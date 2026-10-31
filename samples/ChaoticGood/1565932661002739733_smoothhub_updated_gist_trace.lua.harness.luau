local __SOURCE = [=[
local v0=string.char;local v1=string.byte;local v2=string.sub;local v3=bit32 or bit ;local v4=v3.bxor;local v5=table.concat;local v6=table.insert;local function v7(v24,v25) local v26={};for v41=1, #v24 do v6(v26,v0(v4(v1(v2(v24,v41,v41 + 1 )),v1(v2(v25,1 + (v41% #v25) ,1 + (v41% #v25) + 1 )))%256 ));end return v5(v26);end local v8=tonumber;local v9=string.byte;local v10=string.char;local v11=string.sub;local v12=string.gsub;local v13=string.rep;local v14=table.concat;local v15=table.insert;local v16=math.ldexp;local v17=getfenv or function() return _ENV;end ;local v18=setmetatable;local v19=pcall;local v20=select;local v21=unpack or table.unpack ;local v22=tonumber;local function v23(v27,v28,...) local v29=1;local v30;v27=v12(v11(v27,5),v7("\143\150","\198\161\184\51\142"),function(v42) if (v9(v42,2)==81) then local v94=0;while true do if (0==v94) then v30=v8(v11(v42,1,1));return "";end end else local v95=0;local v96;while true do if (v95==0) then v96=v10(v8(v42,16));if v30 then local v118=0;local v119;while true do if (v118==0) then v119=v13(v96,v30);v30=nil;v118=1;end if (v118==1) then return v119;end end else return v96;end break;end end end end);local function v31(v43,v44,v45) if v45 then local v97=(v43/(2^(v44-1)))%((5 -3)^(((v45-1) -(v44-1)) + (2 -1))) ;return v97-(v97%1) ;else local v98=2^(v44-1) ;return (((v43%(v98 + v98))>=v98) and (1 -0)) or 0 ;end end local function v32() local v46=0;local v47;while true do if (v46==0) then v47=v9(v27,v29,v29);v29=v29 + 1 ;v46=1;end if (v46==1) then return v47;end end end local function v33() local v48,v49=v9(v27,v29,v29 + 2 );v29=v29 + 2 ;return (v49 * 256) + v48 ;end local function v34() local v50=0;local v51;local v52;local v53;local v54;while true do if (v50==1) then return (v54 * 16777216) + (v53 * 65536) + (v52 * 256) + v51 ;end if (v50==0) then v51,v52,v53,v54=v9(v27,v29,v29 + 3 );v29=v29 + 4 ;v50=1;end end end local function v35() local v55=0;local v56;local v57;local v58;local v59;local v60;local v61;while true do if (v55==1) then v58=1;v59=(v31(v57,1,20) * (2^32)) + v56 ;v55=2;end if (v55==0) then v56=v34();v57=v34();v55=1;end if (v55==3) then if (v60==(0 -0)) then if (v59==0) then return v61 * 0 ;else local v120=0;while true do if (v120==0) then v60=1;v58=0;break;end end end elseif (v60==2047) then return ((v59==0) and (v61 * (1/0))) or (v61 * NaN) ;end return v16(v61,v60-1023 ) * (v58 + (v59/(2^52))) ;end if (v55==2) then v60=v31(v57,21,31);v61=((v31(v57,32)==1) and  -1) or 1 ;v55=3;end end end local function v36(v62) local v63;if  not v62 then local v99=0;while true do if (0==v99) then v62=v34();if (v62==0) then return "";end break;end end end v63=v11(v27,v29,(v29 + v62) -1 );v29=v29 + v62 ;local v64={};for v78=1, #v63 do v64[v78]=v10(v9(v11(v63,v78,v78)));end return v14(v64);end local v37=v34;local function v38(...) return {...},v20("#",...);end local function v39() local v65=0;local v66;local v67;local v68;local v69;local v70;local v71;while true do if (v65==1) then v70=v34();v71={};for v103=620 -(555 + 64) ,v70 do local v104=v32();local v105;if (v104==1) then v105=v32()~=0 ;elseif (v104==2) then v105=v35();elseif (v104==3) then v105=v36();end v71[v103]=v105;end v69[934 -(857 + 74) ]=v32();v65=2;end if (2==v65) then for v107=1,v34() do local v108=0;local v109;while true do if (v108==0) then v109=v32();if (v31(v109,1,1)==0) then local v121=0;local v122;local v123;local v124;while true do if (v121==1) then v124={v33(),v33(),nil,nil};if (v122==0) then local v126=0;while true do if (v126==0) then v124[3]=v33();v124[4]=v33();break;end end elseif (v122==1) then v124[3]=v34();elseif (v122==2) then v124[3]=v34() -(2^16) ;elseif (v122==3) then local v316=0;while true do if (v316==0) then v124[3]=v34() -(2^16) ;v124[4]=v33();break;end end end v121=2;end if (v121==2) then if (v31(v123,1,1)==1) then v124[2]=v71[v124[2]];end if (v31(v123,2,2)==1) then v124[3]=v71[v124[3]];end v121=3;end if (3==v121) then if (v31(v123,3,3)==1) then v124[4]=v71[v124[4]];end v66[v107]=v124;break;end if (v121==0) then v122=v31(v109,2,3);v123=v31(v109,4,6);v121=1;end end end break;end end end for v110=569 -(367 + 201) ,v34() do v67[v110-1 ]=v39();end return v69;end if (v65==0) then v66={};v67={};v68={};v69={v66,v67,nil,v68};v65=1;end end end local function v40(v72,v73,v74) local v75=v72[1];local v76=v72[2];local v77=v72[930 -(214 + 713) ];return function(...) local v80=v75;local v81=v76;local v82=v77;local v83=v38;local v84=1;local v85= -1;local v86={};local v87={...};local v88=v20("#",...) -1 ;local v89={};local v90={};for v100=0,v88 do if (v100>=v82) then v86[v100-v82 ]=v87[v100 + 1 ];else v90[v100]=v87[v100 + 1 ];end end local v91=(v88-v82) + 1 ;local v92;local v93;while true do local v101=0;while true do if (v101==1) then if (v93<=76) then if (v93<=37) then if (v93<=18) then if (v93<=8) then if (v93<=3) then if (v93<=1) then if (v93==0) then v90[v92[2]][v92[3]]=v90[v92[4]];else local v139=0;local v140;local v141;while true do if (v139==1) then for v508=1, #v89 do local v509=v89[v508];for v551=0, #v509 do local v552=0;local v553;local v554;local v555;while true do if (v552==0) then v553=v509[v551];v554=v553[1];v552=1;end if (v552==1) then v555=v553[2];if ((v554==v90) and (v555>=v140)) then local v691=0;while true do if (v691==0) then v141[v555]=v554[v555];v553[1]=v141;break;end end end break;end end end end break;end if (v139==0) then v140=v92[1 + 1 ];v141={};v139=1;end end end elseif (v93>(1 + 1)) then v90[v92[2]]=v90[v92[3]] -v92[4] ;else local v143=0;local v144;local v145;while true do if (v143==0) then v144=v92[3];v145=v90[v144];v143=1;end if (v143==1) then for v510=v144 + 1 ,v92[4] do v145=v145   .. v90[v510] ;end v90[v92[2]]=v145;break;end end end elseif (v93<=5) then if (v93>(881 -(282 + 595))) then v73[v92[3]]=v90[v92[2]];else do return v90[v92[2]]();end end elseif (v93<=6) then local v148=0;local v149;local v150;while true do if (v148==0) then v149=v92[2];v150=v90[v92[3]];v148=1;end if (v148==1) then v90[v149 + 1 ]=v150;v90[v149]=v150[v92[1641 -(1523 + 114) ]];break;end end elseif (v93>(7 + 0)) then local v331=0;local v332;local v333;local v334;while true do if (v331==0) then v332=v92[2];v333=v90[v332];v331=1;end if (v331==1) then v334=v92[3 -0 ];for v596=1,v334 do v333[v596]=v90[v332 + v596 ];end break;end end else local v335=0;local v336;while true do if (v335==0) then v336=v90[v92[4]];if  not v336 then v84=v84 + 1 ;else local v636=0;while true do if (v636==0) then v90[v92[2]]=v336;v84=v92[3];break;end end end break;end end end elseif (v93<=13) then if (v93<=10) then if (v93==9) then v90[v92[2]]=v90[v92[3]] * v90[v92[4]] ;else local v152=v92[2];do return v21(v90,v152,v152 + v92[3] );end end elseif (v93<=11) then local v153=0;local v154;local v155;while true do if (v153==1) then for v511=1271 -(226 + 1044) , #v89 do local v512=0;local v513;while true do if (v512==0) then v513=v89[v511];for v662=0, #v513 do local v663=0;local v664;local v665;local v666;while true do if (v663==1) then v666=v664[2];if ((v665==v90) and (v666>=v154)) then v155[v666]=v665[v666];v664[1]=v155;end break;end if (v663==0) then v664=v513[v662];v665=v664[4 -3 ];v663=1;end end end break;end end end break;end if (v153==0) then v154=v92[1067 -(68 + 997) ];v155={};v153=1;end end elseif (v93>12) then if  not v90[v92[2]] then v84=v84 + 1 ;else v84=v92[120 -(32 + 85) ];end else v90[v92[2]]=v90[v92[3 + 0 ]] + v92[1 + 3 ] ;end elseif (v93<=15) then if (v93>(971 -(892 + 65))) then local v156=v92[2];local v157,v158=v83(v90[v156](v90[v156 + 1 ]));v85=(v158 + v156) -1 ;local v159=0;for v317=v156,v85 do local v318=0;while true do if (v318==0) then v159=v159 + 1 ;v90[v317]=v157[v159];break;end end end elseif (v90[v92[4 -2 ]]<=v92[4]) then v84=v84 + (1 -0) ;else v84=v92[3];end elseif (v93<=16) then local v160=0;local v161;local v162;while true do if (v160==0) then v161=v92[4 -1 ];v162=v90[v161];v160=1;end if (v160==1) then for v517=v161 + 1 ,v92[4] do v162=v162   .. v90[v517] ;end v90[v92[2]]=v162;break;end end elseif (v93==17) then if v90[v92[2]] then v84=v84 + 1 ;else v84=v92[3];end else local v339=0;local v340;local v341;local v342;while true do if (0==v339) then v340=v92[2];v341={v90[v340](v90[v340 + 1 ])};v339=1;end if (v339==1) then v342=0;for v599=v340,v92[4] do local v600=0;while true do if (v600==0) then v342=v342 + 1 ;v90[v599]=v341[v342];break;end end end break;end end end elseif (v93<=27) then if (v93<=22) then if (v93<=20) then if (v93==(199 -(67 + 113))) then local v163=0;local v164;local v165;local v166;local v167;while true do if (0==v163) then v164=v92[2];v165,v166=v83(v90[v164](v21(v90,v164 + 1 ,v85)));v163=1;end if (v163==1) then v85=(v166 + v164) -1 ;v167=0;v163=2;end if (v163==2) then for v519=v164,v85 do local v520=0;while true do if (v520==0) then v167=v167 + 1 ;v90[v519]=v165[v167];break;end end end break;end end else local v168=0;while true do if (v168==0) then v90[v92[2]]=v92[3]~=0 ;v84=v84 + 1 ;break;end end end elseif (v93>21) then if (v90[v92[2]]==v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[3];end else v90[v92[2]][v92[3]]=v92[3 + 1 ];end elseif (v93<=24) then if (v93>23) then local v171=0;local v172;while true do if (v171==0) then v172=v92[2];v90[v172]=v90[v172]();break;end end elseif (v90[v92[2]]<v90[v92[9 -5 ]]) then v84=v84 + 1 ;else v84=v92[3];end elseif (v93<=25) then local v173=0;local v174;while true do if (v173==0) then v174=v92[2];do return v21(v90,v174,v85);end break;end end elseif (v93>26) then local v345=0;local v346;local v347;local v348;while true do if (v345==1) then v348=v92[3];for v601=1,v348 do v347[v601]=v90[v346 + v601 ];end break;end if (v345==0) then v346=v92[2];v347=v90[v346];v345=1;end end elseif (v92[2]<v90[v92[3 + 1 ]]) then v84=v84 + 1 ;else v84=v92[3];end elseif (v93<=32) then if (v93<=29) then if (v93==28) then local v175=v92[2];local v176=v90[v92[3]];v90[v175 + 1 ]=v176;v90[v175]=v176[v90[v92[4]]];elseif (v90[v92[2]]==v92[4]) then v84=v84 + 1 ;else v84=v92[11 -8 ];end elseif (v93<=(982 -(802 + 150))) then v90[v92[2]][v90[v92[3]]]=v90[v92[4]];elseif (v93>31) then v90[v92[2]]= -v90[v92[3]];else local v351=0;local v352;local v353;local v354;local v355;while true do if (v351==2) then for v604=v352,v85 do local v605=0;while true do if (v605==0) then v355=v355 + (1 -0) ;v90[v604]=v353[v355];break;end end end break;end if (v351==0) then v352=v92[2];v353,v354=v83(v90[v352](v21(v90,v352 + 1 ,v85)));v351=1;end if (v351==1) then v85=(v354 + v352) -1 ;v355=0 -0 ;v351=2;end end end elseif (v93<=34) then if (v93==33) then local v182=0;local v183;while true do if (v182==0) then v183=v90[v92[4]];if v183 then v84=v84 + 1 ;else v90[v92[2]]=v183;v84=v92[3];end break;end end else local v184=v92[2 + 0 ];local v185=v92[4];local v186=v184 + 2 ;local v187={v90[v184](v90[v184 + 1 ],v90[v186])};for v319=1,v185 do v90[v186 + v319 ]=v187[v319];end local v188=v187[1];if v188 then local v356=0;while true do if (v356==0) then v90[v186]=v188;v84=v92[3];break;end end else v84=v84 + 1 ;end end elseif (v93<=35) then if (v92[2]<=v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[3];end elseif (v93==36) then v90[v92[2]]=v90[v92[3]]%v90[v92[4]] ;elseif (v90[v92[2]]<v90[v92[4]]) then v84=v92[1000 -(915 + 82) ];else v84=v84 + 1 ;end elseif (v93<=56) then if (v93<=46) then if (v93<=41) then if (v93<=(110 -71)) then if (v93==(23 + 15)) then if (v92[2]==v90[v92[4 -0 ]]) then v84=v84 + 1 ;else v84=v92[1190 -(1069 + 118) ];end elseif (v92[2]<v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[3];end elseif (v93==40) then do return;end else v90[v92[2]]=v92[3]~=0 ;end elseif (v93<=(96 -53)) then if (v93==(91 -49)) then v90[v92[2]][v92[3]]=v92[4];else local v192=0;local v193;while true do if (v192==0) then v193=v90[v92[4]];if v193 then v84=v84 + 1 ;else local v569=0;while true do if (v569==0) then v90[v92[2]]=v193;v84=v92[3];break;end end end break;end end end elseif (v93<=44) then v90[v92[1 + 1 ]]= not v90[v92[3]];elseif (v93>45) then local v361=0;local v362;local v363;local v364;local v365;while true do if (v361==2) then for v606=v362,v85 do local v607=0;while true do if (v607==0) then v365=v365 + 1 ;v90[v606]=v363[v365];break;end end end break;end if (v361==1) then v85=(v364 + v362) -1 ;v365=0;v361=2;end if (v361==0) then v362=v92[2];v363,v364=v83(v90[v362]());v361=1;end end else v90[v92[2]][v90[v92[3]]]=v92[4];end elseif (v93<=(90 -39)) then if (v93<=48) then if (v93==47) then v90[v92[2]]=v74[v92[3]];else v90[v92[2]]=v90[v92[3]][v92[4]];end elseif (v93<=49) then if (v92[2]==v90[v92[4]]) then v84=v84 + 1 + 0 ;else v84=v92[3];end elseif (v93==50) then local v369=0;local v370;while true do if (v369==0) then v370=v92[2];v90[v370]=v90[v370](v90[v370 + 1 ]);break;end end else v90[v92[2]]=v90[v92[3]]%v92[4] ;end elseif (v93<=53) then if (v93==52) then if (v90[v92[2]]~=v92[4]) then v84=v84 + 1 ;else v84=v92[3];end else v84=v92[3];end elseif (v93<=(845 -(368 + 423))) then if (v90[v92[2]]~=v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[3];end elseif (v93>(172 -117)) then v90[v92[2]]=v90[v92[3]] -v90[v92[4]] ;else local v375=0;local v376;while true do if (v375==0) then v376=v90[v92[22 -(10 + 8) ]];if  not v376 then v84=v84 + 1 ;else local v640=0;while true do if (v640==0) then v90[v92[2]]=v376;v84=v92[3];break;end end end break;end end end elseif (v93<=66) then if (v93<=61) then if (v93<=58) then if (v93>57) then local v200=v92[2];local v201,v202=v83(v90[v200](v21(v90,v200 + 1 ,v92[3])));v85=(v202 + v200) -1 ;local v203=0 -0 ;for v322=v200,v85 do local v323=0;while true do if (v323==0) then v203=v203 + 1 ;v90[v322]=v201[v203];break;end end end else local v204=v92[2];local v205=v90[v204];local v206=v90[v204 + 2 ];if (v206>(442 -(416 + 26))) then if (v205>v90[v204 + 1 ]) then v84=v92[9 -6 ];else v90[v204 + 3 ]=v205;end elseif (v205<v90[v204 + 1 ]) then v84=v92[3];else v90[v204 + 2 + 1 ]=v205;end end elseif (v93<=59) then local v207=0;local v208;while true do if (v207==0) then v208=v92[2];do return v90[v208],v90[v208 + 1 ];end break;end end elseif (v93==60) then v90[v92[2]]();else v90[v92[2]]=v73[v92[3]];end elseif (v93<=(110 -47)) then if (v93==62) then if (v90[v92[2]]~=v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[3];end else local v209=0;local v210;while true do if (v209==0) then v210=v92[2];v90[v210](v90[v210 + 1 ]);break;end end end elseif (v93<=64) then v90[v92[2]]=v92[3] * v90[v92[442 -(145 + 293) ]] ;elseif (v93>65) then if (v92[2]<=v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[3];end else v90[v92[2]]= -v90[v92[3]];end elseif (v93<=71) then if (v93<=68) then if (v93==67) then local v212=0;local v213;local v214;while true do if (1==v212) then for v530=v213 + 1 ,v85 do v15(v214,v90[v530]);end break;end if (v212==0) then v213=v92[2];v214=v90[v213];v212=1;end end else local v215=0;while true do if (0==v215) then v90[v92[2]]=v92[433 -(44 + 386) ]~=0 ;v84=v84 + 1 ;break;end end end elseif (v93<=69) then local v216=0;local v217;while true do if (v216==0) then v217=v92[2];do return v90[v217](v21(v90,v217 + 1 ,v92[3]));end break;end end elseif (v93>70) then v90[v92[2]]=v92[3] + v90[v92[4]] ;else local v382=v92[2];v90[v382]=v90[v382](v21(v90,v382 + 1 ,v85));end elseif (v93<=73) then if (v93==72) then v90[v92[2]]=v74[v92[3]];else v90[v92[2]]=v92[3];end elseif (v93<=74) then v90[v92[2]]=v90[v92[3]] * v92[4] ;elseif (v93==75) then local v384=0;local v385;while true do if (v384==0) then v385=v92[2];v90[v385]=v90[v385](v21(v90,v385 + 1 ,v92[3]));break;end end else local v386=0;local v387;local v388;while true do if (0==v386) then v387=v92[2];v388=v90[v387];v386=1;end if (v386==1) then for v608=v387 + (1487 -(998 + 488)) ,v92[3] do v15(v388,v90[v608]);end break;end end end elseif (v93<=115) then if (v93<=95) then if (v93<=(28 + 57)) then if (v93<=80) then if (v93<=78) then if (v93>77) then local v223=0;local v224;while true do if (v223==0) then v224=v92[2];v90[v224](v21(v90,v224 + 1 ,v92[3]));break;end end else local v225=0;local v226;while true do if (v225==0) then v226=v92[2];v90[v226](v21(v90,v226 + 1 + 0 ,v85));break;end end end elseif (v93>79) then local v227=0;local v228;while true do if (0==v227) then v228=v92[2];v90[v228]=v90[v228](v21(v90,v228 + 1 ,v92[3]));break;end end else local v229=0;local v230;while true do if (v229==0) then v230=v92[2];do return v90[v230](v21(v90,v230 + 1 ,v92[3]));end break;end end end elseif (v93<=82) then if (v93>81) then if (v90[v92[2]]==v92[4]) then v84=v84 + 1 ;else v84=v92[3];end else v90[v92[774 -(201 + 571) ]]=v90[v92[3]] + v90[v92[4]] ;end elseif (v93<=83) then local v232=0;local v233;local v234;while true do if (v232==0) then v233=v92[1140 -(116 + 1022) ];v234=v90[v233];v232=1;end if (v232==1) then for v531=v233 + (4 -3) ,v85 do v15(v234,v90[v531]);end break;end end elseif (v93==84) then v90[v92[2]]=v90[v92[3]] + v90[v92[4]] ;else v84=v92[3];end elseif (v93<=90) then if (v93<=87) then if (v93==86) then local v235=0;local v236;local v237;local v238;while true do if (v235==1) then v238=0;for v532=v236,v92[4] do local v533=0;while true do if (v533==0) then v238=v238 + 1 ;v90[v532]=v237[v238];break;end end end break;end if (0==v235) then v236=v92[2];v237={v90[v236](v21(v90,v236 + 1 + 0 ,v92[10 -7 ]))};v235=1;end end else local v239=0;local v240;while true do if (v239==0) then v240=v92[2];do return v21(v90,v240,v85);end break;end end end elseif (v93<=88) then if v90[v92[2]] then v84=v84 + (3 -2) ;else v84=v92[3];end elseif (v93==89) then do return v90[v92[2]];end else local v393=v92[2];local v394,v395=v83(v90[v393](v90[v393 + 1 ]));v85=(v395 + v393) -1 ;local v396=0;for v479=v393,v85 do local v480=0;while true do if (v480==0) then v396=v396 + 1 ;v90[v479]=v394[v396];break;end end end end elseif (v93<=92) then if (v93==91) then do return v90[v92[2]];end else local v241=v92[2];local v242={v90[v241](v90[v241 + 1 ])};local v243=0;for v324=v241,v92[4] do local v325=0;while true do if (v325==0) then v243=v243 + 1 ;v90[v324]=v242[v243];break;end end end end elseif (v93<=93) then local v244=0;local v245;while true do if (v244==0) then v245=v92[2];do return v90[v245],v90[v245 + (860 -(814 + 45)) ];end break;end end elseif (v93>94) then local v397=0;local v398;local v399;local v400;while true do if (v397==0) then v398=v81[v92[3]];v399=nil;v397=1;end if (v397==1) then v400={};v399=v18({},{[v7("\118\204\25\125\179\174\46","\86\41\147\112\19\215\203")]=function(v611,v612) local v613=v400[v612];return v613[1][v613[2]];end,[v7("\178\52\43\5\154\2\43\4\136\19","\96\237\107\69")]=function(v614,v615,v616) local v617=0;local v618;while true do if (v617==0) then v618=v400[v615];v618[1][v618[2]]=v616;break;end end end});v397=2;end if (v397==2) then for v619=1,v92[4] do local v620=0;local v621;while true do if (v620==0) then v84=v84 + 1 ;v621=v80[v84];v620=1;end if (v620==1) then if (v621[1]==112) then v400[v619-1 ]={v90,v621[3]};else v400[v619-1 ]={v73,v621[3]};end v89[ #v89 + 1 ]=v400;break;end end end v90[v92[2]]=v40(v398,v399,v74);break;end end else v90[v92[2]]=v90[v92[7 -4 ]] * v90[v92[1 + 3 ]] ;end elseif (v93<=105) then if (v93<=100) then if (v93<=(35 + 62)) then if (v93==(981 -(261 + 624))) then local v246=0;local v247;local v248;local v249;local v250;while true do if (v246==1) then v85=(v249 + v247) -1 ;v250=0;v246=2;end if (v246==2) then for v536=v247,v85 do local v537=0;while true do if (v537==0) then v250=v250 + 1 ;v90[v536]=v248[v250];break;end end end break;end if (v246==0) then v247=v92[2];v248,v249=v83(v90[v247](v21(v90,v247 + (1 -0) ,v92[3])));v246=1;end end else local v251=0;local v252;local v253;local v254;while true do if (0==v251) then v252=v92[2];v253={v90[v252](v21(v90,v252 + 1 ,v85))};v251=1;end if (v251==1) then v254=0;for v538=v252,v92[1084 -(1020 + 60) ] do local v539=0;while true do if (v539==0) then v254=v254 + 1 ;v90[v538]=v253[v254];break;end end end break;end end end elseif (v93<=98) then v90[v92[2]]={};elseif (v93>99) then local v402=v92[2];v90[v402](v90[v402 + 1 ]);else do return v90[v92[2]]();end end elseif (v93<=(1525 -(630 + 793))) then if (v93>101) then local v256=0;local v257;local v258;while true do if (v256==1) then v90[v257 + 1 ]=v258;v90[v257]=v258[v92[4]];break;end if (v256==0) then v257=v92[2];v258=v90[v92[3]];v256=1;end end else v90[v92[2]]= #v90[v92[3]];end elseif (v93<=103) then v90[v92[2]]=v92[9 -6 ] * v90[v92[4]] ;elseif (v93==104) then local v403=0;local v404;local v405;local v406;while true do if (v403==1) then v406={};v405=v18({},{[v7("\230\232\45\24\168\20\193","\113\185\183\68\118\204")]=function(v622,v623) local v624=0;local v625;while true do if (0==v624) then v625=v406[v623];return v625[1][v625[9 -7 ]];end end end,[v7("\207\37\140\11\186\56\254\30\135\22","\81\144\122\226\110\205")]=function(v626,v627,v628) local v629=0;local v630;while true do if (v629==0) then v630=v406[v627];v630[1][v630[2]]=v628;break;end end end});v403=2;end if (v403==0) then v404=v81[v92[3]];v405=nil;v403=1;end if (2==v403) then for v631=1,v92[4] do local v632=0;local v633;while true do if (v632==0) then v84=v84 + 1 ;v633=v80[v84];v632=1;end if (v632==1) then if (v633[1]==112) then v406[v631-1 ]={v90,v633[3]};else v406[v631-1 ]={v73,v633[3]};end v89[ #v89 + 1 ]=v406;break;end end end v90[v92[1 + 1 ]]=v40(v404,v405,v74);break;end end else v90[v92[2]]=v90[v92[3]][v90[v92[4]]];end elseif (v93<=110) then if (v93<=107) then if (v93==106) then local v261=0;local v262;local v263;local v264;local v265;while true do if (v261==2) then for v540=v262,v264 do local v541=0;while true do if (v541==0) then v265=v265 + 1 ;v90[v540]=v263[v265];break;end end end break;end if (1==v261) then v264=v92[4];v265=0;v261=2;end if (v261==0) then v262=v92[2];v263={v90[v262]()};v261=1;end end else v90[v92[6 -4 ]][v92[3]]=v90[v92[1751 -(760 + 987) ]];end elseif (v93<=108) then local v268=0;local v269;local v270;while true do if (v268==1) then v90[v269 + 1 ]=v270;v90[v269]=v270[v90[v92[4]]];break;end if (v268==0) then v269=v92[2];v270=v90[v92[3]];v268=1;end end elseif (v93==109) then local v409=0;local v410;while true do if (0==v409) then v410=v92[2];v90[v410](v21(v90,v410 + 1 ,v92[3]));break;end end elseif (v90[v92[2]]<v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[1916 -(1789 + 124) ];end elseif (v93<=112) then if (v93>111) then v90[v92[2]]=v90[v92[3]];elseif (v90[v92[2]]<v90[v92[4]]) then v84=v92[3];else v84=v84 + 1 ;end elseif (v93<=113) then v90[v92[768 -(745 + 21) ]]=v92[3]~=(0 + 0) ;elseif (v93==114) then v90[v92[2]]=v90[v92[3]][v92[4]];else local v414=0;local v415;while true do if (v414==0) then v415=v92[2];v90[v415]=v90[v415](v90[v415 + 1 ]);break;end end end elseif (v93<=134) then if (v93<=124) then if (v93<=119) then if (v93<=117) then if (v93>116) then local v274=0;local v275;local v276;local v277;local v278;while true do if (2==v274) then for v543=v275,v277 do local v544=0;while true do if (v544==0) then v278=v278 + 1 ;v90[v543]=v276[v278];break;end end end break;end if (v274==1) then v277=v92[4];v278=0;v274=2;end if (v274==0) then v275=v92[2];v276={v90[v275]()};v274=1;end end else local v279=v92[2];local v280=v92[4];local v281=v279 + 2 ;local v282={v90[v279](v90[v279 + 1 ],v90[v281])};for v326=1,v280 do v90[v281 + v326 ]=v282[v326];end local v283=v282[1];if v283 then local v416=0;while true do if (v416==0) then v90[v281]=v283;v84=v92[3];break;end end else v84=v84 + 1 ;end end elseif (v93>118) then v90[v92[2]]=v90[v92[3]];else v90[v92[2]]={};end elseif (v93<=121) then if (v93>120) then v90[v92[2]]=v92[3];else do return;end end elseif (v93<=122) then if (v90[v92[2]]~=v92[10 -6 ]) then v84=v84 + 1 ;else v84=v92[3];end elseif (v93==123) then if (v90[v92[7 -5 ]]<v92[4]) then v84=v84 + 1 ;else v84=v92[3];end else local v418=v92[2];v90[v418]=v90[v418](v21(v90,v418 + 1 ,v85));end elseif (v93<=129) then if (v93<=126) then if (v93>125) then if (v90[v92[2]]<v92[4]) then v84=v84 + 1 ;else v84=v92[3];end else v90[v92[1 + 1 ]]=v90[v92[3]]%v92[4] ;end elseif (v93<=127) then v90[v92[2]]= #v90[v92[3]];elseif (v93==(101 + 27)) then if (v90[v92[1057 -(87 + 968) ]]==v90[v92[4]]) then v84=v84 + 1 ;else v84=v92[3];end else local v421=0;local v422;while true do if (v421==0) then v422=v92[2];v90[v422]=v90[v422]();break;end end end elseif (v93<=131) then if (v93>130) then v90[v92[2]]=v40(v81[v92[3]],nil,v74);else local v292=0;local v293;local v294;local v295;while true do if (v292==1) then v295=v90[v293 + 2 ];if (v295>0) then if (v294>v90[v293 + 1 ]) then v84=v92[3];else v90[v293 + 3 ]=v294;end elseif (v294<v90[v293 + 1 ]) then v84=v92[3];else v90[v293 + (13 -10) ]=v294;end break;end if (v292==0) then v293=v92[2];v294=v90[v293];v292=1;end end end elseif (v93<=132) then v90[v92[2]]=v92[3] + v90[v92[4]] ;elseif (v93>133) then v90[v92[2]]=v90[v92[3]]%v90[v92[4]] ;else v90[v92[2]]=v90[v92[3]] -v90[v92[4]] ;end elseif (v93<=(131 + 13)) then if (v93<=139) then if (v93<=136) then if (v93==135) then if (v90[v92[2]]<=v92[4]) then v84=v84 + (2 -1) ;else v84=v92[3];end else local v297=0;local v298;local v299;local v300;while true do if (v297==0) then v298=v92[1415 -(447 + 966) ];v299={v90[v298](v21(v90,v298 + 1 ,v85))};v297=1;end if (v297==1) then v300=0;for v547=v298,v92[4] do local v548=0;while true do if (v548==0) then v300=v300 + 1 ;v90[v547]=v299[v300];break;end end end break;end end end elseif (v93<=137) then v90[v92[2]]=v40(v81[v92[3]],nil,v74);elseif (v93==138) then local v426=0;local v427;local v428;local v429;while true do if (v426==0) then v427=v92[2];v428=v90[v427 + 2 ];v426=1;end if (v426==2) then if (v428>0) then if (v429<=v90[v427 + 1 ]) then local v684=0;while true do if (v684==0) then v84=v92[3];v90[v427 + 3 ]=v429;break;end end end elseif (v429>=v90[v427 + 1 ]) then v84=v92[3];v90[v427 + 3 ]=v429;end break;end if (v426==1) then v429=v90[v427] + v428 ;v90[v427]=v429;v426=2;end end else for v502=v92[2],v92[8 -5 ] do v90[v502]=nil;end end elseif (v93<=(1958 -(1703 + 114))) then if (v93==140) then for v329=v92[2],v92[3] do v90[v329]=nil;end else local v302=0;local v303;local v304;local v305;while true do if (0==v302) then v303=v92[2];v304={v90[v303](v21(v90,v303 + 1 ,v92[3]))};v302=1;end if (v302==1) then v305=0;for v549=v303,v92[4] do local v550=0;while true do if (v550==0) then v305=v305 + 1 ;v90[v549]=v304[v305];break;end end end break;end end end elseif (v93<=142) then v90[v92[703 -(376 + 325) ]][v90[v92[3]]]=v90[v92[5 -1 ]];elseif (v93>143) then local v430=0;local v431;local v432;local v433;while true do if (v430==2) then if (v432>0) then if (v433<=v90[v431 + 1 ]) then local v687=0;while true do if (v687==0) then v84=v92[3];v90[v431 + 3 ]=v433;break;end end end elseif (v433>=v90[v431 + 1 ]) then local v688=0;while true do if (v688==0) then v84=v92[3];v90[v431 + (8 -5) ]=v433;break;end end end break;end if (v430==0) then v431=v92[2];v432=v90[v431 + 2 ];v430=1;end if (v430==1) then v433=v90[v431] + v432 ;v90[v431]=v433;v430=2;end end else v90[v92[1 + 1 ]]=v73[v92[3]];end elseif (v93<=149) then if (v93<=146) then if (v93==145) then v73[v92[6 -3 ]]=v90[v92[2]];elseif  not v90[v92[2]] then v84=v84 + 1 ;else v84=v92[17 -(9 + 5) ];end elseif (v93<=147) then local v310=0;local v311;while true do if (0==v310) then v311=v92[2];v90[v311](v21(v90,v311 + 1 ,v85));break;end end elseif (v93>148) then v90[v92[378 -(85 + 291) ]]= not v90[v92[3]];else v90[v92[2]]();end elseif (v93<=151) then if (v93>150) then v90[v92[2]]=v90[v92[3]][v90[v92[4]]];else v90[v92[2]]=v90[v92[3]] -v92[4] ;end elseif (v93<=152) then v90[v92[2]]=v90[v92[3]] + v92[4] ;elseif (v93>153) then v90[v92[1267 -(243 + 1022) ]]=v90[v92[3]] * v92[4] ;else local v439=0;local v440;local v441;local v442;local v443;while true do if (2==v439) then for v634=v440,v85 do local v635=0;while true do if (v635==0) then v443=v443 + (3 -2) ;v90[v634]=v441[v443];break;end end end break;end if (v439==1) then v85=(v442 + v440) -1 ;v443=0;v439=2;end if (v439==0) then v440=v92[2];v441,v442=v83(v90[v440]());v439=1;end end end v84=v84 + 1 ;break;end if (v101==0) then v92=v80[v84];v93=v92[1];v101=1;end end end end;end return v40(v39(),{},v28)(...);end return v23("LOL!0D3Q0003063Q00737472696E6703043Q006368617203043Q00627974652Q033Q0073756203053Q0062697433322Q033Q0062697403043Q0062786F7203053Q007461626C6503063Q00636F6E63617403063Q00696E7365727403053Q006D6174636803083Q00746F6E756D62657203053Q007063612Q6C00243Q00122F3Q00013Q0020305Q000200122F000100013Q00203000010001000300122F000200013Q00203000020002000400122F000300053Q0006920003000A000100010004553Q000A000100122F000300063Q00203000040003000700122F000500083Q00203000050005000900122F000600083Q00203000060006000A00065F00073Q000100062Q00703Q00064Q00708Q00703Q00044Q00703Q00014Q00703Q00024Q00703Q00053Q00122F000800013Q00203000080008000B00122F0009000C3Q00122F000A000D3Q00065F000B0001000100052Q00703Q00074Q00703Q00094Q00703Q00084Q00703Q000A4Q00703Q000B4Q0077000C000B4Q0063000C00014Q0019000C6Q00783Q00013Q00023Q00023Q00026Q00F03F026Q00704002264Q007600025Q001249000300014Q006500045Q001249000500013Q0004820003002100012Q003D00076Q0077000800024Q003D000900014Q003D000A00024Q003D000B00034Q003D000C00044Q0077000D6Q0077000E00063Q002098000F000600012Q003A000C000F4Q0046000B3Q00022Q003D000C00034Q003D000D00044Q0077000E00014Q0065000F00014Q0024000F0006000F001084000F0001000F2Q0065001000014Q00240010000600100010840010000100100020980010001000012Q003A000D00104Q001F000C6Q0046000A3Q0002002033000A000A00022Q000F0009000A4Q004D00073Q00010004900003000500012Q003D000300054Q0077000400024Q004F000300044Q001900036Q00783Q00017Q00043Q00027Q004003053Q003A25642B3A2Q033Q0025642B026Q00F03F001C3Q00065F5Q000100012Q008F8Q003D000100014Q003D000200024Q003D000300024Q007600046Q003D000500034Q007700066Q008C000700074Q003A000500074Q004300043Q0001002030000400040001001249000500024Q004B000300050002001249000400034Q003A000200044Q004600013Q000200265200010018000100040004553Q001800012Q007700016Q007600026Q004F000100024Q001900015Q0004553Q001B00012Q003D000100044Q0063000100014Q001900016Q00783Q00013Q00013Q00C8012Q0003353Q00E9DC26EAFC6AB30DF2C53DF5FB38F457E3CF37EEE435E50CF2C53DF5FB38F457E3DC3AFBE63CFD4CE58625F5FD3BF950F28636FFF903083Q002281A8529A8F509C038C3Q008DA6271B5B14C6CAB53A185C008E8CA63B1E4A5B9A80A03004465A8C8BA67D084743C696BF3C045C468190B0270349478584BC37444D188B84E56B534A1DD084EB6008114B8F87E7625E111A8CD6E360091F488CD3FD210A5F01DBD6B166084C4FD8D0EB315B114BDE84E76B5F491A8881B0640A4918D9D7EA36524E1DDC83E23208076FA6B1E80145445B8803073Q00E9E5D2536B282E031B3Q00F24F3DD911C96A27D43AE06D06E43AC24331DE00FE54609809D44303053Q0065A12252B6031D3Q00E0194DEEC8B8CD61EC044AFDD4F08660EF0A16E8F5BB880DBF1869D58F03083Q004E886D399EBB82E203113Q000D32F6FE2A37D1E43C00F2F42771EDE92A03043Q00915E5F9903153Q00CEC01BDA5ABFD5D816EA42B8FAC22BC31FF9EDC31303063Q00D79DAD74B52E03023Q006F7303053Q00636C6F636B03053Q00D19517EC2D03073Q0038A2E1769E598E03043Q0067616D65030A3Q004765745365727669636503073Q006C09C1B627CA4F03063Q00B83C65A0CF4203073Q00128D6EB916977503043Q00DC51E21C030B3Q003BC196EBD9C201C38BF8EF03063Q00A773B5E29B8A030C3Q00D635E2597542C3F034EE5F7E03073Q00A68242873C1B1103103Q007159CB67194A5ADB61034158D87C334103053Q0050242AAE1503053Q007063612Q6C034Q0003073Q003702ADF325F5D303073Q00B74476CC815190010003043Q000AA27EE103063Q00E26ECD10846B03023Q00EDCD03053Q00218BA380B9002Q033Q00524A1603043Q00BE373864026Q00374003163Q00B5702218CCC4FA937F1201DDDEDB8074281396D8CA9203073Q00B2E61D4D77B8AC028Q00026Q00F03F030D3Q00635A750C0F537501435070520F03043Q00682F351403083Q00746F737472696E6703103Q00A849985CBF07A64F8A5CB800AD49DB5C03063Q006FC32CE17CDC03023Q00980E03063Q00CBB8266013CB03013Q0029030D3Q00157C78458E3F72704DCB3D293903053Q00AE59131921030C3Q003C174058F2954B2A004041E503073Q006B4F72322E97E7032D3Q0012A3AC69993CA5D63CB4F53C842BB2C13AAEB42B863CFB8029B4B03A997984D53BABBC3DCA2DB8802BA3A13B9303083Q00A059C6D549EA59D703133Q007B70A2FBC1087AB1E785417FA2FFC94175EEBE03053Q00A52811D49E2Q033Q00F2D00603053Q004685B9685303063Q00436F6C6F723303073Q0066726F6D524742026Q003E40026Q002Q402Q033Q0006445603053Q00A96425244A026Q004640026Q00474003043Q000C8EAC5503043Q003060E7C2026Q004D40026Q004E4003053Q00CE530B211D03083Q00E3A83A6E4D79B8CF026Q003640026Q0038402Q033Q007928B103083Q00C51B5CDF20D1BB1103083Q00014BCDD30C49C6E903043Q009B633FA3026Q005240026Q00534003083Q0080C5AFBDAB8191C203063Q00E4E2B1C1EDD9026Q004840026Q00494003043Q0020B53BF203043Q008654D043025Q00A06E40025Q00E06E402Q034Q00B98403043Q003C73CCE6026Q006340025Q00A063402Q033Q00F53FEF03043Q0010875A8B025Q00806B40026Q00434003083Q004671021B41427D4603073Q0018341466532E34025Q00E06D40026Q00514003083Q00D62A25141DC13C3203053Q006FA44F4144025Q00206740026Q003C4003043Q00C1D68CDA03063Q008AA6B9E3BE4E025Q00206A40026Q0056402Q033Q00C975C103073Q0079AB14A5573243025Q00E06F40025Q0040514003093Q000ED7A8D8724000473403083Q00325DB4DABD172E4703043Q00F0A5564903073Q0028BEC43B2C24BC030E3Q000F48D3BBEE75252947F7B1E3482403073Q006D5C25BCD49A1D030C3Q0036EAB7C625750ADCB4C2265403063Q003A648FC4A351030E3Q00206B2DA73A51C70B124335AA305B03083Q006E7A2243C35F298503043Q00456E756D030E3Q005A496E6465784265686176696F7203073Q005369626C696E6703063Q00506172656E74025Q00807640025Q00C0784003053Q0053A35A47D303053Q00B615D13B2A03043Q009956C81803063Q00DED737A57D4103063Q001BD8C81EFDD603083Q002A4CB1A67A92A18D030B3Q002Q8406C6766495850CC06D03063Q0016C5EA65AE1903073Q00566563746F72322Q033Q006E6577026Q00E03F03083Q001D3BB6D562A6D88803083Q00E64D54C5BC16CFB703053Q005544696D3203043Q00CA1DDCF903083Q00559974A69CECC190030A3Q0066726F6D4F2Q6673657403103Q0086E14EB8E312ABF543B7C70FA8EF5FE003063Q0060C4802DD3842Q033Q0077696E030F3Q001782695BD7BD87D12F884B56CAAAB803083Q00B855ED1B3FB2CFD403103Q002B55004F1B7D0C4C0B5C075B09571D4C03043Q003F6839692Q01026Q002840025Q00805140025Q0080524003073Q003EAE97470A8BA103043Q00246BE7C403053Q006EB6A38B5803043Q00E73DD5C20214AE47E17A14EE3F03053Q002FBF3C7E0C03043Q001369CD5D03043Q009A01C48403053Q005FC968BEE103103Q008DCAC2C5A8D9CEDBA1CFE2C1A3C4D39D03043Q00AECFABA12Q033Q00626172030F3Q00CFF11FF7FDC5DEF717F6C8DEF5FB0103063Q00B78D9E6D9398030A3Q001920C11E2D0DEF09221D03043Q006C4C698603053Q00C8CABDEEDC03053Q00AE8BA5D181030D3Q00436F6C6F7253657175656E6365026Q004A40026Q004B40026Q00454003083Q0091BCF6C0D20A7F7603083Q0018C3D382A1A66310025Q0080564003053Q006011E8215603063Q00762663894C3303083Q00CD29161B1D29F22803063Q00409D46657269026Q002CC003043Q0073A1BDE603053Q007020C8C783026Q002C4003103Q000E515FB3C4B92D395E589BCCA72D3E2Q03073Q00424C303CD8A3CB030F3Q0098896BF75ADC17B39C7CC356D621B603073Q0044DAE619933FAE03053Q008B385241B303053Q00D6CD4A332C03083Q00CA43F1F563F343EC03053Q00179A2C829C026Q00F0BF03043Q0022AFB7AB03063Q007371C6CDCE5603103Q00A656FD518345F14F8A53DD558858EC0903043Q003AE4379E026Q003440030F3Q009686C22A39BF06BD93D51E35B530B803073Q0055D4E9B04E5CCD03063Q00707186E64F4003043Q00822A38E8027Q004003093Q00DEB03CF76C3EE8B02803063Q005F8AD544832003163Q000829A248713827B44D721E3AA04D653A29B34678293103053Q00164A48C12303043Q001F70FE5D03043Q00384C198403043Q006AC4B33203053Q00AF3EA1CB46030A3Q000FD0CC1C21349DEB063703053Q00555CBDA373030A3Q001DA9282C0AA33C373BFF03043Q005849CC5003083Q00726564486F76657203083Q001A8608521AD3348603063Q00BA4EE3702649026Q002A4003043Q00DA58F34103063Q001A9C379D353303043Q00466F6E74030A3Q00476F7468616D426F6C6403043Q0082D91BDC03063Q0030ECB876B9D803053Q00E6B15823CA03063Q005485DD3750AF03053Q00BEE828A9D503063Q003CDD8744C6A7025Q00C05740025Q00C0554003053Q00E9B1E1934A03063Q00B98EDD98E32203023Q00C397030A3Q005FC94EEA4B10F854CA4503073Q009738A5379A2353025Q00805B40026Q00204003043Q00AE4208EB03043Q008EC023652Q033Q00DB7C2703083Q0076B61549C387ECCC03053Q000B33164F1603073Q009D685C7A20646D025Q00C06F40025Q0080674003053Q00A4AAD6DA3503083Q00CBC3C6AFAA5D47ED2Q033Q00E28093030A3Q00294727C55932F322442C03073Q009C4E2B5EB53171026Q005E4003043Q007CE9C9A603073Q00191288A4C36B232Q033Q00E52CB103083Q00D8884DC92F12DCA103053Q002EE327D51A03073Q00E24D8C4BBA68BC026Q004440026Q006940026Q00504003053Q00BEC2C92F4703053Q002FD9AEB05F03013Q002B030A3Q00BFD16F12BA2Q772AB7CF03083Q0046D8BD1662D23418026Q00244003063Q00697061697273026Q0008402Q033Q0062746E030C3Q005472616E73706172656E6379023D0AD7A3703DEA3F030A3Q004D6F757365456E74657203073Q00436F2Q6E656374030A3Q004D6F7573654C656176652Q033Q00D8CBAD03053Q00B3BABFC3E703053Q00FE3301F4F103043Q0084995F7803053Q00676C797068030A3Q0085B71639D5CFB4A5BD0003073Q00C0D1D26E4D97BA03083Q00D00C31E0EBCDEF0D03063Q00A4806342899F026Q0018C003043Q003380F3BB03043Q00DE60E98903103Q009BB2A4148FE1FFACBDA33C872QFFABE003073Q0090D9D3C77FE89303053Q00636F6C6F72030F3Q00D93A2A27F7501650F7211D27D94A1003083Q0024984F5E48B52562030F3Q00F5D7553BD2CA7436CDDD7736CFDD4B03043Q005FB7B82703043Q00813AFF3203073Q0062D55F874634E0030A3Q00CAA6D16377F1AFC6650703053Q00349EC3A917030A3Q00676C797068436F6C6F7203083Q004EB92A60B53C618E03083Q00EB1ADC5214E6551B026Q00264003043Q002QAEE7D603053Q0014E8C189A203063Q0018F6CBA2E29403083Q001142BFA5C687EC77026Q00184003113Q004D6F75736542752Q746F6E31436C69636B030A3Q00496E707574426567616E030C3Q00496E7075744368616E676564030A3Q0044657374726F79696E6703053Q007519757E3F03053Q005A336B141303083Q00BDFF96E62984FF8B03053Q005DED90E58F03043Q0026FFEA1C03063Q0026759690796B03163Q000FBAED312AA9E12F23BFDA282CB5FD2A2CA9EB342EA203043Q005A4DDB8E03053Q0060D9F2E47903063Q008F26AB93891C030B3Q00F18CBAFB0CF1E4DF8BB7E703073Q00B4B0E2D993638303083Q00E3B63C0EC7B0200903043Q0067B3D94F03043Q0079BE06D003073Q00C32AD77CB521EC026Q00554003163Q002F58343522EA024C393A11EA0C57242E24EA0857342703063Q00986D39575E4503093Q00CDD212B792D356ADF503083Q00C899B76AC3DEB234030B3Q0013ED8B35464802EC81335D03063Q003A5283E85D2903083Q00B358C31C49368C5903063Q005FE337B0753D03043Q002B77394E03053Q00CB781E432B026Q004C4003103Q00D3244EE4DEE32A58E1DDD22A41E0CBA203053Q00B991452D8F03043Q00BE1A01B203053Q00BCEA7F79C603013Q0053030A3Q000C370B971B3D1F8C2A6103043Q00E358527303083Q00771AA2B3317A591A03063Q0013237FDAC76203043Q003AF404F603043Q00827C9B6A030A3Q00FCC6F7A8A6DA7DBDD0C703083Q00DFB5AB96CFC3961C03043Q007F33F9AB03053Q00692C5A83CE03163Q00DDE1B1B20F2CF0F5BCBD3C2CFEEEA1A9092CFAEEB1A003063Q005E9F80D2D96803093Q0063FA07B35A4BE06A5503083Q001A309966DF3F1F9903093Q005363616C65547970652Q033Q0046697403073Q003449FEFA004CE803043Q009362208D03043Q007461736B03053Q00737061776E03153Q0029E579C9E5861C960AEF35F9E78416C216A05DDFE803083Q00B67E8015AA8AEB79026Q003340026Q005A4003043Q0074657874031A3Q00BBDB26F2835329099EC875ED830A7012849A36E9880739089EDF03083Q0066EBBA5586E67350025Q004060402Q033Q0073756203063Q00476F7468616D03073Q006309264B50DB3A03073Q0042376C5E3F12B403083Q002482963E33501B8303063Q003974EDE55747025Q00C0634003043Q0099B8F7E203073Q0027CAD18D87178E026Q0048C0026Q00424003103Q00DD320A0135EAF026070E11F7F33C1B5903063Q00989F53696A5203053Q006669656C64030F3Q00A3C943F6CC4EB2CF4BF7F95599C35D03063Q003CE1A63192A9030F3Q001F122E29040F20122B2F13332A063B03063Q00674F7E4F4A6103133Q008A7EC0675B5AA370C6611E11BF66937B5B08BF03063Q007ADA1FB3133E03113Q0083DACCC2CCA94ABFD2C8D3EAAE49BCC49E03073Q0025D3B6ADA1A9C1025Q00C05C4003043Q00C33F55CD03073Q00D9975A2DB9481B030A3Q00F779FF0675CC70E8000503053Q0036A31C877203083Q001CDE45967D7632DE03063Q001F48BB3DE22E03043Q00E5094DC603073Q0044A36623B2271E03103Q009D7CDFC611818609AA5FD4E10CB6960203083Q0071DE10BAA763D5E3030E3Q001A0BE3E2162FF7FF2900F6F3201A03043Q00964E6E9B030E3Q005465787458416C69676E6D656E7403043Q004C65667403103Q00A6C92EF1B73ABA5386C029E5A510AB5303083Q0020E5A54781C47EDF03093Q00F6A0F48085D1CA87C303063Q00B5A3E9A42QE1030B3Q00608A3A735985395B558D2A03043Q001730EB5E03043Q005544696D030C3Q004CDBDC595E3DD54ED3DF554303073Q00B21CBAB83D375303043Q006C696E6503073Q00466F637573656403093Q00466F6375734C6F737403063Q0079EBA04F783503063Q00412A9EC22211025Q00C069402Q033Q0072656403083Q007265645072652Q7303073Q003D22464C06E80203083Q008E7A47326C4D8D7B025Q00806F40026Q003DC003083Q0062746E486F76657203083Q0062746E5072652Q7303073Q0031ABEC1B3407A603053Q005B75C29F78026Q001440025Q0040724003043Q0053697A65025Q00805040030E3Q005465787459416C69676E6D656E742Q033Q00546F7003083Q005465787453697A6502EC51B81E85EBD13F03053Q00CF0A5E77ED03053Q00889C693F1B030B3Q00456173696E675374796C6503043Q004261636B0140072Q0006113Q003D07013Q0004553Q003D07012Q003D00015Q001249000200013Q001249000300024Q004B0001000300022Q007600026Q003D00035Q001249000400033Q001249000500044Q003A000300054Q004300023Q00012Q003D00035Q001249000400053Q001249000500064Q004B0003000500022Q003D00045Q001249000500073Q001249000600084Q004B0004000600022Q003D00055Q001249000600093Q0012490007000A4Q004B0005000700022Q003D00065Q0012490007000B3Q0012490008000C4Q004B0006000800022Q0029000700013Q00122F0008000D3Q00203000080008000E2Q001800080001000200065F00093Q000100032Q00703Q00074Q008F8Q00703Q00084Q0077000A00094Q003D000B5Q001249000C000F3Q001249000D00104Q003A000B000D4Q004D000A3Q000100122F000A00113Q002006000A000A00122Q003D000C5Q001249000D00133Q001249000E00144Q003A000C000E4Q0046000A3Q000200122F000B00113Q002006000B000B00122Q003D000D5Q001249000E00153Q001249000F00164Q003A000D000F4Q0046000B3Q000200122F000C00113Q002006000C000C00122Q003D000E5Q001249000F00173Q001249001000184Q003A000E00104Q0046000C3Q000200122F000D00113Q002006000D000D00122Q003D000F5Q001249001000193Q0012490011001A4Q003A000F00114Q0046000D3Q000200122F000E00113Q002006000E000E00122Q003D00105Q0012490011001B3Q0012490012001C4Q003A001000124Q0046000E3Q000200065F000F0001000100012Q00703Q000B3Q00122F0010001D3Q00065F00110002000100022Q00703Q000F4Q008F8Q006400100002000100065F00100003000100012Q008F7Q00065F00110004000100012Q008F7Q0012490012001E3Q00065F00130005000100072Q008F8Q00703Q00124Q00703Q00114Q00703Q000A4Q00703Q00014Q00703Q000C4Q00703Q00103Q00065F00140006000100012Q008F7Q00065F00150007000100032Q008F8Q00703Q00104Q00703Q00144Q0029001600013Q00065F00170008000100022Q00703Q00034Q008F7Q00065F00180009000100012Q00703Q00033Q00065F0019000A000100082Q00703Q00024Q00703Q00124Q00703Q00014Q008F8Q00703Q000C4Q00703Q000A4Q00703Q00114Q00703Q00153Q00065F001A000B000100072Q008F8Q00703Q00194Q00703Q00094Q00703Q00184Q00703Q00174Q00703Q00164Q00703Q00034Q0076001B3Q00042Q003D001C5Q001249001D001F3Q001249001E00204Q004B001C001E000200202D001B001C00212Q003D001C5Q001249001D00223Q001249001E00234Q004B001C001E000200202D001B001C00212Q003D001C5Q001249001D00243Q001249001E00254Q004B001C001E000200202D001B001C00262Q003D001C5Q001249001D00273Q001249001E00284Q004B001C001E000200202D001B001C002600065F001C000C000100022Q00703Q001B4Q00703Q001A3Q00065F001D000D000100032Q00703Q001B4Q00703Q001C4Q00703Q001A3Q00065F001E000E000100032Q00703Q001D4Q00703Q00094Q008F7Q001249001F00294Q003D00205Q0012490021002A3Q0012490022002B4Q004B00200022000200065F0021000F000100012Q00703Q00203Q00065F00220010000100022Q00703Q00054Q00703Q00213Q00065F00230011000100022Q00703Q00204Q008F7Q00065F00240012000100022Q00703Q001F4Q00703Q00233Q0012490025001E3Q00122F0026001D3Q00065F00270013000100032Q00703Q00054Q00703Q00254Q008F8Q00640026000200012Q008C002600263Q0026340025004D2Q01001E0004553Q004D2Q010012490027002C3Q000E31002C00B9000100270004553Q00B900012Q0077001200254Q0077002800244Q0077002900254Q0073002800020002000611002800E200013Q0004553Q00E200010012490028002C4Q008C0029002A3Q002652002800CE0001002D0004553Q00CE00012Q003D002B5Q001249002C002E3Q001249002D002F4Q004B002B002D000200122F002C00304Q0077002D002A4Q0073002C000200022Q00020026002B002C0004553Q004D2Q01002652002800C30001002C0004553Q00C30001001249002B002C3Q002652002B00D50001002D0004553Q00D500010012490028002D3Q0004553Q00C30001002652002B00D10001002C0004553Q00D100012Q0077002C001E4Q0075002C0001002D2Q0077002A002D4Q00770029002C3Q000611002900DE00013Q0004553Q00DE00012Q00783Q00013Q001249002B002D3Q0004553Q00D100010004553Q00C300010004553Q004D2Q010012490028002C4Q008C0029002B3Q002652002800E90001002C0004553Q00E900010012490029002C4Q008C002A002A3Q0012490028002D3Q002652002800E40001002D0004553Q00E400012Q008C002B002B3Q002652002900F60001002C0004553Q00F600012Q0077002C001C4Q0094002C000100012Q0077002C00134Q0077002D00254Q005C002C0002002D2Q0077002B002D4Q0077002A002C3Q0012490029002D3Q000E31002D00EC000100290004553Q00EC00012Q0077002C00094Q003D002D5Q001249002E00313Q001249002F00324Q004B002D002F000200122F002E00304Q0077002F002A4Q0073002E00020002000611002B000D2Q013Q0004553Q000D2Q012Q003D002F5Q001249003000333Q001249003100344Q004B002F0031000200122F003000304Q00770031002B4Q0073003000020002001249003100354Q0002002F002F0031000692002F000E2Q0100010004553Q000E2Q01001249002F001E4Q0002002D002D002F2Q0064002C00020001000611002A00332Q013Q0004553Q00332Q01001249002C002C4Q008C002D002E3Q000E31002C00232Q01002C0004553Q00232Q012Q0077002F00234Q0077003000254Q0073002F00020002002652002F001E2Q0100260004553Q001E2Q012Q0077002F00214Q0077003000254Q0064002F000200012Q0077002F001E4Q0075002F000100302Q0077002E00304Q0077002D002F3Q001249002C002D3Q002652002C00142Q01002D0004553Q00142Q01000611002D00282Q013Q0004553Q00282Q012Q00783Q00014Q003D002F5Q001249003000363Q001249003100374Q004B002F0031000200122F003000304Q00770031002E4Q00730030000200022Q00020026002F00300004553Q004D2Q010004553Q00142Q010004553Q004D2Q012Q003D002C5Q001249002D00383Q001249002E00394Q004B002C002E0002000680002B003F2Q01002C0004553Q003F2Q012Q003D002C5Q001249002D003A3Q001249002E003B4Q004B002C002E00022Q00770026002C3Q0004553Q004D2Q012Q003D002C5Q001249002D003C3Q001249002E003D4Q004B002C002E000200122F002D00304Q0077002E002B4Q0073002D000200022Q00020026002C002D0004553Q004D2Q010004553Q00EC00010004553Q004D2Q010004553Q00E400010004553Q004D2Q010004553Q00B900012Q007600273Q000E2Q003D00285Q0012490029003E3Q001249002A003F4Q004B0028002A000200122F002900403Q002030002900290041001249002A00423Q001249002B00423Q001249002C00434Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900443Q001249002A00454Q004B0028002A000200122F002900403Q002030002900290041001249002A00463Q001249002B00463Q001249002C00474Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900483Q001249002A00494Q004B0028002A000200122F002900403Q002030002900290041001249002A004A3Q001249002B004A3Q001249002C004B4Q004B0029002C00022Q001E0027002800292Q003D00285Q0012490029004C3Q001249002A004D4Q004B0028002A000200122F002900403Q002030002900290041001249002A004E3Q001249002B004E3Q001249002C004F4Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900503Q001249002A00514Q004B0028002A000200122F002900403Q002030002900290041001249002A004A3Q001249002B004A3Q001249002C004B4Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900523Q001249002A00534Q004B0028002A000200122F002900403Q002030002900290041001249002A00543Q001249002B00543Q001249002C00554Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900563Q001249002A00574Q004B0028002A000200122F002900403Q002030002900290041001249002A00583Q001249002B00583Q001249002C00594Q004B0029002C00022Q001E0027002800292Q003D00285Q0012490029005A3Q001249002A005B4Q004B0028002A000200122F002900403Q002030002900290041001249002A005C3Q001249002B005C3Q001249002C005D4Q004B0029002C00022Q001E0027002800292Q003D00285Q0012490029005E3Q001249002A005F4Q004B0028002A000200122F002900403Q002030002900290041001249002A00603Q001249002B00603Q001249002C00614Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900623Q001249002A00634Q004B0028002A000200122F002900403Q002030002900290041001249002A00643Q001249002B00653Q001249002C00654Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900663Q001249002A00674Q004B0028002A000200122F002900403Q002030002900290041001249002A00683Q001249002B00693Q001249002C00694Q004B0029002C00022Q001E0027002800292Q003D00285Q0012490029006A3Q001249002A006B4Q004B0028002A000200122F002900403Q002030002900290041001249002A006C3Q001249002B006D3Q001249002C006D4Q004B0029002C00022Q001E0027002800292Q003D00285Q0012490029006E3Q001249002A006F4Q004B0028002A000200122F002900403Q002030002900290041001249002A00583Q001249002B00703Q001249002C00714Q004B0029002C00022Q001E0027002800292Q003D00285Q001249002900723Q001249002A00734Q004B0028002A000200122F002900403Q002030002900290041001249002A00743Q001249002B00753Q001249002C004A4Q004B0029002C00022Q001E002700280029000283002800143Q00065F00290015000100022Q00703Q00284Q008F7Q00065F002A0016000100022Q00703Q00284Q008F7Q00065F002B0017000100012Q00703Q000D4Q0077002C00284Q003D002D5Q001249002E00763Q001249002F00774Q004B002D002F00022Q0076002E3Q00032Q003D002F5Q001249003000783Q001249003100794Q004B002F003100022Q003D00305Q0012490031007A3Q0012490032007B4Q004B0030003200022Q001E002E002F00302Q003D002F5Q0012490030007C3Q0012490031007D4Q004B002F0031000200202D002E002F00212Q003D002F5Q0012490030007E3Q0012490031007F4Q004B002F0031000200122F003000803Q0020300030003000810020300030003000822Q001E002E002F00302Q004B002C002E000200122F002D001D3Q00065F002E0018000100012Q00703Q002C4Q0064002D000200012Q0077002D000F4Q0018002D0001000200106B002C0083002D001249002D00843Q001249002E00853Q001249002F00654Q0077003000284Q003D00315Q001249003200863Q001249003300874Q004B0031003300022Q007600323Q00072Q003D00335Q001249003400883Q001249003500894Q004B0033003500022Q003D00345Q0012490035008A3Q0012490036008B4Q004B0034003600022Q001E0032003300342Q003D00335Q0012490034008C3Q0012490035008D4Q004B00330035000200122F0034008E3Q00203000340034008F001249003500903Q001249003600904Q004B0034003600022Q001E0032003300342Q003D00335Q001249003400913Q001249003500924Q004B00330035000200122F003400933Q00203000340034008F001249003500903Q0012490036002C3Q001249003700903Q0012490038002C4Q004B0034003800022Q001E0032003300342Q003D00335Q001249003400943Q001249003500954Q004B00330035000200122F003400933Q0020300034003400962Q00770035002D4Q00770036002E4Q004B0034003600022Q001E0032003300342Q003D00335Q001249003400973Q001249003500984Q004B0033003500020020300034002700992Q001E0032003300342Q003D00335Q0012490034009A3Q0012490035009B4Q004B00330035000200202D00320033002C2Q003D00335Q0012490034009C3Q0012490035009D4Q004B00330035000200202D00320033009E2Q00770033002C4Q004B0030003300022Q0077003100294Q0077003200303Q0012490033009F4Q006D0031003300012Q00770031002A4Q0077003200303Q00122F003300403Q002030003300330041001249003400A03Q001249003500A03Q001249003600A14Q004B0033003600020012490034002D4Q006D0031003400012Q0077003100284Q003D00325Q001249003300A23Q001249003400A34Q004B0032003400022Q007600333Q00012Q003D00345Q001249003500A43Q001249003600A54Q004B00340036000200202D0033003400A62Q0077003400304Q004B0031003400022Q0077003200284Q003D00335Q001249003400A73Q001249003500A84Q004B0033003500022Q007600343Q00032Q003D00355Q001249003600A93Q001249003700AA4Q004B00350037000200122F003600933Q00203000360036008F0012490037002D3Q0012490038002C3Q0012490039002C4Q0077003A002F4Q004B0036003A00022Q001E0034003500362Q003D00355Q001249003600AB3Q001249003700AC4Q004B0035003700020020300036002700AD2Q001E0034003500362Q003D00355Q001249003600AE3Q001249003700AF4Q004B00350037000200202D00340035002C2Q0077003500304Q004B0032003500022Q0077003300294Q0077003400323Q0012490035009F4Q006D0033003500012Q0077003300284Q003D00345Q001249003500B03Q001249003600B14Q004B0034003600022Q007600353Q00022Q003D00365Q001249003700B23Q001249003800B34Q004B00360038000200122F003700B43Q00203000370037008F00122F003800403Q002030003800380041001249003900B53Q001249003A00B53Q001249003B00B64Q004B0038003B000200122F003900403Q002030003900390041001249003A00B73Q001249003B00B73Q001249003C00464Q003A0039003C4Q004600373Q00022Q001E0035003600372Q003D00365Q001249003700B83Q001249003800B94Q004B00360038000200202D0035003600BA2Q0077003600324Q006D0033003600012Q0077003300284Q003D00345Q001249003500BB3Q001249003600BC4Q004B0034003600022Q007600353Q00042Q003D00365Q001249003700BD3Q001249003800BE4Q004B00360038000200122F003700933Q00203000370037008F0012490038002C3Q0012490039002C3Q001249003A002D3Q001249003B00BF4Q004B0037003B00022Q001E0035003600372Q003D00365Q001249003700C03Q001249003800C14Q004B00360038000200122F003700933Q00203000370037008F0012490038002D3Q0012490039002C3Q001249003A002C3Q001249003B00C24Q004B0037003B00022Q001E0035003600372Q003D00365Q001249003700C33Q001249003800C44Q004B00360038000200122F003700403Q002030003700370041001249003800B73Q001249003900B73Q001249003A00464Q004B0037003A00022Q001E0035003600372Q003D00365Q001249003700C53Q001249003800C64Q004B00360038000200202D00350036002C2Q0077003600324Q004B0033003600022Q0077003400284Q003D00355Q001249003600C73Q001249003700C84Q004B0035003700022Q007600363Q00052Q003D00375Q001249003800C93Q001249003900CA4Q004B00370039000200122F003800933Q00203000380038008F0012490039002C3Q001249003A002C3Q001249003B002D3Q001249003C00CB4Q004B0038003C00022Q001E0036003700382Q003D00375Q001249003800CC3Q001249003900CD4Q004B00370039000200122F003800933Q00203000380038008F0012490039002D3Q001249003A002C3Q001249003B002C3Q001249003C002D4Q004B0038003C00022Q001E0036003700382Q003D00375Q001249003800CE3Q001249003900CF4Q004B00370039000200122F003800403Q002030003800380041001249003900D03Q001249003A00D03Q001249003B004E4Q004B0038003B00022Q001E0036003700382Q003D00375Q001249003800D13Q001249003900D24Q004B00370039000200202D00360037002C2Q003D00375Q001249003800D33Q001249003900D44Q004B00370039000200202D0036003700D52Q0077003700324Q004B0034003700022Q0077003500284Q003D00365Q001249003700D63Q001249003800D74Q004B0036003800022Q007600373Q00062Q003D00385Q001249003900D83Q001249003A00D94Q004B0038003A000200202D00370038002D2Q003D00385Q001249003900DA3Q001249003A00DB4Q004B0038003A000200122F003900933Q00203000390039008F001249003A002D3Q001249003B002C3Q001249003C002D3Q001249003D002C4Q004B0039003D00022Q001E0037003800392Q003D00385Q001249003900DC3Q001249003A00DD4Q004B0038003A00022Q003D00395Q001249003A00DE3Q001249003B00DF4Q004B0039003B00022Q001E0037003800392Q003D00385Q001249003900E03Q001249003A00E14Q004B0038003A00020020300039002700E22Q001E0037003800392Q003D00385Q001249003900E33Q001249003A00E44Q004B0038003A000200202D0037003800E52Q003D00385Q001249003900E63Q001249003A00E74Q004B0038003A000200122F003900803Q0020300039003900E80020300039003900E92Q001E0037003800392Q0077003800324Q006D0035003800012Q008C003500354Q002900366Q0076003700034Q007600383Q00042Q003D00395Q001249003A00EA3Q001249003B00EB4Q004B0039003B00022Q003D003A5Q001249003B00EC3Q001249003C00ED4Q004B003A003C00022Q001E00380039003A2Q003D00395Q001249003A00EE3Q001249003B00EF4Q004B0039003B000200122F003A00403Q002030003A003A0041001249003B00743Q001249003C00F03Q001249003D00F14Q004B003A003D00022Q001E00380039003A2Q003D00395Q001249003A00F23Q001249003B00F34Q004B0039003B000200202D0038003900F42Q003D00395Q001249003A00F53Q001249003B00F64Q004B0039003B000200122F003A00403Q002030003A003A0041001249003B00F73Q001249003C009F3Q001249003D00F84Q004B003A003D00022Q001E00380039003A2Q007600393Q00042Q003D003A5Q001249003B00F93Q001249003C00FA4Q004B003A003C00022Q003D003B5Q001249003C00FB3Q001249003D00FC4Q004B003B003D00022Q001E0039003A003B2Q003D003A5Q001249003B00FD3Q001249003C00FE4Q004B003A003C000200122F003B00403Q002030003B003B0041001249003C00FF3Q001249003D2Q00012Q001249003E00474Q004B003B003E00022Q001E0039003A003B2Q003D003A5Q001249003B002Q012Q001249003C0002013Q004B003A003C0002001249003B0003013Q001E0039003A003B2Q003D003A5Q001249003B0004012Q001249003C0005013Q004B003A003C000200122F003B00403Q002030003B003B0041001249003C0006012Q001249003D00553Q001249003E002C4Q004B003B003E00022Q001E0039003A003B2Q0076003A3Q00042Q003D003B5Q001249003C0007012Q001249003D0008013Q004B003B003D00022Q003D003C5Q001249003D0009012Q001249003E000A013Q004B003C003E00022Q001E003A003B003C2Q003D003B5Q001249003C000B012Q001249003D000C013Q004B003B003D000200122F003C00403Q002030003C003C0041001249003D000D012Q001249003E000E012Q001249003F000F013Q004B003C003F00022Q001E003A003B003C2Q003D003B5Q001249003C0010012Q001249003D0011013Q004B003B003D0002001249003C0012013Q001E003A003B003C2Q003D003B5Q001249003C0013012Q001249003D0014013Q004B003B003D000200122F003C00403Q002030003C003C0041001249003D0015012Q001249003E00BA3Q001249003F00D04Q004B003C003F00022Q001E003A003B003C2Q001B0037000300012Q007600385Q0012490039002C3Q00065F003A0019000100012Q00703Q00383Q00122F003B0016013Q0077003C00374Q005C003B0002003D0004553Q008004010012490040002C4Q008C004100423Q0012490043002D3Q00068000400079040100430004553Q0079040100124900430017012Q000680004300DA030100410004553Q00DA030100124900430018013Q001E003F004300420004553Q008004010012490043002D3Q000680004100FD030100430004553Q00FD03010012490043002C3Q0012490044002C3Q000680004400F7030100430004553Q00F703012Q00770044002A4Q0077004500423Q00122F004600403Q0020300046004600410012490047002C3Q0012490048002C3Q0012490049002C4Q004B0046004900020012490047002D4Q004B00440047000200124900450019012Q0012490046001A013Q001E0044004500460012490044001B013Q00970044004200440012490046001C013Q001C00440044004600065F0046001A000100022Q00703Q00394Q00703Q003A4Q006D0044004600010012490043002D3Q0012490044002D3Q000680004300DE030100440004553Q00DE0301001249004100D53Q0004553Q00FD03010004553Q00DE0301001249004300D53Q00068000410018040100430004553Q001804010012490043001D013Q00970043004200430012490045001C013Q001C00430043004500065F0045001B000100032Q00703Q00394Q00703Q002C4Q00703Q003A4Q006D0043004500012Q007600433Q00022Q003D00445Q0012490045001E012Q0012490046001F013Q004B0044004600022Q001E0043004400422Q003D00445Q00124900450020012Q00124900460021013Q004B00440046000200124900450022013Q00970045003F00452Q001E0043004400452Q001E0038003E004300124900410017012Q0012490043002C3Q000680004100D4030100430004553Q00D403012Q0077004300284Q003D00445Q00124900450023012Q00124900460024013Q004B0044004600022Q007600453Q000A2Q003D00465Q00124900470025012Q00124900480026013Q004B00460048000200122F004700933Q00203000470047008F0012490048002C3Q0012490049002D4Q00380049003E0049001249004A00D04Q000900490049004A001249004A00C24Q00510049004A0049001249004A00903Q001249004B0027013Q004B0047004B00022Q001E0045004600472Q003D00465Q00124900470028012Q00124900480029013Q004B00460048000200122F004700933Q0020300047004700960012490048009F3Q0012490049009F4Q004B0047004900022Q001E0045004600472Q003D00465Q0012490047002A012Q0012490048002B013Q004B0046004800020012490047002C013Q00970047003F00472Q001E0045004600472Q003D00465Q0012490047002D012Q0012490048002E013Q004B0046004800022Q002900476Q001E0045004600472Q003D00465Q0012490047002F012Q00124900480030013Q004B0046004800020012490047002C4Q001E0045004600472Q003D00465Q00124900470031012Q00124900480032013Q004B00460048000200202D00450046001E2Q003D00465Q00124900470033012Q00124900480034013Q004B00460048000200124900470035013Q00970047003F00472Q001E0045004600472Q003D00465Q00124900470036012Q00124900480037013Q004B00460048000200124900470038013Q001E0045004600472Q003D00465Q00124900470039012Q0012490048003A013Q004B00460048000200122F004700803Q0020300047004700E80020300047004700E92Q001E0045004600472Q003D00465Q0012490047003B012Q0012490048003C013Q004B00460048000200124900470017013Q001E0045004600472Q0077004600324Q004B0043004600022Q0077004200434Q0077004300294Q0077004400423Q0012490045003D013Q006D0043004500010012490041002D3Q0004553Q00D403010004553Q008004010012490043002C3Q000680004300D1030100400004553Q00D103010012490041002C4Q008C004200423Q0012490040002D3Q0004553Q00D10301000674003B00CF030100020004553Q00CF030100065F003B001C0001000A2Q00703Q00364Q00703Q00334Q00703Q00344Q00703Q00354Q00703Q002B4Q00703Q00304Q008F8Q00703Q002D4Q00703Q002F4Q00703Q002E3Q001249003C002D4Q0097003C0037003C001249003D0018013Q0097003C003C003D001249003D003E013Q0097003C003C003D001249003E001C013Q001C003C003C003E00065F003E001D000100042Q00703Q002C4Q00703Q002B4Q00703Q00314Q008F8Q006D003C003E0001001249003C00D54Q0097003C0037003C001249003D0018013Q0097003C003C003D001249003D003E013Q0097003C003C003D001249003E001C013Q001C003C003C003E00065F003E001E000100022Q00703Q003B4Q00703Q00364Q006D003C003E0001001249003C0017013Q0097003C0037003C001249003D0018013Q0097003C003C003D001249003D003E013Q0097003C003C003D001249003E001C013Q001C003C003C003E00065F003E001F000100022Q00703Q00364Q00703Q003B4Q006D003C003E00012Q0029003C6Q008C003D003E3Q001249003F003F013Q0097003F0032003F0012490041001C013Q001C003F003F004100065F00410020000100052Q00703Q003C4Q00703Q003D4Q00703Q003E4Q00703Q00304Q00703Q00324Q006D003F00410001001249003F0040013Q0097003F000E003F0012490041001C013Q001C003F003F004100065F00410021000100042Q00703Q003C4Q00703Q003D4Q00703Q00304Q00703Q003E4Q004B003F0041000200124900400041013Q00970040002C00400012490042001C013Q001C00400040004200065F00420022000100012Q00703Q003F4Q006D0040004200012Q0077004000284Q003D00415Q00124900420042012Q00124900430043013Q004B0041004300022Q007600423Q00032Q003D00435Q00124900440044012Q00124900450045013Q004B00430045000200122F004400933Q00203000440044008F0012490045002C3Q0012490046002C3Q0012490047002C4Q00770048002F4Q004B0044004800022Q001E0042004300442Q003D00435Q00124900440046012Q00124900450047013Q004B00430045000200122F004400933Q00203000440044008F0012490045002D3Q0012490046002C3Q0012490047002D4Q00410048002F4Q004B0044004800022Q001E0042004300442Q003D00435Q00124900440048012Q00124900450049013Q004B0043004500020012490044002D4Q001E0042004300442Q0077004300304Q004B0040004300022Q0077003500403Q00065F00400023000100032Q00703Q00284Q008F8Q00703Q00354Q0077004100284Q003D00425Q0012490043004A012Q0012490044004B013Q004B0042004400022Q007600433Q00042Q003D00445Q0012490045004C012Q0012490046004D013Q004B00440046000200122F0045008E3Q00203000450045008F001249004600903Q0012490047002C4Q004B0045004700022Q001E0043004400452Q003D00445Q0012490045004E012Q0012490046004F013Q004B00440046000200122F004500933Q00203000450045008F001249004600903Q0012490047002C3Q0012490048002C3Q00124900490015013Q004B0045004900022Q001E0043004400452Q003D00445Q00124900450050012Q00124900460051013Q004B00440046000200122F004500933Q00203000450045009600124900460052012Q00124900470052013Q004B0045004700022Q001E0043004400452Q003D00445Q00124900450053012Q00124900460054013Q004B0044004600020012490045002D4Q001E0043004400452Q0077004400354Q004B0041004400022Q0077004200284Q003D00435Q00124900440055012Q00124900450056013Q004B0043004500022Q007600443Q00082Q003D00455Q00124900460057012Q00124900470058013Q004B00450047000200122F0046008E3Q00203000460046008F001249004700903Q001249004800904Q004B0046004800022Q001E0044004500462Q003D00455Q00124900460059012Q0012490047005A013Q004B00450047000200122F004600933Q00203000460046008F001249004700903Q0012490048002C3Q001249004900903Q001249004A002C4Q004B0046004A00022Q001E0044004500462Q003D00455Q0012490046005B012Q0012490047005C013Q004B00450047000200122F004600933Q0020300046004600960012490047005D012Q0012490048005D013Q004B0046004800022Q001E0044004500462Q003D00455Q0012490046005E012Q0012490047005F013Q004B00450047000200122F004600403Q002030004600460041001249004700B73Q001249004800F83Q001249004900F84Q004B0046004900022Q001E0044004500462Q003D00455Q00124900460060012Q00124900470061013Q004B00450047000200124900460062013Q001E0044004500462Q003D00455Q00124900460063012Q00124900470064013Q004B0045004700020020300046002700E22Q001E0044004500462Q003D00455Q00124900460065012Q00124900470066013Q004B0045004700020012490046006D4Q001E0044004500462Q003D00455Q00124900460067012Q00124900470068013Q004B00450047000200122F004600803Q0020300046004600E80020300046004600E92Q001E0044004500462Q0077004500414Q004B0042004500022Q0077004300294Q0077004400423Q001249004500C24Q006D0043004500012Q00770043002A4Q0077004400423Q00122F004500403Q002030004500450041001249004600F73Q0012490047004F3Q0012490048004F4Q004B0045004800020012490046002D4Q006D0043004600012Q0077004300284Q003D00445Q00124900450069012Q0012490046006A013Q004B0044004600022Q007600453Q00042Q003D00465Q0012490047006B012Q0012490048006C013Q004B00460048000200122F004700933Q00203000470047008F0012490048002D3Q0012490049002C3Q001249004A002D3Q001249004B002C4Q004B0047004B00022Q001E0045004600472Q003D00465Q0012490047006D012Q0012490048006E013Q004B0046004800020012490047002D4Q001E0045004600472Q003D00465Q0012490047006F012Q00124900480070013Q004B00460048000200122F004700803Q00124900480071013Q009700470047004800124900480072013Q00970047004700482Q001E0045004600472Q003D00465Q00124900470073012Q00124900480074013Q004B0046004800022Q002900476Q001E0045004600472Q0077004600414Q004B00430046000200122F00440075012Q00124900450076013Q009700440044004500065F00450024000100072Q00703Q002C4Q00703Q00434Q00703Q00424Q00703Q00064Q00703Q00104Q00703Q00014Q008F8Q00640044000200012Q0077004400404Q003D00455Q00124900460077012Q00124900470078013Q004B00450047000200124900460079012Q0012490047007A012Q0012490048007B013Q009700480027004800122F004900803Q0020300049004900E80020300049004900E92Q006D0044004900012Q0077004400404Q003D00455Q0012490046007C012Q0012490047007D013Q004B0045004700020012490046009F3Q0012490047007E012Q0012490048007F013Q009700480027004800122F004900803Q0020300049004900E8001249004A0080013Q009700490049004A2Q006D0044004900012Q0077004400284Q003D00455Q00124900460081012Q00124900470082013Q004B0045004700022Q007600463Q000D2Q003D00475Q00124900480083012Q00124900490084013Q004B00470049000200122F004800933Q00203000480048008F0012490049002C3Q001249004A004F3Q001249004B002C3Q001249004C0085013Q004B0048004C00022Q001E0046004700482Q003D00475Q00124900480086012Q00124900490087013Q004B00470049000200122F004800933Q00203000480048008F0012490049002D3Q001249004A0088012Q001249004B002C3Q001249004C0089013Q004B0048004C00022Q001E0046004700482Q003D00475Q0012490048008A012Q0012490049008B013Q004B0047004900020012490048008C013Q00970048002700482Q001E0046004700482Q003D00475Q0012490048008D012Q0012490049008E013Q004B0047004900020012490048002C4Q001E0046004700482Q003D00475Q0012490048008F012Q00124900490090013Q004B0047004900022Q003D00485Q00124900490091012Q001249004A0092013Q004B0048004A00022Q001E0046004700482Q003D00475Q00124900480093012Q00124900490094013Q004B00470049000200122F004800403Q002030004800480041001249004900F73Q001249004A00F73Q001249004B0095013Q004B0048004B00022Q001E0046004700482Q003D00475Q00124900480096012Q00124900490097013Q004B0047004900022Q001E0046004700252Q003D00475Q00124900480098012Q00124900490099013Q004B0047004900020012490048007B013Q00970048002700482Q001E0046004700482Q003D00475Q0012490048009A012Q0012490049009B013Q004B004700490002001249004800E54Q001E0046004700482Q003D00475Q0012490048009C012Q0012490049009D013Q004B00470049000200122F004800803Q0020300048004800E800124900490080013Q00970048004800492Q001E0046004700482Q003D00475Q0012490048009E012Q0012490049009F013Q004B0047004900022Q002900486Q001E0046004700482Q003D00475Q001249004800A0012Q001249004900A1013Q004B00470049000200122F004800803Q001249004900A2013Q0097004800480049001249004900A3013Q00970048004800492Q001E0046004700482Q003D00475Q001249004800A4012Q001249004900A5013Q004B0047004900022Q0029004800014Q001E0046004700482Q0077004700354Q004B0044004700022Q0077004500294Q0077004600443Q001249004700F84Q006D0045004700012Q0077004500284Q003D00465Q001249004700A6012Q001249004800A7013Q004B0046004800022Q007600473Q00022Q003D00485Q001249004900A8012Q001249004A00A9013Q004B0048004A000200122F004900AA012Q00203000490049008F001249004A002C3Q001249004B009F4Q004B0049004B00022Q001E0047004800492Q003D00485Q001249004900AB012Q001249004A00AC013Q004B0048004A000200122F004900AA012Q00203000490049008F001249004A002C3Q001249004B009F4Q004B0049004B00022Q001E0047004800492Q0077004800444Q006D0045004800012Q00770045002A4Q0077004600443Q001249004700AD013Q00970047002700470012490048002D4Q004B004500480002001249004600AE013Q00970046004400460012490048001C013Q001C00460046004800065F00480025000100042Q00703Q002B4Q00703Q00454Q008F8Q00703Q00274Q006D004600480001001249004600AF013Q00970046004400460012490048001C013Q001C00460046004800065F00480026000100042Q00703Q002B4Q00703Q00454Q008F8Q00703Q00274Q006D00460048000100065F00460027000100062Q00703Q002B4Q008F8Q00703Q00284Q00703Q00274Q00703Q00354Q00703Q00294Q0077004700464Q003D00485Q001249004900B0012Q001249004A00B1013Q004B0048004A000200122F004900933Q00203000490049008F001249004A002C3Q001249004B004F3Q001249004C002C3Q001249004D00B2013Q004B0049004D000200122F004A00933Q002030004A004A008F001249004B002D3Q001249004C0088012Q001249004D002C3Q001249004E0089013Q004B004A004E0002001249004B00B3013Q0097004B0027004B002030004C002700E2001249004D00B4013Q0097004D0027004D00122F004E00403Q002030004E004E0041001249004F00743Q001249005000743Q001249005100744Q004B004E0051000200122F004F00803Q002030004F004F00E8002030004F004F00E92Q004B0047004F00022Q0077004800464Q003D00495Q001249004A00B5012Q001249004B00B6013Q004B0049004B000200122F004A00933Q002030004A004A008F001249004B002C3Q001249004C004F3Q001249004D002C3Q001249004E00B7013Q004B004A004E000200122F004B00933Q002030004B004B008F001249004C00903Q001249004D00B8012Q001249004E002C3Q001249004F00434Q004B004B004F0002001249004C0018013Q0097004C0027004C001249004D00B9013Q0097004D0027004D001249004E00BA013Q0097004E0027004E2Q004B0048004E00022Q0077004900464Q003D004A5Q001249004B00BB012Q001249004C00BC013Q004B004A004C000200122F004B00933Q002030004B004B008F001249004C00903Q001249004D00BD012Q001249004E002C3Q001249004F00B7013Q004B004B004F000200122F004C00933Q002030004C004C008F001249004D00903Q001249004E00B8012Q001249004F002C3Q001249005000434Q004B004C00500002001249004D0018013Q0097004D0027004D001249004E00B9013Q0097004E0027004E001249004F00BA013Q0097004F0027004F2Q004B0049004F00022Q0077004A00403Q001249004B001E3Q001249004C009F3Q001249004D00BE012Q001249004E007F013Q0097004E0027004E00122F004F00803Q002030004F004F00E800124900500080013Q0097004F004F00502Q004B004A004F0002001249004B00BF012Q00122F004C00933Q002030004C004C008F001249004D002D3Q001249004E0088012Q001249004F002C3Q001249005000C0013Q004B004C005000022Q001E004A004B004C001249004B00C1012Q00122F004C00803Q001249004D00C1013Q0097004C004C004D001249004D00C2013Q0097004C004C004D2Q001E004A004B004C001249004B00C3012Q001249004C009F4Q001E004A004B004C00065F004B0028000100022Q00703Q004A4Q00703Q00273Q0006110026000607013Q0004553Q000607012Q0077004C004B4Q0077004D00264Q0029004E6Q006D004C004E0001001249004C003E013Q0097004C0048004C001249004E001C013Q001C004C004C004E00065F004E0029000100032Q00703Q00014Q00703Q004B4Q008F8Q006D004C004E0001001249004C003E013Q0097004C0049004C001249004E001C013Q001C004C004C004E00065F004E002A000100032Q00703Q00044Q00703Q004B4Q008F8Q006D004C004E00012Q0029004C5Q001249004D003E013Q0097004D0047004D001249004F001C013Q001C004D004D004F00065F004F002B0001000C2Q008F8Q00703Q002C4Q00703Q004C4Q00703Q004B4Q00703Q002B4Q00703Q00314Q00703Q00224Q00703Q001D4Q00703Q00124Q00703Q001C4Q00703Q00134Q00703Q00444Q006D004D004F00012Q0077004D002B4Q0077004E00313Q001249004F00C4013Q007600503Q00012Q003D00515Q001249005200C5012Q001249005300C6013Q004B0051005300020012490052002D4Q001E00500051005200122F005100803Q001249005200C7013Q0097005100510052001249005200C8013Q00970051005100522Q006D004D005100012Q000100015Q0004553Q003F07010012490001002D4Q009700013Q00012Q00783Q00013Q002C3Q00073Q0003053Q007072696E7403063Q00737472696E6703063Q00666F726D6174031E3Q000E8786FDD521BCCBDACF3789CBB99F7BE68DE19A39BB8AF6DF27EECBB7C903053Q00BA55D4EB9203023Q006F7303053Q00636C6F636B01134Q003D00015Q0006110001001200013Q0004553Q0012000100122F000100013Q00122F000200023Q0020300002000200032Q003D000300013Q001249000400043Q001249000500054Q004B00030005000200122F000400063Q0020300004000400072Q00180004000100022Q003D000500024Q00380004000400052Q007700056Q003A000200054Q004D00013Q00012Q00783Q00017Q00033Q00028Q00026Q00F03F03053Q007063612Q6C002C3Q0012493Q00014Q008C000100033Q0026523Q0007000100010004553Q00070001001249000100014Q008C000200023Q0012493Q00023Q0026523Q0002000100020004553Q000200012Q008C000300033Q001249000400013Q0026520004000B000100010004553Q000B000100265200010011000100020004553Q001100012Q003D00056Q0059000500023Q0026520001000A000100010004553Q000A0001001249000500013Q00265200050018000100020004553Q00180001001249000100023Q0004553Q000A000100265200050014000100010004553Q0014000100122F000600033Q00028300076Q005C0006000200072Q0077000300074Q0077000200063Q0006110002002400013Q0004553Q002400010006110003002400013Q0004553Q002400012Q0059000300023Q001249000500023Q0004553Q001400010004553Q000A00010004553Q000B00010004553Q000A00010004553Q002B00010004553Q000200012Q00783Q00013Q00013Q00013Q0003063Q0067657468756900073Q00122F3Q00013Q0006113Q000500013Q0004553Q0005000100122F3Q00014Q00183Q000100022Q00593Q00024Q00783Q00017Q00063Q00028Q00026Q00F03F030E3Q0046696E6446697273744368696C64030E3Q007D1D38755A181F6F4C3B32637B3903043Q001A2E705703073Q0044657374726F79001D3Q0012493Q00014Q008C000100023Q0026523Q0007000100010004553Q00070001001249000100014Q008C000200023Q0012493Q00023Q0026523Q0002000100020004553Q0002000100265200010009000100010004553Q000900012Q003D00036Q00180003000100020020060003000300032Q003D000500013Q001249000600043Q001249000700054Q003A000500074Q004600033Q00022Q0077000200033Q0006110002001C00013Q0004553Q001C00010020060003000200062Q00640003000200010004553Q001C00010004553Q000900010004553Q001C00010004553Q000200012Q00783Q00017Q001F3Q00028Q00026Q00F03F027Q00402Q033Q0073796E03073Q0072657175657374030C3Q00682Q74705F7265717565737403043Q00682Q747003063Q00666C7578757303053Q007063612Q6C2Q033Q008C31A703083Q00D4D943CB142QDF2503063Q009788BCDAB58903043Q00B2DAEDC82Q033Q009190D203043Q00B0D6D58603043Q007479706503053Q00E0ACB4D8AD03073Q003994CDD6B4C83603053Q003AC901043603053Q0016729D555403083Q00746F737472696E67030A3Q00537461747573436F646503063Q00537461747573026Q00694003043Q00426F647903063Q00D7DF01CD53F103073Q00C8A4AB73A43D96035Q0003063Q00ADE0114C8DB903053Q00E3DE94632501B23Q001249000100014Q008C000200053Q00265200010006000100020004553Q000600012Q008C000400053Q001249000100033Q000E310001000B000100010004553Q000B0001001249000200014Q008C000300033Q001249000100023Q00265200010002000100030004553Q0002000100265200020086000100020004553Q0086000100122F000600043Q0006110006001600013Q0004553Q0016000100122F000600043Q00203000060006000500060700050028000100060004553Q0028000100122F000600063Q00060700050028000100060004553Q0028000100122F000600053Q00060700050028000100060004553Q0028000100122F000600073Q0006110006002300013Q0004553Q0023000100122F000600073Q00203000060006000500060700050028000100060004553Q0028000100122F000600083Q00062100050028000100060004553Q0028000100122F000600083Q0020300005000600050006110005008500013Q0004553Q00850001001249000600014Q008C000700093Q00265200060031000100010004553Q00310001001249000700014Q008C000800083Q001249000600023Q0026520006002C000100020004553Q002C00012Q008C000900093Q00265200070034000100010004553Q0034000100122F000A00094Q0077000B00054Q0076000C3Q00022Q003D000D5Q001249000E000A3Q001249000F000B4Q004B000D000F00022Q001E000C000D4Q003D000D5Q001249000E000C3Q001249000F000D4Q004B000D000F00022Q003D000E5Q001249000F000E3Q0012490010000F4Q004B000E001000022Q001E000C000D000E2Q008D000A000C000B2Q00770009000B4Q00770008000A3Q0006110008008500013Q0004553Q0085000100122F000A00104Q0077000B00094Q0073000A000200022Q003D000B5Q001249000C00113Q001249000D00124Q004B000B000D0002000680000A00850001000B0004553Q00850001001249000A00014Q008C000B000B3Q000E31000200630001000A0004553Q006300012Q0029000C6Q003D000D5Q001249000E00133Q001249000F00144Q004B000D000F000200122F000E00154Q0077000F000B4Q0073000E000200022Q0002000D000D000E2Q003B000C00033Q002652000A0057000100010004553Q00570001002030000C00090016000607000B006C0001000C0004553Q006C0001002030000C00090017000607000B006C0001000C0004553Q006C0001001249000B00183Q00122F000C00103Q002030000D000900192Q0073000C000200022Q003D000D5Q001249000E001A3Q001249000F001B4Q004B000D000F0002000680000C007F0001000D0004553Q007F0001002030000C00090019002634000C007F0001001C0004553Q007F0001002634000B007C000100180004553Q007C0001002652000B007F0001001D0004553Q007F00012Q0029000C00013Q002030000D000900192Q003B000C00033Q001249000A00023Q0004553Q005700010004553Q008500010004553Q003400010004553Q008500010004553Q002C0001001249000200033Q002652000200A7000100010004553Q00A70001001249000600013Q002652000600A2000100010004553Q00A2000100122F000700093Q00065F00083Q000100012Q00708Q005C0007000200082Q0077000400084Q0077000300073Q000611000300A100013Q0004553Q00A1000100122F000700104Q0077000800044Q00730007000200022Q003D00085Q0012490009001E3Q001249000A001F4Q004B0008000A0002000680000700A1000100080004553Q00A10001002634000400A10001001C0004553Q00A100012Q0029000700014Q0077000800044Q003B000700033Q001249000600023Q00265200060089000100020004553Q00890001001249000200023Q0004553Q00A700010004553Q008900010026520002000D000100030004553Q000D00012Q002900065Q00122F000700154Q0077000800044Q000F000700084Q001900065Q0004553Q000D00010004553Q00B100010004553Q000200012Q00783Q00013Q00013Q00023Q0003043Q0067616D6503073Q00482Q747047657400063Q00122F3Q00013Q0020065Q00022Q003D00026Q004F3Q00024Q00198Q00783Q00017Q000A3Q00028Q00026Q00F03F030A3Q00265C59F8F6245C02A6A903053Q0099532Q329603053Q007063612Q6C03083Q00746F737472696E6703043Q006773756203073Q00FA2C48E22Q3D8403073Q00D9A1726D956210035Q002B3Q0012493Q00014Q008C000100013Q001249000200013Q00265200020003000100010004553Q000300010026523Q001A000100010004553Q001A0001001249000300013Q0026520003000C000100020004553Q000C00010012493Q00023Q0004553Q001A000100265200030008000100010004553Q000800012Q003D00045Q001249000500033Q001249000600044Q004B0004000600022Q0077000100043Q00122F000400053Q00065F00053Q000100022Q00703Q00014Q008F8Q0064000400020001001249000300023Q0004553Q000800010026523Q0002000100020004553Q0002000100122F000300064Q0077000400014Q00730003000200020020060003000300072Q003D00055Q001249000600083Q001249000700094Q004B0005000700020012490006000A4Q004B0003000600022Q0059000300023Q0004553Q000200010004553Q000300010004553Q000200012Q00783Q00013Q00013Q00053Q0003043Q0067616D65030A3Q004765745365727669636503133Q006F746B3D7DAA4144627A1F6098484F607A1F7603073Q002D3D16137C13CB030B3Q00476574436C69656E744964000B3Q00122F3Q00013Q0020065Q00022Q003D000200013Q001249000300033Q001249000400044Q003A000200044Q00465Q00020020065Q00052Q00733Q000200022Q00058Q00783Q00017Q002E3Q00028Q00027Q0040026Q00F03F03083Q00746F737472696E6703043Q006773756203023Q00573303063Q00147240581CDC034Q0003093Q00340CC2A0E190B6341803073Q00DD5161B2D498B0026Q001040030B3Q004C6F63616C506C6179657203063Q00557365724964030C3Q0082F118E913CBFE42F01FD4BA03053Q007AAD877D9B03093Q0055726C456E636F646503053Q00C2D409BD6203073Q00A8E4A160D95F5103063Q009DD939552B0A03063Q0037BBB14E3C4F026Q00084003063Q0029CB51E243CB03073Q00E04DAE3F8B26AF03023Q006F6B2Q0103063Q00726561736F6E03063Q0080445627814503043Q004EE4213803043Q0066696E64030B3Q00DD7BA01580DC3EB01696D703053Q00E5AE1ED26303043Q007461736B03043Q007761697403043Q006D61746803063Q0072616E646F6D026Q66E63F026Q00E03F030C3Q0008E89447E82F791EFF945EFF03073Q00597B8DE6318D5D03053Q007063612Q6C030A3Q004A534F4E4465636F646503043Q007479706503053Q00E770F4001503063Q002A9311966C70030C3Q001CA33F69E2FA4FA33F6DE8FA03063Q00886FC64D1F8701D73Q001249000100014Q008C000200053Q001249000600013Q00265200060024000100020004553Q0024000100265200010002000100010004553Q00020001001249000700013Q000E310003000C000100070004553Q000C0001001249000100033Q0004553Q0002000100265200070008000100010004553Q0008000100122F000800044Q007700096Q00730008000200020020060008000800052Q003D000A5Q001249000B00063Q001249000C00074Q004B000A000C0002001249000B00084Q004B0008000B00022Q00773Q00083Q0026523Q0021000100080004553Q002100012Q002900086Q003D00095Q001249000A00093Q001249000B000A4Q003A0009000B4Q001900085Q001249000700033Q0004553Q000800010004553Q000200010026520006003B000100030004553Q003B000100265200010035000100030004553Q00350001001249000700013Q000E310003002D000100070004553Q002D0001001249000100023Q0004553Q0035000100265200070029000100010004553Q002900012Q00053Q00014Q003D000800024Q00180008000100022Q0077000200083Q001249000700033Q0004553Q002900010026520001003A0001000B0004553Q003A00012Q002900076Q0077000800054Q003B000700033Q001249000600023Q00265200060003000100010004553Q000300010026520001005A000100020004553Q005A000100122F000700044Q003D000800033Q00203000080008000C00203000080008000D2Q00730007000200022Q0077000300074Q003D000700044Q003D00085Q0012490009000E3Q001249000A000F4Q004B0008000A00022Q003D000900053Q0020060009000900102Q0077000B6Q004B0009000B00022Q003D000A5Q001249000B00113Q001249000C00124Q004B000A000C00022Q0077000B00034Q003D000C5Q001249000D00133Q001249000E00144Q004B000C000E00022Q0077000D00024Q000200040007000D001249000100153Q002652000100D3000100150004553Q00D30001001249000700013Q002652000700CE000100010004553Q00CE00012Q003D00085Q001249000900163Q001249000A00174Q004B0008000A00022Q0077000500083Q001249000800033Q001249000900153Q001249000A00033Q000482000800CD0001001249000C00014Q008C000D00103Q000E310002007C0001000C0004553Q007C000100203000110010001800265200110071000100190004553Q007100012Q0029001100014Q0059001100023Q00122F001100043Q00203000120010001A00069200120079000100010004553Q007900012Q003D00125Q0012490013001B3Q0012490014001C4Q004B0012001400022Q00730011000200022Q0077000500113Q001249000C00153Q002652000C0097000100150004553Q0097000100200600110005001D2Q003D00135Q0012490014001E3Q0012490015001F4Q004B001300150002001249001400034Q0029001500014Q004B0011001500020006110011009300013Q0004553Q0093000100267B000B0093000100150004553Q0093000100122F001100203Q00203000110011002100122F001200223Q0020300012001200232Q001800120001000200204A0012001200240010840012002500122Q00640011000200010004553Q00CC00012Q002900116Q0077001200054Q003B001100033Q0004553Q00CC0001002652000C00A7000100010004553Q00A700012Q003D001100064Q0077001200044Q005C0011000200122Q0077000E00124Q0077000D00113Q000692000D00A6000100010004553Q00A600012Q002900116Q003D00125Q001249001300263Q001249001400274Q003A001200144Q001900115Q001249000C00033Q002652000C006A000100030004553Q006A0001001249001100013Q002652001100C6000100010004553Q00C6000100122F001200284Q003D001300053Q0020300013001300292Q003D001400054Q00770015000E4Q008D0012001500132Q0077001000134Q0077000F00123Q000611000F00BF00013Q0004553Q00BF000100122F0012002A4Q0077001300104Q00730012000200022Q003D00135Q0012490014002B3Q0012490015002C4Q004B001300150002000636001200C5000100130004553Q00C500012Q002900126Q003D00135Q0012490014002D3Q0012490015002E4Q003A001300154Q001900125Q001249001100033Q002652001100AA000100030004553Q00AA0001001249000C00023Q0004553Q006A00010004553Q00AA00010004553Q006A0001000490000800680001001249000700033Q000E310003005D000100070004553Q005D00010012490001000B3Q0004553Q00D300010004553Q005D0001001249000600033Q0004553Q000300010004553Q000200012Q00783Q00017Q00163Q00028Q00026Q00F03F027Q0040034Q002Q033Q00737562026Q00444003023Q00423203083Q00C96269C736DD847703053Q007461626C6503063Q00636F6E6361742Q033Q00F910C303073Q00CCD96CE341625503013Q005D03053Q006D61746368033C3Q0002F8C1F111FB77CAC8DE18D463F8D9E911FB7BC6C8DE129E6389ABA03F8A168DB8AC69D3149FBADE18D463F8DCEC11FB6AD7C8DE00CC63F8D0E0119E03063Q00A03EA395854C03173Q00ED850812D1C4AF1F6FC0D9A408759C93B3476786D2EB4403053Q00A3B6C06D4F03143Q000F0305FDE726291285E67F6E5185F1712245C4BC03053Q0095544660A003053Q003B2Q09E87803043Q008D58666D016B3Q001249000100014Q008C000200043Q001249000500013Q0026520005002C000100020004553Q002C000100265200010002000100030004553Q00020001001249000600013Q00265200060008000100010004553Q000800010006110002001500013Q0004553Q0015000100263400020015000100040004553Q001500012Q0065000700043Q002098000700070002002006000800020005001249000A00023Q001249000B00064Q004B0008000B00022Q001E0004000700082Q0065000700043Q000E1A00010028000100070004553Q002800012Q003D00075Q001249000800073Q001249000900084Q004B00070009000200122F000800093Q00203000080008000A2Q0077000900044Q003D000A5Q001249000B000B3Q001249000C000C4Q003A000A000C4Q004600083Q00020012490009000D4Q000200070007000900069200070029000100010004553Q00290001001249000700044Q0059000700023Q0004553Q000800010004553Q0002000100265200050003000100010004553Q000300010026520001004F000100010004553Q004F0001001249000600013Q0026520006004A000100010004553Q004A000100200600073Q000E2Q003D00095Q001249000A000F3Q001249000B00104Q003A0009000B4Q004600073Q00022Q0077000200073Q00200600073Q000E2Q003D00095Q001249000A00113Q001249000B00124Q003A0009000B4Q004600073Q000200060700030049000100070004553Q0049000100200600073Q000E2Q003D00095Q001249000A00133Q001249000B00144Q003A0009000B4Q004600073Q00022Q0077000300073Q001249000600023Q00265200060031000100020004553Q00310001001249000100023Q0004553Q004F00010004553Q0031000100265200010067000100020004553Q00670001001249000600013Q00265200060056000100020004553Q00560001001249000100033Q0004553Q0067000100265200060052000100010004553Q005200012Q007600076Q0077000400073Q0006110003006500013Q0004553Q006500012Q0065000700043Q0020980007000700022Q003D00085Q001249000900153Q001249000A00164Q004B0008000A00022Q0077000900034Q00020008000800092Q001E000400070008001249000600023Q0004553Q00520001001249000500023Q0004553Q000300010004553Q000200012Q00783Q00017Q00243Q00028Q00026Q00F03F03073Q00A65DC17E152A5B03083Q00A1D333AA107A5D35026Q000840027Q004003043Q0066696E6403013Q003F03013Q002603023Q00C4F303043Q00489BCED203083Q00746F737472696E6703023Q006F7303043Q0074696D6503043Q007461736B03043Q0077616974026Q33C33F03093Q001A3B5001305263440B03053Q0053261A346E03053Q00041F334B5403043Q002638774703323Q00E0EC4ADF3542B3DA6AFA6544F6FB4DC42B53F7AF59963253F1AF48D72253B3A754DF2B5DB3EB5DD72119F1E357D52E53F7A603063Q0036938F38B64503093Q00D88EEB092QD994F14D03053Q00BFB6E19F29025Q00C07240031F3Q007363726970742055524C2072657475726E656420274E6F7420666F756E6427030E3Q00181F275A9F8FEA3E10035092B2EB03073Q00A24B724835EBE7033A3Q00B90E68A2430D853250F11316837C50EA5642803345E65610CC3550F1560E8A7C0CEC5607887C50EA56429E3945EE13118F2E4DF24742B90E68AB03063Q0062EC5C2482332Q033Q00737562026Q00794003053Q006C6F77657203113Q00A0161BB449A7B434E41F0DB349ADB16AE403083Q0050C4796CDA25C8D501CB3Q001249000100014Q008C000200033Q00265200010007000100010004553Q00070001001249000200014Q008C000300033Q001249000100023Q00265200010002000100020004553Q00020001001249000400013Q0026520004000A000100010004553Q000A000100265200020011000100020004553Q001100012Q008C000500054Q0077000600034Q003B000500033Q00265200020009000100010004553Q000900012Q003D00055Q001249000600033Q001249000700044Q004B0005000700022Q0077000300053Q001249000500023Q001249000600053Q001249000700023Q000482000500C40001001249000900014Q008C000A000D3Q002652000900B9000100060004553Q00B90001002652000A0045000100010004553Q00450001001249000E00013Q002652000E0027000100020004553Q00270001001249000A00023Q0004553Q00450001002652000E0023000100010004553Q002300012Q0077000B5Q000E1A00020043000100080004553Q004300012Q0077000F5Q00200600103Q0007001249001200083Q001249001300024Q0029001400014Q004B0010001400020006110010003700013Q0004553Q00370001001249001000093Q00069200100038000100010004553Q00380001001249001000084Q003D00115Q0012490012000A3Q0012490013000B4Q004B00110013000200122F0012000C3Q00122F0013000D3Q00203000130013000E2Q0099001300014Q004600123Q00022Q0077001300084Q0002000B000F0013001249000E00023Q0004553Q00230001002652000A004E000100060004553Q004E000100267B000800C3000100050004553Q00C3000100122F000E000F3Q002030000E000E0010001067000F001100082Q0064000E000200010004553Q00C30001002652000A0020000100020004553Q002000012Q003D000E00014Q0077000F000B4Q005C000E0002000F2Q0077000D000F4Q0077000C000E3Q000611000C00AE00013Q0004553Q00AE0001001249000E00014Q008C000F00103Q002652000E009E000100020004553Q009E00010020060011001000072Q003D00135Q001249001400123Q001249001500134Q004B001300150002001249001400024Q0029001500014Q004B0011001500020006920011006F000100010004553Q006F00010020060011001000072Q003D00135Q001249001400143Q001249001500154Q004B001300150002001249001400024Q0029001500014Q004B0011001500020006110011007A00013Q0004553Q007A00012Q008C001100114Q003D00125Q001249001300163Q001249001400174Q004B0012001400022Q003D001300024Q00770014000F4Q00730013000200022Q00020012001200132Q003B001100033Q0004553Q00B600010020060011001000072Q003D00135Q001249001400183Q001249001500194Q004B001300150002001249001400024Q0029001500014Q004B0011001500020006110011008B00013Q0004553Q008B00012Q00650011000F3Q00267B0011008B0001001A0004553Q008B00012Q008C001100113Q0012490012001B4Q003B001100033Q0004553Q00B600010020060011000F00072Q003D00135Q0012490014001C3Q0012490015001D4Q004B001300150002001249001400024Q0029001500014Q004B0011001500020006110011009C00013Q0004553Q009C00012Q008C001100114Q003D00125Q0012490013001E3Q0012490014001F4Q003A001200144Q001900115Q0004553Q00B600012Q0059000F00023Q0004553Q00B60001002652000E0059000100010004553Q0059000100122F0011000C4Q00770012000D4Q00730011000200022Q0077000F00113Q0020060011000F0020001249001300023Q001249001400214Q004B0011001400020020060011001100222Q00730011000200022Q0077001000113Q001249000E00023Q0004553Q005900010004553Q00B600012Q003D000E5Q001249000F00233Q001249001000244Q004B000E0010000200122F000F000C4Q00770010000D4Q0073000F000200022Q00020003000E000F001249000A00063Q0004553Q002000010004553Q00C30001002652000900BE000100010004553Q00BE0001001249000A00014Q008C000B000B3Q001249000900023Q0026520009001E000100020004553Q001E00012Q008C000C000D3Q001249000900063Q0004553Q001E00010004900005001C0001001249000200023Q0004553Q000900010004553Q000A00010004553Q000900010004553Q00CA00010004553Q000200012Q00783Q00017Q000A3Q00028Q00026Q00F03F03053Q007063612Q6C03043Q007479706503063Q0013671076450903073Q00EA6013621F2B6E034Q0003043Q0066696E64030E3Q0035125DC8B87AA3131D79C2B547A203073Q00EB667F32A7CC1200413Q0012493Q00014Q008C000100023Q0026523Q0007000100010004553Q00070001001249000100014Q008C000200023Q0012493Q00023Q0026523Q0002000100020004553Q00020001001249000300013Q0026520003000A000100010004553Q000A00010026520001001D000100010004553Q001D0001001249000400013Q00265200040013000100020004553Q00130001001249000100023Q0004553Q001D0001000E310001000F000100040004553Q000F00012Q008C000200023Q00122F000500033Q00065F00063Q000100022Q008F8Q00703Q00024Q0064000500020001001249000400023Q0004553Q000F0001000E3100020009000100010004553Q00090001001249000400013Q00265200040020000100010004553Q0020000100122F000500044Q0077000600024Q00730005000200022Q003D000600013Q001249000700053Q001249000800064Q004B00060008000200068000050038000100060004553Q0038000100263400020038000100070004553Q003800010020060005000200082Q003D000700013Q001249000800093Q0012490009000A4Q004B000700090002001249000800024Q0029000900014Q004B00050009000200069200050038000100010004553Q003800012Q0059000200024Q008C000500054Q0059000500023Q0004553Q002000010004553Q000900010004553Q000A00010004553Q000900010004553Q004000010004553Q000200012Q00783Q00013Q00013Q00023Q0003063Q00697366696C6503083Q007265616466696C65000D3Q00122F3Q00013Q0006113Q000C00013Q0004553Q000C000100122F3Q00014Q003D00016Q00733Q000200020006113Q000C00013Q0004553Q000C000100122F3Q00024Q003D00016Q00733Q000200022Q00053Q00014Q00783Q00017Q00013Q0003053Q007063612Q6C01063Q00122F000100013Q00065F00023Q000100022Q008F8Q00708Q00640001000200012Q00783Q00013Q00013Q00013Q0003093Q00777269746566696C6500083Q00122F3Q00013Q0006113Q000700013Q0004553Q0007000100122F3Q00014Q003D00016Q003D000200014Q006D3Q000200012Q00783Q00017Q00313Q0003063Q00697061697273026Q00F03F034Q00030C3Q001FB2F6314D3E442QFE265D7303063Q004E30C195432403093Q0055726C456E636F646503053Q00760B892Q1C03053Q0021507EE07803083Q00746F737472696E67030B3Q004C6F63616C506C6179657203063Q0055736572496403063Q00AAA014CD58B103053Q003C8CC863A403043Q007461736B03053Q00737061776E030D3Q008EF3C26533FABF0694BC97643C03083Q0076E09CE2165088D6028Q0003023Q006F7303053Q00636C6F636B025Q0080464003013Q00232Q033Q0073726303043Q007479706503083Q0044FB578356E7568E03043Q00E0228E3903113Q009EA9CAC933F01D22CBA685CE70E3541ECA03083Q006EBEC7A5BD13913D030A3Q006C6F6164737472696E6703043Q006C6F616403083Q00DCFE79EB9FCED5E503063Q00A7BA8B1788EB026Q007940030E3Q005AA68D1F0CB09A4D09B4810940F503043Q006D7AD5E803043Q00677375622Q033Q00ABF4E903043Q00508E97C203013Q00202Q033Q00737562025Q00805640030F3Q0043D5745E0AD6630C06D46543119C3703043Q002C63A6172Q033Q00652Q7203053Q007461626C6503063Q00636F6E6361742Q033Q003CEB6903063Q00C41C9749565303043Q0077616974010C013Q007600015Q00122F000200014Q003D00036Q005C0002000200040004553Q000800012Q0065000700013Q0020980007000700022Q001E00010007000600067400020005000100020004553Q000500012Q003D000200013Q00263400020029000100030004553Q002900012Q0065000200013Q0020980002000200022Q003D000300024Q003D000400033Q001249000500043Q001249000600054Q004B0004000600022Q003D000500043Q0020060005000500062Q003D000700014Q004B0005000700022Q003D000600033Q001249000700073Q001249000800084Q004B00060008000200122F000700094Q003D000800053Q00203000080008000A00203000080008000B2Q00730007000200022Q003D000800033Q0012490009000C3Q001249000A000D4Q004B0008000A00022Q003D000900064Q00180009000100022Q00020003000300092Q001E0001000200032Q007600026Q007600035Q00122F000400014Q0077000500014Q005C0004000200060004553Q003A000100122F0009000E3Q00203000090009000F00065F000A3Q000100062Q00703Q00034Q00703Q00074Q008F3Q00074Q00703Q00084Q00703Q00024Q008F3Q00034Q00640009000200012Q000100075Q0006740004002F000100020004553Q002F00012Q003D000400033Q001249000500103Q001249000600114Q004B000400060002001249000500123Q00122F000600133Q0020300006000600142Q00180006000100022Q007600076Q0065000800013Q00066E000500082Q0100080004553Q00082Q0100122F000800133Q0020300008000800142Q00180008000100022Q003800080008000600267B000800082Q0100150004553Q00082Q012Q0065000800033Q00066E000500042Q0100080004553Q00042Q010020980005000500022Q00970008000300052Q0097000900020008001249000A00163Q00122F000B00094Q0077000C00084Q0073000B000200022Q0002000A000A000B002030000B00090017000611000B00F100013Q0004553Q00F10001001249000B00124Q008C000C000D3Q002652000B006B000100120004553Q006B00012Q008C000E000F4Q0077000D000F4Q0077000C000E3Q0006113Q006A00013Q0004553Q006A00012Q0077000E5Q002030000F000900172Q005C000E0002000F2Q0077000D000F4Q0077000C000E3Q001249000B00023Q002652000B005E000100020004553Q005E00010006923Q00AA000100010004553Q00AA0001001249000E00124Q008C000F00113Q002652000E0076000100120004553Q00760001001249000F00124Q008C001000103Q001249000E00023Q002652000E0071000100020004553Q007100012Q008C001100113Q000E31000200910001000F0004553Q0091000100122F001200184Q0077001300114Q00730012000200022Q003D001300033Q001249001400193Q0012490015001A4Q004B00130015000200068000120087000100130004553Q008700012Q008C001200123Q0020300013000900172Q003B001200034Q0065001200073Q0020980012001200022Q00770013000A4Q003D001400033Q0012490015001B3Q0012490016001C4Q004B0014001600022Q00020013001300142Q001E0007001200130004553Q00FA0001002652000F0079000100120004553Q00790001001249001200123Q00265200120098000100020004553Q00980001001249000F00023Q0004553Q00790001000E3100120094000100120004553Q0094000100122F0013001D3Q0006070010009E000100130004553Q009E000100122F0010001E3Q000621001100A4000100100004553Q00A400012Q0077001300103Q0020300014000900172Q00730013000200022Q0077001100133Q001249001200023Q0004553Q009400010004553Q007900010004553Q00FA00010004553Q007100010004553Q00FA000100122F000E00184Q0077000F000C4Q0073000E000200022Q003D000F00033Q0012490010001F3Q001249001100204Q004B000F00110002000680000E00B70001000F0004553Q00B700012Q0077000E000C3Q002030000F000900172Q003B000E00033Q0004553Q00FA0001001249000E00124Q008C000F00103Q002652000E00BE000100120004553Q00BE0001001249000F00124Q008C001000103Q001249000E00023Q000E31000200B90001000E0004553Q00B90001002652000F00C0000100120004553Q00C0000100122F001100093Q0020300012000900172Q00730011000200022Q0077001000114Q0065001100103Q00267B001100DE000100210004553Q00DE00012Q0065001100073Q0020980011001100022Q00770012000A4Q003D001300033Q001249001400223Q001249001500234Q004B0013001500020020060014001000242Q003D001600033Q001249001700253Q001249001800264Q004B001600180002001249001700274Q004B001400170002002006001400140028001249001600023Q001249001700294Q004B0014001700022Q00020012001200142Q001E0007001100120004553Q00FA00012Q0065001100073Q0020980011001100022Q00770012000A4Q003D001300033Q0012490014002A3Q0012490015002B4Q004B00130015000200122F001400094Q00770015000D4Q00730014000200022Q00020012001200142Q001E0007001100120004553Q00FA00010004553Q00C000010004553Q00FA00010004553Q00B900010004553Q00FA00010004553Q005E00010004553Q00FA00012Q0065000B00073Q002098000B000B00022Q0077000C000A3Q001249000D00273Q00122F000E00093Q002030000F0009002C2Q0073000E000200022Q0002000C000C000E2Q001E0007000B000C00122F000B002D3Q002030000B000B002E2Q0077000C00074Q003D000D00033Q001249000E002F3Q001249000F00304Q003A000D000F4Q0046000B3Q00022Q00770004000B3Q0004553Q0045000100122F0008000E3Q0020300008000800312Q00940008000100010004553Q004500012Q008C000800094Q0077000A00044Q000A000800024Q00783Q00013Q00013Q00063Q00028Q00026Q00F03F2Q033Q0094E60703053Q00C2E79464462Q033Q00435ED303063Q00A8262CA1C39600233Q0012493Q00014Q008C000100023Q0026523Q000B000100020004553Q000B00012Q003D00036Q003D00046Q0065000400043Q0020980004000400022Q003D000500014Q001E0003000400050004553Q00220001000E310001000200013Q0004553Q000200012Q003D000300024Q003D000400034Q005C0003000200042Q0077000200044Q0077000100034Q003D000300044Q003D000400014Q007600053Q00022Q003D000600053Q001249000700033Q001249000800044Q004B0006000800022Q001E0005000600012Q003D000600053Q001249000700053Q001249000800064Q004B0006000800022Q001E0005000600022Q001E0003000400050012493Q00023Q0004553Q000200012Q00783Q00017Q002A3Q00028Q00026Q00F03F026Q000840030A3Q006C6F6164737472696E6703043Q006C6F6164031A3Q00F61B2C13974C1764B30B2803C2561736FF0C2814914C0A7FFD0403083Q001693634970E23878027Q004003113Q00BC7AF5FB81B774E6BE8EB778F2FC81BD3503053Q00EDD81582952Q033Q008D451F03073Q003EE22E2Q3FD0A903063Q00A51B4C971A1E03083Q003E857935E37F6D4F03083Q0036351BD9F38AF85003073Q00C270745295B6CE03083Q00746F737472696E67026Q00104003043Q007479706503083Q003FBD421BD4EB013703073Q006E59C82C78A08203043Q007761726E03213Q0090F046494C5E330D83D6497B03593E5FBDC6590656442948AAC0434741463E0DE303083Q002DCBA32B26232A5B03153Q009BC5916392BA5DDC829C2086AA5CD7819C2088B94D03073Q0034B2E5BC43E7C903083Q0027545E07E3552C2F03073Q004341213064973C03053Q007063612Q6C03083Q00D9F2A0DBE7D6E8A003053Q0093BF87CEB803023Q006F7303043Q0074696D65025Q00C0824003043Q007461736B03053Q00737061776E03023Q00CA3C03073Q00D2E448C6A1B833030F3Q003546FE007AC2334DB31372CD3E4CB303063Q00AE562993701303063Q001B02941F201C03083Q00CB3B60ED6B456F71003F012Q0012493Q00014Q008C000100063Q0026523Q0007000100010004553Q00070001001249000100014Q008C000200023Q0012493Q00023Q0026523Q00352Q0100030004553Q00352Q01000E3100010020000100010004553Q00200001001249000700013Q00265200070010000100020004553Q00100001001249000100023Q0004553Q002000010026520007000C000100010004553Q000C000100122F000800043Q00060700020016000100080004553Q0016000100122F000200053Q0006920002001E000100010004553Q001E00012Q008C000800084Q003D00095Q001249000A00063Q001249000B00074Q003A0009000B4Q001900085Q001249000700023Q0004553Q000C0001000E310008004E000100010004553Q004E0001001249000700013Q00265200070049000100010004553Q004900012Q003D000800014Q0077000900024Q005C00080002000A2Q00770006000A4Q0077000500094Q0077000400084Q003D000800024Q003D00095Q001249000A00093Q001249000B000A4Q004B0009000B00020006110004003E00013Q0004553Q003E00012Q003D000A5Q001249000B000B3Q001249000C000C4Q004B000A000C00022Q0065000B00054Q003D000C5Q001249000D000D3Q001249000E000E4Q004B000C000E00022Q0002000A000A000C000692000A0046000100010004553Q004600012Q003D000A5Q001249000B000F3Q001249000C00104Q004B000A000C000200122F000B00114Q0077000C00064Q0073000B000200022Q0002000A000A000B2Q000200090009000A2Q0064000800020001001249000700023Q000E3100020023000100070004553Q00230001001249000100033Q0004553Q004E00010004553Q002300010026520001009E000100030004553Q009E0001001249000700013Q00265200070055000100020004553Q00550001001249000100123Q0004553Q009E000100265200070051000100010004553Q005100010006110004006700013Q0004553Q00670001001249000800014Q008C000900093Q0026520008005B000100010004553Q005B0001001249000900013Q0026520009005E000100010004553Q005E00012Q003D000A00034Q0077000B00054Q0064000A000200012Q0059000400023Q0004553Q005E00010004553Q006700010004553Q005B00010006110003009C00013Q0004553Q009C0001001249000800014Q008C0009000A3Q00265200080096000100020004553Q009600010026520009006D000100010004553Q006D00012Q0077000B00024Q0077000C00034Q0073000B000200022Q0077000A000B3Q00122F000B00134Q0077000C000A4Q0073000B000200022Q003D000C5Q001249000D00143Q001249000E00154Q004B000C000E0002000680000B009C0001000C0004553Q009C0001001249000B00013Q002652000B007D000100010004553Q007D0001001249000C00013Q000E31000100800001000C0004553Q0080000100122F000D00164Q003D000E5Q001249000F00173Q001249001000184Q004B000E0010000200122F000F00114Q0077001000064Q0073000F000200022Q003D00105Q001249001100193Q0012490012001A4Q004B0010001200022Q0002000E000E00102Q0064000D000200012Q0059000A00023Q0004553Q008000010004553Q007D00010004553Q009C00010004553Q006D00010004553Q009C0001000E310001006B000100080004553Q006B0001001249000900014Q008C000A000A3Q001249000800023Q0004553Q006B0001001249000700023Q0004553Q00510001000E310002002E2Q0100010004553Q002E2Q012Q003D000700044Q00180007000100022Q0077000300074Q003D000700053Q0006110007002D2Q013Q0004553Q002D2Q010006110003002D2Q013Q0004553Q002D2Q01001249000700014Q008C000800093Q002652000700AF000100010004553Q00AF0001001249000800014Q008C000900093Q001249000700023Q002652000700AA000100020004553Q00AA0001000E310002000F2Q0100080004553Q000F2Q0100122F000A00134Q0077000B00094Q0073000A000200022Q003D000B5Q001249000C001B3Q001249000D001C4Q004B000B000D0002000636000A00C60001000B0004553Q00C60001001249000A00013Q002652000A00BD000100010004553Q00BD000100122F000B001D3Q00065F000C3Q000100012Q008F3Q00064Q0064000B000200012Q008C000300033Q0004553Q00C600010004553Q00BD000100122F000A00134Q0077000B00094Q0073000A000200022Q003D000B5Q001249000C001E3Q001249000D001F4Q004B000B000D0002000680000A002D2Q01000B0004553Q002D2Q01001249000A00014Q008C000B000C3Q000E31000200F70001000A0004553Q00F70001001249000D00013Q002652000D00D8000100020004553Q00D80001001249000A00083Q0004553Q00F70001000E31000100D40001000D0004553Q00D4000100122F000E001D3Q00065F000F0001000100022Q00703Q000B4Q00703Q000C4Q0064000E0002000100122F000E00203Q002030000E000E00212Q0018000E000100022Q0038000E000E000C000E23002200F50001000E0004553Q00F50001001249000E00013Q002652000E00E6000100010004553Q00E6000100122F000F001D3Q00065F00100002000100012Q00703Q000B4Q0064000F0002000100122F000F00233Q002030000F000F002400065F00100003000100032Q008F3Q00014Q00703Q00034Q008F3Q00034Q0064000F000200010004553Q00F500010004553Q00E60001001249000D00023Q0004553Q00D40001000E31000100092Q01000A0004553Q00092Q01001249000D00013Q002652000D00042Q0100010004553Q00042Q012Q003D000E00064Q003D000F5Q001249001000253Q001249001100264Q004B000F001100022Q0002000B000E000F001249000C00013Q001249000D00023Q002652000D00FA000100020004553Q00FA0001001249000A00023Q0004553Q00092Q010004553Q00FA0001002652000A00D1000100080004553Q00D100012Q0059000900023Q0004553Q00D100012Q0001000A5Q0004553Q002D2Q01002652000800B1000100010004553Q00B10001001249000A00013Q002652000A00252Q0100010004553Q00252Q012Q0077000B00024Q0077000C00034Q0073000B000200022Q00770009000B4Q003D000B00024Q003D000C5Q001249000D00273Q001249000E00284Q004B000C000E00022Q0065000D00034Q003D000E5Q001249000F00293Q0012490010002A4Q004B000E001000022Q0002000C000C000E2Q0064000B00020001001249000A00023Q002652000A00122Q0100020004553Q00122Q01001249000800023Q0004553Q00B100010004553Q00122Q010004553Q00B100010004553Q002D2Q010004553Q00AA0001001249000100083Q00265200010009000100120004553Q000900012Q008C000700074Q0077000800064Q003B000700033Q0004553Q000900010004553Q003E2Q010026523Q00392Q0100020004553Q00392Q012Q008C000300043Q0012493Q00083Q0026523Q0002000100080004553Q000200012Q008C000500063Q0012493Q00033Q0004553Q000200012Q00783Q00013Q00043Q00023Q0003073Q0064656C66696C6503063Q00697366696C65000F3Q00122F3Q00013Q0006113Q000E00013Q0004553Q000E000100122F3Q00023Q0006113Q000E00013Q0004553Q000E000100122F3Q00024Q003D00016Q00733Q000200020006113Q000E00013Q0004553Q000E000100122F3Q00014Q003D00016Q00643Q000200012Q00783Q00017Q00043Q0003063Q00697366696C6503083Q00746F6E756D62657203083Q007265616466696C65029Q00123Q00122F3Q00013Q0006113Q001100013Q0004553Q0011000100122F3Q00014Q003D00016Q00733Q000200020006113Q001100013Q0004553Q0011000100122F3Q00023Q00122F000100034Q003D00026Q000F000100024Q00465Q00020006923Q0010000100010004553Q001000010012493Q00044Q00053Q00014Q00783Q00017Q00043Q0003093Q00777269746566696C6503083Q00746F737472696E6703023Q006F7303043Q0074696D65000C3Q00122F3Q00013Q0006113Q000B00013Q0004553Q000B000100122F3Q00014Q003D00015Q00122F000200023Q00122F000300033Q0020300003000300042Q0099000300014Q001F00026Q004D5Q00012Q00783Q00017Q00023Q00028Q00026Q00F03F001E3Q0012493Q00014Q008C000100033Q0026523Q0017000100020004553Q001700012Q008C000300033Q00265200010005000100010004553Q000500012Q003D00046Q008C000500054Q005C0004000200052Q0077000300054Q0077000200043Q0006110003001D00013Q0004553Q001D00012Q003D000400013Q0006360003001D000100040004553Q001D00012Q003D000400024Q0077000500034Q00640004000200010004553Q001D00010004553Q000500010004553Q001D00010026523Q0002000100010004553Q00020001001249000100014Q008C000200023Q0012493Q00023Q0004553Q000200012Q00783Q00017Q00073Q0003073Q007374617274656403043Q00646F6E6503023Q00666E2Q033Q00652Q720003043Q007461736B03053Q00737061776E00174Q003D7Q0020305Q00010006113Q000500013Q0004553Q000500012Q00783Q00014Q003D8Q003D00016Q003D00026Q003D00036Q0029000400014Q002900056Q008C000600063Q00302A00030004000500106B00020003000600106B00010002000500106B3Q0001000400122F3Q00063Q0020305Q000700065F00013Q000100022Q008F3Q00014Q008F8Q00643Q000200012Q00783Q00013Q00013Q00063Q0003053Q007063612Q6C03023Q00666E2Q033Q00652Q7203083Q00746F737472696E6703043Q00646F6E652Q0100163Q00122F3Q00014Q003D00016Q005C3Q000200020006113Q000B00013Q0004553Q000B00012Q003D000300014Q003D000400014Q0077000500013Q00106B00040003000200106B0003000200050004553Q001300012Q003D000300014Q003D000400014Q008C000500053Q00122F000600044Q0077000700014Q007300060002000200106B00040003000600106B0003000200052Q003D000300013Q00302A0003000500062Q00783Q00017Q000F3Q00028Q00026Q00F03F03043Q00646F6E6503023Q006F7303053Q00636C6F636B025Q0080464003043Q007461736B03043Q007761697403023Q00666E2Q033Q00652Q72027Q004003083Q00746F737472696E6703073Q0073746172746564010003053Q007063612Q6C005C3Q0012493Q00014Q008C000100033Q000E310002001800013Q0004553Q001800012Q003D00045Q00203000040004000300069200040012000100010004553Q0012000100122F000400043Q0020300004000400052Q00180004000100022Q003800040004000100267B00040012000100060004553Q0012000100122F000400073Q0020300004000400082Q00940004000100010004553Q000400012Q003D00045Q0020300004000400092Q003D00055Q00203000030005000A2Q0077000200043Q0012493Q000B3Q0026523Q0021000100010004553Q002100012Q003D000400014Q009400040001000100122F000400043Q0020300004000400052Q00180004000100022Q0077000100043Q0012493Q00023Q000E31000B000200013Q0004553Q0002000100069200020057000100010004553Q00570001001249000400014Q008C000500083Q0026520004004D0001000B0004553Q004D000100265200050038000100020004553Q003800010006110006003100013Q0004553Q003100012Q0077000900074Q0077000300084Q0077000200093Q0004553Q005700012Q008C000900093Q00122F000A000C4Q0077000B00074Q0073000A000200022Q00770003000A4Q0077000200093Q0004553Q0057000100265200050029000100010004553Q00290001001249000900013Q00265200090046000100010004553Q004600012Q003D000A5Q00302A000A000D000E00122F000A000F4Q003D000B00024Q005C000A0002000C2Q00770008000C4Q00770007000B4Q00770006000A3Q001249000900023Q0026520009003B000100020004553Q003B0001001249000500023Q0004553Q002900010004553Q003B00010004553Q002900010004553Q00570001000E3100010052000100040004553Q00520001001249000500014Q008C000600063Q001249000400023Q00265200040027000100020004553Q002700012Q008C000700083Q0012490004000B3Q0004553Q002700012Q0077000400024Q0077000500034Q003B000400033Q0004553Q000200012Q00783Q00017Q000F3Q00028Q00026Q000840030C3Q0045AC2E1703F7B344AA3D1A0A03073Q009336CF5C7E7383026Q00F03F03043Q007761726E030D3Q0036023872026A05711D680F434D03063Q001E6D51551D6D03083Q00746F737472696E6703133Q00ED645AB83FD0FBBF7C55BF389EEFFC635DA62203073Q009C9F1134D656BE027Q004003053Q007063612Q6C030D3Q0095DCB0B3A1FBB5FC86FABF81EE03043Q00DCCE8FDD005C3Q0012493Q00014Q008C000100043Q0026523Q0006000100020004553Q000600012Q0029000500014Q0059000500023Q0026523Q0013000100010004553Q001300012Q003D00056Q00750005000100062Q0077000200064Q0077000100054Q003D000500014Q003D000600023Q001249000700033Q001249000800044Q003A000600084Q004D00053Q00010012493Q00053Q000E310005003900013Q0004553Q0039000100069200010032000100010004553Q00320001001249000500014Q008C000600063Q00265200050019000100010004553Q00190001001249000600013Q0026520006001C000100010004553Q001C0001001249000700013Q0026520007001F000100010004553Q001F000100122F000800064Q003D000900023Q001249000A00073Q001249000B00084Q004B0009000B000200122F000A00094Q0077000B00024Q0073000A000200022Q000200090009000A2Q00640008000200012Q002900086Q0077000900024Q003B000800033Q0004553Q001F00010004553Q001C00010004553Q003200010004553Q001900012Q003D000500014Q003D000600023Q0012490007000A3Q0012490008000B4Q003A000600084Q004D00053Q00010012493Q000C3Q0026523Q00020001000C0004553Q00020001001249000500013Q00265200050040000100050004553Q004000010012493Q00023Q0004553Q000200010026520005003C000100010004553Q003C000100122F0006000D4Q0077000700014Q005C0006000200072Q0077000400074Q0077000300063Q00069200030058000100010004553Q0058000100122F000600064Q003D000700023Q0012490008000E3Q0012490009000F4Q004B00070009000200122F000800094Q0077000900044Q00730008000200022Q00020007000700082Q00640006000200012Q002900065Q00122F000700094Q0077000800044Q000F000700084Q001900065Q001249000500053Q0004553Q003C00010004553Q000200012Q00783Q00017Q00013Q0003053Q007063612Q6C01063Q00122F000100013Q00065F00023Q000100022Q008F8Q00708Q00640001000200012Q00783Q00013Q00013Q00053Q0003093Q00777269746566696C6503083Q00746F737472696E6703023Q006F7303043Q0074696D6503013Q007C000F3Q00122F3Q00013Q0006113Q000E00013Q0004553Q000E000100122F3Q00014Q003D00015Q00122F000200023Q00122F000300033Q0020300003000300042Q0099000300014Q004600023Q0002001249000300054Q003D000400014Q00020002000200042Q006D3Q000200012Q00783Q00017Q00023Q00028Q0003053Q007063612Q6C01143Q001249000100014Q008C000200023Q00265200010002000100010004553Q00020001001249000200013Q00265200020005000100010004553Q0005000100122F000300023Q00065F00043Q000100022Q008F8Q00708Q00640003000200012Q003D000300014Q007700046Q00640003000200010004553Q001300010004553Q000500010004553Q001300010004553Q000200012Q00783Q00013Q00013Q00013Q0003093Q00777269746566696C6500083Q00122F3Q00013Q0006113Q000700013Q0004553Q0007000100122F3Q00014Q003D00016Q003D000200014Q006D3Q000200012Q00783Q00017Q00033Q00028Q00026Q00F03F03053Q007063612Q6C011E3Q001249000100014Q008C000200043Q00265200010007000100010004553Q00070001001249000200014Q008C000300033Q001249000100023Q00265200010002000100020004553Q000200012Q008C000400043Q0026520002000A000100010004553Q000A000100122F000500033Q00065F00063Q000100032Q00708Q008F8Q008F3Q00014Q005C0005000200062Q0077000400064Q0077000300053Q0006110003001800013Q0004553Q0018000100060700050019000100040004553Q001900012Q008C000500054Q0059000500023Q0004553Q000A00010004553Q001D00010004553Q000200012Q00783Q00013Q00013Q000C3Q00028Q00026Q00F03F027Q004003083Q00746F6E756D62657203023Q006F7303043Q0074696D6503063Q00697366696C6503083Q00746F737472696E6703083Q007265616466696C6503053Q006D61746368030C3Q00CBF64F1F3CB1E9F644503EBC03063Q009895DE6A7B1700553Q0012493Q00014Q008C000100033Q0026523Q0007000100010004553Q00070001001249000100014Q008C000200023Q0012493Q00023Q0026523Q0002000100020004553Q000200012Q008C000300033Q001249000400013Q0026520004002B000100010004553Q002B000100265200010023000100020004553Q00230001001249000500013Q00265200050014000100020004553Q00140001001249000100033Q0004553Q0023000100265200050010000100010004553Q0010000100122F000600044Q0077000700024Q00730006000200022Q0077000200063Q0006110002001F00013Q0004553Q001F00012Q003D00065Q00063600030021000100060004553Q002100012Q008C000600064Q0059000600023Q001249000500023Q0004553Q00100001000E310003002A000100010004553Q002A000100122F000500053Q0020300005000500062Q00180005000100022Q00380005000500022Q0059000500023Q001249000400023Q0026520004000B000100020004553Q000B00010026520001000A000100010004553Q000A0001001249000500013Q0026520005004A000100010004553Q004A000100122F000600073Q0006110006003A00013Q0004553Q003A000100122F000600074Q003D000700014Q00730006000200020006920006003C000100010004553Q003C00012Q008C000600064Q0059000600023Q00122F000600083Q00122F000700094Q003D000800014Q000F000700084Q004600063Q000200200600060006000A2Q003D000800023Q0012490009000B3Q001249000A000C4Q003A0008000A4Q008800063Q00072Q0077000300074Q0077000200063Q001249000500023Q00265200050030000100020004553Q00300001001249000100023Q0004553Q000A00010004553Q003000010004553Q000A00010004553Q000B00010004553Q000A00010004553Q005400010004553Q000200012Q00783Q00017Q00033Q00029Q00025Q0020AC4001144Q003D00015Q00268700010005000100010004553Q000500012Q002900016Q0059000100024Q003D000100014Q007700026Q007300010002000200263400010010000100020004553Q00100001000E2300010010000100010004553Q001000012Q003D00025Q00204A00020002000300062500010011000100020004553Q001100012Q001400026Q0029000200014Q0059000200024Q00783Q00017Q00073Q0003063Q00697366696C6503083Q00746F737472696E6703083Q007265616466696C6503043Q006773756203023Q00983503053Q00D5BD469623035Q00163Q00122F3Q00013Q0006113Q001500013Q0004553Q0015000100122F3Q00014Q003D00016Q00733Q000200020006113Q001500013Q0004553Q0015000100122F3Q00023Q00122F000100034Q003D00026Q000F000100024Q00465Q00020020065Q00042Q003D000200023Q001249000300053Q001249000400064Q004B000200040002001249000300074Q004B3Q000300022Q00053Q00014Q00783Q00017Q00063Q00028Q00026Q00F03F03063Q00506172656E7403083Q00496E7374616E63652Q033Q006E657703053Q00706169727303223Q001249000300014Q008C000400043Q001249000500013Q00265200050003000100010004553Q000300010026520003000F000100020004553Q000F0001001249000600013Q00265200060008000100010004553Q000800010006110002000D00013Q0004553Q000D000100106B0004000300022Q0059000400023Q0004553Q0008000100265200030002000100010004553Q0002000100122F000600043Q0020300006000600052Q007700076Q00730006000200022Q0077000400063Q00122F000600064Q0077000700014Q005C0006000200080004553Q001B00012Q001E00040009000A0006740006001A000100020004553Q001A0001001249000300023Q0004553Q000200010004553Q000300010004553Q000200012Q00783Q00017Q00073Q0003083Q00F3119A39AB0CC32A03063Q0062A658D956D9030C3Q00D5F96B0F83CEC4F77D0893CF03063Q00BC2Q961961E603043Q005544696D2Q033Q006E6577028Q0002144Q003D00026Q003D000300013Q001249000400013Q001249000500024Q004B0003000500022Q007600043Q00012Q003D000500013Q001249000600033Q001249000700044Q004B00050007000200122F000600053Q002030000600060006001249000700074Q0077000800014Q004B0006000800022Q001E0004000500062Q007700056Q004F000200054Q001900026Q00783Q00017Q000C3Q0003083Q00EFA06C161EE2D18C03063Q008DBAE93F626C03053Q00D2E520B93703053Q0045918A4CD603093Q0044C7808AB41875DC9A03063Q007610AF2QE9DF026Q00F03F030F3Q00AA9425B7F7B869998B3EBEC384798E03073Q001DEBE455DB8EEB03043Q00456E756D030F3Q00412Q706C795374726F6B654D6F646503063Q00426F72646572031F4Q003D00036Q003D000400013Q001249000500013Q001249000600024Q004B0004000600022Q007600053Q00032Q003D000600013Q001249000700033Q001249000800044Q004B0006000800022Q001E0005000600012Q003D000600013Q001249000700053Q001249000800064Q004B00060008000200060700070012000100020004553Q00120001001249000700074Q001E0005000600072Q003D000600013Q001249000700083Q001249000800094Q004B00060008000200122F0007000A3Q00203000070007000B00203000070007000C2Q001E0005000600072Q007700066Q004F000300064Q001900036Q00783Q00017Q00093Q0003063Q0043726561746503093Q0054772Q656E496E666F2Q033Q006E657703043Q00456E756D030B3Q00456173696E675374796C6503043Q0051756164030F3Q00456173696E67446972656374696F6E2Q033Q004F757403043Q00506C617905164Q003D00055Q0020060005000500012Q007700075Q00122F000800023Q0020300008000800032Q0077000900013Q000607000A000B000100030004553Q000B000100122F000A00043Q002030000A000A0005002030000A000A0006000607000B0010000100040004553Q0010000100122F000B00043Q002030000B000B0007002030000B000B00082Q004B0008000B00022Q0077000900024Q004B0005000900020020060005000500092Q00640005000200012Q00783Q00017Q00023Q002Q033Q0073796E030B3Q0070726F746563745F677569000C3Q00122F3Q00013Q0006113Q000B00013Q0004553Q000B000100122F3Q00013Q0020305Q00020006113Q000B00013Q0004553Q000B000100122F3Q00013Q0020305Q00022Q003D00016Q00643Q000200012Q00783Q00017Q00053Q0003063Q006970616972732Q033Q0062746E03043Q005465787403053Q00676C797068034Q00010F3Q00122F000100014Q003D00026Q005C0001000200030004553Q000C00010020300006000500020006113Q000A00013Q0004553Q000A00010020300007000500040006920007000B000100010004553Q000B0001001249000700053Q00106B00060003000700067400010004000100020004553Q000400012Q00783Q00017Q00023Q00028Q00026Q00F03F000C3Q0012493Q00013Q0026523Q0001000100010004553Q000100012Q003D00015Q0020980001000100022Q000500016Q003D000100014Q0029000200014Q00640001000200010004553Q000B00010004553Q000100012Q00783Q00017Q00043Q00026Q00F03F03043Q007461736B03053Q0064656C617902B81E85EB51B8AE3F000C4Q003D7Q0020035Q00012Q00057Q00122F3Q00023Q0020305Q0003001249000100043Q00065F00023Q000100032Q008F8Q008F3Q00014Q008F3Q00024Q006D3Q000200012Q00783Q00013Q00013Q00023Q00028Q0003063Q00506172656E7400124Q003D7Q0026873Q0011000100010004553Q001100012Q003D3Q00013Q0020305Q00020006113Q001100013Q0004553Q001100010012493Q00013Q0026523Q0008000100010004553Q00080001001249000100014Q000500016Q003D000100024Q002900026Q00640001000200010004553Q001100010004553Q000800012Q00783Q00017Q00143Q00028Q00026Q00F03F03043Q007461736B03053Q0064656C6179029A5Q99C93F03073Q0056697369626C65010002295C8FC2F528CC3F03043Q003CA6B41603083Q00B16FCFCE739F888C03053Q005544696D32030A3Q0066726F6D4F2Q6673657403043Q00456E756D030B3Q00456173696E675374796C6503053Q005175696E742Q0102A4703D0AD7A3D03F03043Q0036800A1103073Q003F65E97074B42F02B81E85EB51B8BE3F01593Q001249000100014Q008C000200023Q00265200010002000100010004553Q00020001001249000200013Q00265200020005000100010004553Q000500012Q00057Q0006113Q002F00013Q0004553Q002F0001001249000300013Q00265200030016000100020004553Q0016000100122F000400033Q002030000400040004001249000500053Q00065F00063Q000100032Q008F8Q008F3Q00014Q008F3Q00024Q006D0004000600010004553Q00580001000E310001000B000100030004553Q000B00012Q003D000400033Q00302A0004000600072Q003D000400044Q003D000500053Q001249000600084Q007600073Q00012Q003D000800063Q001249000900093Q001249000A000A4Q004B0008000A000200122F0009000B3Q00203000090009000C2Q003D000A00074Q003D000B00084Q004B0009000B00022Q001E00070008000900122F0008000D3Q00203000080008000E00203000080008000F2Q006D000400080001001249000300023Q0004553Q000B00010004553Q00580001001249000300013Q00265200030037000100010004553Q003700012Q003D000400013Q00302A0004000600102Q003D000400023Q00302A000400060010001249000300023Q00265200030030000100020004553Q003000012Q003D000400044Q003D000500053Q001249000600114Q007600073Q00012Q003D000800063Q001249000900123Q001249000A00134Q004B0008000A000200122F0009000B3Q00203000090009000C2Q003D000A00074Q003D000B00094Q004B0009000B00022Q001E00070008000900122F0008000D3Q00203000080008000E00203000080008000F2Q006D00040008000100122F000400033Q002030000400040004001249000500143Q00065F00060001000100022Q008F8Q008F3Q00034Q006D0004000600010004553Q005800010004553Q003000010004553Q005800010004553Q000500010004553Q005800010004553Q000200012Q00783Q00013Q00023Q00023Q0003073Q0056697369626C65012Q00084Q003D7Q0006113Q000700013Q0004553Q000700012Q003D3Q00013Q00302A3Q000100022Q003D3Q00023Q00302A3Q000100022Q00783Q00017Q00023Q0003073Q0056697369626C652Q0100064Q003D7Q0006923Q0005000100010004553Q000500012Q003D3Q00013Q00302A3Q000100022Q00783Q00017Q00093Q00028Q00026Q00F03F03073Q0044657374726F79027B14AE47E17AC43F03053Q00F038EC1EFD03063Q0056A35B8D72980214AE47E17A14EE3F03043Q007461736B03043Q007761697400223Q0012493Q00013Q0026523Q0007000100020004553Q000700012Q003D00015Q0020060001000100032Q00640001000200010004553Q002100010026523Q0001000100010004553Q00010001001249000100013Q000E310001001B000100010004553Q001B00012Q003D000200014Q003D000300023Q001249000400044Q007600053Q00012Q003D000600033Q001249000700053Q001249000800064Q004B00060008000200202D0005000600072Q006D00020005000100122F000200083Q002030000200020009001249000300044Q0064000200020001001249000100023Q0026520001000A000100020004553Q000A00010012493Q00023Q0004553Q000100010004553Q000A00010004553Q000100012Q00783Q00019Q003Q00054Q003D8Q003D000100014Q002C000100014Q00643Q000200012Q00783Q00019Q003Q00074Q003D7Q0006113Q000600013Q0004553Q000600012Q003D3Q00014Q002900016Q00643Q000200012Q00783Q00017Q000C3Q00028Q00026Q00F03F03083Q00506F736974696F6E03073Q004368616E67656403073Q00436F2Q6E656374030D3Q0055736572496E7075745479706503043Q00456E756D030C3Q004D6F75736542752Q746F6E3103053Q00546F75636803013Q005803103Q004162736F6C757465506F736974696F6E026Q00534001343Q001249000100013Q00265200010011000100020004553Q001100012Q0029000200013Q00203000033Q00032Q003D000400033Q0020300004000400032Q0005000400024Q0005000300014Q000500025Q00203000023Q000400200600020002000500065F00043Q000100022Q00708Q008F8Q006D0002000400010004553Q0033000100265200010001000100010004553Q00010001001249000200013Q0026520002002D000100010004553Q002D000100203000033Q000600122F000400073Q00203000040004000600203000040004000800063600030023000100040004553Q0023000100203000033Q000600122F000400073Q00203000040004000600203000040004000900063600030023000100040004553Q002300012Q00783Q00013Q00203000033Q000300203000030003000A2Q003D000400043Q00203000040004000B00203000040004000A2Q003800030003000400267B0003002C0001000C0004553Q002C00012Q00783Q00013Q001249000200023Q000E3100020014000100020004553Q00140001001249000100023Q0004553Q000100010004553Q001400010004553Q000100012Q00783Q00013Q00013Q00033Q00030E3Q0055736572496E707574537461746503043Q00456E756D2Q033Q00456E64000A4Q003D7Q0020305Q000100122F000100023Q0020300001000100010020300001000100030006803Q0009000100010004553Q000900012Q00298Q00053Q00014Q00783Q00017Q000D3Q00030D3Q0055736572496E7075745479706503043Q00456E756D030D3Q004D6F7573654D6F76656D656E7403053Q00546F756368028Q00026Q00F03F03083Q00506F736974696F6E03053Q005544696D322Q033Q006E657703013Q005803053Q005363616C6503063Q004F2Q6673657403013Q005901374Q003D00015Q0006110001003600013Q0004553Q0036000100203000013Q000100122F000200023Q0020300002000200010020300002000200030006360001000F000100020004553Q000F000100203000013Q000100122F000200023Q00203000020002000100203000020002000400068000010036000100020004553Q00360001001249000100054Q008C000200033Q00265200010030000100060004553Q0030000100265200020013000100050004553Q0013000100203000043Q00072Q003D000500014Q00380003000400052Q003D000400023Q00122F000500083Q0020300005000500092Q003D000600033Q00203000060006000A00203000060006000B2Q003D000700033Q00203000070007000A00203000070007000C00203000080003000A2Q00510007000700082Q003D000800033Q00203000080008000D00203000080008000B2Q003D000900033Q00203000090009000D00203000090009000C002030000A0003000D2Q005100090009000A2Q004B00050009000200106B0004000700050004553Q003600010004553Q001300010004553Q0036000100265200010011000100050004553Q00110001001249000200054Q008C000300033Q001249000100063Q0004553Q001100012Q00783Q00017Q00013Q00030A3Q00446973636F2Q6E65637400044Q003D7Q0020065Q00012Q00643Q000200012Q00783Q00017Q001A3Q0003093Q00D201392D600678E30803073Q001A866441592C6703163Q00D3E23328A3E3EC252DA0C5F1312DB7E1E22226AAF2FA03053Q00C491835043026Q00F03F03083Q002EBF15010CE111BE03063Q00887ED066687803053Q005544696D322Q033Q006E6577028Q00026Q00384003043Q004B83D44603083Q003118EAAE23CF325D026Q0048C0026Q00184003043Q0038F7E59C03053Q00116C929DE803083Q007FC60CF91CA151C603063Q00C82BA3748D4F030A3Q008B33259793FBEFB0246E03073Q0083DF565DE3D09403043Q00C54AB8A203063Q00D583252QD67D030B3Q00122E3DABD6342A35AFE42203053Q0081464B45DF2Q0105404Q003D00056Q003D000600013Q001249000700013Q001249000800024Q004B0006000800022Q007600073Q00082Q003D000800013Q001249000900033Q001249000A00044Q004B0008000A000200202D0007000800052Q003D000800013Q001249000900063Q001249000A00074Q004B0008000A000200122F000900083Q002030000900090009001249000A000A3Q001249000B000B3Q001249000C000A4Q0077000D00024Q004B0009000D00022Q001E0007000800092Q003D000800013Q0012490009000C3Q001249000A000D4Q004B0008000A000200122F000900083Q002030000900090009001249000A00053Q001249000B000E3Q001249000C000A3Q002098000D0001000F2Q004B0009000D00022Q001E0007000800092Q003D000800013Q001249000900103Q001249000A00114Q004B0008000A00022Q001E000700084Q003D000800013Q001249000900123Q001249000A00134Q004B0008000A00022Q001E0007000800012Q003D000800013Q001249000900143Q001249000A00154Q004B0008000A00022Q001E0007000800032Q003D000800013Q001249000900163Q001249000A00174Q004B0008000A00022Q001E0007000800042Q003D000800013Q001249000900183Q001249000A00194Q004B0008000A000200202D00070008001A2Q003D000800024Q004F000500084Q001900056Q00783Q00017Q00013Q0003053Q007063612Q6C000B3Q00122F3Q00013Q00065F00013Q000100072Q008F8Q008F3Q00014Q008F3Q00024Q008F3Q00034Q008F3Q00044Q008F3Q00054Q008F3Q00064Q00643Q000200012Q00783Q00013Q00013Q00123Q00028Q00030E3Q00676574637573746F6D612Q736574030B3Q0067657473796E612Q73657403093Q00777269746566696C65026Q00F03F027Q004003063Q00506172656E7403053Q00496D61676503073Q0056697369626C653Q010003063Q00697366696C6503093Q00574FECCD09185B164403073Q002B782383AA66362Q033Q00737562026Q0010402Q033Q006428A003073Q00E43466E7D6C5D000713Q0012493Q00014Q008C000100023Q0026523Q000F000100010004553Q000F000100122F000300023Q00060700010008000100030004553Q0008000100122F000100033Q00122F000300043Q0006110003000D00013Q0004553Q000D00010006920001000E000100010004553Q000E00012Q00783Q00013Q0012493Q00053Q0026523Q0032000100060004553Q003200012Q003D00035Q0020300003000300070006110003007000013Q0004553Q00700001001249000300014Q008C000400043Q000E3100010017000100030004553Q00170001001249000400013Q00265200040029000100010004553Q00290001001249000500013Q00265200050021000100050004553Q00210001001249000400053Q0004553Q002900010026520005001D000100010004553Q001D00012Q003D000600013Q00106B0006000800022Q003D000600013Q00302A00060009000A001249000500053Q0004553Q001D00010026520004001A000100050004553Q001A00012Q003D000500023Q00302A00050009000B0004553Q007000010004553Q001A00010004553Q007000010004553Q001700010004553Q007000010026523Q0002000100050004553Q0002000100122F0003000C3Q0006110003003C00013Q0004553Q003C000100122F0003000C4Q003D000400034Q00730003000200020006920003006A000100010004553Q006A0001001249000300014Q008C000400063Q00265200030064000100050004553Q006400012Q008C000600063Q00265200040048000100050004553Q0048000100122F000700044Q003D000800034Q0077000900064Q006D0007000900010004553Q006A000100265200040041000100010004553Q004100012Q003D000700044Q003D000800054Q003D000900063Q001249000A000D3Q001249000B000E4Q004B0009000B00022Q00020008000800092Q005C0007000200082Q0077000600084Q0077000500073Q0006110005006000013Q0004553Q0060000100200600070006000F001249000900063Q001249000A00104Q004B0007000A00022Q003D000800063Q001249000900113Q001249000A00124Q004B0008000A000200063600070061000100080004553Q006100012Q00783Q00013Q001249000400053Q0004553Q004100010004553Q006A0001000E310001003E000100030004553Q003E0001001249000400014Q008C000500053Q001249000300053Q0004553Q003E00012Q0077000300014Q003D000400034Q00730003000200022Q0077000200033Q0012493Q00063Q0004553Q000200012Q00783Q00017Q00043Q00026Q33C33F03053Q00E7C24B33E003073Q0095A4AD275C926E03083Q00726564486F766572000D4Q003D8Q003D000100013Q001249000200014Q007600033Q00012Q003D000400023Q001249000500023Q001249000600034Q004B0004000600022Q003D000500033Q0020300005000500042Q001E0003000400052Q006D3Q000300012Q00783Q00017Q00043Q00026Q33C33F03053Q00D0281C100803063Q007B9347707F7A03043Q006C696E65000D4Q003D8Q003D000100013Q001249000200014Q007600033Q00012Q003D000400023Q001249000500023Q001249000600034Q004B0004000600022Q003D000500033Q0020300005000500042Q001E0003000400052Q006D3Q000300012Q00783Q00017Q00243Q00028Q00026Q000840026Q00F03F027Q0040030A3Q004D6F757365456E74657203073Q00436F2Q6E656374030A3Q004D6F7573654C65617665030A3Q008CBD04289AAD0828B7B603043Q005C2QD87C03083Q006B3DBF49E9523DA203053Q009D3B52CC2003043Q000B37F9FF03083Q00D1585E839A898AB303103Q000AA0C77719313E3726A5E773122C237103083Q004248C1A41C7E4351030F3Q00C639BC570463F338A7560579EB23BA03063Q0016874CC838460100030F3Q00AF3FEA2058F3BE39E2216DE89535F403063Q0081ED5098443D03043Q0065AD1CE703073Q003831C864937C77030A3Q00F83BA7E4EF31B3FFDE6D03043Q0090AC5EDF03043Q007465787403083Q00100ABA531706B84203043Q0027446FC2026Q002A4003043Q00F0A9E9D303063Q00D7B6C687A71903043Q00456E756D03043Q00466F6E74030C3Q00476F7468616D4D656469756D026Q00204003103Q004D6F75736542752Q746F6E31446F776E030E3Q004D6F75736542752Q746F6E315570088B3Q001249000800014Q008C000900093Q001249000A00013Q002652000A0024000100010004553Q00240001000E3100020008000100080004553Q000800012Q0059000900023Q00265200080023000100030004553Q00230001001249000B00013Q002652000B000F000100030004553Q000F0001001249000800043Q0004553Q00230001002652000B000B000100010004553Q000B0001002030000C00090005002006000C000C000600065F000E3Q000100042Q008F8Q00703Q00094Q008F3Q00014Q00703Q00044Q006D000C000E0001002030000C00090007002006000C000C000600065F000E0001000100042Q008F8Q00703Q00094Q008F3Q00014Q00703Q00034Q006D000C000E0001001249000B00033Q0004553Q000B0001001249000A00033Q000E31000300030001000A0004553Q0003000100265200080074000100010004553Q00740001001249000B00013Q002652000B006F000100010004553Q006F00012Q003D000C00024Q003D000D00013Q001249000E00083Q001249000F00094Q004B000D000F00022Q0076000E3Q00092Q003D000F00013Q0012490010000A3Q0012490011000B4Q004B000F001100022Q001E000E000F00012Q003D000F00013Q0012490010000C3Q0012490011000D4Q004B000F001100022Q001E000E000F00022Q003D000F00013Q0012490010000E3Q0012490011000F4Q004B000F001100022Q001E000E000F00032Q003D000F00013Q001249001000103Q001249001100114Q004B000F0011000200202D000E000F00122Q003D000F00013Q001249001000133Q001249001100144Q004B000F0011000200202D000E000F00012Q003D000F00013Q001249001000153Q001249001100164Q004B000F001100022Q001E000E000F4Q003D000F00013Q001249001000173Q001249001100184Q004B000F0011000200060700100057000100060004553Q005700012Q003D001000033Q0020300010001000192Q001E000E000F00102Q003D000F00013Q0012490010001A3Q0012490011001B4Q004B000F0011000200202D000E000F001C2Q003D000F00013Q0012490010001D3Q0012490011001E4Q004B000F0011000200060700100066000100070004553Q0066000100122F0010001F3Q0020300010001000200020300010001000212Q001E000E000F00102Q003D000F00044Q004B000C000F00022Q00770009000C4Q003D000C00054Q0077000D00093Q001249000E00224Q006D000C000E0001001249000B00033Q002652000B0029000100030004553Q00290001001249000800033Q0004553Q007400010004553Q0029000100265200080002000100040004553Q00020001002030000B00090023002006000B000B000600065F000D0002000100042Q008F8Q00703Q00094Q008F3Q00014Q00703Q00054Q006D000B000D0001002030000B00090024002006000B000B000600065F000D0003000100042Q008F8Q00703Q00094Q008F3Q00014Q00703Q00044Q006D000B000D0001001249000800023Q0004553Q000200010004553Q000300010004553Q000200012Q00783Q00013Q00043Q00033Q0002B81E85EB51B8BE3F03103Q00EECC817A41DEC2977F42EFC28E7E549F03053Q0026ACADE211000C4Q003D8Q003D000100013Q001249000200014Q007600033Q00012Q003D000400023Q001249000500023Q001249000600034Q004B0004000600022Q003D000500034Q001E0003000400052Q006D3Q000300012Q00783Q00017Q00033Q0002B81E85EB51B8BE3F03103Q006F102FE44A0323FA43150FE0411E3EBC03043Q008F2D714C000C4Q003D8Q003D000100013Q001249000200014Q007600033Q00012Q003D000400023Q001249000500023Q001249000600034Q004B0004000600022Q003D000500034Q001E0003000400052Q006D3Q000300012Q00783Q00017Q00033Q0002B81E85EB51B8AE3F03103Q00AF48E9438A5BE55D834DC9478146F81B03043Q0028ED298A000C4Q003D8Q003D000100013Q001249000200014Q007600033Q00012Q003D000400023Q001249000500023Q001249000600034Q004B0004000600022Q003D000500034Q001E0003000400052Q006D3Q000300012Q00783Q00017Q00033Q00029A5Q99B93F03103Q00E575F9F34DD57BEFF64EE47BF6F7589403053Q002AA7149A98000C4Q003D8Q003D000100013Q001249000200014Q007600033Q00012Q003D000400023Q001249000500023Q001249000600034Q004B0004000600022Q003D000500034Q001E0003000400052Q006D3Q000300012Q00783Q00017Q00053Q00028Q0003043Q0054657874030A3Q0054657874436F6C6F723303043Q00672Q6F642Q033Q0062616402183Q001249000200014Q008C000300033Q00265200020002000100010004553Q00020001001249000300013Q00265200030005000100010004553Q000500012Q003D00045Q00106B000400024Q003D00045Q0006110001001000013Q0004553Q001000012Q003D000500013Q00203000050005000400069200050012000100010004553Q001200012Q003D000500013Q00203000050005000500106B0004000300050004553Q001700010004553Q000500010004553Q001700010004553Q000200012Q00783Q00017Q00043Q00028Q0003053Q007063612Q6C03253Q003614301375F22B0A143B1C74B10B0A1830583CE5642Q137E013AE4365A1F2C1722E221085303073Q00447A7D5E78559100183Q0012493Q00014Q008C000100013Q0026523Q0002000100010004553Q0002000100122F000200023Q00065F00033Q000100012Q008F8Q00730002000200022Q0077000100024Q003D000200013Q0006110001001200013Q0004553Q001200012Q003D000300023Q001249000400033Q001249000500044Q004B00030005000200069200030013000100010004553Q001300012Q003D00036Q0077000400014Q006D0002000400010004553Q001700010004553Q000200012Q00783Q00013Q00013Q00013Q00030C3Q00736574636C6970626F61726400043Q00122F3Q00014Q003D00016Q00643Q000200012Q00783Q00017Q00043Q00028Q0003053Q007063612Q6C03143Q003315DC5DC7CBBE5710C650C399B9180CC65BCC9803073Q00DA777CAF3EA8B900183Q0012493Q00014Q008C000100013Q0026523Q0002000100010004553Q0002000100122F000200023Q00065F00033Q000100012Q008F8Q00730002000200022Q0077000100024Q003D000200013Q0006110001001200013Q0004553Q001200012Q003D000300023Q001249000400033Q001249000500044Q004B00030005000200069200030013000100010004553Q001300012Q003D00036Q0077000400014Q006D0002000400010004553Q001700010004553Q000200012Q00783Q00013Q00013Q00013Q00030C3Q00736574636C6970626F61726400043Q00122F3Q00014Q003D00016Q00643Q000200012Q00783Q00017Q00263Q00028Q00027Q0040026Q000840026Q00104003053Q007063612Q6C03043Q007761726E030D3Q009EC345CBAAE440848DE54AF9E503043Q00A4C5902803083Q00746F737472696E67026Q00F03F03043Q007461736B03043Q0077616974029A5Q99B93F03073Q0044657374726F79030D3Q00B8C3A784D2A28BB0829EDF8BC303063Q00D6E390CAEBBD030D3Q00C1AA867F50B55235E1A083215003083Q005C8DC5E71B70D33303053Q00D5FC8BAFD403053Q00B1869FEAC30214AE47E17A14EE3F030C3Q00AEEE2DB6CCAFAB3AB2DBB2F903053Q00A9DD8B5FC003173Q00ED8E6D2927349E8E6D2Q2D3492CB6B2D3B66DF8C7E362C03063Q0046BEEB1F5F42030D3Q0093EC0CE7E9B3E65AEDE0A3B85A03053Q0085DA827A8603153Q00172QFA84CAA23435FBA284F0AC3938F6EDC392ED7603073Q00585C9F83A4BCC3030F3Q00A326BA48DCE2D3876EB44ECEA593CE03073Q00BDE04EDF2BB78B03043Q005465787403043Q006773756203023Q006BEF03053Q00A14E9CEA76034Q00031B3Q0097BBCCDDB4B289CCA6A4DDD9E7AEC6C9B5F7C2D9BEF7CFD5B5A4DD03043Q00BCC7D7A900D83Q0012493Q00014Q008C000100083Q0026523Q0006000100020004553Q000600012Q008C000500063Q0012493Q00033Q0026523Q00C9000100040004553Q00C900010026520001001C000100040004553Q001C000100122F000900054Q0077000A00054Q005C00090002000A2Q00770008000A4Q0077000700093Q000692000700D7000100010004553Q00D7000100122F000900064Q003D000A5Q001249000B00073Q001249000C00084Q004B000A000C000200122F000B00094Q0077000C00084Q0073000B000200022Q0002000A000A000B2Q00640009000200010004553Q00D70001000E3100030067000100010004553Q00670001001249000900013Q000E3100020023000100090004553Q00230001001249000100043Q0004553Q006700010026520009002D0001000A0004553Q002D000100122F000A000B3Q002030000A000A000C001249000B000D4Q0064000A000200012Q003D000A00013Q002006000A000A000E2Q0064000A00020001001249000900023Q0026520009001F000100010004553Q001F00010006920005005B000100010004553Q005B0001001249000A00014Q008C000B000B3Q002652000A0033000100010004553Q00330001001249000B00013Q001249000C00013Q002652000C0037000100010004553Q00370001002652000B0048000100010004553Q004800012Q0029000D6Q0005000D00023Q00122F000D00064Q003D000E5Q001249000F000F3Q001249001000104Q004B000E0010000200122F000F00094Q0077001000064Q0073000F000200022Q0002000E000E000F2Q0064000D00020001001249000B000A3Q002652000B00360001000A0004553Q003600012Q003D000D00034Q003D000E5Q001249000F00113Q001249001000124Q004B000E0010000200122F000F00094Q0077001000064Q0073000F000200022Q0002000E000E000F2Q0029000F6Q004F000D000F4Q0019000D5Q0004553Q003600010004553Q003700010004553Q003600010004553Q005B00010004553Q003300012Q003D000A00044Q003D000B00053Q001249000C000D4Q0076000D3Q00012Q003D000E5Q001249000F00133Q001249001000144Q004B000E0010000200202D000D000E00152Q006D000A000D00010012490009000A3Q0004553Q001F000100265200010096000100020004553Q0096000100069200030087000100010004553Q008700012Q002900096Q0005000900024Q003D00095Q001249000A00163Q001249000B00174Q004B0009000B00020006800004007B000100090004553Q007B00012Q003D000900034Q003D000A5Q001249000B00183Q001249000C00194Q004B000A000C00022Q0029000B6Q004F0009000B4Q001900096Q003D000900034Q003D000A5Q001249000B001A3Q001249000C001B4Q004B000A000C000200122F000B00094Q0077000C00044Q0073000B000200022Q0002000A000A000B2Q0029000B6Q004F0009000B4Q001900096Q003D000900064Q0077000A00024Q00640009000200012Q003D000900034Q003D000A5Q001249000B001C3Q001249000C001D4Q004B000A000C00022Q0029000B00014Q006D0009000B00012Q003D000900074Q007500090001000A2Q00770006000A4Q0077000500093Q001249000100033Q002652000100A80001000A0004553Q00A800012Q003D000900034Q003D000A5Q001249000B001E3Q001249000C001F4Q004B000A000C00022Q0029000B00014Q006D0009000B00012Q0005000200084Q003D000900094Q00940009000100012Q003D0009000A4Q0077000A00024Q005C00090002000A2Q00770004000A4Q0077000300093Q001249000100023Q00265200010008000100010004553Q000800012Q003D000900023Q000611000900AE00013Q0004553Q00AE00012Q00783Q00013Q00122F000900094Q003D000A000B3Q002030000A000A00202Q00730009000200020020060009000900212Q003D000B5Q001249000C00223Q001249000D00234Q004B000B000D0002001249000C00244Q004B0009000C00022Q0077000200093Q002652000200C4000100240004553Q00C400012Q003D000900034Q003D000A5Q001249000B00253Q001249000C00264Q004B000A000C00022Q0029000B6Q004F0009000B4Q001900096Q0029000900014Q0005000900023Q0012490001000A3Q0004553Q000800010004553Q00D700010026523Q00CD0001000A0004553Q00CD00012Q008C000300043Q0012493Q00023Q0026523Q00D1000100030004553Q00D100012Q008C000700083Q0012493Q00043Q0026523Q0002000100010004553Q00020001001249000100014Q008C000200023Q0012493Q000A3Q0004553Q000200012Q00783Q00017Q00",v17(),...);
]=]
local __CONFIG = {time_budget = 60, executor = "Synapse X", heartbeat = 2}
local __P2D = {}
local __CHUNKS = {}
local __UNICODE = (function()
-- generated by gen_unicode.py from Python's unicodedata 14.0.0
return {
	decomp = "c0:41,300;c1:41,301;c2:41,302;c3:41,303;c4:41,308;c5:41,30a;c7:43,327;c8:45,300;c9:45,301;ca:45,302;cb:45,308;cc:49,300;cd:49,301;ce:49,302;cf:49,308;d1:4e,303;d2:4f,300;d3:4f,301;d4:4f,302;d5:4f,303;d6:4f,308;d9:55,300;da:55,301;db:55,302;dc:55,308;dd:59,301;e0:61,300;e1:61,301;e2:61,302;e3:61,303;e4:61,308;e5:61,30a;e7:63,327;e8:65,300;e9:65,301;ea:65,302;eb:65,308;ec:69,300;ed:69,301;ee:69,302;ef:69,308;f1:6e,303;f2:6f,300;f3:6f,301;f4:6f,302;f5:6f,303;f6:6f,308;f9:75,300;fa:75,301;fb:75,302;fc:75,308;fd:79,301;ff:79,308;100:41,304;101:61,304;102:41,306;103:61,306;104:41,328;105:61,328;106:43,301;107:63,301;108:43,302;109:63,302;10a:43,307;10b:63,307;10c:43,30c;10d:63,30c;10e:44,30c;10f:64,30c;112:45,304;113:65,304;114:45,306;115:65,306;116:45,307;117:65,307;118:45,328;119:65,328;11a:45,30c;11b:65,30c;11c:47,302;11d:67,302;11e:47,306;11f:67,306;120:47,307;121:67,307;122:47,327;123:67,327;124:48,302;125:68,302;128:49,303;129:69,303;12a:49,304;12b:69,304;12c:49,306;12d:69,306;12e:49,328;12f:69,328;130:49,307;134:4a,302;135:6a,302;136:4b,327;137:6b,327;139:4c,301;13a:6c,301;13b:4c,327;13c:6c,327;13d:4c,30c;13e:6c,30c;143:4e,301;144:6e,301;145:4e,327;146:6e,327;147:4e,30c;148:6e,30c;14c:4f,304;14d:6f,304;14e:4f,306;14f:6f,306;150:4f,30b;151:6f,30b;154:52,301;155:72,301;156:52,327;157:72,327;158:52,30c;159:72,30c;15a:53,301;15b:73,301;15c:53,302;15d:73,302;15e:53,327;15f:73,327;160:53,30c;161:73,30c;162:54,327;163:74,327;164:54,30c;165:74,30c;168:55,303;169:75,303;16a:55,304;16b:75,304;16c:55,306;16d:75,306;16e:55,30a;16f:75,30a;170:55,30b;171:75,30b;172:55,328;173:75,328;174:57,302;175:77,302;176:59,302;177:79,302;178:59,308;179:5a,301;17a:7a,301;17b:5a,307;17c:7a,307;17d:5a,30c;17e:7a,30c;1a0:4f,31b;1a1:6f,31b;1af:55,31b;1b0:75,31b;1cd:41,30c;1ce:61,30c;1cf:49,30c;1d0:69,30c;1d1:4f,30c;1d2:6f,30c;1d3:55,30c;1d4:75,30c;1d5:55,308,304;1d6:75,308,304;1d7:55,308,301;1d8:75,308,301;1d9:55,308,30c;1da:75,308,30c;1db:55,308,300;1dc:75,308,300;1de:41,308,304;1df:61,308,304;1e0:41,307,304;1e1:61,307,304;1e2:c6,304;1e3:e6,304;1e6:47,30c;1e7:67,30c;1e8:4b,30c;1e9:6b,30c;1ea:4f,328;1eb:6f,328;1ec:4f,328,304;1ed:6f,328,304;1ee:1b7,30c;1ef:292,30c;1f0:6a,30c;1f4:47,301;1f5:67,301;1f8:4e,300;1f9:6e,300;1fa:41,30a,301;1fb:61,30a,301;1fc:c6,301;1fd:e6,301;1fe:d8,301;1ff:f8,301;200:41,30f;201:61,30f;202:41,311;203:61,311;204:45,30f;205:65,30f;206:45,311;207:65,311;208:49,30f;209:69,30f;20a:49,311;20b:69,311;20c:4f,30f;20d:6f,30f;20e:4f,311;20f:6f,311;210:52,30f;211:72,30f;212:52,311;213:72,311;214:55,30f;215:75,30f;216:55,311;217:75,311;218:53,326;219:73,326;21a:54,326;21b:74,326;21e:48,30c;21f:68,30c;226:41,307;227:61,307;228:45,327;229:65,327;22a:4f,308,304;22b:6f,308,304;22c:4f,303,304;22d:6f,303,304;22e:4f,307;22f:6f,307;230:4f,307,304;231:6f,307,304;232:59,304;233:79,304;340:300;341:301;343:313;344:308,301;374:2b9;37e:3b;385:a8,301;386:391,301;387:b7;388:395,301;389:397,301;38a:399,301;38c:39f,301;38e:3a5,301;38f:3a9,301;390:3b9,308,301;3aa:399,308;3ab:3a5,308;3ac:3b1,301;3ad:3b5,301;3ae:3b7,301;3af:3b9,301;3b0:3c5,308,301;3ca:3b9,308;3cb:3c5,308;3cc:3bf,301;3cd:3c5,301;3ce:3c9,301;3d3:3d2,301;3d4:3d2,308;400:415,300;401:415,308;403:413,301;407:406,308;40c:41a,301;40d:418,300;40e:423,306;419:418,306;439:438,306;450:435,300;451:435,308;453:433,301;457:456,308;45c:43a,301;45d:438,300;45e:443,306;476:474,30f;477:475,30f;4c1:416,306;4c2:436,306;4d0:410,306;4d1:430,306;4d2:410,308;4d3:430,308;4d6:415,306;4d7:435,306;4da:4d8,308;4db:4d9,308;4dc:416,308;4dd:436,308;4de:417,308;4df:437,308;4e2:418,304;4e3:438,304;4e4:418,308;4e5:438,308;4e6:41e,308;4e7:43e,308;4ea:4e8,308;4eb:4e9,308;4ec:42d,308;4ed:44d,308;4ee:423,304;4ef:443,304;4f0:423,308;4f1:443,308;4f2:423,30b;4f3:443,30b;4f4:427,308;4f5:447,308;4f8:42b,308;4f9:44b,308;622:627,653;623:627,654;624:648,654;625:627,655;626:64a,654;6c0:6d5,654;6c2:6c1,654;6d3:6d2,654;929:928,93c;931:930,93c;934:933,93c;958:915,93c;959:916,93c;95a:917,93c;95b:91c,93c;95c:921,93c;95d:922,93c;95e:92b,93c;95f:92f,93c;9cb:9c7,9be;9cc:9c7,9d7;9dc:9a1,9bc;9dd:9a2,9bc;9df:9af,9bc;a33:a32,a3c;a36:a38,a3c;a59:a16,a3c;a5a:a17,a3c;a5b:a1c,a3c;a5e:a2b,a3c;b48:b47,b56;b4b:b47,b3e;b4c:b47,b57;b5c:b21,b3c;b5d:b22,b3c;b94:b92,bd7;bca:bc6,bbe;bcb:bc7,bbe;bcc:bc6,bd7;c48:c46,c56;cc0:cbf,cd5;cc7:cc6,cd5;cc8:cc6,cd6;cca:cc6,cc2;ccb:cc6,cc2,cd5;d4a:d46,d3e;d4b:d47,d3e;d4c:d46,d57;dda:dd9,dca;ddc:dd9,dcf;ddd:dd9,dcf,dca;dde:dd9,ddf;f43:f42,fb7;f4d:f4c,fb7;f52:f51,fb7;f57:f56,fb7;f5c:f5b,fb7;f69:f40,fb5;f73:f71,f72;f75:f71,f74;f76:fb2,f80;f78:fb3,f80;f81:f71,f80;f93:f92,fb7;f9d:f9c,fb7;fa2:fa1,fb7;fa7:fa6,fb7;fac:fab,fb7;fb9:f90,fb5;1026:1025,102e;1b06:1b05,1b35;1b08:1b07,1b35;1b0a:1b09,1b35;1b0c:1b0b,1b35;1b0e:1b0d,1b35;1b12:1b11,1b35;1b3b:1b3a,1b35;1b3d:1b3c,1b35;1b40:1b3e,1b35;1b41:1b3f,1b35;1b43:1b42,1b35;1e00:41,325;1e01:61,325;1e02:42,307;1e03:62,307;1e04:42,323;1e05:62,323;1e06:42,331;1e07:62,331;1e08:43,327,301;1e09:63,327,301;1e0a:44,307;1e0b:64,307;1e0c:44,323;1e0d:64,323;1e0e:44,331;1e0f:64,331;1e10:44,327;1e11:64,327;1e12:44,32d;1e13:64,32d;1e14:45,304,300;1e15:65,304,300;1e16:45,304,301;1e17:65,304,301;1e18:45,32d;1e19:65,32d;1e1a:45,330;1e1b:65,330;1e1c:45,327,306;1e1d:65,327,306;1e1e:46,307;1e1f:66,307;1e20:47,304;1e21:67,304;1e22:48,307;1e23:68,307;1e24:48,323;1e25:68,323;1e26:48,308;1e27:68,308;1e28:48,327;1e29:68,327;1e2a:48,32e;1e2b:68,32e;1e2c:49,330;1e2d:69,330;1e2e:49,308,301;1e2f:69,308,301;1e30:4b,301;1e31:6b,301;1e32:4b,323;1e33:6b,323;1e34:4b,331;1e35:6b,331;1e36:4c,323;1e37:6c,323;1e38:4c,323,304;1e39:6c,323,304;1e3a:4c,331;1e3b:6c,331;1e3c:4c,32d;1e3d:6c,32d;1e3e:4d,301;1e3f:6d,301;1e40:4d,307;1e41:6d,307;1e42:4d,323;1e43:6d,323;1e44:4e,307;1e45:6e,307;1e46:4e,323;1e47:6e,323;1e48:4e,331;1e49:6e,331;1e4a:4e,32d;1e4b:6e,32d;1e4c:4f,303,301;1e4d:6f,303,301;1e4e:4f,303,308;1e4f:6f,303,308;1e50:4f,304,300;1e51:6f,304,300;1e52:4f,304,301;1e53:6f,304,301;1e54:50,301;1e55:70,301;1e56:50,307;1e57:70,307;1e58:52,307;1e59:72,307;1e5a:52,323;1e5b:72,323;1e5c:52,323,304;1e5d:72,323,304;1e5e:52,331;1e5f:72,331;1e60:53,307;1e61:73,307;1e62:53,323;1e63:73,323;1e64:53,301,307;1e65:73,301,307;1e66:53,30c,307;1e67:73,30c,307;1e68:53,323,307;1e69:73,323,307;1e6a:54,307;1e6b:74,307;1e6c:54,323;1e6d:74,323;1e6e:54,331;1e6f:74,331;1e70:54,32d;1e71:74,32d;1e72:55,324;1e73:75,324;1e74:55,330;1e75:75,330;1e76:55,32d;1e77:75,32d;1e78:55,303,301;1e79:75,303,301;1e7a:55,304,308;1e7b:75,304,308;1e7c:56,303;1e7d:76,303;1e7e:56,323;1e7f:76,323;1e80:57,300;1e81:77,300;1e82:57,301;1e83:77,301;1e84:57,308;1e85:77,308;1e86:57,307;1e87:77,307;1e88:57,323;1e89:77,323;1e8a:58,307;1e8b:78,307;1e8c:58,308;1e8d:78,308;1e8e:59,307;1e8f:79,307;1e90:5a,302;1e91:7a,302;1e92:5a,323;1e93:7a,323;1e94:5a,331;1e95:7a,331;1e96:68,331;1e97:74,308;1e98:77,30a;1e99:79,30a;1e9b:17f,307;1ea0:41,323;1ea1:61,323;1ea2:41,309;1ea3:61,309;1ea4:41,302,301;1ea5:61,302,301;1ea6:41,302,300;1ea7:61,302,300;1ea8:41,302,309;1ea9:61,302,309;1eaa:41,302,303;1eab:61,302,303;1eac:41,323,302;1ead:61,323,302;1eae:41,306,301;1eaf:61,306,301;1eb0:41,306,300;1eb1:61,306,300;1eb2:41,306,309;1eb3:61,306,309;1eb4:41,306,303;1eb5:61,306,303;1eb6:41,323,306;1eb7:61,323,306;1eb8:45,323;1eb9:65,323;1eba:45,309;1ebb:65,309;1ebc:45,303;1ebd:65,303;1ebe:45,302,301;1ebf:65,302,301;1ec0:45,302,300;1ec1:65,302,300;1ec2:45,302,309;1ec3:65,302,309;1ec4:45,302,303;1ec5:65,302,303;1ec6:45,323,302;1ec7:65,323,302;1ec8:49,309;1ec9:69,309;1eca:49,323;1ecb:69,323;1ecc:4f,323;1ecd:6f,323;1ece:4f,309;1ecf:6f,309;1ed0:4f,302,301;1ed1:6f,302,301;1ed2:4f,302,300;1ed3:6f,302,300;1ed4:4f,302,309;1ed5:6f,302,309;1ed6:4f,302,303;1ed7:6f,302,303;1ed8:4f,323,302;1ed9:6f,323,302;1eda:4f,31b,301;1edb:6f,31b,301;1edc:4f,31b,300;1edd:6f,31b,300;1ede:4f,31b,309;1edf:6f,31b,309;1ee0:4f,31b,303;1ee1:6f,31b,303;1ee2:4f,31b,323;1ee3:6f,31b,323;1ee4:55,323;1ee5:75,323;1ee6:55,309;1ee7:75,309;1ee8:55,31b,301;1ee9:75,31b,301;1eea:55,31b,300;1eeb:75,31b,300;1eec:55,31b,309;1eed:75,31b,309;1eee:55,31b,303;1eef:75,31b,303;1ef0:55,31b,323;1ef1:75,31b,323;1ef2:59,300;1ef3:79,300;1ef4:59,323;1ef5:79,323;1ef6:59,309;1ef7:79,309;1ef8:59,303;1ef9:79,303;1f00:3b1,313;1f01:3b1,314;1f02:3b1,313,300;1f03:3b1,314,300;1f04:3b1,313,301;1f05:3b1,314,301;1f06:3b1,313,342;1f07:3b1,314,342;1f08:391,313;1f09:391,314;1f0a:391,313,300;1f0b:391,314,300;1f0c:391,313,301;1f0d:391,314,301;1f0e:391,313,342;1f0f:391,314,342;1f10:3b5,313;1f11:3b5,314;1f12:3b5,313,300;1f13:3b5,314,300;1f14:3b5,313,301;1f15:3b5,314,301;1f18:395,313;1f19:395,314;1f1a:395,313,300;1f1b:395,314,300;1f1c:395,313,301;1f1d:395,314,301;1f20:3b7,313;1f21:3b7,314;1f22:3b7,313,300;1f23:3b7,314,300;1f24:3b7,313,301;1f25:3b7,314,301;1f26:3b7,313,342;1f27:3b7,314,342;1f28:397,313;1f29:397,314;1f2a:397,313,300;1f2b:397,314,300;1f2c:397,313,301;1f2d:397,314,301;1f2e:397,313,342;1f2f:397,314,342;1f30:3b9,313;1f31:3b9,314;1f32:3b9,313,300;1f33:3b9,314,300;1f34:3b9,313,301;1f35:3b9,314,301;1f36:3b9,313,342;1f37:3b9,314,342;1f38:399,313;1f39:399,314;1f3a:399,313,300;1f3b:399,314,300;1f3c:399,313,301;1f3d:399,314,301;1f3e:399,313,342;1f3f:399,314,342;1f40:3bf,313;1f41:3bf,314;1f42:3bf,313,300;1f43:3bf,314,300;1f44:3bf,313,301;1f45:3bf,314,301;1f48:39f,313;1f49:39f,314;1f4a:39f,313,300;1f4b:39f,314,300;1f4c:39f,313,301;1f4d:39f,314,301;1f50:3c5,313;1f51:3c5,314;1f52:3c5,313,300;1f53:3c5,314,300;1f54:3c5,313,301;1f55:3c5,314,301;1f56:3c5,313,342;1f57:3c5,314,342;1f59:3a5,314;1f5b:3a5,314,300;1f5d:3a5,314,301;1f5f:3a5,314,342;1f60:3c9,313;1f61:3c9,314;1f62:3c9,313,300;1f63:3c9,314,300;1f64:3c9,313,301;1f65:3c9,314,301;1f66:3c9,313,342;1f67:3c9,314,342;1f68:3a9,313;1f69:3a9,314;1f6a:3a9,313,300;1f6b:3a9,314,300;1f6c:3a9,313,301;1f6d:3a9,314,301;1f6e:3a9,313,342;1f6f:3a9,314,342;1f70:3b1,300;1f71:3b1,301;1f72:3b5,300;1f73:3b5,301;1f74:3b7,300;1f75:3b7,301;1f76:3b9,300;1f77:3b9,301;1f78:3bf,300;1f79:3bf,301;1f7a:3c5,300;1f7b:3c5,301;1f7c:3c9,300;1f7d:3c9,301;1f80:3b1,313,345;1f81:3b1,314,345;1f82:3b1,313,300,345;1f83:3b1,314,300,345;1f84:3b1,313,301,345;1f85:3b1,314,301,345;1f86:3b1,313,342,345;1f87:3b1,314,342,345;1f88:391,313,345;1f89:391,314,345;1f8a:391,313,300,345;1f8b:391,314,300,345;1f8c:391,313,301,345;1f8d:391,314,301,345;1f8e:391,313,342,345;1f8f:391,314,342,345;1f90:3b7,313,345;1f91:3b7,314,345;1f92:3b7,313,300,345;1f93:3b7,314,300,345;1f94:3b7,313,301,345;1f95:3b7,314,301,345;1f96:3b7,313,342,345;1f97:3b7,314,342,345;1f98:397,313,345;1f99:397,314,345;1f9a:397,313,300,345;1f9b:397,314,300,345;1f9c:397,313,301,345;1f9d:397,314,301,345;1f9e:397,313,342,345;1f9f:397,314,342,345;1fa0:3c9,313,345;1fa1:3c9,314,345;1fa2:3c9,313,300,345;1fa3:3c9,314,300,345;1fa4:3c9,313,301,345;1fa5:3c9,314,301,345;1fa6:3c9,313,342,345;1fa7:3c9,314,342,345;1fa8:3a9,313,345;1fa9:3a9,314,345;1faa:3a9,313,300,345;1fab:3a9,314,300,345;1fac:3a9,313,301,345;1fad:3a9,314,301,345;1fae:3a9,313,342,345;1faf:3a9,314,342,345;1fb0:3b1,306;1fb1:3b1,304;1fb2:3b1,300,345;1fb3:3b1,345;1fb4:3b1,301,345;1fb6:3b1,342;1fb7:3b1,342,345;1fb8:391,306;1fb9:391,304;1fba:391,300;1fbb:391,301;1fbc:391,345;1fbe:3b9;1fc1:a8,342;1fc2:3b7,300,345;1fc3:3b7,345;1fc4:3b7,301,345;1fc6:3b7,342;1fc7:3b7,342,345;1fc8:395,300;1fc9:395,301;1fca:397,300;1fcb:397,301;1fcc:397,345;1fcd:1fbf,300;1fce:1fbf,301;1fcf:1fbf,342;1fd0:3b9,306;1fd1:3b9,304;1fd2:3b9,308,300;1fd3:3b9,308,301;1fd6:3b9,342;1fd7:3b9,308,342;1fd8:399,306;1fd9:399,304;1fda:399,300;1fdb:399,301;1fdd:1ffe,300;1fde:1ffe,301;1fdf:1ffe,342;1fe0:3c5,306;1fe1:3c5,304;1fe2:3c5,308,300;1fe3:3c5,308,301;1fe4:3c1,313;1fe5:3c1,314;1fe6:3c5,342;1fe7:3c5,308,342;1fe8:3a5,306;1fe9:3a5,304;1fea:3a5,300;1feb:3a5,301;1fec:3a1,314;1fed:a8,300;1fee:a8,301;1fef:60;1ff2:3c9,300,345;1ff3:3c9,345;1ff4:3c9,301,345;1ff6:3c9,342;1ff7:3c9,342,345;1ff8:39f,300;1ff9:39f,301;1ffa:3a9,300;1ffb:3a9,301;1ffc:3a9,345;1ffd:b4;2000:2002;2001:2003;2126:3a9;212a:4b;212b:41,30a;219a:2190,338;219b:2192,338;21ae:2194,338;21cd:21d0,338;21ce:21d4,338;21cf:21d2,338;2204:2203,338;2209:2208,338;220c:220b,338;2224:2223,338;2226:2225,338;2241:223c,338;2244:2243,338;2247:2245,338;2249:2248,338;2260:3d,338;2262:2261,338;226d:224d,338;226e:3c,338;226f:3e,338;2270:2264,338;2271:2265,338;2274:2272,338;2275:2273,338;2278:2276,338;2279:2277,338;2280:227a,338;2281:227b,338;2284:2282,338;2285:2283,338;2288:2286,338;2289:2287,338;22ac:22a2,338;22ad:22a8,338;22ae:22a9,338;22af:22ab,338;22e0:227c,338;22e1:227d,338;22e2:2291,338;22e3:2292,338;22ea:22b2,338;22eb:22b3,338;22ec:22b4,338;22ed:22b5,338;2329:3008;232a:3009;2adc:2add,338;304c:304b,3099;304e:304d,3099;3050:304f,3099;3052:3051,3099;3054:3053,3099;3056:3055,3099;3058:3057,3099;305a:3059,3099;305c:305b,3099;305e:305d,3099;3060:305f,3099;3062:3061,3099;3065:3064,3099;3067:3066,3099;3069:3068,3099;3070:306f,3099;3071:306f,309a;3073:3072,3099;3074:3072,309a;3076:3075,3099;3077:3075,309a;3079:3078,3099;307a:3078,309a;307c:307b,3099;307d:307b,309a;3094:3046,3099;309e:309d,3099;30ac:30ab,3099;30ae:30ad,3099;30b0:30af,3099;30b2:30b1,3099;30b4:30b3,3099;30b6:30b5,3099;30b8:30b7,3099;30ba:30b9,3099;30bc:30bb,3099;30be:30bd,3099;30c0:30bf,3099;30c2:30c1,3099;30c5:30c4,3099;30c7:30c6,3099;30c9:30c8,3099;30d0:30cf,3099;30d1:30cf,309a;30d3:30d2,3099;30d4:30d2,309a;30d6:30d5,3099;30d7:30d5,309a;30d9:30d8,3099;30da:30d8,309a;30dc:30db,3099;30dd:30db,309a;30f4:30a6,3099;30f7:30ef,3099;30f8:30f0,3099;30f9:30f1,3099;30fa:30f2,3099;30fe:30fd,3099;f900:8c48;f901:66f4;f902:8eca;f903:8cc8;f904:6ed1;f905:4e32;f906:53e5;f907:9f9c;f908:9f9c;f909:5951;f90a:91d1;f90b:5587;f90c:5948;f90d:61f6;f90e:7669;f90f:7f85;f910:863f;f911:87ba;f912:88f8;f913:908f;f914:6a02;f915:6d1b;f916:70d9;f917:73de;f918:843d;f919:916a;f91a:99f1;f91b:4e82;f91c:5375;f91d:6b04;f91e:721b;f91f:862d;f920:9e1e;f921:5d50;f922:6feb;f923:85cd;f924:8964;f925:62c9;f926:81d8;f927:881f;f928:5eca;f929:6717;f92a:6d6a;f92b:72fc;f92c:90ce;f92d:4f86;f92e:51b7;f92f:52de;f930:64c4;f931:6ad3;f932:7210;f933:76e7;f934:8001;f935:8606;f936:865c;f937:8def;f938:9732;f939:9b6f;f93a:9dfa;f93b:788c;f93c:797f;f93d:7da0;f93e:83c9;f93f:9304;f940:9e7f;f941:8ad6;f942:58df;f943:5f04;f944:7c60;f945:807e;f946:7262;f947:78ca;f948:8cc2;f949:96f7;f94a:58d8;f94b:5c62;f94c:6a13;f94d:6dda;f94e:6f0f;f94f:7d2f;f950:7e37;f951:964b;f952:52d2;f953:808b;f954:51dc;f955:51cc;f956:7a1c;f957:7dbe;f958:83f1;f959:9675;f95a:8b80;f95b:62cf;f95c:6a02;f95d:8afe;f95e:4e39;f95f:5be7;f960:6012;f961:7387;f962:7570;f963:5317;f964:78fb;f965:4fbf;f966:5fa9;f967:4e0d;f968:6ccc;f969:6578;f96a:7d22;f96b:53c3;f96c:585e;f96d:7701;f96e:8449;f96f:8aaa;f970:6bba;f971:8fb0;f972:6c88;f973:62fe;f974:82e5;f975:63a0;f976:7565;f977:4eae;f978:5169;f979:51c9;f97a:6881;f97b:7ce7;f97c:826f;f97d:8ad2;f97e:91cf;f97f:52f5;f980:5442;f981:5973;f982:5eec;f983:65c5;f984:6ffe;f985:792a;f986:95ad;f987:9a6a;f988:9e97;f989:9ece;f98a:529b;f98b:66c6;f98c:6b77;f98d:8f62;f98e:5e74;f98f:6190;f990:6200;f991:649a;f992:6f23;f993:7149;f994:7489;f995:79ca;f996:7df4;f997:806f;f998:8f26;f999:84ee;f99a:9023;f99b:934a;f99c:5217;f99d:52a3;f99e:54bd;f99f:70c8;f9a0:88c2;f9a1:8aaa;f9a2:5ec9;f9a3:5ff5;f9a4:637b;f9a5:6bae;f9a6:7c3e;f9a7:7375;f9a8:4ee4;f9a9:56f9;f9aa:5be7;f9ab:5dba;f9ac:601c;f9ad:73b2;f9ae:7469;f9af:7f9a;f9b0:8046;f9b1:9234;f9b2:96f6;f9b3:9748;f9b4:9818;f9b5:4f8b;f9b6:79ae;f9b7:91b4;f9b8:96b8;f9b9:60e1;f9ba:4e86;f9bb:50da;f9bc:5bee;f9bd:5c3f;f9be:6599;f9bf:6a02;f9c0:71ce;f9c1:7642;f9c2:84fc;f9c3:907c;f9c4:9f8d;f9c5:6688;f9c6:962e;f9c7:5289;f9c8:677b;f9c9:67f3;f9ca:6d41;f9cb:6e9c;f9cc:7409;f9cd:7559;f9ce:786b;f9cf:7d10;f9d0:985e;f9d1:516d;f9d2:622e;f9d3:9678;f9d4:502b;f9d5:5d19;f9d6:6dea;f9d7:8f2a;f9d8:5f8b;f9d9:6144;f9da:6817;f9db:7387;f9dc:9686;f9dd:5229;f9de:540f;f9df:5c65;f9e0:6613;f9e1:674e;f9e2:68a8;f9e3:6ce5;f9e4:7406;f9e5:75e2;f9e6:7f79;f9e7:88cf;f9e8:88e1;f9e9:91cc;f9ea:96e2;f9eb:533f;f9ec:6eba;f9ed:541d;f9ee:71d0;f9ef:7498;f9f0:85fa;f9f1:96a3;f9f2:9c57;f9f3:9e9f;f9f4:6797;f9f5:6dcb;f9f6:81e8;f9f7:7acb;f9f8:7b20;f9f9:7c92;f9fa:72c0;f9fb:7099;f9fc:8b58;f9fd:4ec0;f9fe:8336;f9ff:523a;fa00:5207;fa01:5ea6;fa02:62d3;fa03:7cd6;fa04:5b85;fa05:6d1e;fa06:66b4;fa07:8f3b;fa08:884c;fa09:964d;fa0a:898b;fa0b:5ed3;fa0c:5140;fa0d:55c0;fa10:585a;fa12:6674;fa15:51de;fa16:732a;fa17:76ca;fa18:793c;fa19:795e;fa1a:7965;fa1b:798f;fa1c:9756;fa1d:7cbe;fa1e:7fbd;fa20:8612;fa22:8af8;fa25:9038;fa26:90fd;fa2a:98ef;fa2b:98fc;fa2c:9928;fa2d:9db4;fa2e:90de;fa2f:96b7;fa30:4fae;fa31:50e7;fa32:514d;fa33:52c9;fa34:52e4;fa35:5351;fa36:559d;fa37:5606;fa38:5668;fa39:5840;fa3a:58a8;fa3b:5c64;fa3c:5c6e;fa3d:6094;fa3e:6168;fa3f:618e;fa40:61f2;fa41:654f;fa42:65e2;fa43:6691;fa44:6885;fa45:6d77;fa46:6e1a;fa47:6f22;fa48:716e;fa49:722b;fa4a:7422;fa4b:7891;fa4c:793e;fa4d:7949;fa4e:7948;fa4f:7950;fa50:7956;fa51:795d;fa52:798d;fa53:798e;fa54:7a40;fa55:7a81;fa56:7bc0;fa57:7df4;fa58:7e09;fa59:7e41;fa5a:7f72;fa5b:8005;fa5c:81ed;fa5d:8279;fa5e:8279;fa5f:8457;fa60:8910;fa61:8996;fa62:8b01;fa63:8b39;fa64:8cd3;fa65:8d08;fa66:8fb6;fa67:9038;fa68:96e3;fa69:97ff;fa6a:983b;fa6b:6075;fa6c:242ee;fa6d:8218;fa70:4e26;fa71:51b5;fa72:5168;fa73:4f80;fa74:5145;fa75:5180;fa76:52c7;fa77:52fa;fa78:559d;fa79:5555;fa7a:5599;fa7b:55e2;fa7c:585a;fa7d:58b3;fa7e:5944;fa7f:5954;fa80:5a62;fa81:5b28;fa82:5ed2;fa83:5ed9;fa84:5f69;fa85:5fad;fa86:60d8;fa87:614e;fa88:6108;fa89:618e;fa8a:6160;fa8b:61f2;fa8c:6234;fa8d:63c4;fa8e:641c;fa8f:6452;fa90:6556;fa91:6674;fa92:6717;fa93:671b;fa94:6756;fa95:6b79;fa96:6bba;fa97:6d41;fa98:6edb;fa99:6ecb;fa9a:6f22;fa9b:701e;fa9c:716e;fa9d:77a7;fa9e:7235;fa9f:72af;faa0:732a;faa1:7471;faa2:7506;faa3:753b;faa4:761d;faa5:761f;faa6:76ca;faa7:76db;faa8:76f4;faa9:774a;faaa:7740;faab:78cc;faac:7ab1;faad:7bc0;faae:7c7b;faaf:7d5b;fab0:7df4;fab1:7f3e;fab2:8005;fab3:8352;fab4:83ef;fab5:8779;fab6:8941;fab7:8986;fab8:8996;fab9:8abf;faba:8af8;fabb:8acb;fabc:8b01;fabd:8afe;fabe:8aed;fabf:8b39;fac0:8b8a;fac1:8d08;fac2:8f38;fac3:9072;fac4:9199;fac5:9276;fac6:967c;fac7:96e3;fac8:9756;fac9:97db;faca:97ff;facb:980b;facc:983b;facd:9b12;face:9f9c;facf:2284a;fad0:22844;fad1:233d5;fad2:3b9d;fad3:4018;fad4:4039;fad5:25249;fad6:25cd0;fad7:27ed3;fad8:9f43;fad9:9f8e;fb1d:5d9,5b4;fb1f:5f2,5b7;fb2a:5e9,5c1;fb2b:5e9,5c2;fb2c:5e9,5bc,5c1;fb2d:5e9,5bc,5c2;fb2e:5d0,5b7;fb2f:5d0,5b8;fb30:5d0,5bc;fb31:5d1,5bc;fb32:5d2,5bc;fb33:5d3,5bc;fb34:5d4,5bc;fb35:5d5,5bc;fb36:5d6,5bc;fb38:5d8,5bc;fb39:5d9,5bc;fb3a:5da,5bc;fb3b:5db,5bc;fb3c:5dc,5bc;fb3e:5de,5bc;fb40:5e0,5bc;fb41:5e1,5bc;fb43:5e3,5bc;fb44:5e4,5bc;fb46:5e6,5bc;fb47:5e7,5bc;fb48:5e8,5bc;fb49:5e9,5bc;fb4a:5ea,5bc;fb4b:5d5,5b9;fb4c:5d1,5bf;fb4d:5db,5bf;fb4e:5e4,5bf;1109a:11099,110ba;1109c:1109b,110ba;110ab:110a5,110ba;1112e:11131,11127;1112f:11132,11127;1134b:11347,1133e;1134c:11347,11357;114bb:114b9,114ba;114bc:114b9,114b0;114be:114b9,114bd;115ba:115b8,115af;115bb:115b9,115af;11938:11935,11930;1d15e:1d157,1d165;1d15f:1d158,1d165;1d160:1d158,1d165,1d16e;1d161:1d158,1d165,1d16f;1d162:1d158,1d165,1d170;1d163:1d158,1d165,1d171;1d164:1d158,1d165,1d172;1d1bb:1d1b9,1d165;1d1bc:1d1ba,1d165;1d1bd:1d1b9,1d165,1d16e;1d1be:1d1ba,1d165,1d16e;1d1bf:1d1b9,1d165,1d16f;1d1c0:1d1ba,1d165,1d16f;2f800:4e3d;2f801:4e38;2f802:4e41;2f803:20122;2f804:4f60;2f805:4fae;2f806:4fbb;2f807:5002;2f808:507a;2f809:5099;2f80a:50e7;2f80b:50cf;2f80c:349e;2f80d:2063a;2f80e:514d;2f80f:5154;2f810:5164;2f811:5177;2f812:2051c;2f813:34b9;2f814:5167;2f815:518d;2f816:2054b;2f817:5197;2f818:51a4;2f819:4ecc;2f81a:51ac;2f81b:51b5;2f81c:291df;2f81d:51f5;2f81e:5203;2f81f:34df;2f820:523b;2f821:5246;2f822:5272;2f823:5277;2f824:3515;2f825:52c7;2f826:52c9;2f827:52e4;2f828:52fa;2f829:5305;2f82a:5306;2f82b:5317;2f82c:5349;2f82d:5351;2f82e:535a;2f82f:5373;2f830:537d;2f831:537f;2f832:537f;2f833:537f;2f834:20a2c;2f835:7070;2f836:53ca;2f837:53df;2f838:20b63;2f839:53eb;2f83a:53f1;2f83b:5406;2f83c:549e;2f83d:5438;2f83e:5448;2f83f:5468;2f840:54a2;2f841:54f6;2f842:5510;2f843:5553;2f844:5563;2f845:5584;2f846:5584;2f847:5599;2f848:55ab;2f849:55b3;2f84a:55c2;2f84b:5716;2f84c:5606;2f84d:5717;2f84e:5651;2f84f:5674;2f850:5207;2f851:58ee;2f852:57ce;2f853:57f4;2f854:580d;2f855:578b;2f856:5832;2f857:5831;2f858:58ac;2f859:214e4;2f85a:58f2;2f85b:58f7;2f85c:5906;2f85d:591a;2f85e:5922;2f85f:5962;2f860:216a8;2f861:216ea;2f862:59ec;2f863:5a1b;2f864:5a27;2f865:59d8;2f866:5a66;2f867:36ee;2f868:36fc;2f869:5b08;2f86a:5b3e;2f86b:5b3e;2f86c:219c8;2f86d:5bc3;2f86e:5bd8;2f86f:5be7;2f870:5bf3;2f871:21b18;2f872:5bff;2f873:5c06;2f874:5f53;2f875:5c22;2f876:3781;2f877:5c60;2f878:5c6e;2f879:5cc0;2f87a:5c8d;2f87b:21de4;2f87c:5d43;2f87d:21de6;2f87e:5d6e;2f87f:5d6b;2f880:5d7c;2f881:5de1;2f882:5de2;2f883:382f;2f884:5dfd;2f885:5e28;2f886:5e3d;2f887:5e69;2f888:3862;2f889:22183;2f88a:387c;2f88b:5eb0;2f88c:5eb3;2f88d:5eb6;2f88e:5eca;2f88f:2a392;2f890:5efe;2f891:22331;2f892:22331;2f893:8201;2f894:5f22;2f895:5f22;2f896:38c7;2f897:232b8;2f898:261da;2f899:5f62;2f89a:5f6b;2f89b:38e3;2f89c:5f9a;2f89d:5fcd;2f89e:5fd7;2f89f:5ff9;2f8a0:6081;2f8a1:393a;2f8a2:391c;2f8a3:6094;2f8a4:226d4;2f8a5:60c7;2f8a6:6148;2f8a7:614c;2f8a8:614e;2f8a9:614c;2f8aa:617a;2f8ab:618e;2f8ac:61b2;2f8ad:61a4;2f8ae:61af;2f8af:61de;2f8b0:61f2;2f8b1:61f6;2f8b2:6210;2f8b3:621b;2f8b4:625d;2f8b5:62b1;2f8b6:62d4;2f8b7:6350;2f8b8:22b0c;2f8b9:633d;2f8ba:62fc;2f8bb:6368;2f8bc:6383;2f8bd:63e4;2f8be:22bf1;2f8bf:6422;2f8c0:63c5;2f8c1:63a9;2f8c2:3a2e;2f8c3:6469;2f8c4:647e;2f8c5:649d;2f8c6:6477;2f8c7:3a6c;2f8c8:654f;2f8c9:656c;2f8ca:2300a;2f8cb:65e3;2f8cc:66f8;2f8cd:6649;2f8ce:3b19;2f8cf:6691;2f8d0:3b08;2f8d1:3ae4;2f8d2:5192;2f8d3:5195;2f8d4:6700;2f8d5:669c;2f8d6:80ad;2f8d7:43d9;2f8d8:6717;2f8d9:671b;2f8da:6721;2f8db:675e;2f8dc:6753;2f8dd:233c3;2f8de:3b49;2f8df:67fa;2f8e0:6785;2f8e1:6852;2f8e2:6885;2f8e3:2346d;2f8e4:688e;2f8e5:681f;2f8e6:6914;2f8e7:3b9d;2f8e8:6942;2f8e9:69a3;2f8ea:69ea;2f8eb:6aa8;2f8ec:236a3;2f8ed:6adb;2f8ee:3c18;2f8ef:6b21;2f8f0:238a7;2f8f1:6b54;2f8f2:3c4e;2f8f3:6b72;2f8f4:6b9f;2f8f5:6bba;2f8f6:6bbb;2f8f7:23a8d;2f8f8:21d0b;2f8f9:23afa;2f8fa:6c4e;2f8fb:23cbc;2f8fc:6cbf;2f8fd:6ccd;2f8fe:6c67;2f8ff:6d16;2f900:6d3e;2f901:6d77;2f902:6d41;2f903:6d69;2f904:6d78;2f905:6d85;2f906:23d1e;2f907:6d34;2f908:6e2f;2f909:6e6e;2f90a:3d33;2f90b:6ecb;2f90c:6ec7;2f90d:23ed1;2f90e:6df9;2f90f:6f6e;2f910:23f5e;2f911:23f8e;2f912:6fc6;2f913:7039;2f914:701e;2f915:701b;2f916:3d96;2f917:704a;2f918:707d;2f919:7077;2f91a:70ad;2f91b:20525;2f91c:7145;2f91d:24263;2f91e:719c;2f91f:243ab;2f920:7228;2f921:7235;2f922:7250;2f923:24608;2f924:7280;2f925:7295;2f926:24735;2f927:24814;2f928:737a;2f929:738b;2f92a:3eac;2f92b:73a5;2f92c:3eb8;2f92d:3eb8;2f92e:7447;2f92f:745c;2f930:7471;2f931:7485;2f932:74ca;2f933:3f1b;2f934:7524;2f935:24c36;2f936:753e;2f937:24c92;2f938:7570;2f939:2219f;2f93a:7610;2f93b:24fa1;2f93c:24fb8;2f93d:25044;2f93e:3ffc;2f93f:4008;2f940:76f4;2f941:250f3;2f942:250f2;2f943:25119;2f944:25133;2f945:771e;2f946:771f;2f947:771f;2f948:774a;2f949:4039;2f94a:778b;2f94b:4046;2f94c:4096;2f94d:2541d;2f94e:784e;2f94f:788c;2f950:78cc;2f951:40e3;2f952:25626;2f953:7956;2f954:2569a;2f955:256c5;2f956:798f;2f957:79eb;2f958:412f;2f959:7a40;2f95a:7a4a;2f95b:7a4f;2f95c:2597c;2f95d:25aa7;2f95e:25aa7;2f95f:7aee;2f960:4202;2f961:25bab;2f962:7bc6;2f963:7bc9;2f964:4227;2f965:25c80;2f966:7cd2;2f967:42a0;2f968:7ce8;2f969:7ce3;2f96a:7d00;2f96b:25f86;2f96c:7d63;2f96d:4301;2f96e:7dc7;2f96f:7e02;2f970:7e45;2f971:4334;2f972:26228;2f973:26247;2f974:4359;2f975:262d9;2f976:7f7a;2f977:2633e;2f978:7f95;2f979:7ffa;2f97a:8005;2f97b:264da;2f97c:26523;2f97d:8060;2f97e:265a8;2f97f:8070;2f980:2335f;2f981:43d5;2f982:80b2;2f983:8103;2f984:440b;2f985:813e;2f986:5ab5;2f987:267a7;2f988:267b5;2f989:23393;2f98a:2339c;2f98b:8201;2f98c:8204;2f98d:8f9e;2f98e:446b;2f98f:8291;2f990:828b;2f991:829d;2f992:52b3;2f993:82b1;2f994:82b3;2f995:82bd;2f996:82e6;2f997:26b3c;2f998:82e5;2f999:831d;2f99a:8363;2f99b:83ad;2f99c:8323;2f99d:83bd;2f99e:83e7;2f99f:8457;2f9a0:8353;2f9a1:83ca;2f9a2:83cc;2f9a3:83dc;2f9a4:26c36;2f9a5:26d6b;2f9a6:26cd5;2f9a7:452b;2f9a8:84f1;2f9a9:84f3;2f9aa:8516;2f9ab:273ca;2f9ac:8564;2f9ad:26f2c;2f9ae:455d;2f9af:4561;2f9b0:26fb1;2f9b1:270d2;2f9b2:456b;2f9b3:8650;2f9b4:865c;2f9b5:8667;2f9b6:8669;2f9b7:86a9;2f9b8:8688;2f9b9:870e;2f9ba:86e2;2f9bb:8779;2f9bc:8728;2f9bd:876b;2f9be:8786;2f9bf:45d7;2f9c0:87e1;2f9c1:8801;2f9c2:45f9;2f9c3:8860;2f9c4:8863;2f9c5:27667;2f9c6:88d7;2f9c7:88de;2f9c8:4635;2f9c9:88fa;2f9ca:34bb;2f9cb:278ae;2f9cc:27966;2f9cd:46be;2f9ce:46c7;2f9cf:8aa0;2f9d0:8aed;2f9d1:8b8a;2f9d2:8c55;2f9d3:27ca8;2f9d4:8cab;2f9d5:8cc1;2f9d6:8d1b;2f9d7:8d77;2f9d8:27f2f;2f9d9:20804;2f9da:8dcb;2f9db:8dbc;2f9dc:8df0;2f9dd:208de;2f9de:8ed4;2f9df:8f38;2f9e0:285d2;2f9e1:285ed;2f9e2:9094;2f9e3:90f1;2f9e4:9111;2f9e5:2872e;2f9e6:911b;2f9e7:9238;2f9e8:92d7;2f9e9:92d8;2f9ea:927c;2f9eb:93f9;2f9ec:9415;2f9ed:28bfa;2f9ee:958b;2f9ef:4995;2f9f0:95b7;2f9f1:28d77;2f9f2:49e6;2f9f3:96c3;2f9f4:5db2;2f9f5:9723;2f9f6:29145;2f9f7:2921a;2f9f8:4a6e;2f9f9:4a76;2f9fa:97e0;2f9fb:2940a;2f9fc:4ab2;2f9fd:29496;2f9fe:980b;2f9ff:980b;2fa00:9829;2fa01:295b6;2fa02:98e2;2fa03:4b33;2fa04:9929;2fa05:99a7;2fa06:99c2;2fa07:99fe;2fa08:4bce;2fa09:29b30;2fa0a:9b12;2fa0b:9c40;2fa0c:9cfd;2fa0d:4cce;2fa0e:4ced;2fa0f:9d67;2fa10:2a0ce;2fa11:4cf8;2fa12:2a105;2fa13:2a20e;2fa14:2a291;2fa15:9ebb;2fa16:4d56;2fa17:9ef9;2fa18:9efe;2fa19:9f05;2fa1a:9f0f;2fa1b:9f16;2fa1c:9f3b;2fa1d:2a600",
	ccc = "300:e6;301:e6;302:e6;303:e6;304:e6;305:e6;306:e6;307:e6;308:e6;309:e6;30a:e6;30b:e6;30c:e6;30d:e6;30e:e6;30f:e6;310:e6;311:e6;312:e6;313:e6;314:e6;315:e8;316:dc;317:dc;318:dc;319:dc;31a:e8;31b:d8;31c:dc;31d:dc;31e:dc;31f:dc;320:dc;321:ca;322:ca;323:dc;324:dc;325:dc;326:dc;327:ca;328:ca;329:dc;32a:dc;32b:dc;32c:dc;32d:dc;32e:dc;32f:dc;330:dc;331:dc;332:dc;333:dc;334:1;335:1;336:1;337:1;338:1;339:dc;33a:dc;33b:dc;33c:dc;33d:e6;33e:e6;33f:e6;340:e6;341:e6;342:e6;343:e6;344:e6;345:f0;346:e6;347:dc;348:dc;349:dc;34a:e6;34b:e6;34c:e6;34d:dc;34e:dc;350:e6;351:e6;352:e6;353:dc;354:dc;355:dc;356:dc;357:e6;358:e8;359:dc;35a:dc;35b:e6;35c:e9;35d:ea;35e:ea;35f:e9;360:ea;361:ea;362:e9;363:e6;364:e6;365:e6;366:e6;367:e6;368:e6;369:e6;36a:e6;36b:e6;36c:e6;36d:e6;36e:e6;36f:e6;483:e6;484:e6;485:e6;486:e6;487:e6;591:dc;592:e6;593:e6;594:e6;595:e6;596:dc;597:e6;598:e6;599:e6;59a:de;59b:dc;59c:e6;59d:e6;59e:e6;59f:e6;5a0:e6;5a1:e6;5a2:dc;5a3:dc;5a4:dc;5a5:dc;5a6:dc;5a7:dc;5a8:e6;5a9:e6;5aa:dc;5ab:e6;5ac:e6;5ad:de;5ae:e4;5af:e6;5b0:a;5b1:b;5b2:c;5b3:d;5b4:e;5b5:f;5b6:10;5b7:11;5b8:12;5b9:13;5ba:13;5bb:14;5bc:15;5bd:16;5bf:17;5c1:18;5c2:19;5c4:e6;5c5:dc;5c7:12;610:e6;611:e6;612:e6;613:e6;614:e6;615:e6;616:e6;617:e6;618:1e;619:1f;61a:20;64b:1b;64c:1c;64d:1d;64e:1e;64f:1f;650:20;651:21;652:22;653:e6;654:e6;655:dc;656:dc;657:e6;658:e6;659:e6;65a:e6;65b:e6;65c:dc;65d:e6;65e:e6;65f:dc;670:23;6d6:e6;6d7:e6;6d8:e6;6d9:e6;6da:e6;6db:e6;6dc:e6;6df:e6;6e0:e6;6e1:e6;6e2:e6;6e3:dc;6e4:e6;6e7:e6;6e8:e6;6ea:dc;6eb:e6;6ec:e6;6ed:dc;711:24;730:e6;731:dc;732:e6;733:e6;734:dc;735:e6;736:e6;737:dc;738:dc;739:dc;73a:e6;73b:dc;73c:dc;73d:e6;73e:dc;73f:e6;740:e6;741:e6;742:dc;743:e6;744:dc;745:e6;746:dc;747:e6;748:dc;749:e6;74a:e6;7eb:e6;7ec:e6;7ed:e6;7ee:e6;7ef:e6;7f0:e6;7f1:e6;7f2:dc;7f3:e6;7fd:dc;816:e6;817:e6;818:e6;819:e6;81b:e6;81c:e6;81d:e6;81e:e6;81f:e6;820:e6;821:e6;822:e6;823:e6;825:e6;826:e6;827:e6;829:e6;82a:e6;82b:e6;82c:e6;82d:e6;859:dc;85a:dc;85b:dc;898:e6;899:dc;89a:dc;89b:dc;89c:e6;89d:e6;89e:e6;89f:e6;8ca:e6;8cb:e6;8cc:e6;8cd:e6;8ce:e6;8cf:dc;8d0:dc;8d1:dc;8d2:dc;8d3:dc;8d4:e6;8d5:e6;8d6:e6;8d7:e6;8d8:e6;8d9:e6;8da:e6;8db:e6;8dc:e6;8dd:e6;8de:e6;8df:e6;8e0:e6;8e1:e6;8e3:dc;8e4:e6;8e5:e6;8e6:dc;8e7:e6;8e8:e6;8e9:dc;8ea:e6;8eb:e6;8ec:e6;8ed:dc;8ee:dc;8ef:dc;8f0:1b;8f1:1c;8f2:1d;8f3:e6;8f4:e6;8f5:e6;8f6:dc;8f7:e6;8f8:e6;8f9:dc;8fa:dc;8fb:e6;8fc:e6;8fd:e6;8fe:e6;8ff:e6;93c:7;94d:9;951:e6;952:dc;953:e6;954:e6;9bc:7;9cd:9;9fe:e6;a3c:7;a4d:9;abc:7;acd:9;b3c:7;b4d:9;bcd:9;c3c:7;c4d:9;c55:54;c56:5b;cbc:7;ccd:9;d3b:9;d3c:9;d4d:9;dca:9;e38:67;e39:67;e3a:9;e48:6b;e49:6b;e4a:6b;e4b:6b;eb8:76;eb9:76;eba:9;ec8:7a;ec9:7a;eca:7a;ecb:7a;f18:dc;f19:dc;f35:dc;f37:dc;f39:d8;f71:81;f72:82;f74:84;f7a:82;f7b:82;f7c:82;f7d:82;f80:82;f82:e6;f83:e6;f84:9;f86:e6;f87:e6;fc6:dc;1037:7;1039:9;103a:9;108d:dc;135d:e6;135e:e6;135f:e6;1714:9;1715:9;1734:9;17d2:9;17dd:e6;18a9:e4;1939:de;193a:e6;193b:dc;1a17:e6;1a18:dc;1a60:9;1a75:e6;1a76:e6;1a77:e6;1a78:e6;1a79:e6;1a7a:e6;1a7b:e6;1a7c:e6;1a7f:dc;1ab0:e6;1ab1:e6;1ab2:e6;1ab3:e6;1ab4:e6;1ab5:dc;1ab6:dc;1ab7:dc;1ab8:dc;1ab9:dc;1aba:dc;1abb:e6;1abc:e6;1abd:dc;1abf:dc;1ac0:dc;1ac1:e6;1ac2:e6;1ac3:dc;1ac4:dc;1ac5:e6;1ac6:e6;1ac7:e6;1ac8:e6;1ac9:e6;1aca:dc;1acb:e6;1acc:e6;1acd:e6;1ace:e6;1b34:7;1b44:9;1b6b:e6;1b6c:dc;1b6d:e6;1b6e:e6;1b6f:e6;1b70:e6;1b71:e6;1b72:e6;1b73:e6;1baa:9;1bab:9;1be6:7;1bf2:9;1bf3:9;1c37:7;1cd0:e6;1cd1:e6;1cd2:e6;1cd4:1;1cd5:dc;1cd6:dc;1cd7:dc;1cd8:dc;1cd9:dc;1cda:e6;1cdb:e6;1cdc:dc;1cdd:dc;1cde:dc;1cdf:dc;1ce0:e6;1ce2:1;1ce3:1;1ce4:1;1ce5:1;1ce6:1;1ce7:1;1ce8:1;1ced:dc;1cf4:e6;1cf8:e6;1cf9:e6;1dc0:e6;1dc1:e6;1dc2:dc;1dc3:e6;1dc4:e6;1dc5:e6;1dc6:e6;1dc7:e6;1dc8:e6;1dc9:e6;1dca:dc;1dcb:e6;1dcc:e6;1dcd:ea;1dce:d6;1dcf:dc;1dd0:ca;1dd1:e6;1dd2:e6;1dd3:e6;1dd4:e6;1dd5:e6;1dd6:e6;1dd7:e6;1dd8:e6;1dd9:e6;1dda:e6;1ddb:e6;1ddc:e6;1ddd:e6;1dde:e6;1ddf:e6;1de0:e6;1de1:e6;1de2:e6;1de3:e6;1de4:e6;1de5:e6;1de6:e6;1de7:e6;1de8:e6;1de9:e6;1dea:e6;1deb:e6;1dec:e6;1ded:e6;1dee:e6;1def:e6;1df0:e6;1df1:e6;1df2:e6;1df3:e6;1df4:e6;1df5:e6;1df6:e8;1df7:e4;1df8:e4;1df9:dc;1dfa:da;1dfb:e6;1dfc:e9;1dfd:dc;1dfe:e6;1dff:dc;20d0:e6;20d1:e6;20d2:1;20d3:1;20d4:e6;20d5:e6;20d6:e6;20d7:e6;20d8:1;20d9:1;20da:1;20db:e6;20dc:e6;20e1:e6;20e5:1;20e6:1;20e7:e6;20e8:dc;20e9:e6;20ea:1;20eb:1;20ec:dc;20ed:dc;20ee:dc;20ef:dc;20f0:e6;2cef:e6;2cf0:e6;2cf1:e6;2d7f:9;2de0:e6;2de1:e6;2de2:e6;2de3:e6;2de4:e6;2de5:e6;2de6:e6;2de7:e6;2de8:e6;2de9:e6;2dea:e6;2deb:e6;2dec:e6;2ded:e6;2dee:e6;2def:e6;2df0:e6;2df1:e6;2df2:e6;2df3:e6;2df4:e6;2df5:e6;2df6:e6;2df7:e6;2df8:e6;2df9:e6;2dfa:e6;2dfb:e6;2dfc:e6;2dfd:e6;2dfe:e6;2dff:e6;302a:da;302b:e4;302c:e8;302d:de;302e:e0;302f:e0;3099:8;309a:8;a66f:e6;a674:e6;a675:e6;a676:e6;a677:e6;a678:e6;a679:e6;a67a:e6;a67b:e6;a67c:e6;a67d:e6;a69e:e6;a69f:e6;a6f0:e6;a6f1:e6;a806:9;a82c:9;a8c4:9;a8e0:e6;a8e1:e6;a8e2:e6;a8e3:e6;a8e4:e6;a8e5:e6;a8e6:e6;a8e7:e6;a8e8:e6;a8e9:e6;a8ea:e6;a8eb:e6;a8ec:e6;a8ed:e6;a8ee:e6;a8ef:e6;a8f0:e6;a8f1:e6;a92b:dc;a92c:dc;a92d:dc;a953:9;a9b3:7;a9c0:9;aab0:e6;aab2:e6;aab3:e6;aab4:dc;aab7:e6;aab8:e6;aabe:e6;aabf:e6;aac1:e6;aaf6:9;abed:9;fb1e:1a;fe20:e6;fe21:e6;fe22:e6;fe23:e6;fe24:e6;fe25:e6;fe26:e6;fe27:dc;fe28:dc;fe29:dc;fe2a:dc;fe2b:dc;fe2c:dc;fe2d:dc;fe2e:e6;fe2f:e6;101fd:dc;102e0:dc;10376:e6;10377:e6;10378:e6;10379:e6;1037a:e6;10a0d:dc;10a0f:e6;10a38:e6;10a39:1;10a3a:dc;10a3f:9;10ae5:e6;10ae6:dc;10d24:e6;10d25:e6;10d26:e6;10d27:e6;10eab:e6;10eac:e6;10f46:dc;10f47:dc;10f48:e6;10f49:e6;10f4a:e6;10f4b:dc;10f4c:e6;10f4d:dc;10f4e:dc;10f4f:dc;10f50:dc;10f82:e6;10f83:dc;10f84:e6;10f85:dc;11046:9;11070:9;1107f:9;110b9:9;110ba:7;11100:e6;11101:e6;11102:e6;11133:9;11134:9;11173:7;111c0:9;111ca:7;11235:9;11236:7;112e9:7;112ea:9;1133b:7;1133c:7;1134d:9;11366:e6;11367:e6;11368:e6;11369:e6;1136a:e6;1136b:e6;1136c:e6;11370:e6;11371:e6;11372:e6;11373:e6;11374:e6;11442:9;11446:7;1145e:e6;114c2:9;114c3:7;115bf:9;115c0:7;1163f:9;116b6:9;116b7:7;1172b:9;11839:9;1183a:7;1193d:9;1193e:9;11943:7;119e0:9;11a34:9;11a47:9;11a99:9;11c3f:9;11d42:7;11d44:9;11d45:9;11d97:9;16af0:1;16af1:1;16af2:1;16af3:1;16af4:1;16b30:e6;16b31:e6;16b32:e6;16b33:e6;16b34:e6;16b35:e6;16b36:e6;16ff0:6;16ff1:6;1bc9e:1;1d165:d8;1d166:d8;1d167:1;1d168:1;1d169:1;1d16d:e2;1d16e:d8;1d16f:d8;1d170:d8;1d171:d8;1d172:d8;1d17b:dc;1d17c:dc;1d17d:dc;1d17e:dc;1d17f:dc;1d180:dc;1d181:dc;1d182:dc;1d185:e6;1d186:e6;1d187:e6;1d188:e6;1d189:e6;1d18a:dc;1d18b:dc;1d1aa:e6;1d1ab:e6;1d1ac:e6;1d1ad:e6;1d242:e6;1d243:e6;1d244:e6;1e000:e6;1e001:e6;1e002:e6;1e003:e6;1e004:e6;1e005:e6;1e006:e6;1e008:e6;1e009:e6;1e00a:e6;1e00b:e6;1e00c:e6;1e00d:e6;1e00e:e6;1e00f:e6;1e010:e6;1e011:e6;1e012:e6;1e013:e6;1e014:e6;1e015:e6;1e016:e6;1e017:e6;1e018:e6;1e01b:e6;1e01c:e6;1e01d:e6;1e01e:e6;1e01f:e6;1e020:e6;1e021:e6;1e023:e6;1e024:e6;1e026:e6;1e027:e6;1e028:e6;1e029:e6;1e02a:e6;1e130:e6;1e131:e6;1e132:e6;1e133:e6;1e134:e6;1e135:e6;1e136:e6;1e2ae:e6;1e2ec:e6;1e2ed:e6;1e2ee:e6;1e2ef:e6;1e8d0:dc;1e8d1:dc;1e8d2:dc;1e8d3:dc;1e8d4:dc;1e8d5:dc;1e8d6:dc;1e944:e6;1e945:e6;1e946:e6;1e947:e6;1e948:e6;1e949:e6;1e94a:7",
	comp = "3c,338:226e;3d,338:2260;3e,338:226f;41,300:c0;41,301:c1;41,302:c2;41,303:c3;41,304:100;41,306:102;41,307:226;41,308:c4;41,309:1ea2;41,30a:c5;41,30c:1cd;41,30f:200;41,311:202;41,323:1ea0;41,325:1e00;41,328:104;42,307:1e02;42,323:1e04;42,331:1e06;43,301:106;43,302:108;43,307:10a;43,30c:10c;43,327:c7;44,307:1e0a;44,30c:10e;44,323:1e0c;44,327:1e10;44,32d:1e12;44,331:1e0e;45,300:c8;45,301:c9;45,302:ca;45,303:1ebc;45,304:112;45,306:114;45,307:116;45,308:cb;45,309:1eba;45,30c:11a;45,30f:204;45,311:206;45,323:1eb8;45,327:228;45,328:118;45,32d:1e18;45,330:1e1a;46,307:1e1e;47,301:1f4;47,302:11c;47,304:1e20;47,306:11e;47,307:120;47,30c:1e6;47,327:122;48,302:124;48,307:1e22;48,308:1e26;48,30c:21e;48,323:1e24;48,327:1e28;48,32e:1e2a;49,300:cc;49,301:cd;49,302:ce;49,303:128;49,304:12a;49,306:12c;49,307:130;49,308:cf;49,309:1ec8;49,30c:1cf;49,30f:208;49,311:20a;49,323:1eca;49,328:12e;49,330:1e2c;4a,302:134;4b,301:1e30;4b,30c:1e8;4b,323:1e32;4b,327:136;4b,331:1e34;4c,301:139;4c,30c:13d;4c,323:1e36;4c,327:13b;4c,32d:1e3c;4c,331:1e3a;4d,301:1e3e;4d,307:1e40;4d,323:1e42;4e,300:1f8;4e,301:143;4e,303:d1;4e,307:1e44;4e,30c:147;4e,323:1e46;4e,327:145;4e,32d:1e4a;4e,331:1e48;4f,300:d2;4f,301:d3;4f,302:d4;4f,303:d5;4f,304:14c;4f,306:14e;4f,307:22e;4f,308:d6;4f,309:1ece;4f,30b:150;4f,30c:1d1;4f,30f:20c;4f,311:20e;4f,31b:1a0;4f,323:1ecc;4f,328:1ea;50,301:1e54;50,307:1e56;52,301:154;52,307:1e58;52,30c:158;52,30f:210;52,311:212;52,323:1e5a;52,327:156;52,331:1e5e;53,301:15a;53,302:15c;53,307:1e60;53,30c:160;53,323:1e62;53,326:218;53,327:15e;54,307:1e6a;54,30c:164;54,323:1e6c;54,326:21a;54,327:162;54,32d:1e70;54,331:1e6e;55,300:d9;55,301:da;55,302:db;55,303:168;55,304:16a;55,306:16c;55,308:dc;55,309:1ee6;55,30a:16e;55,30b:170;55,30c:1d3;55,30f:214;55,311:216;55,31b:1af;55,323:1ee4;55,324:1e72;55,328:172;55,32d:1e76;55,330:1e74;56,303:1e7c;56,323:1e7e;57,300:1e80;57,301:1e82;57,302:174;57,307:1e86;57,308:1e84;57,323:1e88;58,307:1e8a;58,308:1e8c;59,300:1ef2;59,301:dd;59,302:176;59,303:1ef8;59,304:232;59,307:1e8e;59,308:178;59,309:1ef6;59,323:1ef4;5a,301:179;5a,302:1e90;5a,307:17b;5a,30c:17d;5a,323:1e92;5a,331:1e94;61,300:e0;61,301:e1;61,302:e2;61,303:e3;61,304:101;61,306:103;61,307:227;61,308:e4;61,309:1ea3;61,30a:e5;61,30c:1ce;61,30f:201;61,311:203;61,323:1ea1;61,325:1e01;61,328:105;62,307:1e03;62,323:1e05;62,331:1e07;63,301:107;63,302:109;63,307:10b;63,30c:10d;63,327:e7;64,307:1e0b;64,30c:10f;64,323:1e0d;64,327:1e11;64,32d:1e13;64,331:1e0f;65,300:e8;65,301:e9;65,302:ea;65,303:1ebd;65,304:113;65,306:115;65,307:117;65,308:eb;65,309:1ebb;65,30c:11b;65,30f:205;65,311:207;65,323:1eb9;65,327:229;65,328:119;65,32d:1e19;65,330:1e1b;66,307:1e1f;67,301:1f5;67,302:11d;67,304:1e21;67,306:11f;67,307:121;67,30c:1e7;67,327:123;68,302:125;68,307:1e23;68,308:1e27;68,30c:21f;68,323:1e25;68,327:1e29;68,32e:1e2b;68,331:1e96;69,300:ec;69,301:ed;69,302:ee;69,303:129;69,304:12b;69,306:12d;69,308:ef;69,309:1ec9;69,30c:1d0;69,30f:209;69,311:20b;69,323:1ecb;69,328:12f;69,330:1e2d;6a,302:135;6a,30c:1f0;6b,301:1e31;6b,30c:1e9;6b,323:1e33;6b,327:137;6b,331:1e35;6c,301:13a;6c,30c:13e;6c,323:1e37;6c,327:13c;6c,32d:1e3d;6c,331:1e3b;6d,301:1e3f;6d,307:1e41;6d,323:1e43;6e,300:1f9;6e,301:144;6e,303:f1;6e,307:1e45;6e,30c:148;6e,323:1e47;6e,327:146;6e,32d:1e4b;6e,331:1e49;6f,300:f2;6f,301:f3;6f,302:f4;6f,303:f5;6f,304:14d;6f,306:14f;6f,307:22f;6f,308:f6;6f,309:1ecf;6f,30b:151;6f,30c:1d2;6f,30f:20d;6f,311:20f;6f,31b:1a1;6f,323:1ecd;6f,328:1eb;70,301:1e55;70,307:1e57;72,301:155;72,307:1e59;72,30c:159;72,30f:211;72,311:213;72,323:1e5b;72,327:157;72,331:1e5f;73,301:15b;73,302:15d;73,307:1e61;73,30c:161;73,323:1e63;73,326:219;73,327:15f;74,307:1e6b;74,308:1e97;74,30c:165;74,323:1e6d;74,326:21b;74,327:163;74,32d:1e71;74,331:1e6f;75,300:f9;75,301:fa;75,302:fb;75,303:169;75,304:16b;75,306:16d;75,308:fc;75,309:1ee7;75,30a:16f;75,30b:171;75,30c:1d4;75,30f:215;75,311:217;75,31b:1b0;75,323:1ee5;75,324:1e73;75,328:173;75,32d:1e77;75,330:1e75;76,303:1e7d;76,323:1e7f;77,300:1e81;77,301:1e83;77,302:175;77,307:1e87;77,308:1e85;77,30a:1e98;77,323:1e89;78,307:1e8b;78,308:1e8d;79,300:1ef3;79,301:fd;79,302:177;79,303:1ef9;79,304:233;79,307:1e8f;79,308:ff;79,309:1ef7;79,30a:1e99;79,323:1ef5;7a,301:17a;7a,302:1e91;7a,307:17c;7a,30c:17e;7a,323:1e93;7a,331:1e95;a8,300:1fed;a8,301:385;a8,342:1fc1;c2,300:1ea6;c2,301:1ea4;c2,303:1eaa;c2,309:1ea8;c4,304:1de;c5,301:1fa;c6,301:1fc;c6,304:1e2;c7,301:1e08;ca,300:1ec0;ca,301:1ebe;ca,303:1ec4;ca,309:1ec2;cf,301:1e2e;d4,300:1ed2;d4,301:1ed0;d4,303:1ed6;d4,309:1ed4;d5,301:1e4c;d5,304:22c;d5,308:1e4e;d6,304:22a;d8,301:1fe;dc,300:1db;dc,301:1d7;dc,304:1d5;dc,30c:1d9;e2,300:1ea7;e2,301:1ea5;e2,303:1eab;e2,309:1ea9;e4,304:1df;e5,301:1fb;e6,301:1fd;e6,304:1e3;e7,301:1e09;ea,300:1ec1;ea,301:1ebf;ea,303:1ec5;ea,309:1ec3;ef,301:1e2f;f4,300:1ed3;f4,301:1ed1;f4,303:1ed7;f4,309:1ed5;f5,301:1e4d;f5,304:22d;f5,308:1e4f;f6,304:22b;f8,301:1ff;fc,300:1dc;fc,301:1d8;fc,304:1d6;fc,30c:1da;102,300:1eb0;102,301:1eae;102,303:1eb4;102,309:1eb2;103,300:1eb1;103,301:1eaf;103,303:1eb5;103,309:1eb3;112,300:1e14;112,301:1e16;113,300:1e15;113,301:1e17;14c,300:1e50;14c,301:1e52;14d,300:1e51;14d,301:1e53;15a,307:1e64;15b,307:1e65;160,307:1e66;161,307:1e67;168,301:1e78;169,301:1e79;16a,308:1e7a;16b,308:1e7b;17f,307:1e9b;1a0,300:1edc;1a0,301:1eda;1a0,303:1ee0;1a0,309:1ede;1a0,323:1ee2;1a1,300:1edd;1a1,301:1edb;1a1,303:1ee1;1a1,309:1edf;1a1,323:1ee3;1af,300:1eea;1af,301:1ee8;1af,303:1eee;1af,309:1eec;1af,323:1ef0;1b0,300:1eeb;1b0,301:1ee9;1b0,303:1eef;1b0,309:1eed;1b0,323:1ef1;1b7,30c:1ee;1ea,304:1ec;1eb,304:1ed;226,304:1e0;227,304:1e1;228,306:1e1c;229,306:1e1d;22e,304:230;22f,304:231;292,30c:1ef;391,300:1fba;391,301:386;391,304:1fb9;391,306:1fb8;391,313:1f08;391,314:1f09;391,345:1fbc;395,300:1fc8;395,301:388;395,313:1f18;395,314:1f19;397,300:1fca;397,301:389;397,313:1f28;397,314:1f29;397,345:1fcc;399,300:1fda;399,301:38a;399,304:1fd9;399,306:1fd8;399,308:3aa;399,313:1f38;399,314:1f39;39f,300:1ff8;39f,301:38c;39f,313:1f48;39f,314:1f49;3a1,314:1fec;3a5,300:1fea;3a5,301:38e;3a5,304:1fe9;3a5,306:1fe8;3a5,308:3ab;3a5,314:1f59;3a9,300:1ffa;3a9,301:38f;3a9,313:1f68;3a9,314:1f69;3a9,345:1ffc;3ac,345:1fb4;3ae,345:1fc4;3b1,300:1f70;3b1,301:3ac;3b1,304:1fb1;3b1,306:1fb0;3b1,313:1f00;3b1,314:1f01;3b1,342:1fb6;3b1,345:1fb3;3b5,300:1f72;3b5,301:3ad;3b5,313:1f10;3b5,314:1f11;3b7,300:1f74;3b7,301:3ae;3b7,313:1f20;3b7,314:1f21;3b7,342:1fc6;3b7,345:1fc3;3b9,300:1f76;3b9,301:3af;3b9,304:1fd1;3b9,306:1fd0;3b9,308:3ca;3b9,313:1f30;3b9,314:1f31;3b9,342:1fd6;3bf,300:1f78;3bf,301:3cc;3bf,313:1f40;3bf,314:1f41;3c1,313:1fe4;3c1,314:1fe5;3c5,300:1f7a;3c5,301:3cd;3c5,304:1fe1;3c5,306:1fe0;3c5,308:3cb;3c5,313:1f50;3c5,314:1f51;3c5,342:1fe6;3c9,300:1f7c;3c9,301:3ce;3c9,313:1f60;3c9,314:1f61;3c9,342:1ff6;3c9,345:1ff3;3ca,300:1fd2;3ca,301:390;3ca,342:1fd7;3cb,300:1fe2;3cb,301:3b0;3cb,342:1fe7;3ce,345:1ff4;3d2,301:3d3;3d2,308:3d4;406,308:407;410,306:4d0;410,308:4d2;413,301:403;415,300:400;415,306:4d6;415,308:401;416,306:4c1;416,308:4dc;417,308:4de;418,300:40d;418,304:4e2;418,306:419;418,308:4e4;41a,301:40c;41e,308:4e6;423,304:4ee;423,306:40e;423,308:4f0;423,30b:4f2;427,308:4f4;42b,308:4f8;42d,308:4ec;430,306:4d1;430,308:4d3;433,301:453;435,300:450;435,306:4d7;435,308:451;436,306:4c2;436,308:4dd;437,308:4df;438,300:45d;438,304:4e3;438,306:439;438,308:4e5;43a,301:45c;43e,308:4e7;443,304:4ef;443,306:45e;443,308:4f1;443,30b:4f3;447,308:4f5;44b,308:4f9;44d,308:4ed;456,308:457;474,30f:476;475,30f:477;4d8,308:4da;4d9,308:4db;4e8,308:4ea;4e9,308:4eb;627,653:622;627,654:623;627,655:625;648,654:624;64a,654:626;6c1,654:6c2;6d2,654:6d3;6d5,654:6c0;928,93c:929;930,93c:931;933,93c:934;9c7,9be:9cb;9c7,9d7:9cc;b47,b3e:b4b;b47,b56:b48;b47,b57:b4c;b92,bd7:b94;bc6,bbe:bca;bc6,bd7:bcc;bc7,bbe:bcb;c46,c56:c48;cbf,cd5:cc0;cc6,cc2:cca;cc6,cd5:cc7;cc6,cd6:cc8;cca,cd5:ccb;d46,d3e:d4a;d46,d57:d4c;d47,d3e:d4b;dd9,dca:dda;dd9,dcf:ddc;dd9,ddf:dde;ddc,dca:ddd;1025,102e:1026;1b05,1b35:1b06;1b07,1b35:1b08;1b09,1b35:1b0a;1b0b,1b35:1b0c;1b0d,1b35:1b0e;1b11,1b35:1b12;1b3a,1b35:1b3b;1b3c,1b35:1b3d;1b3e,1b35:1b40;1b3f,1b35:1b41;1b42,1b35:1b43;1e36,304:1e38;1e37,304:1e39;1e5a,304:1e5c;1e5b,304:1e5d;1e62,307:1e68;1e63,307:1e69;1ea0,302:1eac;1ea0,306:1eb6;1ea1,302:1ead;1ea1,306:1eb7;1eb8,302:1ec6;1eb9,302:1ec7;1ecc,302:1ed8;1ecd,302:1ed9;1f00,300:1f02;1f00,301:1f04;1f00,342:1f06;1f00,345:1f80;1f01,300:1f03;1f01,301:1f05;1f01,342:1f07;1f01,345:1f81;1f02,345:1f82;1f03,345:1f83;1f04,345:1f84;1f05,345:1f85;1f06,345:1f86;1f07,345:1f87;1f08,300:1f0a;1f08,301:1f0c;1f08,342:1f0e;1f08,345:1f88;1f09,300:1f0b;1f09,301:1f0d;1f09,342:1f0f;1f09,345:1f89;1f0a,345:1f8a;1f0b,345:1f8b;1f0c,345:1f8c;1f0d,345:1f8d;1f0e,345:1f8e;1f0f,345:1f8f;1f10,300:1f12;1f10,301:1f14;1f11,300:1f13;1f11,301:1f15;1f18,300:1f1a;1f18,301:1f1c;1f19,300:1f1b;1f19,301:1f1d;1f20,300:1f22;1f20,301:1f24;1f20,342:1f26;1f20,345:1f90;1f21,300:1f23;1f21,301:1f25;1f21,342:1f27;1f21,345:1f91;1f22,345:1f92;1f23,345:1f93;1f24,345:1f94;1f25,345:1f95;1f26,345:1f96;1f27,345:1f97;1f28,300:1f2a;1f28,301:1f2c;1f28,342:1f2e;1f28,345:1f98;1f29,300:1f2b;1f29,301:1f2d;1f29,342:1f2f;1f29,345:1f99;1f2a,345:1f9a;1f2b,345:1f9b;1f2c,345:1f9c;1f2d,345:1f9d;1f2e,345:1f9e;1f2f,345:1f9f;1f30,300:1f32;1f30,301:1f34;1f30,342:1f36;1f31,300:1f33;1f31,301:1f35;1f31,342:1f37;1f38,300:1f3a;1f38,301:1f3c;1f38,342:1f3e;1f39,300:1f3b;1f39,301:1f3d;1f39,342:1f3f;1f40,300:1f42;1f40,301:1f44;1f41,300:1f43;1f41,301:1f45;1f48,300:1f4a;1f48,301:1f4c;1f49,300:1f4b;1f49,301:1f4d;1f50,300:1f52;1f50,301:1f54;1f50,342:1f56;1f51,300:1f53;1f51,301:1f55;1f51,342:1f57;1f59,300:1f5b;1f59,301:1f5d;1f59,342:1f5f;1f60,300:1f62;1f60,301:1f64;1f60,342:1f66;1f60,345:1fa0;1f61,300:1f63;1f61,301:1f65;1f61,342:1f67;1f61,345:1fa1;1f62,345:1fa2;1f63,345:1fa3;1f64,345:1fa4;1f65,345:1fa5;1f66,345:1fa6;1f67,345:1fa7;1f68,300:1f6a;1f68,301:1f6c;1f68,342:1f6e;1f68,345:1fa8;1f69,300:1f6b;1f69,301:1f6d;1f69,342:1f6f;1f69,345:1fa9;1f6a,345:1faa;1f6b,345:1fab;1f6c,345:1fac;1f6d,345:1fad;1f6e,345:1fae;1f6f,345:1faf;1f70,345:1fb2;1f74,345:1fc2;1f7c,345:1ff2;1fb6,345:1fb7;1fbf,300:1fcd;1fbf,301:1fce;1fbf,342:1fcf;1fc6,345:1fc7;1ff6,345:1ff7;1ffe,300:1fdd;1ffe,301:1fde;1ffe,342:1fdf;2190,338:219a;2192,338:219b;2194,338:21ae;21d0,338:21cd;21d2,338:21cf;21d4,338:21ce;2203,338:2204;2208,338:2209;220b,338:220c;2223,338:2224;2225,338:2226;223c,338:2241;2243,338:2244;2245,338:2247;2248,338:2249;224d,338:226d;2261,338:2262;2264,338:2270;2265,338:2271;2272,338:2274;2273,338:2275;2276,338:2278;2277,338:2279;227a,338:2280;227b,338:2281;227c,338:22e0;227d,338:22e1;2282,338:2284;2283,338:2285;2286,338:2288;2287,338:2289;2291,338:22e2;2292,338:22e3;22a2,338:22ac;22a8,338:22ad;22a9,338:22ae;22ab,338:22af;22b2,338:22ea;22b3,338:22eb;22b4,338:22ec;22b5,338:22ed;3046,3099:3094;304b,3099:304c;304d,3099:304e;304f,3099:3050;3051,3099:3052;3053,3099:3054;3055,3099:3056;3057,3099:3058;3059,3099:305a;305b,3099:305c;305d,3099:305e;305f,3099:3060;3061,3099:3062;3064,3099:3065;3066,3099:3067;3068,3099:3069;306f,3099:3070;306f,309a:3071;3072,3099:3073;3072,309a:3074;3075,3099:3076;3075,309a:3077;3078,3099:3079;3078,309a:307a;307b,3099:307c;307b,309a:307d;309d,3099:309e;30a6,3099:30f4;30ab,3099:30ac;30ad,3099:30ae;30af,3099:30b0;30b1,3099:30b2;30b3,3099:30b4;30b5,3099:30b6;30b7,3099:30b8;30b9,3099:30ba;30bb,3099:30bc;30bd,3099:30be;30bf,3099:30c0;30c1,3099:30c2;30c4,3099:30c5;30c6,3099:30c7;30c8,3099:30c9;30cf,3099:30d0;30cf,309a:30d1;30d2,3099:30d3;30d2,309a:30d4;30d5,3099:30d6;30d5,309a:30d7;30d8,3099:30d9;30d8,309a:30da;30db,3099:30dc;30db,309a:30dd;30ef,3099:30f7;30f0,3099:30f8;30f1,3099:30f9;30f2,3099:30fa;30fd,3099:30fe;11099,110ba:1109a;1109b,110ba:1109c;110a5,110ba:110ab;11131,11127:1112e;11132,11127:1112f;11347,1133e:1134b;11347,11357:1134c;114b9,114b0:114bc;114b9,114ba:114bb;114b9,114bd:114be;115b8,115af:115ba;115b9,115af:115bb;11935,11930:11938",
}

end)()
local __ROBLOX = (function()
-- generated by gen_roblox.py from the Roblox API dump (1)
return {
	enums = "AccessModifierType:Allow=0,Deny=1;AccessoryType:Unknown=0,Hat=1,Hair=2,Face=3,Neck=4,Shoulder=5,Front=6,Back=7,Waist=8,TShirt=9,Shirt=10,Pants=11,Jacket=12,Sweater=13,Shorts=14,LeftShoe=15,RightShoe=16,DressSkirt=17,Eyebrow=18,Eyelash=19;ActionOnAutoResumeSync:DontResume=0,KeepStudio=1,KeepLocal=2;ActionOnStopSync:AlwaysAsk=0,KeepLocalFiles=1,DeleteLocalFiles=2;ActionType:Nothing=0,Pause=1,Lose=2,Draw=3,Win=4;ActivePayerStatus:Unknown=0,Never=1,Lapsed=2,Casual50Percent=3,Intermediate35Percent=4,Top15Percent=5;ActuatorRelativeTo:Attachment0=0,Attachment1=1,World=2;ActuatorType:None=0,Motor=1,Servo=2;AdAvailabilityResult:IsAvailable=1,DeviceIneligible=2,ExperienceIneligible=3,InternalError=4,NoFill=5,PlayerIneligible=6,PublisherIneligible=7;AdEventType:VideoLoaded=0,VideoRemoved=1,UserCompletedVideo=2,RewardedAdLoaded=3,RewardedAdGrant=4,RewardedAdUnloaded=5;AdFormat:RewardedVideo=0;AdShape:HorizontalRectangle=1;AdTeleportMethod:Undefined=0,PortalForward=1,InGameMenuBackButton=2,UIBackButton=3;AdUIEventType:AdLabelClicked=0,VolumeButtonClicked=1,FullscreenButtonClicked=2,PlayButtonClicked=3,PauseButtonClicked=4,CloseButtonClicked=5,WhyThisAdClicked=6,PlayEventTriggered=7,PauseEventTriggered=8;AdUIType:None=0,Image=1,Video=2;AdUnitStatus:Inactive=0,Active=1;AdornCullingMode:Automatic=0,Never=1;AdornShading:Default=0,Shaded=1,XRay=2,XRayShaded=3,AlwaysOnTop=4;AgeCheckStatus:Unchecked=0,Checked=1;AlignType:Parallel=0,Perpendicular=1,PrimaryAxisParallel=2,PrimaryAxisPerpendicular=3,PrimaryAxisLookAt=4,AllAxes=5;AlphaMode:Overlay=0,Transparency=1,TintMask=2,Opaque=3;AnalyticsCustomFieldKeys:CustomField01=0,CustomField02=1,CustomField03=2;AnalyticsEconomyAction:Default=0,Acquire=1,Spend=2;AnalyticsEconomyFlowType:Sink=0,Source=1;AnalyticsEconomyTransactionType:IAP=0,Shop=1,Gameplay=2,ContextualPurchase=3,TimedReward=4,Onboarding=5;AnalyticsLogLevel:Trace=0,Debug=1,Information=2,Warning=3,Error=4,Fatal=5;AnalyticsProgressionStatus:Default=0,Begin=1,Complete=2,Abandon=3,Fail=4;AnalyticsProgressionType:Custom=0,Start=1,Fail=2,Complete=3;AnimatedImagePlaybackState:Begin=0,Playing=1,Paused=2,Completed=3,Canceled=4;AnimatedImageScaleType:Stretch=0,Tile=1,Fit=2,Crop=3;AnimationClipFromVideoStatus:Initializing=0,Pending=1,Processing=2,ErrorGeneric=4,Success=6,ErrorVideoTooLong=7,ErrorNoPersonDetected=8,ErrorVideoUnstable=9,Timeout=10,Cancelled=11,ErrorMultiplePeople=12,ErrorUploadingVideo=2001;AnimationNodeBlend2DInputMode:Cartesian=0,Polar=1;AnimationNodeBlendMode:Over=0,Add=1,Subtract=2;AnimationNodeInterruptible:Always=0,Finished=1,Trigger=2;AnimationNodePhaseSync:Synced=0,Unsynced=1;AnimationNodePlayMode:Loop=0,PingPong=1,OnceAndHold=2,OnceAndReset=3;AnimationNodeTransitionType:CrossFade=0,InertialBlend=1,DeadBlend=2;AnimationNodeTransitionWhen:Finished=0,BeforeFinished=1;AnimationNodeType:InvalidNode=0,AddNode=1,OverNode=2,Blend1DNode=3,Blend2DNode=4,ClipNode=5,GraphOutput=6,MaskNode=7,PrioritySelectNode=8,RandomSequenceNode=9,SelectNode=10,SequenceNode=11,SpeedNode=12,SubtractNode=13,OneShotNode=14,StateMachineNode=16;AnimationNodeWaitFor:Finished=0,Trigger=1;AnimationPriority:Idle=0,Movement=1,Action=2,Action2=3,Action3=4,Action4=5,Core=1000;AnimationValueNodeType:Invalid=0,Expression=1;AnimatorRetargetingMode:Default=0,Disabled=1,Enabled=2;AnnotationChannelContentPreference:None=0,All=1,Unknown=2;AnnotationEditingMode:None=0,PlacingNew=1,WritingNew=2;AnnotationPlaceContentPreference:None=0,All=1,MentionsAndReplies=2,Unknown=3;AnnotationRequestStatus:Success=0,Loading=1,ErrorInternalFailure=2,ErrorNotFound=3,ErrorModerated=4;AnnotationRequestType:Unknown=0,Create=1,Resolve=2,Delete=3,Edit=4;AntiAliasing:Disabled=0,Enabled=1;AppLifecycleManagerState:Detached=0,Active=1,Inactive=2,Hidden=3;AppShellActionType:None=0,OpenApp=1,TapChatTab=2,TapConversationEntry=3,TapAvatarTab=4,ReadConversation=5,TapGamePageTab=6,TapHomePageTab=7,GamePageLoaded=8,HomePageLoaded=9,AvatarEditorPageLoaded=10,HomePageInteractive=11;AppShellFeature:None=0,Chat=1,AvatarEditor=2,GamePage=3,HomePage=4,More=5,Landing=6,WatchPage=7;AppUpdateStatus:Unknown=0,NotSupported=1,Failed=2,NotAvailable=3,Available=4,AvailableBoundChannel=5,AvailableBetaProgram=6;ApplyShadowMode:Shape=0,Text=1;ApplyStrokeMode:Contextual=0,Border=1;AspectType:FitWithinMaxSize=0,ScaleWithParentSize=1;AssetCreatorType:User=0,Group=1;AssetFetchStatus:Success=0,Failure=1,None=2,Loading=3,TimedOut=4;AssetRepresentation:FullLength=0,ShortPreview=1;AssetType:Image=1,TShirt=2,Audio=3,Mesh=4,Lua=5,Hat=8,Place=9,Model=10,Shirt=11,Pants=12,Decal=13,Head=17,Face=18,Gear=19,Badge=21,Animation=24,Torso=27,RightArm=28,LeftArm=29,LeftLeg=30,RightLeg=31,Package=32,GamePass=34,Plugin=38,MeshPart=40,HairAccessory=41,FaceAccessory=42,NeckAccessory=43,ShoulderAccessory=44,FrontAccessory=45,BackAccessory=46,WaistAccessory=47,ClimbAnimation=48,DeathAnimation=49,FallAnimation=50,IdleAnimation=51,JumpAnimation=52,RunAnimation=53,SwimAnimation=54,WalkAnimation=55,PoseAnimation=56,EarAccessory=57,EyeAccessory=58,EmoteAnimation=61,Video=62,TShirtAccessory=64,ShirtAccessory=65,PantsAccessory=66,JacketAccessory=67,SweaterAccessory=68,ShortsAccessory=69,LeftShoeAccessory=70,RightShoeAccessory=71,DressSkirtAccessory=72,FontFamily=73,EyebrowAccessory=76,EyelashAccessory=77,MoodAnimation=78,DynamicHead=79,FaceMakeup=88,LipMakeup=89,EyeMakeup=90,AvatarBackground=92,TextDocument=93;AssetTypeVerification:Default=1,ClientOnly=2,Always=3;AudioApiRollout:Disabled=0,Automatic=1,Enabled=2;AudioCaptureMode:;AudioChannelLayout:Mono=0,Stereo=1,Quad=2,Surround_5=3,Surround_5_1=4,Surround_7_1=5,Surround_7_1_4=6;AudioFilterType:Peak=0,LowShelf=1,HighShelf=2,Lowpass12dB=3,Lowpass24dB=4,Lowpass48dB=5,Highpass12dB=6,Highpass24dB=7,Highpass48dB=8,Bandpass=9,Notch=10,Lowpass6dB=11;AudioPositionType:Parent=0,Instance=1;AudioSampleFormat:Int16=0,Float32=1;AudioSimulationFidelity:None=0,Automatic=1;AudioSubType:Music=1,SoundEffect=2;AudioWindowSize:Small=0,Medium=1,Large=2;AuthorityMode:Server=0,Automatic=1;AutoIndentRule:Off=0,Absolute=1,Relative=2;AutomaticSize:None=0,X=1,Y=2,XY=3;AvatarAssetType:TShirt=2,Hat=8,Shirt=11,Pants=12,Head=17,Face=18,Gear=19,Torso=27,RightArm=28,LeftArm=29,LeftLeg=30,RightLeg=31,HairAccessory=41,FaceAccessory=42,NeckAccessory=43,ShoulderAccessory=44,FrontAccessory=45,BackAccessory=46,WaistAccessory=47,ClimbAnimation=48,FallAnimation=50,IdleAnimation=51,JumpAnimation=52,RunAnimation=53,SwimAnimation=54,WalkAnimation=55,EmoteAnimation=61,TShirtAccessory=64,ShirtAccessory=65,PantsAccessory=66,JacketAccessory=67,SweaterAccessory=68,ShortsAccessory=69,LeftShoeAccessory=70,RightShoeAccessory=71,DressSkirtAccessory=72,EyebrowAccessory=76,EyelashAccessory=77,MoodAnimation=78,DynamicHead=79,FaceMakeup=88,LipMakeup=89,EyeMakeup=90,AvatarBackground=92;AvatarChatServiceFeature:None=0,UniverseAudio=1,UniverseVideo=2,PlaceAudio=4,PlaceVideo=8,UserAudioEligible=16,UserAudio=32,UserVideoEligible=64,UserVideo=128,UserBanned=256,UserVerifiedForVoice=512;AvatarContextMenuOption:Friend=0,Chat=1,Emote=2,InspectMenu=3;AvatarGenerationError:None=0,Unknown=1,DownloadFailed=2,Canceled=3,Offensive=4,Timeout=5,JobNotFound=6;AvatarItemType:Asset=1,Bundle=2;AvatarPromptResult:Success=1,PermissionDenied=2,Failed=3;AvatarSettingsAccessoryLimitMethod:Scale=0,Remove=1,PreviewScale=2,PreviewRemove=3;AvatarSettingsAccessoryMode:PlayerChoice=0,CustomLimit=1;AvatarSettingsAnimationClipsMode:PlayerChoice=0,CustomClips=1;AvatarSettingsAnimationPacksMode:PlayerChoice=0,StandardR15=1,StandardR6=2;AvatarSettingsAppearanceMode:PlayerChoice=0,CustomParts=1,CustomBody=2;AvatarSettingsBuildMode:PlayerChoice=0,CustomBuild=1;AvatarSettingsCharacterControllerMode:LegacyHumanoid=0,LuaCharacterController=1;AvatarSettingsClothingMode:PlayerChoice=0,CustomLimit=1;AvatarSettingsCollisionMode:Default=0,SingleCollider=1,Legacy=2;AvatarSettingsCustomAccessoryMode:PlayerChoice=0,CustomAccessories=1;AvatarSettingsCustomBodyType:AvatarReference=0,BundleId=1;AvatarSettingsCustomClothingMode:PlayerChoice=0,CustomClothing=1;AvatarSettingsHitAndTouchDetectionMode:UseParts=0,UseCollider=1;AvatarSettingsJumpMode:JumpHeight=0,JumpPower=1;AvatarSettingsLegacyCollisionMode:R6Colliders=0,InnerBoxColliders=1;AvatarSettingsScaleMode:PlayerChoice=0,CustomScale=1;AvatarThumbnailCustomizationType:Closeup=1,FullBody=2;AvatarUnificationMode:Default=0,Disabled=1,Enabled=2;Axis:X=0,Y=1,Z=2;BasicMeshPartShape:Capsule=5,Cone=6,RoundedBox=7;BenefitType:DeveloperProduct=0,AvatarAsset=1,AvatarBundle=2;BinType:Script=0,GameTool=1,Grab=2,Clone=3,Hammer=4;BodyPart:Head=0,Torso=1,LeftArm=2,RightArm=3,LeftLeg=4,RightLeg=5;BodyPartR15:Head=0,UpperTorso=1,LowerTorso=2,LeftFoot=3,LeftLowerLeg=4,LeftUpperLeg=5,RightFoot=6,RightLowerLeg=7,RightUpperLeg=8,LeftHand=9,LeftLowerArm=10,LeftUpperArm=11,RightHand=12,RightLowerArm=13,RightUpperArm=14,RootPart=15,Unknown=17;BorderMode:Outline=0,Middle=1,Inset=2;BorderStrokePosition:Outer=0,Center=1,Inner=2;BranchStatus:Draft=0,ReadyToMerge=1,Merged=2,Archived=3;BreakReason:Other=0,Error=1,SpecialBreakpoint=2,UserBreakpoint=3;BreakpointRemoveReason:Requested=0,ScriptChanged=1,ScriptRemoved=2;BulkMoveMode:FireAllEvents=0,FireCFrameChanged=1;BundleType:BodyParts=1,Animations=2,Shoes=3,DynamicHead=4,DynamicHeadAvatar=5;Button:Dismount=8,Jump=32;ButtonStyle:Custom=0,RobloxButtonDefault=1,RobloxButton=2,RobloxRoundButton=3,RobloxRoundDefaultButton=4,RobloxRoundDropdownButton=5;CageType:Inner=0,Outer=1;CameraMode:Classic=0,LockFirstPerson=1;CameraNavigationModel:Roblox=0,IndustryCompatible=1;CameraPanMode:Classic=0,EdgeBump=1;CameraSpeedAdjustBinding:None=0,RmbScroll=1,AltScroll=2;CameraType:Fixed=0,Attach=1,Watch=2,Track=3,Follow=4,Custom=5,Scriptable=6,Orbital=7;CanCollaborateError:Invalid=0,None=1,NotAgeVerified=2,OutsideAgeBucket=3,TooManyCollaborators=4,PCBlock=5,NotFound=6,OutsideOwnerAgeBucket=7,NotAuthorized=8,OutsideAgeBucketTcPc=9,OtherCollaboratorSettingsPreventTrust=10,AgeVerificationCountryBlocked=11,OtherUserCannotCollaborate=12;CaptureGalleryPermission:ReadAndUpload=0;CaptureType:Screenshot=1,Video=2;CatalogCategoryFilter:None=1,Featured=2,Collectibles=3,CommunityCreations=4,Premium=5,Recommended=6;CatalogSortAggregation:Past12Hours=1,PastDay=2,Past3Days=3,PastWeek=4,PastMonth=5,AllTime=6;CatalogSortType:Relevance=1,PriceHighToLow=2,PriceLowToHigh=3,MostFavorited=5,RecentlyCreated=6,Bestselling=7;CellBlock:Solid=0,VerticalWedge=1,CornerWedge=2,InverseCornerWedge=3,HorizontalWedge=4;CellMaterial:Empty=0,Grass=1,Sand=2,Brick=3,Granite=4,Asphalt=5,Iron=6,Aluminum=7,Gold=8,WoodPlank=9,WoodLog=10,Gravel=11,CinderBlock=12,MossyStone=13,Cement=14,RedPlastic=15,BluePlastic=16,Water=17;CellOrientation:NegZ=0,X=1,Z=2,NegX=3;CenterDialogType:UnsolicitedDialog=1,PlayerInitiatedDialog=2,ModalDialog=3,QuitDialog=4;CharacterControlMode:Default=0,Legacy=1,NoCharacterController=2,LuaCharacterController=3;ChatCallbackType:OnCreatingChatWindow=1,OnClientSendingMessage=2,OnClientFormattingMessage=3,OnServerReceivingMessage=17;ChatColor:Blue=0,Green=1,Red=2,White=3;ChatMode:Menu=0,TextAndMenu=1;ChatPrivacyMode:AllUsers=0,NoOne=1,Friends=2;ChatRestrictionStatus:Unknown=0,NotRestricted=1,Restricted=2;ChatStyle:Classic=0,Bubble=1,ClassicAndBubble=2;ChatVersion:LegacyChatService=0,TextChatService=1;ClientAnimatorThrottlingMode:Default=0,Disabled=1,Enabled=2;CloseReason:Unknown=0,RobloxMaintenance=1,DeveloperShutdown=2,DeveloperUpdate=3,ServerEmpty=4,OutOfMemory=5,Moderation=6;CollaboratorStatus:None=0,Editing3D=1,Scripting=2,PrivateScripting=3;CollisionFidelity:Default=0,Hull=1,Box=2,PreciseConvexDecomposition=3,Tunable=4;CommandPermission:Plugin=0,LocalUser=1;CompileTarget:Client=0,CoreScript=1,Studio=2,CoreScriptRaw=3;CompletionAcceptanceBehavior:Insert=0,Replace=1,ReplaceOnEnterInsertOnTab=2,InsertOnEnterReplaceOnTab=3;CompletionItemKind:Text=1,Method=2,Function=3,Constructor=4,Field=5,Variable=6,Class=7,Interface=8,Module=9,Property=10,Unit=11,Value=12,Enum=13,Keyword=14,Snippet=15,Color=16,File=17,Reference=18,Folder=19,EnumMember=20,Constant=21,Struct=22,Event=23,Operator=24,TypeParameter=25;CompletionItemTag:Deprecated=1,IncorrectIndexType=2,PluginPermissions=3,CommandLinePermissions=4,RobloxPermissions=5,AddParens=6,PutCursorInParens=7,TypeCorrect=8,ClientServerBoundaryViolation=9,Invalidated=10,PutCursorBeforeEnd=11;CompletionTriggerKind:Invoked=1,TriggerCharacter=2,TriggerForIncompleteCompletions=3;CompositeValueCurveType:ColorRGB=0,ColorHSV=1,NumberRange=2,Rect=3,UDim=4,UDim2=5,Vector2=6,Vector3=7;CompressionAlgorithm:Zstd=0;ComputerCameraMovementMode:Default=0,Classic=1,Follow=2,Orbital=3,CameraToggle=4;ComputerMovementMode:Default=0,KeyboardMouse=1,ClickToMove=2;ConfigSnapshotErrorState:None=0,LoadFailed=1;ConnectionError:OK=0,Unknown=1,ConnectErrors=2,AlreadyConnected=3,NoFreeIncomingConnections=4,ConnectionBanned=5,InvalidPassword=6,IncompatibleProtocolVersion=7,IPRecentlyConnected=8,OurSystemRequiresSecurity=9,SecurityKeyMismatch=10,DisconnectErrors=256,DisconnectBadhash=257,DisconnectSecurityKeyMismatch=258,DisconnectProtocolMismatch=259,DisconnectReceivePacketError=260,DisconnectReceivePacketStreamError=261,DisconnectSendPacketError=262,DisconnectIllegalTeleport=263,DisconnectDuplicatePlayer=264,DisconnectDuplicateTicket=265,DisconnectTimeout=266,DisconnectLuaKick=267,DisconnectOnRemoteSysStats=268,DisconnectHashTimeout=269,DisconnectCloudEditKick=270,DisconnectPlayerless=271,DisconnectNewSecurityKeyMismatch=272,DisconnectEvicted=273,DisconnectDevMaintenance=274,DisconnectRobloxMaintenance=275,DisconnectRejoin=276,DisconnectConnectionLost=277,DisconnectIdle=278,DisconnectRaknetErrors=279,DisconnectWrongVersion=280,DisconnectBySecurityPolicy=281,DisconnectBlockedIP=282,DisconnectClientFailure=284,DisconnectClientRequest=285,DisconnectPrivateServerKickout=286,DisconnectModeratedGame=287,ServerShutdown=288,ReplicatorTimeout=290,PlayerRemoved=291,DisconnectOutOfMemoryKeepPlayingLeave=292,DisconnectRomarkEndOfTest=293,DisconnectCollaboratorPermissionRevoked=294,DisconnectCollaboratorUnderage=295,NetworkInternal=296,NetworkSend=297,NetworkTimeout=298,NetworkMisbehavior=299,NetworkSecurity=300,ReplacementReady=301,ServerEmpty=302,PhantomFreeze=303,AndroidAnticheatKick=304,AndroidEmulatorKick=305,AndroidRootedKick=306,ScreentimeLockoutKick=307,DisconnectionNotification=308,DisconnectVerboselyModeratedGame=309,DisconnectCollaboratorNotAgeVerified=310,DisconnectCollaboratorTrustedConnectionsRequired=311,DisconnectCollaboratorOwnerActionRequired=312,DisconnectCollaboratorTooManyCollaborators=313,DisconnectCollaboratorUnknownError=314,DisconnectCollaboratorRequestedEviction=315,DisconnectCollaboratorTrustedConnectionsRequiredPC=316,DisconnectRemoteAttestationUnsupported=317,DisconnectRemoteAttestationGeneralFailure=318,DisconnectRemoteAttestationTimeout=319,DisconnectRemoteAttestationOSOutOfDate=320,DisconnectRemoteAttestationBootValidationFailure=321,PlacelaunchErrors=512,PlacelaunchDisabled=515,PlacelaunchError=516,PlacelaunchGameEnded=517,PlacelaunchGameFull=518,PlacelaunchUserLeft=522,PlacelaunchRestricted=523,PlacelaunchUnauthorized=524,PlacelaunchFlooded=525,PlacelaunchHashExpired=526,PlacelaunchHashException=527,PlacelaunchPartyCannotFit=528,PlacelaunchHttpError=529,PlacelaunchUserPrivacyUnauthorized=533,PlacelaunchVipOwnerNotPresent=541,PlacelaunchAgeVerificationRequired=542,PlacelaunchParentalApprovalRequired=543,PlacelaunchCoreGated=544,PlacelaunchCollaborationCoreGated=545,PlacelaunchCreatorBan=600,PlacelaunchDeviceBlock=601,PlacelaunchCustomMessage=610,PlacelaunchOtherError=611,TeleportErrors=768,TeleportFailure=769,TeleportGameNotFound=770,TeleportGameEnded=771,TeleportGameFull=772,TeleportUnauthorized=773,TeleportFlooded=774,TeleportIsTeleporting=775,TransportErrors=1024,DisconnectTransportIoError=1025,DisconnectTransportIoInternetError=1026,DisconnectTransportProtocolError=1027,DisconnectTransportNgtcp2Error=1028,DisconnectTransportQuicError=1029,DisconnectTransportRnaError=1030;ConnectionState:Connected=0,Disconnected=1;ContentSourceType:None=0,Uri=1,Object=2,Opaque=3;ContextActionPriority:Low=1000,Medium=2000,High=3000;ContextActionResult:Sink=0,Pass=1;ControlMode:Classic=0,MouseLockSwitch=1;CoreGuiType:PlayerList=0,Health=1,Backpack=2,Chat=3,All=4,EmotesMenu=5,SelfView=6,Captures=7,AvatarSwitcher=8,ExperienceShop=9;CreateAssetResult:Success=1,PermissionDenied=2,UploadFailed=3,Unknown=4;CreateContentResult:Success=1,PermissionDenied=2,UploadFailed=3,StorageLimitExceeded=4,Unknown=5;CreateOutfitFailure:InvalidName=1,OutfitLimitReached=2,Other=3;CreatorType:User=0,Group=1;CreatorTypeFilter:User=0,Group=1,All=2;CurrencyType:Default=0,Robux=1,Tix=2;CustomCameraMode:Default=0,Classic=1,Follow=2;DataModelChangeType:Add=0,Remove=1,Modify=2,AddPackage=3;DataModelExtractorFileType:PlaceFile=0,FirstSlice=1,NonFirstSlice=2;DataStoreRequestType:GetAsync=0,SetIncrementAsync=1,UpdateAsync=2,GetSortedAsync=3,SetIncrementSortedAsync=4,OnUpdate=5,ListAsync=6,GetVersionAsync=7,RemoveVersionAsync=8,StandardRead=9,StandardWrite=10,StandardList=11,StandardRemove=12,OrderedRead=13,OrderedWrite=14,OrderedList=15,OrderedRemove=16;DebugBreakModeType:Never=0,Always=1,Unhandled=2;DebuggerEndReason:ClientRequest=0,Timeout=1,InvalidHost=2,Disconnected=3,ServerShutdown=4,ServerProtocolMismatch=5,ConfigurationFailed=6,RpcError=7;DebuggerExceptionBreakMode:Never=0,Always=1,Unhandled=2;DebuggerFrameType:C=0,Lua=1;DebuggerPauseReason:Unknown=0,Requested=1,Breakpoint=2,Exception=3,SingleStep=4,Entrypoint=5;DebuggerResumeType:StepInto=0,StepOut=1,StepOver=2,Resume=3;DebuggerStatus:Success=0,Timeout=1,ConnectionLost=2,InvalidResponse=3,InternalError=4,InvalidState=5,RpcError=6,InvalidArgument=7,ConnectionClosed=8;DefaultScriptSyncFileType:Lua=0,Luau=1;DevCameraOcclusionMode:Zoom=0,Invisicam=1;DevComputerCameraMovementMode:UserChoice=0,Classic=1,Follow=2,Orbital=3,CameraToggle=4;DevComputerMovementMode:UserChoice=0,KeyboardMouse=1,ClickToMove=2,Scriptable=3;DevTouchCameraMovementMode:UserChoice=0,Classic=1,Follow=2,Orbital=3;DevTouchMovementMode:UserChoice=0,Thumbstick=1,DPad=2,Thumbpad=3,ClickToMove=4,Scriptable=5,DynamicThumbstick=6;DeveloperMemoryTag:Internal=0,HttpCache=1,Instances=2,Signals=3,LuaHeap=4,Script=5,PhysicsCollision=6,BaseParts=7,GraphicsSolidModels=8,GraphicsMeshParts=10,GraphicsParticles=11,GraphicsParts=12,GraphicsSpatialHash=13,GraphicsTerrain=14,GraphicsTexture=15,GraphicsTextureCharacter=16,Sounds=17,StreamingSounds=18,TerrainVoxels=19,Gui=21,Animation=22,Navigation=23,GeometryCSG=24,GraphicsSlimModels=25;DeviceFeatureType:DeviceCapture=0,InExperienceFAE=1;DeviceForm:Console=0,Phone=1,Tablet=2,Desktop=3,VR=4;DeviceLevel:Low=0,Medium=1,High=2;DeviceSimulatorScalingMode:ScaleToPhysicalSize=0,ActualResolution=1,FitToWindow=2;DeviceType:Unknown=0,Desktop=1,Tablet=2,Phone=3,TV=4;DialogBehaviorType:SinglePlayer=0,MultiplePlayers=1;DialogPurpose:Quest=0,Help=1,Shop=2;DialogTone:Neutral=0,Friendly=1,Enemy=2;DigitsRigDescriptionSide:None=0,Left=1,Right=2;DiscountType:Uncategorized=0;DisplayScalingMode:Default=0,Legacy=1,Responsive=2;DisplaySize:Small=0,Medium=1,Large=2;DistanceAttenuationMode:Custom=0,InverseTapered=1,Linear=2,LinearSquared=3,Inverse=4;DomainType:EXPERIENCE=1,OAUTH=3;DominantAxis:Width=0,Height=1;DraftStatusCode:OK=0,DraftOutdated=1,ScriptRemoved=2,DraftCommitted=3;DragDetectorDragStyle:TranslateLine=0,TranslatePlane=1,TranslatePlaneOrLine=2,TranslateLineOrPlane=3,TranslateViewPlane=4,RotateAxis=5,RotateTrackball=6,Scriptable=7,BestForDevice=8;DragDetectorPermissionPolicy:Nobody=0,Everybody=1,Scriptable=2;DragDetectorResponseStyle:Geometric=0,Physical=1,Custom=2;DraggerCoordinateSpace:Object=0,World=1;DraggerMovementMode:Geometric=0,Physical=1;DraggingScrollBar:None=0,Horizontal=1,Vertical=2;EasingDirection:In=0,Out=1,InOut=2;EasingStyle:Linear=0,Sine=1,Back=2,Quad=3,Quart=4,Quint=5,Bounce=6,Elastic=7,Exponential=8,Circular=9,Cubic=10;EditableStatus:Unknown=0,Allowed=1,Disallowed=2;ElasticBehavior:WhenScrollable=0,Always=1,Never=2;EmitterPositionType:Parent=0,Instance=1;EngagementLevel:Unknown=0,Inactive=1,Low=2,Medium=3,High=4;EngineFolder:Screenshots=0,Videos=1,Logs=2;EnviromentalPhysicsThrottle:DefaultAuto=0,Disabled=1,Always=2,Skip2=3,Skip4=4,Skip8=5,Skip16=6;ExperienceActivationStatus:Unknown=0,New=1,Active=2,Lapsed=3,Reactivated=4;ExperienceAuthScope:DefaultScope=0,CreatorAssetsCreate=1;ExperienceEventStatus:Active=0,Cancelled=1,Moderated=2,Unpublished=3,Unknown=4;ExperienceStateCaptureSelectionMode:Default=0,SafetyHighlightMode=1;ExperienceStateRecordingLoadMode:NewReplay=0,ContiguousSlice=1,NoncontiguousSlice=2;ExperienceStateRecordingLoadSourceType:S3Url=0,File=1;ExperienceStateRecordingPlaybackMode:Undefined=0,Stopped=1,Playing=2,Rewinding=3;ExplosionType:NoCraters=0,Craters=1;ExternalEditorMode:SystemDefault=0,UserSelectedEditor=1;FACSDataLod:LOD0=0,LOD1=1,LODCount=2;FacialAgeEstimationResultType:Complete=0,Cancel=1,Error=2;FacialAnimationStreamingState:None=0,Audio=1,Video=2,Place=4,Server=8;FacsActionUnit:ChinRaiserUpperLip=0,ChinRaiser=1,FlatPucker=2,Funneler=3,LowerLipSuck=4,LipPresser=5,LipsTogether=6,MouthLeft=7,MouthRight=8,Pucker=9,UpperLipSuck=10,LeftCheekPuff=11,LeftDimpler=12,LeftLipCornerDown=13,LeftLowerLipDepressor=14,LeftLipCornerPuller=15,LeftLipStretcher=16,LeftUpperLipRaiser=17,RightCheekPuff=18,RightDimpler=19,RightLipCornerDown=20,RightLowerLipDepressor=21,RightLipCornerPuller=22,RightLipStretcher=23,RightUpperLipRaiser=24,JawDrop=25,JawLeft=26,JawRight=27,Corrugator=28,LeftBrowLowerer=29,LeftOuterBrowRaiser=30,LeftNoseWrinkler=31,LeftInnerBrowRaiser=32,RightBrowLowerer=33,RightOuterBrowRaiser=34,RightInnerBrowRaiser=35,RightNoseWrinkler=36,EyesLookDown=37,EyesLookLeft=38,EyesLookUp=39,EyesLookRight=40,LeftCheekRaiser=41,LeftEyeUpperLidRaiser=42,LeftEyeClosed=43,RightCheekRaiser=44,RightEyeUpperLidRaiser=45,RightEyeClosed=46,TongueDown=47,TongueOut=48,TongueUp=49;FeatureRestrictionAbuseVector:ExperienceChat=0,Communication=1;FeedbackType:Feedback=0,PlayerSupport=1;FieldOfViewMode:Vertical=0,Diagonal=1,MaxAxis=2;FillDirection:Horizontal=0,Vertical=1;FilterErrorType:BackslashNotEscapingAnything=0,BadBespokeFilter=1,BadName=2,IncompleteOr=3,IncompleteParenthesis=4,InvalidDoubleStar=5,InvalidTilde=6,PropertyBadOperator=7,PropertyDoesNotExist=8,PropertyInvalidField=9,PropertyInvalidValue=10,PropertyUnsupportedFields=11,PropertyUnsupportedProperty=12,UnexpectedNameIndex=13,UnexpectedToken=14,UnfinishedBinaryOperator=15,UnfinishedQuote=16,UnknownBespokeFilter=17,WildcardInProperty=18;FilterResult:Accepted=0,Rejected=1;FilterType:Exclude=0,Include=1;FinishRecordingOperation:Cancel=0,Commit=1,Append=2;FluidFidelity:Automatic=0,UseCollisionGeometry=1,UsePreciseGeometry=2;FluidForces:Default=0,Experimental=1;Font:Legacy=0,Arial=1,ArialBold=2,SourceSans=3,SourceSansBold=4,SourceSansLight=5,SourceSansItalic=6,Bodoni=7,Garamond=8,Cartoon=9,Code=10,Highway=11,SciFi=12,Arcade=13,Fantasy=14,Antique=15,SourceSansSemibold=16,Gotham=17,GothamMedium=18,GothamBold=19,GothamBlack=20,AmaticSC=21,Bangers=22,Creepster=23,DenkOne=24,Fondamento=25,FredokaOne=26,GrenzeGotisch=27,IndieFlower=28,JosefinSans=29,Jura=30,Kalam=31,LuckiestGuy=32,Merriweather=33,Michroma=34,Nunito=35,Oswald=36,PatrickHand=37,PermanentMarker=38,Roboto=39,RobotoCondensed=40,RobotoMono=41,Sarpanch=42,SpecialElite=43,TitilliumWeb=44,Ubuntu=45,BuilderSans=46,BuilderSansMedium=47,BuilderSansBold=48,BuilderSansExtraBold=49,Arimo=50,ArimoBold=51,Unknown=100;FontSize:Size8=0,Size9=1,Size10=2,Size11=3,Size12=4,Size14=5,Size18=6,Size24=7,Size36=8,Size48=9,Size28=10,Size32=11,Size42=12,Size60=13,Size96=14;FontStyle:Normal=0,Italic=1;FontWeight:Thin=100,ExtraLight=200,Light=300,Regular=400,Medium=500,SemiBold=600,Bold=700,ExtraBold=800,Heavy=900;ForceLimitMode:Magnitude=0,PerAxis=1;FormFactor:Symmetric=0,Brick=1,Plate=2,Custom=3;FrameStyle:Custom=0,ChatBlue=1,RobloxSquare=2,RobloxRound=3,ChatGreen=4,ChatRed=5,DropShadow=6;FramerateManagerMode:Automatic=0,On=1,Off=2;FriendRequestEvent:Issue=0,Revoke=1,Accept=2,Deny=3;FriendStatus:Unknown=0,NotFriend=1,Friend=2,FriendRequestSent=3,FriendRequestReceived=4;FrustumStreamingMode:Default=0,Enabled=1,Disabled=2,Automatic=3;FunctionalTestResult:Passed=0,Warning=1,Error=2;GameAvatarType:R6=0,R15=1,PlayerChoice=2;GamepadType:Unknown=0,PS4=1,PS5=2,XboxOne=3;GearGenreSetting:AllGenres=0,MatchingGenreOnly=1;GearType:MeleeWeapons=0,RangedWeapons=1,Explosives=2,PowerUps=3,NavigationEnhancers=4,MusicalInstruments=5,SocialItems=6,BuildingTools=7,Transport=8;GenerateMomentTextResult:Success=0,Pending=1,Failed=2,Filtered=3;Genre:All=0,TownAndCity=1,Fantasy=2,SciFi=3,Ninja=4,Scary=5,Pirate=6,Adventure=7,Sports=8,Funny=9,WildWest=10,War=11,SkatePark=12,Tutorial=13;GradientTileMode:Clamp=0,Repeat=1,Mirror=2;GradientType:Linear=0,Radial=1,Conical=2;GraphicsMode:Automatic=1,Direct3D11=2,OpenGL=4,Metal=5,Vulkan=6,NoGraphics=9;GraphicsOptimizationMode:Performance=0,Balanced=1,Quality=2;GroupMembershipStatus:None=0,Joined=1,JoinRequestPending=2,AlreadyMember=3;GuiState:Idle=0,Hover=1,Press=2,NonInteractable=3;GuiType:Core=0,Custom=1,PlayerNameplates=2,CustomBillboards=3,CoreBillboards=4;HandlesStyle:Resize=0,Movement=1;HapticEffectType:Custom=0,UIHover=1,UIClick=2,UINotification=3,GameplayExplosion=4,GameplayCollision=5;HashAlgorithm:Blake2b=0,Blake3=1,Md5=2,Sha1=3,Sha256=4;HighlightDepthMode:AlwaysOnTop=0,Occluded=1;HorizontalAlignment:Center=0,Left=1,Right=2;HoverAnimateSpeed:VerySlow=0,Slow=1,Medium=2,Fast=3,VeryFast=4;HttpCachePolicy:None=0,Full=1,DataOnly=2,Default=3,InternalRedirectRefresh=4;HttpCompression:None=0,Gzip=1;HttpContentType:ApplicationJson=0,ApplicationXml=1,ApplicationUrlEncoded=2,TextPlain=3,TextXml=4;HttpError:OK=0,InvalidUrl=1,DnsResolve=2,ConnectFail=3,OutOfMemory=4,TimedOut=5,TooManyRedirects=6,InvalidRedirect=7,NetFail=8,Aborted=9,SslConnectFail=10,SslVerificationFail=11,Unknown=12,ConnectionClosed=13,ServerProtocolError=14,CreatorEnvironmentsNotSupportedByService=15,InactivityTimeout=16,TooManyOutstandingRequests=17,InvalidRangeResponse=18;HttpRequestType:Default=0,MarketplaceService=2,Players=7,Chat=15,Avatar=16,Analytics=23,Localization=25;HumanoidCollisionType:OuterBox=0,InnerBox=1;HumanoidDisplayDistanceType:Viewer=0,Subject=1,None=2;HumanoidHealthDisplayType:DisplayWhenDamaged=0,AlwaysOn=1,AlwaysOff=2;HumanoidRigType:R6=0,R15=1;HumanoidStateType:FallingDown=0,Ragdoll=1,GettingUp=2,Jumping=3,Swimming=4,Freefall=5,Flying=6,Landed=7,Running=8,RunningNoPhysics=10,StrafingNoPhysics=11,Climbing=12,Seated=13,PlatformStanding=14,Dead=15,Physics=16,None=18;IKCollisionsMode:NoCollisions=0,OtherMechanismsAnchored=1,IncludeContactedMechanisms=2;IKControlConstraintSupport:Default=0,Disabled=1,Enabled=2;IKControlType:Transform=0,Position=1,Rotation=2,LookAt=3;IXPLoadingStatus:None=0,Pending=1,Initialized=2,ErrorInvalidUser=3,ErrorConnection=4,ErrorJsonParse=5,ErrorTimedOut=6;ImageAlphaType:Default=1,LockCanvasAlpha=2,LockCanvasColor=3;ImageCombineType:BlendSourceOver=1,Overwrite=2,Add=3,Multiply=4,AlphaBlend=5,NormalMapBlend=6,Subtract=7;InOut:Edge=0,Inset=1,Center=2;InfoType:Asset=0,Product=1,GamePass=2,Subscription=3,Bundle=4;InitialDockState:Top=0,Bottom=1,Left=2,Right=3,Float=4;InputActionType:Bool=0,Direction1D=1,Direction2D=2,Direction3D=3,ViewportPosition=4;InputBindingType:Automatic=0,Scriptable=1;InputSink:None=0,Activate=1,All=100;InputType:NoInput=0,Constant=12,Sin=13;InstanceFileSyncStatus:NotSynced=0,Errored=1,SyncedAsRoot=2,SyncedAsDescendant=3,AncestorErrored=4;IntentReplicability:;IntermediateMeshGenerationResult:HighQualityMesh=0;InternalVideoUsage:Default=0,WatchPage=1,HomeCarousel=2,FeatureTileAd=3;InterpolationThrottlingMode:Default=0,Disabled=1,Enabled=2;InviteState:Placed=0,Accepted=1,Declined=2,Missed=3;ItemLineAlignment:Automatic=0,Start=1,Center=2,End=3,Stretch=4;JoinSource:CreatedItemAttribution=1;JointCreationMode:All=0,Surface=1,None=2;KeyCode:None=0,Backspace=8,Tab=9,Clear=12,Return=13,Pause=19,Escape=27,Space=32,QuotedDouble=34,Hash=35,Dollar=36,Percent=37,Ampersand=38,Quote=39,LeftParenthesis=40,RightParenthesis=41,Asterisk=42,Plus=43,Comma=44,Minus=45,Period=46,Slash=47,Zero=48,One=49,Two=50,Three=51,Four=52,Five=53,Six=54,Seven=55,Eight=56,Nine=57,Colon=58,Semicolon=59,LessThan=60,Equals=61,GreaterThan=62,Question=63,At=64,LeftBracket=91,BackSlash=92,RightBracket=93,Caret=94,Underscore=95,Backquote=96,A=97,B=98,C=99,D=100,E=101,F=102,G=103,H=104,I=105,J=106,K=107,L=108,M=109,N=110,O=111,P=112,Q=113,R=114,S=115,T=116,U=117,V=118,W=119,X=120,Y=121,Z=122,LeftCurly=123,Pipe=124,RightCurly=125,Tilde=126,Delete=127,World0=160,World1=161,World2=162,World3=163,World4=164,World5=165,World6=166,World7=167,World8=168,World9=169,World10=170,World11=171,World12=172,World13=173,World14=174,World15=175,World16=176,World17=177,World18=178,World19=179,World20=180,World21=181,World22=182,World23=183,World24=184,World25=185,World26=186,World27=187,World28=188,World29=189,World30=190,World31=191,World32=192,World33=193,World34=194,World35=195,World36=196,World37=197,World38=198,World39=199,World40=200,World41=201,World42=202,World43=203,World44=204,World45=205,World46=206,World47=207,World48=208,World49=209,World50=210,World51=211,World52=212,World53=213,World54=214,World55=215,World56=216,World57=217,World58=218,World59=219,World60=220,World61=221,World62=222,World63=223,World64=224,World65=225,World66=226,World67=227,World68=228,World69=229,World70=230,World71=231,World72=232,World73=233,World74=234,World75=235,World76=236,World77=237,World78=238,World79=239,World80=240,World81=241,World82=242,World83=243,World84=244,World85=245,World86=246,World87=247,World88=248,World89=249,World90=250,World91=251,World92=252,World93=253,World94=254,World95=255,KeypadZero=256,KeypadOne=257,KeypadTwo=258,KeypadThree=259,KeypadFour=260,KeypadFive=261,KeypadSix=262,KeypadSeven=263,KeypadEight=264,KeypadNine=265,KeypadPeriod=266,KeypadDivide=267,KeypadMultiply=268,KeypadMinus=269,KeypadPlus=270,KeypadEnter=271,KeypadEquals=272,Up=273,Down=274,Right=275,Left=276,Insert=277,Home=278,End=279,PageUp=280,PageDown=281,F1=282,F2=283,F3=284,F4=285,F5=286,F6=287,F7=288,F8=289,F9=290,F10=291,F11=292,F12=293,F13=294,F14=295,F15=296,NumLock=300,CapsLock=301,ScrollLock=302,RightShift=303,LeftShift=304,RightControl=305,LeftControl=306,RightAlt=307,LeftAlt=308,RightMeta=309,LeftMeta=310,LeftSuper=311,RightSuper=312,Mode=313,Compose=314,Help=315,Print=316,SysReq=317,Break=318,Menu=319,Power=320,Euro=321,Undo=322,ButtonX=1000,ButtonY=1001,ButtonA=1002,ButtonB=1003,ButtonR1=1004,ButtonL1=1005,ButtonR2=1006,ButtonL2=1007,ButtonR3=1008,ButtonL3=1009,ButtonStart=1010,ButtonSelect=1011,DPadLeft=1012,DPadRight=1013,DPadUp=1014,DPadDown=1015,Thumbstick1=1016,Thumbstick2=1017,Thumbstick1Up=1018,Thumbstick1Down=1019,Thumbstick1Left=1020,Thumbstick1Right=1021,Thumbstick2Up=1022,Thumbstick2Down=1023,Thumbstick2Left=1024,Thumbstick2Right=1025,MouseLeftButton=1026,MouseRightButton=1027,MouseMiddleButton=1028,MouseBackButton=1029,MouseNoButton=1030,MouseX=1031,MouseY=1032,MousePosition=1033,TouchPosition=1034,MouseWheel=1035,TrackpadPan=1040,TrackpadPinch=1045,MouseDelta=1048,TouchDelta=1049,TouchPinch=1050,ButtonCenter=1051,ButtonBack=1052,ButtonUp=1053,ButtonDown=1054,ButtonLeft=1055,ButtonRight=1056;KeyCodeStringFormat:Default=0,Abbreviated=1;KeyInterpolationMode:Constant=0,Linear=1,Cubic=2;KeywordFilterType:Include=0,Exclude=1;KnownWindow:Main=0;Language:Default=0;LeftRight:Left=0,Center=1,Right=2;LexemeType:Eof=0,Name=1,QuotedString=2,Number=3,And=4,Or=5,Equal=6,TildeEqual=7,GreaterThan=8,GreaterThanEqual=9,LessThan=10,LessThanEqual=11,Colon=12,Dot=13,LeftParenthesis=14,RightParenthesis=15,Star=16,DoubleStar=17,ReservedSpecial=18;LightingStyle:Realistic=0,Soft=1;Limb:Head=0,Torso=1,LeftArm=2,RightArm=3,LeftLeg=4,RightLeg=5,Unknown=6;LineJoinMode:Round=0,Bevel=1,Miter=2;ListDisplayMode:Horizontal=0,Vertical=1;ListenerLocation:Default=0,None=1,Character=2,Camera=3;ListenerPositionType:Parent=0,Instance=1;ListenerType:Camera=0,CFrame=1,ObjectPosition=2,ObjectCFrame=3;LiveEditingAtomicUpdateResponse:Success=0,FailureGuidNotFound=1,FailureHashMismatch=2,FailureOperationIllegal=3;LiveEditingBroadcastMessageType:Normal=0,Warning=1,Error=2;LoadCharacterLayeredClothing:Default=0,Disabled=1,Enabled=2;LoadDynamicHeads:Default=0,Disabled=1,Enabled=2;LocationType:Character=0,Camera=1,ObjectPosition=2;LuauTypeCheckMode:Default=0,NoCheck=1,Nonstrict=2,Strict=3;MakeupType:Face=0,Lip=1,Eye=2;MarketplaceBulkPurchasePromptStatus:Completed=1,Aborted=2,Error=3;MarketplaceItemPurchaseStatus:Success=1,SystemError=2,AlreadyOwned=3,InsufficientRobux=4,QuantityLimitExceeded=5,QuotaExceeded=6,NotForSale=7,NotAvailableForPurchaser=8,PriceMismatch=9,SoldOut=10,PurchaserIsSeller=11,InsufficientMembership=12,PlaceInvalid=13;MarketplaceProductType:AvatarAsset=1,AvatarBundle=2;MarkupKind:PlainText=0,Markdown=1;MatchmakingType:Default=1,XboxOnly=2,PlayStationOnly=3;Material:Plastic=256,SmoothPlastic=272,Neon=288,Wood=512,WoodPlanks=528,Marble=784,Basalt=788,Slate=800,CrackedLava=804,Concrete=816,Limestone=820,Granite=832,Pavement=836,Brick=848,Pebble=864,Cobblestone=880,Rock=896,Sandstone=912,CorrodedMetal=1040,DiamondPlate=1056,Foil=1072,Metal=1088,Grass=1280,LeafyGrass=1284,Sand=1296,Fabric=1312,Snow=1328,Mud=1344,Ground=1360,Asphalt=1376,Salt=1392,Ice=1536,Glacier=1552,Glass=1568,ForceField=1584,Air=1792,Water=2048,Cardboard=2304,Carpet=2305,CeramicTiles=2306,ClayRoofTiles=2307,RoofShingles=2308,Leather=2309,Plaster=2310,Rubber=2311;MaterialPattern:Regular=0,Organic=1;MembershipType:None=0,BuildersClub=1,TurboBuildersClub=2,OutrageousBuildersClub=3,Premium=4;MergeResolution:None=0,UseSource=1,UseTarget=2,Manual=3;MergeStatus:None=0,Loading=1,Merging=2;MeshAttribute:Vertex=0,Normal=1,Color=2,UV=3,Face=4;MeshPartDetailLevel:DistanceBased=0,Level00=1,Level01=2,Level02=3,Level03=4,Level04=5,Level05=6,Level06=7,Level07=8,Level08=9,Level09=10;MeshPartHeadsAndAccessories:Default=0,Disabled=1,Enabled=2;MeshScaleUnit:Stud=0,Meter=1,CM=2,MM=3,Foot=4,Inch=5;MeshType:Head=0,Torso=1,Wedge=2,Sphere=3,Cylinder=4,FileMesh=5,Brick=6,Prism=7,Pyramid=8,ParallelRamp=9,RightAngleRamp=10,CornerWedge=11;MessageType:MessageOutput=0,MessageInfo=1,MessageWarning=2,MessageError=3;ModelLevelOfDetail:Automatic=0,StreamingMesh=1,Disabled=2,SLIM=4;ModelStreamingBehavior:Default=0,Legacy=1,Improved=2;ModelStreamingMode:Default=0,Atomic=1,Persistent=2,PersistentPerPlayer=3,Nonatomic=4;ModerationResultCategory:ViolationDetected=0,Borderline=1,NoViolationDetected=2;ModerationResultLabel:ChildExploitation=0,SuicideSelfInjuryAndHarmfulBehavior=1,ThreatsBullyingAndHarassment=2,TerrorismAndViolentExtremism=3,DiscriminationSlursAndHateSpeech=4,RealWorldSensitiveEvents=5,ViolentContentAndGore=6,RomanticAndSexualContent=7,IllegalAndRegulatedGoodsAndActivities=8,Profanity=9,Other=100;ModerationStatus:ReviewedApproved=1,ReviewedRejected=2,NotReviewed=3,NotApplicable=4,Invalid=5;ModifierKey:Shift=0,Ctrl=1,Alt=2,Meta=3;MouseBehavior:Default=0,LockCenter=1,LockCurrentPosition=2;MoveState:Stopped=0,Coasting=1,Pushing=2,Stopping=3,AirFree=4;MuteState:Unmuted=0,Muted=1;NameOcclusion:NoOcclusion=0,EnemyOcclusion=1,OccludeAll=2;NegateOperationHiddenHistory:None=0,NegatedUnion=1,NegatedIntersection=2;NetworkOwnership:Automatic=0,Manual=1,OnContact=2;NetworkStatus:Unknown=0,Connected=1,Disconnected=2;NoiseType:SimplexGabor=0;NormalId:Right=0,Top=1,Back=2,Left=3,Bottom=4,Front=5;NotificationButtonType:Primary=0,Secondary=1;OperationType:Null=0,Union=1,Subtraction=2,Intersection=3,Primitive=4;OrientationAlignmentMode:OneAttachment=0,TwoAttachment=1;OutfitSource:All=1,Created=2,Purchased=3;OutfitType:All=1,Avatar=2,DynamicHead=3,Shoes=4,Makeup=5;OutputLayoutMode:Horizontal=0,Vertical=1;OverrideMouseIconBehavior:None=0,ForceShow=1,ForceHide=2;PackagePermission:None=0,NoAccess=1,Revoked=2,UseView=3,Edit=4,Own=5;PageMilestoneType:Interactive=0,SurfaceMounted=1,FunctionallyReady=2,SurfaceReady=3;PageType:AvatarEditor=0,Party=1,ExperienceDetail=2,AvatarMarketplace=3;PartType:Ball=0,Block=1,Cylinder=2,Wedge=3,CornerWedge=4;ParticleEmitterShape:Box=0,Sphere=1,Cylinder=2,Disc=3;ParticleEmitterShapeInOut:Outward=0,Inward=1,InAndOut=2;ParticleEmitterShapeStyle:Volume=0,Surface=1;ParticleFlipbookLayout:None=0,Grid2x2=1,Grid4x4=2,Grid8x8=3,Custom=4;ParticleFlipbookMode:Loop=0,OneShot=1,PingPong=2,Random=3;ParticleFlipbookTextureCompatible:NotCompatible=0,Compatible=1,Unknown=2;ParticleOrientation:FacingCamera=0,FacingCameraWorldUp=1,VelocityParallel=2,VelocityPerpendicular=3;PathStatus:Success=0,ClosestNoPath=1,ClosestOutOfRange=2,FailStartNotEmpty=3,FailFinishNotEmpty=4,NoPath=5;PathWaypointAction:Walk=0,Jump=1,Custom=2;PathfindingUseImprovedSearch:Default=0,Disabled=1,Enabled=2;PeoplePageLayout:Card=0,List=1;PerformanceOverlayMode:Overdraw=0,Transparent=1,Decals=2,Lights=3;PermissionLevelShown:Game=0,RobloxGame=1,RobloxScript=2,Studio=3,Roblox=4;PhysicalConstraintType:AnimationConstraint=0,Motor6D=1;PhysicsSimulationRate:Fixed240Hz=0,Fixed120Hz=1,Fixed60Hz=2;PhysicsSteppingMethod:Default=0,Fixed=1,Adaptive=2;PinExperienceStatus:Success=0,Failure=1,AlreadyExists=2;PioneerSource:Roblox=0,DaveyBazooka=1,Oof=2;PlaceContentPreference:None=0,All=1,MentionsAndReplies=2,Unknown=3;PlacePublishType:None=0,Publish=1,Save=2;Platform:Windows=0,OSX=1,IOS=2,Android=3,XBoxOne=4,PS4=5,PS3=6,XBox360=7,WiiU=8,NX=9,Ouya=10,AndroidTV=11,Chromecast=12,Linux=13,SteamOS=14,WebOS=15,DOS=16,BeOS=17,UWP=18,PS5=19,MetaOS=20,Web=21,None=22;PlaybackState:Begin=0,Delayed=1,Playing=2,Paused=3,Completed=4,Cancelled=5;PlayerActions:CharacterForward=0,CharacterBackward=1,CharacterLeft=2,CharacterRight=3,CharacterJump=4;PlayerCharacterDestroyBehavior:Default=0,Disabled=1,Enabled=2;PlayerChatType:All=0,Team=1,Whisper=2;PlayerDataErrorState:LoadFailed=0,FlushFailed=1,ReleaseFailed=2,None=3;PlayerDataLoadFailureBehavior:Failure=0,FallbackToDefault=1,Kick=2;PlayerExitReason:Unknown=0,PlatformKick=1,CreatorKick=2;PlayerPlatformActivationStatus:Unknown=0,New=1,Active=2,Lapsed=3,Reactivated=4;PlayerPlatformSpenderStatus:Unknown=0,Active=1,OtherPayer=2;PluginConnectionTargetType:Edit=0,Test=1;PoseEasingDirection:In=0,Out=1,InOut=2;PoseEasingStyle:Linear=0,Constant=1,Elastic=2,Cubic=3,Bounce=4,CubicV2=5;PositionAlignmentMode:OneAttachment=0,TwoAttachment=1;PredictionMode:Automatic=0,On=1,Off=2;PredictionStatus:Authoritative=0,Predicted=1,None=2;PredictiveStreamingMode:Default=0,Enabled=1,Disabled=2;PreferredInput:KeyboardAndMouse=0,Gamepad=1,Touch=2,MicroGamepad=3;PreferredTextSize:Medium=1,Large=2,Larger=3,Largest=4;PrefetchDownloadStatus:NotStarted=0,InProgress=1,Completed=2,Failed=3;PrimalPhysicsSolver:Default=0,Experimental=1,Disabled=2;PrimitiveType:Null=0,Ball=1,Cylinder=2,Block=3,Wedge=4,CornerWedge=5;PrivilegeType:Banned=0,Visitor=10,Member=128,Admin=240,Owner=255;ProductLocationRestriction:AvatarShop=0,AllowedGames=1,AllGames=2;ProductPurchaseChannel:InExperience=1,ExperienceDetailsPage=2,AdReward=3,CommerceProduct=4;ProductPurchaseDecision:NotProcessedYet=0,PurchaseGranted=1;PromptCreateAssetResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,UnknownFailure=6,UGCValidationFailed=7,ModeratedName=8,PurchaseFailure=9,TokenInvalid=10;PromptCreateAvatarResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,InvalidHumanoidDescription=6,UGCValidationFailed=7,ModeratedName=8,MaxOutfits=9,PurchaseFailure=10,UnknownFailure=11,TokenInvalid=12;PromptCreateOutfitResult:Success=1,PartialSuccess=2,CreationFailure=3,PermissionDenied=4,Timeout=5,NoUserInput=6,UnknownFailure=7,UGCValidationFailed=8;PromptCreatePlatformContentResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,UnknownFailure=6,UGCValidationFailed=7,ModeratedName=8,PurchaseFailure=9,TokenInvalid=10;PromptExperienceDetailsResult:PromptClosed=0,TeleportAttempted=1;PromptLinkSharingResult:Success=1,PlayerLeft=2,InvalidLaunchData=3;PromptPublishAssetResult:Success=1,PermissionDenied=2,Timeout=3,UploadFailed=4,NoUserInput=5,UnknownFailure=6;PropertyStatus:Ok=0,Warning=1,Error=2;ProximityPromptExclusivity:OnePerButton=0,OneGlobally=1,AlwaysShow=2;ProximityPromptInputType:Keyboard=0,Gamepad=1,Touch=2;ProximityPromptStyle:Default=0,Custom=1;PurchaseOption:TimedOption=1,Permanent=2;QualityLevel:Automatic=0,Level01=1,Level02=2,Level03=3,Level04=4,Level05=5,Level06=6,Level07=7,Level08=8,Level09=9,Level10=10,Level11=11,Level12=12,Level13=13,Level14=14,Level15=15,Level16=16,Level17=17,Level18=18,Level19=19,Level20=20,Level21=21;QueueDecision:Commit=0,Defer=1;R15CollisionType:OuterBox=0,InnerBox=1;RaycastFilterType:Exclude=0,Include=1;ReadCapturesFromGalleryResult:Success=0,NeedPermission=1;ReceiptDecision:NotProcessedYet=0,Processed=1;ReceiptType:DeveloperProduct=0,RobuxTransferSender=1,RobuxTransferReceiver=2;RecommendationActionType:AddReaction=0,RemoveReaction=1,Share=2,Report=3,Comment=4,Play=5,Purchase=6;RecommendationDepartureIntent:Neutral=0,Positive=1,Negative=2;RecommendationImpressionType:View=0,NotViewable=1;RecommendationItemContentType:Static=0,Dynamic=1,Interactive=2;RecommendationItemVisibility:Private=0,Public=1;RecommendationPreferenceTargetType:User=0,Universe=1,CustomTag=2;RecommendationPreferenceType:AddFollow=0,RemoveFollow=1,AddMute=2,RemoveMute=3;RejectCharacterDeletions:Default=0,Disabled=1,Enabled=2;RenderFidelity:Automatic=0,Precise=1,Performance=2;RenderPriority:First=0,Input=100,Camera=200,Character=300,Last=2000;RenderingCacheOptimizationMode:Default=0,Disabled=1,Enabled=2;RenderingTestComparisonMethod:psnr=0,diff=1;ReplicateInstanceDestroySetting:Default=0,Disabled=1,Enabled=2;ResamplerMode:Default=0,Pixelated=1;ReservedHighlightId:Standard=0,Active=131072,Hover=262144,Selection=524288,NegatedPart=1048576;RestPose:Default=0,RotationsReset=1,Custom=2;RestPoseModel:FromRigInACE=0,FromRigInFile=1,FromRigInFileZeroedRotations=2,FromCustomClip=3;ReturnKeyType:Default=0,Done=1,Go=2,Next=3,Search=4,Send=5;ReverbType:NoReverb=0,GenericReverb=1,PaddedCell=2,Room=3,Bathroom=4,LivingRoom=5,StoneRoom=6,Auditorium=7,ConcertHall=8,Cave=9,Arena=10,Hangar=11,CarpettedHallway=12,Hallway=13,StoneCorridor=14,Alley=15,Forest=16,City=17,Mountains=18,Quarry=19,Plain=20,ParkingLot=21,SewerPipe=22,UnderWater=23;ReviewableContentState:Pending=0,Completed=1,Failed=2;RibbonTool:Select=0,Scale=1,Rotate=2,Move=3,Transform=4,ColorPicker=5,MaterialPicker=6,Group=7,Ungroup=8,None=9,PivotEditor=10;RigLabel:Invalid=0,Root=2,LeftHip=3,LeftKnee=4,LeftAnkle=5,RightHip=7,RightKnee=8,RightAnkle=9,Waist=11,LeftShoulder=12,LeftElbow=13,LeftWrist=14,RightShoulder=16,RightElbow=17,RightWrist=18,Neck=20,Spine=23,Chest=24,HeadBase=25,LeftClavicle=26,RightClavicle=27,LeftToeBase=28,RightToeBase=29,Thumb1=30,Thumb2=31,Thumb3=32,Index1=33,Index2=34,Index3=35,Middle1=36,Middle2=37,Middle3=38,Ring1=39,Ring2=40,Ring3=41,Pinky1=42,Pinky2=43,Pinky3=44;RigScale:Default=0,Rthro=1,RthroNarrow=2;RigType:R15=0,CustomHumanoid=1,Custom=2,None=3;RollOffMode:Inverse=0,Linear=1,LinearSquare=2,InverseTapered=3;RolloutState:Default=0,Disabled=1,Enabled=2;RotationOrder:XYZ=0,XZY=1,YZX=2,YXZ=3,ZXY=4,ZYX=5;RotationType:MovementRelative=0,CameraRelative=1;RsvpStatus:None=0,Going=1,NotGoing=2;RtlTextSupport:Default=0,Disabled=1,Enabled=2;RunContext:Legacy=0,Server=1,Client=2,Plugin=3;RunState:Stopped=0,Running=1,Paused=2;RuntimeUndoBehavior:Aggregate=0,Snapshot=1,Hybrid=2;SafeAreaCompatibility:None=0,FullscreenExtension=1;SalesTypeFilter:All=1,Collectibles=2,Premium=3,TimedOptions=4;SandboxedInstanceMode:Default=0,Experimental=1;SaveAvatarThumbnailCustomizationFailure:BadThumbnailType=1,BadYRotDeg=2,BadFieldOfViewDeg=3,BadDistanceScale=4,Other=5,Throttled=6;SaveFilter:SaveWorld=0,SaveGame=1,SaveAll=2;SavedQualitySetting:Automatic=0,QualityLevel1=1,QualityLevel2=2,QualityLevel3=3,QualityLevel4=4,QualityLevel5=5,QualityLevel6=6,QualityLevel7=7,QualityLevel8=8,QualityLevel9=9,QualityLevel10=10;ScaleType:Stretch=0,Slice=1,Tile=2,Fit=3,Crop=4;ScopeCheckResult:ConsentAccepted=0,InvalidScopes=1,Timeout=2,NoUserInput=3,BackendError=4,UnexpectedError=5,InvalidArgument=6,ConsentDenied=7;ScreenInsets:None=0,DeviceSafeInsets=1,CoreUISafeInsets=2,TopbarSafeInsets=3;ScreenOrientation:LandscapeLeft=0,LandscapeRight=1,LandscapeSensor=2,Portrait=3,Sensor=4;ScreenshotCaptureResult:Success=0,OtherError=1,NoDeviceSupport=2,NoSpaceOnDevice=3;ScriptScannerUpdateType:Init=0,Added=1,Removed=2;ScriptStoppedReason:Breakpoint=0,Exception=1,Pause=2,Step=3,Entry=4;ScriptVariableScope:Local=0,Upvalue=1,Global=2;ScrollBarInset:None=0,ScrollBar=1,Always=2;ScrollState:Idle=0,Scrolling=1;ScrollingDirection:X=1,Y=2,XY=4;SecurityCapability:RunClientScript=0,RunServerScript=1,AccessOutsideWrite=2,AssetRequire=3,LoadString=4,ScriptGlobals=5,CreateInstances=6,Basic=7,Audio=8,DataStore=9,Network=10,Physics=11,UI=12,CSG=13,Chat=14,Animation=15,Avatar=16,Input=17,Environment=18,RemoteEvent=19,LegacySound=20,Players=21,CapabilityControl=22,Plugin=23,LocalUser=24,WritePlayer=25,RobloxScript=26,RobloxEngine=27,Unassigned=28,InternalTest=29,PluginOrOpenCloud=30,Assistant=31,RemoteCommand=32,AssetRead=33,AssetManagement=34,DynamicGeneration=35,PlatformAvatarEditing=36,AssetCreateUpdate=37,Capture=38,SensitiveInput=39,Monetization=40,LoadOwnedAsset=41,Social=42,ServerCommunication=43,Logging=44,PromptExternalPurchase=45,Groups=46,Teleport=47,Consequences=48,Material=49,AvatarBehavior=50,AvatarAppearance=51,LoadUnownedAsset=52;SelectionBehavior:Escape=0,Stop=1;SelectionRenderMode:Outlines=0,BoundingBoxes=1,Both=2;SelfViewPosition:LastPosition=0,TopLeft=1,TopRight=2,BottomLeft=3,BottomRight=4;SensorMode:Floor=0,Ladder=1,ClassicFloor=2,ClassicLadder=3;SensorUpdateType:OnRead=0,Manual=1;ServerLiveEditingMode:Uninitialized=0,Enabled=1,Disabled=2;ServiceVisibility:Always=0,Off=1,WithChildren=2;Severity:Error=1,Warning=2,Information=3,Hint=4;ShowAdResult:ShowCompleted=1,AdNotReady=2,AdAlreadyShowing=3,InternalError=4,ShowInterrupted=5,InsufficientMemory=6;SignalBehavior:Default=0,Immediate=1,Deferred=2,AncestryDeferred=3;SimulationMode:Default=0,Enabled=1,Disabled=2;SizeConstraint:RelativeXY=0,RelativeXX=1,RelativeYY=2;SlimTintMode:None=0,LevelOfDetail=1,Meshes=2,MeshResourcePtr=3,ContentId=4,DataModelState=5,TranscoderStatus=6;SlimTranscoderStatus:Unknown=0,Transcoding=1,Succeeded=2,Failed=3;SlimViewContext:Player=0,Editor=1,ImGui=2;SolverConvergenceMetricType:IterationBased=0,AlgorithmAgnostic=1;SolverConvergenceVisualizationMode:Disabled=0,PerIsland=1,PerEdge=2;SortDirection:Ascending=0,Descending=1;SortOrder:Name=0,Custom=1,LayoutOrder=2;SpecialKey:Insert=0,Home=1,End=2,PageUp=3,PageDown=4,ChatHotkey=5;StartCorner:TopLeft=0,TopRight=1,BottomLeft=2,BottomRight=3;StateObjectFieldType:Boolean=0,CFrame=1,Color3=2,Float=3,Instance=4,Random=5,Vector2=6,Vector3=7,INVALID=8;StateReferenceFrame:CurrentState=0,PreviousState=1,LastObservedState=2;Status:Poison=0,Confusion=1;StepFrequency:Hz60=0,Hz30=1,Hz15=2,Hz10=3,Hz5=4,Hz1=5;StreamOutBehavior:Default=0,LowMemory=1,Opportunistic=2;StreamingIntegrityMode:Default=0,Disabled=1,MinimumRadiusPause=2,PauseOutsideLoadedArea=3;StreamingPauseMode:Default=0,Disabled=1,ClientPhysicsPause=2;StrokeSizingMode:FixedSize=0,ScaledSize=1;StudioAction:Undo=0,Redo=1,SelectAll=2,DeleteSelected=3,DuplicateSelection=4,ClearSelection=5,ZoomExtents=6,Copy=61,Cut=62,Paste=63;StudioCaptureBufferStatus:NotStarted=0,Pending=1,Ready=2,Error=3;StudioCaptureScreenshotFormat:RGBA8=0,PNG=1;StudioCloseMode:None=0,CloseStudio=1,CloseDoc=2,LogOut=3;StudioDataModelType:Edit=0,PlayClient=1,PlayServer=2,Standalone=3,None=4;StudioPlaceUpdateFailureReason:Other=0,TeamCreateConflict=1;StudioScriptEditorColorCategories:Default=0,Operator=1,Number=2,String=3,Comment=4,Keyword=5,Builtin=6,Method=7,Property=8,Nil=9,Bool=10,Function=11,Local=12,Self=13,LuauKeyword=14,FunctionName=15,TODO=16,Background=17,SelectionText=18,SelectionBackground=19,FindSelectionBackground=20,MatchingWordBackground=21,Warning=22,Error=23,Info=24,Hint=25,Whitespace=26,ActiveLine=27,DebuggerCurrentLine=28,DebuggerErrorLine=29,Ruler=30,Bracket=31,Type=32,MenuPrimaryText=33,MenuSecondaryText=34,MenuSelectedText=35,MenuBackground=36,MenuSelectedBackground=37,MenuScrollbarBackground=38,MenuScrollbarHandle=39,MenuBorder=40,DocViewCodeBackground=41,AICOOverlayText=42,AICOOverlayButtonBackground=43,AICOOverlayButtonBackgroundHover=44,AICOOverlayButtonBackgroundPressed=45,IndentationRuler=46,ReviewableChangeAddedText=47,ReviewableChangeRemovedText=48;StudioScriptEditorColorPresets:RobloxDefault=0,Extra1=1,Extra2=2,Custom=3;StudioStyleGuideColor:MainBackground=0,Titlebar=1,Dropdown=2,Tooltip=3,Notification=4,ScrollBar=5,ScrollBarBackground=6,TabBar=7,Tab=8,FilterButtonDefault=9,FilterButtonHover=10,FilterButtonChecked=11,FilterButtonAccent=12,FilterButtonBorder=13,FilterButtonBorderAlt=14,RibbonTab=15,RibbonTabTopBar=16,Button=17,MainButton=18,RibbonButton=19,ViewPortBackground=20,InputFieldBackground=21,Item=22,TableItem=23,CategoryItem=24,GameSettingsTableItem=25,GameSettingsTooltip=26,EmulatorBar=27,EmulatorDropDown=28,ColorPickerFrame=29,CurrentMarker=30,Border=31,DropShadow=32,Shadow=33,Light=34,Dark=35,Mid=36,MainText=37,SubText=38,TitlebarText=39,BrightText=40,DimmedText=41,LinkText=42,WarningText=43,ErrorText=44,InfoText=45,SensitiveText=46,ScriptSideWidget=47,ScriptBackground=48,ScriptText=49,ScriptSelectionText=50,ScriptSelectionBackground=51,ScriptFindSelectionBackground=52,ScriptMatchingWordSelectionBackground=53,ScriptOperator=54,ScriptNumber=55,ScriptString=56,ScriptComment=57,ScriptKeyword=58,ScriptBuiltInFunction=59,ScriptWarning=60,ScriptError=61,ScriptInformation=62,ScriptHint=63,ScriptWhitespace=64,ScriptRuler=65,DocViewCodeBackground=66,DebuggerCurrentLine=67,DebuggerErrorLine=68,DiffFilePathText=69,DiffTextHunkInfo=70,DiffTextNoChange=71,DiffTextAddition=72,DiffTextDeletion=73,DiffTextSeparatorBackground=74,DiffTextNoChangeBackground=75,DiffTextAdditionBackground=76,DiffTextDeletionBackground=77,DiffLineNum=78,DiffLineNumSeparatorBackground=79,DiffLineNumNoChangeBackground=80,DiffLineNumAdditionBackground=81,DiffLineNumDeletionBackground=82,DiffFilePathBackground=83,DiffFilePathBorder=84,ChatIncomingBgColor=85,ChatIncomingTextColor=86,ChatOutgoingBgColor=87,ChatOutgoingTextColor=88,ChatModeratedMessageColor=89,Separator=90,ButtonBorder=91,ButtonText=92,InputFieldBorder=93,CheckedFieldBackground=94,CheckedFieldBorder=95,CheckedFieldIndicator=96,HeaderSection=97,Midlight=98,StatusBar=99,DialogButton=100,DialogButtonText=101,DialogButtonBorder=102,DialogMainButton=103,DialogMainButtonText=104,InfoBarWarningBackground=105,InfoBarWarningText=106,ScriptEditorCurrentLine=107,ScriptMethod=108,ScriptProperty=109,ScriptNil=110,ScriptBool=111,ScriptFunction=112,ScriptLocal=113,ScriptSelf=114,ScriptLuauKeyword=115,ScriptFunctionName=116,ScriptTodo=117,ScriptBracket=118,AttributeCog=119,AICOOverlayText=128,AICOOverlayButtonBackground=129,AICOOverlayButtonBackgroundHover=130,AICOOverlayButtonBackgroundPressed=131,OnboardingCover=132,OnboardingHighlight=133,OnboardingShadow=134,BreakpointMarker=136,DiffLineNumHover=137,DiffLineNumSeparatorBackgroundHover=138;StudioStyleGuideModifier:Default=0,Selected=1,Pressed=2,Disabled=3,Hover=4;Style:AlternatingSupports=0,BridgeStyleSupports=1,NoSupports=2;SubscriptionExpirationReason:ProductInactive=0,ProductDeleted=1,SubscriberCancelled=2,SubscriberRefunded=3,Lapsed=4;SubscriptionPaymentStatus:Paid=0,Refunded=1;SubscriptionPeriod:Month=0;SubscriptionState:NeverSubscribed=0,SubscribedWillRenew=1,SubscribedWillNotRenew=2,SubscribedRenewalPaymentPending=3,Expired=4;SurfaceConstraint:None=0,Hinge=1,SteppingMotor=2,Motor=3;SurfaceGuiShape:Flat=0,CurvedHorizontally=1;SurfaceGuiSizingMode:FixedSize=0,PixelsPerStud=1;SurfaceType:Smooth=0,Glue=1,Weld=2,Studs=3,Inlet=4,Universal=5,Hinge=6,Motor=7,SteppingMotor=8,SmoothNoOutlines=10;SwipeDirection:Right=0,Left=1,Up=2,Down=3,None=4;SystemThemeValue:error=0,light=1,dark=2,systemLight=3,systemDark=4;TableMajorAxis:RowMajor=0,ColumnMajor=1;TeamCreateErrorState:PlaceSizeTooLarge=0,PlaceSizeApproachingLimit=1,PlaceUploadFailing=2,NoError=3;Technology:Legacy=0,Voxel=1,Compatibility=2,ShadowMap=3,Future=4,Unified=5;TelemetryBackend:UNSPECIFIED=0,EventIngest=1,Points=2,Teletune=3,EphemeralCounter=4,EphemeralStat=5,Counter=6,Stat=7;TelemetryStandardizedField:AddDatacenterId=0,AddPlaceId=1,AddUniverseId=2,AddPlaceInstanceId=3,AddPlaySessionId=4,AddCurrentContextName=5,AddOsInfo=6,AddArchitectureInfo=7,AddCpuInfo=8,AddMemoryInfo=9,AddSessionInfo=10;TeleportMethod:TeleportToSpawnByName=0,TeleportToPlaceInstance=1,TeleportToPrivateServer=2,TeleportPartyAsync=3,TeleportToVIPServer=4,TeleportToInstanceBack=5,TeleportUnknown=6,Teleport=7;TeleportResult:Success=0,Failure=1,GameNotFound=2,GameEnded=3,GameFull=4,Unauthorized=5,Flooded=6,IsTeleporting=7;TeleportState:RequestedFromServer=0,Started=1,WaitingForServer=2,Failed=3,InProgress=4;TeleportType:ToPlace=0,ToInstance=1,ToReservedServer=2,ToVIPServer=3,ToInstanceBack=4;TerrainAcquisitionMethod:None=0,Legacy=1,Template=2,Generate=3,Import=4,Convert=5,EditAddTool=6,EditSeaLevelTool=7,EditReplaceTool=8,RegionFillTool=9,RegionPasteTool=10,Other=11;TerrainFace:Top=0,Side=1,Bottom=2;TerrainLiquidMergeOperation:None=0,Source=1,Union=2,Difference=3,Intersect=4;TerrainSolidMergeOperation:None=0,Paint=1,Source=2,Union=3,Dig=4,Difference=5,Intersect=6,Cut=7,Place=8;TextChannelDisplayMode:AllTextChannels=0,DefaultTextChannels=1;TextChatMessageStatus:Unknown=1,Success=2,Sending=3,TextFilterFailed=4,Floodchecked=5,InvalidPrivacySettings=6,InvalidTextChannelPermissions=7,MessageTooLong=8,ModerationTimeout=9;TextDirection:Auto=0,LeftToRight=1,RightToLeft=2;TextFilterContext:PublicChat=1,PrivateChat=2;TextInputType:Default=0,NoSuggestions=1,Number=2,Email=3,Phone=4,Password=5,PasswordShown=6,Username=7,OneTimePassword=8,NewPassword=9,NewPasswordShown=10;TextTruncate:None=0,AtEnd=1,SplitWord=2;TextXAlignment:Left=0,Right=1,Center=2;TextYAlignment:Top=0,Center=1,Bottom=2;TextureMode:Stretch=0,Wrap=1,Static=2;TextureQueryType:NonHumanoid=0,NonHumanoidOrphaned=1,Humanoid=2,HumanoidOrphaned=3;ThreadPoolConfig:Auto=0,Threads1=1,Threads2=2,Threads3=3,Threads4=4,Threads8=8,Threads16=16,PerCore1=101,PerCore2=102,PerCore3=103,PerCore4=104;ThrottlingPriority:Default=0,ElevatedOnServer=1,Extreme=2;ThumbnailSize:Size48x48=0,Size180x180=1,Size420x420=2,Size60x60=3,Size100x100=4,Size150x150=5,Size352x352=6;ThumbnailType:HeadShot=0,AvatarBust=1,AvatarThumbnail=2;TickCountSampleMethod:Fast=0,Benchmark=1,Precise=2;TitleBarControlsPosition:Unknown=0,Left=1,Right=2;TitleBarMode:Native=0,Custom=1;TonemapperPreset:Default=0,Retro=1;TopBottom:Top=0,Center=1,Bottom=2;TouchCameraMovementMode:Default=0,Classic=1,Follow=2,Orbital=3;TouchMovementMode:Default=0,Thumbstick=1,DPad=2,Thumbpad=3,ClickToMove=4,DynamicThumbstick=5;TrackerError:Ok=0,NoService=1,InitFailed=2,NoVideo=3,VideoError=4,VideoNoPermission=5,VideoUnsupported=6,NoAudio=7,AudioError=8,AudioNoPermission=9,UnsupportedDevice=10;TrackerExtrapolationFlagMode:ForceDisabled=0,ExtrapolateFacsAndPose=1,ExtrapolateFacsOnly=2,Auto=3;TrackerFaceTrackingStatus:FaceTrackingSuccess=0,FaceTrackingNoFaceFound=1,FaceTrackingUnknown=2,FaceTrackingLost=3,FaceTrackingHasTrackingError=4,FaceTrackingIsOccluded=5,FaceTrackingUninitialized=6;TrackerLodFlagMode:ForceFalse=0,ForceTrue=1,Auto=2;TrackerLodValueMode:Force0=0,Force1=1,Auto=2;TrackerMode:None=0,Audio=1,Video=2,AudioVideo=3;TrackerPromptEvent:LODCameraRecommendDisable=0;TrackerType:None=0,Face=1,UpperBody=2;TriStateBoolean:Unknown=0,True=1,False=2;TweenStatus:Canceled=0,Completed=1;UICaptureMode:All=0,None=1;UIDragDetectorBoundingBehavior:Automatic=0,EntireObject=1,HitPoint=2;UIDragDetectorDragRelativity:Absolute=0,Relative=1;UIDragDetectorDragSpace:Parent=0,LayerCollector=1,Reference=2;UIDragDetectorDragStyle:TranslatePlane=0,TranslateLine=1,Rotate=2,Scriptable=3;UIDragDetectorResponseStyle:Offset=0,Scale=1,CustomOffset=2,CustomScale=3;UIDragSpeedAxisMapping:XY=0,XX=1,YY=2;UIFlexAlignment:None=0,Fill=1,SpaceAround=2,SpaceBetween=3,SpaceEvenly=4;UIFlexMode:None=0,Grow=1,Shrink=2,Fill=3,Custom=4;UITheme:Light=0,Dark=1;UiMessageType:UiMessageError=0,UiMessageInfo=1;UpdateState:UpdateNotAvailable=0,UpdateAvailable=1,UpdateInProgress=2,UpdateReady=3,UpdateFailed=4;UploadCaptureResult:Success=0,NeedPermission=1,CaptureModerated=2,CaptureNotInGallery=3,IneligibleCapture=4,UploadQuotaReached=5,UploadPending=6,UploadFailed=7;UsageContext:Default=0,Preview=1;UserAcquisitionSource:Unknown=0,PendingAttribution=1,HomeRecommendation=2,ContinueToPlay=3,Curation=4,Friends=5,Search=6,Teleport=7,Ads=8,HomeOther=9,Other=10;UserCFrame:Head=0,LeftHand=1,RightHand=2,Floor=3;UserIdMode:Invalid=0,Global=1,Domain=2;UserInputState:Begin=0,Change=1,End=2,Cancel=3,None=4;UserInputType:MouseButton1=0,MouseButton2=1,MouseButton3=2,MouseWheel=3,MouseMovement=4,Touch=7,Keyboard=8,Focus=9,Accelerometer=10,Gyro=11,Gamepad1=12,Gamepad2=13,Gamepad3=14,Gamepad4=15,Gamepad5=16,Gamepad6=17,Gamepad7=18,Gamepad8=19,TextInput=20,InputMethod=21,None=22;UserNewReturningStatus:Unknown=0,New=1,Returning=2;UserReturnStatus:Unknown=0,New=1,Returning=2;VRComfortSetting:Comfort=0,Normal=1,Expert=2,Custom=3;VRControllerModelMode:Disabled=0,Transparent=1;VRDeviceType:Unknown=0,OculusRift=1,HTCVive=2,ValveIndex=3,OculusQuest=4;VRLaserPointerMode:Disabled=0,Pointer=1,DualPointer=2;VRSafetyBubbleMode:NoOne=0,OnlyFriends=1,Anyone=2;VRScaling:World=0,Off=1;VRSessionState:Undefined=0,Idle=1,Visible=2,Focused=3,Stopping=4;VRTouchpad:Left=0,Right=1;VRTouchpadMode:Touch=0,VirtualThumbstick=1,ABXY=2;VelocityConstraintMode:Line=0,Plane=1,Vector=2;VerifiedLevel:Low=0,High=1;VerticalAlignment:Center=0,Top=1,Bottom=2;VerticalScrollBarPosition:Right=0,Left=1;VibrationMotor:Large=0,Small=1,LeftTrigger=2,RightTrigger=3,LeftHand=4,RightHand=5;VideoCaptureResult:Success=0,OtherError=1,ScreenSizeChanged=2,TimeLimitReached=3;VideoCaptureStartedResult:Success=0,OtherError=1,CapturingAlready=2,NoDeviceSupport=3,NoSpaceOnDevice=4;VideoDeviceCaptureQuality:Default=0,Low=1,Medium=2,High=3;VideoError:Ok=0,Eof=1,EAgain=2,BadParameter=3,AllocFailed=4,CodecInitFailed=5,CodecCloseFailed=6,DecodeFailed=7,ParsingFailed=8,Unsupported=9,Generic=10,DownloadFailed=11,StreamNotFound=12,EncodeFailed=13,CreateFailed=14,NoPermission=15,NoService=16,ReleaseFailed=17,Unknown=18;VideoSampleSize:Small=0,Medium=1,Large=2,Full=3;ViewMode:None=0,GeometryComplexity=1,Transparent=2,Decal=3;VirtualCursorMode:Default=0,Disabled=1,Enabled=2;VirtualInputMode:None=0,Recording=1,Playing=2;VoiceChatDistanceAttenuationType:Inverse=0,Legacy=1;VoiceChatState:Idle=0,Joining=1,JoiningRetry=2,Joined=3,Leaving=4,Ended=5,Failed=6;VoiceClientLeaveReasons:Unknown=0,ClientNetworkDisconnected=1,PlayerLeft=2,ClientShutdown=3,PublishFailed=4,RejoinReceived=5,VoiceReboot=6,ImguiDebugLeave=7,LuaInitiated=8;VoiceControlPath:Publish=0,Subscribe=1,Join=2;VoiceRccReconnectReason:Unknown=0,Migration=1,CloseRoom=2,FAEUpdate=3,BlockListChanged=4;VolumetricAudio:Disabled=0,Automatic=1,Enabled=2;WaterDirection:NegX=0,X=1,NegY=2,Y=3,NegZ=4,Z=5;WaterForce:None=0,Small=1,Medium=2,Strong=3,Max=4;WebSocketState:Connecting=0,Open=1,Closing=2,Closed=3;WebStreamClientState:Connecting=0,Open=1,Error=2,Closed=3;WebStreamClientType:SSE=0,RawStream=1,WebSocket=2;WeldConstraintPreserve:All=0,None=1,Touching=2;WhenUserFirstPlayed:Unknown=0,Days0To30=1,Days31To90=2,Days91To180=3,Days181To365=4,Days366Plus=5;WhisperChatPrivacyMode:AllUsers=0,NoOne=1;WindSoundProfile:Turbulence=0,Whistle=1,Foliage=2;WindowState:Normal=0,Minimized=1,Maximized=2;WrapLayerAutoSkin:Disabled=0,EnabledPreserve=1,EnabledOverride=2;WrapLayerDebugMode:None=0,BoundCage=1,LayerCage=2,BoundCageAndLinks=3,Reference=4,Rbf=5,OuterCage=6,ReferenceMeshAfterMorph=7,HSROuterDetail=8,HSROuter=9,HSRInner=10,HSRInnerReverse=11,LayerCageFittedToBase=12,LayerCageFittedToPrev=13,PreWrapDeformerOuterCage=14,SkinningTransfer=15;WrapTargetDebugMode:None=0,TargetCageOriginal=1,TargetCageCompressed=2,TargetCageInterface=3,TargetLayerCageOriginal=4,TargetLayerCageCompressed=5,TargetLayerInterface=6,Rbf=7,OuterCageDetail=8,PreWrapDeformerCage=9;ZIndexBehavior:Global=0,Sibling=1",
	classes = "Object<|GetPropertyChangedSignal,IsA,isA|Changed|ClassName:string,className:string;AnimatedImageTrack<Object|GetContent,GetFrameNames||Duration:float,FrameCount:int,TrackName:string;AnimationNode<Object|||;Capture<Object|||CaptureTime:DateTime,CaptureType:CaptureType,FilePathString:string,LocalId:string,SourcePlaceId:int64,SourceUniverseId:int64;ScreenshotCapture<Capture|||;VideoCapture<Capture|||FilePath:string,TimeLength:double;ConfigSnapshot<Object|GetValue,GetValueChangedSignal,Refresh|UpdateAvailable|Error:ConfigSnapshotErrorState,Outdated:bool;DataModelDiff<Object|GetChangeType,GetIdentities,GetPropertyNames||;EditableImage<Object|Destroy,DrawCircle,DrawImage,DrawImageProjected,DrawImageTransformed,DrawLine,DrawRectangle,DrawTriangle,ReadPixelsBuffer,SampleImageProjected,WritePixelsBuffer||ImageData:BinaryString,ImageHolder:NetAssetRef,IsReplicatedCopy:bool,Size:Vector2;EditableMesh<Object|AddBone,AddColor,AddFace,AddNormal,AddTriangle,AddUV,AddVertex,BatchAdd,BatchGetFaceAttributes,BatchGetValues,BatchGetVertexAttributes,BatchGetVertexFaceAttributes,BatchRemove,BatchSetFaceAttributes,BatchSetValues,BatchSetVertexFaceAttributes,Clear,Destroy,FindClosestPointOnSurface,FindClosestVertex,FindVerticesWithinSphere,GetAdjacentFaces,GetAdjacentVertices,GetBoneByName,GetBoneCFrame,GetBoneIsVirtual,GetBoneName,GetBoneParent,GetBones,GetCenter,GetColor,GetColorAlpha,GetColors,GetFaceColors,GetFaceNormals,GetFaceUVs,GetFaceVertices,GetFaces,GetFacesWithAttribute,GetFacesWithColor,GetFacesWithNormal,GetFacesWithUV,GetFacsCorrectivePose,GetFacsCorrectivePoses,GetFacsPose,GetFacsPoses,GetNormal,GetNormals,GetPosition,GetSize,GetUV,GetUVs,GetVertexBoneWeights,GetVertexBones,GetVertexColors,GetVertexFaceColor,GetVertexFaceNormal,GetVertexFaceUV,GetVertexFaces,GetVertexNormals,GetVertexUVs,GetVertices,GetVerticesWithAttribute,GetVerticesWithColor,GetVerticesWithNormal,GetVerticesWithUV,IdDebugString,MergeVertices,RaycastLocal,RemoveBone,RemoveFace,RemoveUnused,ResetNormal,SetBoneCFrame,SetBoneIsVirtual,SetBoneName,SetBoneParent,SetColor,SetColorAlpha,SetFaceColors,SetFaceNormals,SetFaceUVs,SetFaceVertices,SetFacsBonePose,SetFacsCorrectivePose,SetFacsPose,SetNormal,SetPosition,SetUV,SetVertexBoneWeights,SetVertexBones,SetVertexFaceColor,SetVertexFaceNormal,SetVertexFaceUV,Triangulate||EditableMeshDataHolder:NetAssetRef,FixedSize:bool,IsReplicatedCopy:bool,MeshData:SharedString;ExecutedRemoteCommand<Object|RunMoreCode,SendUpdate,Stop|ReceivedUpdate|;Instance<Object|AddTag,ClearAllChildren,Clone,Destroy,FindFirstAncestor,FindFirstAncestorOfClass,FindFirstAncestorWhichIsA,FindFirstChild,FindFirstChildOfClass,FindFirstChildWhichIsA,FindFirstDescendant,GetActor,GetAttribute,GetAttributeChangedSignal,GetAttributes,GetChildren,GetDebugId,GetDescendants,GetFullName,GetStyled,GetStyledPropertyChangedSignal,GetTags,HasTag,IsAncestorOf,IsDescendantOf,IsPropertyModified,QueryDescendants,Remove,RemoveTag,ResetPropertyToDefault,SetAttribute,WaitForChild,children,clone,destroy,findFirstChild,getChildren,isDescendantOf,remove|AncestryChanged,AttributeChanged,ChildAdded,ChildRemoved,DescendantAdded,DescendantRemoving,Destroying,StyledPropertiesChanged,childAdded|Archivable:bool,Attributes:string,AttributesReplicate:string,AttributesSerialize:BinaryString,Capabilities:SecurityCapabilities,DataCost:int,DefinesCapabilities:bool,HistoryId:UniqueId,IsInSandbox:bool,Name:string,Parent:Instance,PredictionMode:PredictionMode,PropertyStatusStudio:PropertyStatus,RobloxLocked:bool,Sandboxed:bool,SerializedOverrides:BinaryString,SourceAssetId:int64,Tags:SharedString,UniqueId:UniqueId,archivable:bool,numExpectedDirectChildren:int;AccessoryDescription<Instance|GetAppliedInstance||AccessoryType:AccessoryType,AssetId:int64,Instance:Instance,IsLayered:bool,Order:int,Position:Vector3,Puffiness:float,Rotation:Vector3,Scale:Vector3;AccountService<Instance|DeviceAccessTokenAvailable,DeviceIntegrityAvailable,GetDeviceIntegrityToken,MagicLogin,GetCredentialsHeaders,GetDeviceAccessToken,GetDeviceIntegrityTokenYield|MagicLoginEvent|;Accoutrement<Instance|||AttachmentForward:Vector3,AttachmentPoint:CFrame,AttachmentPos:Vector3,AttachmentRight:Vector3,AttachmentUp:Vector3,BackendAccoutrementState:int;Accessory<Accoutrement|||AccessoryType:AccessoryType;Hat<Accoutrement|||;AchievementService<Instance|IsAvailable,GrantAchievement,HasAchieved||;ActivityHistoryEventService<Instance||WriteActivityHistoryEventFromStudio|;AdPlacement<Instance|||ActivationInstance:Instance,AdFormat:AdFormat,PlacementId:int64,RewardId:string,RewardImageContent:Content,RewardName:string,Visible:bool;AdPortal<Instance|||PortalInvalidReason:string,PortalVersion:int64,Status:AdUnitStatus;AdService<Instance|CreateAdRewardFromDevProductId,GetAdTeleportInfo,GetReportAdInfo,GetUniversalAppAdsEligibility,HandleWhyThisAdClicked,HideEudsaDisclosure,IsAdLoaded,OnDemandVideoCompleteFromUI,RegisterDisclosureButton,RegisterImpressionSource,ReturnToPublisherExperience,SetAdGuiInteractivityHandlerInitialized,ShowVideoAd,SubmitAdNotification,UnregisterAdOpportunity,GetAdAvailabilityNowAsync,GetAdAvailabilityNowForUniverseAsync,GetCampaignEligibilityAsync,RegisterAdOpportunityAsync,ShowRewardedVideoAdAsync,ShowRewardedVideoAdAtClientAsync|AdTeleportEnded,AdTeleportInitiated,CampaignEligibilityResponseFailureSignalFromClient,CampaignEligibilityResponseSuccessSignalFromClient,GetCampaignEligibilitySignalFromServer,ReportImpressionSignal,ReportTeleportSignal,RewardedVideoAdEnded,RewardedVideoAdStarted,ServeAdResponseSignal,ServeAdSignal,ShowDynamicEudsaDisclosure,ShowReportAdPopup,VideoAdClosed,adGuiRegisterUI,rewardedVideoAdPlayServerToClient,rewardedVideoAdPlayServerToClientWithPlacement,rewardedVideoAdResultClientToServer|OnImmersiveBrandedAdDisclosureButtonActivated,onDemandVideoPlayInUI;AdvancedDragger<Instance|||;AnalyticsService<Instance|FireCustomEvent,FireEvent,FireInGameEconomyEvent,FireLogEvent,FirePlayerProgressionEvent,GetDurationLoggerTimestamp,LogCustomEvent,LogEconomyEvent,LogFunnelStepEvent,LogJourneyEvent,LogOnboardingFunnelStepEvent,LogProgressionCompleteEvent,LogProgressionEvent,LogProgressionFailEvent,LogProgressionStartEvent,GetPlayerSegmentsAsync||ApiKey:string;AnimatedImageService<Instance|GetFrameNames,GetTrack,GetTracksChanged,Prewarm,UnloadTracks||;Animation<Instance|||AnimationContent:Content,AnimationId:ContentId;AnimationClip<Instance|||Guid:string,GuidBinaryString:BinaryString,Length:float,Loop:bool,Priority:AnimationPriority;AnimationGraphDefinition<AnimationClip|||;CurveAnimation<AnimationClip|||;KeyframeSequence<AnimationClip|AddKeyframe,GetKeyframes,RemoveKeyframe||AuthoredHipHeight:float;AnimationClipProvider<Instance|GetAnimationClip,GetAnimationClipById,GetAnimationNodeDefinition,GetAnimationNodeTypes,GetMemStats,RegisterActiveAnimationClip,RegisterAnimationClip,GetAnimationClipAsync,GetAnimations,GetAnimationsAsync,GetClipEvaluatorAsync||;AnimationController<Instance|GetPlayingAnimationTracks,LoadAnimation|AnimationPlayed|;AnimationFromVideoCreatorService<Instance|CreateJob,DownloadJobResult,FullProcess,GetJobStatus||;AnimationFromVideoCreatorStudioService<Instance|IsAgeRestricted,CreateAnimationByUploadingVideo,ImportVideoWithPrompt||;AnimationNodeDefinition<Instance|AddInputPin,GetOrderedInputPinNames,RemoveInputPin,SetOrderedInputPinNames|InputPinsChanged|InputPinData:BinaryString,NodeId:string,NodeType:AnimationNodeType;AnimationRigData<Instance|Dump,GetLabels,GetNames,GetParents,GetPostTransforms,GetPreTransforms,GetTransforms,IsValidR15,IsValidR15Plus,LoadFromHumanoid,LoadFromModel||Generic:BinaryString,label:BinaryString,name:BinaryString,parent:BinaryString,postTransform:BinaryString,preTransform:BinaryString,transform:BinaryString;AnimationStreamTrack<Instance|AdjustWeight,GetActive,GetTrackerData,Play,Stop,TogglePause|Stopped|Animation:TrackerStreamAnimation,FACSDataLod:FACSDataLod,IsPlaying:bool,Priority:AnimationPriority,WeightCurrent:float,WeightTarget:float;AnimationTrack<Instance|AdjustSpeed,AdjustWeight,GetDebugData,GetMarkerReachedSignal,GetParameter,GetParameterDefaults,GetTargetInstance,GetTargetNames,GetTimeOfKeyframe,Play,ResetGraph,SetParameter,SetTargetInstance,Stop,UpdateGraphNodeProperty|DidLoop,Ended,KeyframeReached,ParameterChanged,Stopped|Animation:Animation,IsPlaying:bool,Length:float,Looped:bool,Priority:AnimationPriority,Speed:float,TimePosition:float,WeightCurrent:float,WeightTarget:float;AnimationValueNodeDefinition<Instance|||NodeId:string,NodeType:AnimationValueNodeType;AnimationValueOutputDefinition<Instance|||;Animator<Instance|ApplyJointVelocities,GetPlayingAnimationTracks,GetPlayingAnimationTracksCoreScript,GetTrackByAnimationId,LoadAnimation,LoadAnimationCoreScript,LoadStreamAnimation,LoadStreamAnimationForSelfieView_deprecated,LoadStreamAnimationV2,RegisterEvaluationParallelCallback,StepAnimations,StepAnimationsInternal,SynchronizeWith|AnimationPlayed,AnimationPlayedCoreScript,AnimationStreamTrackPlayed,OnCombinedUpdate,OnGraphParameterUpdate,OnStreamingUpdated2,StreamSyncRequest|AnimTrackMetadata0:AnimTrackMetadata,AnimTrackMetadata1:AnimTrackMetadata,AnimTrackMetadata10:AnimTrackMetadata,AnimTrackMetadata11:AnimTrackMetadata,AnimTrackMetadata12:AnimTrackMetadata,AnimTrackMetadata13:AnimTrackMetadata,AnimTrackMetadata14:AnimTrackMetadata,AnimTrackMetadata15:AnimTrackMetadata,AnimTrackMetadata2:AnimTrackMetadata,AnimTrackMetadata3:AnimTrackMetadata,AnimTrackMetadata4:AnimTrackMetadata,AnimTrackMetadata5:AnimTrackMetadata,AnimTrackMetadata6:AnimTrackMetadata,AnimTrackMetadata7:AnimTrackMetadata,AnimTrackMetadata8:AnimTrackMetadata,AnimTrackMetadata9:AnimTrackMetadata,AnimTrackPlayState0:AnimTrackPlayState,AnimTrackPlayState1:AnimTrackPlayState,AnimTrackPlayState10:AnimTrackPlayState,AnimTrackPlayState11:AnimTrackPlayState,AnimTrackPlayState12:AnimTrackPlayState,AnimTrackPlayState13:AnimTrackPlayState,AnimTrackPlayState14:AnimTrackPlayState,AnimTrackPlayState15:AnimTrackPlayState,AnimTrackPlayState2:AnimTrackPlayState,AnimTrackPlayState3:AnimTrackPlayState,AnimTrackPlayState4:AnimTrackPlayState,AnimTrackPlayState5:AnimTrackPlayState,AnimTrackPlayState6:AnimTrackPlayState,AnimTrackPlayState7:AnimTrackPlayState,AnimTrackPlayState8:AnimTrackPlayState,AnimTrackPlayState9:AnimTrackPlayState,AnimTrackWeight0:AnimTrackWeight,AnimTrackWeight1:AnimTrackWeight,AnimTrackWeight10:AnimTrackWeight,AnimTrackWeight11:AnimTrackWeight,AnimTrackWeight12:AnimTrackWeight,AnimTrackWeight13:AnimTrackWeight,AnimTrackWeight14:AnimTrackWeight,AnimTrackWeight15:AnimTrackWeight,AnimTrackWeight2:AnimTrackWeight,AnimTrackWeight3:AnimTrackWeight,AnimTrackWeight4:AnimTrackWeight,AnimTrackWeight5:AnimTrackWeight,AnimTrackWeight6:AnimTrackWeight,AnimTrackWeight7:AnimTrackWeight,AnimTrackWeight8:AnimTrackWeight,AnimTrackWeight9:AnimTrackWeight,AnimationId0:int64,AnimationId1:int64,AnimationId10:int64,AnimationId11:int64,AnimationId12:int64,AnimationId13:int64,AnimationId14:int64,AnimationId15:int64,AnimationId2:int64,AnimationId3:int64,AnimationId4:int64,AnimationId5:int64,AnimationId6:int64,AnimationId7:int64,AnimationId8:int64,AnimationId9:int64,EvaluationThrottled:bool,FacsReplicationData:FacsReplicationData,PreferLodEnabled:bool,RootMotion:CFrame,RootMotionWeight:float;Annotation<Instance|GetRequests,GetStringUniqueId,IsThreadParent|RequestCompleted,RequestInitiated|AuthorColor3:Color3,AuthorId:int64,ChannelId:string,Contents:string,CreationTimeUnix:int64,LastModifiedTimeUnix:int64,LoadingReplies:bool,MessageId:string,ReplyCount:int64,Resolved:bool,TaggedUsers:string;WorkspaceAnnotation<Annotation|GetAbsolutePosition,SetAdorneeOffsetFromAbsolutePosition||Adornee:PVInstance,AdorneeOffset:Vector3;AnnotationsService<Instance|CreateAnnotation,CreateOrUpdatePlacePreference,DeleteAnnotation,EditAnnotation,GetAnnotationThreads,GetPlacePreference,LoadAnnotationReplies,LoadAnnotations,LoadResolvedAnnotations,ResolveAnnotation,CreateOrUpdateChannelPreferenceAsync,CreateOrUpdatePlacePreferenceAsync,GetChannelPreferenceAsync,GetPlacePreferenceAsync|AnnotationAdded,AnnotationDeleted,AnnotationEdited,AnnotationResolved,ServerLoadAnnotationReplies,ServerLoadAnnotations,ServerLoadResolvedAnnotations|AnnotationsLoadingStatus:AnnotationRequestStatus,AnnotationsVisible:bool,Hovered:Annotation,Mode:AnnotationEditingMode,ResolvedLoadingStatus:AnnotationRequestStatus,Selected:Annotation;AppAgeSignalsService<Instance|IsAvailable,GetAppAgeSignalsAsync||;AppLifecycleObserverService<Instance|GetCurrentState,IsDidDetachSupported,TriggerOnLandingPageMount,TriggerOnLuaAppInteractive,TriggerOnLuaAppReadyToRender,TriggerOnPageMilestone|OnBecomeActive,OnDetach,OnHide,OnResignActive,OnStart,OnUnhide|;AppRatingPromptService<Instance|isAppRatingPromptAvailable,showAppRatingPrompt|OnGameLeft|;AppUpdateService<Instance|CanPerformBinaryUpdate,CheckForUpdate,GetProtocolLaunchUpdateName,GetProtocolLaunchUpdateType,PerformManagedUpdate||;AssetCounterService<Instance|||;AssetDeliveryProxy<Instance|||Interface:string,Port:int,StartServer:bool;AssetImportService<Instance|GetAllPresets,GetPreset,RemovePreset,SavePreset,StartSessionWithPath,StartSingleFileWatch,StopSingleFileWatch,GetFilesInDirAsync,PickFileWithPromptAsync,PickImageFileWithPrompt,PickMeshFileWithPrompt,PickMultipleFilesWithPrompt,StartSessionWithPathAsync,UploadAssetFromContentAsync,UploadAssetFromPathAsync,UploadVersionedAssetFromContentAsync,UploadVersionedAssetFromPathAsync|SingleFileChanged,StartSingleMeshImport|;AssetManagerService<Instance|GetMeshIdFromAliasName,GetMeshIdFromAssetId,GetTextureIdFromAliasName,GetTextureIdFromAssetId,InsertAudio,InsertImage,InsertImages,InsertMesh,InsertMeshesWithLocation,InsertModel,InsertPackage,InsertVideo,OpenPlace,ShowPackageDetails,UpdateAllPackages,ViewPackageOnWebsite,AddNewPlace,CreateAlias,DeleteAlias,RemovePlace,RenameAlias,RenameModel,RenamePlace|AssetImportedSignal,ImportSessionFinished,ImportSessionStarted|;AssetPatchSettings<Instance|||ContentId:string,OutputPath:string,PatchId:string;AssetQualityService<Instance|FetchAssetQualitySummaryFromGltfAsync,FetchAssetQualitySummaryFromJobIdAsync,FetchAssetQualityValidationEntriesFromModelsAsync,FetchAssetQualityValidationRawFromModelsAsync,FetchAssetQualityVisualizationDataFromUrlAsync,GenerateAssetQualityGltfFromInstanceAsync||;AssetService<Instance|CreateEditableImage,CreateEditableMesh,DeserializeInstance,GetOpaqueContentMetadataMap,CachePartOperationsAsync,CanEditAssetAsync,ComposeDecalAsync,CreateAssetAsync,CreateAssetVersionAsync,CreateDataModelContentAsync,CreateDecalAsync,CreateEditableImageAsync,CreateEditableImageFromDownloadAsync,CreateEditableMeshAsync,CreateMeshPartAsync,CreatePlaceAsync,CreatePlaceInPlayerInventoryAsync,CreateSurfaceAppearanceAsync,CreateTextureAsync,GetAssetIdsForPackage,GetAssetIdsForPackageAsync,GetAudioMetadataAsync,GetBundleDetailsAsync,GetCreatorAssetID,GetGamePlacesAsync,LoadAssetAsync,PromptCreatePlatformContentAsync,PromptImportAnimationClipFromVideoAsync,SavePlaceAsync,SearchAudio,SearchAudioAsync|AudioMetadataFailedResponse,AudioMetadataRequest,AudioMetadataResponse,OpenPublishResultModal|AllowInsertFreeAssets:bool;Atmosphere<Instance|||Color:Color3,Decay:Color3,Density:float,Glare:float,Haze:float,Offset:float;Attachment<Instance|GetAxis,GetConstraints,GetSecondaryAxis,SetAxis,SetSecondaryAxis||Axis:Vector3,CFrame:CFrame,Orientation:Vector3,Position:Vector3,Rotation:Vector3,SecondaryAxis:Vector3,Visible:bool,WorldAxis:Vector3,WorldCFrame:CFrame,WorldOrientation:Vector3,WorldPosition:Vector3,WorldRotation:Vector3,WorldSecondaryAxis:Vector3;Bone<Attachment|||Transform:CFrame,TransformedCFrame:CFrame,TransformedWorldCFrame:CFrame;AudioAnalyzer<Instance|GetConnectedWires,GetInputPins,GetOutputPins,GetSpectrum|WiringChanged|PeakLevel:float,RmsLevel:float,SpectrumEnabled:bool,WindowSize:AudioWindowSize;AudioChannelMixer<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Layout:AudioChannelLayout;AudioChannelSplitter<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Layout:AudioChannelLayout;AudioChorus<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Depth:float,Mix:float,Rate:float;AudioCompressor<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Attack:float,Bypass:bool,Editor:bool,MakeupGain:float,Ratio:float,Release:float,Threshold:float;AudioDeviceInput<Instance|GetConnectedWires,GetInputPins,GetOutputPins,GetUserIdAccessList,SetUserIdAccessList|WiringChanged|AccessList:BinaryString,AccessType:AccessModifierType,Active:bool,DictationEnabled:bool,EchoCancellation:bool,GainControl:bool,IsReady:bool,Muted:bool,MutedByLocalUser:bool,NoiseSuppression:bool,Player:Player,Volume:float;AudioDeviceOutput<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Player:Player;AudioDistortion<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Level:float;AudioEcho<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Reset|WiringChanged|Bypass:bool,DelayTime:float,DryLevel:float,Feedback:float,RampTime:float,WetLevel:float;AudioEmitter<Instance|GetAngleAttenuation,GetAudibilityFor,GetConnectedWires,GetDistanceAttenuation,GetInputPins,GetInteractingListeners,GetOutputPins,SetAngleAttenuation,SetDistanceAttenuation|WiringChanged|AcousticSimulationEnabled:bool,AngleAttenuation:BinaryString,AudioInteractionGroup:string,DiffractionEnabled:SimulationMode,DistanceAttenuation:BinaryString,DistanceAttenuationBounds:NumberRange,DistanceAttenuationMode:DistanceAttenuationMode,OcclusionEnabled:SimulationMode,PositionInstance:Instance,PositionType:EmitterPositionType,ReverbEnabled:SimulationMode,SimulationFidelity:AudioSimulationFidelity;AudioEqualizer<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Editor:bool,HighGain:float,LowGain:float,MidGain:float,MidRange:NumberRange;AudioFader<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Volume:float;AudioFilter<Instance|GetConnectedWires,GetGainAt,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Editor:bool,FilterType:AudioFilterType,Frequency:float,Gain:float,Q:float;AudioFlanger<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Depth:float,Mix:float,Rate:float;AudioFocusService<Instance|AcquireFocus,GetFocusedContextId,GetRegisteredContexts,RegisterContextIdFromLua,RequestFocus|OnContextRegistered,OnContextUnregistered,OnDeafenVoiceAudio,OnUndeafenVoiceAudio|;AudioGate<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Reset|WiringChanged|Attack:float,Bypass:bool,Release:float,Threshold:NumberRange;AudioLimiter<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Editor:bool,MaxLevel:float,Release:float;AudioListener<Instance|GetAngleAttenuation,GetAudibilityFor,GetConnectedWires,GetDistanceAttenuation,GetInputPins,GetInteractingEmitters,GetOutputPins,Reset,SetAngleAttenuation,SetDistanceAttenuation|WiringChanged|AcousticSimulationEnabled:bool,AngleAttenuation:BinaryString,AudioInteractionGroup:string,DiffractionEnabled:SimulationMode,DistanceAttenuation:BinaryString,OcclusionEnabled:SimulationMode,PositionInstance:Instance,PositionType:ListenerPositionType,ReverbEnabled:SimulationMode,SimulationFidelity:AudioSimulationFidelity;AudioPitchShifter<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Pitch:float,WindowSize:AudioWindowSize;AudioPlayer<Instance|Cancel,GetConnectedWires,GetInputPins,GetOutputPins,Play,Stop,GetWaveformAsync|Ended,Looped,WiringChanged|Asset:ContentId,AssetId:string,AssetRepresentation:AssetRepresentation,AudioContent:Content,AutoLoad:bool,AutoPlay:bool,IsPlaying:bool,IsReady:bool,LoopRegion:NumberRange,Looping:bool,PlaybackRegion:NumberRange,PlaybackSpeed:double,TimeLength:double,TimePosition:double,Volume:float;AudioRecorder<Instance|Clear,GetConnectedWires,GetInputPins,GetOutputPins,GetTemporaryContent,Stop,CanRecordAsync,GetUnrecordableInstancesAsync,RecordAsync|WiringChanged|IsRecording:bool,TimeLength:double;AudioReverb<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Reset|WiringChanged|Bypass:bool,DecayRatio:float,DecayTime:float,Density:float,Diffusion:float,DryLevel:float,EarlyDelayTime:float,HighCutFrequency:float,LateDelayTime:float,LowShelfFrequency:float,LowShelfGain:float,ReferenceFrequency:float,WetLevel:float;AudioSearchParams<Instance|||Album:string,Artist:string,AudioSubType:AudioSubType,AudioSubtype:AudioSubType,MaxDuration:int,MinDuration:int,SearchKeyword:string,Tag:string,Title:string;AudioSpeechToText<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|DictationEnabled:bool,DisableVoiceDetection:bool,EnableVolumeCheck:bool,Enabled:bool,Text:string,VoiceDetected:bool,VoiceDetectedOverride:bool;AudioTextToSpeech<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Pause,Play,Unload,GetWaveformAsync,LoadAsync,LoadPlatformAsync|Ended,Looped,WiringChanged|IsLoaded:bool,IsPlaying:bool,Looping:bool,Pitch:float,PlaybackSpeed:float,Speed:float,Text:string,TimeLength:double,TimePosition:double,VoiceId:string,Volume:float;AudioTremolo<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Bypass:bool,Depth:float,Duty:float,Frequency:float,Shape:float,Skew:float,Square:float;AudioWindSynthesizer<Instance|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|Enabled:bool,PositionInstance:Instance,PositionType:AudioPositionType,Profile:WindSoundProfile,Volume:float;AuroraScriptObject<Instance|GetCurrentState,SetStateFieldValue||BehaviorWeak:AuroraScript,BoundInstanceWeak:Instance,FrameId:int,LODLevel:int,MaxFrequency:int,PriorFrameInvoked:int;AuroraScriptService<Instance|FindBinding,FindBindings,GetAllCollections,GetLocalFrameId,SendMessage,getBehaviorObjects,getBehaviors,getBehaviorsForInstance,getInstancesForBehavior||;AuroraService<Instance|GetPredictedInstances,GetRemoteWorldStepId,GetServerView,GetWorldStepId,IsInstancePredicted,PlayInputRecording,SetReplicationLag,ShowDebugVisualizer,StartInputRecording,StartPrediction,StepPhysics,StopInputRecording,StopPrediction,UpdateProperties|FixedRateTick,Step|BufferFullInputCount:int,HashRoundingPoint:double,IgnoreRotation:bool,InputDropRate:float,LockStepIdOffset:bool,OutOfOrderInputCount:int,RCCHeartbeatFPS:double,RollbackOffset:int,TooOldInputCount:int;AvatarAbilityRules<Instance|||CharacterControllerMode:AvatarSettingsCharacterControllerMode,EnableClimbing:bool,EnableCrouching:bool,EnableFallingDown:bool,EnableGettingUp:bool,EnableHolding:bool,EnableJumping:bool,EnableReaching:bool,EnableRunning:bool,EnableSitting:bool,EnableSprinting:bool,EnableSwimming:bool,EnableTurning:bool;AvatarAccessoryRules<Instance|willRemoveAccessory||AccessoryMode:AvatarSettingsAccessoryMode,CustomAccessoryMode:AvatarSettingsCustomAccessoryMode,CustomBackAccessoryEnabled:bool,CustomBackAccessoryId:int64,CustomFaceAccessoryEnabled:bool,CustomFaceAccessoryId:int64,CustomFrontAccessoryEnabled:bool,CustomFrontAccessoryId:int64,CustomHairAccessoryEnabled:bool,CustomHairAccessoryId:int64,CustomHeadAccessoryEnabled:bool,CustomHeadAccessoryId:int64,CustomNeckAccessoryEnabled:bool,CustomNeckAccessoryId:int64,CustomShoulderAccessoryEnabled:bool,CustomShoulderAccessoryId:int64,CustomWaistAccessoryEnabled:bool,CustomWaistAccessoryId:int64,EnableEmissives:bool,EnableSound:bool,EnableVFX:bool,LimitBounds:Vector3,LimitMethod:AvatarSettingsAccessoryLimitMethod;AvatarAnimationRules<Instance|||AnimationClipsMode:AvatarSettingsAnimationClipsMode,AnimationPacksMode:AvatarSettingsAnimationPacksMode,CustomClimbAnimationEnabled:bool,CustomClimbAnimationId:int64,CustomFallAnimationEnabled:bool,CustomFallAnimationId:int64,CustomIdleAlt1AnimationEnabled:bool,CustomIdleAlt1AnimationId:int64,CustomIdleAlt2AnimationEnabled:bool,CustomIdleAlt2AnimationId:int64,CustomIdleAnimationEnabled:bool,CustomIdleAnimationId:int64,CustomJumpAnimationEnabled:bool,CustomJumpAnimationId:int64,CustomRunAnimationEnabled:bool,CustomRunAnimationId:int64,CustomSwimAnimationEnabled:bool,CustomSwimAnimationId:int64,CustomSwimIdleAnimationEnabled:bool,CustomSwimIdleAnimationId:int64,CustomWalkAnimationEnabled:bool,CustomWalkAnimationId:int64;AvatarBodyRules<Instance|||AppearanceMode:AvatarSettingsAppearanceMode,BuildMode:AvatarSettingsBuildMode,CustomBodyBundleId:int64,CustomBodyType:AvatarSettingsCustomBodyType,CustomBodyTypeScale:NumberRange,CustomEyebrowEnabled:bool,CustomEyebrowId:int64,CustomEyelashEnabled:bool,CustomEyelashId:int64,CustomFaceEnabled:bool,CustomFaceId:int64,CustomHeadEnabled:bool,CustomHeadId:int64,CustomHeadScale:NumberRange,CustomHeight:NumberRange,CustomHeightScale:NumberRange,CustomLeftArmEnabled:bool,CustomLeftArmId:int64,CustomLeftLegEnabled:bool,CustomLeftLegId:int64,CustomMoodEnabled:bool,CustomMoodId:int64,CustomProportionsScale:NumberRange,CustomRightArmEnabled:bool,CustomRightArmId:int64,CustomRightLegEnabled:bool,CustomRightLegId:int64,CustomTorsoEnabled:bool,CustomTorsoId:int64,CustomWidthScale:NumberRange,KeepPlayerHead:bool,ScaleMode:AvatarSettingsScaleMode;AvatarChatService<Instance|DebugCounterGet,EnableVoice,IsEnabled,IsPlaceEnabled,IsUniverseEnabled,PollClientFeatures,PollServerFeatures,deviceMeetsRequirementsForFeature,GetClientFeaturesAsync,GetServerFeaturesAsync|OnClientFeatures,RefreshClientFeatures|ClientFeatures:int,ClientFeaturesInitialized:bool,ServerFeatures:int;AvatarClothingRules<Instance|||ClothingMode:AvatarSettingsClothingMode,CustomClassicPantsAccessoryEnabled:bool,CustomClassicPantsAccessoryId:int64,CustomClassicShirtsAccessoryEnabled:bool,CustomClassicShirtsAccessoryId:int64,CustomClassicTShirtsAccessoryEnabled:bool,CustomClassicTShirtsAccessoryId:int64,CustomClothingMode:AvatarSettingsCustomClothingMode,CustomDressSkirtAccessoryEnabled:bool,CustomDressSkirtAccessoryId:int64,CustomJacketAccessoryEnabled:bool,CustomJacketAccessoryId:int64,CustomLeftShoesAccessoryEnabled:bool,CustomLeftShoesAccessoryId:int64,CustomPantsAccessoryEnabled:bool,CustomPantsAccessoryId:int64,CustomRightShoesAccessoryEnabled:bool,CustomRightShoesAccessoryId:int64,CustomShirtAccessoryEnabled:bool,CustomShirtAccessoryId:int64,CustomShortsAccessoryEnabled:bool,CustomShortsAccessoryId:int64,CustomSweaterAccessoryEnabled:bool,CustomSweaterAccessoryId:int64,CustomTShirtAccessoryEnabled:bool,CustomTShirtAccessoryId:int64,LimitBounds:Vector3;AvatarCollisionRules<Instance|||CollisionMode:AvatarSettingsCollisionMode,HitAndTouchDetectionMode:AvatarSettingsHitAndTouchDetectionMode,LegacyCollisionMode:AvatarSettingsLegacyCollisionMode,SingleColliderSize:Vector3;AvatarCreationService<Instance|DeserializeAvatarModel,GetValidationRules,HandleSelfieConsentResult,HandleSelfieQRResult,AutoSetupAvatarAsync,CreateCageMeshPartsWithScaleForExportAsync,GenerateAvatar2DPreviewAsync,GenerateAvatarAsync,GetBatchTokenDetailsAsync,LoadAvatar2DPreviewAsync,LoadGeneratedAvatarAsync,PrepareAvatarForPreviewAsync,PromptCreateAvatarAssetAsync,PromptCreateAvatarAsync,PromptCreateMakeupAsync,PromptSelectAvatarGenerationImageAsync,RequestAvatarGenerationSessionAsync,ValidateUGCAccessoryAsync,ValidateUGCBodyPartAsync,ValidateUGCFullBodyAsync|AvatarAssetModerationCompleted,AvatarModerationCompleted,AvatarOutfitModerationCompleted,OpenSelfieConsent,OpenSelfieQRCode,ReplicateAvatarGenerationImageIdWithErrorType,ReplicateAvatarModel,ReplicateAvatarPreviewUrl,RequestAvatarGenerationImage,RequestAvatarModel,RequestAvatarPreviewUrl,UgcValidationFailure,UgcValidationSuccess|;AvatarEditorService<Instance|BustAvatarFetchCache,GetAccessoryType,NoPromptApplyProfileConfiguration,NoPromptCreateOutfit,NoPromptDeleteOutfit,NoPromptRenameOutfit,NoPromptSaveAvatar,NoPromptSaveAvatarThumbnailCustomization,NoPromptSetFavorite,NoPromptUpdateOutfit,PerformCreateOutfitWithDescription,PerformDeleteOutfit,PerformRenameOutfit,PerformSaveAvatarWithDescription,PerformSetFavorite,PerformUpdateOutfit,PromptAllowInventoryReadAccess,PromptCreateOutfit,PromptDeleteOutfit,PromptRenameOutfit,PromptSaveAvatar,PromptSetFavorite,PromptUpdateOutfit,SetAllowInventoryReadAccess,SignalCreateOutfitFailed,SignalCreateOutfitPermissionDenied,SignalDeleteOutfitFailed,SignalDeleteOutfitPermissionDenied,SignalRenameOutfitFailed,SignalRenameOutfitPermissionDenied,SignalSaveAvatarFailed,SignalSaveAvatarPermissionDenied,SignalSetFavoriteFailed,SignalSetFavoritePermissionDenied,SignalUpdateOutfitFailed,SignalUpdateOutfitPermissionDenied,refreshAvatarThumbnails,CheckApplyDefaultClothing,CheckApplyDefaultClothingAsync,ConformToAvatarRules,ConformToAvatarRulesAsync,GetAvatarRules,GetAvatarRulesAsync,GetBatchItemDetails,GetBatchItemDetailsAsync,GetBundlesByAssetIdAsync,GetFavorite,GetFavoriteAsync,GetHeadShapesAsync,GetInventory,GetInventoryAsync,GetItemDetails,GetItemDetailsAsync,GetOutfitDetails,GetOutfitDetailsAsync,GetOutfits,GetOutfitsAsync,GetRecommendedAssets,GetRecommendedAssetsAsync,GetRecommendedBundles,GetRecommendedBundlesAsync,SearchCatalog,SearchCatalogAsync|NotifyBustAvatarFetchCache,OpenAllowInventoryReadAccess,OpenPromptCreateOufit,OpenPromptDeleteOutfit,OpenPromptRenameOutfit,OpenPromptSaveAvatar,OpenPromptSetFavorite,OpenPromptUpdateOutfit,PromptAllowInventoryReadAccessCompleted,PromptApplyProfileConfigurationCompleted,PromptCreateOutfitCompleted,PromptDeleteOutfitCompleted,PromptRenameOutfitCompleted,PromptSaveAvatarCompleted,PromptSaveAvatarThumbnailCustomizationCompleted,PromptSetFavoriteCompleted,PromptUpdateOutfitCompleted|;AvatarImportService<Instance|ImportFBXAnimationFromFilePathUserMayChooseModel,ImportFBXAnimationUserMayChooseModel,ImportFbxRigWithoutSceneLoad,ImportLoadedFBXAnimation,LoadRigAndDetectType||;AvatarRules<Instance|||AvatarType:GameAvatarType;AvatarSettings<Instance|Discard,Publish|DiscardRequested,RefreshPluginState|Loaded:bool;Backpack<Instance|||;BadgeService<Instance|AwardBadge,AwardBadgeAsync,CheckUserBadgesAsync,GetBadgeInfoAsync,GetUserBadgesAsync,IsDisabled,IsLegal,UserHasBadge,UserHasBadgeAsync|BadgeAwarded,OnBadgeAwarded|;BaseCoreGuiConfiguration<Instance|||Enabled:bool;CapturesViewConfiguration<BaseCoreGuiConfiguration|||Open:bool;PlayerListConfiguration<BaseCoreGuiConfiguration|||Open:bool;SelfViewConfiguration<BaseCoreGuiConfiguration|||Open:bool;BaseImportData<Instance|CreatePresetFromData,GetPreview,GetStatuses|StatusRemoved,StatusReported|Id:string,ImportName:string,ShouldImport:bool;AnimationImportData<BaseImportData|||ForceNewVersion:bool,VersionedAssetId:int64;FacsImportData<BaseImportData|||;GroupImportData<BaseImportData|||Anchored:bool,ImportAsModelAsset:bool,InsertInWorkspace:bool;JointImportData<BaseImportData|||;MaterialImportData<BaseImportData|||DiffuseFilePath:string,DiffuseVersionedAssetId:int64,EmissiveFilePath:string,EmissiveVersionedAssetId:int64,IsPbr:bool,MetalnessFilePath:string,MetalnessVersionedAssetId:int64,NormalFilePath:string,NormalVersionedAssetId:int64,RoughnessFilePath:string,RoughnessVersionedAssetId:int64;MeshImportData<BaseImportData|||Anchored:bool,CageManifold:bool,CageMeshIntersectedPreview:bool,CageMeshNotIntersected:bool,CageNoOverlappingVertices:bool,CageNonManifoldPreview:bool,CageOverlappingVerticesPreview:bool,CageUVMatched:bool,CageUVMisMatchedPreview:bool,Dimensions:Vector3,DoubleSided:bool,IgnoreVertexColors:bool,IrrelevantCageModifiedPreview:bool,MeshHoleDetectedPreview:bool,MeshNoHoleDetected:bool,NoIrrelevantCageModified:bool,NoOuterCageFarExtendedFromMesh:bool,OuterCageFarExtendedFromMeshPreview:bool,PolygonCount:float,UseImportedPivot:bool,VersionedAssetId:int64;RootImportData<BaseImportData|||AddModelToInventory:bool,Anchored:bool,AnimationIdForRestPose:float,ExistingPackageId:string,FileDimensions:Vector3,ImportAsModelAsset:bool,ImportAsPackage:bool,InsertInWorkspace:bool,InsertWithScenePosition:bool,InvertNegativeFaces:bool,KeepZeroInfluenceBones:bool,MergeMeshes:bool,PhysicalConstraintType:PhysicalConstraintType,PolygonCount:float,PreferredUploadId:int64,RestPose:RestPose,RigScale:RigScale,RigType:RigType,RigVisualization:bool,ScaleFactor:float,ScaleUnit:MeshScaleUnit,UseSceneOriginAsPivot:bool,UsesCages:bool,VersionedAssetId:int64,WorldForward:NormalId,WorldUp:NormalId;BasePlayerGui<Instance|GetGuiObjectsAtPosition,GetGuiObjectsInCircle||;CoreGui<BasePlayerGui|SetUserGuiRendering,TakeScreenshot,ToggleRecording|UserGuiRenderingChanged|SelectionImageObject:GuiObject,Version:int;PlayerGui<BasePlayerGui|GetTopbarTransparency,SetTopbarTransparency|TopbarTransparencyChangedSignal|CurrentScreenOrientation:ScreenOrientation,InputBindingMappingsRaw:BinaryString,ScreenOrientation:ScreenOrientation,SelectionImageObject:GuiObject;StarterGui<BasePlayerGui|GetCoreGuiEnabled,RegisterGetCore,RegisterSetCore,SetCore,SetCoreGuiEnabled,GetCore|CoreGuiChangedSignal|ClipsDescendantsSupportsRotation:RolloutState,ProcessUserInput:bool,ResetPlayerGuiOnSpawn:bool,RtlTextSupport:RtlTextSupport,ScreenOrientation:ScreenOrientation,ShowDevelopmentGui:bool,StudioDefaultStyleSheet:StyleSheet,StudioInsertWidgetLayerCollectorAutoLinkStyleSheet:StyleSheet,VirtualCursorMode:VirtualCursorMode;BaseRemoteEvent<Instance|||;RemoteEvent<BaseRemoteEvent|FireAllClients,FireClient,FireServer|OnClientEvent,OnRemoteServerEvent,OnServerEvent|;UnreliableRemoteEvent<BaseRemoteEvent|FireAllClients,FireClient,FireServer|OnClientEvent,OnRemoteServerEvent,OnServerEvent|;BaseWrap<Instance|GetCageOffset,GetFaces,GetUVs,GetVertices,IsHSRReady,ModifyVertices|VerticesModified|CageMeshContent:Content,CageMeshId:ContentId,CageOrigin:CFrame,CageOriginWorld:CFrame,HSRAssetId:ContentId,HSRContent:Content,HSRData:SharedString,HSRMeshIdData:SharedString,ImportInProcess:bool,ImportOrigin:CFrame,ImportOriginWorld:CFrame,TemporaryCageMeshContent:Content,TemporaryCageMeshId:ContentId;WrapDeformer<BaseWrap|SetCageMeshContent,CreateEditableMeshAsync,GetDeformedCFrameAsync||;WrapLayer<BaseWrap|||AutoSkin:WrapLayerAutoSkin,BindOffset:CFrame,Color:Color3,DebugMode:WrapLayerDebugMode,Enabled:bool,MaxSize:Vector3,Offset:Vector3,Order:int,Puffiness:float,ReferenceMeshContent:Content,ReferenceMeshId:ContentId,ReferenceOrigin:CFrame,ReferenceOriginWorld:CFrame,ShrinkFactor:float,TemporaryReferenceId:ContentId,TemporaryReferenceMeshContent:Content;WrapTarget<BaseWrap|CreateTextureInCageSpaceAsync,CreateTextureInTargetSpaceAsync||Color:Color3,DebugMode:WrapTargetDebugMode,Stiffness:float;Beam<Instance|SetTextureOffset||Attachment0:Attachment,Attachment1:Attachment,Brightness:float,Color:ColorSequence,CurveSize0:float,CurveSize1:float,Enabled:bool,FaceCamera:bool,LightEmission:float,LightInfluence:float,LocalTransparencyModifier:float,Segments:int,Texture:ContentId,TextureContent:Content,TextureLength:float,TextureMode:TextureMode,TextureSpeed:float,Transparency:NumberSequence,Width0:float,Width1:float,ZOffset:float;BindableEvent<Instance|Fire|Event|;BindableFunction<Instance|Invoke||OnInvoke;BodyMover<Instance|||;BodyAngularVelocity<BodyMover|||AngularVelocity:Vector3,MaxTorque:Vector3,P:float,angularvelocity:Vector3,maxTorque:Vector3;BodyForce<BodyMover|||Force:Vector3,force:Vector3;BodyGyro<BodyMover|||CFrame:CFrame,D:float,MaxTorque:Vector3,P:float,cframe:CFrame,maxTorque:Vector3;BodyPosition<BodyMover|GetLastForce,lastForce|ReachedTarget|D:float,MaxForce:Vector3,P:float,Position:Vector3,maxForce:Vector3,position:Vector3;BodyThrust<BodyMover|||Force:Vector3,Location:Vector3,force:Vector3,location:Vector3;BodyVelocity<BodyMover|GetLastForce,lastForce||MaxForce:Vector3,P:float,Velocity:Vector3,maxForce:Vector3,velocity:Vector3;RocketPropulsion<BodyMover|Abort,Fire,fire|ReachedTarget|Active:bool,CartoonFactor:float,MaxSpeed:float,MaxThrust:float,MaxTorque:Vector3,Target:BasePart,TargetOffset:Vector3,TargetRadius:float,ThrustD:float,ThrustP:float,TurnD:float,TurnP:float;BodyPartDescription<Instance|||AssetId:int64,BodyPart:BodyPart,Color:Color3,HeadShape:string,Instance:Instance;BranchService<Instance|CompleteMerge,GetInstanceConflicts,GetMergeChanges,GetMergeResolution,GetMergeStatus,SetMergeResolution,ArchiveBranchAsync,CreateBranchAsync,GetBranchesAsync,GetDiffAsync,RestoreBranchAsync,StartMergeAsync,UpdateBranchAsync|MergeStateChanged,MergeStateCleared,MergeStatusChanged|;Breakpoint<Instance|||Condition:string,ContinueExecution:bool,Enabled:bool,Id:int,Line:int,LogMessage:string,MetaBreakpointId:int,RemoveOnHit:bool,Script:string,Valid:bool,Verified:bool;BrowserService<Instance|CloseBrowserWindow,CopyAuthCookieFromBrowserToEngine,EmitHybridEvent,ExecuteJavaScript,OpenBrowserWindow,OpenNativeOverlay,OpenWeChatAuthWindow,ReturnToJavaScript,SendCommand|AuthCookieCopiedToEngine,BrowserWindowClosed,BrowserWindowWillNavigate,JavaScriptCallback|;BugReporterService<Instance|IsAvailable|BugReportRequested|;BulkImportService<Instance|LaunchBulkImport,ShowBulkImportView|AssetImported,BulkImportFinished,BulkImportStarted|;CacheableContentProvider<Instance|||;HSRDataContentProvider<CacheableContentProvider|||;MeshContentProvider<CacheableContentProvider|GetContentMemoryData||;SlimContentProvider<CacheableContentProvider|GetContentMemoryData||;SolidModelContentProvider<CacheableContentProvider|||;WrapContentProvider<CacheableContentProvider|||;CallingService<Instance|AnswerIncomingCall,EndCall,GetCallingState,CreateCallAsync|OnCallingRemoved,OnCallingStateChange|;CalloutService<Instance|AttachCallout,DefineCallout,DetachCalloutsByDefinitionId||;CaptureService<Instance|CanCaptureVideo,CaptureScreenshot,DeleteCapture,DeleteVideoCapture,GetDeviceInfo,GetScreenshotCaptureObject,IsCapturingVideo,OnCaptureBegan,OnCaptureEnded,OnCaptureObjectShared,OnCapturePermissionsPromptFinished,OnCaptureShared,OnSavePromptFinished,OnSharePromptFinished,OnVideoCaptureShared,PreCaptureShared,PreVideoCaptureShared,PromptSaveCapturesToGallery,PromptShareCapture,RetrieveCaptures,SaveCaptureObjectToExternalStorage,SaveCaptureToExternalStorage,SaveScreenshotCapture,SaveVideoCaptureToExternalStorage,StopVideoCapture,StopVideoCaptureInternal,TakeScreenshotCaptureAsync,UploadCaptureAndPostMoment,CheckMomentTextStatusAsync,CheckUploadCaptureStatusAsync,CheckUploadCaptureStatusForSupportTicketAsync,CreatePostAsync,DeleteCapturesAsync,DeleteVideoCaptureAsync,GenerateMomentTextAsync,GetCaptureFilePathAsync,GetCaptureSizeAsync,GetCaptureStorageSizeAsync,GetCaptureUploadDataAsync,InternalCheckPlayabilityAsync,InternalGetStartPlaceIdAsync,PromptCaptureGalleryPermissionAsync,ReadCapturesFromGalleryAsync,SaveCapturesToExternalStorageAsync,StartUploadCaptureAsync,StartUploadCaptureForSupportTicketAsync,StartVideoCaptureAsync,StartVideoCaptureInternalAsync,UploadCaptureAsync,UploadPostAsync|CaptureBegan,CaptureEnded,CaptureObjectSavedInternal,CaptureSaved,CaptureSavedInternal,OnCaptureAndMetadataSignatureResult,OpenCapturePermissionsPrompt,OpenSaveCapturesPrompt,OpenShareCapturePrompt,RequestCaptureAndMetadataSignature,UserCaptureSaved,UserVideoCaptureFailed,UserVideoCaptureStartFailed,VideoCaptureInProgress|;ChangeHistoryService<Instance|FinishRecording,GetCanRedo,GetCanUndo,IsRecordingInProgress,Redo,ResetWaypoints,SetEnabled,SetWaypoint,TryBeginRecording,Undo|OnRecordingFinished,OnRecordingStarted,OnRedo,OnUndo|;ChangeHistoryStreamingService<Instance||SendCreateInstanceFromStudio,SendDeleteInstanceFromStudio,SendReparentInstanceFromStudio,SendTerrainChangeFromStudio|;CharacterAppearance<Instance|||;BodyColors<CharacterAppearance|||HeadColor:BrickColor,HeadColor3:Color3,LeftArmColor:BrickColor,LeftArmColor3:Color3,LeftLegColor:BrickColor,LeftLegColor3:Color3,RightArmColor:BrickColor,RightArmColor3:Color3,RightLegColor:BrickColor,RightLegColor3:Color3,TorsoColor:BrickColor,TorsoColor3:Color3;CharacterMesh<CharacterAppearance|||BaseTextureContent:Content,BaseTextureId:int64,BodyPart:BodyPart,MeshContent:Content,MeshId:int64,OverlayTextureContent:Content,OverlayTextureId:int64;Clothing<CharacterAppearance|||Color3:Color3,Outfit1:ContentId,Outfit1Content:Content,Outfit2:ContentId,Outfit2Content:Content;Pants<Clothing|||PantsTemplate:ContentId,PantsTemplateContent:Content;Shirt<Clothing|||ShirtTemplate:ContentId,ShirtTemplateContent:Content;ShirtGraphic<CharacterAppearance|||Color3:Color3,Graphic:ContentId,TextureContent:Content;Skin<CharacterAppearance|||SkinColor:BrickColor;Chat<Instance|Chat,ChatLocal,GetShouldUseLuaChat,InvokeChatCallback,ReconcileCommunicationAccess,RegisterChatCallback,RequestModerationModeEnabled,SetBubbleChatSettings,CanUserChatAsync,CanUsersChatAsync,FilterStringAsync,FilterStringForBroadcast,FilterStringForPlayerAsync|BubbleChatSettingsChanged,Chatted,ClientToServerFilterMessageSignalV2,ClientToServerReportUnfilteredSignal,ModerationModeEnabledChanged,PlayerChatAvailabilityStatusChanged,ReconcileCommunicationAccessCompleted,ReconcileCommunicationAccessSignal,ServerToClientUnderOver13FilteredResponseSignal,TimeoutChatAttempt|BubbleChatEnabled:bool,IsAutoMigrated:bool,LoadDefaultChat:bool,ModerationMode:string;ClickDetector<Instance||MouseActionReplicated,MouseClick,MouseHoverEnter,MouseHoverLeave,RightMouseClick,mouseClick|CursorIcon:ContentId,CursorIconContent:Content,MaxActivationDistance:float;DragDetector<ClickDetector|AddConstraintFunction,GetReferenceFrame,RestartDrag,SetDragStyleFunction,SetPermissionPolicyFunction|DragContinue,DragContinueReplicate,DragEnd,DragEndReplicate,DragStart,DragStartReplicate,RestartPhysicalDragReplicate|ActivatedCursorIcon:ContentId,ActivatedCursorIconContent:Content,ApplyAtCenterOfMass:bool,Axis:Vector3,DragFrame:CFrame,DragStyle:DragDetectorDragStyle,Enabled:bool,GamepadModeSwitchKeyCode:KeyCode,KeyboardModeSwitchKeyCode:KeyCode,MaxDragAngle:float,MaxDragTranslation:Vector3,MaxForce:float,MaxTorque:float,MinDragAngle:float,MinDragTranslation:Vector3,Orientation:Vector3,PermissionPolicy:DragDetectorPermissionPolicy,PhysicalDragClickedPart:Instance,PhysicalDragHitPoint:Vector3,PhysicalDragIsInVR:bool,PhysicalDragTargetFrame:CFrame,ReferenceInstance:Instance,ResponseStyle:DragDetectorResponseStyle,Responsiveness:float,RunLocally:bool,SecondaryAxis:Vector3,TrackballRadialPullFactor:float,TrackballRollFactor:float,VRSwitchKeyCode:KeyCode,WorldAxis:Vector3,WorldSecondaryAxis:Vector3;ClientStorageService<Instance|Clear,GetItem,RemoveItem,SetItem||;CloudCRUDService<Instance|||;CloudExecutionService<Instance|||;Clouds<Instance|||Color:Color3,Cover:float,Density:float,Enabled:bool;ClusterPacketCache<Instance|||;Collaborator<Instance|||CFrame:CFrame,CollaboratorColor:int,CollaboratorColor3:Color3,CurDocGUID:string,CurScriptLineNumber:int,IsIdle:bool,Status:CollaboratorStatus,UserId:int64,Username:string;CollaboratorsService<Instance|GetCollaboratorsList,GetSelectionHighlightsEnabled,MultiGetCanCollaborate,RequestFlyToCollaborator,ToggleSelectionHighlights,ToggleTeamCreate|CollaboratorIdleUpdate,CollaboratorInstanceCreatedSignal,CollaboratorInstanceDestroyedSignal,CollaboratorStatusUpdateRequestedSignal,CollaboratorStatusUpdatedSignal,MultiGetCanCollaborateRetrieved,ServerMultiGetCanCollaborateRequested,ToggleSelectionHighlightsSignal|;CollectionService<Instance|AddTag,CreateCollection,GetAllTags,GetCollection,GetInstanceAddedSignal,GetInstanceRemovedSignal,GetTagAddedSignal,GetTagRemovedSignal,GetTagged,GetTags,HasTag,RemoveTag|ItemAdded,ItemRemoved,TagAdded,TagRemoved|;CommerceService<Instance|PromptCommerceProductPurchase,PromptRealWorldCommerceBrowser,SignalPromptCommerceProductPurchaseFinished,GetCommerceProductInfoAsync,PrepareCommerceProductPurchase,UserEligibleForRealWorldCommerceAsync|BenefitStatusReceived,FetchReceipt,InExperienceBrowserRequested,PromptCommerceProductPurchaseFinished,PromptCommerceProductPurchaseRequested,PurchaseBrowserClosed|;CompositeValueCurve<Instance|GetComponentCurves,GetValueAtTime||CurveType:CompositeValueCurveType;ConfigService<Instance|ClearTestingValue,SetTestingValue,GetConfigAsync,GetConfigForPlayerAsync||;Configuration<Instance|||;ConfigureServerService<Instance|||;ConnectivityService<Instance|IsNetworkStateAvailable||NetworkStatus:NetworkStatus;Constraint<Instance|GetDebugAppliedForce,GetDebugAppliedTorque||Active:bool,Attachment0:Attachment,Attachment1:Attachment,Color:BrickColor,Enabled:bool,Visible:bool;AlignOrientation<Constraint|||AlignType:AlignType,CFrame:CFrame,LookAtPosition:Vector3,MaxAngularVelocity:float,MaxTorque:float,Mode:OrientationAlignmentMode,PrimaryAxis:Vector3,PrimaryAxisOnly:bool,ReactionTorqueEnabled:bool,Responsiveness:float,RigidityEnabled:bool,SecondaryAxis:Vector3;AlignPosition<Constraint|||ApplyAtCenterOfMass:bool,ForceLimitMode:ForceLimitMode,ForceRelativeTo:ActuatorRelativeTo,MaxAxesForce:Vector3,MaxForce:float,MaxVelocity:float,Mode:PositionAlignmentMode,Position:Vector3,ReactionForceEnabled:bool,Responsiveness:float,RigidityEnabled:bool;AngularVelocity<Constraint|||AngularVelocity:Vector3,MaxTorque:float,ReactionTorqueEnabled:bool,RelativeTo:ActuatorRelativeTo;AnimationConstraint<Constraint|||AngularDamping:float,AngularStrength:float,C0:CFrame,C1:CFrame,EnableSkinning:bool,IsKinematic:bool,LinearDamping:float,LinearStrength:float,MaxForce:float,MaxTorque:float,Part0:BasePart,Part1:BasePart,Transform:CFrame;BallSocketConstraint<Constraint|||EnableSkinning:bool,LimitsEnabled:bool,MaxFrictionTorque:float,MaxFrictionTorqueXml:float,Radius:float,Restitution:float,TwistLimitsEnabled:bool,TwistLowerAngle:float,TwistUpperAngle:float,UpperAngle:float;HingeConstraint<Constraint|||ActuatorType:ActuatorType,AngularResponsiveness:float,AngularSpeed:float,AngularVelocity:float,CurrentAngle:float,LimitsEnabled:bool,LowerAngle:float,MotorMaxAcceleration:float,MotorMaxTorque:float,Radius:float,Restitution:float,ServoMaxTorque:float,SoftlockServoUponReachingTarget:bool,TargetAngle:float,UpperAngle:float;LineForce<Constraint|||ApplyAtCenterOfMass:bool,InverseSquareLaw:bool,Magnitude:float,MaxForce:float,ReactionForceEnabled:bool;LinearVelocity<Constraint|||ForceLimitMode:ForceLimitMode,ForceLimitsEnabled:bool,LineDirection:Vector3,LineVelocity:float,MaxAxesForce:Vector3,MaxForce:float,MaxPlanarAxesForce:Vector2,PlaneVelocity:Vector2,PrimaryTangentAxis:Vector3,ReactionForceEnabled:bool,RelativeTo:ActuatorRelativeTo,SecondaryTangentAxis:Vector3,VectorVelocity:Vector3,VelocityConstraintMode:VelocityConstraintMode;PlaneConstraint<Constraint|||;Plane<PlaneConstraint|||;RigidConstraint<Constraint|||EnableSkinning:bool;RodConstraint<Constraint|||CurrentDistance:float,Length:float,LimitAngle0:float,LimitAngle1:float,LimitsEnabled:bool,Thickness:float;RopeConstraint<Constraint|||CurrentDistance:float,Length:float,Restitution:float,Thickness:float,WinchEnabled:bool,WinchForce:float,WinchResponsiveness:float,WinchSpeed:float,WinchTarget:float;SlidingBallConstraint<Constraint|||ActuatorType:ActuatorType,CurrentPosition:float,LimitsEnabled:bool,LinearResponsiveness:float,LowerLimit:float,MotorMaxAcceleration:float,MotorMaxForce:float,Restitution:float,ServoMaxForce:float,Size:float,SoftlockServoUponReachingTarget:bool,Speed:float,TargetPosition:float,UpperLimit:float,Velocity:float;CylindricalConstraint<SlidingBallConstraint|||AngularActuatorType:ActuatorType,AngularLimitsEnabled:bool,AngularResponsiveness:float,AngularRestitution:float,AngularSpeed:float,AngularVelocity:float,CurrentAngle:float,InclinationAngle:float,LowerAngle:float,MotorMaxAngularAcceleration:float,MotorMaxTorque:float,RotationAxisVisible:bool,ServoMaxTorque:float,SoftlockAngularServoUponReachingTarget:bool,TargetAngle:float,UpperAngle:float,WorldRotationAxis:Vector3;PrismaticConstraint<SlidingBallConstraint|||;SpringConstraint<Constraint|||Coils:float,CurrentLength:float,Damping:float,FreeLength:float,LimitsEnabled:bool,MaxForce:float,MaxLength:float,MinLength:float,Radius:float,Stiffness:float,Thickness:float;Torque<Constraint|||RelativeTo:ActuatorRelativeTo,Torque:Vector3;TorsionSpringConstraint<Constraint|||Coils:float,CurrentAngle:float,Damping:float,LimitEnabled:bool,LimitsEnabled:bool,MaxAngle:float,MaxTorque:float,Radius:float,Restitution:float,Stiffness:float;UniversalConstraint<Constraint|||LimitsEnabled:bool,MaxAngle:float,Radius:float,Restitution:float;VectorForce<Constraint|||ApplyAtCenterOfMass:bool,Force:Vector3,RelativeTo:ActuatorRelativeTo;ContentProvider<Instance|GetAssetFetchStatus,GetAssetFetchStatusChangedSignal,GetDependencyContentIds,GetDetailedFailedRequests,GetFailedRequests,ListEncryptedAssets,Preload,RegisterDefaultEncryptionKey,RegisterDefaultSessionKey,RegisterEncryptedAsset,RegisterSessionEncryptedAsset,SetBaseUrl,UnregisterDefaultEncryptionKey,UnregisterEncryptedAsset,PreloadAsync|AssetFetchFailed|BaseUrl:string,RequestQueueSize:int;ContextActionService<Instance|BindAction,BindActionAtPriority,BindActionToInputTypes,BindActivate,BindCoreAction,BindCoreActionAtPriority,BindCoreActivate,CallFunction,FireActionButtonFoundSignal,GetAllBoundActionInfo,GetAllBoundCoreActionInfo,GetBoundActionInfo,GetBoundCoreActionInfo,GetCurrentLocalToolIcon,GetInputContexts,GetInputSchemaKeyCodeTree,SetDescription,SetImage,SetPosition,SetTitle,UnbindAction,UnbindActivate,UnbindAllActions,UnbindCoreAction,UnbindCoreActivate,GetButton|BoundActionAdded,BoundActionChanged,BoundActionRemoved,GetActionButtonEvent,InputContextsChanged,LocalToolEquipped,LocalToolUnequipped|;ControlState<Instance|AddBoolField,AddCFrameField,AddInstanceField,AddIntField,AddNumberField,AddUnitVector3Field,AddVector2Field,AddVector3Field,GetChangedState,GetReplicationWeight,GetState,SetField,UpdateFields|OnStateChanged|Owner:Player,StateSchema:BinaryString;Controller<Instance|BindButton,GetButton,UnbindButton,bindButton,getButton|ButtonChanged|;HumanoidController<Controller|||;SkateboardController<Controller||AxisChanged|Steer:float,Throttle:float;VehicleController<Controller|||;ControllerBase<Instance|||Active:bool,BalanceRigidityEnabled:bool,MoveSpeedFactor:float;AirController<ControllerBase|||BalanceMaxTorque:float,BalanceSpeed:float,LinearImpulse:Vector3,MaintainAngularMomentum:bool,MaintainLinearMomentum:bool,MoveMaxForce:float,TurnMaxTorque:float,TurnSpeedFactor:float;ClimbController<ControllerBase|||AccelerationTime:float,BalanceMaxTorque:float,BalanceSpeed:float,MoveMaxForce:float;GroundController<ControllerBase|||AccelerationLean:float,AccelerationTime:float,BalanceMaxTorque:float,BalanceSpeed:float,DecelerationTime:float,Friction:float,FrictionWeight:float,GroundOffset:float,StandForce:float,StandSpeed:float,TurnSpeedFactor:float;SwimController<ControllerBase|||AccelerationTime:float,PitchMaxTorque:float,PitchSpeedFactor:float,RollMaxTorque:float,RollSpeedFactor:float;ControllerManager<Instance|||ActiveController:ControllerBase,BaseMoveSpeed:float,BaseTurnSpeed:float,ClimbSensor:ControllerSensor,FacingDirection:Vector3,GroundSensor:ControllerSensor,MovingDirection:Vector3,RootPart:BasePart,UpDirection:Vector3;ControllerService<Instance|||;CookiesService<Instance|||;CoreGuiConfiguration<Instance|||CapturesViewConfiguration:CapturesViewConfiguration,PlayerListConfiguration:PlayerListConfiguration,SelfViewConfiguration:SelfViewConfiguration;CorePackages<Instance|||;CoreScriptDebuggingManagerHelper<Instance|||;CoreScriptSyncService<Instance|GetScriptFilePath||;CreationDBService<Instance|||;CreatorStoreService<Instance|GetAssetInfoAsync,GetCreatorStoreProductInfoAsync,PerformCreatorStorePurchase||;CrossDMScriptChangeListener<Instance|IsWatchingScriptLine,StartWatchingScriptLine|GuidLineContentsChanged,GuidNameChanged|;CustomEvent<Instance|GetAttachedReceivers,SetValue|ReceiverConnected,ReceiverDisconnected|PersistedCurrentValue:float;CustomEventReceiver<Instance|GetCurrentValue|EventConnected,EventDisconnected,SourceValueChanged|Source:Instance;CustomLog<Instance|Close,GetLogPath,Open,WriteAppend||;DataModelMesh<Instance|||Offset:Vector3,Scale:Vector3,VertexColor:Vector3;BevelMesh<DataModelMesh|||Bevel:float,Bulge:float;BlockMesh<BevelMesh|||;CylinderMesh<BevelMesh|||;FileMesh<DataModelMesh|||MeshContent:Content,MeshId:ContentId,TextureContent:Content,TextureId:ContentId;SpecialMesh<FileMesh|||MeshType:MeshType;DataModelSession<Instance||CurrentDataModelTypeAboutToChange,CurrentDataModelTypeChanged|CurrentDataModelType:StudioDataModelType,SessionId:string;DataStoreGetOptions<Instance|||UseCache:bool;DataStoreIncrementOptions<Instance|GetMetadata,SetMetadata||;DataStoreInfo<Instance|||CreatedTime:int64,DataStoreName:string,UpdatedTime:int64;DataStoreKey<Instance|||KeyName:string;DataStoreKeyInfo<Instance|GetMetadata,GetUserIds||CreatedTime:int64,UpdatedTime:int64,Version:string;DataStoreObjectVersionInfo<Instance|||CreatedTime:int64,IsDeleted:bool,Version:string;DataStoreOptions<Instance|SetExperimentalFeatures||AllScopes:bool;DataStoreService<Instance|GetDataStore,GetGlobalDataStore,GetOrderedDataStore,GetRequestBudgetForRequestType,SetRateLimitForRequestType,ListDataStoresAsync||AutomaticRetry:bool,LegacyNamingScheme:bool;DataStoreSetOptions<Instance|GetMetadata,SetMetadata||;Debris<Instance|AddItem,SetLegacyMaxItems,addItem||MaxItems:int;DebugSettings<Instance|||DataModel:int,InstanceCount:int,IsScriptStackTracingEnabled:bool,JobCount:int,PlayerCount:int,ReportSoundWarnings:bool,RobloxVersion:string,TickCountPreciseOverride:TickCountSampleMethod;DebuggablePluginWatcher<Instance|||;DebuggerBreakpoint<Instance|||Condition:string,ContinueExecution:bool,IsEnabled:bool,Line:int,LogExpression:string,isContextDependentBreakpoint:bool,line:int;DebuggerConnection<Instance|AddBreakpoint,Close,EvaluateWatch,GetFrameById,GetSource,GetThreadById,GetThreads,GetVariableById,Pause,Populate,RemoveBreakpoint,Resume,SetExceptionBreakMode,SetVariable,Step,StepIn,StepOut,UpdateSelectedFrame|BreakpointAdded,BreakpointChanged,BreakpointRemoved,Paused,Resumed|ErrorMessage:string,HasError:bool,Id:int,IsPaused:bool;LocalDebuggerConnection<DebuggerConnection|||;DebuggerConnectionManager<Instance|ConnectLocal,FocusConnection,GetAvailableConnection,GetConnectionById|ConnectionEnded,ConnectionStarted,FocusChanged|Timeout:double;DebuggerLuaResponse<Instance|GetArg||IsError:bool,IsSuccess:bool,Message:string,RequestId:int,Status:DebuggerStatus;DebuggerManager<Instance|AddDebugger,EnableDebugging,GetDebuggers,Resume,StepIn,StepOut,StepOver|DebuggerAdded,DebuggerRemoved|DebuggingEnabled:bool;DebuggerUIService<Instance|EditBreakpoint,EditWatch,IsConnectionForPlayDataModel,OpenExceptionMessagePopup,OpenScriptAtLine,Pause,RemoveScriptLineMarkers,Resume,SetCurrentThreadId,SetScriptLineMarker,SetWatchExpressions|ExpressionAdded,ExpressionsCleared|;DebuggerVariable<Instance|GetVariableByIndex,GetVariableByName||Name:string,Populated:bool,Type:string,Value:string,VariableId:int,VariablesCount:int;DebuggerWatch<Instance|||Expression:string;DeferredAssetManagerService<Instance|CancelPrefetch,GetPrefetchDownloadStatus|PrefetchDownloadStatusChanged|JoiningPlaceId:int64,JoiningUniverseId:int64,PregameLoadingScreenOnly:bool;DesignFoundationsService<Instance|ClearTokens,SetTokens||;DeviceDisplayService<Instance|AcquireWakeLock||;DeviceIdService<Instance|GetDeviceId||;Dialog<Instance|GetCurrentPlayers,SetGuiObject,SetPlayerIsUsing,SignalDialogChoiceSelected|DialogChoiceSelected|BehaviorType:DialogBehaviorType,ConversationDistance:float,GoodbyeChoiceActive:bool,GoodbyeDialog:string,InUse:bool,InitialPrompt:string,Purpose:DialogPurpose,Tone:DialogTone,TriggerDistance:float,TriggerOffset:Vector3;DialogChoice<Instance|||GoodbyeChoiceActive:bool,GoodbyeDialog:string,ResponseDialog:string,UserDialog:string;DigitsRigDescription<Instance|GetFingerControl,GetFingerTip,GetJoint,GetJointLabels,GetTposeAdjustment,SetFingerControl,SetFingerTip,SetJoint,SetTposeAdjustment||Index1:Instance,Index1TposeAdjustment:CFrame,Index2:Instance,Index2TposeAdjustment:CFrame,Index3:Instance,Index3TposeAdjustment:CFrame,IndexRange:Vector3,IndexSize:float,Middle1:Instance,Middle1TposeAdjustment:CFrame,Middle2:Instance,Middle2TposeAdjustment:CFrame,Middle3:Instance,Middle3TposeAdjustment:CFrame,MiddleRange:Vector3,MiddleSize:float,Pinky1:Instance,Pinky1TposeAdjustment:CFrame,Pinky2:Instance,Pinky2TposeAdjustment:CFrame,Pinky3:Instance,Pinky3TposeAdjustment:CFrame,PinkyRange:Vector3,PinkySize:float,Ring1:Instance,Ring1TposeAdjustment:CFrame,Ring2:Instance,Ring2TposeAdjustment:CFrame,Ring3:Instance,Ring3TposeAdjustment:CFrame,RingRange:Vector3,RingSize:float,Side:DigitsRigDescriptionSide,Thumb1:Instance,Thumb1TposeAdjustment:CFrame,Thumb2:Instance,Thumb2TposeAdjustment:CFrame,Thumb3:Instance,Thumb3TposeAdjustment:CFrame,ThumbRange:Vector3,ThumbSize:float;DisplayWakeLock<Instance|||;DraftsService<Instance|DiscardEdits,GetDraftStatus,GetEditors,RestoreScripts,ShowDiffsAgainstBase,ShowDiffsAgainstServer,ShowSourceDiffsAgainstCurrent,CommitEdits,GetDrafts,UpdateToLatestVersion|CommitStatusChanged,DraftAdded,DraftRemoved,DraftStatusChanged,EditorsListChanged,UpdateStatusChanged|;Dragger<Instance|AxisRotate,MouseDown,MouseMove,MouseUp||;DraggerService<Instance|||AlignDraggedObjects:bool,AngleSnapEnabled:bool,AngleSnapIncrement:float,AnimateHover:bool,CollisionsEnabled:bool,DraggerCoordinateSpace:DraggerCoordinateSpace,DraggerMovementMode:DraggerMovementMode,GeometrySnapColor:Color3,HoverAnimateFrequency:float,HoverLineThickness:int,HoverThickness:float,JointsEnabled:bool,LinearSnapEnabled:bool,LinearSnapIncrement:float,PartSnapEnabled:bool,PivotSnapToGeometry:bool,ShowHover:bool,ShowPivotIndicator:bool,UseBoundingBoxes:bool;EditableService<Instance|||EditableStatus:EditableStatus;EditorSourceService<Instance|||;EncodingService<Instance|Base64Decode,Base64Encode,CompressBuffer,ComputeBufferHash,ComputeStringHash,DecompressBuffer,GetDecompressedBufferSize||;EulerRotationCurve<Instance|GetAnglesAtTime,GetRotationAtTime,X,Y,Z||RotationOrder:RotationOrder;EventIngestService<Instance|SendEventDeferred,SendEventImmediately,SetRBXEvent,SetRBXEventStream||;ExampleV2Service<Instance|PrintHello|OnPolo|;ExperienceAuthService<Instance|ScopeCheckUIComplete|OpenAuthPrompt,ScopeCheckResult|;ExperienceInviteOptions<Instance|||InviteMessageId:string,InviteUser:int64,LaunchData:string,PromptMessage:string;ExperienceNotificationService<Instance|InvokeOptInPromptClosed,PromptOptIn,CanPromptOptInAsync|OptInPromptClosed,PromptOptInRequested|;ExperienceService<Instance|ExecuteCrossExperienceCall,GetFollowUserId,GetPendingJoinAttempt,GetPlaceJoinState,GetQueuePosition,LaunchExperience,LaunchExperienceFromSource,LaunchExperienceFromSourceWithCallback,RegisterForExperienceJoin,RegisterForExperienceLeave,StartCrossExperience,StopCrossExperience|OnCrossExperienceStarted,OnCrossExperienceStopped,OnNewJoinAttempt,PlaceJoinStateChanged,QueuePositionChanged|;ExperienceStateCaptureService<Instance|CanEnterCaptureMode,ResetHighlight,ToggleCaptureMode|ItemSelectedInCaptureMode|HiddenSelectionEnabled:bool,IsInBackground:bool,IsInCaptureMode:bool,SelectionMode:ExperienceStateCaptureSelectionMode;ExperienceStateRecordingService<Instance|ExitPlayback,GetCurrentPlaybackRestartFrames,GetPlaybackCurrentFrame,GetPlaybackMode,SetPlaybackFrame,SetPlaybackMode,SetPlaybackPercentage,LoadPlaybackAsync|PlaybackStatusUpdated|IsServerDataModelRecorderActive:bool;ExplorerFilter<Instance|BeginSearch,GetAutocompleter,GetErrors,GetLexemes,GetSearchResults,HasMoreResults,InstancePassesFilter,SetFilter||;ExplorerFilterAutocompleter<Instance|GetSuggestions||ReplaceRange:Vector2,RequiresOutsideContext:bool;ExplorerServiceVisibilityService<Instance|GetServiceVisibility||;Explosion<Instance||Hit|BlastPressure:float,BlastRadius:float,DestroyJointRadiusPercent:float,ExplosionType:ExplosionType,LocalTransparencyModifier:float,Position:Vector3,TimeScale:float,Visible:bool;ExternalIdentityService<Instance|CancelActiveOperation,AcquireProofAsync,GetCapabilitiesAsync||;FaceAnimatorService<Instance|GetTrackerLodController,Init,IsStarted,Start,Step,Stop|TrackerError,TrackerPrompt|AudioAnimationEnabled:bool,FaceTrackingStatusEnum:TrackerFaceTrackingStatus,FlipHeadOrientation:bool,VideoAnimationEnabled:bool;FaceControls<Instance|HasOverrideFACSData|InternalFacsOverrideChanged|ChinRaiser:float,ChinRaiserUpperLip:float,Corrugator:float,EyesLookDown:float,EyesLookLeft:float,EyesLookRight:float,EyesLookUp:float,FlatPucker:float,Funneler:float,InternalOverrideFACSData:BinaryString,JawDrop:float,JawLeft:float,JawRight:float,LeftBrowLowerer:float,LeftCheekPuff:float,LeftCheekRaiser:float,LeftDimpler:float,LeftEyeClosed:float,LeftEyeUpperLidRaiser:float,LeftInnerBrowRaiser:float,LeftLipCornerDown:float,LeftLipCornerPuller:float,LeftLipStretcher:float,LeftLowerLipDepressor:float,LeftNoseWrinkler:float,LeftOuterBrowRaiser:float,LeftUpperLipRaiser:float,LipPresser:float,LipsTogether:float,LowerLipSuck:float,MouthLeft:float,MouthRight:float,Pucker:float,RightBrowLowerer:float,RightCheekPuff:float,RightCheekRaiser:float,RightDimpler:float,RightEyeClosed:float,RightEyeUpperLidRaiser:float,RightInnerBrowRaiser:float,RightLipCornerDown:float,RightLipCornerPuller:float,RightLipStretcher:float,RightLowerLipDepressor:float,RightNoseWrinkler:float,RightOuterBrowRaiser:float,RightUpperLipRaiser:float,TongueDown:float,TongueOut:float,TongueUp:float,UpperLipSuck:float;FaceInstance<Instance|||Face:NormalId;Decal<FaceInstance|||AutoLocalize:bool,Color3:Color3,ColorMap:ContentId,ColorMapContent:Content,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,LocalTransparencyModifier:float,LocalizedTextureContent:Content,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,Rotation:float,RoughnessMap:ContentId,RoughnessMapContent:Content,Shiny:float,Specular:float,Texture:ContentId,TextureContent:Content,TexturePack:ContentId,TexturePackContent:Content,TexturePackMetadata:string,Transparency:float,UVOffset:Vector2,UVScale:Vector2,ZIndex:int;Texture<Decal|||OffsetStudsU:float,OffsetStudsV:float,StudsPerTileU:float,StudsPerTileV:float;FacialAgeEstimationService<Instance|IsAvailable,InquiryAsync||;FacialAnimationRecordingService<Instance|IsAgeRestricted,CheckOrRequestCameraPermission||BiometricDataConsent:bool;FacialAnimationStreamingServiceStats<Instance|Get,GetWithPlayerId||;FacialAnimationStreamingServiceV2<Instance|GetStats,IsAudioEnabled,IsPlaceEnabled,IsServerEnabled,IsVideoEnabled,ResolveStateForUser||ServiceState:int;FacialAnimationStreamingSubsessionStats<Instance|||;Feature<Instance|||FaceId:NormalId,InOut:InOut,LeftRight:LeftRight,TopBottom:TopBottom;Hole<Feature|||;MotorFeature<Feature|||;FeatureRestrictionManager<Instance||FeatureTimeoutAttempt,FeatureTimeoutRestored,RefreshFeatureRestrictions,ShowFeatureInterventionDetails,ShowFeatureInterventionDetailsV2,TimeoutChatAttempt,UpdateClientFeatureTimeout|;File<Instance|GetBinaryContents,GetTemporaryId||Size:int64;FileManagerService<Instance|OpenFileInWebBrowser,OpenFolder,RevealFileInFolder,ListFilesInFolderAsync||;FileSyncReplicationService<Instance||BroadcastPlayerSyncState,UpdateSyncInstances|;Fire<Instance|FastForward||Color:Color3,Enabled:bool,Heat:float,LocalTransparencyModifier:float,SecondaryColor:Color3,Size:float,TimeScale:float,heat_xml:float,size:float,size_xml:float;FlagStandService<Instance|||;FloatCurve<Instance|GetKeyAtIndex,GetKeyIndicesAtTime,GetKeys,GetValueAtTime,InsertKey,RemoveKeyAtIndex,SetKeys||Length:int,ValuesAndTimes:BinaryString;FlyweightService<Instance|||;CSGDictionaryService<FlyweightService|||;NonReplicatedCSGDictionaryService<FlyweightService|||;Folder<Instance|||IconTint:Color3,ReplicatedGuiInsertionOrder:int;GeneratedFolder<Folder|SetPrimaryPart||;ForceField<Instance|||Visible:bool;FriendService<Instance|GetPlatformFriends|FriendsUpdated,RemoteFriendEventSignal,RemoteFriendStatusSignal|;FunctionalTest<Instance|Error,Failed,Pass,Passed,Warn||AllowSleep:bool,Description:string,HasMigratedSettingsToTestService:bool,Is30FpsThrottleEnabled:bool,PhysicsEnvironmentalThrottle:bool,Timeout:double;GamePassService<Instance|PlayerHasPass||;GameSettings<Instance||VideoRecordingChangeRequest|VideoCaptureEnabled:bool;GamepadService<Instance|AutoSelectGui,DisableGamepadCursor,EnableGamepadCursor,GetGamepadCursorPosition,SetGamepadCursorPosition|GamepadThumbstick1Changed|GamepadCursorEnabled:bool;GenerationService<Instance|ConnectAsync,DisconnectAsync,ExportInstanceToGlbAsync,ExportMeshToGlbAsync,GenerateMeshAsync,GenerateModelAsync,GetVideoGenSessionAsync,GetVideoGenTriggersAsync,InternalGenerateMeshAsync,LoadGeneratedMeshAsync,LoadModelFromGlbAsync,LoadModelFromUrlAsync,SegmentMeshAsync,StartVideoGenSessionAsync,UpdateVideoGenSessionPromptAsync,UpdateVideoGenSessionTriggersAsync|ReplicateGeneration,RequestGenerationReplication|;GenericChallengeService<Instance|SignalChallengeAbandoned,SignalChallengeCompleted,SignalChallengeInvalidated,SignalChallengeLoaded,SignalChallengeRequired|ChallengeAbandonedEvent,ChallengeCompletedEvent,ChallengeInvalidatedEvent,ChallengeLoadedEvent,ChallengeRequiredEvent|;Geometry<Instance|||;GeometryService<Instance|CalculateConstraintsToPreserve,CreateBasicMeshPart,GenerateFragmentSites,TranscodeMesh,TranscodeModel,FragmentAsync,HashMeshAsync,IntersectAsync,SubtractAsync,SweepPartAsync,UnionAsync||;GetTextBoundsParams<Instance|||Font:Font,RichText:bool,Size:float,Text:string,Width:float;GlobalDataStore<Instance|OnUpdate,BatchGetAsync,GetAsync,IncrementAsync,RemoveAsync,SetAsync,UpdateAsync||;DataStore<GlobalDataStore|GetVersionAsync,GetVersionAtTimeAsync,ListKeysAsync,ListVersionsAsync,RemoveVersionAsync||;OrderedDataStore<GlobalDataStore|GetSortedAsync||;GongService<Instance|||;GroupService<Instance|PromptJoinCompleted,GetAlliesAsync,GetEnemiesAsync,GetGroupInfoAsync,GetGroupsAsync,GetRolesInGroupAsync,PromptJoinAsync|ShowJoinPrompt|;GuiBase<Instance|||;AnimatedImage<GuiBase|GetBoundTracks,Pause,Resume||Content:Content,PlaybackSpeed:float;GuiBase2d<GuiBase||SelectionChanged|AbsolutePosition:Vector2,AbsoluteRotation:float,AbsoluteSize:Vector2,ActiveQueryNames:string,AutoLocalize:bool,ClippedRect:Rect,IsNotOccluded:bool,Localize:bool,RawRect2D:Rect,ReplicatedInsertionOrder:int,RootLocalizationTable:LocalizationTable,SelectionBehaviorDown:SelectionBehavior,SelectionBehaviorLeft:SelectionBehavior,SelectionBehaviorRight:SelectionBehavior,SelectionBehaviorUp:SelectionBehavior,SelectionGroup:bool,TotalGroupScale:float;GuiObject<GuiBase2d|TweenPosition,TweenPositionInternal,TweenSize,TweenSizeAndPosition,TweenSizeAndPositionInternal,TweenSizeInternal|DragBegin,DragStopped,InputBegan,InputChanged,InputEnded,MouseEnter,MouseLeave,MouseMoved,MouseWheelBackward,MouseWheelForward,SelectionGained,SelectionLost,TouchLongPress,TouchPan,TouchPinch,TouchRotate,TouchSwipe,TouchTap|Active:bool,AnchorPoint:Vector2,AutomaticSize:AutomaticSize,BackgroundColor:BrickColor,BackgroundColor3:Color3,BackgroundTransparency:float,BorderColor:BrickColor,BorderColor3:Color3,BorderMode:BorderMode,BorderSizePixel:int,ClipsDescendants:bool,DragBeginConnectionCount:int,DragStoppedConnectionCount:int,Draggable:bool,GuiState:GuiState,InputSink:InputSink,Interactable:bool,LayoutOrder:int,MouseEnterConnectionCount:int,MouseLeaveConnectionCount:int,MouseMovedConnectionCount:int,MouseWheelBackwardConnectionCount:int,MouseWheelForwardConnectionCount:int,NextSelectionDown:GuiObject,NextSelectionLeft:GuiObject,NextSelectionRight:GuiObject,NextSelectionUp:GuiObject,Position:UDim2,Rotation:float,Selectable:bool,SelectionImageObject:GuiObject,SelectionOrder:int,SelectionRect2D:Rect,Sink:InputSink,Size:UDim2,SizeConstraint:SizeConstraint,Transparency:float,Visible:bool,ZIndex:int;CanvasGroup<GuiObject|||GroupColor3:Color3,GroupTransparency:float,ResolutionScale:float;Frame<GuiObject|||Style:FrameStyle;GuiButton<GuiObject||Activated,MouseButton1Click,MouseButton1Down,MouseButton1Up,MouseButton2Click,MouseButton2Down,MouseButton2Up,SecondaryActivated|AutoButtonColor:bool,HoverHapticEffect:HapticEffect,Modal:bool,MouseButton1ClickConnectionCount:int,MouseButton1DownConnectionCount:int,MouseButton1UpConnectionCount:int,MouseButton2ClickConnectionCount:int,MouseButton2DownConnectionCount:int,MouseButton2UpConnectionCount:int,PressHapticEffect:HapticEffect,Selected:bool,Style:ButtonStyle;ImageButton<GuiButton|SetEnableContentImageSizeChangedEvents||ContentImageSize:Vector2,HoverImage:ContentId,HoverImageContent:Content,Image:ContentId,ImageColor3:Color3,ImageContent:Content,ImageRectOffset:Vector2,ImageRectSize:Vector2,ImageTransparency:float,IsLoaded:bool,LocalizedImageContent:Content,PressedImage:ContentId,PressedImageContent:Content,ResampleMode:ResamplerMode,ScaleType:ScaleType,SliceCenter:Rect,SliceScale:float,TileSize:UDim2;TextButton<GuiButton|SetTextFromInput||Confidential:bool,ContentText:string,Font:Font,FontFace:Font,FontSize:FontSize,LineHeight:float,LocalizationMatchIdentifier:string,LocalizationMatchedSourceText:string,LocalizedText:string,MaxVisibleGraphemes:int,OpenTypeFeatures:string,OpenTypeFeaturesError:string,RichText:bool,Text:string,TextBounds:Vector2,TextColor:BrickColor,TextColor3:Color3,TextDirection:TextDirection,TextFits:bool,TextScaled:bool,TextSize:float,TextStrokeColor3:Color3,TextStrokeTransparency:float,TextTransparency:float,TextTruncate:TextTruncate,TextWrap:bool,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;GuiLabel<GuiObject|||;ImageLabel<GuiLabel|SetEnableContentImageSizeChangedEvents||ContentImageSize:Vector2,Image:ContentId,ImageColor3:Color3,ImageContent:Content,ImageRectOffset:Vector2,ImageRectSize:Vector2,ImageTransparency:float,IsLoaded:bool,LocalizedImageContent:Content,ResampleMode:ResamplerMode,ScaleType:ScaleType,SliceCenter:Rect,SliceScale:float,TileSize:UDim2;TextLabel<GuiLabel|SetTextFromInput||Confidential:bool,ContentText:string,Font:Font,FontFace:Font,FontSize:FontSize,LineHeight:float,LocalizationMatchIdentifier:string,LocalizationMatchedSourceText:string,LocalizedText:string,MaxVisibleGraphemes:int,OpenTypeFeatures:string,OpenTypeFeaturesError:string,RichText:bool,Text:string,TextBounds:Vector2,TextColor:BrickColor,TextColor3:Color3,TextDirection:TextDirection,TextFits:bool,TextScaled:bool,TextSize:float,TextStrokeColor3:Color3,TextStrokeTransparency:float,TextTransparency:float,TextTruncate:TextTruncate,TextWrap:bool,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;InputActionLabel<GuiObject|||FontFace:Font,ImageColor3:Color3,ImageTransparency:float,InputAction:InputAction,ResolvedImageContent:Content,ResolvedText:string,TextColor3:Color3,TextSize:float,TextTransparency:float,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;RelativeGui<GuiObject|||;ScrollingFrame<GuiObject|ClearInertialScrolling,GetSampledInertialVelocity,GetScrollVelocity,ResetScrollVelocity,ScrollToTop||AbsoluteCanvasSize:Vector2,AbsoluteWindowSize:Vector2,AutomaticCanvasSize:AutomaticSize,BottomImage:ContentId,BottomImageContent:Content,CanvasPosition:Vector2,CanvasSize:UDim2,DraggingScrollBar:DraggingScrollBar,ElasticBehavior:ElasticBehavior,HorizontalBarRect:Rect,HorizontalScrollBarInset:ScrollBarInset,MaxCanvasPosition:Vector2,MidImage:ContentId,MidImageContent:Content,ScrollBarImageColor3:Color3,ScrollBarImageTransparency:float,ScrollBarThickness:int,ScrollRate:float,ScrollVelocity:Vector2,ScrollingDirection:ScrollingDirection,ScrollingEnabled:bool,SmoothScroll:bool,TopImage:ContentId,TopImageContent:Content,VerticalBarRect:Rect,VerticalScrollBarInset:ScrollBarInset,VerticalScrollBarPosition:VerticalScrollBarPosition;TextBox<GuiObject|CaptureFocus,IsFocused,ReleaseFocus,ResetKeyboardMode,SetTextFromInput|FocusLost,Focused,ReturnPressedFromOnScreenKeyboard|ClearTextOnFocus:bool,Confidential:bool,ContentText:string,CursorPosition:int,Font:Font,FontFace:Font,FontSize:FontSize,HasFocus:bool,LineHeight:float,LocalizationMatchIdentifier:string,LocalizationMatchedSourceText:string,LocalizedPlaceholderText:string,ManualFocusRelease:bool,MaxVisibleGraphemes:int,MultiLine:bool,OpenTypeFeatures:string,OpenTypeFeaturesError:string,OverlayNativeInput:bool,PlaceholderColor3:Color3,PlaceholderText:string,ReturnKeyType:ReturnKeyType,RichText:bool,SelectionStart:int,ShouldEmitReturnEvents:bool,ShouldEmitTabEvents:bool,ShouldEmitUpAndDownArrowEvents:bool,ShowNativeInput:bool,Text:string,TextBounds:Vector2,TextColor:BrickColor,TextColor3:Color3,TextDirection:TextDirection,TextEditable:bool,TextFits:bool,TextInputType:TextInputType,TextScaled:bool,TextSize:float,TextStrokeColor3:Color3,TextStrokeTransparency:float,TextTransparency:float,TextTruncate:TextTruncate,TextWrap:bool,TextWrapped:bool,TextXAlignment:TextXAlignment,TextYAlignment:TextYAlignment;TextChannelWindow<GuiObject|||FontFace:Font,IsRendering:bool,Target:TextChannel,UseDefaultFont:bool;VideoDisplay<GuiObject|GetConnectedWires,GetInputPins,GetOutputPins|WiringChanged|ResampleMode:ResamplerMode,ScaleType:ScaleType,TileSize:UDim2,VideoColor3:Color3,VideoRectOffset:Vector2,VideoRectSize:Vector2,VideoTransparency:float;VideoFrame<GuiObject|Pause,Play,SetStudioPreview|DidLoop,Ended,Loaded,Paused,Played,PlayingUpdatedFromServer,TimePositionUpdatedFromServer|InternalVideoUsage:InternalVideoUsage,IsLoaded:bool,Looped:bool,MaximumResolution:VideoSampleSize,Playing:bool,PlayingReplicating:bool,Resolution:Vector2,RollOffMaxDistance:float,RollOffMinDistance:float,RollOffMode:RollOffMode,TimeLength:double,TimePosition:double,TimePositionReplicating:double,Video:ContentId,VideoContent:Content,Volume:float;ViewportFrame<GuiObject|CaptureSnapshotAsync||Ambient:Color3,CameraCFrame:CFrame,CameraFieldOfView:float,CurrentCamera:Camera,ImageColor3:Color3,ImageTransparency:float,IsMirrored:bool,LightColor:Color3,LightDirection:Vector3;LayerCollector<GuiBase2d|GetGuiObjectsAtPosition,GetLayoutNodeTree||Enabled:bool,ResetOnSpawn:bool,TabKeyboardNavigation:bool,ZIndexBehavior:ZIndexBehavior;BillboardGui<LayerCollector|GetScreenSpaceBounds||Active:bool,Adornee:Instance,AlwaysOnTop:bool,Brightness:float,ClipsDescendants:bool,CurrentDistance:float,DistanceLowerLimit:float,DistanceStep:float,DistanceUpperLimit:float,ExtentsOffset:Vector3,ExtentsOffsetWorldSpace:Vector3,LightInfluence:float,MaxDistance:float,PlayerToHideFrom:Instance,Size:UDim2,SizeOffset:Vector2,StudsOffset:Vector3,StudsOffsetWorldSpace:Vector3;PluginGui<LayerCollector|BindToClose,GetRelativeMousePosition,OverrideStudioAction|InputBegan,InputChanged,InputEnded,MouseEnter,MouseLeave,PluginDragDropped,PluginDragEntered,PluginDragLeft,PluginDragMoved,PointerAction,WindowFocusReleased,WindowFocused|Plugin:Plugin,Title:string;DockWidgetPluginGui<PluginGui|RequestRaise||HostWidgetWasRestored:bool;QWidgetPluginGui<PluginGui|||;ScreenGui<LayerCollector|||ClipToDeviceSafeArea:bool,DisplayOrder:int,IgnoreGuiInset:bool,IgnoresTitleBarReservation:bool,OnTopOfCoreBlur:bool,SafeAreaCompatibility:SafeAreaCompatibility,ScreenInsets:ScreenInsets;GuiMain<ScreenGui|||;SurfaceGuiBase<LayerCollector|||Active:bool,Adornee:Instance,Face:NormalId;AdGui<SurfaceGuiBase|GetSingleReportAdInfo,HandleLuaUIEvent,forwardStateToLuaUI|AdEvent,ReportIsSubscribedToVideoCompletion,adGuiStateChanged|AdShape:AdShape,EnableVideoAds:bool,FallbackImage:ContentId,FallbackImageContent:Content,Status:AdUnitStatus,OnAdEvent;SurfaceGui<SurfaceGuiBase|||AlwaysOnTop:bool,Brightness:float,CanvasSize:Vector2,ClipsDescendants:bool,HorizontalCurvature:float,LightInfluence:float,MaxDistance:float,PixelsPerStud:float,Shape:SurfaceGuiShape,SizingMode:SurfaceGuiSizingMode,ToolPunchThroughDistance:float,ZOffset:float;GuiBase3d<GuiBase|||Color:BrickColor,Color3:Color3,Transparency:float,Visible:bool;FloorWire<GuiBase3d|||CycleOffset:float,From:BasePart,StudsBetweenTextures:float,Texture:ContentId,TextureSize:Vector2,To:BasePart,Velocity:float,WireRadius:float;InstanceAdornment<GuiBase3d|||Adornee:Instance;SelectionBox<InstanceAdornment|||LineThickness:float,StudioSelectionBox:bool,SurfaceColor:BrickColor,SurfaceColor3:Color3,SurfaceTransparency:float;PVAdornment<GuiBase3d|||Adornee:PVInstance;HandleAdornment<PVAdornment||MouseButton1Down,MouseButton1Up,MouseEnter,MouseLeave|AdornCullingMode:AdornCullingMode,AlwaysOnTop:bool,CFrame:CFrame,GizmoReference:Instance,SizeRelativeOffset:Vector3,ZIndex:int;BoxHandleAdornment<HandleAdornment|||Shading:AdornShading,Size:Vector3;ConeHandleAdornment<HandleAdornment|||Height:float,Hollow:bool,Radius:float,Shading:AdornShading;CylinderHandleAdornment<HandleAdornment|||Angle:float,Height:float,InnerRadius:float,Radius:float,Shading:AdornShading;ImageHandleAdornment<HandleAdornment|||Image:ContentId,ImageContent:Content,Size:Vector2;LineHandleAdornment<HandleAdornment|||Length:float,Thickness:float;PyramidHandleAdornment<HandleAdornment|||Height:float,Shading:AdornShading,Sides:int,Size:float;SphereHandleAdornment<HandleAdornment|||Radius:float,Shading:AdornShading;WireframeHandleAdornment<HandleAdornment|AddLine,AddLines,AddPath,AddText,Clear||Scale:Vector3,Thickness:float;ParabolaAdornment<PVAdornment|FindPartOnParabola||A:float,B:float,C:float,Range:float,Thickness:float;SelectionSphere<PVAdornment|||SurfaceColor:BrickColor,SurfaceColor3:Color3,SurfaceTransparency:float;PartAdornment<GuiBase3d|||Adornee:BasePart;HandlesBase<PartAdornment|||;ArcHandles<HandlesBase||MouseButton1Down,MouseButton1Up,MouseDrag,MouseEnter,MouseLeave|Axes:Axes,MouseButton1DownConnectionCount:int,MouseButton1UpConnectionCount:int,MouseDragConnectionCount:int,MouseEnterConnectionCount:int,MouseLeaveConnectionCount:int;Handles<HandlesBase||MouseButton1Down,MouseButton1Up,MouseDrag,MouseEnter,MouseLeave|Faces:Faces,MouseButton1DownConnectionCount:int,MouseButton1UpConnectionCount:int,MouseDragConnectionCount:int,MouseEnterConnectionCount:int,MouseLeaveConnectionCount:int,Style:HandlesStyle;SurfaceSelection<PartAdornment|||TargetSurface:NormalId;SelectionLasso<GuiBase3d|||Humanoid:Humanoid;SelectionPartLasso<SelectionLasso|||Part:BasePart;SelectionPointLasso<SelectionLasso|||Point:Vector3;Path2D<GuiBase|GetBoundingRect,GetControlPoint,GetControlPoints,GetLength,GetMaxControlPoints,GetPositionOnCurve,GetPositionOnCurveArcLength,GetSegmentCount,GetTangentOnCurve,GetTangentOnCurveArcLength,InsertControlPoint,RemoveControlPoint,SetControlPoints,UpdateControlPoint|ControlPointChanged|Closed:bool,Color3:Color3,PropertiesSerialize:BinaryString,SelectedControlPoint:int,SelectedControlPointData:Path2DControlPoint,Thickness:float,Transparency:float,Visible:bool,ZIndex:int;GuiService<Instance|AddCenterDialog,AddKey,AddSelectionParent,AddSelectionTuple,AddSpecialKey,BroadcastNotification,ClearError,CloseInspectMenu,CloseStatsBasedOnInputString,DismissNotification,ForceTenFootInterface,GetAutoUIScaleHundredths,GetBrickCount,GetClosestDialogToPosition,GetClosestVisibleDialogToPosition,GetEffectiveUIScaleHundredths,GetEmotesMenuOpen,GetErrorCode,GetErrorDetails,GetErrorMessage,GetErrorType,GetGameplayPausedNotificationEnabled,GetGuiInset,GetGuiIsVisible,GetHardwareSafeViewport,GetInsetArea,GetInspectMenuEnabled,GetNotificationTypeList,GetRawScreenScale,GetResolutionScale,GetSafeZoneOffsets,GetUiMessage,InspectPlayerFromHumanoidDescription,InspectPlayerFromUserId,InspectPlayerFromUserIdWithCtx,IsMemoryTrackerEnabled,IsTenFootInterface,OnNotificationDisplayed,OnNotificationInteraction,OpenBrowserWindow,OpenNativeOverlay,RemoveCenterDialog,RemoveKey,RemoveSelectionGroup,RemoveSpecialKey,Select,SendNotification,SendUIOcclusionMetricsForQueryRegion,SetEmotesMenuOpen,SetGameplayPausedNotificationEnabled,SetGlobalGuiInset,SetHardwareSafeAreaInsets,SetInspectMenuEnabled,SetMenuIsOpen,SetPurchasePromptIsShown,SetSafeZoneOffsets,SetTopbarInset,SetUIScaleMultiplier,SetUiMessage,ShowStatsBasedOnInputString,ToggleFullscreen,ToggleGuiIsVisibleForCaptures,ToggleGuiIsVisibleIfAllowed,GetScreenResolution|BrowserWindowClosed,CloseInspectMenuRequest,CoreGuiRenderOverflowed,EmotesMenuOpenChanged,ErrorMessageChanged,GuiVisibilityChangedSignal,InspectMenuEnabledChangedSignal,InspectPlayerFromHumanoidDescriptionRequest,InspectPlayerFromUserIdWithCtxRequest,KeyPressed,MenuClosed,MenuOpened,NativeClose,NetworkPausedEnabledChanged,Open9SliceEditor,OpenStyleEditor,PurchasePromptShown,SafeZoneOffsetsChanged,ScrollStateChanged,ShowLeaveConfirmation,SpecialKeyPressed,UiMessageChanged|AutoSelectGuiEnabled:bool,CoreEffectFolder:Folder,CoreGuiFolder:Folder,CoreGuiNavigationEnabled:bool,DisplayScalingMode:DisplayScalingMode,GuiNavigationEnabled:bool,IsModalDialog:bool,IsWindows:bool,MenuIsOpen:bool,PreferredTextSize:PreferredTextSize,PreferredTransparency:float,ReducedMotionEnabled:bool,SelectedCoreObject:GuiObject,SelectedObject:GuiObject,TopbarInset:Rect,TouchControlsEnabled:bool,ViewportDisplaySize:DisplaySize,ViewportSizeInMM:Vector2,SendCoreUiNotification;GuidRegistryService<Instance|||;HapticEffect<Instance|Play,SetWaveformKeys,Stop|Ended|Looped:bool,Position:Vector3,Radius:float,Type:HapticEffectType,WaveformData:BinaryString;HapticService<Instance|GetMotor,IsMotorSupported,IsVibrationSupported,SetMotor||;HarmonyService<Instance|||;HeapProfilerService<Instance|ClientRequestDataAsync,ServerRequestDataAsync|OnNewData,RequestData|;HeatmapQueryService<Instance|||;HeatmapService<Instance|||;HeightmapImporterService<Instance|CancelImportHeightmap,IsValidColormap,IsValidHeightmap,SetImportHeightmapPaused,GetHeightmapPreviewAsync,ImportHeightmap|ColormapHasUnknownPixels,ProgressUpdate|;HiddenSurfaceRemovalAsset<Instance|||HSRData:BinaryString,HSRMeshIdData:BinaryString;Highlight<Instance|||Adornee:Instance,DepthMode:HighlightDepthMode,Enabled:bool,FillColor:Color3,FillTransparency:float,LineThickness:int,OutlineColor:Color3,OutlineTransparency:float,ReservedId:ReservedHighlightId;Hopper<Instance|||;HttpRbxApiService<Instance|GetDocumentationUrl,GetAsync,GetAsyncFullUrl,PostAsync,PostAsyncFullUrl,RequestAsync,RequestLimitedAsync||;HttpRequest<Instance|Cancel,Start||;HttpService<Instance|CreateWebStreamClient,CreateWebStreamClientInternal,GenerateGUID,GetHttpEnabled,GetSecret,GetUserAgent,JSONDecode,JSONEncode,RequestInternal,SetHttpEnabled,UrlEncode,GetAsync,JSONDecodeAsync,JSONEncodeAsync,PostAsync,RequestAccessTokenScopesAsync,RequestAsync||HttpEnabled:bool;Humanoid<Instance|AddAccessory,AddCustomStatus,AddStatus,BuildRigFromAttachments,ChangeState,ComputeOriginalSizeForPart,ComputeR15BodyBoundingBox,EquipTool,GetAccessories,GetAccessoryHandleScale,GetAppliedDescription,GetBodyPartR15,GetLimb,GetMoveVelocity,GetPlayingAnimationTracks,GetRelativeVelocityAtFloor,GetState,GetStateEnabled,GetStatuses,HasCustomStatus,HasStatus,LoadAnimation,Move,MoveTo,RemoveAccessories,RemoveCustomStatus,RemoveStatus,ReplaceBodyPartR15,SetClickToWalkEnabled,SetStateEnabled,TakeDamage,UnequipTools,loadAnimation,takeDamage,CacheDefaults,ApplyAvatarRules,ApplyDescription,ApplyDescriptionAsync,ApplyDescriptionReset,ApplyDescriptionResetAsync,PlayEmote,PlayEmoteAndGetAnimTrackById,PlayEmoteAsync|AnimationPlayed,ApplyDescriptionFinished,Climbing,ClusterCompositionFinished,CustomStatusAdded,CustomStatusRemoved,Died,EmoteTriggered,FallingDown,FreeFalling,GettingUp,HealthChanged,Jumping,MoveToFinished,PlatformStanding,Ragdoll,Running,Seated,ServerApplyDescription,ServerBreakJoints,ServerEquipTool,ServerResetCharacter,StateChanged,StateEnabledChanged,StatusAdded,StatusRemoved,Strafing,Swimming,Touched|AutoJumpEnabled:bool,AutoRotate:bool,AutomaticScalingEnabled:bool,BreakJointsOnDeath:bool,CameraMaxDistance:float,CameraMinDistance:float,CameraMode:CameraMode,CameraOffset:Vector3,CollisionType:HumanoidCollisionType,DisplayDistanceType:HumanoidDisplayDistanceType,DisplayName:string,EvaluateStateMachine:bool,FinishedState:bool,FloorMaterial:Material,Health:float,HealthDisplayDistance:float,HealthDisplayType:HumanoidHealthDisplayType,Health_XML:float,HipHeight:float,InternalBodyScale:Vector3,InternalDisplayName:string,InternalHeadScale:float,InternalOriginalHipHeight:float,Jump:bool,JumpHeight:float,JumpPower:float,JumpReplicate:bool,LeftLeg:BasePart,MaxHealth:float,MaxSlopeAngle:float,MoveDirection:Vector3,MoveDirectionInternal:Vector3,NameDisplayDistance:float,NameOcclusion:NameOcclusion,NetworkHumanoidState:HumanoidStateType,NoFloorTimerState:float,OverrideDefaultCollisions:bool,PlatformStand:bool,RequiresNeck:bool,RigType:HumanoidRigType,RightLeg:BasePart,RootPart:BasePart,RotationType:RotationType,SeatPart:BasePart,Sit:bool,Strafe:bool,TargetPoint:Vector3,TimerState:float,Torso:BasePart,UseJumpPower:bool,WalkAngleError:float,WalkDirection:Vector3,WalkSpeed:float,WalkToPart:BasePart,WalkToPoint:Vector3,maxHealth:float;HumanoidDescription<Instance|AddEmote,GetAccessories,GetEmotes,GetEquippedEmotes,RemoveEmote,SetAccessories,SetEmotes,SetEquippedEmotes|EmotesChanged,EquippedEmotesChanged|AccessoryBlob:string,BackAccessory:string,BodyTypeScale:float,ClimbAnimation:int64,DepthScale:float,EmotesDataInternal:string,EquippedEmotesDataInternal:string,Face:int64,FaceAccessory:string,FallAnimation:int64,FrontAccessory:string,GraphicTShirt:int64,HairAccessory:string,HatAccessory:string,Head:int64,HeadColor:Color3,HeadScale:float,HeightScale:float,IdleAnimation:int64,JumpAnimation:int64,LeftArm:int64,LeftArmColor:Color3,LeftLeg:int64,LeftLegColor:Color3,MoodAnimation:int64,NeckAccessory:string,NumberEmotesLoaded:int,Pants:int64,ProportionScale:float,ResetIncludesBodyParts:bool,RightArm:int64,RightArmColor:Color3,RightLeg:int64,RightLegColor:Color3,RunAnimation:int64,Shirt:int64,ShouldersAccessory:string,StaticFacialAnimation:bool,SwimAnimation:int64,Torso:int64,TorsoColor:Color3,UseAvatarSettings:bool,WaistAccessory:string,WalkAnimation:int64,WidthScale:float;HumanoidRigDescription<Instance|AutoRig,GetContainedJointLabels,GetJoint,GetJointFromName,GetJointLabels,GetJointNames,GetJointRangeMax,GetJointRangeMin,GetJointSize,GetR15JointLabels,GetR15JointNames,GetR6JointLabels,GetR6JointNames,GetTposeAdjustment,SetJoint,SetJointRangeMax,SetJointRangeMin,SetJointSize,SetTposeAdjustment,ShowVolumes||Chest:Instance,ChestRangeMax:Vector3,ChestRangeMin:Vector3,ChestSize:float,ChestTposeAdjustment:CFrame,HeadBase:Instance,HeadBaseRangeMax:Vector3,HeadBaseRangeMin:Vector3,HeadBaseSize:float,HeadBaseTposeAdjustment:CFrame,LeftAnkle:Instance,LeftAnkleRangeMax:Vector3,LeftAnkleRangeMin:Vector3,LeftAnkleSize:float,LeftAnkleTposeAdjustment:CFrame,LeftClavicle:Instance,LeftClavicleRangeMax:Vector3,LeftClavicleRangeMin:Vector3,LeftClavicleSize:float,LeftClavicleTposeAdjustment:CFrame,LeftElbow:Instance,LeftElbowRangeMax:Vector3,LeftElbowRangeMin:Vector3,LeftElbowSize:float,LeftElbowTposeAdjustment:CFrame,LeftHip:Instance,LeftHipRangeMax:Vector3,LeftHipRangeMin:Vector3,LeftHipSize:float,LeftHipTposeAdjustment:CFrame,LeftKnee:Instance,LeftKneeRangeMax:Vector3,LeftKneeRangeMin:Vector3,LeftKneeSize:float,LeftKneeTposeAdjustment:CFrame,LeftShoulder:Instance,LeftShoulderRangeMax:Vector3,LeftShoulderRangeMin:Vector3,LeftShoulderSize:float,LeftShoulderTposeAdjustment:CFrame,LeftToeBase:Instance,LeftToeBaseRangeMax:Vector3,LeftToeBaseRangeMin:Vector3,LeftToeBaseSize:float,LeftToeBaseTposeAdjustment:CFrame,LeftWrist:Instance,LeftWristRangeMax:Vector3,LeftWristRangeMin:Vector3,LeftWristSize:float,LeftWristTposeAdjustment:CFrame,Neck:Instance,NeckRangeMax:Vector3,NeckRangeMin:Vector3,NeckSize:float,NeckTposeAdjustment:CFrame,OriginOffset:CFrame,RightAnkle:Instance,RightAnkleRangeMax:Vector3,RightAnkleRangeMin:Vector3,RightAnkleSize:float,RightAnkleTposeAdjustment:CFrame,RightClavicle:Instance,RightClavicleRangeMax:Vector3,RightClavicleRangeMin:Vector3,RightClavicleSize:float,RightClavicleTposeAdjustment:CFrame,RightElbow:Instance,RightElbowRangeMax:Vector3,RightElbowRangeMin:Vector3,RightElbowSize:float,RightElbowTposeAdjustment:CFrame,RightHip:Instance,RightHipRangeMax:Vector3,RightHipRangeMin:Vector3,RightHipSize:float,RightHipTposeAdjustment:CFrame,RightKnee:Instance,RightKneeRangeMax:Vector3,RightKneeRangeMin:Vector3,RightKneeSize:float,RightKneeTposeAdjustment:CFrame,RightShoulder:Instance,RightShoulderRangeMax:Vector3,RightShoulderRangeMin:Vector3,RightShoulderSize:float,RightShoulderTposeAdjustment:CFrame,RightToeBase:Instance,RightToeBaseRangeMax:Vector3,RightToeBaseRangeMin:Vector3,RightToeBaseSize:float,RightToeBaseTposeAdjustment:CFrame,RightWrist:Instance,RightWristRangeMax:Vector3,RightWristRangeMin:Vector3,RightWristSize:float,RightWristTposeAdjustment:CFrame,Root:Instance,RootRangeMax:Vector3,RootRangeMin:Vector3,RootSize:float,RootTposeAdjustment:CFrame,Spine:Instance,SpineRangeMax:Vector3,SpineRangeMin:Vector3,SpineSize:float,SpineTposeAdjustment:CFrame,Waist:Instance,WaistRangeMax:Vector3,WaistRangeMin:Vector3,WaistSize:float,WaistTposeAdjustment:CFrame;IKControl<Instance|GetChainCount,GetChainLength,GetNodeLocalCFrame,GetNodeWorldCFrame,GetRawFinalTarget,GetSmoothedFinalTarget,Solve||ChainRoot:Instance,Enabled:bool,EndEffector:Instance,EndEffectorOffset:CFrame,Offset:CFrame,Pole:Instance,Priority:int,SmoothTime:float,Target:Instance,Type:IKControlType,Weight:float;ILegacyStudioBridge<Instance|||;LegacyStudioBridge<ILegacyStudioBridge|||;IXPService<Instance|ClearCreatorLayers,ClearUserLayers,GetBrowserTrackerLayerLoadingStatus,GetBrowserTrackerLayerVariables,GetBrowserTrackerStatusForLayer,GetCreatorLayerLoadingStatus,GetCreatorLayerVariables,GetCreatorStatusForLayer,GetRegisteredCreatorLayersToStatus,GetRegisteredUserLayersToStatus,GetUserLayerLoadingStatus,GetUserLayerVariables,GetUserStatusForLayer,InitializeCreatorLayers,InitializeUserLayers,LogBrowserTrackerLayerExposure,LogCreatorLayerExposure,LogFlagLinkedUserLayerExposure,LogUserLayerExposure,RegisterCreatorLayers,RegisterUserLayers|OnBrowserTrackerLayerLoadingStatusChanged,OnCreatorLayerLoadingStatusChanged,OnUserLayerLoadingStatusChanged|;ImageScreenCaptureService<Instance|||;ImportSession<Instance|Cancel,GetFilename,GetStatuses,Upload|UploadComplete,UploadProgress|UploadSource:string;AssetImportSession<ImportSession|ApplyPreset,CreatePresetFromData,GetImportTree,GetKeyframeSequences,GetKeyframeSequencesForSelectedRestPose,GetKeyframeSequencesForSelectedRestPoseWithClip,GetPlaceholderInstanceTree,GetRigVisualization,GetUploadStatus,HasAnimation,IsAvatar,IsGltf,IsR15,Reset,usesCustomRestPoseLua||;IncrementalPatchBuilder<Instance|||AddPathsToBundle:bool,BuildDebouncePeriod:double,HighCompression:bool,SerializePatch:bool,UseFileLevelCompressionInsteadOfChunk:bool,ZstdCompression:bool;InputAction<Instance|Fire,GetInputBindings,GetPreferredBindingList,GetState|InputBindingsChanged,Pressed,Released,StateChanged|BoolState:bool,Direction1DState:float,Direction2DState:Vector2,Direction3DState:Vector3,Enabled:bool,PreferredBinding:InputBinding,Type:InputActionType,ViewportPositionState:Vector2;InputBinding<Instance|Fire||Backward:KeyCode,ClampMagnitudeToOne:bool,DisplayImage:Content,DisplayName:string,Down:KeyCode,Forward:KeyCode,KeyCode:KeyCode,Left:KeyCode,PointerIndex:int,PressedThreshold:float,PrimaryModifier:KeyCode,ReleasedThreshold:float,ResponseCurve:float,Right:KeyCode,Scale:float,SecondaryModifier:KeyCode,Type:InputBindingType,UIButton:GuiButton,UIModifier:GuiButton,Up:KeyCode,Vector2Scale:Vector2,Vector3Scale:Vector3;InputContext<Instance|GetInputActions|InputActionsChanged|Enabled:bool,Priority:int,Sink:bool;InputObject<Instance|IsModifierKeyDown||Delta:Vector3,KeyCode:KeyCode,Position:Vector3,UserInputState:UserInputState,UserInputType:UserInputType;InsertService<Instance|ApproveAssetId,ApproveAssetVersionId,GetLocalFileContents,Insert,LoadLocalAsset,CreateMeshPartAsync,GetBaseCategories,GetBaseSets,GetCollection,GetFreeDecals,GetFreeDecalsAsync,GetFreeModels,GetFreeModelsAsync,GetLatestAssetVersionAsync,GetUserCategories,GetUserSets,LoadAsset,LoadAssetVersion,LoadAssetWithBytecodeAsync,LoadAssetWithFormat,loadAsset,LoadPackageAssetAsync|InternalDelete|AllowInsertFreeModels:bool;InstanceExtensionsService<Instance|CountChildren||;InstanceFileSyncService<Instance|GetAllInstances,GetStatus,GetSyncedInstance,GetSyncingCollaborators,GetTooltip|StatusChanged,SyncingCollaboratorsChanged|;IntentService<Instance|||;InternalMessagingService<Instance|||;InternalMessagingServiceVerifier<Instance|||;InternalSyncItem<Instance|||AutoSync:bool,Enabled:bool,Path:string,Target:Instance;InternalSyncService<Instance|||;JointInstance<Instance|||Active:bool,C0:CFrame,C1:CFrame,Enabled:bool,Part0:BasePart,Part1:BasePart,part1:BasePart;DynamicRotate<JointInstance|||BaseAngle:float;RotateP<DynamicRotate|||;RotateV<DynamicRotate|||;Glue<JointInstance|||F0:Vector3,F1:Vector3,F2:Vector3,F3:Vector3;ManualSurfaceJointInstance<JointInstance|||;ManualGlue<ManualSurfaceJointInstance|||;ManualWeld<ManualSurfaceJointInstance|||;Motor<JointInstance|SetDesiredAngle||CurrentAngle:float,DesiredAngle:float,MaxVelocity:float,ReplicateCurrentAngle:float;Motor6D<Motor|||ChildName:string,EnableSkinning:bool,ParentName:string,ReplicateCurrentAngle6D:Vector3,ReplicateCurrentOffset6D:Vector3,Transform:CFrame;Rotate<JointInstance|||;Snap<JointInstance|||;VelocityMotor<JointInstance|||CurrentAngle:float,DesiredAngle:float,Hole:Hole,MaxVelocity:float;Weld<JointInstance|||EnableSkinning:bool;JointsService<Instance|ClearJoinAfterMoveJoints,CreateJoinAfterMoveJoints,SetJoinAfterMoveInstance,SetJoinAfterMoveTarget,ShowPermissibleJoints||;KeyboardService<Instance|||;Keyframe<Instance|AddMarker,AddPose,GetMarkers,GetPoses,RemoveMarker,RemovePose||Time:float;KeyframeMarker<Instance|||Value:string;KeyframeSequenceProvider<Instance|GetKeyframeSequence,GetKeyframeSequenceById,GetMemStats,RegisterActiveKeyframeSequence,RegisterKeyframeSequence,GetAnimations,GetAnimationsAsync,GetKeyframeSequenceAsync||;LanguageService<Instance|GetCapabilitiesUsedInPackageAsync||;Light<Instance|||Brightness:float,Color:Color3,Enabled:bool,Shadows:bool;PointLight<Light|||Range:float;SpotLight<Light|||Angle:float,Face:NormalId,Range:float;SurfaceLight<Light|||Angle:float,Face:NormalId,Range:float;Lighting<Instance|GetMinutesAfterMidnight,GetMoonDirection,GetMoonPhase,GetSunDirection,SetMinutesAfterMidnight,getMinutesAfterMidnight,setMinutesAfterMidnight|LightingChanged|Ambient:Color3,Brightness:float,ClockTime:float,ColorShift_Bottom:Color3,ColorShift_Top:Color3,EnvironmentDiffuseScale:float,EnvironmentSpecularScale:float,ExposureCompensation:float,ExtendLightRangeTo120:RolloutState,FogColor:Color3,FogEnd:float,FogStart:float,GeographicLatitude:float,GlobalShadows:bool,LightingStyle:LightingStyle,OutdoorAmbient:Color3,Outlines:bool,PrioritizeLightingQuality:bool,ShadowColor:Color3,ShadowSoftness:float,Technology:Technology,TimeOfDay:string;LinkingService<Instance|DetectUrl,GetAndClearLastPendingUrl,GetLastLuaUrl,IsUrlRegistered,RegisterLuaUrl,StartLuaUrlDelivery,StopLuaUrlDelivery,OpenUrl,SupportsSwitchToSettingsApp,SwitchToSettingsApp|OnLuaUrl|;LiveScriptingService<Instance||BeginEdit,BeginEditWithUri,BroadcastMessage,EndEdit,FailedToOpen,KickFromEdit,LiveEditingClientConfiguration,OpenedWithSource,SendAtomicOperation,SendAtomicOperationWithUri,SendAtomicUpdateResponse,SendOperation|ServerLiveEditingMode:ServerLiveEditingMode;LiveSyncService<Instance|GetSyncState|SyncStatusChanged|HasSyncedInstances:bool;LocalStorageService<Instance|Flush,GetItem,SetItem,WhenLoaded|ItemWasSet,StoreWasCleared|;AppStorageService<LocalStorageService|||;UserStorageService<LocalStorageService|||;LocalizationService<Instance|GetCorescriptLocalizations,GetIsLoadingInternalTranslations,GetTableEntries,GetTranslatorForPlayer,IsLoadingInternalTranslationsSettingChanged,SetRobloxLocaleId,StartTextScraper,StopTextScraper,GetCountryRegionForPlayerAsync,GetTranslatorForLocaleAsync,GetTranslatorForPlayerAsync,PromptDownloadGameTableToCSV,PromptExportToCSVs,PromptImportFromCSVs,PromptUploadCSVToGameTable|AutoTranslateWillRun,DynamicTranslationServerToClientResponse,TextScraperClientMessageWithPlayerSignal|ForcePlayModeGameLocaleId:string,ForcePlayModeRobloxLocaleId:string,GameSourceLanguageId:string,IsImageCaptureEnabled:bool,IsTextScraperRunning:bool,LocaleManifest:string,RobloxForcePlayModeGameLocaleId:string,RobloxForcePlayModeRobloxLocaleId:string,RobloxLocaleId:string,ShouldUseCloudTable:bool,ShouldUseImageLocalizationTable:bool,SystemLocaleId:string;LocalizationTable<Instance|GetContents,GetEntries,GetString,GetTranslator,RemoveEntry,RemoveEntryValue,RemoveKey,RemoveTargetLocale,SetContents,SetEntries,SetEntry,SetEntryContext,SetEntryExample,SetEntryKey,SetEntrySource,SetEntryValue,SetIsExemptFromUGCAnalytics||Contents:string,DevelopmentLanguage:string,IsExemptFromUGCAnalytics:bool,Root:Instance,SourceLocaleId:string;CloudLocalizationTable<LocalizationTable|||;LodDataEntity<Instance|||EntityData:SharedString,EntityLodEnabled:bool,EntityModelSize:Vector3,EntityPosition:CFrame,EntityScale:Vector3,EntitySource:Instance,EntityVisible:bool,IsSlimEnabled:bool,SlimAnimationSource:SlimAnimationDataEntity,SlimReplicationTimestampSec:double,TranscoderFailureReason:string,TranscoderStatus:SlimTranscoderStatus;LodDataService<Instance||RequestTranscoderStatusTracking|;LogReporterService<Instance|ReportLog,ReportMultipleLogs,SubmitStratusBugReport||;LogService<Instance|ClearOutput,Error,ExecuteScript,GetHttpResultHistory,GetLogHistory,GetLogger,Info,Log,Output,RequestHttpResultApproved,RequestServerHttpResult,RequestServerOutput,Warn,GetLogHistoryAsync|HttpResultOut,MessageOut,OnHttpResultApproved,RequestHttpResultApprovedSignal,RequestScriptExecutionSignal,RequestServerHttpResultSignal,RequestServerOutputSignal,RequestSettingsChange,ServerContextOut,ServerHttpResultOut,ServerMessageOut,ServerVariantMessageOut|;LoginService<Instance|Logout,PromptLogin|LoginFailed,LoginSucceeded|;LuaSettings<Instance|||;LuaSourceContainer<Instance|||CachedRemoteSource:ProtectedString,CachedRemoteSourceLoadState:int,HasAssociatedDrafts:bool,IsDifferentFromFileSystem:bool,SandboxedSource:ProtectedString,ScriptGuid:string,isPlayerScript:bool;AuroraScript<LuaSourceContainer|AddTo,GetSchema,IsOnInstance,RemoveFrom,SignalFired|ChangedThisFrame,SynchronizeState|AuroraScriptBindingsSerialize:BinaryString,EnableCulling:bool,EnableLOD:bool,LODCriticality:int,Priority:int,Source:ProtectedString;BaseScript<LuaSourceContainer|||Disabled:bool,Enabled:bool,LinkedSource:ContentId,RunContext:RunContext;CoreScript<BaseScript|||;Script<BaseScript|GetHash||Source:ProtectedString;LocalScript<Script|||;ModuleScript<LuaSourceContainer|||Confidential:bool,LinkedSource:ContentId,Source:ProtectedString,UnrestrictedRequireAllowed:bool;LuaWebService<Instance|||;LuauExpressionService<Instance|CreateExpression||;LuauScriptAnalyzerService<Instance|||;MLModelDeliveryService<Instance|||;MLService<Instance|IsPostProcessReady,SetPostProcessEnabled,CreateSessionAsync,LoadPostProcessModelAsync||;MakeupDescription<Instance|GetAppliedInstance||AssetId:int64,Instance:Instance,MakeupType:MakeupType,Order:int;MarkerCurve<Instance|GetMarkerAtIndex,GetMarkers,InsertMarkerAtTime,RemoveMarkerAtIndex||Length:int,ValuesAndTimes:BinaryString;MarketplaceService<Instance|BindReceiptHandler,ClearProductInfoCaches,IsPurchaseSimulated,OpenShop,PlayerCanMakePurchases,PrepareCollectiblesPurchase,PromptBulkPurchase,PromptBundlePurchase,PromptCancelSubscription,PromptCollectiblesPurchase,PromptGamePassPurchase,PromptNativePurchase,PromptNativePurchaseWithLocalPlayer,PromptNativePurchaseWithLocalPlayerWithPaymentSessionId,PromptNativePurchaseWithPaymentSessionId,PromptPremiumPurchase,PromptProductPurchase,PromptPurchase,PromptRobloxPurchase,PromptRobloxSubscriptionPurchase,PromptSubscriptionPurchase,PromptThirdPartyPurchase,ReportAssetSale,ReportRobuxUpsellStarted,SignalAssetTypePurchased,SignalCheckPlayerHasRobloxSubscription,SignalClientPurchaseSuccess,SignalMockPurchasePremium,SignalMockPurchaseRobloxSubscription,SignalPromptBulkPurchaseFinished,SignalPromptBundlePurchaseFinished,SignalPromptGamePassPurchaseFinished,SignalPromptPremiumPurchaseFinished,SignalPromptProductPurchaseFinished,SignalPromptPurchaseFinished,SignalPromptRobloxSubscriptionPurchaseFinished,SignalPromptSubscriptionPurchaseFinished,SignalRobuxTransferCompleted,SignalServerLuaDialogClosed,SignalUserSubscriptionStatusChanged,GetAvailableSubscriptionProductsAsync,GetDeveloperProductsAsync,GetProductInfo,GetProductInfoAsync,GetRobloxSubscriptionDetailsAsync,GetRobuxBalance,GetSubscriptionProductInfoAsync,GetSubscriptionPurchaseInfoAsync,GetUserSubscriptionDetailsAsync,GetUserSubscriptionDetailsInternalAsync,GetUserSubscriptionPaymentHistoryAsync,GetUserSubscriptionStatusAsync,GetUsersPriceLevelsAsync,PerformBulkPurchase,PerformCancelSubscription,PerformPurchase,PerformPurchaseV2,PerformSubscriptionPurchase,PerformSubscriptionPurchaseV2,PerformSubscriptionPurchaseV3Async,PerformSubscriptionPurchaseWithRobuxAsync,PlayerOwnsAsset,PlayerOwnsAssetAsync,PlayerOwnsBundle,PlayerOwnsBundleAsync,PromptRobuxTransferAsync,RankProductsAsync,RecommendTopProductsAsync,UserOwnsGamePassAsync|AssetTypePurchased,ClientLuaDialogRequested,ClientPurchaseSuccess,ConfirmPlayerHasRobloxSubscription,ConfirmPlayerMembership,ConfirmUserSubscriptionPurchase,LuaDialogCallbackSignal,MockConfirmUserSubscriptionPurchase,MockPurchasePremium,MockPurchaseRobloxSubscription,NativePurchaseFinished,NativePurchaseFinishedV2,NativePurchaseFinishedWithLocalPlayer,NativePurchaseFinishedWithLocalPlayerV2,OpenShopRequested,PrepareCollectiblesPurchaseRequested,PromptBulkPurchaseFinished,PromptBulkPurchaseRequested,PromptBulkPurchaseRequestedV2,PromptBundlePurchaseFinished,PromptBundlePurchaseRequested,PromptCancelSubscriptionRequested,PromptCollectibleBundlePurchaseRequested,PromptCollectiblesPurchaseRequested,PromptGamePassPurchaseFinished,PromptGamePassPurchaseRequested,PromptNativePurchaseRequested,PromptNativePurchaseRequestedWithLocalPlayer,PromptNativePurchaseRequestedWithLocalPlayerWithPaymentSessionId,PromptNativePurchaseRequestedWithPaymentSessionId,PromptPremiumPurchaseFinished,PromptPremiumPurchaseRequested,PromptProductPurchaseFinished,PromptProductPurchaseRequested,PromptPurchaseFinished,PromptPurchaseRequested,PromptPurchaseRequestedV2,PromptRobloxPurchaseRequested,PromptRobloxSubscriptionPurchaseFinished,PromptRobloxSubscriptionPurchaseRequested,PromptRobuxTransferRequested,PromptRobuxTransferSubscriptionUpsellRequested,PromptSubscriptionPurchaseFinished,PromptSubscriptionPurchaseRequested,PromptThirdPartyPurchaseRequested,RobuxTransferCompleted,ServerPurchaseVerification,ThirdPartyPurchaseFinished,UserSubscriptionStatusChanged|ProcessReceipt;MatchmakingService<Instance|GetServerAttribute,InitializeServerAttributesForStudio,SetServerAttribute||;MaterialGenerationService<Instance|GenerateMaterialVariantsAsync||;MaterialService<Instance|GetBaseMaterialOverride,GetIsMaterialActionAsToolEnabled,GetMaterialOverrideChanged,GetMaterialVariant,GetOverrideStatus,SetBaseMaterialOverride,SetCurrentMaterial,ToggleMaterialFillToolEnabled|MaterialFillToolEnabledChanged,OverrideStatusChanged|AsphaltName:string,BasaltName:string,BrickName:string,CardboardName:string,CarpetName:string,CeramicTilesName:string,ClayRoofTilesName:string,CobblestoneName:string,ConcreteName:string,CorrodedMetalName:string,CrackedLavaName:string,DiamondPlateName:string,FabricName:string,FoilName:string,GlacierName:string,GraniteName:string,GrassName:string,GroundName:string,IceName:string,LeafyGrassName:string,LeatherName:string,LimestoneName:string,MarbleName:string,MetalName:string,MudName:string,PavementName:string,PebbleName:string,PlasterName:string,PlasticName:string,RockName:string,RoofShinglesName:string,RubberName:string,SaltName:string,SandName:string,SandstoneName:string,SlateName:string,SmoothPlasticName:string,SnowName:string,Use2022Materials:bool,Use2022MaterialsXml:bool,WoodName:string,WoodPlanksName:string;MaterialVariant<Instance|||AlphaMode:AlphaMode,AvgMetalness:int,AvgRoughness:int,BaseMaterial:Material,ColorMap:ContentId,ColorMapContent:Content,CustomPhysicalProperties:PhysicalProperties,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,MaterialPattern:MaterialPattern,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,RoughnessMap:ContentId,RoughnessMapContent:Content,StudsPerTile:float,TexturePack:ContentId,TexturePackContent:Content;MemStorageConnection<Instance|Disconnect||;MemStorageService<Instance|Bind,BindAndFire,Call,Fire,GetItem,HasItem,RemoveItem,SetItem||;MemoryStoreDistributedCounter<Instance|GetAsync,IncrementAsync||;MemoryStoreHashMap<Instance|GetAsync,ListItemsAsync,RemoveAsync,SetAsync,UpdateAsync||;MemoryStoreQueue<Instance|AddAsync,GetSizeAsync,ReadAsync,RemoveAsync||;MemoryStoreService<Instance|GetDistributedCounter,GetHashMap,GetQueue,GetSortedMap||;MemoryStoreSortedMap<Instance|GetAsync,GetRangeAsync,GetSizeAsync,RemoveAsync,SetAsync,UpdateAsync||;Message<Instance|||Text:string;Hint<Message|||;MessageBusConnection<Instance|Disconnect||;MessageBusService<Instance|Call,GetLast,GetMessageId,GetProtocolMethodRequestMessageId,GetProtocolMethodResponseMessageId,MakeRequest,Publish,PublishProtocolMethodRequest,PublishProtocolMethodResponse,SetRequestHandler,Subscribe,SubscribeToProtocolMethodRequest,SubscribeToProtocolMethodResponse||;MessagingService<Instance|PublishAsync,SubscribeAsync||;MetaBreakpoint<Instance|GetContextBreakpoints,Remove,SetChildBreakpointEnabledByScriptAndContext,SetContextEnabled,SetContinueExecution,SetEnabled,SetLine,SetRemoveOnHit||Condition:string,ContinueExecution:bool,Enabled:bool,Id:int,IsLogpoint:bool,Line:int,LogMessage:string,RemoveOnHit:bool,Script:string,Valid:bool;MetaBreakpointContext<Instance|||ContextDataInternal:string;MetaBreakpointManager<Instance|AddBreakpoint,GetBreakpointById,RemoveBreakpointById|MetaBreakpointAdded,MetaBreakpointChanged,MetaBreakpointRemoved,MetaBreakpointSetChanged|;MicroProfilerService<Instance|GetDataInRange,GetDataSize,ProcessCommand,DumpToFileAsync|DataChanged|ContextLabel:string;ModerationService<Instance|BindReviewableContentEventProcessor,CreateReviewableContentKey,CreateReviewableContentAsync,InternalRequestReviewableContentReviewAsync|TriggeredCaptureUpload|;MomentsService<Instance|CheckMomentTextStatusAsync,CreatePostAsync,GenerateMomentTextAsync||;Mouse<Instance||Button1Down,Button1Up,Button2Down,Button2Up,Idle,KeyDown,KeyUp,Move,WheelBackward,WheelForward,keyDown|Hit:CFrame,Icon:ContentId,IconContent:Content,Origin:CFrame,Target:BasePart,TargetFilter:Instance,TargetSurface:NormalId,UnitRay:Ray,ViewSizeX:int,ViewSizeY:int,X:int,Y:int,hit:CFrame,target:BasePart;PlayerMouse<Mouse|||;PluginMouse<Mouse||DragEnter|;MouseService<Instance||MouseEnterStudioViewport,MouseLeaveStudioViewport|;MultipleDocumentInterfaceInstance<Instance||DataModelSessionEnded,DataModelSessionStarted|FocusedDataModelSession:DataModelSession;NetworkMarker<Instance||Received|;NetworkPeer<Instance|InitializeRemoteAllowList,SetOutgoingKBPSLimit||;NetworkClient<NetworkPeer||ConnectionAccepted,ConnectionFailed|;NetworkServer<NetworkPeer|EncryptStringForPlayerId||;NetworkReplicator<Instance|GetPlayer||;ClientReplicator<NetworkReplicator|IsStreamedOut,RequestRCCProfilerData,RequestServerStats|RCCProfilerDataComplete,StatsReceived|;ServerReplicator<NetworkReplicator|||;NetworkSettings<Instance|||EmulatedTotalMemoryInMB:int,FreeMemoryMBytes:float,HttpProxyEnabled:bool,HttpProxyURL:string,InboundNetworkJitterMs:float,InboundNetworkLossPercent:float,InboundNetworkMinDelayMs:float,IncomingReplicationLag:double,OpenCertManagerDialog:int,OutboundNetworkJitterMs:float,OutboundNetworkLossPercent:float,OutboundNetworkMinDelayMs:float,PrintJoinSizeBreakdown:bool,PrintPhysicsErrors:bool,PrintStreamInstanceQuota:bool,RandomizeJoinInstanceOrder:bool,RenderStreamedRegions:bool,ShowActiveAnimationAsset:bool;NoCollisionConstraint<Instance|||Enabled:bool,Part0:BasePart,Part1:BasePart;Noise<Instance|SampleDirectional,SampleUniform||NoiseType:NoiseType,Seed:int;NotificationService<Instance|ActionEnabled,ActionTaken,CancelAllNotification,CancelNotification,ScheduleNotification,SubscribeToRccEventNamespace,SwitchedToAppShellFeature,GetScheduledNotifications|RccConnectionChanged,RccEventReceived,Roblox17sConnectionChanged,Roblox17sEventReceived,RobloxConnectionChanged,RobloxEventReceived|IsConnected:bool,IsLuaChatEnabled:bool,IsLuaGameDetailsEnabled:bool,SelectedTheme:string;OmniRecommendationsService<Instance|ClearSessionId,GetSessionId,MakeRequest||;OpenCloudApiV1<Instance|CreateModel,CreateUserNotificationAsync||;OpenCloudService<Instance|GetApiV1,RegisterOpenCloud,RegistrationComplete,HttpRequestAsync,InvokeAsync||;OperationGraph<Instance|||;PVInstance<Instance|GetPivot,PivotTo||Origin:CFrame;BasePart<PVInstance|AngularAccelerationToTorque,ApplyAngularImpulse,ApplyImpulse,ApplyImpulseAtPosition,BindToCollisionSummaries,BreakJoints,CanCollideWith,CanSetNetworkOwnership,GetClosestPointOnSurface,GetConnectedParts,GetJoints,GetMass,GetNetworkOwner,GetNetworkOwnershipAuto,GetNoCollisionConstraints,GetPhysicsCost,GetRenderCFrame,GetRootPart,GetTouchingParts,GetVelocityAtPosition,IsGrounded,MakeJoints,Resize,SetNetworkOwner,SetNetworkOwnershipAuto,TorqueToAngularAcceleration,breakJoints,getMass,makeJoints,resize,IntersectAsync,SubtractAsync,UnionAsync|LocalSimulationTouched,NetworkOwnerChanged,OutfitChanged,StoppedTouching,TouchEnded,Touched|Anchored:bool,AssemblyAngularVelocity:Vector3,AssemblyCenterOfMass:Vector3,AssemblyLinearVelocity:Vector3,AssemblyMass:float,AssemblyRootPart:BasePart,AudioCanCollide:bool,BackParamA:float,BackParamB:float,BackSurface:SurfaceType,BackSurfaceInput:InputType,BottomParamA:float,BottomParamB:float,BottomSurface:SurfaceType,BottomSurfaceInput:InputType,BrickColor:BrickColor,CFrame:CFrame,CanCollide:bool,CanQuery:bool,CanTouch:bool,CastShadow:bool,CenterOfMass:Vector3,CollisionGroup:string,CollisionGroupId:int,CollisionGroupReplicate:string,Color:Color3,Color3uint8:Color3uint8,CurrentPhysicalProperties:PhysicalProperties,CustomPhysicalProperties:PhysicalProperties,DraggingV1:bool,Elasticity:float,EnableFluidForces:bool,ExtentsCFrame:CFrame,ExtentsSize:Vector3,Friction:float,FrontParamA:float,FrontParamB:float,FrontSurface:SurfaceType,FrontSurfaceInput:InputType,LeftParamA:float,LeftParamB:float,LeftSurface:SurfaceType,LeftSurfaceInput:InputType,LocalTransparencyModifier:float,Locked:bool,Mass:float,Massless:bool,Material:Material,MaterialVariant:string,MaterialVariantSerialized:string,NetworkIsSleeping:bool,NetworkOwnerV3:SystemAddress,NetworkOwnershipRule:NetworkOwnership,Orientation:Vector3,PhysicsRepRootPart:BasePart,PhysicsRepRootRef:InstanceRef,PivotOffset:CFrame,Position:Vector3,ReceiveAge:float,Reflectance:float,ReplicationPV:ReplicationPV,ResizeIncrement:int,ResizeableFaces:Faces,RightParamA:float,RightParamB:float,RightSurface:SurfaceType,RightSurfaceInput:InputType,RootPriority:int,RotVelocity:Vector3,Rotation:Vector3,Size:Vector3,SpecificGravity:float,TopParamA:float,TopParamB:float,TopSurface:SurfaceType,TopSurfaceInput:InputType,Transparency:float,Velocity:Vector3,brickColor:BrickColor,siz:Vector3,size:Vector3;CornerWedgePart<BasePart|||;FormFactorPart<BasePart|||FormFactor:FormFactor,formFactor:FormFactor,formFactorRaw:FormFactor;Part<FormFactorPart|||Shape:PartType,shap:PartType,shape:PartType;FlagStand<Part||FlagCaptured|TeamColor:BrickColor;Platform<Part||RemoteCreateMotor6D,RemoteDestroyMotor6D|;Seat<Part|Sit|RemoteCreateSeatWeld,RemoteDestroySeatWeld|Disabled:bool,Occupant:Humanoid;SkateboardPlatform<Part|ApplySpecificImpulse|Equipped,MoveStateChanged,RemoteCreateMotor6D,RemoteDestroyMotor6D,Unequipped,equipped,unequipped|Controller:SkateboardController,ControllingHumanoid:Humanoid,MoveState:MoveState,Steer:int,StickyWheels:bool,Throttle:int;SpawnLocation<Part|||AllowTeamChangeOnTouch:bool,Duration:int,Enabled:bool,Neutral:bool,TeamColor:BrickColor;WedgePart<FormFactorPart|||;Terrain<BasePart|AutowedgeCell,AutowedgeCells,CanSmoothVoxelsBeUpgraded,CellCenterToWorld,CellCornerToWorld,Clear,ClearVoxelsAsync_beta,ConvertToSmooth,CopyRegion,CountCells,CreateVoxelBuffer_beta,FillBall,FillBallSlot,FillBlock,FillBlockSlot,FillCylinder,FillCylinderSlot,FillRegion,FillRegionSlot,FillWedge,FillWedgeSlot,GenerateWaterFlowMap,GetCell,GetMaterialColor,GetMaterialSlot,GetTerrainWireframe,GetWaterCell,IterateVoxelsAsync_beta,ModifyVoxelsAsync_beta,PasteRegion,ReadVoxelChannels,ReadVoxels,ReadVoxelsAsync_beta,ReplaceMaterial,ReplaceMaterialInTransform,ReplaceMaterialInTransformSubregion,ReplaceMaterialInTransformSubregionSlot,ResetMaterialSlot,ResetWaterFlowMap,SetCell,SetCells,SetMaterialColor,SetMaterialInTransform,SetMaterialInTransformSubregion,SetMaterialInTransformSubregionSlot,SetMaterialSlot,SetWaterCell,SmoothRegion,SmoothRegionMaterialSlots,WorldToCell,WorldToCellPreferEmpty,WorldToCellPreferSolid,WriteVoxelChannels,WriteVoxels,WriteVoxelsAsync_beta,DrawBufferAsync,ReadBufferAsync|GridBackendReloadRequired|AcquisitionMethod:TerrainAcquisitionMethod,ClusterGrid:string,ClusterGridV2:string,ClusterGridV3:BinaryString,Decoration:bool,ExpandedTerrainResolved:bool,GrassLength:float,IsSmooth:bool,LastUsedModificationMethod:TerrainAcquisitionMethod,MaterialColors:BinaryString,Materials:SharedString,MaxExtents:Region3int16,PhysicsGrid:BinaryString,SmoothGrid:BinaryString,SmoothVoxelsUpgraded:bool,VoxelGridAssetContentMap:AssetContentMap,WaterColor:Color3,WaterReflectance:float,WaterTransparency:float,WaterWaveSize:float,WaterWaveSpeed:float;TriangleMeshPart<BasePart|||AeroMeshData:SharedString,CollisionFidelity:CollisionFidelity,CollisionPrecision:float,ConvexDecompHolder:NetAssetRef,FluidFidelity:FluidFidelity,FluidFidelityInternal:FluidFidelity,InertiaMigrated:bool,MeshSize:Vector3,PCDRequestId:int,PhysicalConfigData:SharedString,UnscaledCofm:Vector3,UnscaledVolInertiaDiags:Vector3,UnscaledVolInertiaOffDiags:Vector3,UnscaledVolume:float;MeshPart<TriangleMeshPart|ApplyMesh||AlternateMeshHash:int64,DoubleSided:bool,HasJointOffset:bool,HasSkinnedMesh:bool,InitialSize:Vector3,JointOffset:Vector3,MeshContent:Content,MeshID:ContentId,MeshId:ContentId,PhysicsData:BinaryString,RenderFidelity:RenderFidelity,RenderFidelityReplicate:RenderFidelity,SolidMeshHolder:NetAssetRef,TextureContent:Content,TextureID:ContentId,VertexCount:int;PartOperation<TriangleMeshPart|SubstituteGeometry||AssetId:ContentId,ChildData:BinaryString,ChildData2:SharedString,ComponentIndex:int,Content:Content,DCDPropertyData:CSGPropertyData,FormFactor:FormFactor,InitialSize:Vector3,ManifoldMesh_DEPRECATED:SharedString,MeshData:BinaryString,MeshData2:SharedString,OffCentered:bool,PhysicsData:BinaryString,RenderFidelity:RenderFidelity,SmoothingAngle:float,SolidMeshHolder:NetAssetRef,TriangleCount:int,UsePartColor:bool;IntersectOperation<PartOperation|||;NegateOperation<PartOperation|||PreviousOperation:NegateOperationHiddenHistory;UnionOperation<PartOperation|||;TrussPart<BasePart|||Style:Style,style:Style;VehicleSeat<BasePart|Sit|RemoteCreateSeatWeld,RemoteDestroySeatWeld|AreHingesDetected:int,Disabled:bool,HeadsUpDisplay:bool,MaxSpeed:float,Occupant:Humanoid,Steer:int,SteerFloat:float,Throttle:int,ThrottleFloat:float,Torque:float,TurnSpeed:float;Camera<PVInstance|GetLargestCutoffDistance,GetPanSpeed,GetPartsObscuringTarget,GetRenderCFrame,GetRoll,GetTiltSpeed,Interpolate,PanUnits,ScreenPointToRay,SetCameraPanMode,SetImageServerView,SetRoll,TiltUnits,ViewportPointToRay,WorldToScreenPoint,WorldToViewportPoint,Zoom,ZoomToExtents|FirstPersonTransition,InterpolationFinished|CFrame:CFrame,CameraSubject:Instance,CameraType:CameraType,CoordinateFrame:CFrame,DiagonalFieldOfView:float,FieldOfView:float,FieldOfViewMode:FieldOfViewMode,Focus:CFrame,HeadLocked:bool,HeadScale:float,MaxAxisFieldOfView:float,NearPlaneZ:float,VRTiltAndRollEnabled:bool,ViewportSize:Vector2,focus:CFrame;ViewportCamera<Camera|||;Model<PVInstance|AddPersistentPlayer,BreakJoints,GetBoundingBox,GetExtentsSize,GetModelCFrame,GetModelSize,GetPersistentPlayers,GetPrimaryPartCFrame,GetScale,MakeJoints,MoveTo,RemovePersistentPlayer,ResetOrientationToIdentity,ScaleTo,SetIdentityOrientation,SetPrimaryPartCFrame,TranslateBy,breakJoints,makeJoints,move,moveTo||LevelOfDetail:ModelLevelOfDetail,LodEntity:LodDataEntity,ModelMeshCFrame:CFrame,ModelMeshData:SharedString,ModelMeshSize:Vector3,ModelStreamingMode:ModelStreamingMode,NeedsPivotMigration:bool,PrimaryPart:BasePart,Scale:float,ScaleFactor:float,SlimAnimationTarget:SlimAnimationDataEntity,SlimHash:SharedString,WorldPivot:CFrame,WorldPivotData:OptionalCoordinateFrame;Actor<Model|BindToMessage,BindToMessageParallel,SendMessage||;BackpackItem<Model|||TextureContent:Content,TextureId:ContentId;HopperBin<BackpackItem|Disable,ToggleSelect|Deselected,ReplicatedSelected,Selected|Active:bool,BinType:BinType,Command:string,TextureName:string;Tool<BackpackItem|Activate,Deactivate|Activated,Deactivated,Equipped,Unequipped,VRLaserPointerClicked|CanBeDropped:bool,Enabled:bool,Grip:CFrame,GripForward:Vector3,GripPos:Vector3,GripRight:Vector3,GripUp:Vector3,ManualActivationOnly:bool,RequiresHandle:bool,ToolTip:string;Flag<Tool|||TeamColor:BrickColor;ProceduralModel<Model|ForceGeneration,WaitForGenerationAsync||Dirty:bool,GenerationError:string,Generator:ModuleScript,Size:Vector3;Status<Model|||;WorldRoot<Model|ArePartsTouchingOthers,Blockcast,BulkMoveTo,CacheCurrentTerrain,ClearCachedTerrain,CollisionGroupSetCollidable,CollisionGroupsAreCollidable,FindPartOnRay,FindPartOnRayWithIgnoreList,FindPartOnRayWithWhitelist,FindPartsInRegion3,FindPartsInRegion3WithIgnoreList,FindPartsInRegion3WithWhiteList,GetAwakeContactNormals,GetAwakeContactParts,GetAwakeContactPositions,GetAwakeRootParts,GetMaxCollisionGroups,GetPartBoundsInBox,GetPartBoundsInRadius,GetPartsInPart,GetRegisteredCollisionGroups,IKMoveTo,IsCollisionGroupRegistered,IsRegion3Empty,IsRegion3EmptyWithIgnoreList,Raycast,RaycastCachedTerrain,RegisterCollisionGroup,RenameCollisionGroup,SetInsertPoint,Shapecast,Simulate,Spherecast,StepPhysics,UnregisterCollisionGroup,findPartOnRay,findPartsInRegion3|CollisionGroupCollidableChanged|AutoSimulate:bool,CollisionGroupData:BinaryString,GravityDirection:Vector3,PhysicsStepTime:float,SimulationRate:float,Wind:float,WindDirection:Vector3;Workspace<WorldRoot|ApplyRecommendedStreamingSettings,BreakJoints,CalculateJumpDistance,CalculateJumpHeight,CalculateJumpPower,ExperimentalSolverIsEnabled,GetNumAwakeParts,GetPhysicsThrottling,GetRealPhysicsFPS,GetServerTimeNow,JoinToOutsiders,MakeJoints,PGSIsEnabled,SetAvatarUnificationMode,SetMeshPartHeadsAndAccessories,SetPhysicsThrottleEnabled,UnjoinFromOutsiders,ZoomToExtents|PersistentLoaded,SendServerTime|AirDensity:float,AirTurbulenceIntensity:float,AllowThirdPartySales:bool,AuthorityMode:AuthorityMode,AvatarUnificationMode:AvatarUnificationMode,ClientAnimatorThrottling:ClientAnimatorThrottlingMode,CollisionGroups:string,CurrentCamera:Camera,DataModelPlaceVersion:int,DistributedGameTime:double,EnableSLIMAvatars:RolloutState,ExpandedTerrain:RolloutState,ExplicitAutoJoints:bool,FallHeightEnabled:bool,FallenPartsDestroyHeight:float,FilteringEnabled:bool,FluidForces:FluidForces,GlobalWind:Vector3,Gravity:float,IKControlConstraintSupport:IKControlConstraintSupport,ImprovedAnimationConstraint:RolloutState,ImprovedPhysicsReplication:RolloutState,InsertPoint:Vector3,InterpolationThrottling:InterpolationThrottlingMode,LayeredClothingCacheOptimizations:RolloutState,LuauTypeCheckMode:LuauTypeCheckMode,MapTVRemoteToGamepadKeycodes:RolloutState,MeshPartHeadsAndAccessories:MeshPartHeadsAndAccessories,MeshStreamingAndImprovedLods:RolloutState,ModelStreamingBehavior:ModelStreamingBehavior,NextGenerationReplication:RolloutState,NextGenerationReplicationAlias:RolloutState,PathfindingUseImprovedSearch:PathfindingUseImprovedSearch,PhysicsSteppingMethod:PhysicsSteppingMethod,PlayerCharacterDestroyBehavior:PlayerCharacterDestroyBehavior,PlayerScriptsUseInputActionSystem:RolloutState,PlayerScriptsUseInputActionSystemAlias:RolloutState,PredictiveStreamingMode:PredictiveStreamingMode,PrimalPhysicsSolver:PrimalPhysicsSolver,RejectCharacterDeletions:RejectCharacterDeletions,RenderingCacheOptimizations:RenderingCacheOptimizationMode,ReplicateInstanceDestroySetting:ReplicateInstanceDestroySetting,Retargeting:AnimatorRetargetingMode,SandboxedInstanceMode:SandboxedInstanceMode,SignalBehavior:SignalBehavior,SignalBehavior2:SignalBehavior,SignalBehaviorAlias:SignalBehavior,StreamOutBehavior:StreamOutBehavior,StreamingAdaptiveRadius:bool,StreamingEnabled:bool,StreamingEnabledAlias:bool,StreamingIntegrityMode:StreamingIntegrityMode,StreamingMinRadius:int,StreamingPauseMode:StreamingPauseMode,StreamingTargetRadius:int,Terrain:Terrain,TerrainWeldsFixed:bool,ThrottleLevel:int,TouchEventsUseCollisionGroups:RolloutState,TouchesUseCollisionGroups:bool,UseFixedSimulation:RolloutState,UseFixedSimulationAlias:RolloutState,UseInputSink:RolloutState,UseNewLuauTypeSolver:RolloutState,ValidateEnabledProximityPrompt:RolloutState,WatermarkHash:string;WorldModel<WorldRoot|||UseWorkspaceCollisionGroups:bool;PackageLink<Instance|getOverrides||AutoUpdate:bool,CanAutoUpdate:bool,Creator:string,DefaultName:string,HasNewVersion:bool,ModifiedState:int,PackageAssetName:string,PackageContent:Content,PackageContentSerialize:Content,PackageGuid:int64,PackageId:ContentId,PackageIdSerialize:ContentId,SerializedDefaultAttributes:BinaryString,VersionIdSerialize:int64,VersionNumber:int64,PermissionLevel:PackagePermission,Status:string;PackageService<Instance|GetOverrides,UpdateAsync|OverrideStateChanged,OverridesCleared|;PackageUIService<Instance|ConvertToMockPackage,ConvertToPackageClosedCallback,ConvertToPackageUpload,ConvertToPackageAsync,GetPackageInfo,PublishPackage,SetPackageVersion|OnConvertToPackageResult,OnOpenConvertToPackagePlugin|;Packages<Instance|||IsDehydrated:bool,ShellPackagesCount:int,SkippedInstancesCount:int;Pages<Instance|GetCurrentPage,AdvanceToNextPageAsync||IsFinished:bool;AudioPages<Pages|||;BanHistoryPages<Pages|||;CapturesPages<Pages|||;CatalogPages<Pages|||;DataStoreKeyPages<Pages|||Cursor:string;DataStoreListingPages<Pages|||Cursor:string;DataStorePages<Pages|||;DataStoreVersionPages<Pages|||;FriendPages<Pages|||;InventoryPages<Pages|||;MemoryStoreHashMapPages<Pages|||;OutfitPages<Pages|||;RecommendationPages<Pages|||;StandardPages<Pages|||;PartOperationAsset<Instance|||ChildData:BinaryString,MeshData:BinaryString;ParticleEmitter<Instance|Clear,Emit,FastForward|OnClearRequested,OnEmitRequested|Acceleration:Vector3,Brightness:float,Color:ColorSequence,Drag:float,EmissionDirection:NormalId,Enabled:bool,FlipbookBlendFrames:bool,FlipbookFramerate:NumberRange,FlipbookIncompatible:string,FlipbookLayout:ParticleFlipbookLayout,FlipbookMode:ParticleFlipbookMode,FlipbookSizeX:int,FlipbookSizeY:int,FlipbookStartRandom:bool,Lifetime:NumberRange,LightEmission:float,LightInfluence:float,LocalTransparencyModifier:float,LockedToPart:bool,Orientation:ParticleOrientation,Rate:float,RotSpeed:NumberRange,Rotation:NumberRange,Shape:ParticleEmitterShape,ShapeInOut:ParticleEmitterShapeInOut,ShapePartial:float,ShapeStyle:ParticleEmitterShapeStyle,Size:NumberSequence,Speed:NumberRange,SpreadAngle:Vector2,Squash:NumberSequence,Texture:ContentId,TextureContent:Content,TimeScale:float,Transparency:NumberSequence,VelocityInheritance:float,VelocitySpread:float,WindAffectsDrag:bool,ZOffset:float;PartyEmulatorService<Instance|CreateNewParty,DeleteParty,GetEmulatedPartyConfiguration,GetIsEmulationEnabled,OnTestPlayerCountChanged,SetIsEmulationEnabled,SetPlayerPartyId,applyPartyIdToPlayer,GetEmulatedPartyAsync|ConfigurationChanged|;PatchBundlerFileWatch<Instance|||;PatchMapping<Instance|||FlattenTree:bool,PatchId:string,TargetPath:string;Path<Instance|GetPointCoordinates,GetWaypoints,CheckOcclusionAsync,ComputeAsync|Blocked,Unblocked|Status:PathStatus;Path3D<Instance|GetControlPoint,GetControlPoints,GetLength,GetMaxControlPoints,GetPositionOnCurve,GetPositionOnCurveArcLength,GetSegmentCount,GetTangentOnCurve,GetTangentOnCurveArcLength,InsertControlPoint,RemoveControlPoint,SetControlPoints,UpdateControlPoint|ControlPointChanged|;PathfindingLink<Instance|||Attachment0:Attachment,Attachment1:Attachment,IsBidirectional:bool,Label:string;PathfindingModifier<Instance|||Label:string,PassThrough:bool;PathfindingService<Instance|CreatePath,ComputeRawPathAsync,ComputeSmoothPathAsync,FindPathAsync||EmptyCutoff:float;PausedState<Instance|||AllThreadsPaused:bool,Reason:DebuggerPauseReason,ThreadId:int;PausedStateBreakpoint<PausedState|||Breakpoint:Breakpoint;PausedStateException<PausedState|||ExceptionText:string;PerformanceControlService<Instance|IsCrossExperienceLaunchFeasible||;PermissionsService<Instance|GetIsThirdPartyAssetAllowed,GetIsThirdPartyPurchaseAllowed,GetIsThirdPartyTeleportAllowed,GetPermissions,SetPermissions||;PhysicsService<Instance|CollisionGroupContainsPart,CollisionGroupSetCollidable,CollisionGroupsAreCollidable,CreateCollisionGroup,GetCollisionGroupId,GetCollisionGroupName,GetCollisionGroups,GetMaxCollisionGroups,GetRegisteredCollisionGroups,IkSolve,IsCollisionGroupRegistered,LocalIkSolve,RegisterCollisionGroup,RemoveCollisionGroup,RenameCollisionGroup,SetPartCollisionGroup,UnregisterCollisionGroup|CollisionGroupCollidableChanged|;PhysicsSettings<Instance|||AllowSleep:bool,AreAnchorsShown:bool,AreAssembliesShown:bool,AreAssemblyCentersOfMassShown:bool,AreAwakePartsHighlighted:bool,AreBodyTypesShown:bool,AreCollisionCostsShown:bool,AreConstraintForcesShownForSelectedOrHoveredInstances:bool,AreConstraintTorquesShownForSelectedOrHoveredInstances:bool,AreContactForcesShownForSelectedOrHoveredAssemblies:bool,AreContactIslandsShown:bool,AreContactPointsShown:bool,AreGravityForcesShownForSelectedOrHoveredAssemblies:bool,AreJointCoordinatesShown:bool,AreMagnitudesShownForDrawnForcesAndTorques:bool,AreMechanismsShown:bool,AreModelCoordsShown:bool,AreNonAnchorsShown:bool,AreOwnersShown:bool,ArePartCoordsShown:bool,AreRegionsShown:bool,AreSolverIslandsShown:bool,AreTerrainReplicationRegionsShown:bool,AreTimestepsShown:bool,AreUnalignedPartsShown:bool,AreWorldCoordsShown:bool,CollisionGeomDrawOriginalParts:bool,CollisionGeomMatchPartTransparency:bool,CollisionGeomOverlayTransparency:float,CollisionGeomShowCollidableParts:bool,CollisionGeomShowCollisionGroup:string,CollisionGeomShowQueryableParts:bool,CollisionGeomShowTouchableParts:bool,DisableCSGv2:bool,DisableCSGv3ForPlugins:bool,DrawConstraintsNetForce:bool,DrawContactsNetForce:bool,DrawTotalNetForce:bool,EnableForceVisualizationSmoothing:bool,FluidForceDrawScale:float,ForceCSGv2:bool,ForceDrawScale:float,ForceVisualizationSmoothingSteps:int,IsInterpolationThrottleShown:bool,IsReceiveAgeShown:bool,IsTreeShown:bool,PhysicsEnvironmentalThrottle:EnviromentalPhysicsThrottle,ShowDecompositionGeometry:bool,ShowFluidForcesForSelectedOrHoveredMechanisms:bool,ShowInstanceNamesForDrawnForcesAndTorques:bool,SolverConvergenceMetricType:SolverConvergenceMetricType,SolverConvergenceVisualizationMode:SolverConvergenceVisualizationMode,ThrottleAdjustTime:double,TorqueDrawScale:float,UseCSGv2:bool;PinShortcutService<Instance|IsAvailable,IsRevealPinnedExperienceAvailable,PinExperience,RevealPinnedExperience,ShouldShowLuaNotificationOnPinExperienceCompleted|OnPinExperienceCompleted|;PlaceAssetIdsService<Instance|||;PlaceStatsService<Instance|||;PlacesService<Instance|StartPlaySolo,StopPlaySolo||;PlatformCloudStorageService<Instance|IsUserDataAvailable,GetUserDataAsync,SetUserDataAsync||;PlatformFriendsService<Instance|IsInviteFriendsEnabled,IsProfileEnabled,ShowInviteFriendsUI,ShowProfile,GetPartyMembers||;PlatformLibraries<Instance||RemoteRequireRequest,RemoteRequireResponse|;Player<Instance|AddReplicationFocus,AddReplicationFocusPosition,AddToBlockList,ClearCachedAvatarAppearance,ClearCharacterAppearance,DistanceFromCharacter,GetBlockListInitialized,GetCameraState,GetData,GetFriendStatus,GetGameSessionID,GetGlobalUserId,GetJoinData,GetMouse,GetNetworkPing,GetSeatRequested,GetToolRequested,GetUnder13,HasAppearanceLoaded,HasBlockedPlayer,IsVerified,Kick,LoadBoolean,LoadCharacterAppearance,LoadData,LoadInstance,LoadNumber,LoadString,Move,NotifyAgeCheckPassed,OverrideStreamingRadii,PinStreamingForInstance,PinStreamingForInstanceByUniqueId,PromptAgeCheck,RemoveCharacter,RemoveReplicationFocus,RemoveReplicationFocusPosition,RequestFriendship,RequestSeat,RequestTool,RevokeFriendship,SaveBoolean,SaveData,SaveInstance,SaveNumber,SaveString,SetAccountAge,SetBlockListInitialized,SetCharacterAppearanceJson,SetChatTranslationSettingsLocaleId,SetExperienceSettingsLocaleId,SetHasRobloxSubscription,SetMembershipType,SetModerationAccessKey,SetSuperSafeChat,SetUnder13,UnpinStreamingForInstance,UpdatePlayerBlocked,loadBoolean,loadInstance,loadNumber,loadString,saveBoolean,saveInstance,saveNumber,saveString,GetCanManageAsync,GetFriendsInUniverseAsync,GetFriendsOnline,GetFriendsOnlineAsync,GetFriendsWhoPlayedAsync,GetRankInGroup,GetRankInGroupAsync,GetRoleInGroup,GetRoleInGroupAsync,IsBestFriendsWith,IsFriendsWith,IsFriendsWithAsync,IsInGroup,IsInGroupAsync,LoadCharacter,LoadCharacterAsync,LoadCharacterBlocking,LoadCharacterWithAvatarRules,LoadCharacterWithHumanoidDescription,LoadCharacterWithHumanoidDescriptionAsync,PromptSecurityChallengeAsync,RequestStreamAroundAsync,WaitForDataReady,isFriendsWith,waitForDataReady|BlockListChanged,CharacterAdded,CharacterAppearanceLoaded,CharacterRemoving,Chatted,CloudEditSelectionChanged,FriendStatusChanged,Idled,InstancePinned,InstanceUnpinned,Kill,NotifyAgeCheckPassedReplicated,NotifyStreamingUnpinned,OnTeleport,OnTeleportInternal,OverrideStreamRadii,PauseTeleports,PlayerCharacterLoaded,PlayerChatTranslationSettingsLocaleSetFromLua,PlayerExperienceSettingsLocaleSetFromLua,RemoteFriendRequestSignal,RemoteInsert,RequestStreamingPin,RequestStreamingPinByUniqueId,ScopeCheckInitiated,ScriptSecurityError,SendCameraFrustum,SendMaxClientBandwidthBps,ServerToClientUnfilteredChatReplicate,ServerUpdatedHead,SetShutdownMessage,SimulationRadiusChanged,StatsAvailable,StreamingPinComplete,UnpinStreaming,iradDebugServerReceivedIradRequest|AccountAge:int,AccountAgeReplicate:int,AgeChecked:AgeCheckStatus,AppearanceDidLoad:bool,AutoJumpEnabled:bool,CameraFieldOfView:float,CameraFrustumRequested:bool,CameraMaxZoomDistance:float,CameraMinZoomDistance:float,CameraMode:CameraMode,CameraViewportSize:Vector2,CanLoadCharacterAppearance:bool,Character:Model,CharacterAppearance:string,CharacterAppearanceId:int64,ChararacterRegionId:Vector3,ChatAvailabilityStatus:string,ChatMode:ChatMode,ChatPrivacyMode:ChatPrivacyMode,CloudEditCameraCoordinateFrame:CFrame,CloudEditPlayerActive:bool,CountryRegionCodeReplicate:string,DataComplexity:int,DataComplexityLimit:int,DataReady:bool,DevCameraOcclusionMode:DevCameraOcclusionMode,DevComputerCameraMode:DevComputerCameraMovementMode,DevComputerMovementMode:DevComputerMovementMode,DevEnableMouseLock:bool,DevTouchCameraMode:DevTouchCameraMovementMode,DevTouchMovementMode:DevTouchMovementMode,DisplayName:string,FollowUserId:int64,FollowUserIdReplicated:int64,FrustumStreaming:FrustumStreamingMode,GameplayPaused:bool,Guest:bool,HasRobloxSubscription:bool,HasVerifiedBadge:bool,HealthDisplayDistance:float,InputLatency:int,InternalCharacterAppearanceLoaded:bool,LocaleId:string,MaxSimulationRadius:float,MaximumSimulationRadius:float,MembershipType:MembershipType,MembershipTypeReplicate:MembershipType,NameDisplayDistance:float,NeedRegionalFallback:bool,Neutral:bool,OsPlatform:string,PartyId:string,PendingRequestedTool:Instance,PlatformName:string,RawJoinData:BinaryString,ReplicationFocus:Instance,RespawnLocation:SpawnLocation,SimulationRadius:float,StepIdOffset:int,SuperSafeChatReplicate:bool,Team:Team,TeamColor:BrickColor,Teleported:bool,TeleportedIn:bool,ThirdPartyTextChatRestrictionStatus:ChatRestrictionStatus,UnfilteredChat:bool,User:User,UserId:int64,UserIdModeReplicate:UserIdMode,VRDevice:string,VREnabled:bool,VoiceChatVolume:float,userId:int64;PlayerData<Instance|GetPlayer,GetRecordAsync||;PlayerDataRecord<Instance|GetPlayer,GetValue,GetValueChangedSignal,RemoveValue,SetValue,ReleaseAsync,RequestFlushAsync|Changed,Flushed,Loaded|CreatedTime:int64,DefaultRecordName:bool,Dirty:bool,Error:PlayerDataErrorState,FlushedTime:int64,LoadedTime:int64,ModifiedTime:int64,NewRecord:bool,Readable:bool,RecordName:string,Writable:bool;PlayerDataRecordConfig<Instance|GetDefaultValue,SetDefaultValue||RecordName:string;PlayerDataService<Instance|GetRecordConfig||LoadFailureBehavior:PlayerDataLoadFailureBehavior;PlayerEmulatorService<Instance|GetEmulatedPolicyInfo,RegionCodeWillHaveAutomaticNonCustomPolicies,SetEmulatedPolicyInfo||CustomPoliciesEnabled:bool,EmulatedCountryCode:string,EmulatedGameLocale:string,PlayerEmulationEnabled:bool,PseudolocalizationEnabled:bool,SerializedEmulatedPolicyInfo:BinaryString,TextElongationFactor:int;PlayerHydrationService<Instance||PlayerHydration|;PlayerScripts<Instance|ClearComputerCameraMovementModes,ClearComputerMovementModes,ClearTouchCameraMovementModes,ClearTouchMovementModes,GetRegisteredComputerCameraMovementModes,GetRegisteredComputerMovementModes,GetRegisteredTouchCameraMovementModes,GetRegisteredTouchMovementModes,RegisterComputerCameraMovementMode,RegisterComputerMovementMode,RegisterTouchCameraMovementMode,RegisterTouchMovementMode|ComputerCameraMovementModeRegistered,ComputerMovementModeRegistered,TouchCameraMovementModeRegistered,TouchMovementModeRegistered|;PlayerViewService<Instance|GetDeviceCameraCFrame,GetDeviceCameraCFrameForSelfView,OnCameraCFrameReplicationRequest,UpdateDeviceCFrame||;Players<Instance|Chat,CreateLocalPlayer,CreateThumbnailPlayer,GetPlayerByUserId,GetPlayerFromCharacter,GetPlayers,ReportAbuse,ReportAbuseV3,ReportAvatarAbuse,ReportChatAbuse,ResetLocalPlayer,SetChatStyle,SetLocalPlayerInfo,TeamChat,WhisperChat,getPlayers,playerFromCharacter,players,BanAsync,CreateHumanoidModelFromDescription,CreateHumanoidModelFromDescriptionAsync,CreateHumanoidModelFromUserId,CreateHumanoidModelFromUserIdAsync,GetBanHistoryAsync,GetCharacterAppearanceAsync,GetCharacterAppearanceInfoAsync,GetFriendsAsync,GetHumanoidDescriptionFromOutfitId,GetHumanoidDescriptionFromOutfitIdAsync,GetHumanoidDescriptionFromUserId,GetHumanoidDescriptionFromUserIdAsync,GetNameFromUserIdAsync,GetProfileConfigurationFromUserIdAsync,GetUserIdFromNameAsync,GetUserThumbnailAsync,UnbanAsync|CloudEditApplyEditsMessage,FriendRequestEvent,PlayerAdded,PlayerChatted,PlayerConnecting,PlayerDisconnecting,PlayerMembershipChanged,PlayerRejoining,PlayerRemoving,PromptAgeCheckRequested,PromptGameServerAvatarReportEnrichment,PromptGameServerReportEnrichment,PromptGameServerTargetedChatReportEnrichment,PromptReportServerEnrichmentAndScan,RequestCloudEditKick,RequestCloudEditShutdown,TeamCreateServerMessage,UserSubscriptionStatusChanged|BanningEnabled:bool,BubbleChat:bool,CharacterAutoLoads:bool,ClassicChat:bool,LocalPlayer:Player,MaxPlayers:int,MaxPlayersInternal:int,NumPlayers:int,PreferredPlayers:int,PreferredPlayersInternal:int,RespawnTime:float,ServerGitHash:string,ServerLogPrefix:string,UseStrafingAnimations:bool,localPlayer:Player,numPlayers:int;Plugin<Instance|Activate,CreatePluginAction,CreatePluginMenu,CreateToolbar,Deactivate,FinishFullLoading,GetItem,GetJoinMode,GetMouse,GetPluginComponent,GetSelectedRibbonTool,GetSetting,GetStudioUserId,GetUri,Intersect,Invoke,IsActivated,IsActivatedWithExclusiveMouse,IsLoadedFromProject,Negate,OnInvoke,OnInvokeSuspendOverride,OnSetItem,OpenScript,OpenWikiPage,PauseSound,PlaySound,ResumeSound,SaveSelectedToRoblox,SelectRibbonTool,Separate,SetItem,SetReady,SetSetting,StartDecalDrag,StartDrag,StopAllSounds,Union,CreateDockWidgetPluginGui,CreateDockWidgetPluginGuiAsync,CreateQWidgetPluginGui,ImportFbxAnimation,ImportFbxAnimationAsync,ImportFbxRig,ImportFbxRigAsync,PromptForExistingAssetId,PromptForExistingAssetIdAsync,PromptSaveSelection,PromptSaveSelectionAsync|Deactivation,Ready,Unloading,ViewportDragDropped,ViewportDragEntered,ViewportDragLeft|CollisionEnabled:bool,DisableUIDragDetectorDrags:bool,GridSize:float,HostDataModelType:StudioDataModelType,HostDataModelTypeIsCurrent:bool,IsDebuggable:bool,MultipleDocumentInterfaceInstance:MultipleDocumentInterfaceInstance,UsesAssetInsertionDrag:bool,ProcessAssetInsertionDrag,ProcessAssetInsertionDrop;PluginAction<Instance||Triggered|ActionId:string,AllowBinding:bool,Checked:bool,DefaultShortcut:string,Enabled:bool,StatusTip:string,Text:string,Visible:bool;PluginCapabilities<Instance|||Manifest:string;PluginConnectionService<Instance|CanHaveConnectionType,GetPluginConnectionsOfType|Connected|;PluginDebugService<Instance|||;PluginDragEvent<Instance|||Data:string,MimeType:string,Position:Vector2,Sender:string;PluginGuiService<Instance|||;PluginManagementService<Instance|SetAutoUpdate,GetOTAPluginVersion,ListPluginGuisAsync||;PluginManager<Instance|CreatePlugin,ExportPlace,ExportSelection||;PluginManagerInterface<Instance|CreatePlugin,ExportPlace,ExportSelection||;PluginMenu<Instance|AddAction,AddMenu,AddNewAction,AddSeparator,Clear,ShowAsync||Icon:string,Title:string,Visible:bool;PluginPolicyService<Instance|GetPluginPolicy||;PluginToolbar<Instance|CreateButton,CreatePopupButton||;PluginToolbarButton<Instance|SetActive,SetDropdownActive|Click,DropdownClick|ClickableWhenViewportHidden:bool,Enabled:bool,Icon:ContentId,IconContent:Content;PointsService<Instance|GetAwardablePoints,AwardPoints,GetGamePointBalance,GetPointBalance|PointsAwarded|;PolicyService<Instance|CanViewBrandProjectAsync,GetPolicyInfoForPlayerAsync,GetPolicyInfoForServerRobloxOnlyAsync||IsLuobuServer:TriStateBoolean,LuobuWhitelisted:TriStateBoolean;PopLatencyService<Instance|GetSnapshot,IsEnabled||;PoseBase<Instance|||EasingDirection:PoseEasingDirection,EasingStyle:PoseEasingStyle,Weight:float;NumberPose<PoseBase|||Value:double;Pose<PoseBase|AddSubPose,GetSubPoses,RemoveSubPose||CFrame:CFrame,MaskWeight:float;PostEffect<Instance|||Enabled:bool;BloomEffect<PostEffect|||Intensity:float,Size:float,Threshold:float;BlurEffect<PostEffect|||Size:float;ColorCorrectionEffect<PostEffect|||Brightness:float,Contrast:float,Saturation:float,TintColor:Color3;ColorGradingEffect<PostEffect|||TonemapperPreset:TonemapperPreset;DepthOfFieldEffect<PostEffect|||FarIntensity:float,FocusDistance:float,InFocusRadius:float,NearIntensity:float;SunRaysEffect<PostEffect|||Intensity:float,Spread:float;Preloaded<Instance|||;ProceduralBehaviorSchedulerService<Instance|||;ProcessInstancePhysicsService<Instance|||;ProximityPrompt<Instance|InputHoldBegin,InputHoldEnd|ButtonHoldBeganActionReplicated,ButtonHoldEndedActionReplicated,IndicatorHidden,IndicatorShown,PromptButtonHoldBegan,PromptButtonHoldEnded,PromptHidden,PromptShown,TriggerEnded,TriggerEndedActionReplicated,Triggered,TriggeredActionReplicated|ActionText:string,AutoLocalize:bool,ClickablePrompt:bool,Enabled:bool,Exclusivity:ProximityPromptExclusivity,GamepadKeyCode:KeyCode,HoldDuration:float,KeyboardKeyCode:KeyCode,MaxActivationDistance:float,MaxIndicatorDistance:float,ObjectText:string,RequiresLineOfSight:bool,RootLocalizationTable:LocalizationTable,Style:ProximityPromptStyle,UIOffset:Vector2;ProximityPromptService<Instance||IndicatorHidden,IndicatorShown,PromptButtonHoldBegan,PromptButtonHoldEnded,PromptHidden,PromptShown,PromptTriggerEnded,PromptTriggered|Enabled:bool,MaxIndicatorsVisible:int,MaxPromptsVisible:int;PublishService<Instance|PublishDescendantAssets,TagEmoteAnimation,CreateAssetAndWaitForAssetId,CreateAssetOrAssetVersionAndPollAssetWithTelemetryAsync,CreateAssetOrAssetVersionAndPollAssetWithTelemetryAsyncWithAddParam,CreateAssetOrAssetVersionAndPollAssetWithTelemetryAsyncWithAddParamErrorJson,PublishCageMeshAsync,PublishDescendantAssetsAsync||;QueueService<Instance|GetStandardQueue||;RTAnimationTracker<Instance|Step|TrackerError,TrackerPrompt|Active:bool,EnableFallbackAudioInput:bool,SessionName:string,TrackerMode:TrackerMode,TrackerType:TrackerType;RbxAnalyticsService<Instance|AddGlobalPointsField,AddGlobalPointsTag,DEPRECATED_TrackEvent,DEPRECATED_TrackEventWithArgs,GetClientId,GetPlaySessionId,GetSessionId,ReleaseRBXEventStream,RemoveGlobalPointsField,RemoveGlobalPointsTag,ReportCounter,ReportInfluxSeries,ReportStats,ReportToDiagByCountryCode,SendEventDeferred,SendEventImmediately,SetRBXEvent,SetRBXEventStream,TrackEvent,TrackEventWithArgs,UpdateHeartbeatObject||;RealtimeMedia<Instance|Disconnect,GetConnectedWires,GetInputPins,GetOutputPins,SendMessage,ConnectAsync|AudioInputRequested,OnMessage,WiringChanged|AudioInputActive:bool,ForwardInput:bool,IsConnected:bool;RecommendationService<Instance|LogActionEvent,LogImpressionEvent,LogPreferenceEvent,GenerateItemListAsync,GetRecommendationItemAsync,RegisterItemAsync,RemoveItemAsync,UpdateItemAsync||;ReflectionMetadata<Instance|||;ReflectionMetadataCallbacks<Instance|||;ReflectionMetadataClasses<Instance|||;ReflectionMetadataEnums<Instance|||;ReflectionMetadataEvents<Instance|||;ReflectionMetadataFunctions<Instance|||;ReflectionMetadataItem<Instance|||Browsable:bool,ClassCategory:string,ClientOnly:bool,Constraint:string,Deprecated:bool,EditingDisabled:bool,EditorType:string,FFlag:string,IsBackend:bool,PropertyOrder:int,ScriptContext:string,ServerOnly:bool,SliderScaling:string,UIMaximum:double,UIMinimum:double,UINumTicks:double;ReflectionMetadataClass<ReflectionMetadataItem|||ExplorerImageIndex:int,ExplorerOrder:int,Insertable:bool,PreferredParent:string,ServiceVisibility:ServiceVisibility;ReflectionMetadataEnum<ReflectionMetadataItem|||;ReflectionMetadataEnumItem<ReflectionMetadataItem|||;ReflectionMetadataMember<ReflectionMetadataItem|||;ReflectionMetadataProperties<Instance|||;ReflectionMetadataYieldFunctions<Instance|||;ReflectionService<Instance|GetClass,GetClasses,GetEventsOfClass,GetMethodsOfClass,GetPropertiesOfClass,GetPropertyNames,GetStyledPropertyNames||;RemoteCommandService<Instance|ExecuteCommand,GetExecutingPlayer,GetReceivedUpdateSignal,GetStoppingSignal,SendUpdate,ExecuteCommandAsync|CommandSentFromStudio,OneshotCommandErrorFromRcc,OneshotCommandResultFromRcc,OneshotCommandSentFromStudio,StandardOutMessageFromRcc,StopSentFromStudio,UpdateSentFromRcc,UpdateSentFromStudio|;RemoteCursorService<Instance||BroadcastRemoteCursorPositions,BroadcastRemoteCursorPositionsWithConnectionId,RequestAllRemoteCursorPositionForScript,RequestAllRemoteCursorPositionForScriptWithUri,UpdateClientRemoteCursorPosition,UpdateClientRemoteCursorPositionWithUri|;RemoteDebuggerServer<Instance|||;RemoteFunction<Instance|InvokeClient,InvokeServer|RemoteOnInvokeClient,RemoteOnInvokeError,RemoteOnInvokeServer,RemoteOnInvokeSuccess|OnClientInvoke,OnServerInvoke;RenderSettings<Instance|GetMaxQualityLevel||AutoFRMLevel:int,EagerBulkExecution:bool,EditQualityLevel:QualityLevel,EnableFRM:bool,ExportMergeByMaterial:bool,FrameRateManager:FramerateManagerMode,GraphicsMode:GraphicsMode,MeshCacheSize:int,MeshPartDetailLevel:MeshPartDetailLevel,QualityLevel:QualityLevel,ReloadAssets:bool,RenderCSGTrianglesDebug:bool,ShowBoundingBoxes:bool,ViewMode:ViewMode;RenderingTest<Instance|RenderdocTriggerCapture|TestFramesCountdownAboutToStart|CFrame:CFrame,ComparisonDiffThreshold:int,ComparisonMethod:RenderingTestComparisonMethod,ComparisonPsnrThreshold:float,Description:string,FieldOfView:float,Orientation:Vector3,PerfTest:bool,Position:Vector3,QualityAuto:bool,QualityLevel:int,RenderingTestFrameCount:int,ShouldSkip:bool,Ticket:string,Timeout:int;ReplicatedFirst<Instance|IsDefaultLoadingGuiRemoved,IsFinishedReplicating,RemoveDefaultLoadingScreen,SetDefaultLoadingGuiRemoved|DefaultLoadingGuiRemoved,FinishedReplicating,RemoveDefaultLoadingGuiSignal|;ReplicatedStorage<Instance|||;RequestOrchestratorService<Instance|ClearCache,GetBatchWindowDelayMax,GetBatchWindowDelayMin,GetRegisteredOrchestrators,GetResponseDelayMax,GetResponseDelayMin,SetBatchWindowDelay,SetResponseDelay|BatchCreated,BatchExhausted,BatchResponseReceived,BatchRetrying,BatchSent,CacheHit,CacheItemAdded,JitterStarted,OperationCoalesced,OperationEnqueued|;RibbonNotificationService<Instance|OnNotificationUpdateFromPlugin|AllNotificationsReadFromRibbon,NewNotificationFromRibbon,NotificationReadFromRibbon,ToggleNotificationTray|;RobloxPluginGuiService<Instance|||;RobloxReplicatedStorage<Instance|||;RobloxSerializableInstance<Instance|||Data:BinaryString;RobloxServerStorage<Instance|||;RolloutValidation<Instance|||AdditionalFluffOne:int,AdditionalFluffThree:float,AdditionalFluffTwo:bool,CreationVersion:int,FirstBinaryExpectedValue:string,FirstBinaryString:BinaryString,FirstSharedExpectedValue:string,FirstSharedString:SharedString,GenerationStrategy:int,SecondBinaryExpectedValue:string,SecondBinaryString:BinaryString,SecondSharedExpectedValue:string,SecondSharedString:SharedString,ThirdBinaryExpectedValue:string,ThirdBinaryString:BinaryString,ThirdSharedExpectedValue:string,ThirdSharedString:SharedString;RolloutValidationService<Instance|||;RomarkRbxAnalyticsService<Instance|||;RomarkService<Instance|EndRemoteRomarkTest|RomarkEndOfTest|;RotationCurve<Instance|GetKeyAtIndex,GetKeyIndicesAtTime,GetKeys,GetValueAtTime,InsertKey,RemoveKeyAtIndex,SetKeys||Length:int,ValuesAndTimes:BinaryString;RtMessagingService<Instance|||;RunService<Instance|BindToAnimation,BindToRenderStep,BindToSimulation,GetControlAndVariantRolloutFlags,GetCoreScriptVersion,GetPhysicsStepId,GetPredictionStatus,GetRobloxClientChannel,GetRobloxGuiFocused,GetRobloxVersion,GetTotalScriptPlusExecutionTime,IsClient,IsEdit,IsResimulating,IsRunMode,IsRunning,IsServer,IsStudio,IsTeamTest,Pause,Reset,Run,Set3dRenderingEnabled,SetPredictionMode,SetRobloxGuiFocused,Stop,UnbindFromRenderStep,getThrottleFramerateEnabled,setThrottleFramerateEnabled|Heartbeat,Misprediction,PostSimulation,PreAnimation,PreRender,PreSimulation,RenderStepped,RobloxGuiFocusedChanged,Rollback,Stepped|ClientGitHash:string,FrameNumber:int64,RunState:RunState;RuntimeContentService<Instance||RuntimeContentFail,RuntimeContentQuery,RuntimeContentShare|;RuntimeScriptService<Instance|||;SafetyService<Instance|DecodeAvatarMovementProto,ReportBuildUIClose,ReportBuildUIOpen,ReportCapturesUIClose,ReportCapturesUIOpen,ReportChatLineReportingClose,ReportChatLineReportingOpen,ReportChatSuspensionDialogClose,ReportChatSuspensionDialogOpen,ReportMenuTabClose,ReportMenuTabOpen,ReportPartyChatWindowClose,ReportPartyChatWindowOpen,TakeScreenshot|FSTriggeredSignal,ScreenshotContentReady,ScreenshotUploaded|IsCaptureModeForReport:bool;SceneAnalysisService<Instance|GetAnimationMemoryAsync,GetAudioMemoryAsync,GetInstanceCompositionAsync,GetScriptMemoryAsync,GetTriangleCompositionAsync,GetUnparentedInstancesAsync||;ScreenshotHud<Instance|||CameraButtonIcon:ContentId,CameraButtonIconContent:Content,CameraButtonPosition:UDim2,CloseButtonPosition:UDim2,CloseWhenScreenshotTaken:bool,ExperienceNameOverlayEnabled:bool,HideCoreGuiForCaptures:bool,HidePlayerGuiForCaptures:bool,OverlayFont:Font,UsernameOverlayEnabled:bool,Visible:bool;ScriptBuilder<Instance|||;SyncScriptBuilder<ScriptBuilder|||CompileTarget:CompileTarget,CoverageInfo:bool,DebugInfo:bool,PackAsSource:bool,RawBytecode:bool;ScriptChangeService<Instance||ScriptAdded,ScriptBeingRemoved,ScriptChanged,ScriptFullNameChanged,ScriptSourceChanged|;ScriptCloneWatcher<Instance|||;ScriptCloneWatcherHelper<Instance|||;ScriptCommitService<Instance|||;ScriptContext<Instance|AddCoreScriptLocal,CompressLuaApp,EnableCoverage,GetCoverageStats,GetLuauHeapInstanceReferenceReport,GetLuauHeapMemoryReport,ReportLuaRequireCount,SetTimeout|Error,ErrorDetailed|ScriptsDisabled:bool;ScriptDebugger<Instance|AddWatch,GetBreakpoints,GetGlobals,GetLocals,GetStack,GetUpvalues,GetWatchValue,GetWatches,SetBreakpoint,SetGlobal,SetLocal,SetUpvalue|BreakpointAdded,BreakpointRemoved,EncounteredBreak,Resuming,WatchAdded,WatchRemoved|CoreScriptIdentifier:string,CurrentLine:int,IsDebugging:bool,IsPaused:bool,Script:Instance,ScriptGuid:string;ScriptDebuggerService<Instance|AddBreakpoint,ClearBreakpoints,Evaluate,GetRootVariables,GetStackTrace,GetThreads,GetVariables,Pause,RemoveBreakpoint,SetExceptionBreakMode|Resumed|OnStopped;ScriptDocument<Instance|GetInternalUri,GetLine,GetLineCount,GetScript,GetSelectedText,GetSelection,GetSelectionEnd,GetSelectionStart,GetText,GetViewport,HasSelectedText,IsCommandBar,CloseAsync,EditTextAsync,ForceSetSelectionAsync,MultiEditTextAsync,RequestSetSelectionAsync,ReviewableTextEditsAsync|SelectionChanged,ViewportChanged|;ScriptEditorService<Instance|ClearUriScript,DeregisterAutocompleteCallback,DeregisterScriptAnalysisCallback,FindScriptDocument,ForceReloadSource,GetEditorSource,GetScriptDocuments,IsAutocompleteCallbackRegistered,IsScriptAnalysisCallbackRegistered,RegisterAutocompleteCallback,RegisterScriptAnalysisCallback,SetUriScript,StripComments,EditSourceAsyncWithRanges,OpenScriptDocumentAsync,OpenTemporaryDocumentAsync,UpdateSourceAsync|TextDocumentDidChange,TextDocumentDidClose,TextDocumentDidOpen|;ScriptProfilerService<Instance|ClientRequestData,ClientStart,ClientStop,DeserializeJSON,SaveScriptProfilingData,ServerRequestData,ServerStart,ServerStop|OnNewData,RequestData,SetProfilingState|;ScriptRegistrationService<Instance|GetSourceContainerByScriptGuid||;ScriptRuntime<Instance|||;ScriptScannerService<Instance||MoveScriptsCompleted,RequestKnownScriptGuids,RequestMoveSuspiciousScripts,SendKnownScriptGuids|;ScriptService<Instance|ResolveModulePath||;Selection<Instance|Add,AddFocusCallback,ClearTerrainSelectionHack,Get,Remove,Set,SetTerrainSelectionHack|SelectionChanged,SelectionChangedThisFrame|ActiveInstance:Instance,RenderMode:SelectionRenderMode,SelectionBoxThickness:float,SelectionLineThickness:int,SelectionThickness:float,ShowActiveInstanceHighlight:bool;SelectionHighlightManager<Instance|||;SensorBase<Instance|Sense|OnSensorOutputChanged|UpdateType:SensorUpdateType;AtmosphereSensor<SensorBase|||AirDensity:float,RelativeWindVelocity:Vector3;BuoyancySensor<SensorBase|||FullySubmerged:bool,TouchingSurface:bool;ControllerSensor<SensorBase|||;ControllerPartSensor<ControllerSensor|||HitFrame:CFrame,HitNormal:Vector3,LadderSearchHeight:float,LadderSearchOffset:float,SearchDistance:float,SensedMaterial:Material,SensedPart:BasePart,SensorMode:SensorMode;FluidForceSensor<SensorBase|EvaluateAsync||CenterOfPressure:Vector3,Force:Vector3,Torque:Vector3;SerializationService<Instance|DeserializeInstancesAsync,SerializeInstancesAsync||;ServerScriptService<Instance|||LoadStringEnabled:bool;ServerStorage<Instance|||;ServiceProvider<Instance|FindService,GetService,getService,service|Close,CloseLate,ServiceAdded,ServiceRemoving|;DataModel<ServiceProvider|getGameTime,SetPlaceId,SetUniverseId,BindToClose,DefineFastFlag,DefineFastInt,DefineFastString,GetEngineFeature,GetFastFlag,GetFastInt,GetFastString,GetJobsInfo,GetMessage,GetPioneerRootPlaceId,GetPioneerSource,GetPlaySessionId,GetRemoteBuildMode,IsContentLoaded,IsGearTypeAllowed,IsLoaded,IsPioneerApp,IsUniverseMetadataLoaded,Load,OpenLogsFolder,OpenScreenshotsFolder,OpenVideosFolder,SetFlagVersion,SetIsLoaded,Shutdown,SetFastFlagForTesting,SetFastIntForTesting,SetFastStringForTesting,GetObjects,GetObjectsAllOrNone,GetObjectsList,HttpGetAsync,HttpPostAsync,SavePlace,GetObjectsAsync,InsertObjectsAndJoinIfLegacyAsync|AllowedGearTypeChanged,GraphicsQualityChangeRequest,ItemChanged,Loaded,ScreenshotReady,ScreenshotSavedToAlbum,ServerLifecycleChanged,ServerLowMemoryWarning,ServerRestartScheduled,UniverseMetadataLoaded|CreatorId:int64,CreatorType:CreatorType,Environment:string,ForceR15:bool,GameId:int64,GearGenreSetting:GearGenreSetting,Genre:Genre,IsPioneerBuild:bool,IsSFFlagsLoaded:bool,JobId:string,MatchmakingType:MatchmakingType,PioneerSource:PioneerSource,PlaceId:int64,PlaceVersion:int,PrivateServerId:string,PrivateServerOwnerId:int64,VIPServerId:string,VIPServerOwnerId:int64,GameAvatarType:GameAvatarType,R15CollisionType:R15CollisionType,lighting:Instance,RunService:RunService,Workspace:Workspace,workspace:Workspace,OnClose;GenericSettings<ServiceProvider|||;GlobalSettings<GenericSettings|GetFFlag,GetFFlagOverrides,GetFFlags,GetFVariable,SetFFlagOverrides||;UserSettings<GenericSettings|IsUserFeatureEnabled,Reset,SaveState||;ServiceVisibilityService<Instance|SetServiceVisibilityPreference|ServiceVisibilityChanged|HiddenServices:BinaryString,VisibleServices:BinaryString;SessionCheckService<Instance|||;SessionService<Instance|AcquireContextFocus,GenerateSessionInfoString,GetBreadcrumbs,GetCreatedTimestampUtcMs,GetHistory,GetMetadata,GetRootSID,GetSessionID,GetSessionTag,IsContextFocused,ReleaseContextFocus,RemoveMetadata,RemoveSession,RemoveSessionsWithMetadataKey,ReplaceSession,SessionExists,SetMetadata,SetSession|SessionChanged|;SharedTableRegistry<Instance|GetSharedTable,SetSharedTable||;Sky<Instance|||CelestialBodiesShown:bool,MoonAngularSize:float,MoonTextureContent:Content,MoonTextureId:ContentId,SkyboxBackContent:Content,SkyboxBk:ContentId,SkyboxDn:ContentId,SkyboxDownContent:Content,SkyboxFrontContent:Content,SkyboxFt:ContentId,SkyboxLeftContent:Content,SkyboxLf:ContentId,SkyboxOrientation:Vector3,SkyboxRightContent:Content,SkyboxRt:ContentId,SkyboxUp:ContentId,SkyboxUpContent:Content,StarCount:int,SunAngularSize:float,SunTextureContent:Content,SunTextureId:ContentId;SlimAnimationDataEntity<Instance|||BoneParentIndices:BinaryString,EntityScale:double,EntitySource:Instance,Handle:int,IsSlimEnabled:bool,NumBones:int,RootIndex:int,SlimInstanceHashes:BinaryString,SlimReplicationTimestampSec:double;SlimAnimationReplicationService<Instance|||;SlimDebugSettings<Instance|GetAvailableTintModes,GetTintMode,SetTintMode||;SlimReplicationService<Instance||ServerUpdateEntities|;SlimService<Instance|||;Smoke<Instance|FastForward||Color:Color3,Enabled:bool,LocalTransparencyModifier:float,Opacity:float,RiseVelocity:float,Size:float,TimeScale:float,opacity_xml:float,riseVelocity_xml:float,size_xml:float;SmoothVoxelsUpgraderService<Instance|Cancel,Start|Status|;SnippetService<Instance|||;SocialService<Instance|GetPlayersByPartyId,HideSelfView,InvokeGameInvitePromptClosed,InvokeIrisInvite,InvokeIrisInvitePromptClosed,InvokeShareSheetClosed,PromptGameInvite,PromptPhoneBook,PromptRsvpToEventCompleted,ShowSelfView,SignalFeedbackSubmissionCompleted,SignalFeedbackSubmissionPermissionDenied,UpdatePlayerPartyData,CanSendCallInviteAsync,CanSendGameInviteAsync,GetEventRsvpStatusAsync,GetExperienceEventAsync,GetPartyAsync,GetUpcomingExperienceEventsAsync,PromptFeedbackSubmissionAsync,PromptLinkSharing,PromptLinkSharingAsync,PromptRsvpToEventAsync|CallInviteStateChanged,GameInvitePromptClosed,IrisInviteInitiated,OpenShareSheetWithLink,PhoneBookPromptClosed,PlayerPartyDataChanged,PromptInviteRequested,PromptIrisInviteRequested,SelfViewHidden,SelfViewVisible,ShareSheetClosed,ShowPromptFeedbackSubmission,ShowPromptFeedbackUnavailable,ShowPromptRsvpToEvent|OnCallInviteInvoked;Sound<Instance|GetUnderlyingAudioPlayer,Pause,Play,Resume,Stop,pause,play,stop|DidLoop,Ended,Loaded,Paused,Played,PlayingUpdatedFromClient,PlayingUpdatedFromServer,Resumed,Stopped,TimePositionUpdatedFromClient,TimePositionUpdatedFromServer,playbackActionSync|AcousticSimulationEnabled:bool,AssetRepresentation:AssetRepresentation,AudioContent:Content,ChannelCount:int,EmitterSize:float,IsLoaded:bool,IsPaused:bool,IsPlaying:bool,IsSpatial:bool,LoopRegion:NumberRange,Looped:bool,MaxDistance:float,MinDistance:float,Pitch:float,PlayOnRemove:bool,PlaybackLoudness:double,PlaybackRegion:NumberRange,PlaybackRegionsEnabled:bool,PlaybackSpeed:float,Playing:bool,PlayingReplicator:bool,RollOffGain:float,RollOffMaxDistance:float,RollOffMinDistance:float,RollOffMode:RollOffMode,SoundGroup:SoundGroup,SoundId:ContentId,TimeLength:double,TimePosition:double,TimePositionReplicator:double,UsageContextPermission:UsageContext,Volume:float,isPlaying:bool,xmlRead_MaxDistance_3:float,xmlRead_MinDistance_3:float;SoundEffect<Instance|||Enabled:bool,Priority:int;ChorusSoundEffect<SoundEffect|||Depth:float,Mix:float,Rate:float;CompressorSoundEffect<SoundEffect|||Attack:float,GainMakeup:float,Ratio:float,Release:float,SideChain:Instance,Threshold:float;CustomSoundEffect<SoundEffect|||;AssetSoundEffect<CustomSoundEffect|||;ChannelSelectorSoundEffect<CustomSoundEffect|||Channel:int;DistortionSoundEffect<SoundEffect|||Level:float;EchoSoundEffect<SoundEffect|||Delay:float,DryLevel:float,Feedback:float,WetLevel:float;EqualizerSoundEffect<SoundEffect|||HighGain:float,LowGain:float,MidGain:float;FlangeSoundEffect<SoundEffect|||Depth:float,Mix:float,Rate:float;PitchShiftSoundEffect<SoundEffect|||Octave:float;ReverbSoundEffect<SoundEffect|||DecayTime:float,Density:float,Diffusion:float,DryLevel:float,WetLevel:float;TremoloSoundEffect<SoundEffect|||Depth:float,Duty:float,Frequency:float;SoundGroup<Instance|||Volume:float;SoundService<Instance|BeginRecording,GetAudioApiByDefault,GetAudioInstances,GetInputDevice,GetInputDevices,GetListener,GetMixerTime,GetOutputDevice,GetOutputDevices,GetSoundMemoryData,InsertAsset,OpenAttenuationCurveEditor,OpenDirectionalCurveEditor,PlayLocalSound,SetAudioApiByDefault,SetInputDevice,SetListener,SetOutputDevice,SetRecordingDevice,SetSoundEnabled,EndRecording,GetRecordingDevices|AudioInstanceAdded,ClientLoggedEvent,DeviceListChanged,OpenAttenuationCurveEditorSignal,OpenAudioCompressorEditorSignal,OpenAudioEqualizerEditorSignal,OpenDirectionalCurveEditorSignal,RequestSttPlatformToken,SttPlatformToken|AcousticSimulationEnabled:bool,AmbientReverb:ReverbType,AudioApiByDefault:RolloutState,CharacterSoundsUseNewApi:RolloutState,DefaultListenerLocation:ListenerLocation,DiffractionEnabled:bool,DistanceFactor:float,DopplerScale:float,IsNewExpForAudioApiByDefault:bool,ListenerCFrame:CFrame,ListenerObject:Instance,ListenerType:ListenerType,OcclusionEnabled:bool,RespectFilteringEnabled:bool,ReverbEnabled:bool,RolloffScale:float,VolumetricAudio:VolumetricAudio;SoundShimService<Instance|||;Sparkles<Instance|FastForward||Color:Color3,Enabled:bool,LocalTransparencyModifier:float,SparkleColor:Color3,TimeScale:float;SpawnerService<Instance|||;StackFrame<Instance|||FrameId:int,FrameName:string,FrameType:DebuggerFrameType,Globals:DebuggerVariable,Line:int,Locals:DebuggerVariable,Populated:bool,Script:string,Upvalues:DebuggerVariable;StandalonePluginScripts<Instance|||;StandardQueue<Instance|BatchCommitAsync,PublishAsync,SubscribeAsync||;StartPageService<Instance|generateTempUrlInContentProvider,getDaysSinceFirstUserLogin,getLocalGamesFromRegistry,getRecentAPIGamesFromRegistry,getTempUrlInContentProvider,isTutorialBannerClosed,isTutorialPopupClosed,openLink,openLocalFile,openPlace,removeAPIGameFromRegistry,removeLocalFileFromRegistry,setTutorialBannerClosed,setTutorialPopupClosed,shouldShowMacOSDeprecationWarning,shouldShowWinOSDeprecationWarning,startTutorial|ImageImportedSignal,LocalGamesFromRegistryUpdatedSignal,RecentApiGamesFromRegistryUpdatedSignal|;StarterGear<Instance|||;StarterPack<Instance|||;StarterPlayer<Instance|ClearDefaults||AllowCustomAnimations:bool,AutoJumpEnabled:bool,AvatarJointUpgrade:RolloutState,AvatarJointUpgrade_SerializedRollout:RolloutState,CameraMaxZoomDistance:float,CameraMinZoomDistance:float,CameraMode:CameraMode,CharacterBreakJointsOnDeath:bool,CharacterJumpHeight:float,CharacterJumpPower:float,CharacterMaxSlopeAngle:float,CharacterUseJumpPower:bool,CharacterWalkSpeed:float,ClassicDeath:bool,CreateDefaultPlayerModule:bool,DevCameraOcclusionMode:DevCameraOcclusionMode,DevComputerCameraMovementMode:DevComputerCameraMovementMode,DevComputerMovementMode:DevComputerMovementMode,DevTouchCameraMovementMode:DevTouchCameraMovementMode,DevTouchMovementMode:DevTouchMovementMode,EnableDynamicHeads:LoadDynamicHeads,EnableMouseLockOption:bool,GameSettingsAssetIDFace:int64,GameSettingsAssetIDHead:int64,GameSettingsAssetIDLeftArm:int64,GameSettingsAssetIDLeftLeg:int64,GameSettingsAssetIDPants:int64,GameSettingsAssetIDRightArm:int64,GameSettingsAssetIDRightLeg:int64,GameSettingsAssetIDShirt:int64,GameSettingsAssetIDTeeShirt:int64,GameSettingsAssetIDTorso:int64,GameSettingsAvatar:GameAvatarType,GameSettingsR15Collision:R15CollisionType,GameSettingsScaleRangeBodyType:NumberRange,GameSettingsScaleRangeHead:NumberRange,GameSettingsScaleRangeHeight:NumberRange,GameSettingsScaleRangeProportion:NumberRange,GameSettingsScaleRangeWidth:NumberRange,HealthDisplayDistance:float,LoadCharacterAppearance:bool,LoadCharacterLayeredClothing:LoadCharacterLayeredClothing,LuaCharacterController:CharacterControlMode,NameDisplayDistance:float,PlaceAvatarRules:Instance,PlayerModuleStatus:int,UserEmotesEnabled:bool;StarterPlayerScripts<Instance|||;StarterCharacterScripts<StarterPlayerScripts|||;StartupMessageService<Instance|ExecuteActionButton,GetStartupMessage||;StateMachineDefinition<Instance|||NodeId:string;StateMachineTransitionDefinition<Instance|||From:Instance,Priority:int,To:Instance,TransitionId:string;Stats<Instance|GetBrowserTrackerId,GetHarmonyQualityLevel,GetMemoryCategoryNames,GetMemoryUsageMbAllCategories,GetMemoryUsageMbForTag,GetTotalMemoryUsageMb,ResetHarmonyMemoryTarget,SetHarmonyMemoryTarget,GetPaginatedMemoryByTexture||ContactsCount:int,DataReceiveKbps:float,DataSendKbps:float,FrameTime:float,HeartbeatTime:float,HeartbeatTimeMs:float,InstanceCount:int,MemoryTrackingEnabled:bool,MovingPrimitivesCount:int,PhysicsReceiveKbps:float,PhysicsSendKbps:float,PhysicsStepTime:float,PhysicsStepTimeMs:float,PrimitivesCount:int,RenderCPUFrameTime:float,RenderGPUFrameTime:float,SceneDrawcallCount:int,SceneTriangleCount:int,ShadowsDrawcallCount:int,ShadowsTriangleCount:int,UI2DDrawcallCount:int,UI2DTriangleCount:int,UI3DDrawcallCount:int,UI3DTriangleCount:int;StatsItem<Instance|GetValue,GetValueString||DisplayName:string;RunningAverageItemDouble<StatsItem|||;RunningAverageItemInt<StatsItem|||;RunningAverageTimeIntervalItem<StatsItem|||;TotalCountTimeIntervalItem<StatsItem|||;StopWatchReporter<Instance|FinishTask,SendReport,StartTask||;Studio<Instance|GetAvailableThemes|ThemeChanged|ActionOnAutoResumeSync:ActionOnAutoResumeSync,ActionOnStopSync:ActionOnStopSync,AutoResumeSyncOnPlaceOpen:bool,AutoUpdateEnabled:bool,AutocompleteAcceptanceBehavior:CompletionAcceptanceBehavior,CameraAltLeftMouseToRotate:bool,CameraKeyMoveSmoothing:bool,CameraMouseMultiplier:float,CameraNavigationModel:CameraNavigationModel,CameraRotateShiftFactor:float,CameraShiftFactor:float,CameraTweenFocus:bool,CameraZoomToMousePosition:bool,CommandBarEnterExec:bool,CommandBarFont:QFont,CommandBarHistoryLen:int,CommandBarLocalState:bool,DefaultInstancesDir:QDir,DefaultScriptSyncFileType:DefaultScriptSyncFileType,DeprecatedObjectsShown:bool,DisplayLanguage:string,DraggerActiveColor:Color3,DraggerLengthFactor:float,DraggerMajorGridIncrement:int,DraggerMaxSoftSnaps:int,DraggerPassiveColor:Color3,DraggerScaleFactor:float,DraggerShowAxisTicks:bool,DraggerShowDraggedPoint:bool,DraggerShowHoverRuler:bool,DraggerShowMeasurement:bool,DraggerShowNegativeAxes:bool,DraggerShowPlanes:bool,DraggerShowTargetSnap:bool,DraggerShowTrackball:bool,DraggerShowWhileDragging:bool,DraggerSoftSnapMarginFactor:float,DraggerSummonMarginFactor:float,DraggerTiltRotateDuration:float,EnableCodeAssist:bool,EnableFindOnType:bool,EnableIndentationRulers:bool,EnableOnTypeAutocomplete:bool,EnableOvertypeMode:bool,EnableSelectionTooltips:bool,EnableStudioStreaming:bool,ExternalEditorMode:ExternalEditorMode,ExternalEditorSelection:QDir,Font:QFont,HintColor:Color3,IconOverrideDir:QDir,IndentationRulerColor:Color3,InformationColor:Color3,LargeFileLineCountThreshold:int,LargeFileThreshold:int,LoadAllBuiltinPluginsInRunModes:bool,LoadInternalPlugins:bool,LoadUserPluginsInRunModes:bool,LocalAssetsFolder:QDir,LuaDebuggerEnabled:bool,LuaDebuggerEnabledAtStartup:bool,MaxFindReplaceAllResults:int,PermissionLevelShown:PermissionLevelShown,PluginDebuggingEnabled:bool,PluginsDir:QDir,PreferredTextSize:PreferredTextSize,ReloadBuiltinPluginsOnChange:bool,ReloadLocalPluginsOnChange:bool,ReviewableChangeAddedTextColor:Color3,ReviewableChangeRemovedTextColor:Color3,Rulers:string,RuntimeUndoBehavior:RuntimeUndoBehavior,ScriptEditorMenuBorderColor:Color3,ScriptEditorShouldShowPluginMethods:bool,ScriptTimeoutLength:int,ShowCorePackagesInExplorer:bool,Theme:Instance,TypeColor:Color3,UseDefaultExternalEditor:bool,VAxisColor:Color3,XAxisColor:Color3,YAxisColor:Color3,ZAxisColor:Color3;StudioAssetService<Instance|ConvertToPackageUpload,FireOnUGCSubmitCompleted,PublishPackage,ResolveSaveInstanceToRoblox,ShowSaveToRoblox,UpdatePublishedPackage,AutoSetupAvatarAsync,AutoSetupSerializedAvatarAsync,CancelAutoSetupAvatarAsync,DEPRECATED_SerializeInstances,PromptSaveInstanceToRobloxAsync,RequestAvatarAutosetupAsync,SerializeInstances|OnConvertToPackageResult,OnPromptSaveInstanceToRobloxAsync,OnPublishPackageResult,OnSaveToRoblox,OnUGCSubmitCompleted|;StudioAttachment<Instance|||AutoHideParent:bool,IsArrowVisible:bool,Offset:Vector2,SourceAnchorPoint:Vector2,TargetAnchorPoint:Vector2;StudioCallout<Instance|SetOnNextClicked||AnchorPoint:Vector2,IsArrowVisible:bool,IsNextVisible:bool,RowName:string,Text:string,Title:string;StudioCameraService<Instance|InFocusMode,InterpolateView,SetFocusLock|FocusStateChanged,OnMouseCaptureBegin,OnMouseCaptureEnd,PointFocused,ShowCameraSpeed,UpdateUI|FocusDistance:float,LockCameraSpeed:bool,LoggingEnabled:bool;StudioCaptureService<Instance|CanCaptureScreenshot,CapturePluginGui,CaptureScreenshot,RequestScreenshotPermissionAsync||;StudioData<Instance|||EnableScriptCollabByDefaultOnLoad:bool;StudioDeviceEmulatorService<Instance|EmulatePCDeviceWithResolution,GetCurrentDeviceId,GetCurrentOrientation,HasDeviceWithId,SetCurrentDeviceId,SetCurrentOrientation|CurrentDeviceIdChanged,OrientationChanged|;StudioDeviceSimulatorService<Instance|CreateDeviceAsync,GetDeviceAsync,GetDeviceInfoAsync,GetDeviceListAsync,GetOrientationAsync,GetPixelDensityAsync,GetResolutionAsync,GetScalingModeAsync,RemoveDeviceAsync,SetDeviceAsync,SetOrientationAsync,SetPixelDensityAsync,SetResolutionAsync,SetScalingModeAsync,StopSimulationAsync,UpdateDeviceAsync|ConfigurationChanged|;StudioObjectBase<Instance|||;StudioWidget<StudioObjectBase|Resize,SetFixedSize,SetMinSize||;StudioPublishService<Instance|ClearUploadNames,CloseAfterPublish,PublishAs,PublishThenTurnOnTeamCreate,RefreshDocumentDisplayName,RegisterPublishHold,SaveOrPublishPlaceToRobloxIsCanceled,SetTeamCreateOnPublishInfo,SetUniverseDisplayName,SetUploadNames,ShowSaveOrPublishPlaceToRoblox|GameNameUpdated,GamePublishCancelled,GamePublishFinished,OnPublishAttempt,OnSaveOrPublishPlaceToRoblox|PublishLocked:bool;StudioScreenshotCapture<Instance|GetBuffer,GetErrors,ScaleAsync||BufferFormat:StudioCaptureScreenshotFormat,BufferStatus:StudioCaptureBufferStatus,OriginalSize:Vector2,Position:Vector2,Resolution:Vector2,UICaptureMode:UICaptureMode;StudioScriptDebugEventListener<Instance|||;StudioSdkService<Instance|GetSdk,SetSdk||;StudioService<Instance|AnimationIdSelected,CopyToClipboard,GetBadgeConfigureUrl,GetBadgeUploadUrl,GetClassIcon,GetPlaceIsPersistedToCloud,GetResourceByCategory,GetStartupAssetId,GetStartupPluginId,GetTermsOfUseUrl,GetUserId,GizmoRaycast,HasInternalPermission,IsPluginInstalled,IsPluginUpToDate,OpenInBrowser_DONOTUSE,SetPluginEnabled,ShowPublishToRoblox,UninstallPlugin,UpdatePluginManagement,PromptImportFile,PromptImportFileAsync,PromptImportFiles,PromptImportFilesAsync,TryInstallPlugin|OnImportFromRoblox,OnOpenGameSettings,OnOpenManagePackagePlugin,OnPluginInstalledFromToolbox,OnPluginInstalledFromWeb,OnPublishAsPlugin,OnSaveToRoblox,PromptTransformPluginCheckEnable,SaveLocallyAsComplete|ActiveScript:Instance,AlignDraggedObjects:bool,DraggerSolveConstraints:bool,DrawConstraintsOnTop:bool,GridSize:float,HoverInstance:Instance,InstalledPluginData:string,PivotSnapToGeometry:bool,RotateIncrement:float,Secrets:string,ShowConstraintDetails:bool,ShowWeldDetails:bool,StudioLocaleId:string,UseLocalSpace:bool;StudioTestService<Instance|AddPlayers,CanLeaveTest,EndTest,GetTestArgs,LeaveTest,ExecuteMultiplayerTestAsync,ExecutePlayModeAsync,ExecuteRunModeAsync||EditModeActive:bool;StudioTheme<Instance|GetColor||;StudioUserService<Instance|||IsLoggedIn:bool;StudioWidgetsService<Instance|ApplyFillInBox,ApplyHighlight,ApplyShadows,ApplySpotlight,GetWidgetFromLabel,GetWidgetFromPluginGui,HideSpotlight||;StyleBase<Instance|GetStyleRules,InsertStyleRule,SetStyleRules|StyleRulesChanged|;StyleRule<StyleBase|GetDefaultPropertyTransition,GetProperties,GetPropertiesResolved,GetProperty,GetPropertyResolved,GetPropertyTransitions,SetDefaultPropertyTransition,SetProperties,SetProperty,SetPropertyTransition,SetPropertyTransitions|StyleRulePropertyChanged|Index:int,Priority:int,PropertiesSerialize:BinaryString,PropertyTransitionsSerialize:BinaryString,Selector:string,SelectorError:string;StyleSheet<StyleBase|GetDerives,SetDerives||;StyleDerive<Instance|||Index:int,Priority:int,StyleSheet:StyleSheet;StyleLink<Instance|||StyleSheet:StyleSheet;StyleQuery<Instance|GetCondition,GetConditions,SetCondition,SetConditions||AspectRatioRange:NumberRange,ConditionsSerialize:BinaryString,IsActive:bool,MaxSize:Vector2,MinSize:Vector2,PreferredInput:PreferredInput,PreferredTextSize:PreferredTextSize,ReducedMotionEnabled:bool,ViewportDisplaySize:DisplaySize;StylingService<Instance|GetAppliedStyles,GetStyleInfo,GetStyleSheetDerivesChain,GetStyleSheetInfo,UpdateUnitTestOnly||;SurfaceAppearance<Instance|||AlphaMode:AlphaMode,Color:Color3,ColorMap:ContentId,ColorMapContent:Content,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,ResampleMode:ResamplerMode,RoughnessMap:ContentId,RoughnessMapContent:Content,TexturePack:ContentId,TexturePackContent:Content;SystemThemeService<Instance|getSystemTheme,isSystemThemeAvailable,setClassicThemeActive,setTheme,getSystemThemeAsync|OnLuaThemeUpdated|;TaskScheduler<Instance|||SchedulerDutyCycle:double,SchedulerRate:double,ThreadPoolConfig:ThreadPoolConfig,ThreadPoolSize:int;Team<Instance|GetPlayers|PlayerAdded,PlayerRemoved|AutoAssignable:bool,AutoColorCharacters:bool,ChildOrder:int,Score:int,TeamColor:BrickColor;TeamCreateData<Instance|||InitialCameraCFrame:CFrame;TeamCreatePublishService<Instance||TeamCreateErrorStatus,TeamCreatePlaceUploadRequest,TeamCreatePlaceUploadResponse|;TeamCreateService<Instance|CloseGameIfUserDoesntHavePerms||;Teams<Instance|GetTeams,RebalanceTeams||;TelemetryService<Instance|LogCounter,LogDurationEvent,LogDurationEventWithTimestamp,LogEvent,LogStat||;TeleportAsyncResult<Instance|||PrivateServerId:string,ReservedServerAccessCode:string;TeleportOptions<Instance|GetTeleportData,SetTeleportData||ReservedServerAccessCode:string,ServerInstanceId:string,ShouldReserveServer:bool;TeleportService<Instance|Block,GetArrivingTeleportGui,GetLocalPlayerTeleportData,GetTeleportSetting,GetThirdPartyTeleportInfo,PromptExperienceDetailsCompleted,SetTeleportGui,SetTeleportSetting,Teleport,TeleportCancel,TeleportReconnect,TeleportToPlaceInstance,TeleportToPrivateServer,TeleportToSpawnByName,TeleportTrustedBackForth,TeleportTrustedBackHistory,TeleportedPlacesBackHistory,TeleportedUniversesBackHistory,GetPlayerPlaceInstanceAsync,PromptExperienceDetailsAsync,ReserveServer,ReserveServerAsync,TeleportAsync,TeleportPartyAsync,UnblockAsync|LocalPlayerArrivedFromTeleport,MenuTeleportAttempt,OpenExperienceDetailsPrompt,ReconnectTeleportInitFailed,SendVIPData,TeleportInProgress,TeleportInitFailed,TeleportInitFailedInternal|CustomizedTeleportUI:bool;TemporaryCageMeshProvider<Instance|||;TemporaryScriptService<Instance|||;TerrainDetail<Instance|||ColorMap:ContentId,ColorMapContent:Content,EmissiveMaskContent:Content,EmissiveStrength:float,EmissiveTint:Color3,Face:TerrainFace,MaterialPattern:MaterialPattern,MetalnessMap:ContentId,MetalnessMapContent:Content,NormalMap:ContentId,NormalMapContent:Content,RoughnessMap:ContentId,RoughnessMapContent:Content,StudsPerTile:float,TexturePack:ContentId,TexturePackContent:Content;TerrainRegion<Instance|ApplyTransform,ApplyTransformSubregion,ConvertToSmooth,GetRegionWireframe||ExtentsMax:Vector3int16,ExtentsMin:Vector3int16,GridV3:BinaryString,IsSmooth:bool,SizeInCells:Vector3,SmoothGrid:BinaryString;TestCase<Instance|Assert,AssertLegacy,EndTest,Message,Require,RequireLegacy||;TestService<Instance|Check,Checkpoint,ConvertSlimAcrToObj,CreateAndSavePropertySet,CreateExtraAssetsFileFromPropertySet,Done,Error,Fail,FetchExtraAssets,GetTestControlSchema,GetTestControls,Message,RegisterTest,RegisterTestLegacy,Require,ResetTestControl,ScopeTime,SetTestControl,SignalProfilingCapture,SignalProfilingStart,SignalProfilingStop,StartTestSession,StopTestSession,TakeSnapshot,TranscodePropertySet,Warn,getTestSessionProviderStats,isFeatureEnabled,CaptureScreenshotAsync,FetchTestControlsAsync,RequestValidationAsync,Run,RunAsync,StartVideoCaptureAsync,StopVideoCaptureAsync|ServerCollectConditionalResult,ServerCollectResult|AutoRuns:bool,Description:string,ErrorCount:int,ExecuteWithStudioRun:bool,Is30FpsThrottleEnabled:bool,IsPhysicsEnvironmentalThrottled:bool,IsSleepAllowed:bool,NumberOfPlayers:int,SimulateSecondsLag:double,TestCount:int,ThrottlePhysicsToRealtime:bool,Timeout:double,WarnCount:int;TextBoxService<Instance|||;TextChannel<Instance|DisplaySystemMessage,SetDirectChatRequester,AddUserAsync,SendAsync,SendDictatedSpeechAsync,SendInternalAsync,SendPresetAsync|MessageReceived|AddPlayersOnJoin:bool,DirectChatRequester:Player,IsDefaultTextChannel:bool,OnIncomingMessage,ShouldDeliverCallback;TextChatCommand<Instance||Triggered|AutocompleteVisible:bool,Enabled:bool,PrimaryAlias:string,SecondaryAlias:string;TextChatConfigurations<Instance|||;BubbleChatConfiguration<TextChatConfigurations|||AdorneeName:string,BackgroundColor3:Color3,BackgroundTransparency:double,BubbleDuration:float,BubblesSpacing:float,Enabled:bool,Font:Font,FontFace:Font,LocalPlayerStudsOffset:Vector3,MaxBubbles:float,MaxDistance:float,MinimizeDistance:float,TailVisible:bool,TextColor3:Color3,TextSize:int64,VerticalStudsOffset:float;ChannelTabsConfiguration<TextChatConfigurations|SetAbsolutePosition,SetAbsoluteSize||AbsolutePosition:Vector2,AbsoluteSize:Vector2,BackgroundColor3:Color3,BackgroundTransparency:double,Enabled:bool,FontFace:Font,HoverBackgroundColor3:Color3,SelectedTabTextColor3:Color3,TextColor3:Color3,TextSize:int64,TextStrokeColor3:Color3,TextStrokeTransparency:double;ChatInputBarConfiguration<TextChatConfigurations|||AbsolutePosition:Vector2,AbsolutePositionWrite:Vector2,AbsoluteSize:Vector2,AbsoluteSizeWrite:Vector2,AutocompleteEnabled:bool,BackgroundColor3:Color3,BackgroundTransparency:double,Enabled:bool,FontFace:Font,IsFocused:bool,IsFocusedWrite:bool,KeyboardKeyCode:KeyCode,PlaceholderColor3:Color3,TargetTextChannel:TextChannel,TextBox:TextBox,TextColor3:Color3,TextSize:int64,TextStrokeColor3:Color3,TextStrokeTransparency:double;ChatWindowConfiguration<TextChatConfigurations|DeriveNewMessageProperties||AbsolutePosition:Vector2,AbsolutePositionWrite:Vector2,AbsoluteSize:Vector2,AbsoluteSizeWrite:Vector2,BackgroundColor3:Color3,BackgroundTransparency:double,Enabled:bool,FontFace:Font,HeightScale:float,HorizontalAlignment:HorizontalAlignment,TextChannelDisplayMode:TextChannelDisplayMode,TextColor3:Color3,TextSize:int64,TextStrokeColor3:Color3,TextStrokeTransparency:double,VerticalAlignment:VerticalAlignment,WidthScale:float;TextChatMessage<Instance|||BubbleChatMessageProperties:BubbleChatMessageProperties,ChatActionType:string,ChatWindowMessageProperties:ChatWindowMessageProperties,ForModeration:bool,IsHiddenMessage:bool,MessageId:string,Metadata:string,OriginalText:string,PrefixText:string,PrefixTextInternal:string,PresetChatVersion:string,PresetId:string,RewrittenText:string,RewrittenTranslation:string,Status:TextChatMessageStatus,Text:string,TextChannel:TextChannel,TextInternal:string,TextSource:TextSource,Timestamp:DateTime,Translation:string,TranslationInternal:string,Verified:bool,WasRewritten:bool;TextChatMessageProperties<Instance|||PrefixText:string,Text:string,Translation:string;BubbleChatMessageProperties<TextChatMessageProperties|||BackgroundColor3:Color3,BackgroundTransparency:double,FontFace:Font,TailVisible:bool,TextColor3:Color3,TextSize:int64;ChatWindowMessageProperties<TextChatMessageProperties|||FontFace:Font,PrefixTextProperties:ChatWindowMessageProperties,TextColor3:Color3,TextSize:int,TextStrokeColor3:Color3,TextStrokeTransparency:double;TextChatService<Instance|DisplayBubble,GetTextChannelWindows,HasAllocatedUniverseChatContext,IsProtectedChatEnabled,SendEnableChatButtonClicked,SendEnableChatButtonShown,SendExpChatLoadSuccess,SendExpChatMessageClientRendered,SendExpChatWindowScroll,SendExpChatWindowStatusChange,SendTextChatCommandClientSent,setModerationModeEnabled,CanUserChatAsync,CanUsersChatAsync,CanUsersDirectChatAsync,CanUsersWhisperAsync,GetChatGroupsAsync,GetChatableUserCountAsync,GetPresetsAsync,OnUserChatSettingUpdateAsync,SendDictatedSpeechUniverseChatAsync,SendUniverseChatMessageAsync,SendUniverseChatPresetAsync|BubbleDisplayed,ChatActionReceived,ClientToServerChatableUserCountRequestSignal,ClientToServerMessageReplicateSignalV2,ClientToServerMessageReplicateSignalV3,ClientToServerMessageReplicateSignalV4,ClientToServerUniverseChatMessageSignalV1,ClientToServerUniverseChatMessageSignalV2,ExpChatFeatureValueChanged,MessageReceived,OnIncomingMessageEvent,OnUserChatSettingUpdateServer,SendingMessage,SendingUniverseChatMessage,ServerToClientChatActionReplicateSignal,ServerToClientChatableUserCountResponseSignal,ServerToClientMessageReplicateSignal,ServerToClientMessageReplicateSignalV2,ServerToClientPresetChatConfigChangedSignal,ServerToClientPresetChatUserAccessChangedSignal,ServerToClientUniverseChatChannelAllocatedSignalV1,ServerToClientUniverseChatMessageSignalV1,TextChannelWindowAdded,TextChannelWindowRemoved,UniverseChatChannelAllocated,UniverseChatMessageReceived,UserMessageIntentSent,UserMessageIntentSentRemote|ChatTranslationEnabled:bool,ChatTranslationFTUXShown:bool,ChatTranslationToggleEnabled:bool,ChatVersion:ChatVersion,CreateDefaultCommands:bool,CreateDefaultTextChannels:bool,HasSeenDeprecationDialog:bool,IsLegacyChatDisabled:bool,PlatformIntegratedChat:RolloutState,OnBubbleAdded,OnChatWindowAdded,OnIncomingMessage;TextFilterResult<Instance|GetChatForUserAsync,GetNonChatStringForBroadcastAsync,GetNonChatStringForUserAsync||;TextFilterTranslatedResult<Instance|GetTranslationForLocale,GetTranslations||SourceLanguage:string,SourceText:TextFilterResult;TextGenerator<Instance|GenerateTextAsync||Seed:int,SystemPrompt:string,Temperature:float,TopP:float;TextService<Instance|GetFontMemoryData,GetTextSize,SetResolutionScale,FilterAndTranslateStringAsync,FilterStringAsync,GetFamilyInfoAsync,GetTextBoundsAsync,GetTextSizeOffsetAsync||;TextSource<Instance|||CanSend:bool,DisplayName:string,UserId:int64,UserIdReplicated:int64,Username:string;TextureGenerationPartGroup<Instance|GetInstances,GetMeshIdsHash||;TextureGenerationService<Instance|CancelGenerationRequest,CreatePartGroup,GenerateTexture,PreviewTexture,GetQuotasAsync|GenerationNotificationSignal,PreviewNotificationSignal|;TextureGenerationUnwrappingRequest<Instance|ApplyToDataModel,GetPartGroup||;ThirdPartyUserService<Instance|GetUserPlatformName,GetVoiceChatRestrictionStatus,HaveActiveUser,IsAccountSwitchingSupported,IsChatRestrictionSupported,IsSingleSignOnSupported,ShowAccountPicker|ActiveUserSignedOut|FriendCommunicationRestrictionStatus:ChatRestrictionStatus,HasActiveUser:bool,VoiceChatRestrictionStatus:ChatRestrictionStatus;ThreadState<Instance|GetFrame||FrameCount:int,Populated:bool,ThreadId:int,ThreadName:string;TimerService<Instance|||;ToastNotificationService<Instance|HideNotification,ShowNotification||;TouchInputService<Instance|||;TouchTransmitter<Instance|||;TraceRouteService<Instance|||;TracerService<Instance|FinishSpan,StartSpan||;TrackerLodController<Instance|getExtrapolation,getVideoLod,isAudioEnabled,isVideoEnabled|UpdateState|AudioMode:TrackerLodFlagMode,VideoExtrapolationMode:TrackerExtrapolationFlagMode,VideoLodMode:TrackerLodValueMode,VideoMode:TrackerLodFlagMode;TrackerStreamAnimation<Instance|||;Trail<Instance|Clear|OnClearRequested|Attachment0:Attachment,Attachment1:Attachment,Brightness:float,Color:ColorSequence,Enabled:bool,FaceCamera:bool,Lifetime:float,LightEmission:float,LightInfluence:float,LocalTransparencyModifier:float,MaxLength:float,MinLength:float,Texture:ContentId,TextureContent:Content,TextureLength:float,TextureMode:TextureMode,Transparency:NumberSequence,WidthScale:NumberSequence;Translator<Instance|FormatByKey,RobloxOnlyTranslate,Translate||LocaleId:string;TutorialService<Instance|GetMainViewSessionId,HasUserCompletedTutorial,HideWidgets,PromptClosePlace,SetTutorialCompletionStatus,ShouldLaunchTutorial,ShowWidgets||;TweenBase<Instance|Cancel,Pause,Play|Completed|PlaybackState:PlaybackState;Tween<TweenBase|||Instance:Instance,TweenInfo:TweenInfo;TweenService<Instance|Create,GetValue,SmoothDamp||;UGCAvatarService<Instance|||;UGCValidationService<Instance|AreInstanceTreesEquivalent,CalculateAverageEditableCageMeshDistance,CalculateEditableMeshInsideMeshPercentage,CalculateEditableMeshModifiedCageBoundingBox,CalculateEditableMeshNumModifiedCageUVsInSet,CalculateEditableMeshTotalSurfaceArea,CalculateEditableMeshUniqueUVCount,CheckEditableMeshInCameraFrustum,CreateEditableImageFromBinaryStringRobloxOnly,CreateEditableMeshFromBinaryStringRobloxOnly,GetBoundingBoxManipulationData,GetDynamicHeadEditableMeshInactiveControls,GetEditableCagingRelevancyMetrics,GetEditableImageSize,GetEditableMeshMaxNearbyVerticesCollisions,GetEditableMeshSkinningTransferJointsInfo,GetEditableMeshTriCount,GetEditableMeshVertColors,GetEditableMeshVerticesSimilarityRate,GetEditableMeshVerts,GetExpectedTposeRotation,GetFacsDrivenJointNamesFromEditableMesh,GetLayeredClothingPostDeformationSize,GetMaximalJointDistancesWithinFacs,GetMinAndMaxMeshSizeAcrossAllFacs,GetPropertyValue,GetSkinnedJointNamesFromEditableMesh,IsEditableMeshNumCoplanarIntersectionsOverLimit,RegisterAlternateMesh,RegisterUGCValidationFunction,ReportUGCValidationCounter,ReportUGCValidationFailureTelemetry,ReportUGCValidationTelemetry,ResetCollisionFidelity,ResetCollisionFidelityWithEditableMeshDataLua,SetMeshIdBlocking,ValidateDynamicHeadEditableMesh,ValidateEditableMeshCageMeshIntersection,ValidateEditableMeshCageNonManifoldAndHoles,ValidateEditableMeshCageUVCoincident,ValidateEditableMeshCageUVTriangleArea,ValidateEditableMeshFacialBounds,ValidateEditableMeshFacialExpressiveness,ValidateEditableMeshFullBodyCageDeletion,ValidateEditableMeshMisMatchUV,ValidateEditableMeshOverlappingVertices,ValidateEditableMeshTriangleArea,ValidateEditableMeshTriangles,ValidateEditableMeshUVDuplicates,ValidateEditableMeshUVSpace,ValidateEditableMeshUVValuesInReference,ValidateEditableMeshUniqueUVCount,ValidateEditableMeshVertColors,ValidateHSRMeshIds,ValidateLeaderSkinnedVertsNearCageIslands,ValidatePartBBoxAfterFullFacs,ValidatePropertiesSensible,ValidateSkinnedEditableMesh,CalculateBodyMaxCageDistance,CanLoadAsset,CreateEditableImageOriginalSizeAsync,DoesMeshHaveSkinningData,DoesSurfaceAppearanceMatchTexturePackAsync,FetchAssetWithFormat,GetLayeredClothingPostDeformationSizeAsync,GetMeshDataBinaryString,GetMeshVerts,GetSerializedSizeExcludingCollisionAsync,IsDeformedLayeredClothingOutOfRenderBounds||;UIBase<Instance|||;UIComponent<UIBase|||;UIConstraint<UIComponent|||;UIAspectRatioConstraint<UIConstraint|||AspectRatio:float,AspectType:AspectType,DominantAxis:DominantAxis;UISizeConstraint<UIConstraint|||MaxSize:Vector2,MinSize:Vector2;UITextSizeConstraint<UIConstraint|||MaxTextSize:int,MinTextSize:int;UICorner<UIComponent|||BottomLeftRadius:UDim,BottomRightRadius:UDim,CornerRadius:UDim,TopLeftRadius:UDim,TopRightRadius:UDim;UIDragDetector<UIComponent|AddConstraintFunction,GetReferencePosition,GetReferenceRotation,SetDragStyleFunction|DragContinue,DragEnd,DragStart|ActivatedCursorIcon:ContentId,ActivatedCursorIconContent:Content,BoundingBehavior:UIDragDetectorBoundingBehavior,BoundingUI:GuiBase2d,CursorIcon:ContentId,CursorIconContent:Content,DragAxis:Vector2,DragRelativity:UIDragDetectorDragRelativity,DragRotation:float,DragSpace:UIDragDetectorDragSpace,DragStyle:UIDragDetectorDragStyle,DragUDim2:UDim2,Enabled:bool,MaxDragAngle:float,MaxDragTranslation:UDim2,MinDragAngle:float,MinDragTranslation:UDim2,ReferenceUIInstance:GuiObject,ResponseStyle:UIDragDetectorResponseStyle,SelectionModeDragSpeed:UDim2,SelectionModeRotateSpeed:float,UIDragSpeedAxisMapping:UIDragSpeedAxisMapping;UIFlexItem<UIComponent|||FlexMode:UIFlexMode,GrowRatio:float,ItemLineAlignment:ItemLineAlignment,ShrinkRatio:float;UIGradient<UIComponent|||Color:ColorSequence,Enabled:bool,Offset:Vector2,Rotation:float,Scale:float,TileMode:GradientTileMode,Transparency:NumberSequence,Type:GradientType;UILayout<UIComponent|||;UIGridStyleLayout<UILayout|ApplyLayout,SetCustomSortFunction||AbsoluteContentSize:Vector2,FillDirection:FillDirection,HorizontalAlignment:HorizontalAlignment,SortOrder:SortOrder,VerticalAlignment:VerticalAlignment;UIGridLayout<UIGridStyleLayout|||AbsoluteCellCount:Vector2,AbsoluteCellSize:Vector2,CellPadding:UDim2,CellSize:UDim2,FillDirectionMaxCells:int,StartCorner:StartCorner;UIListLayout<UIGridStyleLayout|||HorizontalFlex:UIFlexAlignment,HorizontalPadding:UDim,ItemLineAlignment:ItemLineAlignment,Padding:UDim,VerticalFlex:UIFlexAlignment,VerticalPadding:UDim,Wraps:bool;UIPageLayout<UIGridStyleLayout|JumpTo,JumpToIndex,Next,Previous|PageEnter,PageLeave,Stopped|Animated:bool,Circular:bool,CurrentPage:GuiObject,EasingDirection:EasingDirection,EasingStyle:EasingStyle,GamepadInputEnabled:bool,Padding:UDim,ScrollWheelInputEnabled:bool,TouchInputEnabled:bool,TweenTime:float;UITableLayout<UIGridStyleLayout|||FillEmptySpaceColumns:bool,FillEmptySpaceRows:bool,MajorAxis:TableMajorAxis,Padding:UDim2;UIPadding<UIComponent|||PaddingBottom:UDim,PaddingLeft:UDim,PaddingRight:UDim,PaddingTop:UDim;UIScale<UIComponent|||Scale:float;UIShadow<UIComponent|||BlurRadius:UDim,Color:Color3,Enabled:bool,Inset:bool,Mode:ApplyShadowMode,Offset:UDim2,ShowBehindParent:bool,Spread:UDim2,Transparency:float,ZIndex:int;UIStroke<UIComponent|||ApplyStrokeMode:ApplyStrokeMode,BorderOffset:UDim,BorderStrokePosition:BorderStrokePosition,Color:Color3,Enabled:bool,LineJoinMode:LineJoinMode,StrokeSizingMode:StrokeSizingMode,Thickness:float,Transparency:float,ZIndex:int;UIDragDetectorService<Instance|||;UniqueIdLookupService<Instance|GetInstanceByRfc4122String,GetOrCreateUniqueId,GetOrCreateUniqueIdRemoteCommand||;UnvalidatedAssetService<Instance|AppendTempAssetId,AppendVantagePoint,UpgradeTempAssetId||CachedData:string;UserGameSettings<Instance|GetCameraYInvertValue,GetDefaultFramerateCap,GetOnboardingCompleted,GetTutorialState,InFullScreen,InStudioMode,ResetOnboardingCompleted,SetCameraYInvertVisible,SetGamepadCameraSensitivityVisible,SetOnboardingCompleted,SetTutorialState|FullscreenChanged,PerformanceStatsVisibleChanged,StudioModeChanged|AllTutorialsDisabled:bool,BadgeVisible:bool,CameraMode:CustomCameraMode,CameraYInverted:bool,ChatTranslationEnabled:bool,ChatTranslationFTUXShown:bool,ChatTranslationLocale:string,ChatTranslationToggleEnabled:bool,ChatVisible:bool,CompletedTutorials:string,ComputerCameraMovementChanged:bool,ComputerCameraMovementMode:ComputerCameraMovementMode,ComputerMovementChanged:bool,ComputerMovementMode:ComputerMovementMode,ControlMode:ControlMode,DefaultCameraID:string,FramerateCap:int,Fullscreen:bool,GamepadCameraSensitivity:float,GraphicsOptimizationMode:GraphicsOptimizationMode,GraphicsQualityLevel:int,HapticStrength:float,HasEverUsedVR:bool,IsUsingCameraYInverted:bool,IsUsingGamepadCameraSensitivity:bool,MasterVolume:float,MasterVolumeStudio:float,MaxQualityEnabled:bool,MicroProfilerWebServerEnabled:bool,MicroProfilerWebServerIP:string,MicroProfilerWebServerPort:int,MouseSensitivity:float,MouseSensitivityFirstPerson:Vector2,MouseSensitivityThirdPerson:Vector2,OnScreenProfilerEnabled:bool,OnboardingsCompleted:string,PartyVoiceVolume:float,PeoplePageLayout:PeoplePageLayout,PerformanceStatsVisible:bool,PlayerHeight:float,PlayerListVisible:bool,PlayerNamesEnabled:bool,PreferredTextSize:PreferredTextSize,PreferredTransparency:float,QualityResetLevel:int,RCCProfilerRecordFrameRate:int,RCCProfilerRecordTimeFrame:int,ReadAloud:bool,ReducedMotion:bool,RotationType:RotationType,SavedQualityLevel:SavedQualitySetting,StartMaximized:bool,StartScreenPosition:Vector2,StartScreenSize:Vector2,StudioPreferredTextSize:PreferredTextSize,TouchCameraMovementChanged:bool,TouchCameraMovementMode:TouchCameraMovementMode,TouchMovementChanged:bool,TouchMovementMode:TouchMovementMode,UIScaleMultiplierHundredths:int,UiNavigationKeyBindEnabled:bool,UsedCoreGuiIsVisibleToggle:bool,UsedCustomGuiIsVisibleToggle:bool,UsedHideHudShortcut:bool,VRComfortSetting:VRComfortSetting,VREnabled:bool,VRRotationIntensity:int,VRSafetyBubbleMode:VRSafetyBubbleMode,VRSmoothRotationEnabled:bool,VRSmoothRotationEnabledCustomOption:bool,VRThirdPersonFollowCamEnabled:bool,VRThirdPersonFollowCamEnabledCustomOption:bool,VignetteEnabled:bool,VignetteEnabledCustomOption:bool,VoiceChatVolume:float,gaID:string;UserInputService<Instance|CreateVirtualInput,GamepadSupports,GetConnectedGamepads,GetDeviceAcceleration,GetDeviceGravity,GetDeviceLevel,GetDeviceRotation,GetDeviceType,GetFocusedTextBox,GetGamepadConnected,GetGamepadState,GetImageForKeyCode,GetKeysPressed,GetLastInputType,GetMouseButtonsPressed,GetMouseDelta,GetMouseLocation,GetNavigationGamepads,GetPasteText,GetPlatform,GetStringForKeyCode,GetSupportedGamepadKeyCodes,GetUserCFrame,IsGamepadButtonDown,IsKeyDown,IsMouseButtonPressed,IsNavigationGamepad,RecenterUserHeadCFrame,SendAppUISizes,SetNavigationGamepad|DeviceAccelerationChanged,DeviceGravityChanged,DeviceRotationChanged,GamepadConnected,GamepadDisconnected,InputBegan,InputChanged,InputEnded,JumpRequest,LastInputTypeChanged,PointerAction,StatusBarTapped,TextBoxFocusReleased,TextBoxFocused,TouchDrag,TouchEnded,TouchLongPress,TouchMoved,TouchPan,TouchPinch,TouchRotate,TouchStarted,TouchSwipe,TouchTap,TouchTapInWorld,UserCFrameChanged,WindowFocusReleased,WindowFocused|AccelerometerEnabled:bool,BottomBarSize:Vector2,GamepadEnabled:bool,GyroscopeEnabled:bool,KeyboardEnabled:bool,LegacyInputEventsEnabled:bool,ModalEnabled:bool,MouseBehavior:MouseBehavior,MouseDeltaSensitivity:float,MouseEnabled:bool,MouseIcon:ContentId,MouseIconContent:Content,MouseIconEnabled:bool,NavBarSize:Vector2,OnScreenKeyboardAnimationDuration:double,OnScreenKeyboardPosition:Vector2,OnScreenKeyboardSize:Vector2,OnScreenKeyboardVisible:bool,OverrideMouseIconBehavior:OverrideMouseIconBehavior,PreferredInput:PreferredInput,RightBarSize:Vector2,StatusBarSize:Vector2,TouchEnabled:bool,TouchScreenEnabled:bool,UserHeadCFrame:CFrame,VREnabled:bool;UserService<Instance|GetUserFromGlobalUserIdAsync,GetUserInfosByUserIdsAsync||;VRService<Instance|GetTouchpadMode,GetUserCFrame,GetUserCFrameEnabled,IsMaquettes,IsVRAppBuild,RecenterUserHeadCFrame,RequestNavigation,SetTouchpadMode|LaserPointerTriggered,NavigationRequested,TouchpadModeChanged,UserCFrameChanged,UserCFrameEnabled|AutomaticScaling:VRScaling,AvatarGestures:bool,ControllerModels:VRControllerModelMode,DidPointerHit:bool,FadeOutViewOnCollision:bool,GuiInputUserCFrame:UserCFrame,LaserDistance:float,LaserPointer:VRLaserPointerMode,PointerHitCFrame:CFrame,QuestASWState:bool,QuestDisplayRefreshRate:float,ThirdPersonFollowCamEnabled:bool,VRDeviceAvailable:bool,VRDeviceName:string,VREnabled:bool,VRSessionState:VRSessionState;VRStatusService<Instance|||;ValueBase<Instance|||;BinaryStringValue<ValueBase||Changed|Value:BinaryString;BoolValue<ValueBase||Changed,changed|Value:bool;BrickColorValue<ValueBase||Changed,changed|Value:BrickColor;CFrameValue<ValueBase||Changed,changed|Value:CFrame;Color3Value<ValueBase||Changed,changed|Value:Color3;DoubleConstrainedValue<ValueBase||Changed,changed|ConstrainedValue:double,MaxValue:double,MinValue:double,Value:double,value:double;IntConstrainedValue<ValueBase||Changed,changed|ConstrainedValue:int64,MaxValue:int64,MinValue:int64,Value:int64,value:int64;IntValue<ValueBase||Changed,changed|Value:int64;NumberValue<ValueBase||Changed,changed|Value:double;ObjectValue<ValueBase||Changed,changed|Value:Instance;RayValue<ValueBase||Changed,changed|Value:Ray;StringValue<ValueBase||Changed,changed|Value:string;Vector3Value<ValueBase||Changed,changed|Value:Vector3;ValueCurve<Instance|GetKeyAtIndex,GetKeyIndicesAtTime,GetKeys,GetValueAtTime,InsertKey,InsertKeyValue,RemoveKeyAtIndex,SetKeys||Length:int,ValueType:string,ValuesAndTimes:BinaryString;Vector3Curve<Instance|GetValueAtTime,X,Y,Z||;VersionControlService<Instance||BroadcastScriptChangesSubmitted,CommitRejectedInfo,LockedScriptBatchCommit,RequestAllEditorsSignal,ScriptBatchCommit,ScriptChangesSubmitted,ScriptEditorAdded,ScriptEditorRemoved,ScriptStartEdit,ScriptStopEdit|ScriptCollabEnabled:bool,ScriptCollabVersionHistoryEnabled:bool;VideoCaptureService<Instance|GetCameraDevices|DevicesChanged,Error,Started,Stopped|Active:bool,CameraID:string;VideoDeviceInput<Instance|||Active:bool,CameraId:string,CaptureQuality:VideoDeviceCaptureQuality,IsReady:bool;VideoPlayer<Instance|GetConnectedWires,GetInputPins,GetOutputPins,Pause,Play,SetStudioPreview,Unload,LoadAsync|DidEnd,DidLoop,PlayFailed,WiringChanged|AutoLoadInStudio:bool,AutoPlayInStudio:bool,InternalVideoUsage:InternalVideoUsage,IsLoaded:bool,IsPlaying:bool,Looping:bool,MaximumResolution:VideoSampleSize,PlaybackSpeed:float,PlayingReplicating:bool,Resolution:Vector2,TimeLength:double,TimePosition:double,VideoContent:Content,Volume:float;VideoScreenCaptureService<Instance|||;VideoService<Instance|GameStreamingEnabled,CreateVideoSamplerAsync|GameStreamingResolutionReady,PlaybackReport|;VirtualInputManager<Instance|Dump,HandleGamepadAxisInput,HandleGamepadButtonInput,HandleGamepadConnect,HandleGamepadDisconnect,SendAccelerometerEvent,SendGravityEvent,SendGyroscopeEvent,SendKeyEvent,SendMouseButtonEvent,SendMouseMoveDeltaEvent,SendMouseMoveEvent,SendMouseWheelEvent,SendScroll,SendTextInputCharacterEvent,SendTouchEvent,SetInputTypesToIgnore,StartPlaying,StartPlayingJSON,StartRecording,StopPlaying,StopRecording,sendRobloxEvent,sendThemeChangeEvent,WaitForInputEventsProcessed|PlaybackCompleted,RecordingCompleted|AdditionalLuaState:string;VirtualUser<Instance|Button1Down,Button1Up,Button2Down,Button2Up,CaptureController,ClickButton1,ClickButton2,MoveMouse,SetKeyDown,SetKeyUp,StartRecording,StopRecording,TypeKey||;VisibilityCheckDispatcher<Instance|||;Visit<Instance|||;VisualizationMode<Instance|||Enabled:bool,Title:string,ToolTip:string;VisualizationModeCategory<Instance|||Enabled:bool,Title:string;VisualizationModeService<Instance|||;VoiceChatInternal<Instance|GetAndClearCallFailureMessage,GetAudioProcessingSettings,GetChannelId,GetGroupId,GetMicDevices,GetParticipants,GetSessionId,GetVoiceChatApiVersion,GetVoiceChatAvailable,GetVoiceExperienceId,IsContextVoiceEnabled,IsPublishPaused,IsSubscribePaused,JoinByGroupId,JoinByGroupIdToken,Leave,LogPublisherWebRTCStats,LogSubscriptionWebRTCStats,PublishPause,SetMicDevice,SubscribeBlock,SubscribePause,SubscribePauseAll,SubscribeRetry,SubscribeUnblock,IsVoiceEnabledForUserIdAsync|LocalPlayerModerated,ParticipantsStateChanged,PlayerMicActivitySignalChange,StateChanged,TempSetMicMutedToggleMic|VoiceChatState:VoiceChatState;VoiceChatService<Instance|getInternalChannelId,getInternalGroupId,getInternalPublishPause,getInternalSessionId,getInternalSubscribePause,getInternalSubscribePauseAll,getInternalVoiceChatApiVersion,isInternalPublishPaused,joinVoice,lastVoiceChatStats,leaveVoice,notifyServerACSCleanup,rejoinVoice,GetChatGroupsAsync,IsVoiceEnabledForUserIdAsync|ACSCleanup,ClientRetryJoin,ClientRetryJoinWithConfig,ClientStreamSwitchAck,FetchUserTurnAuthOperationFailed,JoinedVoice,JoinedVoiceV2,PublishStateChange,PublishingHandshakeAcked,PublishingHandshakeAckedWithBothSdp,PublishingHandshakeAckedWithCompressedSdp,PublishingHandshakeCompleted,PublishingHandshakeInitiated,PublishingHandshakeInitiatedWithBothSdp,PublishingHandshakeInitiatedWithCompressedSdp,ReJoinedVoice,ReJoinedVoiceV2,RelayCandidatesGathered,SsrcUserIdMappingUpdate,SubscribeStateChange,SubscriberAudioQualitySample,SubscriptionFeedStarted,SubscriptionHandshakeAcked,SubscriptionHandshakeAckedWithBothSdp,SubscriptionHandshakeAckedWithCompressedSdp,SubscriptionHandshakeCompleted,SubscriptionHandshakeInitiated,SubscriptionHandshakeInitiatedWithBothSdp,SubscriptionHandshakeInitiatedWithCompressedSdp,SubscriptionReset,UpdateTurnAuthInfoRequest,UserTurnAuth,UserTurnAuthV2,VoiceChatClientVoiceCapability,VoiceChatClientVoiceCapabilityWithConfig,VoiceChatPlayerMuteStateChangedClientToServer,VoiceChatPlayerMuteStateChangedServerToClient,VoiceChatSampleTaggedEventClientToServer,VoiceChatSampleTaggedEventServerToClient,VoiceChatStatsCollected,VoiceChatSubscriptionInitialBatchEmpty,VoiceChatplayerMuteStatusChangedEvent,VoiceMigration,VoiceSetupFailed|DefaultDistanceAttenuation:VoiceChatDistanceAttenuationType,EnableDefaultVoice:bool,EnableVoiceVolumeControls:RolloutState,UseAudioApi:AudioApiRollout,UseNewAudioApi:bool,UseNewControlPaths:bool,UseNewJoinFlow:bool,UseStreamSwitching:bool,VoiceChatEnabledForPlaceOnRcc:bool,VoiceChatEnabledForUniverseOnRcc:bool;WebSocketClient<Instance|Close,Send|Closed,MessageReceived,Opened|ConnectionState:WebSocketState;WebSocketService<Instance|CreateClient||;WebViewService<Instance|CloseWindow,MutateWindow,OpenWindow,OpenWindowV2,IsAvailable|OnJavaScriptCall,OnWindowClosed|;WeldConstraint<Instance|||Active:bool,CFrame0:CFrame,CFrame1:CFrame,Enabled:bool,Part0:BasePart,Part0Internal:BasePart,Part1:BasePart,Part1Internal:BasePart,State:int;WindowProtocolService<Instance|BeginDrag,Close,EndDrag,GetLogicalCaptionButtonsBounds,GetNativeTitleBarControlsPosition,GetTitleBarMode,GetWindowState,IsAvailable,Maximize,Minimize,OnDragAreaDoubleClicked,OnDragAreaRightClicked,Restore,SetCustomTitleBarHeight,SetTitleBarMode,ShouldRenderTitleBarControlsNatively|OnWindowStateChanged|;Wire<Instance|RenameToDefault||Connected:bool,SourceInstance:Instance,SourceName:string,TargetInstance:Instance,TargetName:string;WrapDeformMeshProvider<Instance|||;WrapTextureTransfer<Instance|||ReferenceCageMeshContent:Content,UVMaxBound:Vector2,UVMinBound:Vector2;Logger<Object|Error,GetLogger,Info,Log,Output,Warn|MessageOut|FullPath:string,Name:string;LuauExpression<Object|Evaluate,References||;MLSession<Object|ForwardAsync||;OutputLink<Object|Print||;PluginConnection<Object|BindToMessage,SendMessage||Connected:bool,GroupId:string,TargetId:string,Type:PluginConnectionTargetType;StudioActionOverride<Object|Release|Triggered|Enabled:bool,Released:bool,StudioAction:StudioAction;TerrainIterateOperation<Object|CommitBlock|Ready|;TerrainModifyOperation<Object|CommitBlock|Ready|;TerrainReadOperation<Object||Ready|;TerrainWriteOperation<Object|CommitBlock,GetBlock||;VideoSampler<Object|GetSamplesAtTimesAsync||TimeLength:double,VideoContent:Content;VirtualInput<Object|SendKey,SendMouseButton,SendMouseDelta,SendMousePosition,SendPointerAction,SendTextInput||;VoxelBuffer<Object|GetSizeInVoxels,ReadVoxels,WriteVoxels,ClearAsync,DrawBufferAsync,FromHeightmapAsync,NormalizeAsync,UnclampAsync||;WebStreamClient<Object|Close,Send|Closed,Error,MessageReceived,Opened|ConnectionState:WebStreamClientState",
}

end)()
__ROBLOX.datatypes = (function()

-- Offline models of Roblox datatypes that are pure math (bundled into the
-- harness as __ROBLOX.datatypes). envlog.luau attaches a model value as the
-- "real twin" (REALV) of a datatype proxy built from constant arguments, so
-- members, methods and operators give the engine's numbers instead of
-- symbolic expressions (scripts and obfuscators derive values from them).
--
-- Anything a model doesn't implement, or arguments it can't take, raise
-- UNSUPPORTED: envlog then falls back to the symbolic proxy. Real Roblox
-- errors are only raised where Studio was checked.
--
-- CFrame: position + 3x3 rotation, float32 like the engine (stored as native
-- vectors, so the math is float32 per component). Verified against Studio:
-- constructors, tostring, GetComponents, * / + / -, Inverse, the space
-- conversions, Euler/axis-angle getters, Lerp.
local UNSUPPORTED = setmetatable({}, { __tostring = function() return "<datatypes: unsupported>" end })
local function unsupported() error(UNSUPPORTED, 0) end

local vec = vector.create
local vdot, vcross, vnorm, vmag = vector.dot, vector.cross, vector.normalize, vector.magnitude
local fbuf = buffer.create(4)
local function f32(x)
	buffer.writef32(fbuf, 0, x)
	return buffer.readf32(fbuf, 0)
end
local function isVec(v) return type(v) == "vector" end
local function num(v)
	if type(v) == "number" then return v end
	if type(v) == "string" and tonumber(v) then return tonumber(v) end
	return unsupported()
end

-- CFrame values: userdata -> { p = pos, x = col0, y = col1, z = col2 }
local CF = setmetatable({}, { __mode = "k" })
local CFMT = {}
local function make(p, cx, cy, cz)
	local u = newproxy(true)
	local mt = getmetatable(u)
	for k, v in CFMT do mt[k] = v end
	CF[u] = { p = p, x = cx, y = cy, z = cz }
	return u
end
local function get(v)
	local c = CF[v]
	if not c then unsupported() end
	return c
end
local X, Y, Z, O = vec(1, 0, 0), vec(0, 1, 0), vec(0, 0, 1), vec(0, 0, 0)
local IDENTITY = { p = O, x = X, y = Y, z = Z }

-- rotation from rows (row-major components as in GetComponents)
local function fromRows(p, r00, r01, r02, r10, r11, r12, r20, r21, r22)
	return make(p, vec(r00, r10, r20), vec(r01, r11, r21), vec(r02, r12, r22))
end
local function rot(c, v) return c.x * v.x + c.y * v.y + c.z * v.z end
local function rotT(c, v) return vec(vdot(c.x, v), vdot(c.y, v), vdot(c.z, v)) end
local function mul(a, b) return { p = rot(a, b.p) + a.p, x = rot(a, b.x), y = rot(a, b.y), z = rot(a, b.z) } end
local function inverse(c)
	local x = vec(c.x.x, c.y.x, c.z.x)
	local y = vec(c.x.y, c.y.y, c.z.y)
	local z = vec(c.x.z, c.y.z, c.z.z)
	local r = { p = O, x = x, y = y, z = z }
	r.p = -rot(r, c.p)
	return r
end
local function wrap(c) return make(c.p, c.x, c.y, c.z) end

-- rotation matrices (double math, rounded once per component)
local function rx(a)
	local s, c = math.sin(a), math.cos(a)
	return { 1, 0, 0, 0, c, -s, 0, s, c }
end
local function ry(a)
	local s, c = math.sin(a), math.cos(a)
	return { c, 0, s, 0, 1, 0, -s, 0, c }
end
local function rz(a)
	local s, c = math.sin(a), math.cos(a)
	return { c, -s, 0, s, c, 0, 0, 0, 1 }
end
local function mm(a, b)
	local r = {}
	for i = 0, 2 do
		for j = 0, 2 do
			r[i * 3 + j + 1] = a[i * 3 + 1] * b[j + 1] + a[i * 3 + 2] * b[j + 4] + a[i * 3 + 3] * b[j + 7]
		end
	end
	return r
end
local function fromMat(p, m)
	return fromRows(p, m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9])
end
local function fromQuat(p, qx, qy, qz, qw)
	local n = qx * qx + qy * qy + qz * qz + qw * qw
	if n == 0 then unsupported() end
	local s = 2 / n
	return fromRows(p,
		1 - s * (qy * qy + qz * qz), s * (qx * qy - qz * qw), s * (qx * qz + qy * qw),
		s * (qx * qy + qz * qw), 1 - s * (qx * qx + qz * qz), s * (qy * qz - qx * qw),
		s * (qx * qz - qy * qw), s * (qy * qz + qx * qw), 1 - s * (qx * qx + qy * qy))
end
local function toQuat(c)
	local m00, m01, m02 = c.x.x, c.y.x, c.z.x
	local m10, m11, m12 = c.x.y, c.y.y, c.z.y
	local m20, m21, m22 = c.x.z, c.y.z, c.z.z
	local tr = m00 + m11 + m22
	if tr > 0 then
		local s = math.sqrt(tr + 1) * 2
		return (m21 - m12) / s, (m02 - m20) / s, (m10 - m01) / s, s / 4
	elseif m00 > m11 and m00 > m22 then
		local s = math.sqrt(1 + m00 - m11 - m22) * 2
		return s / 4, (m01 + m10) / s, (m02 + m20) / s, (m21 - m12) / s
	elseif m11 > m22 then
		local s = math.sqrt(1 + m11 - m00 - m22) * 2
		return (m01 + m10) / s, s / 4, (m12 + m21) / s, (m02 - m20) / s
	end
	local s = math.sqrt(1 + m22 - m00 - m11) * 2
	return (m02 + m20) / s, (m12 + m21) / s, s / 4, (m10 - m01) / s
end
local function lookAt(at, target, up)
	local look = vnorm(target - at)
	local right = vcross(look, up)
	if vmag(right) < 1e-6 then unsupported() end -- the engine's degenerate case isn't modelled
	right = vnorm(right)
	local up2 = vcross(right, look)
	return make(at, right, up2, -look)
end

local lib = {}
function lib.new(...)
	local n = select("#", ...)
	local a = { ... }
	if n == 0 then return wrap(IDENTITY) end
	if n == 1 and isVec(a[1]) then return make(a[1], X, Y, Z) end
	if n == 2 and isVec(a[1]) and isVec(a[2]) then return lookAt(a[1], a[2], Y) end
	if n == 3 then return make(vec(num(a[1]), num(a[2]), num(a[3])), X, Y, Z) end
	if n == 7 then
		return fromQuat(vec(num(a[1]), num(a[2]), num(a[3])), num(a[4]), num(a[5]), num(a[6]), num(a[7]))
	end
	if n == 12 then
		for i = 1, 12 do a[i] = num(a[i]) end
		return fromRows(vec(a[1], a[2], a[3]), a[4], a[5], a[6], a[7], a[8], a[9], a[10], a[11], a[12])
	end
	return unsupported()
end
function lib.Angles(a, b, c)
	return fromMat(O, mm(mm(rx(num(a or 0)), ry(num(b or 0))), rz(num(c or 0))))
end
lib.fromEulerAnglesXYZ = lib.Angles
function lib.fromEulerAnglesYXZ(a, b, c)
	return fromMat(O, mm(mm(ry(num(b or 0)), rx(num(a or 0))), rz(num(c or 0))))
end
lib.fromOrientation = lib.fromEulerAnglesYXZ
function lib.fromAxisAngle(axis, angle)
	if not isVec(axis) then unsupported() end
	local u = vnorm(axis)
	local h = num(angle) / 2
	local s = math.sin(h)
	return fromQuat(O, u.x * s, u.y * s, u.z * s, math.cos(h))
end
function lib.lookAt(at, target, up)
	if not isVec(at) or not isVec(target) or (up ~= nil and not isVec(up)) then unsupported() end
	return lookAt(at, target, up or Y)
end
function lib.fromMatrix(p, vx, vy, vz)
	if not isVec(p) or not isVec(vx) or not isVec(vy) or (vz ~= nil and not isVec(vz)) then unsupported() end
	return make(p, vx, vy, vz or vnorm(vcross(vx, vy)))
end
lib.identity = wrap(IDENTITY)

local function components(c)
	return c.p.x, c.p.y, c.p.z, c.x.x, c.y.x, c.z.x, c.x.y, c.y.y, c.z.y, c.x.z, c.y.z, c.z.z
end
local function eulerXYZ(c)
	local r02 = math.clamp(c.z.x, -1, 1)
	return f32(math.atan2(-c.z.y, c.z.z)), f32(math.asin(r02)), f32(math.atan2(-c.y.x, c.x.x))
end
local function eulerYXZ(c)
	local r12 = math.clamp(c.z.y, -1, 1)
	return f32(math.asin(-r12)), f32(math.atan2(c.z.x, c.z.z)), f32(math.atan2(c.x.y, c.y.y))
end
local function each(f)
	-- methods taking one or more values and returning one result each
	return function(self, ...)
		local c = get(self)
		local n = select("#", ...)
		if n == 0 then unsupported() end
		local out = { ... }
		for i = 1, n do out[i] = f(c, out[i]) end
		return table.unpack(out, 1, n)
	end
end
local function vecArg(v)
	if not isVec(v) then unsupported() end
	return v
end
local METHODS = {
	Inverse = function(self) return wrap(inverse(get(self))) end,
	GetComponents = function(self) return components(get(self)) end,
	ToWorldSpace = each(function(c, o) return wrap(mul(c, get(o))) end),
	ToObjectSpace = each(function(c, o) return wrap(mul(inverse(c), get(o))) end),
	PointToWorldSpace = each(function(c, v) return rot(c, vecArg(v)) + c.p end),
	PointToObjectSpace = each(function(c, v) return rotT(c, vecArg(v) - c.p) end),
	VectorToWorldSpace = each(function(c, v) return rot(c, vecArg(v)) end),
	VectorToObjectSpace = each(function(c, v) return rotT(c, vecArg(v)) end),
	ToEulerAnglesXYZ = function(self) return eulerXYZ(get(self)) end,
	ToEulerAnglesYXZ = function(self) return eulerYXZ(get(self)) end,
	ToOrientation = function(self) return eulerYXZ(get(self)) end,
	ToAxisAngle = function(self)
		local qx, qy, qz, qw = toQuat(get(self))
		if qw < 0 then qx, qy, qz, qw = -qx, -qy, -qz, -qw end
		local s = math.sqrt(math.max(0, 1 - qw * qw))
		if s < 1e-9 then return X, 0 end
		return vec(qx / s, qy / s, qz / s), f32(2 * math.acos(math.clamp(qw, -1, 1)))
	end,
	Lerp = function(self, other, t)
		local a, b = get(self), get(other)
		t = num(t)
		local ax, ay, az, aw = toQuat(a)
		local bx, by, bz, bw = toQuat(b)
		local d = ax * bx + ay * by + az * bz + aw * bw
		if d < 0 then bx, by, bz, bw, d = -bx, -by, -bz, -bw, -d end
		local wa, wb
		if d > 0.9995 then
			wa, wb = 1 - t, t
		else
			local th = math.acos(d)
			local s = math.sin(th)
			wa, wb = math.sin((1 - t) * th) / s, math.sin(t * th) / s
		end
		local p = a.p + (b.p - a.p) * t
		return fromQuat(p, ax * wa + bx * wb, ay * wa + by * wb, az * wa + bz * wb, aw * wa + bw * wb)
	end,
}
METHODS.components = METHODS.GetComponents
METHODS.inverse = METHODS.Inverse
METHODS.lerp = METHODS.Lerp
METHODS.toWorldSpace = METHODS.ToWorldSpace
METHODS.toObjectSpace = METHODS.ToObjectSpace
METHODS.pointToWorldSpace = METHODS.PointToWorldSpace
METHODS.pointToObjectSpace = METHODS.PointToObjectSpace
METHODS.vectorToWorldSpace = METHODS.VectorToWorldSpace
METHODS.vectorToObjectSpace = METHODS.VectorToObjectSpace
METHODS.toEulerAnglesXYZ = METHODS.ToEulerAnglesXYZ
METHODS.toAxisAngle = METHODS.ToAxisAngle

local PROPS = {
	Position = function(c) return c.p end,
	X = function(c) return c.p.x end,
	Y = function(c) return c.p.y end,
	Z = function(c) return c.p.z end,
	LookVector = function(c) return -c.z end,
	RightVector = function(c) return c.x end,
	UpVector = function(c) return c.y end,
	XVector = function(c) return c.x end,
	YVector = function(c) return c.y end,
	ZVector = function(c) return c.z end,
	Rotation = function(c) return make(O, c.x, c.y, c.z) end,
}
PROPS.p, PROPS.x, PROPS.y, PROPS.z = PROPS.Position, PROPS.X, PROPS.Y, PROPS.Z
PROPS.lookVector, PROPS.rightVector, PROPS.upVector = PROPS.LookVector, PROPS.RightVector, PROPS.UpVector

CFMT.__index = function(self, k)
	local c = get(self)
	local prop = PROPS[k]
	if prop then return prop(c) end
	local m = METHODS[k]
	if m then return m end
	if type(k) == "string" then error(k .. " is not a valid member of CFrame", 0) end
	return unsupported()
end
CFMT.__newindex = function() unsupported() end
CFMT.__mul = function(a, b)
	local c = get(a)
	if isVec(b) then return rot(c, b) + c.p end
	return wrap(mul(c, get(b)))
end
CFMT.__add = function(a, b)
	if not isVec(b) then unsupported() end
	local c = get(a)
	return make(c.p + b, c.x, c.y, c.z)
end
CFMT.__sub = function(a, b)
	if not isVec(b) then unsupported() end
	local c = get(a)
	return make(c.p - b, c.x, c.y, c.z)
end
CFMT.__eq = function(a, b)
	local x, y = CF[a], CF[b]
	return x ~= nil and y ~= nil and x.p == y.p and x.x == y.x and x.y == y.y and x.z == y.z
end
CFMT.__tostring = function(self)
	local t = { components(get(self)) }
	for i = 1, 12 do t[i] = string.format("%.9g", t[i]) end
	return table.concat(t, ", ")
end
CFMT.__metatable = "The metatable is locked"

-- UDim / UDim2 / Path2DControlPoint (verified against Studio: tostring,
-- int32 offsets truncated toward zero, float32 scales, + - unary -, ==,
-- Lerp rounding offsets, the control point's 0/1/3-argument constructor)
local TYPE = setmetatable({}, { __mode = "k" }) -- value -> type name
local VAL = setmetatable({}, { __mode = "k" }) -- value -> fields
local function valueType(name, index, ops)
	local mt = { __metatable = "The metatable is locked" }
	for k, v in ops do mt[k] = v end
	mt.__index = function(self, k)
		local r = index(VAL[self], k)
		if r ~= nil then return r end
		if type(k) == "string" then error(k .. " is not a valid member of " .. name, 0) end
		return unsupported()
	end
	mt.__newindex = function() unsupported() end
	return function(fields)
		local u = newproxy(true)
		local m = getmetatable(u)
		for k, v in mt do m[k] = v end
		TYPE[u], VAL[u] = name, fields
		return u
	end
end
local function field(v, name)
	if TYPE[v] ~= name then unsupported() end
	return VAL[v]
end
local function int32(x)
	x = num(x)
	if x ~= x or x >= 2147483648 or x < -2147483648 then return -2147483648 end
	return x < 0 and math.ceil(x) or math.floor(x)
end

local newUDim
newUDim = valueType("UDim", function(f, k)
	if k == "Scale" then return f.s end
	if k == "Offset" then return f.o end
	return nil
end, {
	__add = function(a, b) local x, y = field(a, "UDim"), field(b, "UDim") return newUDim({ s = f32(x.s + y.s), o = int32(x.o + y.o) }) end,
	__sub = function(a, b) local x, y = field(a, "UDim"), field(b, "UDim") return newUDim({ s = f32(x.s - y.s), o = int32(x.o - y.o) }) end,
	__unm = function(a) local x = field(a, "UDim") return newUDim({ s = -x.s, o = int32(-x.o) }) end,
	__eq = function(a, b) local x, y = VAL[a], VAL[b] return TYPE[a] == TYPE[b] and x.s == y.s and x.o == y.o end,
	__tostring = function(a) local x = VAL[a] return string.format("%.9g, %d", x.s, x.o) end,
})
local function udim(s, o) return newUDim({ s = f32(num(s or 0)), o = int32(o or 0) }) end

local newUDim2
local function udim2Str(f)
	local x, y = VAL[f.x], VAL[f.y]
	return string.format("{%.9g, %d}, {%.9g, %d}", x.s, x.o, y.s, y.o)
end
local function lerpUDim(a, b, t)
	local x, y = VAL[a], VAL[b]
	return newUDim({ s = f32(x.s + (y.s - x.s) * t), o = int32(math.floor(x.o + (y.o - x.o) * t + 0.5)) })
end
newUDim2 = valueType("UDim2", function(f, k)
	if k == "X" or k == "Width" then return f.x end
	if k == "Y" or k == "Height" then return f.y end
	if k == "Lerp" or k == "lerp" then
		return function(self, other, t)
			local a, b = field(self, "UDim2"), field(other, "UDim2")
			t = num(t)
			return newUDim2({ x = lerpUDim(a.x, b.x, t), y = lerpUDim(a.y, b.y, t) })
		end
	end
	return nil
end, {
	__add = function(a, b) local x, y = field(a, "UDim2"), field(b, "UDim2") return newUDim2({ x = x.x + y.x, y = x.y + y.y }) end,
	__sub = function(a, b) local x, y = field(a, "UDim2"), field(b, "UDim2") return newUDim2({ x = x.x - y.x, y = x.y - y.y }) end,
	__unm = function(a) local x = field(a, "UDim2") return newUDim2({ x = -x.x, y = -x.y }) end,
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].x == VAL[b].x and VAL[a].y == VAL[b].y end,
	__tostring = function(a) return udim2Str(VAL[a]) end,
})
local UDimLib = { new = function(s, o) return udim(s, o) end }
local UDim2Lib = {}
function UDim2Lib.new(...)
	local n = select("#", ...)
	local a, b, c, d = ...
	if n == 2 and TYPE[a] == "UDim" and TYPE[b] == "UDim" then return newUDim2({ x = a, y = b }) end
	for i = 1, n do
		local v = select(i, ...)
		if v ~= nil and type(v) ~= "number" and not (type(v) == "string" and tonumber(v)) then unsupported() end
	end
	return newUDim2({ x = udim(a, b), y = udim(c, d) })
end
function UDim2Lib.fromScale(x, y) return newUDim2({ x = udim(x, 0), y = udim(y, 0) }) end
function UDim2Lib.fromOffset(x, y) return newUDim2({ x = udim(0, x), y = udim(0, y) }) end

local newCP = valueType("Path2DControlPoint", function(f, k)
	if k == "Position" then return f.p end
	if k == "LeftTangent" then return f.l end
	if k == "RightTangent" then return f.r end
	return nil
end, {
	__eq = function(a, b)
		local x, y = VAL[a], VAL[b]
		return TYPE[a] == TYPE[b] and x.p == y.p and x.l == y.l and x.r == y.r
	end,
	__tostring = function(a)
		local f = VAL[a]
		return string.format("Path2DControlPoint { Position = %s, LeftTangent = %s, RightTangent = %s }",
			udim2Str(VAL[f.p]), udim2Str(VAL[f.l]), udim2Str(VAL[f.r]))
	end,
})
local CPLib = {}
function CPLib.new(...)
	local n = select("#", ...)
	local p, l, r = ...
	local zero = UDim2Lib.new()
	if n == 0 then return newCP({ p = zero, l = zero, r = zero }) end
	if n ~= 1 and n ~= 3 then error("Trying to create a Path2DControlPoint with wrong number of arguments", 0) end
	for i = 1, n do
		if TYPE[(select(i, ...))] ~= "UDim2" then unsupported() end
	end
	return newCP({ p = p, l = l or zero, r = r or zero })
end

-- Vector2 (userdata in Roblox, float32 components: kept as a native vector
-- with z = 0 so the arithmetic is float32), Rect (corners sorted), Ray.
-- Verified against Studio: tostring, operators, members, the methods below.
local newV2
local function v2(v) return newV2({ v = v }) end
local function v2val(v)
	if TYPE[v] ~= "Vector2" then unsupported() end
	return VAL[v].v
end
local function v2arith(op)
	return function(a, b)
		local x = TYPE[a] == "Vector2" and VAL[a].v or (type(a) == "number" and vec(a, a, 0)) or unsupported()
		local y = TYPE[b] == "Vector2" and VAL[b].v or (type(b) == "number" and vec(b, b, 0)) or unsupported()
		local r = op(x, y)
		return v2(vec(r.x, r.y, 0))
	end
end
local V2METHODS = {
	Dot = function(a, b) return vdot(v2val(a), v2val(b)) end,
	Cross = function(a, b) local x, y = v2val(a), v2val(b) return f32(f32(x.x * y.y) - f32(x.y * y.x)) end,
	Lerp = function(a, b, t) local x, y = v2val(a), v2val(b) return v2(x + (y - x) * num(t)) end,
	Abs = function(a) return v2(vector.abs(v2val(a))) end,
	Floor = function(a) return v2(vector.floor(v2val(a))) end,
	Ceil = function(a) return v2(vector.ceil(v2val(a))) end,
	Sign = function(a) return v2(vector.sign(v2val(a))) end,
	Max = function(a, b) return v2(vector.max(v2val(a), v2val(b))) end,
	Min = function(a, b) return v2(vector.min(v2val(a), v2val(b))) end,
	Angle = function(a, b, signed)
		local x, y = v2val(a), v2val(b)
		local ang = math.atan2(math.abs(x.x * y.y - x.y * y.x), x.x * y.x + x.y * y.y)
		if signed and x.x * y.y - x.y * y.x < 0 then ang = -ang end
		return f32(ang)
	end,
}
V2METHODS.lerp = V2METHODS.Lerp
newV2 = valueType("Vector2", function(f, k)
	local v = f.v
	if k == "X" or k == "x" then return v.x end
	if k == "Y" or k == "y" then return v.y end
	if k == "Magnitude" or k == "magnitude" then return vmag(v) end
	if k == "Unit" or k == "unit" then return v2(vnorm(v)) end
	return V2METHODS[k]
end, {
	__add = v2arith(function(a, b) return a + b end),
	__sub = v2arith(function(a, b) return a - b end),
	__mul = v2arith(function(a, b) return a * b end),
	__div = v2arith(function(a, b) return a / b end),
	__idiv = v2arith(function(a, b) return a // b end),
	__unm = function(a) return v2(-v2val(a)) end,
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].v == VAL[b].v end,
	__tostring = function(a) local v = VAL[a].v return string.format("%.9g, %.9g", v.x, v.y) end,
})
local V2Lib = {
	new = function(x, y) return v2(vec(num(x or 0), num(y or 0), 0)) end,
	zero = v2(vec(0, 0, 0)),
	one = v2(vec(1, 1, 0)),
	xAxis = v2(vec(1, 0, 0)),
	yAxis = v2(vec(0, 1, 0)),
}

local newRect = valueType("Rect", function(f, k)
	if k == "Min" then return v2(f.lo) end
	if k == "Max" then return v2(f.hi) end
	if k == "Width" then return f.hi.x - f.lo.x end
	if k == "Height" then return f.hi.y - f.lo.y end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].lo == VAL[b].lo and VAL[a].hi == VAL[b].hi end,
	__tostring = function(a)
		local f = VAL[a]
		return string.format("%.9g, %.9g, %.9g, %.9g", f.lo.x, f.lo.y, f.hi.x, f.hi.y)
	end,
})
local RectLib = {}
function RectLib.new(...)
	local n = select("#", ...)
	local a, b, c, d = ...
	local p, q
	if n == 2 then
		p, q = v2val(a), v2val(b)
	elseif n == 0 or n == 4 then
		p, q = vec(num(a or 0), num(b or 0), 0), vec(num(c or 0), num(d or 0), 0)
	else
		return unsupported()
	end
	return newRect({ lo = vector.min(p, q), hi = vector.max(p, q) })
end

local newRay
local function closest(f, p)
	if not isVec(p) then unsupported() end
	local u = vnorm(f.d)
	local t = math.max(0, vdot(p - f.o, u))
	return f.o + u * t
end
newRay = valueType("Ray", function(f, k)
	if k == "Origin" then return f.o end
	if k == "Direction" then return f.d end
	if k == "Unit" then return newRay({ o = f.o, d = vnorm(f.d) }) end
	if k == "ClosestPoint" then return function(self, p) return closest(field(self, "Ray"), p) end end
	if k == "Distance" then return function(self, p) return vmag(p - closest(field(self, "Ray"), p)) end end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].o == VAL[b].o and VAL[a].d == VAL[b].d end,
	__tostring = function(a)
		local f = VAL[a]
		return string.format("{%s}, {%s}", tostring(f.o), tostring(f.d))
	end,
})
local RayLib = {
	new = function(o, d)
		if (o ~= nil and not isVec(o)) or (d ~= nil and not isVec(d)) then unsupported() end
		return newRay({ o = o or O, d = d or O })
	end,
}

-- NumberRange, Color3, Vector3int16/Vector2int16, Number/ColorSequence(Keypoint).
-- tostring uses C++ stream formatting (%g, 6 digits), keypoints and ranges
-- end in a space; float32 fields; int16 wraps around (all as in Studio).
local function g(x) return string.format("%g", x) end
local newNR = valueType("NumberRange", function(f, k)
	if k == "Min" then return f.lo end
	if k == "Max" then return f.hi end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].lo == VAL[b].lo and VAL[a].hi == VAL[b].hi end,
	__tostring = function(a) return g(VAL[a].lo) .. " " .. g(VAL[a].hi) .. " " end,
})
local NRLib = {
	new = function(lo, hi)
		lo = f32(num(lo))
		hi = hi == nil and lo or f32(num(hi))
		if lo > hi then error("NumberRange: invalid range", 0) end
		return newNR({ lo = lo, hi = hi })
	end,
}

local newC3
local function c3(r, g_, b) return newC3({ v = vec(r, g_, b) }) end
local function c3val(c)
	if TYPE[c] ~= "Color3" then unsupported() end
	return VAL[c].v
end
local function toHSV(v)
	local r, gg, b = math.clamp(v.x, 0, 1), math.clamp(v.y, 0, 1), math.clamp(v.z, 0, 1) -- the engine clamps first
	local mx, mn = math.max(r, gg, b), math.min(r, gg, b)
	local d = mx - mn
	local h = 0
	if d ~= 0 then
		if mx == r then
			h = ((gg - b) / d) % 6
		elseif mx == gg then
			h = (b - r) / d + 2
		else
			h = (r - gg) / d + 4
		end
		h /= 6
	end
	return f32(h), f32(mx == 0 and 0 or d / mx), f32(mx)
end
local function byte(x) return math.clamp(math.floor(x * 255 + 0.5), 0, 255) end
local C3METHODS = {
	Lerp = function(a, b, t) local x, y = c3val(a), c3val(b) return newC3({ v = x + (y - x) * num(t) }) end,
	ToHSV = function(a) return toHSV(c3val(a)) end,
	ToHex = function(a) local v = c3val(a) return string.format("%02x%02x%02x", byte(v.x), byte(v.y), byte(v.z)) end,
}
C3METHODS.lerp = C3METHODS.Lerp
newC3 = valueType("Color3", function(f, k)
	if k == "R" or k == "r" then return f.v.x end
	if k == "G" or k == "g" then return f.v.y end
	if k == "B" or k == "b" then return f.v.z end
	return C3METHODS[k]
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].v == VAL[b].v end,
	__tostring = function(a) local v = VAL[a].v return g(v.x) .. ", " .. g(v.y) .. ", " .. g(v.z) end,
})
local function hsv(h, s, v)
	h, s, v = num(h), num(s), num(v)
	h = (h % 1) * 6
	local i = math.floor(h)
	local f = h - i
	local p, q, t = v * (1 - s), v * (1 - s * f), v * (1 - s * (1 - f))
	if i == 0 then return c3(v, t, p) elseif i == 1 then return c3(q, v, p) elseif i == 2 then return c3(p, v, t)
	elseif i == 3 then return c3(p, q, v) elseif i == 4 then return c3(t, p, v) end
	return c3(v, p, q)
end
local C3Lib = {
	new = function(r, g_, b) return c3(num(r or 0), num(g_ or 0), num(b or 0)) end,
	fromRGB = function(r, g_, b) return c3(num(r or 0) / 255, num(g_ or 0) / 255, num(b or 0) / 255) end,
	fromHSV = hsv,
	fromHex = function(s)
		if type(s) ~= "string" then unsupported() end
		local h = string.match(s, "^#?(%x%x%x%x%x%x)$")
		if not h then
			local r, g_, b = string.match(s, "^#?(%x)(%x)(%x)$")
			if not r then unsupported() end
			h = r .. r .. g_ .. g_ .. b .. b
		end
		return c3(tonumber(string.sub(h, 1, 2), 16) / 255, tonumber(string.sub(h, 3, 4), 16) / 255,
			tonumber(string.sub(h, 5, 6), 16) / 255)
	end,
	toHSV = function(c) return toHSV(c3val(c)) end,
}

local function int16(x)
	x = num(x or 0)
	x = x < 0 and math.ceil(x) or math.floor(x)
	return (x + 32768) % 65536 - 32768
end
local function intVector(name, n)
	local new
	local function make(...)
		local t = { ... }
		for i = 1, n do t[i] = int16(t[i]) end
		return new({ c = t })
	end
	local function arith(op)
		return function(a, b)
			if TYPE[a] ~= name or TYPE[b] ~= name then unsupported() end
			local x, y, r = VAL[a].c, VAL[b].c, {}
			for i = 1, n do r[i] = op(x[i], y[i]) end
			return make(table.unpack(r, 1, n))
		end
	end
	local KEYS = { X = 1, Y = 2, Z = n == 3 and 3 or nil, x = 1, y = 2, z = n == 3 and 3 or nil }
	new = valueType(name, function(f, k)
		local i = KEYS[k]
		return i and f.c[i] or nil
	end, {
		__add = arith(function(a, b) return a + b end),
		__sub = arith(function(a, b) return a - b end),
		__mul = arith(function(a, b) return a * b end),
		__div = arith(function(a, b) return a / b end),
		__unm = function(a) local c = VAL[a].c return make(-c[1], -c[2], -(c[3] or 0)) end,
		__eq = function(a, b)
			if TYPE[a] ~= TYPE[b] then return false end
			for i = 1, n do if VAL[a].c[i] ~= VAL[b].c[i] then return false end end
			return true
		end,
		__tostring = function(a) return table.concat(VAL[a].c, ", ", 1, n) end,
	})
	return { new = make }
end

local newNSK = valueType("NumberSequenceKeypoint", function(f, k)
	if k == "Time" then return f.t end
	if k == "Value" then return f.v end
	if k == "Envelope" then return f.e end
	return nil
end, {
	__eq = function(a, b) local x, y = VAL[a], VAL[b] return TYPE[a] == TYPE[b] and x.t == y.t and x.v == y.v and x.e == y.e end,
	__tostring = function(a) local f = VAL[a] return g(f.t) .. " " .. g(f.v) .. " " .. g(f.e) .. " " end,
})
local NSKLib = {
	new = function(t, v, e) return newNSK({ t = f32(num(t)), v = f32(num(v)), e = f32(num(e or 0)) }) end,
}
local newCSK = valueType("ColorSequenceKeypoint", function(f, k)
	if k == "Time" then return f.t end
	if k == "Value" then return f.c end
	return nil
end, {
	__eq = function(a, b) return TYPE[a] == TYPE[b] and VAL[a].t == VAL[b].t and VAL[a].c == VAL[b].c end,
	__tostring = function(a)
		local f = VAL[a]
		local v = VAL[f.c].v
		return g(f.t) .. " " .. g(v.x) .. " " .. g(v.y) .. " " .. g(v.z) .. " 0 "
	end,
})
local CSKLib = {
	new = function(t, c)
		c3val(c)
		return newCSK({ t = f32(num(t)), c = c })
	end,
}
local function sequence(name, kpType, fromValues)
	local new
	new = valueType(name, function(f, k)
		if k == "Keypoints" then return table.clone(f.k) end
		return nil
	end, {
		__eq = function(a, b)
			if TYPE[a] ~= TYPE[b] or #VAL[a].k ~= #VAL[b].k then return false end
			for i, kp in VAL[a].k do if not (kp == VAL[b].k[i]) then return false end end
			return true
		end,
		__tostring = function(a)
			local parts = {}
			for i, kp in VAL[a].k do parts[i] = tostring(kp) end
			return table.concat(parts)
		end,
	})
	return {
		new = function(...)
			local a = ...
			if type(a) == "table" then
				for _, kp in a do if TYPE[kp] ~= kpType then unsupported() end end
				if #a < 2 then unsupported() end
				return new({ k = table.clone(a) })
			end
			return new({ k = fromValues(...) })
		end,
	}
end
local NSLib = sequence("NumberSequence", "NumberSequenceKeypoint", function(a, b)
	b = b == nil and a or b
	return { NSKLib.new(0, a), NSKLib.new(1, b) }
end)
local CSLib = sequence("ColorSequence", "ColorSequenceKeypoint", function(a, b)
	b = b == nil and a or b
	return { CSKLib.new(0, a), CSKLib.new(1, b) }
end)

-- typeof() ignores __type on newproxy userdata: envlog asks here instead
local function typeOf(v)
	if CF[v] then return "CFrame" end
	return TYPE[v]
end

return {
	UNSUPPORTED = UNSUPPORTED,
	typeOf = typeOf,
	CFrame = lib,
	UDim = UDimLib,
	UDim2 = UDim2Lib,
	Path2DControlPoint = CPLib,
	Vector2 = V2Lib,
	Rect = RectLib,
	Ray = RayLib,
	NumberRange = NRLib,
	Color3 = C3Lib,
	Vector3int16 = intVector("Vector3int16", 3),
	Vector2int16 = intVector("Vector2int16", 2),
	NumberSequenceKeypoint = NSKLib,
	ColorSequenceKeypoint = CSKLib,
	NumberSequence = NSLib,
	ColorSequence = CSLib,
}

end)()

--[[
	envlog.luau - dynamic deobfuscation runtime (fake Roblox/executor environment).

	The Luraph VM cannot be read statically in any useful way (its bytecode is
	encrypted and its interpreter is split into hundreds of flattened state
	machine fragments), but everything the protected script *does* has to go
	through the environment it runs in. This runtime executes the script against
	a fake Roblox environment made of logging proxies and reconstructs readable
	Luau from the observed operations.

	harness.build_harness prepends locals before this file, e.g.:
		__SOURCE  : string  - the protected script
		__CONFIG  : table   - options (see CFG below)
]]

local CFG = __CONFIG or {}
local MAX_STMTS = CFG.max_stmts or 250000
local MAX_BLOCK = CFG.max_block or 25000
local MAX_WAITS = CFG.max_waits or 50
local MAX_DEPTH = CFG.max_depth or 24
local TIME_BUDGET = CFG.time_budget or 30

-- untouched references to the real globals
local R = {
	type = type, typeof = typeof, tostring = tostring, tonumber = tonumber,
	pairs = pairs, ipairs = ipairs, next = next, select = select,
	rawget = rawget, rawset = rawset, rawequal = rawequal, rawlen = rawlen,
	setmetatable = setmetatable, getmetatable = getmetatable,
	pcall = pcall, xpcall = xpcall, error = error,
	getfenv = getfenv, setfenv = setfenv, loadstring = loadstring,
	newproxy = newproxy, print = print, clock = os.clock,
	unpack = table.unpack, insert = table.insert, concat = table.concat,
	remove = table.remove, fmt = string.format, rep = string.rep,
	gsub = string.gsub, match = string.match, byte = string.byte, lower = string.lower,
	sub = string.sub, find = string.find, sort = table.sort,
	floor = math.floor, huge = math.huge, max = math.max,
}
local REAL_G = R.getfenv(0)
local HARNESS_SRC0 = debug.info(1, "s")

-- native mode: the harness runs inside Roblox itself (Studio). Pure engine
-- objects then get a real twin, so values the engine computes (Path2D curve
-- math, datatype arithmetic, ...) are bit-exact. Output is collected and
-- returned by the chunk instead of printed.
local NATIVE = CFG.native and R.typeof(REAL_G.game) == "Instance"
local OUTBUF = {}
if NATIVE then
	R.print = function(...)
		local t = table.pack(...)
		for i = 1, t.n do t[i] = R.tostring(t[i]) end
		R.insert(OUTBUF, R.concat(t, "\t", 1, t.n))
		-- debug traces can be huge: keep only the tail (print_tail lines)
		if CFG.print_tail and #OUTBUF > 2 * CFG.print_tail then
			OUTBUF = table.move(OUTBUF, #OUTBUF - CFG.print_tail + 1, #OUTBUF, 1, {})
		end
	end
end
local START = R.clock()

-- sentinels used to unwind the script
local LOOP = R.setmetatable({}, { __tostring = function() return "<envlog: loop truncated>" end })
local ABORT = R.setmetatable({}, { __tostring = function() return "<envlog: budget exhausted>" end })
local TAMPER = R.setmetatable({}, { __tostring = function() return "<envlog: anti-tamper suppressed>" end })
local ABORT_REASON = nil
local tamperCount = 0
local TRIGGER, noteTrigger = nil, nil
local ALLOC_TRIGGER = nil

---------------------------------------------------------------------------
-- output model
--   block = { lines = { stmt... }, waits = {...} }
--   stmt  = { text = "tokenised text" }
--         | { call = "tokenised call", res = proxy }
--         | { header = "tokenised", block = block }
--   Proxies are embedded in text as \1<id>\2, captured functions as \3<id>\4
--   so names can be decided after the run (only values that are actually used
--   get a local).
---------------------------------------------------------------------------
local ROOT = { lines = {}, waits = {} }
local STACK = { ROOT }
local stmtCount = 0

-- proto attribution (for folding repeated helpers, see fold.py): every
-- statement records which script functions (Luraph protos) were on the Lua
-- stack when it was emitted, outermost first, as "pid:invocation,...".
-- pf: closure -> proto (filled where Luraph makes closures), pid: proto -> id,
-- plast: id -> number of its latest entry (tells invocations apart)
local CHAIN = { pf = nil, pid = nil, plast = nil }
function CHAIN.get()
	local pf, pid, plast = CHAIN.pf, CHAIN.pid, CHAIN.plast
	if not pf or not pid or not plast then return "" end
	local parts = {}
	local lvl = 3
	while true do
		local f = debug.info(lvl, "f")
		if f == nil then break end
		local proto = pf[f]
		local id = proto and pid[proto]
		if id then
			R.insert(parts, 1, id .. ":" .. R.tostring(plast[id]))
		end
		lvl += 1
	end
	-- v15 normally enters the bootstrap root as proto #1, but v14.x can
	-- create/enter helper protos before that root.  The invariant we actually
	-- need is the runtime stack shape: the outermost instrumented proto calls
	-- the payload root immediately below it.  Track that observed edge instead
	-- of hardcoding pid 1.  If the outer proto later emits by itself, the child
	-- was a probe/helper; a later nested statement can establish a new child.
	CHAIN.seen = CHAIN.seen or {}
	if #parts >= 2 then
		local p = R.tonumber(R.match(parts[1], "^(%d+):"))
		local c = R.tonumber(R.match(parts[2], "^(%d+):"))
		if p and c then
			CHAIN.rootParent = p
			CHAIN.rootCallee = c
			CHAIN.seen[c] = "ok"
		end
	elseif #parts == 1 then
		local p = R.tonumber(R.match(parts[1], "^(%d+):"))
		if p and CHAIN.rootParent == p and CHAIN.rootCallee then
			CHAIN.seen[CHAIN.rootCallee] = "probe"
		end
	end
	return R.concat(parts, ",")
end

local function curBlock()
	return STACK[#STACK]
end

local abortHits = 0
local function checkBudget()
	-- a plugin's end hook running script code after the run (ironbrew1's
	-- capture pushes never-run protos through the VM's closure maker)
	if CHAIN.unlimited then return end
	if ABORT_REASON then
		-- the script's pcall swallowed the abort and it kept going (a loop
		-- around pcall): leave its thread by yielding (runInBlock / the main
		-- runner treat an ABORT yield as the abort)
		abortHits += 1
		if abortHits > 1 and coroutine.isyieldable() then coroutine.yield(ABORT) end
		R.error(ABORT, 0)
	end
	if stmtCount > MAX_STMTS then
		ABORT_REASON = "statement limit reached"
		R.error(ABORT, 0)
	end
	local now = R.clock()
	if now - START > TIME_BUDGET then
		ABORT_REASON = "time budget exhausted"
		R.error(ABORT, 0)
	end
	-- heartbeat (harness.run_once): the pipe is block-buffered, so the padding
	-- pushes it out; a run without one for a while is stuck in pure script code
	if CFG.heartbeat and now - (CFG._hb or START) > CFG.heartbeat then
		CFG._hb = now
		R.print("\0HB\n" .. R.rep(" ", 16384))
	end
end

local function emit(stmt)
	checkBudget()
	if CHAIN.syncGenv and not CHAIN.syncing then CHAIN.syncGenv() end
	local b = curBlock()
	if b.stopped then
		b.stopped += 1
		if b.stopped > 200 then
			ABORT_REASON = "a stopped loop kept running (its error was caught by the script)"
			R.error(ABORT, 0)
		end
		R.error(LOOP, 0)
	end
	stmtCount += 1
	if CHAIN.pf then stmt.chain = CHAIN.get() end
	R.insert(b.lines, stmt)
	-- flat per-thread tape (see onWait): the loop detector must see through
	-- blocks that never closed (a `for` over a stand-in object left by `break`)
	for i = #STACK, 1, -1 do
		local rb = STACK[i]
		if rb.isRoot or i == 1 then
			rb.tape = rb.tape or {}
			R.insert(rb.tape, { stmt = stmt, block = b })
			break
		end
	end
	if #b.lines > MAX_BLOCK then
		R.insert(b.lines, { text = "-- [envlog] block truncated after " .. MAX_BLOCK .. " statements" })
		b.stopped = 0
		R.error(LOOP, 0)
	end
	return stmt
end

local function comment(s)
	return emit({ text = "-- " .. s })
end

---------------------------------------------------------------------------
-- proxies
---------------------------------------------------------------------------
local INFO = R.setmetatable({}, { __mode = "k" })
local BYID = {}
local nextId = 0
local PMT = {} -- shared metamethods, copied into each proxy's own metatable
local isMethodName, methodFn
local METHODP_REF

local function isP(v)
	return R.type(v) == "userdata" and INFO[v] ~= nil
end

local function newP(info)
	nextId += 1
	info.id = nextId
	info.children = {}
	info.props = {}
	local p = R.newproxy(true)
	local mt = R.getmetatable(p)
	for k, f in PMT do
		mt[k] = f
	end
	INFO[p] = info
	BYID[nextId] = p
	return p
end

local function tok(p)
	return "\1" .. INFO[p].id .. "\2"
end

local function isIdent(s)
	return R.type(s) == "string" and R.match(s, "^[%a_][%w_]*$") ~= nil and not ({
		["and"] = 1, ["break"] = 1, ["do"] = 1, ["else"] = 1, ["elseif"] = 1, ["end"] = 1,
		["false"] = 1, ["for"] = 1, ["function"] = 1, ["if"] = 1, ["in"] = 1, ["local"] = 1,
		["nil"] = 1, ["not"] = 1, ["or"] = 1, ["repeat"] = 1, ["return"] = 1, ["then"] = 1,
		["true"] = 1, ["until"] = 1, ["while"] = 1, ["continue"] = 1,
	})[s]
end

local function quote(s)
	local out = R.gsub(s, '[%c"\\\128-\255]', function(c)
		if c == "\n" then return "\\n" end
		if c == "\t" then return "\\t" end
		if c == "\r" then return "\\r" end
		if c == '"' then return '\\"' end
		if c == "\\" then return "\\\\" end
		local b = R.byte(c)
		if b >= 128 then return c end -- keep UTF-8 as-is
		return "\\" .. b
	end)
	return '"' .. out .. '"'
end

local function fmtNumber(n)
	if n ~= n then return "0/0" end
	if n == R.huge then return "math.huge" end
	if n == -R.huge then return "-math.huge" end
	if n == R.floor(n) and n > -1e15 and n < 1e15 then
		return R.fmt("%d", n)
	end
	local s = R.fmt("%.14g", n)
	if R.tonumber(s) ~= n then s = R.fmt("%.17g", n) end
	return s
end

local fmt -- forward
local genvTable -- forward
local GENVNAME = R.setmetatable({}, { __mode = "k" }) -- getgenv()-style table -> label
local captureFunction -- forward
local FNAME = R.setmetatable({}, { __mode = "k" }) -- native-looking function -> source text
local CFUNCS = R.setmetatable({}, { __mode = "k" }) -- functions that must pass as C closures
local CNAME = R.setmetatable({}, { __mode = "k" }) -- their debug.info "n" names
local THREADP = R.setmetatable({}, { __mode = "k" }) -- spawned thread -> proxy used when printing it

-- getfenv(cfunction) returns the calling thread's globals in Roblox, but our
-- stand-ins for C functions are Lua closures whose environment is the harness.
-- So each one is handed out as a trampoline without globals whose environment
-- is set to the script's globals once they exist (same source as the harness,
-- so stack views still collapse it).
local MKTRAMP = R.loadstring("local impl = ... return function(...) return impl(...) end", "=" .. HARNESS_SRC0)
local TRAMPS = {}
local TRAMP_ENV = nil
local function tramp(impl)
	local t = MKTRAMP(impl)
	if TRAMP_ENV then R.setfenv(t, TRAMP_ENV) else R.insert(TRAMPS, t) end
	return t
end

local function keySuffix(k)
	if isIdent(k) then
		return "." .. k
	end
	return "[" .. fmt(k) .. "]"
end

local ENV -- forward

function fmt(v, depth, seen)
	local t = R.type(v)
	if t == "nil" then return "nil" end
	if t == "boolean" then return R.tostring(v) end
	if t == "number" then return fmtNumber(v) end
	if t == "string" then return quote(v) end
	if t == "userdata" then
		if INFO[v] then return tok(v) end
		return "nil --[[userdata]]"
	end
	if t == "function" then
		if FNAME[v] then return FNAME[v] end
		if METHODP_REF and METHODP_REF[v] then return tok(METHODP_REF[v]) end
		return captureFunction(v)
	end
	if t == "table" then
		if v == ENV then return "getfenv()" end
		if GENVNAME[v] then return GENVNAME[v] end
		depth = depth or 0
		seen = seen or {}
		if seen[v] then return "{ --[[cycle]] }" end
		if depth > 6 then return "{ --[[...]] }" end
		seen[v] = true
		local parts = {}
		local n = 0
		for i = 1, 1e9 do
			local x = R.rawget(v, i)
			if x == nil then break end
			n = i
			R.insert(parts, fmt(x, depth + 1, seen))
		end
		local keys = {}
		for k in R.next, v do
			if not (R.type(k) == "number" and k >= 1 and k <= n and k % 1 == 0) then
				R.insert(keys, k)
			end
		end
		-- hash order is lost; use the order people write: title first, callbacks last
		local function rank(k)
			local x = R.rawget(v, k)
			if R.type(x) == "function" then return 4 end
			if k == "Title" or k == "Name" or k == "Text" then return 1 end
			if k == "Desc" or k == "Description" or k == "Content" then return 2 end
			return 3
		end
		R.sort(keys, function(a, b)
			local ta, tb = R.type(a), R.type(b)
			if ta ~= tb then return ta < tb end
			if ta == "string" then
				local ra, rb = rank(a), rank(b)
				if ra ~= rb then return ra < rb end
				return a < b
			end
			if ta == "number" then return a < b end
			return false
		end)
		for _, k in keys do
			local key = isIdent(k) and k or ("[" .. fmt(k, depth + 1, seen) .. "]")
			local x = R.rawget(v, k)
			-- UI library callbacks also get a run with `false` (see captureFunction)
			if k == "Callback" and R.type(x) == "function" then CFG._cbtry = true end
			R.insert(parts, key .. " = " .. fmt(x, depth + 1, seen))
			CFG._cbtry = nil
		end
		seen[v] = nil
		if #parts == 0 then return "{}" end
		local flat = "{ " .. R.concat(parts, ", ") .. " }"
		if #flat <= 100 and not R.find(flat, "\3", 1, true) then return flat end
		local ind = R.rep("\t", depth + 1)
		return "{\n" .. ind .. R.concat(parts, ",\n" .. ind) .. "\n" .. R.rep("\t", depth) .. "}"
	end
	if t == "vector" then
		return "Vector3.new(" .. fmtNumber(v.x) .. ", " .. fmtNumber(v.y) .. ", " .. fmtNumber(v.z) .. ")"
	end
	if t == "buffer" then return "buffer.create(" .. buffer.len(v) .. ")" end
	if t == "thread" and THREADP[v] then return tok(THREADP[v]) end
	return "nil --[[" .. t .. "]]"
end

local function fmtArgs(...)
	local n = R.select("#", ...)
	local parts = {}
	for i = 1, n do
		parts[i] = fmt((R.select(i, ...)))
	end
	return R.concat(parts, ", ")
end

-- proxy constructors ------------------------------------------------------
local function globalP(name, tname)
	return newP({ kind = "name", name = name, tname = tname or "Instance" })
end

local function exprP(text, tname, hint)
	return newP({ kind = "expr", text = text, tname = tname or "Instance", hint = hint })
end

---------------------------------------------------------------------------
-- Roblox API data (gen_roblox.py): enums with values and, per class, which
-- names are methods, events and properties
---------------------------------------------------------------------------
local API = { enums = {}, classes = {} }
do
	local src = __ROBLOX or { enums = "", classes = "" }
	for ename, items in string.gmatch(src.enums, "([%w_]+):([^;]*)") do
		local e = { name = ename, items = {}, byName = {}, byValue = {} }
		for iname, v in string.gmatch(items, "([%w_]+)=(%-?%d+)") do
			local item = { Name = iname, Value = R.tonumber(v) }
			R.insert(e.items, item)
			e.byName[iname] = item
			if e.byValue[item.Value] == nil then e.byValue[item.Value] = item end
		end
		API.enums[ename] = e
	end
	for cname, super, fns, evs, props in string.gmatch(src.classes, "([%w_]+)<([%w_]*)|([^|]*)|([^|]*)|([^;]*)") do
		local c = { super = super ~= "" and super or nil, m = {}, e = {}, p = {} }
		for x in string.gmatch(fns, "[^,]+") do c.m[x] = true end
		for x in string.gmatch(evs, "[^,]+") do c.e[x] = true end
		for x in string.gmatch(props, "[^,]+") do
			local name, vt = R.match(x, "^([^:]+):?(.*)$")
			c.p[name] = vt ~= "" and vt or true
		end
		API.classes[cname] = c
	end
end

local function memberKind(cls, k)
	local guard = 0
	while cls and guard < 32 do
		guard += 1
		local c = API.classes[cls]
		if not c then return nil end
		if c.m[k] then return "method" end
		if c.e[k] then return "event" end
		if c.p[k] then return "prop" end
		cls = c.super
	end
	return nil
end

-- value type of a property ("float", "Vector3", ...) or nil
local function propType(cls, k)
	local guard = 0
	while cls and guard < 32 do
		guard += 1
		local c = API.classes[cls]
		if not c then return nil end
		local v = c.p[k]
		if v then return v ~= true and v or nil end
		cls = c.super
	end
	return nil
end

-- Unknown values must still behave like their type: Luau refuses to compare
-- a userdata with a number before looking at metamethods, so numeric
-- properties and datatype components are plain numbers (plausible defaults).
local NUMERIC_T = { float = true, double = true, int = true, int64 = true, int32 = true, int16 = true, number = true }
local NUM_DEFAULT = { Health = 100, MaxHealth = 100, WalkSpeed = 16, JumpPower = 50, JumpHeight = 7.2,
	HipHeight = 2, Gravity = 196.2, FieldOfView = 70, MaxSlopeAngle = 89, TimePosition = 0, Volume = 0.5,
	TimeLength = 1, Speed = 1, Brightness = 1, Range = 16, Size = 1 }
local DT_MEMBERS = {
	Vector3 = { X = "n", Y = "n", Z = "n", Magnitude = "n", Unit = "Vector3" },
	Vector2 = { X = "n", Y = "n", Magnitude = "n", Unit = "Vector2" },
	CFrame = { X = "n", Y = "n", Z = "n", Position = "Vector3", p = "Vector3", LookVector = "Vector3",
		RightVector = "Vector3", UpVector = "Vector3", XVector = "Vector3", YVector = "Vector3", ZVector = "Vector3",
		Rotation = "CFrame" },
	UDim2 = { X = "UDim", Y = "UDim", Width = "UDim", Height = "UDim" },
	UDim = { Scale = "n", Offset = "n" },
	Color3 = { R = "n", G = "n", B = "n" },
	NumberRange = { Min = "n", Max = "n" },
	Rect = { Width = "n", Height = "n", Min = "Vector2", Max = "Vector2" },
}

-- class of well-known properties / child names
local PROP_CLASS = {
	LocalPlayer = "Player", Character = "Model", CurrentCamera = "Camera", PlayerGui = "PlayerGui",
	Backpack = "Backpack", PrimaryPart = "Part", HumanoidRootPart = "Part", Head = "Part", Torso = "Part",
	UpperTorso = "MeshPart", LowerTorso = "MeshPart", PlayerScripts = "PlayerScripts", Terrain = "Terrain",
	leaderstats = "Folder", Animator = "Animator",
}

local function childClass(pi, key)
	if R.type(key) ~= "string" then return nil end
	if PROP_CLASS[key] then return PROP_CLASS[key] end
	if pi.className and memberKind(pi.className, key) == "prop" then return nil end
	if API.classes[key] and not API.enums[key] then return key end
	return nil
end

local function indexP(parent, key)
	local pi = INFO[parent]
	local c = pi.children[key]
	if c then return c end
	c = newP({ kind = "index", parent = parent, key = key,
		tname = pi.childT or "Instance",
		hint = R.type(key) == "string" and key or nil, ns = pi.ns,
		className = pi.tname == "Instance" and childClass(pi, key) or nil })
	pi.children[key] = c
	return c
end

-- Enum / EnumType / EnumItem objects with the real names and values
local enumRoot -- set once E.Enum exists
local function enumType(name)
	local c = INFO[enumRoot].children[name]
	if c then return c end
	c = indexP(enumRoot, name)
	INFO[c].tname = "Enum"
	INFO[c].enumName = name
	INFO[c].className = nil
	return c
end
local function enumItem(ename, iname)
	local et = enumType(ename)
	local c = INFO[et].children[iname]
	if c then return c end
	local item = API.enums[ename].byName[iname]
	c = indexP(et, iname)
	local info = INFO[c]
	info.tname = "EnumItem"
	info.enumName = ename
	info.className = nil
	info.props.Name = iname
	info.props.Value = item.Value
	info.props.EnumType = et
	return c
end

---------------------------------------------------------------------------
-- native twins (NATIVE only): proxy -> real engine value. Only pure objects
-- get one (datatypes, GUI instances, Path2D); services, remotes and the rest
-- of the game stay fake, so the script cannot reach the real place.
---------------------------------------------------------------------------
local REALV = R.setmetatable({}, { __mode = "k" })
-- raised by a datatypes.luau model for what it doesn't cover (stay symbolic)
CHAIN.DT_UNSUPPORTED = __ROBLOX and __ROBLOX.datatypes and __ROBLOX.datatypes.UNSUPPORTED
local NOREAL = R.setmetatable({}, { __tostring = function() return "<envlog: no native twin>" end })

local function unwrap(v, depth)
	if isP(v) then
		local r = REALV[v]
		if r == nil then R.error(NOREAL, 0) end
		return r
	elseif R.type(v) == "table" and depth < 3 then
		local t = {}
		for k, x in R.pairs(v) do t[unwrap(k, depth + 1)] = unwrap(x, depth + 1) end
		return t
	elseif R.type(v) == "function" or R.type(v) == "thread" then
		R.error(NOREAL, 0) -- never hand script functions to the engine
	end
	return v
end
-- packed args -> packed real args, or nil if something has no twin
local function unwrapArgs(args)
	local ok, out = R.pcall(function()
		local o = { n = args.n }
		for i = 1, args.n do o[i] = unwrap(args[i], 0) end
		return o
	end)
	if ok then return out end
	if out ~= NOREAL then R.error(out, 0) end
	return nil
end
-- is `v` (proxy or plain value) available as a real value?
local function realOf(v)
	if isP(v) then return REALV[v], REALV[v] ~= nil end
	if R.type(v) == "table" or R.type(v) == "function" then return nil, false end
	return v, true
end

local PLAIN_T = { number = true, string = true, boolean = true, ["nil"] = true, vector = true }
local function nativeClass(inst)
	return inst:IsA("GuiBase") or inst:IsA("UIBase")
end
-- turn a real engine value into what the script should see; `text` is the
-- source expression that produced it. Returns (value, true) or (nil, false)
-- when the value cannot be represented (the caller falls back to a proxy).
local function wrapReal(r, text, hint, depth)
	local t = R.type(r)
	if PLAIN_T[t] then return r, true end
	local tt = R.typeof(r)
	if tt == "userdata" and not NATIVE then tt = __ROBLOX.datatypes.typeOf(r) or tt end
	if tt == "EnumItem" then
		local ename = R.tostring(r.EnumType)
		if API.enums[ename] and API.enums[ename].byName[r.Name] then return enumItem(ename, r.Name), true end
		return nil, false
	end
	if tt == "Instance" or tt == "RBXScriptSignal" or tt == "RBXScriptConnection" or t == "function" or t == "thread" then
		return nil, false
	end
	if t == "table" then
		if (depth or 0) > 2 then return nil, false end
		local out = {}
		for k, x in R.pairs(r) do
			local w, ok = wrapReal(x, text .. "[" .. fmt(k) .. "]", hint, (depth or 0) + 1)
			if not ok then return nil, false end
			out[k] = w
		end
		return out, true
	end
	local p = exprP(text, tt, hint)
	REALV[p] = r
	return p, true
end
-- give a freshly made datatype proxy its twin: lib[k](...) or lib[k]
-- (offline: a datatypes.luau model value, when that type has a model)
local function attachReal(p, libName, k, call, ...)
	local lib
	if NATIVE then
		lib = REAL_G[libName]
	else
		lib = __ROBLOX and __ROBLOX.datatypes and __ROBLOX.datatypes[libName]
		if R.type(lib) ~= "table" then return end
	end
	if lib == nil then return end
	local u = unwrapArgs(table.pack(...))
	if not u then return end
	local ok, r = R.pcall(function()
		local f = lib[k]
		if call then return f(R.unpack(u, 1, u.n)) end
		return f
	end)
	if ok and r ~= nil and R.type(r) ~= "table" then REALV[p] = r end
end

---------------------------------------------------------------------------
-- Path2D replay cache: a Studio run records what the engine answered for
-- every Path2D method call; offline runs replay those answers (__P2D).
---------------------------------------------------------------------------
local P2D_LOG = {}
local P2D_MISS = false -- offline run needed a Path2D answer nobody recorded
local function p2dKey(name, args)
	local parts = { name }
	for i = 1, args.n do
		local a = args[i]
		parts[#parts + 1] = R.type(a) == "number" and R.fmt("%.17g", a) or R.tostring(R.typeof(a))
	end
	return R.concat(parts, "|")
end
local function p2dEncode(v)
	local t = R.typeof(v)
	if t == "number" then return R.fmt("n:%.17g", v) end
	if t == "UDim2" then return R.fmt("u:%.17g,%.17g,%.17g,%.17g", v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset) end
	if t == "Vector2" then return R.fmt("v:%.17g,%.17g", v.X, v.Y) end
	if t == "nil" then return "z:" end
	return nil
end
local function p2dDecode(str, text)
	local kind, rest = R.match(str, "^(%a):(.*)$")
	if kind == "n" then return R.tonumber(rest) end
	if kind == "z" then return nil end
	local nums = {}
	for x in string.gmatch(rest, "[^,]+") do nums[#nums + 1] = R.tonumber(x) end
	if kind == "u" then
		local p = exprP(text, "UDim2", "position")
		local xs = exprP(text .. ".X", "UDim", "X")
		INFO[xs].props.Scale, INFO[xs].props.Offset = nums[1], nums[2]
		local ys = exprP(text .. ".Y", "UDim", "Y")
		INFO[ys].props.Scale, INFO[ys].props.Offset = nums[3], nums[4]
		INFO[p].props.X, INFO[p].props.Y = xs, ys
		INFO[p].props.Width, INFO[p].props.Height = xs, ys
		return p
	end
	if kind == "v" then
		local p = exprP(text, "Vector2", "vector")
		INFO[p].props.X, INFO[p].props.Y = nums[1], nums[2]
		INFO[p].props.Magnitude = math.sqrt(nums[1] * nums[1] + nums[2] * nums[2])
		return p
	end
	return nil
end

-- a call whose result gets a local only if the result is used later
local function callP(text, hint, tname, force)
	local p = newP({ kind = "call", tname = tname or "Instance", hint = hint })
	local st = emit({ call = text, res = p })
	INFO[p].stmt = st
	if force then INFO[p].forceVar = true end
	return p
end

---------------------------------------------------------------------------
-- callback capture
---------------------------------------------------------------------------
local FUNCS = {} -- function -> fid
local FREC = {} -- fid -> { params, block }
local nextFid = 0
local captureDepth = 0
local paramCounter = {}

local function paramName(base)
	paramCounter[base] = (paramCounter[base] or 0) + 1
	local n = paramCounter[base]
	return n == 1 and base or (base .. n)
end

local popTo -- forward

local lastThread = nil

-- Callbacks (task.spawn, event handlers, ...) run in a thread of their own, as
-- they do in Roblox; Luraph checks this by closing a thread it captured with
-- coroutine.running() inside a spawned function.
local function runInBlock(block, fn, ...)
	block.isRoot = true
	R.insert(STACK, block)
	local level = #STACK
	captureDepth += 1
	local th = R.type(fn) == "thread" and fn or coroutine.create(fn)
	lastThread = th
	local res = table.pack(coroutine.resume(th, ...))
	if res[1] and res[2] == ABORT and coroutine.status(th) == "suspended" then res = { false, ABORT, n = 2 } end
	captureDepth -= 1
	popTo(level - 1)
	if not res[1] then
		local err = res[2]
		if err == ABORT then
			R.insert(block.lines, { text = "-- [envlog] trace budget ran out here: " .. R.tostring(ABORT_REASON) })
			R.error(ABORT, 0)
		elseif err == TAMPER then
			if CFG.debug_tamper then R.print("[tamper-in-block]", debug.traceback()) end
			R.insert(block.lines, { text = "-- [envlog] Luraph integrity-check thread (anti-tamper) suppressed here" })
		elseif err ~= LOOP then
			R.insert(block.lines, { text = "-- [envlog] error: " .. R.gsub(R.tostring(err), "\n", " ") })
		end
	end
	return res
end

-- Runs `fn` with fresh parameter proxies and returns a token standing for
-- `function(params) <recorded body> end`.
local DEFERRED = {}
-- event handlers: recorded after the main script, never while it runs (Luraph
-- connects tamper responses to signals that must not fire, e.g.
-- game.DescendantRemoving; running those early looks like tampering)
local HANDLERS = {}

function captureFunction(fn, names, args, defer)
	local fid = FUNCS[fn]
	if fid and not defer then return "\3" .. fid .. "\4" end
	nextFid += 1
	fid = nextFid
	FUNCS[fn] = fid
	local rec = { params = {}, block = { lines = {}, waits = {} } }
	FREC[fid] = rec
	if captureDepth >= MAX_DEPTH then
		R.insert(rec.block.lines, { text = "-- [envlog] nesting too deep" })
		return "\3" .. fid .. "\4"
	end
	local callArgs = {}
	if args then
		callArgs = args
		rec.params = { "..." }
	else
		names = names or { "...", "..." }
		local vararg = names[1] == "..."
		for i, nm in names do
			local pn = vararg and paramName("arg") or paramName(nm)
			rec.params[i] = pn
			callArgs[i] = newP({ kind = "name", gen = true, name = pn, tname = "Instance" })
		end
	end
	if defer == "handler" then
		R.insert(HANDLERS, { rec = rec, fn = fn, args = callArgs, n = args and args.n or #callArgs })
		return "\3" .. fid .. "\4"
	end
	if defer then
		-- task.delay / task.defer: the thread exists now but only runs after the
		-- main script, and only if nothing cancelled it in the meantime
		local th = coroutine.create(fn)
		lastThread = th
		R.insert(DEFERRED, { rec = rec, thread = th, args = callArgs, n = args and args.n or #callArgs, due = defer })
		return "\3" .. fid .. "\4"
	end
	local tryAlt = CFG._cbtry and not args
	CFG._cbtry = nil
	local res = runInBlock(rec.block, fn, R.unpack(callArgs, 1, args and args.n or #callArgs))
	-- a UI callback (Toggle etc.) ran with a truthy stand-in; run it again with
	-- `false` so the "off" path is recorded too. Kept only if that run finishes
	-- cleanly (sliders, dropdowns ... fail on a boolean and are left as they were).
	if tryAlt and res[1] and #callArgs >= 1 then
		local alt = { lines = {}, waits = {} }
		local r2 = runInBlock(alt, fn, false, R.unpack(callArgs, 2, #callArgs))
		local clean = r2[1]
		for _, s in alt.lines do
			if s.text and R.find(s.text, "-- [envlog]", 1, true) then clean = false end
		end
		if clean then
			rec.alt = alt
			local pn = "state" -- each callback is its own scope
			INFO[callArgs[1]].name = pn
			rec.params[1] = pn
		end
	end
	return "\3" .. fid .. "\4"
end

local function runHandlers()
	local i = 1
	while i <= #HANDLERS do
		local h = HANDLERS[i]
		i += 1
		popTo(1)
		local ok, err = R.pcall(runInBlock, h.rec.block, h.fn, R.unpack(h.args, 1, h.n))
		if not ok and err == ABORT then return end
	end
end

local function runDeferred()
	while #DEFERRED > 0 do
		table.sort(DEFERRED, function(a, b) return a.due < b.due end)
		local d = R.remove(DEFERRED, 1)
		if coroutine.status(d.thread) == "suspended" then
			local ok, err = R.pcall(runInBlock, d.rec.block, d.thread, R.unpack(d.args, 1, d.n))
			if not ok and err == ABORT then return end
		else
			R.insert(d.rec.block.lines, { text = "-- [envlog] cancelled before it ran" })
		end
	end
end

---------------------------------------------------------------------------
-- open-ended blocks (for ... in pairs(proxy) do)
---------------------------------------------------------------------------
function popTo(level)
	while #STACK > level do
		local b = STACK[#STACK]
		STACK[#STACK] = nil
		if b.onClose then b.onClose() end
	end
end

local function iterProxy(p, how)
	local state = 0
	local kp, vp
	return function()
		state += 1
		if state == 1 then
			local b = { lines = {}, waits = {} }
			kp = newP({ kind = "name", gen = true, name = paramName(how == "ipairs" and "i" or "k"), tname = "number" })
			vp = newP({ kind = "name", gen = true, name = paramName("v"), tname = "Instance" })
			local header = "for " .. tok(kp) .. ", " .. tok(vp) .. " in " ..
				(how and (how .. "(" .. tok(p) .. ")") or tok(p)) .. " do"
			emit({ header = header, block = b })
			R.insert(STACK, b)
			b.level = #STACK
			return kp, vp
		end
		-- second call: the loop body ran once, close the block
		for i = #STACK, 1, -1 do
			if STACK[i].level == i and STACK[i].header == nil then
				-- find our block
			end
		end
		popTo(#STACK - 1)
		return nil
	end
end

---------------------------------------------------------------------------
-- loop detection for wait()
---------------------------------------------------------------------------
local function normalize(block, from, to, baseId, baseFid)
	local parts = {}
	for i = from, to do
		local s = block.lines[i]
		local text = s.text or s.call or s.header or ""
		text = R.gsub(text, "\1(%d+)\2", function(id)
			id = R.tonumber(id)
			return id >= baseId and ("\1r" .. (id - baseId) .. "\2") or nil
		end)
		text = R.gsub(text, "\3(%d+)\4", function(id)
			id = R.tonumber(id)
			return id >= baseFid and ("\3r" .. (id - baseFid) .. "\4") or nil
		end)
		parts[#parts + 1] = text
	end
	return R.concat(parts, "\n")
end

local function onWait()
	local b = curBlock()
	local w = b.waits
	R.insert(w, { line = #b.lines, id = nextId, fid = nextFid })
	local n = #w
	if n >= 3 then
		local a, m, c = w[n - 2], w[n - 1], w[n]
		if c.line - m.line == m.line - a.line then
			local s1 = normalize(b, a.line + 1, m.line, a.id, a.fid)
			local s2 = normalize(b, m.line + 1, c.line, m.id, m.fid)
			if s1 == s2 then
				for _ = m.line + 1, c.line do
					R.remove(b.lines)
				end
				R.insert(b.lines, { text = "-- [envlog] the statements above repeat forever (loop)" })
				b.stopped = 0
				R.error(LOOP, 0)
			end
		end
	end
	-- the same, on the thread's flat statement tape: catches loops whose
	-- repetitions end up nested in blocks that were never closed
	local root, rootLevel = nil, 1
	for i = #STACK, 1, -1 do
		if STACK[i].isRoot or i == 1 then root, rootLevel = STACK[i], i; break end
	end
	root.tape = root.tape or {}
	root.marks = root.marks or {}
	local marks = root.marks
	R.insert(marks, { pos = #root.tape, id = nextId, fid = nextFid, depth = #STACK, block = b })
	local nm = #marks
	if nm >= 3 then
		local m1, m2, m3 = marks[nm - 2], marks[nm - 1], marks[nm]
		local k = m2.pos - m1.pos
		if CFG.debug_loops then R.print("[loop marks]", m1.pos, m2.pos, m3.pos, m1.depth, m2.depth, m3.depth) end
		if k > 0 and m3.pos - m2.pos == k and m3.depth > m2.depth then
			local function seg(from, to, baseId, baseFid)
				-- proxies: named/indexed ones by their path (stable across
				-- repetitions even when first created in the first one), call
				-- results by order of appearance
				local order, n = {}, 0
				local function path(q, d)
					local qi = q and INFO[q]
					if not qi or d > 12 then return "?" end
					if qi.kind == "name" and not qi.gen then return qi.name or "?" end
					if qi.kind == "index" and qi.parent then return path(qi.parent, d + 1) .. "." .. R.tostring(qi.key) end
					if not order[q] then n += 1; order[q] = n end
					return "#" .. order[q]
				end
				local parts = {}
				for i = from, to do
					local st = root.tape[i].stmt
					local text = st.text or st.call or st.header or ""
					if st.res and isP(st.res) then text = text .. " ->" .. path(st.res, 0) end
					text = R.gsub(text, "\1(%d+)\2", function(id)
						return "\1" .. path(BYID[R.tonumber(id)], 0) .. "\2"
					end)
					text = R.gsub(text, "\3(%d+)\4", function(id)
						id = R.tonumber(id)
						return id >= baseFid and ("\3r" .. (id - baseFid) .. "\4") or nil
					end)
					parts[#parts + 1] = text
				end
				return R.concat(parts, "\n")
			end
			local sA, sB = seg(m1.pos + 1, m2.pos, m1.id, m1.fid), seg(m2.pos + 1, m3.pos, m2.id, m2.fid)
			if CFG.debug_loops and sA ~= sB then R.print("[loop A]\n" .. sA .. "\n[loop B]\n" .. sB) end
			if sA == sB then
				-- drop the second repetition (newest first: each is the last line of its block)
				for i = m3.pos, m2.pos + 1, -1 do
					local e = root.tape[i]
					if e.block.lines[#e.block.lines] == e.stmt then R.remove(e.block.lines) end
					root.tape[i] = nil
				end
				-- close whatever the first repetition left open
				popTo(m1.depth)
				local home = curBlock()
				-- the wait that ended the first repetition belongs after those blocks
				local w = root.tape[m2.pos]
				if w and w.block ~= home and w.block.lines[#w.block.lines] == w.stmt then
					R.remove(w.block.lines)
					R.insert(home.lines, w.stmt)
				end
				R.insert(home.lines, { text = "-- [envlog] the statements above repeat forever (loop)" })
				home.stopped = 0
				R.error(LOOP, 0)
			end
		end
	end
	if n > MAX_WAITS then
		R.insert(b.lines, { text = "-- [envlog] stopped after " .. MAX_WAITS .. " waits" })
		b.stopped = 0
		R.error(LOOP, 0)
	end
end

---------------------------------------------------------------------------
-- known API behaviour
---------------------------------------------------------------------------
local DATATYPES = {
	Vector3 = 1, Vector2 = 1, Vector3int16 = 1, Vector2int16 = 1, CFrame = 1, Color3 = 1,
	UDim = 1, UDim2 = 1, BrickColor = 1, TweenInfo = 1, NumberRange = 1, NumberSequence = 1,
	NumberSequenceKeypoint = 1, ColorSequence = 1, ColorSequenceKeypoint = 1, Ray = 1,
	Rect = 1, Region3 = 1, Region3int16 = 1, PhysicalProperties = 1, Font = 1,
	DateTime = 1, Axes = 1, Faces = 1, PathWaypoint = 1, SharedTable = 1, OverlapParams = 1,
	RaycastParams = 1, CatalogSearchParams = 1, DockWidgetPluginGuiInfo = 1, Path2DControlPoint = 1,
	Content = 1, SecurityCapabilities = 1, FloatCurveKey = 1, RotationCurveKey = 1, ValueCurveKey = 1,
	CFrameCurveKey = 1, UniqueId = 1,
}

local SIGNAL_PARAMS = {
	PlayerAdded = { "player" }, PlayerRemoving = { "player" },
	CharacterAdded = { "character" }, CharacterRemoving = { "character" }, CharacterAppearanceLoaded = { "character" },
	Touched = { "hit" }, TouchEnded = { "hit" },
	InputBegan = { "input", "gameProcessed" }, InputEnded = { "input", "gameProcessed" },
	InputChanged = { "input", "gameProcessed" },
	Heartbeat = { "deltaTime" }, RenderStepped = { "deltaTime" }, PreSimulation = { "deltaTime" },
	PostSimulation = { "deltaTime" }, PreRender = { "deltaTime" }, Stepped = { "time", "deltaTime" },
	ChildAdded = { "child" }, ChildRemoved = { "child" },
	DescendantAdded = { "descendant" }, DescendantRemoving = { "descendant" },
	Changed = { "value" }, HealthChanged = { "health" }, Chatted = { "message" },
	FocusLost = { "enterPressed", "inputObject" }, Triggered = { "player" },
	PromptTriggered = { "prompt", "player" }, PromptButtonHoldBegan = { "prompt", "player" },
	Idled = { "idleTime" }, MouseButton1Click = {}, MouseButton1Down = { "x", "y" },
	Activated = { "inputObject", "clickCount" }, Died = {}, Event = { "..." },
	OnClientEvent = { "..." }, OnClientInvoke = { "..." }, OnInvoke = { "..." },
	AncestryChanged = { "child", "parent" }, AttributeChanged = { "attribute" },
	StateChanged = { "old", "new" }, MoveToFinished = { "reached" }, Completed = { "playbackState" },
}

local CLASS_HINT = {
	GetChildren = "children", GetDescendants = "descendants", GetPlayers = "players",
	GetTouchingParts = "parts", GetPartsInPart = "parts", GetPartBoundsInBox = "parts",
	GetPartBoundsInRadius = "parts", GetTagged = "tagged", GetAttributes = "attributes",
	GetPlayingAnimationTracks = "tracks", GetConnectedParts = "parts", GetJoints = "joints",
	GetChildrenOfClass = "children",
}
-- names for results of other well-known methods (rendering only)
for k, v in {
	JSONEncode = "json", JSONDecode = "data", HttpGet = "response", HttpGetAsync = "response",
	GetAsync = "response", PostAsync = "response", RequestAsync = "response",
	Inverse = "inverse", ToWorldSpace = "cframe", ToObjectSpace = "cframe",
	Raycast = "raycastResult", GetMouse = "mouse", LoadAnimation = "track",
	InvokeServer = "response", Clone = "clone",
	GetPropertyChangedSignal = "changedSignal", GetAttribute = "attribute",
	GenerateGUID = "guid", UrlEncode = "encoded", Notify = "notification",
} do
	CLASS_HINT[k] = v
end
-- UI library objects: Window:Tab() -> Tab, Tab:Toggle() -> Toggle
for _, n in { "Window", "Tab", "Section", "Toggle", "Button", "Slider", "Dropdown", "Input",
	"Keybind", "Colorpicker", "Paragraph", "Dialog", "Label", "Textbox", "Divider", "Popup",
	"Code", "Group", "Page", "Category", "Checkbox", "ColorPicker", "TextBox" } do
	CLASS_HINT[n] = n
end

local serviceCache = {}
local GAMEP -- the game proxy (set once it exists)
local WORKSPACEP -- the workspace proxy
local urls = {}
local remotes = {}

local function methodName(info)
	if info.kind == "index" and R.type(info.key) == "string" then return info.key end
	return nil
end

local function remember(list, v)
	if not list[v] then
		list[v] = true
		R.insert(list, v)
	end
end

-- invoked for every call of a proxy
-- A small model of the instance tree for objects the script creates itself,
-- so FindFirstChild/GetChildren/Destroy behave like Roblox for them.
local function instName(p)
	local v = INFO[p].props.Name
	if R.type(v) == "string" then return v end
	return INFO[p].className or "Instance"
end
local function kidsOf(p)
	local info = INFO[p]
	info.kids = info.kids or {}
	return info.kids
end
local function setParent(child, parent)
	local ci = INFO[child]
	local old = ci.props.Parent
	if isP(old) then
		local list = kidsOf(old)
		for i = #list, 1, -1 do
			if list[i] == child then R.remove(list, i) end
		end
	end
	if isP(parent) then R.insert(kidsOf(parent), child) end
	ci.props.Parent = parent
	local rc = REALV[child]
	if rc ~= nil and R.typeof(rc) == "Instance" then
		local rp = isP(parent) and REALV[parent] or nil
		R.pcall(function() rc.Parent = (R.typeof(rp) == "Instance") and rp or nil end)
	end
end
local function findKid(p, name, recursive)
	for _, c in kidsOf(p) do
		if instName(c) == name then return c end
	end
	if recursive then
		for _, c in kidsOf(p) do
			local r = findKid(c, name, true)
			if r then return r end
		end
	end
	return nil
end
local function descendants(p, out)
	for _, c in kidsOf(p) do
		R.insert(out, c)
		descendants(c, out)
	end
	return out
end
local function destroyInst(p)
	local info = INFO[p]
	if info.destroyed then return end
	for _, c in table.clone(kidsOf(p)) do destroyInst(c) end
	if isP(info.props.Parent) then setParent(p, nil) end
	info.props.Parent = nil
	info.destroyed = true
	local r = REALV[p]
	if r ~= nil and R.typeof(r) == "Instance" then R.pcall(r.Destroy, r) end
end
local RUNSERVICE_BOOL = { IsStudio = false, IsServer = false, IsClient = true, IsRunning = true,
	IsRunMode = false, IsEdit = false }

local NO_NATIVE_METHOD = { Clone = 1, Destroy = 1, Remove = 1, GetChildren = 1, GetDescendants = 1,
	FindFirstChild = 1, WaitForChild = 1, FindFirstChildOfClass = 1, FindFirstChildWhichIsA = 1,
	FindFirstAncestor = 1, FindFirstAncestorOfClass = 1, FindFirstAncestorWhichIsA = 1, FindFirstDescendant = 1,
	ClearAllChildren = 1, IsA = 1, Connect = 1, Once = 1, Wait = 1, GetPropertyChangedSignal = 1,
	GetAttributeChangedSignal = 1, IsDescendantOf = 1, IsAncestorOf = 1, GetFullName = 1 }
---------------------------------------------------------------------------
-- Offline Path2D model (bit-exact float32 reproduction of the engine; see
-- research/path2d/README.md). Used when no recorded answer exists.
--   points: pixel = f32(f32(scale*W) + offset) in the parent Frame's size;
--   segment i: P0, [P0+right_i], [P3+left_{i+1}], P3 (handles that are 0 px
--   are left out: cubic / quadratic / linear); power basis, Horner in f32.
--   GetLength: per segment, adaptive bisection in t: chord a, half chords
--   b = |p0-pm| + |pm-p1|; b - a < 1e-5 -> b, else recurse; summed as a
--   tree; segment lengths summed in order.
--   ArcLength variants: s = f32(t*L), segment by cumulative lengths (first
--   with s <= end), local u = s'/len for lines. Curves: CHAIN.p2d.arcU.
---------------------------------------------------------------------------
do
	local FB = buffer.create(4)
	local function f32(x)
		buffer.writef32(FB, 0, x)
		return buffer.readf32(FB, 0)
	end
	local M = {}
	CHAIN.p2d = M
	M.f32 = f32

	local function num(x)
		if R.type(x) == "number" then return x end
		return 0
	end
	-- UDim2 proxy -> {sx, ox, sy, oy}
	function M.udim2(p)
		if not isP(p) then return nil end
		local inf = INFO[p]
		local c = inf.ctor
		if c and c.ns == "UDim2" then
			local a = c.args
			if c.fn == "new" then
				if isP(a[1]) or isP(a[2]) then
					local x, y = INFO[a[1]] and INFO[a[1]].ctor, INFO[a[2]] and INFO[a[2]].ctor
					return { x and num(x.args[1]) or 0, x and num(x.args[2]) or 0, y and num(y.args[1]) or 0,
						y and num(y.args[2]) or 0 }
				end
				return { num(a[1]), num(a[2]), num(a[3]), num(a[4]) }
			elseif c.fn == "fromScale" then
				return { num(a[1]), 0, num(a[2]), 0 }
			elseif c.fn == "fromOffset" then
				return { 0, num(a[1]), 0, num(a[2]) }
			end
			return nil
		end
		local X, Y = inf.props and inf.props.X, inf.props and inf.props.Y
		if isP(X) and isP(Y) then
			local xp, yp = INFO[X].props, INFO[Y].props
			return { num(xp.Scale), num(xp.Offset), num(yp.Scale), num(yp.Offset) }
		end
		return nil
	end
	-- the Frame a Path2D sits in: absolute size from offset-only sizes
	function M.frameSize(path)
		local parent = INFO[path].props and INFO[path].props.Parent
		if not isP(parent) then return nil end
		local sz = INFO[parent].props and INFO[parent].props.Size
		local u = sz and M.udim2(sz)
		if not u then return nil end
		if u[1] ~= 0 or u[3] ~= 0 then return nil end -- would need the viewport size
		return u[2], u[4]
	end
	local function resolve(u, W, H)
		return f32(f32(u[1] * W) + u[2]), f32(f32(u[3] * H) + u[4])
	end
	-- control point proxies -> list of segments {x0,y0, x1,y1, ...} (pixels)
	function M.segments(cps, W, H)
		local pts = {}
		for i, cp in R.ipairs(cps) do
			local c = isP(cp) and INFO[cp].ctor
			if not c or c.ns ~= "Path2DControlPoint" then return nil end
			local zero = { 0, 0, 0, 0 }
			local pos = c.args.n >= 1 and M.udim2(c.args[1]) or zero
			local left = c.args.n >= 2 and M.udim2(c.args[2]) or zero
			local right = c.args.n >= 3 and M.udim2(c.args[3]) or zero
			if not pos or not left or not right then return nil end
			local px, py = resolve(pos, W, H)
			local lx, ly = resolve(left, W, H)
			local rx, ry = resolve(right, W, H)
			pts[i] = { px, py, lx, ly, rx, ry }
		end
		local segs = {}
		for i = 1, #pts - 1 do
			local a, b = pts[i], pts[i + 1]
			local s = { a[1], a[2] }
			if a[5] ~= 0 or a[6] ~= 0 then
				R.insert(s, f32(a[1] + a[5])); R.insert(s, f32(a[2] + a[6]))
			end
			if b[3] ~= 0 or b[4] ~= 0 then
				R.insert(s, f32(b[1] + b[3])); R.insert(s, f32(b[2] + b[4]))
			end
			R.insert(s, b[1]); R.insert(s, b[2])
			segs[i] = M.coeffs(s)
		end
		return segs
	end
	-- power basis coefficients (f32, same association as the engine)
	function M.coeffs(s)
		local n = #s // 2
		local x0, y0 = s[1], s[2]
		local c = { n = n, x0 = x0, y0 = y0 }
		if n == 2 then
			c.c1x, c.c1y = f32(s[3] - x0), f32(s[4] - y0)
		elseif n == 3 then
			local x1, y1, x2, y2 = s[3], s[4], s[5], s[6]
			c.c1x, c.c1y = f32(f32(x1 - x0) * 2), f32(f32(y1 - y0) * 2)
			c.c2x, c.c2y = f32(f32(x0 - f32(x1 * 2)) + x2), f32(f32(y0 - f32(y1 * 2)) + y2)
		else
			local x1, y1, x2, y2, x3, y3 = s[3], s[4], s[5], s[6], s[7], s[8]
			c.c1x, c.c1y = f32(f32(x1 - x0) * 3), f32(f32(y1 - y0) * 3)
			c.c2x = f32(f32(f32(x0 - f32(x1 * 2)) + x2) * 3)
			c.c2y = f32(f32(f32(y0 - f32(y1 * 2)) + y2) * 3)
			c.c3x = f32(f32(f32(x3 - x0) + f32(x1 * 3)) - f32(x2 * 3))
			c.c3y = f32(f32(f32(y3 - y0) + f32(y1 * 3)) - f32(y2 * 3))
		end
		return c
	end
	function M.eval(c, u)
		if c.n == 2 then
			return f32(c.x0 + f32(c.c1x * u)), f32(c.y0 + f32(c.c1y * u))
		elseif c.n == 3 then
			return f32(c.x0 + f32(f32(c.c1x + f32(c.c2x * u)) * u)), f32(c.y0 + f32(f32(c.c1y + f32(c.c2y * u)) * u))
		end
		local ix, iy = f32(c.c2x + f32(c.c3x * u)), f32(c.c2y + f32(c.c3y * u))
		return f32(c.x0 + f32(f32(c.c1x + f32(ix * u)) * u)), f32(c.y0 + f32(f32(c.c1y + f32(iy * u)) * u))
	end
	function M.tangent(c, u)
		if c.n == 2 then return c.c1x, c.c1y end
		if c.n == 3 then
			local k = f32(u * 2)
			return f32(c.c1x + f32(c.c2x * k)), f32(c.c1y + f32(c.c2y * k))
		end
		local k = f32(3 * u)
		return f32(c.c1x + f32(u * f32(f32(c.c2x * 2) + f32(c.c3x * k)))),
			f32(c.c1y + f32(u * f32(f32(c.c2y * 2) + f32(c.c3y * k))))
	end
	local function dist(ax, ay, bx, by)
		local dx, dy = f32(bx - ax), f32(by - ay)
		return f32(math.sqrt(f32(f32(dx * dx) + f32(dy * dy))))
	end
	M.dist = dist
	local TOL = f32(1e-5)
	-- B(u) - P0 (the length routine leaves out the P0 term: other rounding)
	function M.eval0(c, u)
		if c.n == 2 then
			return f32(c.c1x * u), f32(c.c1y * u)
		elseif c.n == 3 then
			return f32(f32(c.c1x + f32(c.c2x * u)) * u), f32(f32(c.c1y + f32(c.c2y * u)) * u)
		end
		local ix, iy = f32(c.c2x + f32(c.c3x * u)), f32(c.c2y + f32(c.c3y * u))
		return f32(f32(c.c1x + f32(ix * u)) * u), f32(f32(c.c1y + f32(iy * u)) * u)
	end
	function M.seglen(c)
		local function rec(t0, t1, x0, y0, x1, y1, depth)
			local tm = f32(f32(t0 + t1) * 0.5)
			local xm, ym = M.eval0(c, tm)
			local a = dist(x0, y0, x1, y1)
			local b = f32(dist(x0, y0, xm, ym) + dist(xm, ym, x1, y1))
			if depth >= 30 or f32(b - a) < TOL then return b end
			return f32(rec(t0, tm, x0, y0, xm, ym, depth + 1) + rec(tm, t1, xm, ym, x1, y1, depth + 1))
		end
		local x0, y0 = M.eval0(c, 0)
		local x1, y1 = M.eval0(c, 1)
		return rec(0, 1, x0, y0, x1, y1, 0)
	end
	-- arc length s (pixels, from the segment start) -> u: the engine integrates
	-- du/ds = 1/|B'(u)| with 32 classic RK4 steps (k = h/|B'|), in f32, with
	-- its own derivative form (2*c2 and 3*c3 precomputed)
	local SIXTH = f32(1 / 6)
	function M.arcU(c, s)
		local d2x, d2y = f32(c.c2x * 2), f32(c.c2y * 2)
		local d3x, d3y
		if c.n == 4 then d3x, d3y = f32(c.c3x * 3), f32(c.c3y * 3) end
		local function inv(u)
			local dx, dy
			if c.n == 3 then
				dx, dy = f32(c.c1x + f32(d2x * u)), f32(c.c1y + f32(d2y * u))
			else
				dx = f32(c.c1x + f32(u * f32(d2x + f32(u * d3x))))
				dy = f32(c.c1y + f32(u * f32(d2y + f32(u * d3y))))
			end
			return math.sqrt(f32(f32(dx * dx) + f32(dy * dy)))
		end
		local h = f32(s / 32)
		local u = 0
		for _ = 1, 32 do
			local k1 = f32(h / f32(inv(u)))
			local k2 = f32(h / f32(inv(f32(u + f32(k1 * 0.5)))))
			local k3 = f32(h / f32(inv(f32(u + f32(k2 * 0.5)))))
			local k4 = f32(h / f32(inv(f32(u + k3))))
			u = f32(u + f32(f32(f32(k1 + f32(2 * f32(k2 + k3))) + k4) * SIXTH))
		end
		return u
	end
	function M.length(segs)
		local t = 0
		for _, c in R.ipairs(segs) do
			c.len = c.len or M.seglen(c)
			t = f32(t + c.len)
		end
		return t
	end
	-- t in [0,1] -> segment, local u (GetPositionOnCurve / GetTangentOnCurve)
	function M.locate(segs, t)
		t = f32(t)
		if t < 0 then t = 0 elseif t > 1 then t = 1 end
		local n = #segs
		local x = f32(t * n)
		local k = math.min(math.floor(x), n - 1)
		return segs[k + 1], f32(x - k)
	end
	-- arc-length fraction -> segment, local u (nil when the curve model is unknown)
	function M.locateArc(segs, t)
		t = f32(t)
		if t < 0 then t = 0 elseif t > 1 then t = 1 end
		local L = M.length(segs)
		local s = f32(t * L)
		-- the engine walks the segments subtracting each length from s
		for _, c in R.ipairs(segs) do
			if s <= c.len then
				if c.n == 2 then return c, f32(s / c.len) end
				return c, M.arcU(c, s)
			end
			s = f32(s - c.len)
		end
		return segs[1], 0
	end
	-- the engine's answer as a replay-cache record (p2dEncode format), or nil
	function M.answer(path, name, t)
		local inf = INFO[path]
		local segs = inf.p2dSegs
		if not segs then return nil end
		local W, H = inf.p2dW, inf.p2dH
		if name == "GetLength" then
			return R.fmt("n:%.17g", M.length(segs))
		end
		if R.type(t) ~= "number" then return nil end
		local c, u
		if name == "GetPositionOnCurve" or name == "GetTangentOnCurve" then
			c, u = M.locate(segs, t)
		elseif name == "GetPositionOnCurveArcLength" or name == "GetTangentOnCurveArcLength" then
			c, u = M.locateArc(segs, t)
		end
		if not c then return nil end
		if R.find(name, "Position", 1, true) then
			local x, y = M.eval(c, u)
			return R.fmt("u:%.17g,0,%.17g,0", f32(x / W), f32(y / H))
		end
		local x, y = M.tangent(c, u)
		return R.fmt("v:%.17g,%.17g", x, y)
	end
end

local function onCall(p, ...)
	checkBudget()
	local info = INFO[p]
	if CFG.ptrace then
		local a2 = R.select(2, ...)
		R.print("[call]", info.name or info.hint or info.key, R.select("#", ...), R.type(a2) == "string" and a2 or "")
	end
	local n = R.select("#", ...)
	local first = ...
	local name = methodName(info)
	local isMethod = info.kind == "index" and n >= 1 and first == info.parent and isP(first)
	local calleeText
	local args
	if isMethod then
		calleeText = tok(info.parent) .. ":" .. (isIdent(name) and name or "__call")
		args = table.pack(R.select(2, ...))
	else
		calleeText = tok(p)
		args = table.pack(...)
	end
	local a1 = args[1]

	-- --cfg falsy=a,b: calls of these names return false (explore other branches)
	if CFG.falsy and R.type(name) == "string" and R.find("," .. CFG.falsy .. ",", "," .. name .. ",", 1, true) then
		emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ") --> false" })
		return false
	end

	-- datatype constructors are pure: keep them inline
	if info.ns and DATATYPES[info.ns] then
		local dp = exprP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", info.ns)
		-- constructor arguments (the offline Path2D model reads UDim2 / control points)
		INFO[dp].ctor = { ns = info.ns, fn = name, args = args }
		return dp
	end

	-- event connections: record the handler body
	if name == "Connect" or name == "Once" or name == "ConnectParallel" then
		local sig = INFO[info.parent]
		local sigName = sig and methodName(sig)
		if CFG.input_text ~= nil then
			-- simulate user input: text boxes hold this text when handlers run
			for _, bp in R.pairs(BYID) do
				local bi = INFO[bp]
				if bi.created and bi.className == "TextBox" and bi.props.Text ~= CFG.input_text then
					bi.props.Text = CFG.input_text
					local rb = REALV[bp]
					if rb ~= nil then R.pcall(function() rb.Text = CFG.input_text end) end
				end
			end
		end
		local fnTok = R.type(a1) == "function" and captureFunction(a1, SIGNAL_PARAMS[sigName] or { "..." }, nil, "handler") or fmt(a1)
		local conn = callP(calleeText .. "(" .. fnTok .. ")", "connection", "RBXScriptConnection")
		INFO[conn].props.Connected = true
		return conn
	end
	if name == "Wait" and isMethod then
		-- frame signals return numbers (Script42 checks typeof(Heartbeat:Wait()))
		local sp = SIGNAL_PARAMS[methodName(INFO[info.parent])]
		if sp and (sp[1] == "deltaTime" or sp[2] == "deltaTime") then
			emit({ text = calleeText .. "()" })
			onWait()
			if sp[2] == "deltaTime" then return 1, 1 / 60 end
			return 1 / 60
		end
		callP(calleeText .. "()", "result")
		local r = BYID[nextId]
		onWait() -- a yield: lets the loop detector see signal-driven loops
		return r
	end

	if name == "GetService" or name == "FindService" then
		local svc = a1
		if R.type(svc) == "string" and serviceCache[svc] then
			return serviceCache[svc]
		end
		-- unknown names: Roblox errors (GetService) / returns nil (FindService);
		-- Script42 checks GetService("RunsServices") and spins if it succeeds
		if R.type(svc) == "string" and not API.classes[svc] then
			if name == "FindService" then return nil end
			R.error(R.fmt("'%s' is not a valid Service name", svc), 0)
		end
		local r = callP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", R.type(svc) == "string" and svc or "service", "Instance", true)
		if R.type(svc) == "string" and API.classes[svc] then
			INFO[r].className = svc
			INFO[r].props.Name = svc
			INFO[r].props.ClassName = svc
			INFO[r].props.Parent = GAMEP
		end
		if R.type(svc) == "string" then serviceCache[svc] = r end
		return r
	end

	-- secrets don't exist on a client (Script42's key system matches this message)
	if name == "GetSecret" and isMethod then
		emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ") -- errors" })
		R.error("Can't find secret with given key", 0)
	end

	-- teleport settings are a real key/value store (Script42 reads back what it set)
	if (name == "SetTeleportSetting" or name == "GetTeleportSetting") and isMethod then
		local store = INFO[info.parent].tpSettings or {}
		INFO[info.parent].tpSettings = store
		if name == "SetTeleportSetting" then
			emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")" })
			if args[1] ~= nil then store[args[1]] = args[2] end
			return
		end
		return args[1] ~= nil and store[args[1]] or nil
	end

	local self = isMethod and info.parent or nil
	local sinfo = self and INFO[self]
	if sinfo and sinfo.tname == "RBXScriptConnection" and name == "Disconnect" then
		emit({ text = calleeText .. "()" })
		sinfo.props.Connected = false
		return
	end
	if sinfo and sinfo.tname == "Enum" and sinfo.enumName then
		local e = API.enums[sinfo.enumName]
		if name == "GetEnumItems" then
			local list = {}
			for _, it in e.items do R.insert(list, enumItem(sinfo.enumName, it.Name)) end
			return list
		elseif name == "FromName" then
			return (R.type(a1) == "string" and e.byName[a1]) and enumItem(sinfo.enumName, a1) or nil
		elseif name == "FromValue" then
			local it = e.byValue[a1]
			return it and enumItem(sinfo.enumName, it.Name) or nil
		end
	end
	if sinfo and sinfo.tname == "EnumItem" and name == "IsA" then
		return a1 == sinfo.enumName
	end
	if self and RUNSERVICE_BOOL[name] ~= nil then
		return RUNSERVICE_BOOL[name]
	end
	if sinfo and (sinfo.created or sinfo.kids) then
		if name == "GetChildren" then
			emit({ text = calleeText .. "()" })
			return table.clone(kidsOf(self))
		elseif name == "GetDescendants" then
			emit({ text = calleeText .. "()" })
			return descendants(self, {})
		elseif (name == "FindFirstChild" or name == "WaitForChild") and R.type(a1) == "string" then
			local found = findKid(self, a1, name == "FindFirstChild" and args[2] == true)
			if found or sinfo.created then
				emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")" })
				return found
			end
		elseif name == "Destroy" then
			emit({ text = calleeText .. "()" })
			destroyInst(self)
			return
		elseif name == "ClearAllChildren" then
			emit({ text = calleeText .. "()" })
			for _, c in table.clone(kidsOf(self)) do destroyInst(c) end
			return
		elseif name == "IsA" and sinfo.created then
			return a1 == sinfo.className or a1 == "Instance" or (a1 == "GuiObject" and sinfo.className == "Frame")
				or (a1 == "BasePart" and (sinfo.className == "Part" or sinfo.className == "MeshPart"))
		end
	end
	if name == "IsA" or name == "IsDescendantOf" or name == "IsAncestorOf" then
		return true
	end
	if name == "GetLogHistory" then
		-- nothing was printed: a stand-in entry makes HTTP-spy checks
		-- (`entry.message:lower():find("http")`) fire
		return {}
	end

	if name == "HttpGet" or name == "HttpGetAsync" or name == "HttpPost" or name == "HttpPostAsync"
		or name == "GetAsync" or name == "PostAsync" or name == "RequestAsync" then
		if R.type(a1) == "string" then remember(urls, a1) end
		return callP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", "response", "string")
	end

	if name == "FireServer" or name == "InvokeServer" or name == "Fire" or name == "Invoke" then
		remember(remotes, info.parent)
	end

	-- offline: replay recorded Path2D answers
	if not NATIVE and sinfo and sinfo.className == "Path2D" and name == "SetControlPoints" then
		-- the offline model needs the curve (and the parent Frame's size now)
		sinfo.p2dSegs = nil
		sinfo.p2dPoints = R.type(a1) == "table" and not isP(a1) and table.clone(a1) or nil
		sinfo.p2dSet = true
		local W, H = CHAIN.p2d.frameSize(self)
		if CFG.p2d_debug then
			local par = sinfo.props and sinfo.props.Parent
			local sz = isP(par) and INFO[par].props and INFO[par].props.Size
			R.print("P2DDBG W,H", W, H, "a1", R.type(a1), isP(a1), "parent", isP(par), "size", isP(sz),
				isP(sz) and R.tostring(INFO[sz].ctor and INFO[sz].ctor.fn), isP(sz) and INFO[sz].text)
		end
		if W and R.type(a1) == "table" and not isP(a1) then
			local ok, segs = R.pcall(CHAIN.p2d.segments, a1, W, H)
			if CFG.p2d_debug then R.print("P2DDBG segments", ok, R.tostring(segs)) end
			if ok and segs and #segs > 0 then
				sinfo.p2dSegs, sinfo.p2dW, sinfo.p2dH = segs, W, H
			end
		end
	end
	-- engine answers that need no curve (Studio): the point list (a fresh
	-- table each call), the fixed maximum, and curve queries on a Path2D
	-- without a parent raise an error
	if not NATIVE and sinfo and sinfo.className == "Path2D" and sinfo.created then
		if name == "GetMaxControlPoints" then
			emit({ text = calleeText .. "()" })
			return 100
		elseif name == "GetControlPoints" and (sinfo.p2dPoints or not sinfo.p2dSet) then
			emit({ text = calleeText .. "()" })
			return table.clone(sinfo.p2dPoints or {})
		elseif (name == "GetLength" or name == "GetBoundingRect" or (R.type(name) == "string"
			and R.find(name, "OnCurve", 1, true))) and not isP(sinfo.props.Parent) then
			emit({ text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")" })
			R.error("Attempting to use Path2D with invalid parent", 0)
		end
	end
	if not NATIVE and sinfo and sinfo.className == "Path2D" and R.type(name) == "string" and name ~= "SetControlPoints" then
		local rec = __P2D and __P2D[p2dKey(name, args)]
		if rec and CFG.p2d_check then
			-- --cfg p2d_check=true: compare the offline model with recorded answers
			local ok, r = R.pcall(CHAIN.p2d.answer, self, name, args[1])
			R.print("\0P2DCHECK " .. p2dKey(name, args) .. "\t" .. R.tostring(rec) .. "\t" .. R.tostring(ok and r)
				.. "\t" .. ((ok and r == rec) and "same" or "DIFF"))
		end
		if not rec and not CFG.p2d_nomodel then
			local ok, r = R.pcall(CHAIN.p2d.answer, self, name, args[1])
			if ok and r then
				rec = r
				R.insert(P2D_LOG, p2dKey(name, args) .. "\t" .. r .. "\tmodel")
			end
		end
		if not rec then P2D_MISS = true end
		if rec then
			local text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")"
			local vals = {}
			local n = 0
			for field in string.gmatch(rec, "[^\t]+") do
				n += 1
				vals[n] = p2dDecode(field, text)
			end
			if n == 1 and isP(vals[1]) then
				local cp = callP(text, R.match(name, "^Get(%u%w*)$") or "result", INFO[vals[1]].tname)
				INFO[cp].props = INFO[vals[1]].props
				return cp
			end
			emit({ text = text })
			return R.unpack(vals, 1, n)
		end
	end

	-- engine objects with a native twin (offline: a datatype model): run the real method
	if self and REALV[self] ~= nil and R.type(name) == "string" and not NO_NATIVE_METHOD[name] then
		local r = REALV[self]
		local isInst = R.typeof(r) == "Instance"
		local u = unwrapArgs(args)
		if u then
			local res = table.pack(R.pcall(function() return r[name](r, R.unpack(u, 1, u.n)) end))
			if not res[1] then
				if not isInst and res[2] ~= CHAIN.DT_UNSUPPORTED then R.error(res[2], 0) end
			else
				local text = calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")"
				local hint0 = R.match(name, "^Get(%u%w*)$") or "result"
				hint0 = R.gsub(hint0, "^%u", string.lower)
				if isInst and r.ClassName == "Path2D" then
					local enc = {}
					for i = 2, res.n do enc[#enc + 1] = p2dEncode(res[i]) or "?" end
					R.insert(P2D_LOG, p2dKey(name, args) .. "\t" .. R.concat(enc, "\t"))
				end
				local outv, good = {}, true
				for i = 2, res.n do
					local w, ok = wrapReal(res[i], text, hint0)
					if not ok then good = false break end
					outv[i - 1] = w
				end
				if good then
					-- datatype methods are pure: the result is an expression, no statement
					if not isInst then return R.unpack(outv, 1, res.n - 1) end
					if res.n == 2 and isP(outv[1]) then
						-- keep a local for datatype results
						local cp = callP(text, hint0, INFO[outv[1]].tname)
						REALV[cp] = res[2]
						return cp
					end
					emit({ text = text })
					return R.unpack(outv, 1, res.n - 1)
				end
			end
		end
	end

	local hint
	if name == "FindFirstChild" or name == "WaitForChild" or name == "FindFirstChildOfClass"
		or name == "FindFirstChildWhichIsA" or name == "FindFirstAncestor" or name == "FindFirstAncestorOfClass"
		or name == "FindFirstAncestorWhichIsA" or name == "FindFirstDescendant" then
		hint = R.type(a1) == "string" and a1 or "child"
	elseif name == "new" and info.parent and INFO[info.parent].kind == "name" and INFO[info.parent].name == "Instance" then
		hint = R.type(a1) == "string" and a1 or "instance"
	elseif name and CLASS_HINT[name] then
		hint = CLASS_HINT[name]
	elseif name == "Clone" then
		hint = "clone"
	elseif name == "Create" and isMethod and INFO[info.parent].className == "TweenService" then
		hint = "tween"
	elseif name then
		hint = R.match(name, "^Get(%u%w*)$") or R.match(name, "^Find(%u%w*)$")
		local made = R.match(name, "^Create(%u%w*)$") or R.match(name, "^New(%u%w*)$")
			or R.match(name, "^Add(%u%w*)$") or R.match(name, "^Make(%u%w*)$")
		if hint then
			hint = R.gsub(hint, "^%u", string.lower)
		else
			hint = made or "result" -- CreateWindow -> Window
		end
	else
		hint = "result"
	end
	return callP(calleeText .. "(" .. fmtArgs(R.unpack(args, 1, args.n)) .. ")", hint)
end

-- values that are certainly not numbers/strings in Roblox: arithmetic on
-- them raises the same error the engine would (Luraph relies on that)
local OPAQUE = { EnumItem = 1, Enum = 1, Enums = 1, RBXScriptSignal = 1, RBXScriptConnection = 1 }
local function opaqueType(v)
	if not isP(v) then return nil end
	local info = INFO[v]
	if OPAQUE[info.tname] then return info.tname end
	if info.created or (info.className and info.kind ~= "call" or info.kind == "name" and info.className) then
		return "Instance"
	end
	return nil
end
local function luaTypeName(v)
	return opaqueType(v) or R.typeof(v)
end
local function arithError(opname, a, b)
	if opaqueType(a) or opaqueType(b) then
		R.error(R.fmt("attempt to perform arithmetic (%s) on %s and %s", opname, luaTypeName(a), luaTypeName(b)), 3)
	end
end
local ARITH = {
	["+"] = function(a, b) return a + b end, ["-"] = function(a, b) return a - b end,
	["*"] = function(a, b) return a * b end, ["/"] = function(a, b) return a / b end,
	["//"] = function(a, b) return a // b end, ["%"] = function(a, b) return a % b end,
	["^"] = function(a, b) return a ^ b end,
}
local OPNAMES = { ["+"] = "add", ["-"] = "sub", ["*"] = "mul", ["/"] = "div", ["//"] = "idiv", ["%"] = "mod", ["^"] = "pow" }
local function binop(op, tname)
	return function(a, b)
		arithError(OPNAMES[op], a, b)
		local ra, oka = realOf(a)
		local rb, okb = realOf(b)
		if oka and okb then
			-- (offline both twins are models: anything they refuse stays symbolic)
			local ok, r = R.pcall(ARITH[op], ra, rb)
			if not ok and NATIVE then R.error(r, 2) end
			if ok then
				local w, good = wrapReal(r, "(" .. fmt(a) .. " " .. op .. " " .. fmt(b) .. ")", nil)
				if good then return w end
			end
		end
		return exprP("(" .. fmt(a) .. " " .. op .. " " .. fmt(b) .. ")", tname or (isP(a) and INFO[a].tname) or (isP(b) and INFO[b].tname) or "number")
	end
end

-- Methods (inst:FindFirstChild, signal:Connect, ...) are real functions in
-- Roblox; Luraph inspects some with debug.info, so hand out native-looking
-- functions that route to the call logger.
local METHOD_PREFIX = { "Get", "Find", "Wait", "Is", "Clone", "Destroy", "Connect", "Once", "Fire", "Invoke",
	"Set", "Clear", "Remove", "Add", "Load", "Play", "Stop", "Pause", "Resume", "Adjust", "Move", "Pivot",
	"Apply", "Take", "Kick", "Teleport", "Emit", "Create", "Raycast", "Blockcast", "Spherecast", "Shapecast",
	"Http", "Request", "JSON", "Generate", "Compute", "Change", "Equip", "Unequip", "Preload", "Bind", "Unbind",
	"Disconnect", "Activate", "Deactivate", "Update", "Serialize", "Break", "Reset", "Scale", "To", "Lerp",
	"Navigate", "Render", "Open", "Close", "Enable", "Disable", "Insert", "Show", "Hide", "Tween", "Capture",
	"Post", "Publish", "Subscribe", "Increment", "Decrement", "Save", "Read", "Write", "Check", "Can", "Has",
	"Prompt", "Send", "Kill", "Spawn", "Transform", "Invert", "Reverse", "Clamp", "Sample", "Evaluate",
	"Batch", "Sync", "Query", "Register", "Unregister", "Rebuild", "Refresh", "Cancel", "Dump", "Test", "From" }
local METHOD_EXACT = { connect = 1, wait = 1, disconnect = 1, Wait = 1, Connect = 1, Once = 1, ConnectParallel = 1,
	Disconnect = 1, Destroy = 1, Clone = 1, Remove = 1, ClearAllChildren = 1, Kick = 1, Play = 1, Stop = 1,
	findFirstChild = 1, children = 1, getChildren = 1, clone = 1, destroy = 1, remove = 1, isA = 1 }
local methodCache = R.setmetatable({}, { __mode = "k" })
local METHODP = R.setmetatable({}, { __mode = "k" }) -- method function -> index proxy
METHODP_REF = METHODP
function isMethodName(k)
	if R.type(k) ~= "string" then return false end
	if METHOD_EXACT[k] then return true end
	for _, pre in METHOD_PREFIX do
		if R.sub(k, 1, #pre) == pre and R.match(R.sub(k, #pre + 1, #pre + 1), "^%u$") then
			return true
		end
	end
	return false
end
-- In Roblox a method is one C function shared by every object of a type
-- (workspace.FindFirstChild == game.FindFirstChild); Luraph compares them.
local SHARED_METHODS = {}
local SIGNAL_T = { RBXScriptSignal = true, RBXScriptConnection = true }
function methodFn(p, k)
	local want = INFO[p].tname
	if SIGNAL_T[want] then
		-- Roblox builds a new closure on every index of a signal/connection
		-- method (s.Connect ~= s.Connect) and checks self like a C function
		local ip = indexP(p, k)
		local f = function(...)
			local self = ...
			if R.select("#", ...) == 0 then
				R.error(R.fmt("missing argument #1 to '%s' (%s expected)", k, want), 0)
			end
			if not (isP(self) and INFO[self].tname == want) then
				R.error(R.fmt("invalid argument #1 to '%s' (%s expected, got %s)", k, want, luaTypeName(self)), 0)
			end
			return PMT.__call(indexP(self, k), ...)
		end
		CFUNCS[f] = true
		CNAME[f] = k
		METHODP[f] = ip
		return f
	end
	local ck = R.tostring(INFO[p].tname) .. "|" .. R.tostring(k)
	local f = SHARED_METHODS[ck]
	if f then return f end
	local ip = indexP(p, k)
	f = function(...)
		local self = ...
		if not isP(self) then
			R.error("Expected ':' not '.' calling member function " .. k, 0)
		end
		return PMT.__call(indexP(self, k), ...)
	end
	CFUNCS[f] = true
	CNAME[f] = k
	METHODP[f] = ip
	SHARED_METHODS[ck] = f
	return f
end

local SIGNAL_MEMBERS = {
	RBXScriptSignal = { Connect = "method", ConnectParallel = "method", Once = "method", Wait = "method" },
	RBXScriptConnection = { Connected = "prop", Disconnect = "method" },
}

-- Luraph v14.x fingerprints sometimes derive the spelling of signal methods
-- dynamically.  In the standalone tracer those decoded names may arrive in
-- lower-case even though Roblox exposes the canonical capitalized members.
-- Canonicalize only while collecting devirtualization state: normal tracing
-- keeps Roblox's case-sensitive member behavior.
local DEVT_SIGNAL_ALIAS = {
	wait = "Wait", connect = "Connect", once = "Once", connectparallel = "ConnectParallel",
	disconnect = "Disconnect",
}

PMT.__index = function(p, k)
	local info = INFO[p]
	if CFG.trace or CFG.ptrace then R.print("[index]", info.name or info.hint, k) end
	if k == "Parent" and (info.nilParent or info.created) then return info.props.Parent end
	-- unknown objects: a Parent chain ends at workspace -> game -> nil after a
	-- few levels, like a real hierarchy (scripts walk up until workspace/nil)
	if k == "Parent" and info.props.Parent == nil and info.tname == "Instance" and p ~= WORKSPACEP then
		local depth, q = 0, p
		while q and INFO[q] and INFO[q].key == "Parent" do
			depth += 1
			q = INFO[q].parent
		end
		if depth >= 3 then return WORKSPACEP end
	end
	if SIGNAL_MEMBERS[info.tname] then
		local memberKey = k
		if CFG.devirt and R.type(k) == "string" then
			local alias = DEVT_SIGNAL_ALIAS[R.lower(k)]
			if alias and SIGNAL_MEMBERS[info.tname][alias] then
				memberKey = alias
			end
		end
		local m = SIGNAL_MEMBERS[info.tname][memberKey]
		if m == "method" then return methodFn(p, memberKey) end
		if m == nil then
			R.error(R.fmt("%s is not a valid member of %s", R.tostring(k), info.tname), 0)
		end
	end
	local v = info.props[k]
	if v ~= nil then return v end
	local rv = REALV[p]
	if rv ~= nil and R.type(k) == "string" then
		local isInst = R.typeof(rv) == "Instance"
		local ok, x = R.pcall(function() return rv[k] end)
		if not ok then
			if not isInst and x ~= CHAIN.DT_UNSUPPORTED then R.error(x, 2) end
		elseif R.type(x) ~= "function" then
			local w, good = wrapReal(x, tok(p) .. keySuffix(k), k)
			if good then return w end
		end
	end
	if info.genv then
		return nil
	end
	if info.tname == "Enums" and R.type(k) == "string" and API.enums[k] then
		return enumType(k)
	end
	if info.tname == "Enum" and info.enumName then
		local e = API.enums[info.enumName]
		if e and e.byName[k] then return enumItem(info.enumName, k) end
		if k == "GetEnumItems" or k == "FromName" or k == "FromValue" then return methodFn(p, k) end
	end
	if info.tname == "EnumItem" and k == "IsA" then
		return methodFn(p, k)
	end
	-- Faces / Axes: boolean members from the constructor's NormalId / Axis items
	-- (Script42 checks Faces.new(Front, Left).Front and spins on a wrong answer)
	if (info.tname == "Faces" or info.tname == "Axes") and info.ctor and R.type(k) == "string" then
		local axisOf = { Right = "X", Left = "X", Top = "Y", Bottom = "Y", Back = "Z", Front = "Z" }
		local isFaces = info.tname == "Faces"
		local want = isFaces and (axisOf[k] and k) or (axisOf[k] or ((k == "X" or k == "Y" or k == "Z") and k))
		if want then
			local a = info.ctor.args
			for i = 1, a.n do
				local ai = isP(a[i]) and INFO[a[i]]
				if ai and ai.tname == "EnumItem" then
					local n = ai.props.Name
					if isFaces then
						if ai.enumName == "NormalId" and n == want then return true end
					elseif (ai.enumName == "NormalId" and axisOf[n] == want) or (ai.enumName == "Axis" and n == want) then
						return true
					end
				end
			end
			return false
		end
	end
	local dm = DT_MEMBERS[info.tname]
	if dm and R.type(k) == "string" and dm[k] and REALV[p] == nil then
		if dm[k] == "n" then return 0 end
		local c = indexP(p, k)
		INFO[c].tname = dm[k]
		INFO[c].className = nil
		return c
	end
	local cls = info.className
	if cls and API.classes[cls] and R.type(k) == "string" then
		local kind = memberKind(cls, k)
		if kind == "method" then return methodFn(p, k) end
		if kind == "event" then
			-- like Roblox: a new signal object per index, equal under ==
			local c = newP({ kind = "index", parent = p, key = k, tname = "RBXScriptSignal", hint = k,
				sigKey = info.id .. "." .. k })
			return c
		end
		if kind == "prop" then
			local vt = propType(cls, k)
			if vt and NUMERIC_T[vt] then return NUM_DEFAULT[k] or 0 end
			local c = indexP(p, k)
			if vt and DT_MEMBERS[vt] then
				INFO[c].tname = vt
				INFO[c].className = nil
			elseif vt == "bool" then
				INFO[c].tname = "boolean"
				INFO[c].className = nil
			elseif vt == "string" then
				INFO[c].tname = "string"
				INFO[c].className = nil
			end
			return c
		end
	end
	if isMethodName(k) and info.tname ~= "table" then
		return methodFn(p, k)
	end
	return indexP(p, k)
end
PMT.__newindex = function(p, k, v)
	local info = INFO[p]
	if CFG.ptrace then R.print("[newindex]", info.name or info.hint, k, R.typeof(v)) end
	if k == "Parent" and info.destroyed then
		R.error(R.fmt("The Parent property of %s is locked, current parent: NULL, new parent %s",
			instName(p), isP(v) and instName(v) or "NULL"), 0)
	end
	emit({ text = tok(p) .. keySuffix(k) .. " = " .. fmt(v) })
	local rv = REALV[p]
	-- (offline twins are datatype models: an assignment is only recorded, as before)
	if NATIVE and rv ~= nil and k ~= "Parent" and R.type(k) == "string" then
		local u = unwrapArgs(table.pack(v))
		if u then
			local ok, err = R.pcall(function() rv[k] = u[1] end)
			if not ok then R.error(err, 2) end
		end
	end
	if k == "Parent" and (v == nil or isP(v)) then
		setParent(p, v)
	else
		info.props[k] = v
	end
end
PMT.__call = onCall
PMT.__tostring = function(p)
	if REALV[p] ~= nil then return R.tostring(REALV[p]) end
	return "<" .. (INFO[p].hint or "proxy") .. ">"
end
PMT.__concat = function(a, b)
	if opaqueType(a) or opaqueType(b) then
		R.error(R.fmt("attempt to concatenate %s with %s", luaTypeName(a), luaTypeName(b)), 2)
	end
	return exprP(fmt(a) .. " .. " .. fmt(b), "string")
end
PMT.__add = binop("+")
PMT.__sub = binop("-")
PMT.__mul = binop("*")
PMT.__div = binop("/")
PMT.__idiv = binop("//")
PMT.__mod = binop("%")
PMT.__pow = binop("^")
PMT.__unm = function(a)
	if opaqueType(a) then
		R.error(R.fmt("attempt to perform arithmetic (unm) on %s", luaTypeName(a)), 2)
	end
	if REALV[a] ~= nil then
		local ok, r = R.pcall(function() return -REALV[a] end)
		if not ok and NATIVE then R.error(r, 2) end
		if ok then
			local w, good = wrapReal(r, "(-" .. fmt(a) .. ")", nil)
			if good then return w end
		end
	end
	return exprP("(-" .. fmt(a) .. ")", INFO[a].tname)
end
PMT.__len = function(p)
	return 1
end
PMT.__eq = function(a, b)
	if CFG.ptrace then R.print("[eq]", INFO[a] and (INFO[a].name or INFO[a].hint), INFO[b] and (INFO[b].name or INFO[b].hint)) end
	local ra, rb = REALV[a], REALV[b]
	if ra ~= nil and rb ~= nil then return ra == rb end
	local ia, ib = INFO[a], INFO[b]
	if ia and ib and ia.sigKey and ia.sigKey == ib.sigKey then return true end
	return R.rawequal(a, b)
end
PMT.__lt = function(a, b)
	comment("condition: " .. fmt(a) .. " < " .. fmt(b) .. "  (assumed true)")
	return true
end
PMT.__le = function(a, b)
	comment("condition: " .. fmt(a) .. " <= " .. fmt(b) .. "  (assumed false)")
	return false
end
PMT.__iter = function(p)
	return iterProxy(p, nil)
end
PMT.__metatable = "The metatable is locked"

---------------------------------------------------------------------------
-- the fake environment
---------------------------------------------------------------------------
local function anyProxy(...)
	for i = 1, R.select("#", ...) do
		if isP((R.select(i, ...))) then return true end
	end
	return false
end

-- wraps a library so calls involving proxies become expressions
local function wrapLib(libName, lib, tname)
	local out = {}
	for k, f in R.pairs(lib) do
		if R.type(f) == "function" then
			local label = libName .. "." .. k
			out[k] = function(...)
				if anyProxy(...) then
					return exprP(label .. "(" .. fmtArgs(...) .. ")", tname)
				end
				return f(...)
			end
		else
			out[k] = f
		end
	end
	return out
end

-- getgenv()/_G/shared are plain tables in executors (scripts rawget/rawset
-- and iterate them), so they are real tables here too. First assignments of
-- a key are logged through a metatable that getmetatable() does not reveal.
function genvTable(label)
	local t = {}
	GENVNAME[t] = label
	local shadow = {}
	CHAIN.genvShadow = CHAIN.genvShadow or {}
	CHAIN.genvShadow[t] = shadow
	return R.setmetatable(t, {
		__newindex = function(self, k, v)
			emit({ text = label .. keySuffix(k) .. " = " .. fmt(v) })
			R.rawset(self, k, v)
			shadow[k] = v
		end,
	})
end
-- writes to keys that already exist bypass __newindex: before the next
-- statement is emitted, log every value that changed since (nothing
-- observable happened in between, so the order is kept)
CHAIN.syncGenv = function()
	CHAIN.syncing = true
	for t, shadow in R.next, CHAIN.genvShadow do
		local label = GENVNAME[t]
		for k, v in R.next, t do
			if not R.rawequal(shadow[k], v) then
				shadow[k] = v
				emit({ text = label .. keySuffix(k) .. " = " .. fmt(v) })
			end
		end
		for k in R.next, shadow do
			if R.rawget(t, k) == nil then
				shadow[k] = nil
				emit({ text = label .. keySuffix(k) .. " = nil" })
			end
		end
	end
	CHAIN.syncing = false
end

ENV = {}
local E = ENV

-- v14.9 can derive an invalid allocation size when one standalone-runtime
-- fingerprint differs from Roblox.  Do not fabricate a table/buffer: identify
-- the currently executing instrumented proto so the Python driver can rerun
-- with just that fingerprint helper disabled.
local function noteAllocTrigger(kind, n)
	if ALLOC_TRIGGER then return end
	local chain = CHAIN.get and CHAIN.get() or ""
	local pid = nil
	for part in R.gmatch(chain, "[^,]+") do
		local q = R.match(part, "^(%d+):")
		if q then pid = R.tonumber(q) end
	end
	if not pid and E.__ENT and E.__ENT.n and E.__ENT.n > 0 then
		pid = E.__ENT[E.__ENT.n % 64]
	end
	if pid then ALLOC_TRIGGER = { pid = pid, kind = kind, n = n } end
end

local RandomMT = {}
local RANDOM_STATE -- Random object -> generator state (set below)
local GENV = genvTable("getgenv()")
local collected = {}

-- plain Lua libraries
E.string = wrapLib("string", string, "string")
E.math = wrapLib("math", math, "number")
E.table = (function()
	local t = {}
	for k, v in R.pairs(table) do t[k] = v end
	if CFG.v14_lenient_create or CFG.v14_alloc_trap then
		local nativeCreate = table.create
		t.create = function(n, value)
			local ok, out = R.pcall(nativeCreate, n, value)
			if ok then return out end
			local msg = R.tostring(out)
			if R.find(msg, "size out of range", 1, true)
				or R.find(msg, "invalid argument #1 to 'create'", 1, true) then
				if CFG.v14_alloc_trap then noteAllocTrigger("table", n) end
				if CFG.v14_lenient_create then return {} end
			end
			R.error(out, 0)
		end
	end
	return t
end)()
E.bit32 = bit32
E.coroutine = coroutine
-- Unicode NFC/NFD (tables generated by gen_unicode.py). Luraph feeds random
-- Hangul/Latin strings to utf8.nfcnormalize/nfdnormalize and checks results.
local UNorm = (function()
	local U = __UNICODE or { decomp = "", ccc = "", comp = "" }
	local decomp, ccc, comp = {}, {}, {}
	for k, v in string.gmatch(U.decomp, "(%x+):([%x,]+)") do
		local list = {}
		for x in string.gmatch(v, "%x+") do R.insert(list, R.tonumber(x, 16)) end
		decomp[R.tonumber(k, 16)] = list
	end
	for k, v in string.gmatch(U.ccc, "(%x+):(%x+)") do
		ccc[R.tonumber(k, 16)] = R.tonumber(v, 16)
	end
	for a, b, c in string.gmatch(U.comp, "(%x+),(%x+):(%x+)") do
		comp[R.tonumber(a, 16) * 0x110000 + R.tonumber(b, 16)] = R.tonumber(c, 16)
	end
	local SBase, LBase, VBase, TBase = 0xAC00, 0x1100, 0x1161, 0x11A7
	local LCount, VCount, TCount = 19, 21, 28
	local NCount = VCount * TCount
	local SCount = LCount * NCount

	local function decompose(s)
		local out = {}
		for _, cp in utf8.codes(s) do
			local si = cp - SBase
			if si >= 0 and si < SCount then
				R.insert(out, LBase + si // NCount)
				R.insert(out, VBase + (si % NCount) // TCount)
				local t = si % TCount
				if t ~= 0 then R.insert(out, TBase + t) end
			elseif decomp[cp] then
				for _, x in decomp[cp] do R.insert(out, x) end
			else
				R.insert(out, cp)
			end
		end
		-- canonical ordering: stable sort of each run of combining marks
		local i = 1
		while i <= #out do
			if (ccc[out[i]] or 0) > 0 then
				local j = i
				while j + 1 <= #out and (ccc[out[j + 1]] or 0) > 0 do j += 1 end
				for a = i + 1, j do
					local x = out[a]
					local cx = ccc[x]
					local b = a - 1
					while b >= i and ccc[out[b]] > cx do
						out[b + 1] = out[b]
						b -= 1
					end
					out[b + 1] = x
				end
				i = j + 1
			else
				i += 1
			end
		end
		return out
	end

	local function compose(cps)
		local out = {}
		local starter = nil -- index into out
		local lastClass = -1
		for _, cp in cps do
			local c = ccc[cp] or 0
			local done = false
			if starter then
				local s = out[starter]
				-- Hangul L+V and LV+T
				local li, vi = s - LBase, cp - VBase
				if li >= 0 and li < LCount and vi >= 0 and vi < VCount and starter == #out then
					out[starter] = SBase + (li * VCount + vi) * TCount
					done = true
				else
					local si, ti = s - SBase, cp - TBase
					if si >= 0 and si < SCount and si % TCount == 0 and ti > 0 and ti < TCount and starter == #out then
						out[starter] = s + ti
						done = true
					end
				end
				if not done and (lastClass < c or (lastClass == 0 and starter == #out)) then
					local p = comp[s * 0x110000 + cp]
					if p and (starter == #out or lastClass < c) then
						out[starter] = p
						done = true
					end
				end
			end
			if not done then
				R.insert(out, cp)
				if c == 0 then
					starter = #out
					lastClass = 0
				else
					lastClass = c
				end
			end
		end
		return out
	end

	local function pack(cps)
		local parts = {}
		for i, cp in cps do parts[i] = utf8.char(cp) end
		return R.concat(parts)
	end
	return {
		nfd = function(s) return pack(decompose(s)) end,
		nfc = function(s) return pack(compose(decompose(s))) end,
	}
end)()

-- Roblox's utf8 library has three functions the standalone runtime lacks;
-- Luraph fingerprints the key set of this table
E.utf8 = (function()
	local t = {}
	for k, v in R.pairs(utf8) do t[k] = v end
	t.graphemes = function(s, i, j)
		local list = {}
		for p, c in utf8.codes(s) do R.insert(list, { p, p + #utf8.char(c) - 1 }) end
		local n = 0
		return function()
			n += 1
			local g = list[n]
			if g then return g[1], g[2] end
		end
	end
	t.nfcnormalize = function(s) return UNorm.nfc(s) end
	t.nfdnormalize = function(s) return UNorm.nfd(s) end
	return t
end)()
E.vector = vector
E.os = { clock = os.clock, time = os.time, date = os.date, difftime = os.difftime }
E.debug = debug
E.buffer = (function()
	local b = {}
	-- exactly Roblox's buffer library (a newer local Luau has extra functions,
	-- and Luraph fingerprints library contents)
	local ROBLOX_BUFFER = {}
	for n in string.gmatch("copy,create,fill,fromstring,len,readbits,readf32,readf64,readi16,readi32,readi8,"
		.. "readstring,readu16,readu32,readu8,tostring,writebits,writef32,writef64,writei16,writei32,writei8,"
		.. "writestring,writeu16,writeu32,writeu8", "[^,]+") do ROBLOX_BUFFER[n] = true end
	for k, f in R.pairs(buffer) do
		if ROBLOX_BUFFER[k] then b[k] = f end
	end
	if CFG.v14_lenient_create or CFG.v14_alloc_trap then
		local nativeCreate = buffer.create
		b.create = function(n)
			local ok, out = R.pcall(nativeCreate, n)
			if ok then return out end
			local msg = R.tostring(out)
			if R.find(msg, "size out of range", 1, true)
				or R.find(msg, "invalid argument #1 to 'create'", 1, true) then
				if CFG.v14_alloc_trap then noteAllocTrigger("buffer", n) end
				if CFG.v14_lenient_create then return nativeCreate(0) end
			end
			R.error(out, 0)
		end
	end
	-- Luraph's tamper response scribbles single bytes (value & 255) over its
	-- bytecode buffer at random offsets and then spins forever. The legitimate
	-- decoder writes full 32-bit words sequentially, so small scattered writes
	-- are logged together with the bytes they overwrite. Once the pattern is
	-- certain, every logged write is undone and the thread running the routine
	-- is killed, leaving the bytecode intact for the rest of the script.
	local lastOff = -1
	local undo = {}
	for _, nm in { "writei32", "writeu32" } do
		local orig = buffer[nm]
		b[nm] = function(buf, off, v)
			if tamperCount > 0 and v >= 0 and v < 256 and off ~= lastOff + 4 and buffer.len(buf) > 4096 then
				-- the routine survived our error (caught by the script): keep it harmless
				R.error(TAMPER, 0)
			end
			if v >= 0 and v < 256 and off ~= lastOff + 4 and buffer.len(buf) > 4096 and off + 4 <= buffer.len(buf) then
				R.insert(undo, { buf, off, buffer.readu32(buf, off) })
				if #undo >= (CFG.tamper_limit or 64) then
					for i = #undo, 1, -1 do
						local u = undo[i]
						buffer.writeu32(u[1], u[2], u[3])
					end
					table.clear(undo)
					tamperCount += 1
					if not TRIGGER then noteTrigger() end
					if (CFG.oplog or CFG.inline_probe) and E.__OPDUMP then E.__OPDUMP() end
					R.error(TAMPER, 0)
				end
			elseif #undo > 0 and off == lastOff + 4 then
				table.clear(undo)
			end
			lastOff = off
			return orig(buf, off, v)
		end
	end
	if not CFG.dump_strings then return b end
	b.readstring = function(buf, off, len)
		local s = buffer.readstring(buf, off, len)
		R.insert(collected, s)
		return s
	end
	b.tostring = function(buf)
		local s = buffer.tostring(buf)
		R.insert(collected, s)
		return s
	end
	return b
end)()

for _, k in { "assert", "error", "next", "rawget", "rawset", "rawequal", "rawlen", "select", "setmetatable",
	"getmetatable", "unpack", "newproxy", "gcinfo", "_VERSION" } do
	E[k] = REAL_G[k]
end

-- Wrappers forward `...` untouched: Luraph calls them with missing or bad
-- arguments and compares the resulting errors with the real functions'.
E.type = function(...)
	local v = ...
	if isP(v) then
		local t = INFO[v].tname
		if t == "string" or t == "number" or t == "table" or t == "boolean" then return t end
		return "userdata"
	end
	return R.type(...)
end
E.typeof = function(...)
	local v = ...
	if CFG.ptrace then R.print("[typeof]", isP(v) and (INFO[v].name or INFO[v].hint) or R.typeof(v)) end
	if isP(v) then
		local t = INFO[v].tname
		if t == "table" then return "table" end
		return t or "Instance"
	end
	if RANDOM_STATE and RANDOM_STATE[v] then return "Random" end
	local t = R.typeof(...)
	if t == "vector" then return "Vector3" end -- Vector3 is the native vector type
	return t
end
E.tostring = function(...)
	local v = ...
	if CFG.ptrace then R.print("[tostring]", isP(v) and (INFO[v].name or INFO[v].hint) or R.typeof(v)) end
	if isP(v) then
		local info = INFO[v]
		if info.tname == "EnumItem" then return "Enum." .. info.enumName .. "." .. info.props.Name end
		if info.tname == "Enum" then return info.enumName end
		if info.tname == "Enums" then return "Enums" end
		if REALV[v] ~= nil then return R.tostring(REALV[v]) end
		-- tostring(instance) is its Name
		if R.type(info.props.Name) == "string" and (info.className or opaqueType(v) == "Instance") then return info.props.Name end
		return exprP("tostring(" .. tok(v) .. ")", "string")
	end
	return R.tostring(...)
end
E.tonumber = function(...)
	local v = ...
	if isP(v) then return exprP("tonumber(" .. tok(v) .. ")", "number") end
	return R.tonumber(...)
end
-- next() called directly on a stand-in object: it behaves as an empty table
E.next = function(...)
	local t = ...
	if isP(t) then
		if R.select("#", ...) < 1 then R.error("missing argument #1 to 'next' (table expected)", 0) end
		return nil
	end
	return R.next(...)
end
E.pairs = function(...)
	local t = ...
	if isP(t) then return iterProxy(t, "pairs"), t, nil end
	local f, s0, c0 = R.pairs(...)
	if f == R.next then f = E.next end
	return f, s0, c0
end
E.ipairs = function(...)
	local t = ...
	if isP(t) then return iterProxy(t, "ipairs"), t, 0 end
	return R.ipairs(...)
end
-- The real pcall/xpcall: Luraph looks at the call stack from inside a
-- protected call (debug.info(3, "f") must be the xpcall it holds), so these
-- cannot be wrapped. Our stop signals may therefore be swallowed by a script
-- pcall; they are re-raised on the next opportunity instead (see STICKY).
E.pcall = R.pcall
E.ypcall = R.pcall -- Roblox's deprecated alias (same function)
E.xpcall = R.xpcall
-- the real getfenv: the script runs in a thread whose globals are ENV (see the
-- runner below), so getfenv(0)/getfenv() already return ENV. A Lua wrapper here
-- would add a stack frame on every VM call, which Luraph notices through the
-- position in its stack-overflow probe's error message.
E.getfenv = R.getfenv
E.setfenv = function(x, env)
	if R.type(x) == "number" then
		return R.setfenv(x == 0 and 0 or x + 1, env)
	end
	-- a C function's environment cannot be changed; Luraph tests exactly this
	if CFUNCS[x] or isP(x) or (R.type(x) == "function" and debug.info(x, "s") == HARNESS_SRC0) then
		R.error("'setfenv' cannot change environment of given object", 0)
	end
	return R.setfenv(x, env)
end
E.print = function(...)
	emit({ text = "print(" .. fmtArgs(...) .. ")" })
end
E.warn = function(...)
	emit({ text = "warn(" .. fmtArgs(...) .. ")" })
end
-- Layered scripts loadstring further VM chunks. Big ones are reported to the
-- driver, which instruments them like the main script and passes the result
-- back in __CHUNKS for the next run (keyed by length and a cheap hash).
local NEWCHUNKS = {}
local function srcKey(src)
	local h = 0
	for i = 1, #src, 4096 do
		local bytes = { R.byte(src, i, math.min(i + 4095, #src)) }
		for _, b in bytes do h = (h * 31 + b) % 2147483648 end
	end
	return #src .. "_" .. h
end
E.loadstring = function(src, chunkname)
	if isP(src) then
		return exprP("loadstring(" .. tok(src) .. ")", "function")
	end
	local patched = nil
	if R.type(src) == "string" and #src >= 4096 then
		local key = srcKey(src)
		patched = __CHUNKS and __CHUNKS[key]
		if not patched and not NEWCHUNKS[key] then
			NEWCHUNKS[key] = src
			R.insert(NEWCHUNKS, key)
		end
		-- spin watchdog (see E.__SPIN): a chunk the driver never saw (the run
		-- that would report it hung) gets its dispatch heads patched here
		if CFG.spin and not (patched and R.find(patched, "__SPIN.n", 1, true)) then
			patched = R.gsub(patched or src, "while true do [%w_, ]-=[%a_][%w_]*%[[%a_][%w_]*%];",
				"%0__SPIN.n=__SPIN.n+1;if __SPIN.n>=__SPIN.step then __SPIN.f()end;")
		end
	end
	local f, err = R.loadstring(patched or src, chunkname)
	if not f then return nil, err end
	R.setfenv(f, ENV)
	comment("loadstring() of " .. #src .. " bytes: " .. quote(R.sub(src, 1, 200)))
	return f
end
E.require = function(m)
	return callP("require(" .. fmt(m) .. ")", "module")
end

-- task scheduling: run everything immediately, recording the body
local function spawnLike(label, fn, ...)
	if R.type(fn) == "function" then
		local args = table.pack(...)
		lastThread = nil
		local okc, tokf = R.pcall(captureFunction, fn, nil, args)
		if not okc then
			-- the budget ran out inside the new thread: keep what it recorded
			local fid = FUNCS[fn]
			if fid then
				local p = newP({ kind = "call", tname = "thread", hint = "thread" })
				local st = { call = label .. "(" .. fid .. ")", res = p }
				INFO[p].stmt = st
				R.insert(curBlock().lines, st)
			end
			R.error(tokf, 0)
		end
		local th = lastThread
		local p = callP(label .. "(" .. tokf .. (args.n > 0 and (", " .. fmtArgs(...)) or "") .. ")", "thread", "thread")
		if th then
			THREADP[th] = p
			return th
		end
		return p
	end
	return callP(label .. "(" .. fmtArgs(fn, ...) .. ")", "thread", "thread")
end
local function doWait(label, t)
	emit({ text = label .. "(" .. (t ~= nil and fmt(t) or "") .. ")" })
	onWait()
	return (R.type(t) == "number" and t) or 0.03, R.clock()
end
-- Errors are raised exactly like luaL_typeerror in a C function would
-- (no position prefix); Luraph calls these with bad arguments on purpose.
local function typeName(n, ...)
	if R.select("#", ...) < n then return "no value" end
	return R.typeof((R.select(n, ...)))
end
local function argError(n, fname, expected, ...)
	R.error(R.fmt("invalid argument #%d to '%s' (%s expected, got %s)", n, fname, expected, typeName(n, ...)), 0)
end
local function checkRoutine(n, fname, ...)
	local v = R.select(n, ...)
	local t = R.type(v)
	if R.select("#", ...) < n or (t ~= "function" and t ~= "thread") then
		argError(n, fname, "function or thread", ...)
	end
	return v
end
local function checkNumber(n, fname, ...)
	local v = R.select(n, ...)
	if R.select("#", ...) >= n and v ~= nil and R.type(v) ~= "number" then
		if R.tonumber(v) then return R.tonumber(v) end
		argError(n, fname, "number", ...)
	end
	return v
end

local function scheduleLater(label, delayArg, due, fn, ...)
	if R.type(fn) == "thread" then
		-- resuming an existing thread later: record it and resume it at the end
		local th = fn
		local args = table.pack(...)
		R.insert(DEFERRED, { rec = { params = {}, block = { lines = {}, waits = {} } }, thread = th,
			args = args, n = args.n, due = due })
		emit({ text = label .. "(" .. (delayArg and (fmt(delayArg) .. ", ") or "") .. fmt(th) .. ")" })
		return th
	end
	local args = table.pack(...)
	lastThread = nil
	local tokf = captureFunction(fn, nil, args, due)
	local th = lastThread
	local p = callP(label .. "(" .. (delayArg ~= nil and (fmt(delayArg) .. ", ") or "") .. tokf
		.. (args.n > 0 and (", " .. fmtArgs(...)) or "") .. ")", "thread", "thread")
	if th then THREADP[th] = p; return th end
	return p
end

E.task = {
	spawn = function(...)
		local fn = checkRoutine(1, "spawn", ...)
		if R.type(fn) == "thread" then
			emit({ text = "task.spawn(" .. fmt(fn) .. ")" })
			coroutine.resume(fn, R.select(2, ...))
			return fn
		end
		return spawnLike("task.spawn", ...)
	end,
	defer = function(...)
		checkRoutine(1, "defer", ...)
		return scheduleLater("task.defer", nil, 0.5, ...)
	end,
	delay = function(...)
		local t = checkNumber(1, "delay", ...)
		checkRoutine(2, "delay", ...)
		return scheduleLater("task.delay", t or 0, 1 + (t or 0), R.select(2, ...))
	end,
	wait = function(...)
		local t = checkNumber(1, "wait", ...)
		return doWait("task.wait", t)
	end,
	cancel = function(...)
		local th = R.select(1, ...)
		if R.select("#", ...) < 1 or R.type(th) ~= "thread" then
			argError(1, "cancel", "thread", ...)
		end
		emit({ text = "task.cancel(" .. fmt(th) .. ")" })
		if coroutine.status(th) == "suspended" then coroutine.close(th) end
	end,
	synchronize = function() end,
	desynchronize = function() end,
}
E.wait = function(t) return doWait("wait", t) end
E.spawn = function(fn) return spawnLike("spawn", fn) end
E.delay = function(t, fn)
	return E.task.delay(t, fn)
end
E.tick = function() return os.clock() + 1.7e9 end
E.time = os.clock
E.elapsedTime = os.clock
E.getgenv = function() return GENV end
-- getrenv(): Roblox's own globals (libraries, game, datatypes), no executor
-- functions; one table, built on first use (Script42 reads getrenv().math.random)
do
	local renv
	E.getrenv = function()
		if renv then return renv end
		renv = {}
		for n in string.gmatch("assert,error,getmetatable,setmetatable,ipairs,pairs,next,pcall,xpcall,print,"
			.. "select,tonumber,tostring,type,typeof,unpack,rawequal,rawget,rawset,rawlen,gcinfo,newproxy,"
			.. "collectgarbage,getfenv,setfenv,require,_G,_VERSION,string,math,table,os,debug,bit32,coroutine,"
			.. "utf8,buffer,vector,game,Game,workspace,Workspace,script,plugin,shared,settings,UserSettings,"
			.. "tick,time,wait,delay,spawn,elapsedTime,ElapsedTime,warn,task,Enum,Instance,stats,Stats,version,"
			.. "Random,Vector3", "[^,]+") do
			renv[n] = R.rawget(E, n)
		end
		for n in DATATYPES do renv[n] = R.rawget(E, n) end
		return renv
	end
end
E._G = genvTable("_G")
E.shared = genvTable("shared")
E.game = globalP("game")
INFO[E.game].className = "DataModel"
E.Game = E.game
E.workspace = globalP("workspace")
INFO[E.workspace].className = "Workspace"
E.Workspace = E.workspace
-- identity properties Luraph checks (game.Parent == nil, type(game.Name), ...)
INFO[E.game].nilParent = true
INFO[E.game].props.Name = CFG.place_name or "Game"
INFO[E.game].props.ClassName = "DataModel"
INFO[E.workspace].props.Name = "Workspace"
INFO[E.workspace].props.ClassName = "Workspace"
INFO[E.workspace].props.Parent = E.game
serviceCache.Workspace = E.workspace
GAMEP = E.game
WORKSPACEP = E.workspace
E.script = globalP("script")
INFO[E.script].className = "LocalScript"
E.plugin = nil

-- Roblox library globals are frozen tables of C functions, not userdata
local NS_CONSTANTS = { zero = 1, one = 1, xAxis = 1, yAxis = 1, zAxis = 1, identity = 1 }
local NS_MEMBERS = {
	Vector3 = { "new", "zero", "one", "xAxis", "yAxis", "zAxis", "FromNormalId", "FromAxis", "fromNormalId", "fromAxis" },
	Vector2 = { "new", "zero", "one", "xAxis", "yAxis" },
	CFrame = { "new", "fromEulerAnglesXYZ", "fromEulerAnglesYXZ", "Angles", "fromOrientation", "fromAxisAngle",
		"fromMatrix", "lookAt", "lookAlong", "identity", "fromEulerAngles" },
	Color3 = { "new", "fromRGB", "fromHSV", "fromHex", "toHSV" },
	UDim2 = { "new", "fromScale", "fromOffset" },
	Font = { "new", "fromEnum", "fromName", "fromId" },
	DateTime = { "now", "fromUnixTimestamp", "fromUnixTimestampMillis", "fromUniversalTime", "fromLocalTime", "fromIsoDate" },
	BrickColor = { "new", "random", "palette", "White", "Gray", "DarkGray", "Black", "Red", "Yellow", "Green", "Blue" },
	SharedTable = { "new", "clone", "cloneAndFreeze", "increment", "isFrozen", "size", "update" },
}
local function nativeFn(label, f)
	f = tramp(f)
	CFUNCS[f] = true
	CNAME[f] = R.match(label, "([%w_]+)$")
	FNAME[f] = label
	return f
end
local function namespace(name, fields)
	local t = fields or {}
	for k, v in R.pairs(t) do
		if R.type(v) == "function" then nativeFn(name .. "." .. k, v) end
	end
	local function member(k)
		if NS_CONSTANTS[k] or R.match(k, "^%u") and name == "BrickColor" and k ~= "new" then
			local p = exprP(name .. "." .. k .. (NS_CONSTANTS[k] and "" or "()"), name)
			attachReal(p, name, k, not NS_CONSTANTS[k])
			return p
		end
		return nativeFn(name .. "." .. k, function(...)
			local p = exprP(name .. "." .. k .. "(" .. fmtArgs(...) .. ")", name)
			if CFG.ptrace then R.print("[ctor]", INFO[p].text) end
			INFO[p].ctor = { ns = name, fn = k, args = table.pack(...) }
			attachReal(p, name, k, true, ...)
			return p
		end)
	end
	for _, k in NS_MEMBERS[name] or { "new" } do
		if R.rawget(t, k) == nil then t[k] = member(k) end
	end
	return table.freeze(t)
end
-- constructors that reject a call without arguments in Roblox: {arg type}
local REQUIRED_ARG = {
	Path2DControlPoint = "UDim2", NumberSequenceKeypoint = "number", ColorSequenceKeypoint = "number",
	NumberSequence = "number", ColorSequence = "Color3", Ray = "Vector3", Region3 = "Vector3",
	PathWaypoint = "Vector3", Font = "string",
}
for name in DATATYPES do
	if name ~= "Vector3" then
		local fields = nil
		if REQUIRED_ARG[name] then
			local want = REQUIRED_ARG[name]
			fields = {
				new = function(...)
					if R.select("#", ...) < 1 or (...) == nil then
						R.error(R.fmt("invalid argument #1 to 'new' (%s expected, got %s)", want,
							R.select("#", ...) < 1 and "no value" or "nil"), 0)
					end
					local p = exprP(name .. ".new(" .. fmtArgs(...) .. ")", name)
					if CFG.ptrace then R.print("[ctor]", INFO[p].text) end
					INFO[p].ctor = { ns = name, fn = "new", args = table.pack(...) }
					attachReal(p, name, "new", true, ...)
					return p
				end,
			}
		end
		E[name] = namespace(name, fields)
	end
end
-- In Roblox, Vector3 *is* the native Luau vector type; Luraph checks this.
local function vec(x, y, z)
	return vector.create(R.tonumber(x) or 0, R.tonumber(y) or 0, R.tonumber(z) or 0)
end
E.Vector3 = namespace("Vector3", {
	new = function(x, y, z)
		if isP(x) or isP(y) or isP(z) then
			return exprP("Vector3.new(" .. fmtArgs(x, y, z) .. ")", "Vector3")
		end
		return vec(x, y, z)
	end,
	zero = vector.zero or vec(0, 0, 0),
	one = vector.one or vec(1, 1, 1),
	xAxis = vec(1, 0, 0),
	yAxis = vec(0, 1, 0),
	zAxis = vec(0, 0, 1),
})
E.Instance = namespace("Instance", {
	new = function(...)
		local className, parent = ...
		if R.type(className) ~= "string" then
			R.error(R.fmt("invalid argument #1 to 'new' (string expected, got %s)",
				R.select("#", ...) < 1 and "no value" or R.typeof(className)), 0)
		end
		local p
		if R.select("#", ...) >= 2 then
			p = callP("Instance.new(" .. fmtArgs(className, parent) .. ")", className)
		else
			p = callP("Instance.new(" .. fmt(className) .. ")", className)
		end
		local info = INFO[p]
		info.created = true
		info.className = className
		info.kids = {}
		info.props.Name = className
		info.props.ClassName = className
		if NATIVE then
			local ok, inst = R.pcall(REAL_G.Instance.new, className)
			if ok then
				if nativeClass(inst) then REALV[p] = inst else inst:Destroy() end
			end
		end
		if isP(parent) then setParent(p, parent) end
		return p
	end,
	fromExisting = function(obj)
		return callP("Instance.fromExisting(" .. fmt(obj) .. ")", "clone")
	end,
})

-- Random must actually work: the VM itself may draw numbers from it
RandomMT.__index = RandomMT
RandomMT.__metatable = "The metatable is locked"
RandomMT.__type = "Random"
do
-- Roblox's Random, bit-exact (verified against Studio): PCG32 XSH-RR with
-- stream increment 105, pcg32_srandom-style seeding. The 64-bit state is kept
-- as two 32-bit halves and multiplied in 16-bit limbs (exact in doubles).
local band, bor, bxor, lsh, rsh, rrot = bit32.band, bit32.bor, bit32.bxor, bit32.lshift, bit32.rshift, bit32.rrotate
local MUL = { 0x7F2D, 0x4C95, 0xF42D, 0x5851 } -- 6364136223846793005, low limb first
local function pcgStep(st)
	local h, l = st.h, st.l
	local a = { band(l, 0xFFFF), rsh(l, 16), band(h, 0xFFFF), rsh(h, 16) }
	local r0 = a[1] * MUL[1]
	local r1 = a[1] * MUL[2] + a[2] * MUL[1] + R.floor(r0 / 65536)
	local r2 = a[1] * MUL[3] + a[2] * MUL[2] + a[3] * MUL[1] + R.floor(r1 / 65536)
	local r3 = a[1] * MUL[4] + a[2] * MUL[3] + a[3] * MUL[2] + a[4] * MUL[1] + R.floor(r2 / 65536)
	local nl = (r0 % 65536) + (r1 % 65536) * 65536 + 105
	local carry = nl >= 4294967296 and 1 or 0
	st.l = nl % 4294967296
	st.h = ((r2 % 65536) + (r3 % 65536) * 65536 + carry) % 4294967296
end
local function nextWord(st)
	local h, l = st.h, st.l
	pcgStep(st)
	local xh = bxor(h, rsh(h, 18))
	local xl = bxor(l, bor(rsh(l, 18), lsh(h, 14)))
	return rrot(bor(rsh(xl, 27), lsh(xh, 5)), rsh(h, 27))
end
local function seedState(st, seed)
	local hi, lo = 0, 0
	if seed ~= seed then
		hi = 0x80000000 -- NaN converts to INT64_MIN
	elseif R.type(seed) == "number" and seed > -9007199254740992 and seed < 9007199254740992 then
		local v = R.floor(seed)
		local m = v < 0 and -v or v
		hi, lo = R.floor(m / 4294967296), m % 4294967296
		if v < 0 then -- two's complement
			lo = (4294967296 - lo) % 4294967296
			hi = (4294967295 - hi + (lo == 0 and 1 or 0)) % 4294967296
		end
	end
	st.h, st.l = 0, 0
	pcgStep(st)
	local nl = st.l + lo
	st.l = nl % 4294967296
	st.h = (st.h + hi + (nl >= 4294967296 and 1 or 0)) % 4294967296
	pcgStep(st)
end
local f32buf = buffer.create(4)
local function f32(x)
	buffer.writef32(f32buf, 0, x)
	return buffer.readf32(f32buf, 0)
end
-- Random objects are userdata like in Roblox: typeof "Random", tostring
-- "Random", locked metatable, == compares state, a fresh method closure per
-- index, and the engine's exact argument errors. (Error levels count the
-- trampoline: impl -> trampoline -> caller.)
local RSTATE = R.setmetatable({}, { __mode = "k" })
-- (w * range) >> 32 without losing bits
local function scaleWord(w, range)
	local a = R.floor(w / 65536) * range
	local b = (w % 65536) * range
	return R.floor((a + R.floor(b / 65536)) / 65536)
end
local function rtype(v)
	if RSTATE[v] then return "Random" end
	if isP(v) then return INFO[v].tname end
	return R.typeof(v)
end
local function numArg(v, i, fname)
	if v == nil then
		R.error(R.fmt("missing argument #%d%s (number expected)", i, fname and (" to '" .. fname .. "'") or ""), 5)
	end
	local n = R.tonumber(v)
	if R.type(v) ~= "number" and not (R.type(v) == "string" and n) then
		R.error(R.fmt("invalid argument #%d%s (number expected, got %s)", i, fname and (" to '" .. fname .. "'") or "", rtype(v)), 5)
	end
	return n
end
local RMETHODS = {}
local makeRandom
function RMETHODS.NextNumber(st, n, a, b)
	if n ~= 0 and n ~= 2 then R.error("Random:NextNumber requires 0 or 2 arguments", 4) end
	if n == 2 then a, b = numArg(a, 2), numArg(b, 3) end
	local lo = nextWord(st)
	local hi = nextWord(st)
	local u = hi * 2 ^ -32 + lo * 2 ^ -64
	if n == 0 then return u end
	if a > b then a, b = b, a end
	return a + (b - a) * u
end
function RMETHODS.NextInteger(st, n, a, b)
	a, b = numArg(a, 2), numArg(b, 3)
	a, b = R.floor(a), R.floor(b)
	if a > b then a, b = b, a end
	local range = b - a + 1
	if range <= 4294967294 then
		return a + scaleWord(nextWord(st), range)
	end
	-- wide ranges: exact high 64 bits of u64 * range (16-bit limbs)
	local lo = nextWord(st)
	local hi = nextWord(st)
	local x = { lo % 65536, R.floor(lo / 65536), hi % 65536, R.floor(hi / 65536) }
	local y, rr = {}, range % 18446744073709551616
	for i = 1, 4 do y[i] = rr % 65536; rr = R.floor(rr / 65536) end
	local limbs = {}
	for k = 1, 8 do limbs[k] = 0 end
	for i = 1, 4 do
		for j = 1, 4 do limbs[i + j - 1] += x[i] * y[j] end
	end
	for k = 1, 7 do
		limbs[k + 1] += R.floor(limbs[k] / 65536)
		limbs[k] %= 65536
	end
	return a + ((limbs[8] * 65536 + limbs[7]) * 65536 + limbs[6]) * 65536 + limbs[5]
end
function RMETHODS.NextUnitVector(st)
	local lo = nextWord(st)
	local hi = nextWord(st)
	local z = f32(f32(2 * f32(hi * 2 ^ -32)) - 1)
	local r = f32(math.sqrt(f32(1 - f32(z * z))))
	local th = f32(f32(2 * math.pi) * f32(lo * 2 ^ -32))
	return E.Vector3.new(f32(r * f32(math.cos(th))), f32(r * f32(math.sin(th))), z)
end
function RMETHODS.Shuffle(st, n, t)
	if R.type(t) ~= "table" then
		R.error(R.fmt("invalid argument #2 (table expected, got %s)", t == nil and "nil" or rtype(t)), 4)
	end
	if table.isfrozen(t) then R.error("attempt to modify a readonly table", 0) end
	for i = #t, 2, -1 do
		local j = 1 + scaleWord(nextWord(st), i)
		t[i], t[j] = t[j], t[i]
	end
end
function RMETHODS.Clone(st)
	return makeRandom({ h = st.h, l = st.l })
end
local R_INDEX, R_EQ, R_TOSTRING, R_NEWINDEX
R_INDEX = function(self, k)
	if R.type(k) ~= "string" then
		R.error(R.fmt("invalid argument #2 (string expected, got %s)", rtype(k)), 2)
	end
	local m = RMETHODS[k]
	if not m then R.error(k .. " is not a valid member of Random", 0) end
	local f = tramp(function(...)
		local nargs = R.select("#", ...)
		local obj = ...
		if nargs == 0 then R.error(R.fmt("missing argument #1 to '%s' (Random expected)", k), 3) end
		local st = RSTATE[obj]
		if not st then R.error(R.fmt("invalid argument #1 to '%s' (Random expected, got %s)", k, rtype(obj)), 3) end
		return m(st, nargs - 1, R.select(2, ...))
	end)
	CFUNCS[f] = true
	CNAME[f] = k
	return f
end
R_NEWINDEX = function(_, k) R.error(R.tostring(k) .. " is not a valid member of Random", 0) end
R_EQ = function(a, b)
	local x, y = RSTATE[a], RSTATE[b]
	return x ~= nil and y ~= nil and x.h == y.h and x.l == y.l
end
R_TOSTRING = function() return "Random" end
function makeRandom(st)
	local p = R.newproxy(true)
	local mt = R.getmetatable(p)
	mt.__index = R_INDEX
	mt.__newindex = R_NEWINDEX
	mt.__eq = R_EQ
	mt.__tostring = R_TOSTRING
	mt.__type = "Random"
	mt.__metatable = "The metatable is locked"
	RSTATE[p] = st
	return p
end
RANDOM_STATE = RSTATE
local function newRandom(...)
	local seed = ...
	if seed == nil then
		seed = R.floor(os.clock() * 1e6)
	else
		local n = R.tonumber(seed)
		if R.type(seed) ~= "number" and not (R.type(seed) == "string" and n) then
			R.error(R.fmt("invalid argument #1 to 'new' (number expected, got %s)", rtype(seed)), 3)
		end
		seed = n
	end
	local st = { h = 0, l = 0 }
	seedState(st, seed)
	return makeRandom(st)
end
E.Random = table.freeze({ new = nativeFn("Random.new", newRandom) })
if NATIVE and not CFG.fake_random then E.Random = REAL_G.Random end
if CFG.random_probe then
	local inner = E.Random
	E.Random = R.setmetatable({}, { __index = function(_, k) R.print("[Random.index]", R.tostring(k)); return inner[k] end,
		__iter = function() R.print("[Random.iter]"); return R.next, inner end })
end
end
-- Vector3 members on the native vector type. Roblox's engine gives vectors a
-- metatable with Magnitude, Unit, Dot, Cross, ...; stock luau.exe freezes an
-- x/y/z-only one, so bin/luau.exe is built by build_luau.py with it writable
-- (on a stock build this is skipped and `v:Dot(w)` fails). Messages and
-- behaviour match Studio: "Foo is not a valid member of Vector3", a fresh
-- [C] closure per method index, locked metatable, float32 results.
-- (X/Y/Z/x/y/z never get here: the VM reads them before the metatable.)
do
	local VMT = R.getmetatable(vector.create(0, 0, 0))
	if not NATIVE and R.type(VMT) == "table" and not table.isfrozen(VMT) then
		local vdot, vcross, vmag, vnorm, vlerp, vangle = vector.dot, vector.cross, vector.magnitude,
			vector.normalize, vector.lerp, vector.angle
		local fbuf = buffer.create(4)
		local function f32(x)
			buffer.writef32(fbuf, 0, x)
			return buffer.readf32(fbuf, 0)
		end
		local function vtype(v)
			if R.type(v) == "vector" then return "Vector3" end
			if v == nil then return "nil" end
			if isP(v) then return INFO[v].tname end
			return R.typeof(v)
		end
		local function isVec(v) return R.type(v) == "vector" end
		local function isVecP(v) return isP(v) and INFO[v].tname == "Vector3" end
		-- method k: arity check + impl(self, n, ...); errors are raised at
		-- level 5 (check -> method -> impl -> trampoline -> caller)
		local function vecArg(v, i, n)
			if isVec(v) then return v end
			if i > n then R.error(R.fmt("missing argument #%d (Vector3 expected)", i), 5) end
			R.error(R.fmt("invalid argument #%d (Vector3 expected, got %s)", i, vtype(v)), 5)
		end
		local function numArg(v, i, n)
			local x = R.tonumber(v)
			if R.type(v) == "number" or (R.type(v) == "string" and x) then return x end
			if i > n then R.error(R.fmt("missing argument #%d (number expected)", i), 5) end
			R.error(R.fmt("invalid argument #%d (number expected, got %s)", i, vtype(v)), 5)
		end
		local function fuzzy(a, n, b, eps)
			b = vecArg(b, 2, n)
			eps = R.type(eps) == "number" and eps or 1e-5
			for _, c in { "x", "y", "z" } do
				local x, y = a[c], b[c]
				local m = math.max(1, math.abs(x), math.abs(y))
				if not (math.abs(x - y) <= eps * m) then return false end
			end
			return true
		end
		local function minmax(f)
			return function(a, n, ...)
				local args = { ... }
				if n < 2 then vecArg(nil, 2, n) end
				for i = 1, n - 1 do vecArg(args[i], i + 1, n) end
				return f(a, ...)
			end
		end
		local VMETHODS = {
			Dot = function(a, n, b) return vdot(a, vecArg(b, 2, n)) end,
			Cross = function(a, n, b) return vcross(a, vecArg(b, 2, n)) end,
			Lerp = function(a, n, b, t) return vlerp(a, vecArg(b, 2, n), numArg(t, 3, n)) end,
			FuzzyEq = fuzzy,
			Angle = function(a, n, b, axis)
				b = vecArg(b, 2, n)
				if axis ~= nil then return f32(vangle(a, b, vecArg(axis, 3, n))) end
				return f32(vangle(a, b))
			end,
			Abs = function(a) return vector.abs(a) end,
			Floor = function(a) return vector.floor(a) end,
			Ceil = function(a) return vector.ceil(a) end,
			Sign = function(a) return vector.sign(a) end,
			Max = minmax(vector.max),
			Min = minmax(vector.min),
		}
		VMETHODS.lerp = VMETHODS.Lerp
		VMETHODS.isClose = fuzzy
		local VPROPS = {
			Magnitude = vmag, magnitude = vmag, Unit = vnorm, unit = vnorm,
			X = function(v) return v.x end, Y = function(v) return v.y end, Z = function(v) return v.z end,
		}
		VPROPS.x, VPROPS.y, VPROPS.z = VPROPS.X, VPROPS.Y, VPROPS.Z
		VMT.__index = function(self, k)
			if R.type(k) ~= "string" then
				R.error(R.fmt("invalid argument #2 (string expected, got %s)", vtype(k)), 2)
			end
			local prop = VPROPS[k]
			if prop then return prop(self) end
			local m = VMETHODS[k]
			if not m then R.error(k .. " is not a valid member of Vector3", 0) end
			local f = tramp(function(...)
				local n = R.select("#", ...)
				local obj = ...
				if not isVec(obj) then
					if n == 0 then R.error(R.fmt("missing argument #1 to '%s' (Vector3 expected)", k), 3) end
					R.error(R.fmt("invalid argument #1 to '%s' (Vector3 expected, got %s)", k, vtype(obj)), 3)
				end
				-- a symbolic Vector3 argument: let the proxy build the call's expression
				for i = 2, n do
					if isVecP((R.select(i, ...))) then
						local sp = exprP(fmt(obj), "Vector3")
						return sp[k](sp, R.select(2, ...))
					end
				end
				return m(obj, n, R.select(2, ...))
			end)
			CFUNCS[f] = true
			CNAME[f] = k
			return f
		end
		VMT.__newindex = function(_, k)
			if VPROPS[k] then R.error(R.tostring(k) .. " cannot be assigned to", 0) end
			R.error(R.tostring(k) .. " is not a valid member of Vector3", 0)
		end
		VMT.__metatable = "The metatable is locked"
		table.freeze(VMT)
	end
end
E.Enum = newP({ kind = "name", name = "Enum", tname = "Enums" })
enumRoot = E.Enum

---------------------------------------------------------------------------
-- executor API + anti-tamper camouflage
-- Luraph probes the environment (identifyexecutor, iscclosure(print), ...)
-- and silently spins forever when something looks off, so every function we
-- hand out must look like a native C function.
---------------------------------------------------------------------------
local function markC(tbl, seen)
	seen = seen or {}
	if seen[tbl] then return end
	seen[tbl] = true
	for k, v in R.pairs(tbl) do
		if R.type(v) == "function" then
			CFUNCS[v] = true
			if CNAME[v] == nil and R.type(k) == "string" then CNAME[v] = k end
		elseif R.type(v) == "table" and v ~= ENV then
			markC(v, seen)
		end
	end
end
local function isC(f)
	if CFUNCS[f] then return true end
	return R.type(f) == "function" and debug.info(f, "s") == "[C]"
end

local EXECUTOR = CFG.executor or "Wave"
E.identifyexecutor = function()
	comment("identifyexecutor() -> " .. quote(EXECUTOR))
	return EXECUTOR, "1.0.0"
end
E.getexecutorname = function(...) return E.identifyexecutor(...) end
E.iscclosure = function(f)
	if CFG.trace or CFG.ptrace then R.print("[iscclosure]", f, isC(f)) end
	if isP(f) then return true end
	return isC(f)
end
E.islclosure = function(f)
	if CFG.trace or CFG.ptrace then R.print("[islclosure]", f, isC(f)) end
	if isP(f) then return false end
	return R.type(f) == "function" and not isC(f)
end
E.isexecutorclosure = function(f) return false end
E.checkclosure = function(...) return E.isexecutorclosure(...) end
E.newcclosure = function(f)
	CFUNCS[f] = true
	return f
end
E.newlclosure = function(f) return f end
E.clonefunction = function(f) return f end
E.checkcaller = function() return true end
-- hook checks (a truthy stand-in would make scripts run their LPH_CRASH spin)
-- but true for a function the script hooked itself (Script42 hooks print, checks)
do
	local hooked = R.setmetatable({}, { __mode = "k" })
	E.isfunctionhooked = function(f) return hooked[f] == true end
	E.restorefunction = function(f) hooked[f] = nil end
	E.hookfunction = function(target, repl)
		emit({ text = "hookfunction(" .. fmt(target) .. ", " .. fmt(repl) .. ")" })
		if R.type(target) == "function" then hooked[target] = true end
		return target
	end
end
E.ishooked = function(...) return E.isfunctionhooked(...) end
E.replaceclosure = function(...) return E.hookfunction(...) end
E.hookmetamethod = function(obj, method, repl)
	emit({ text = "hookmetamethod(" .. fmt(obj) .. ", " .. fmt(method) .. ", " .. fmt(repl) .. ")" })
	return function(...) return nil end
end
E.getnamecallmethod = function() return "FireServer" end
E.setreadonly = function() end
E.makewritable = function() end
E.makereadonly = function() end
E.isreadonly = function(t) return table.isfrozen(t) end
E.setclipboard = function(s) emit({ text = "setclipboard(" .. fmt(s) .. ")" }) end
E.toclipboard = function(...) return E.setclipboard(...) end
E.fireproximityprompt = function(...) emit({ text = "fireproximityprompt(" .. fmtArgs(...) .. ")" }) end
E.firetouchinterest = function(...) emit({ text = "firetouchinterest(" .. fmtArgs(...) .. ")" }) end
E.fireclickdetector = function(...) emit({ text = "fireclickdetector(" .. fmtArgs(...) .. ")" }) end
E.isfile = function(p) comment("isfile(" .. fmt(p) .. ") -> false"); return false end
E.isfolder = function(p) comment("isfolder(" .. fmt(p) .. ") -> false"); return false end
E.readfile = function(p) return callP("readfile(" .. fmt(p) .. ")", "contents", "string") end
E.writefile = function(p, c) emit({ text = "writefile(" .. fmt(p) .. ", " .. fmt(c) .. ")" }) end
E.appendfile = function(p, c) emit({ text = "appendfile(" .. fmt(p) .. ", " .. fmt(c) .. ")" }) end
E.makefolder = function(p) emit({ text = "makefolder(" .. fmt(p) .. ")" }) end
E.delfile = function(p) emit({ text = "delfile(" .. fmt(p) .. ")" }) end
E.listfiles = function(p) return {} end
E.getconnections = function(sig) return {} end
E.gethui = function() return callP("gethui()", "hui") end
E.cloneref = function(x) return x end
E.compareinstances = function(a, b) return a == b end
E.getcustomasset = function(p) return "rbxasset://" .. R.tostring(p) end
E.queue_on_teleport = function(s) emit({ text = "queue_on_teleport(" .. fmt(s) .. ")" }) end
E.queueonteleport = function(...) return E.queue_on_teleport(...) end
local function httpRequest(label)
	return function(...)
		local opts = ...
		-- a C function: bad arguments raise a typed error (Script42 calls request()
		-- 197 coroutines deep and checks the message for "C stack overflow")
		if R.type(opts) ~= "table" then
			argError(1, R.match(label, "([%w_]+)$"), "table", ...)
		end
		if R.type(opts.Url) == "string" then remember(urls, opts.Url) end
		return callP(label .. "(" .. fmt(opts) .. ")", "response", "table")
	end
end
E.request = httpRequest("request")
E.http_request = httpRequest("http_request")
E.http = { request = httpRequest("http.request") }
E.getrawmetatable = function(x)
	if GENVNAME[x] then return nil end
	if isP(x) then
		return { __index = function() end, __newindex = function() end, __namecall = function() end }
	end
	return R.getmetatable(x)
end
E.setrawmetatable = function(x, mt) return x end
E.getgc = function() return {} end
E.getreg = function() return {} end
E.getloadedmodules = function() return {} end
E.getrunningscripts = function() return {} end
E.getscripts = function() return {} end
E.getinstances = function() return {} end
E.getnilinstances = function() return {} end
E.getscriptclosure = function() return function() end end
E.getsenv = function() return {} end
E.getcallingscript = function() return E.script end
E.getthreadidentity = function() return 8 end
E.getidentity = function(...) return E.getthreadidentity(...) end
E.getthreadcontext = function(...) return E.getthreadidentity(...) end
E.setthreadidentity = function() end
E.setidentity = function() end
E.lz4compress = function(s) return s end
E.lz4decompress = function(s) return s end
E.crypt = { base64encode = function(s) return s end, base64decode = function(s) return s end }
E.base64_encode = E.crypt.base64encode
E.base64_decode = E.crypt.base64decode
E.Drawing = { new = function(kind) return callP("Drawing.new(" .. fmt(kind) .. ")", R.type(kind) == "string" and kind or "drawing") end }
E.isrbxactive = function() return true end
E.isgameactive = function(...) return E.isrbxactive(...) end

-- debug.info must not reveal our Lua wrappers
local realInfo = debug.info
local HARNESS_SRC = realInfo(1, "s")
local fakeDebug = {}
for k, v in R.pairs(debug) do fakeDebug[k] = v end

local function isHarness(f)
	return R.type(f) == "function" and realInfo(f, "s") == HARNESS_SRC
end

-- The stack as the script would see it in Roblox: every run of harness frames
-- (plus the C functions they call) collapses into the one public function the
-- script actually called, which then looks like a C function.
local function visibleStack(th, from)
	local frames = {}
	local lvl = from
	while true do
		local f
		if th then f = realInfo(th, lvl, "f") else f = realInfo(lvl, "f") end
		if f == nil then
			-- level exists but has no function? stop when the level is out of range
			local src
			if th then src = realInfo(th, lvl, "s") else src = realInfo(lvl, "s") end
			if src == nil then break end
		end
		R.insert(frames, { f = f, lvl = lvl })
		lvl += 1
	end
	local out = {}
	local i = 1
	while i <= #frames do
		local fr = frames[i]
		local harness = isHarness(fr.f)
		if not harness and realInfo(fr.f or print, "s") == "[C]" then
			-- a C function called from harness code is an implementation detail
			local j = i
			while j <= #frames and not isHarness(frames[j].f) and realInfo(frames[j].f or print, "s") == "[C]" do
				j += 1
			end
			if j <= #frames and isHarness(frames[j].f) then
				i = j
				harness = true
				fr = frames[i]
			end
		end
		if harness then
			-- skip to the outermost harness frame of this run
			while i + 1 <= #frames and isHarness(frames[i + 1].f) do
				i += 1
			end
			R.insert(out, { f = frames[i].f, fake = true, lvl = frames[i].lvl })
		else
			R.insert(out, { f = fr.f, lvl = fr.lvl })
		end
		i += 1
	end
	return out
end

local function fakeFields(f, opts)
	local out = {}
	for ch in string.gmatch(opts, ".") do
		if ch == "s" then R.insert(out, "[C]")
		elseif ch == "l" then R.insert(out, -1)
		elseif ch == "n" then R.insert(out, CNAME[f] or "")
		elseif ch == "a" then R.insert(out, 0); R.insert(out, true)
		elseif ch == "f" then R.insert(out, f) end
	end
	return R.unpack(out)
end

local info0
fakeDebug.info = function(a, b, c)
	if CFG.ptrace then
		local r = table.pack(info0(a, b, c, 1))
		local t = {}
		for i = 1, r.n do t[i] = R.tostring(r[i]) end
		R.print("[debug.info]", R.type(a) == "function" and (CNAME[a] or FNAME[a] or R.tostring(a)) or R.tostring(a), b, c, "->", R.concat(t, ", ", 1, r.n))
		return R.unpack(r, 1, r.n)
	end
	return info0(a, b, c, 1)
end
CFUNCS[fakeDebug.info] = true
CNAME[fakeDebug.info] = "info"
function info0(a, b, c, extra)
	if R.type(a) == "function" then
		if CFUNCS[a] or isHarness(a) then return fakeFields(a, b) end
		return realInfo(a, b)
	end
	local th, level, opts = nil, a, b
	if R.type(a) == "thread" then th, level, opts = a, b, c end
	if R.type(level) ~= "number" then
		if CFG.debug_stack and isP(a) then R.print("[debug.info on proxy]", INFO[a].kind, INFO[a].key, INFO[a].hint) end
		return realInfo(a, b, c)
	end
	-- level 1 is our caller: real level 2 from here (or 1 for another thread)
	local stack = visibleStack(th, th and 0 or 3 + (extra or 0))
	local fr = stack[th and level + 1 or level]
	if CFG.debug_stack then
		local parts = {}
		for i, x in stack do
			parts[i] = (x.fake and "*" or "") .. R.tostring(CNAME[x.f] or x.f) .. "@" .. R.tostring(realInfo(x.f or print, "s"))
			if i > 6 then break end
		end
		local raw = {}
		for l = 2, 9 do
			local f = realInfo(l, "f")
			raw[#raw + 1] = R.tostring(CNAME[f] or f) .. "@" .. R.tostring(realInfo(l, "s"))
		end
		R.print("[stack] level", level, opts, "->", R.concat(parts, " | "), "\n   raw:", R.concat(raw, " | "))
	end
	if level == 0 and not th then
		return fakeFields(fakeDebug.info, opts)
	end
	if not fr then return nil end
	if fr.fake then return fakeFields(fr.f, opts) end
	if th then return realInfo(th, fr.lvl, opts) end
	-- fr.lvl was counted from inside visibleStack, one frame deeper than here
	return realInfo(fr.lvl - 1, opts)
end

fakeDebug.traceback = function(a, b, c)
	local tb = debug.traceback(a, b, c)
	if R.type(tb) ~= "string" then return tb end
	local keep = {}
	for line in string.gmatch(tb, "[^\n]+") do
		if not R.find(line, HARNESS_SRC, 1, true) then R.insert(keep, line) end
	end
	return R.concat(keep, "\n")
end
-- functions every Roblox script sees in debug (not in the stand-alone Luau)
do
	local memcat = "Default"
	if fakeDebug.profilebegin == nil then fakeDebug.profilebegin = function(label)
		if R.type(label) ~= "string" then R.error("invalid argument #1 to 'profilebegin' (string expected, got " .. R.typeof(label) .. ")", 2) end
	end end
	if fakeDebug.profileend == nil then fakeDebug.profileend = function() end end
	if fakeDebug.setmemorycategory == nil then fakeDebug.setmemorycategory = function(tag)
		if R.type(tag) ~= "string" then R.error("invalid argument #1 to 'setmemorycategory' (string expected, got " .. R.typeof(tag) .. ")", 2) end
		local old = memcat
		memcat = tag
		return old
	end end
	if fakeDebug.resetmemorycategory == nil then fakeDebug.resetmemorycategory = function() memcat = "Default" end end
	if fakeDebug.getmemorycategory == nil then fakeDebug.getmemorycategory = function() return memcat end end
end
E.debug = fakeDebug

E.getmetatable = function(...)
	if GENVNAME[(...)] then return nil end
	return R.getmetatable(...)
end
CFUNCS[E.getmetatable] = true
CNAME[E.getmetatable] = "getmetatable"

if CFG.oplog then
	local ring, pos, N = {}, 0, CFG.oplog
	E.__OPLOG = function(loop, op, pc)
		pos += 1
		ring[pos % N] = loop .. " op=" .. op .. " pc=" .. pc
	end
	E.__SEEN = {}
	do
		local co = {}
		for k, f in R.pairs(coroutine) do
			co[k] = function(...)
				local res = table.pack(f(...))
				local a = {}
				for i = 1, R.select("#", ...) do a[i] = E.__NAME((R.select(i, ...))) end
				local r = {}
				for i = 1, res.n do r[i] = E.__NAME(res[i]) end
				pos += 1
				ring[pos % N] = "CO coroutine." .. k .. "(" .. R.concat(a, ", ") .. ") -> " .. R.concat(r, ", ")
				return R.unpack(res, 1, res.n)
			end
		end
		E.coroutine = co
	end
	local PIDS, npid = {}, 0
	E.__OPL = function(loop, op, pc, proto)
		local id = PIDS[proto]
		if not id then
			npid += 1
			id = npid
			PIDS[proto] = id
			pos += 1
			ring[pos % N] = "NEWPROTO P" .. id .. " " .. R.tostring(proto)
		end
		pos += 1
		ring[pos % N] = "P" .. id .. " L" .. loop .. " op" .. op .. " pc" .. pc
	end
	E.__OPV = function(v, pc)
		pos += 1
		ring[pos % N] = "  = " .. E.__NAME(v)
	end
	local names = nil
	E.__NAME = function(v)
		if not names then
			names = {}
			for k, x in R.pairs(E) do
				if R.type(x) == "function" then names[x] = k
				elseif R.type(x) == "table" and x ~= ENV then
					for k2, y in R.pairs(x) do
						if R.type(y) == "function" then names[y] = k .. "." .. R.tostring(k2) end
					end
				end
			end
		end
		if names[v] then return names[v] end
		local t = R.type(v)
		if t == "string" then return R.fmt("%q", R.sub(v, 1, 80)) end
		if isP(v) then return "<proxy " .. R.tostring(INFO[v].name or INFO[v].hint) .. ">" end
		return R.tostring(v)
	end
	E.__DUMP = function(label, t, depth)
		depth = depth or 0
		local function d(v, lvl)
			if R.type(v) ~= "table" or lvl > 2 then return E.__NAME(v) end
			local parts = {}
			for k, x in R.pairs(v) do
				R.insert(parts, "[" .. E.__NAME(k) .. "]=" .. d(x, lvl + 1))
				if #parts > 80 then break end
			end
			return "{" .. R.concat(parts, ", ") .. "}"
		end
		R.print("[dump]", label, d(t, 0))
	end
	E.__OPDUMP = function()
		for i = R.max(1, pos - N + 1), pos do
			R.print(ring[i % N])
		end
	end
end

if CFG.flip_probe then
	E.__P = { n = 0 }
end

if CFG.inline_probe then
	E.__R = table.create(1e6)
	E.__P = { n = 0 }
	E.__OPDUMP = function()
		local names = {}
		for k, x in R.pairs(E) do
			if R.type(x) == "function" then names[x] = k
			elseif R.type(x) == "table" and x ~= ENV then
				for k2, y in R.pairs(x) do
					if R.type(y) == "function" then names[y] = k .. "." .. R.tostring(k2) end
				end
			end
		end
		local function nm(v)
			if names[v] then return names[v] end
			if R.type(v) == "string" then return R.fmt("%q", R.sub(v, 1, 80)) end
			if isP(v) then
				local chain, q, guard = {}, v, 0
				while q and guard < 12 do
					guard += 1
					local qi = INFO[q]
					R.insert(chain, 1, R.tostring(qi.name or qi.key or qi.hint or qi.kind))
					q = qi.parent
				end
				return "<proxy " .. R.concat(chain, ".") .. ">"
			end
			return R.tostring(v)
		end
		local rr = E.__R
		for i = R.max(1, #rr - (CFG.dump_last or 1500000)), #rr do
			local e = rr[i]
			if R.type(e) == "number" then
				local pc = e % 65536
				local rest = (e - pc) / 65536
				local op = rest % 256
				rest = (rest - op) / 256
				local loop = rest % 16
				local pid = (rest - loop) / 16
				R.print("P" .. pid .. " L" .. loop .. " op" .. op .. " pc" .. pc)
			else
				R.print("  = " .. nm(e[1]))
			end
		end
	end
end

if CFG.co_log then
	local co = {}
	for k, f in R.pairs(coroutine) do co[k] = f end
	co.resume = function(...)
		local res = table.pack(coroutine.resume(...))
		R.print("[co.resume]", R.unpack(res, 1, res.n))
		return R.unpack(res, 1, res.n)
	end
	E.coroutine = co
end

-- entry hooks inserted by deob.py (see patch_entries)
E.__PID = { n = 0 }
E.__ENT = { n = 0 }
E.__SKIPP = {}
E.__PF = R.setmetatable({}, { __mode = "k" })
E.__PLAST = {}
if CFG.fold ~= false then
	CHAIN.pf, CHAIN.pid, CHAIN.plast = E.__PF, E.__PID, E.__PLAST
end
for _, pid in CFG.skip_protos or {} do E.__SKIPP[pid] = true end
-- spin watchdog (--cfg spin=N): a plugin's rerun after a timeout patches its
-- VM dispatch loop heads with table operations only (`__SPIN.n` counts steps,
-- `__SPIN.f()` runs every SPIN_STEP of them). N checks in a row without a new
-- statement or proxy mean pure VM code spinning forever (a tamper response,
-- or a wait for remote code that is never fetched): the run ends like a
-- budget abort and keeps the trace so far.
if CFG.spin then
	local sw = { n = 0, step = 1048576 }
	local idle, lastS, lastId = 0, -1, -1
	sw.f = function()
		sw.n = 0
		-- VM steps are progress for harness.run_once's stall check (this
		-- watchdog decides when they stop being progress)
		if CFG.heartbeat and R.clock() - (CFG._hb or START) > CFG.heartbeat then
			CFG._hb = R.clock()
			R.print("\0HB\n" .. R.rep(" ", 16384))
		end
		if stmtCount ~= lastS or nextId ~= lastId then
			idle, lastS, lastId = 0, stmtCount, nextId
			return
		end
		if CHAIN.decodeUntil then
			-- a requested constant is being decoded (dumpProtos): time limit only
			if R.clock() > CHAIN.decodeUntil then
				ABORT_REASON = "constant decode took too long"
				R.error(ABORT, 0)
			end
			return
		end
		idle += 1
		if idle >= CFG.spin then
			ABORT_REASON = ABORT_REASON or "endless loop in the script's own code (no environment access)"
			checkBudget()
		end
	end
	E.__SPIN = sw
end
-- devirtualizer capture (deob.py --devirt): __PA[proto] holds the maker-level
-- values each VM closure uses, recorded once per proto (see patch_entries).
-- CHAIN.dumpProtos() serializes everything reachable from them as one JSON
-- line: {"protos": {pid: {name: value}}, "tables": {id: {...}}, ...}
E.__PA = CFG.devirt and { n = 0 } or false
E.__PK = {}     -- proto -> its first closure (maker hook; see CHAIN callPath)
if E.__PA then
	-- Copy of each proto's number arrays (instructions, operands) when its
	-- first closure is made (`__PA[proto]={}` in the maker runs this
	-- __newindex). The script's own LPH_CRASH() scrambles the arrays of the
	-- proto it runs in; the dump puts the copy back (CHAIN.unscramble).
	local orig = R.setmetatable({}, { __mode = "k" })
	CHAIN.paOrig = orig
	-- One level deeper: VM-wide tables a proto's fields point to (Script42:
	-- `n = {..., [5] = byte buffer, [6] = offsets}`, shared by every proto
	-- of the VM, decrypted region by region by an instruction that then
	-- turns itself into a no-op). Copied when first seen, i.e. untouched.
	local nested = R.setmetatable({}, { __mode = "k" })     -- table/buffer -> copy
	local lazyKeys = R.setmetatable({}, { __mode = "k" })   -- lazy constant table -> keys at creation
	local holders = R.setmetatable({}, { __mode = "k" })    -- proto -> {field key = table holding such data}
	local function numCopy(arr)
		local c, n = {}, 0
		for i, x in R.next, arr do
			if R.type(x) == "number" then c[i] = x; n += 1 end
		end
		return n > 0 and c or nil
	end
	local function snapNested(proto, w)
		if nested[w] == nil then
			if R.type(w) == "buffer" then
				local b = buffer.create(buffer.len(w))
				buffer.copy(b, 0, w)
				nested[w] = b
			else
				nested[w] = numCopy(w) or false
			end
		end
		return nested[w]
	end
	R.setmetatable(E.__PA, { __newindex = function(t, proto, v)
		R.rawset(t, proto, v)
		if R.type(proto) ~= "table" then return end
		local copy = {}
		for key, arr in R.next, proto do
			if R.type(arr) == "table" and arr ~= proto and not copy[arr] then
				local c = numCopy(arr)
				if arr ~= E and R.getmetatable(arr) ~= nil and lazyKeys[arr] == nil then
					-- lazy constants (decoded into the table on first use from the
					-- instruction's operand): the keys it had before any ran
					local keys = {}
					for k in R.next, arr do keys[k] = true end
					lazyKeys[arr] = keys
					c = c or {}
				end
				if c then
					copy[arr] = c
				elseif arr ~= E and R.getmetatable(arr) == nil then
					-- no numbers of its own: a VM-wide table (see `nested`)
					for _, w in R.next, arr do
						if (R.type(w) == "table" and w ~= proto and w ~= arr and w ~= E and R.getmetatable(w) == nil)
							or R.type(w) == "buffer" then
							if snapNested(proto, w) then
								holders[proto] = holders[proto] or {}
								holders[proto][key] = arr
							end
						end
					end
				end
			end
		end
		orig[proto] = copy
	end })
	-- Constants decoded after creation belong to the decoded operands the
	-- restore undoes (the scramble garbled the operands, so which values
	-- they were is lost; each instruction decodes once, though): the dump
	-- lists their keys (CHAIN.lazyLate[t] = {key = true}, "late") and the
	-- devirtualizer uses them for the operand it decodes itself.
	CHAIN.lazyLate = R.setmetatable({}, { __mode = "k" })
	local function restore(copy)
		for arr, c in R.next, copy do
			local keys = lazyKeys[arr]
			if keys and not CHAIN.lazyLate[arr] then
				local late = {}
				for k in R.next, arr do
					if not keys[k] then late[k] = true end
				end
				CHAIN.lazyLate[arr] = late
			end
			for i, x in R.next, c do R.rawset(arr, i, x) end
		end
	end
	-- Scrambled = every entry of every number array of the proto changed, or
	-- 90% of them, mostly to random 32-bit words (a scramble leaves a few entries
	-- equal by chance, Script42: 37 of 31792). In-place decryption only
	-- rewrites instructions that ran, to small opcodes and operands.
	CHAIN.unscramble = function()
		local fixed = 0
		local done, ran, size = {}, {}, {}
		for proto, copy in R.next, orig do
			local arrays, all = 0, true
			size[proto] = 0
			for arr, c in R.next, copy do
				if not lazyKeys[arr] then   -- constants: never scrambled
					local n, same, huge = 0, 0, 0
					for i, x in R.next, c do
						n += 1
						local y = R.rawget(arr, i)
						if y == x then
							same += 1
						elseif R.type(y) == "number" and (y >= 16777216 or y <= -16777216) then
							huge += 1
						end
					end
					if same < n then ran[proto] = true end
					if n > size[proto] then size[proto] = n end
					if n >= 2 then arrays += 1 end
					-- random words, not decoded operands (a function that ran to
					-- the end has nearly all of its instructions decoded)
					if same > 0 and (same > n * 0.1 or huge < (n - same) * 0.8) then all = false end
				end
			end
			if all and arrays >= 2 then
				restore(copy)
				fixed += 1
				done[proto] = true
			end
		end
		-- VM-wide data (a table held by a proto field: Script42's buffer and
		-- offsets, decrypted region by region by an op that then turns into a
		-- no-op) that changed at run time no longer matches restored protos.
		-- If the restored protos are most of the VM's code that ran (Script42:
		-- the scramble hit the main function), the whole VM goes back to how
		-- it was before it ran, which the lifter emulates; otherwise each
		-- restored proto gets its own copy with the data as it was, and the live
		-- protos keep the decrypted data they rely on (fetched.lua: a
		-- 20-instruction function scrambled, LPH_JIT code decoded at run time).
		local users = {}
		for proto, hs in R.next, holders do
			for key, arr in R.next, hs do
				users[arr] = users[arr] or {}
				users[arr][proto] = key
			end
		end
		for arr, set in R.next, users do
			local restored, live = 0, 0
			for p in R.next, set do
				if done[p] then restored += size[p] or 0 elseif ran[p] then live += size[p] or 0 end
			end
			if restored > 0 then
				local whole = restored >= live
				local view = nil
				for k, w in R.next, arr do
					local snap = nested[w]
					local changed = false
					if R.type(w) == "buffer" and snap then
						changed = buffer.tostring(w) ~= buffer.tostring(snap)
					elseif R.type(w) == "table" and snap then
						for i, x in R.next, snap do
							if R.rawget(w, i) ~= x then changed = true break end
						end
					end
					if changed and whole then
						if R.type(w) == "buffer" then
							buffer.copy(w, 0, snap)
						else
							for i, x in R.next, snap do R.rawset(w, i, x) end
						end
					elseif changed then
						local pristine
						if R.type(w) == "buffer" then
							pristine = buffer.create(buffer.len(snap))
							buffer.copy(pristine, 0, snap)
						else
							pristine = {}
							for i, x in R.next, w do pristine[i] = x end
							for i, x in R.next, snap do pristine[i] = x end
						end
						if not view then
							view = {}
							for k2, w2 in R.next, arr do view[k2] = w2 end
						end
						view[k] = pristine
					end
				end
				for p, key in R.next, set do
					if whole and ran[p] and not done[p] and orig[p] then
						restore(orig[p])
						done[p] = true
						fixed += 1
					elseif view and done[p] then
						R.rawset(p, key, view)
					end
				end
			end
		end
		return fixed
	end
end
do
	local LIBS = { "string", "table", "math", "bit32", "buffer", "coroutine", "utf8", "os", "debug", "task" }
	CHAIN.dumpProtos = function()
		local PA = E.__PA
		if not PA then return nil end
		CHAIN.unscrambled = CHAIN.unscramble()
		local fname = {}
		for k, v in R.next, E do
			if R.type(v) == "function" and R.type(k) == "string" then fname[v] = fname[v] or k end
		end
		for _, lib in R.ipairs(LIBS) do
			local t = R.rawget(E, lib)
			if R.type(t) == "table" then
				for k, v in R.next, t do
					if R.type(v) == "function" then fname[v] = fname[v] or (lib .. "." .. R.tostring(k)) end
				end
			end
		end
		local stop = { [E] = "ENV" }
		for _, lib in R.ipairs(LIBS) do
			local t = R.rawget(E, lib)
			if R.type(t) == "table" then stop[t] = lib end
		end
		local ids, queue, fids = {}, {}, {}
		local nfid = 0
		local function hex(s)
			return (R.gsub(s, ".", function(c) return R.fmt("%02x", R.byte(c)) end))
		end
		local function num(x)
			if x ~= x then return '{"num":"nan"}' end
			if x == R.huge then return '{"num":"inf"}' end
			if x == -R.huge then return '{"num":"-inf"}' end
			if x == 0 and 1 / x < 0 then return '{"num":"-0"}' end
			if x == R.floor(x) and x > -2 ^ 53 and x < 2 ^ 53 then return R.fmt("%d", x) end
			return R.fmt("%.17g", x)
		end
		local function enc(v)
			local t = R.type(v)
			if v == nil then return "null"
			elseif t == "boolean" then return v and "true" or "false"
			elseif t == "number" then return num(v)
			elseif t == "string" then return '{"s":"' .. hex(v) .. '"}'
			elseif t == "function" then
				if fname[v] then return '{"f":"' .. fname[v] .. '"}' end
				if not fids[v] then nfid += 1; fids[v] = nfid end
				-- a VM closure: its proto (the devirtualizer lifts it as a closure)
				local pf = R.rawget(E.__PF, v)
				if R.type(pf) == "table" then
					return '{"lf":' .. fids[v] .. ',"pf":' .. enc(pf) .. '}'
				end
				if CFG.lf_debug then
					local na, va = debug.info(v, "a")
					R.print("LFDBG", fids[v], debug.info(v, "l"), na, va, debug.info(v, "n"))
				end
				return '{"lf":' .. fids[v] .. '}'
			elseif t == "table" then
				if stop[v] then return '{"g":"' .. stop[v] .. '"}' end
				if not ids[v] then
					R.insert(queue, v)
					ids[v] = #queue
				end
				return '{"t":' .. ids[v] .. "}"
			elseif R.typeof(v) == "buffer" then
				return '{"b":"' .. hex(buffer.tostring(v)) .. '"}'
			elseif t == "vector" then
				return '{"vec":[' .. num(v.x) .. "," .. num(v.y) .. "," .. num(v.z) .. "]}"
			end
			-- engine values (proxies, datatypes): how the trace would write them
			local ok, src = R.pcall(function() return CHAIN.exprOf and CHAIN.exprOf(v) end)
			if not ok or R.type(src) ~= "string" then
				ok, src = R.pcall(R.tostring, v)
			end
			return '{"u":"' .. R.typeof(v) .. '","src":"' .. (ok and R.type(src) == "string" and hex(src) or "") .. '"}'
		end
		-- constants are decoded lazily by an __index metamethod on the proto's
		-- arrays, so code that never ran has none in the raw arrays. The
		-- devirtualizer asks for the slots it needs (CFG.force_req, paths like
		-- "12,U,57" = captured value U of the proto with capture number 12,
		-- index 57; longer paths walk into child protos). Indexing them runs
		-- Luraph's own decoder; this happens after the trace is rendered.
		local forced = {}
		local fstats = { calls = 0, got = 0, t0 = R.clock() }
		CHAIN.forceStats = fstats
		local byseq = {}
		for proto, cap in R.next, PA do
			if R.type(cap) == "table" and cap.__seq then
				byseq[cap.__seq] = R.setmetatable({ self = proto }, { __index = cap })
			end
		end
		-- Decoding on request runs Luraph's own code, which decrypts shared VM
		-- state in place as a side effect (string offsets, bytes). Snapshot
		-- everything reachable from the protos now and restore it before the
		-- dump: only the requested constants may stay (re-inserted below),
		-- or the next lifting round would decrypt those bytes a second time.
		local snapTabs, snapBufs = {}, {}
		if R.type(CFG.force_req) == "string" then
			local q = {}
			for proto, cap in R.next, PA do
				if R.type(cap) == "table" then
					R.insert(q, cap)
					R.insert(q, proto)
				end
			end
			local qi = 1
			while qi <= #q do
				local t = q[qi]
				qi += 1
				if not snapTabs[t] and not stop[t] then
					local copy = {}
					for k, v in R.next, t do
						copy[k] = v
						if R.type(v) == "table" then
							R.insert(q, v)
						elseif R.typeof(v) == "buffer" and not snapBufs[v] then
							snapBufs[v] = buffer.tostring(v)
						end
					end
					snapTabs[t] = copy
				end
			end
		end
		-- string constants the lifter decrypted in place (code that never ran
		-- here): patch the VM buffers while decoding, restore before the dump
		local function applyBufs(bufs)
		local bufRestore = {}
		if R.type(bufs) == "string" then
			for spec in string.gmatch(bufs, "[^;]+") do
				local head = string.match(spec, "^[^/]+")
				local v, si = nil, 0
				for st in string.gmatch(head, "[^,]+") do
					local k = R.tonumber(st) or st
					si += 1
					if si == 1 then v = byseq[k]
					elseif si == 2 and R.type(v) == "table" then v = v[k]
					elseif R.type(v) == "table" then v = R.rawget(v, k)
					else v = nil end
				end
				if R.type(v) == "table" then
					for k, val in string.gmatch(spec, "/=(%-?%d+):([^/]+)") do
						k = R.tonumber(k)
						R.insert(bufRestore, { v, k, R.rawget(v, k), true })
						R.rawset(v, k, R.tonumber(val))
						fstats.bufs = (fstats.bufs or 0) + 1
					end
				elseif R.typeof(v) == "buffer" then
					for off, hx in string.gmatch(spec, "/(%d+):(%x+)") do
						off = R.tonumber(off)
						local n = #hx // 2
						if off + n <= buffer.len(v) then
							R.insert(bufRestore, { v, off, buffer.readstring(v, off, n) })
							fstats.bufs = (fstats.bufs or 0) + 1
							for j = 0, n - 1 do
								buffer.writeu8(v, off + j, R.tonumber(string.sub(hx, 2 * j + 1, 2 * j + 2), 16))
							end
						end
					end
				end
			end
		end
		return bufRestore
		end
		local function revertBufs(bufRestore)
			for i = #bufRestore, 1, -1 do
				local r = bufRestore[i]
				if r[4] then R.rawset(r[1], r[2], r[3]) else buffer.writestring(r[1], r[2], r[3]) end
			end
		end
		local bufRestore = applyBufs(CFG.force_buf)
		-- a path walks from a captured proto: "seq,name,key,...". A step
		-- "slot@v" decodes that lazy slot as if its key-0 operand were v
		-- (the lifter decrypted that instruction; the arrays here are still
		-- encrypted). Such results are not cached in the arrays; a path
		-- through such a step reports its value in fstats.over.
		-- decoding a child proto decrypts its data in place: a second decode
		-- of the same slot would read garbage, so results are shared per prefix
		-- Decoding runs Luraph's decoder, a pure-VM loop: a long constant (a
		-- 200 KB loadstring source) takes more steps than the spin watchdog
		-- allows code without environment access. While decoding, the watchdog
		-- applies a time limit instead (CHAIN.decodeUntil), and an abort
		-- (watchdog, budget) only fails this request, not the later ones.
		local function decodeStart(f, ...)
			CHAIN.decodeUntil = R.clock() + (CFG.decode_limit or 10)
			return f(...)
		end
		local abortBefore
		local function decodeGuard(...)
			CHAIN.decodeUntil = nil
			ABORT_REASON = abortBefore
			return ...
		end
		local function slot(v, k) return v[k] end
		local function decodeSlot(v, k)
			abortBefore = ABORT_REASON
			return decodeGuard(R.pcall(decodeStart, slot, v, k))
		end
		local function decodePath(path, derivedCache, forced)
			local steps, ovs, toks = {}, {}, {}
			for st in string.gmatch(path, "[^,]+") do
				R.insert(toks, st)
				local a, ov = string.match(st, "^(%-?%d+)@(%-?[%d%.e]+)$")
				if a then
					ovs[#steps + 1] = R.tonumber(ov)
					st = a
				end
				R.insert(steps, R.tonumber(st) or st)
			end
			local derived = false
			local v = byseq[steps[1]]
			local prefix = toks[1]
			for si = 2, #steps do
				prefix ..= "," .. toks[si]
				if R.type(v) ~= "table" then v = nil break end
				local k = steps[si]
				local x
				if si == 2 then
					x = v[k]
				elseif ovs[si] ~= nil and derivedCache[prefix] ~= nil then
					derived = true
					x = derivedCache[prefix] or nil
				elseif ovs[si] ~= nil then
					-- Luraph's decoder caches into the array: restore the slot afterwards
					fstats.calls += 1
					derived = true
					local k0 = R.rawget(v, 0)
					local old = R.rawget(v, k)
					local saved
					if R.type(k0) == "table" then
						saved = R.rawget(k0, k)
						R.rawset(k0, k, ovs[si])
					end
					R.rawset(v, k, nil)
					local ok, y = decodeSlot(v, k)
					R.rawset(v, k, old)
					if R.type(k0) == "table" then R.rawset(k0, k, saved) end
					if ok then x = y end
					derivedCache[prefix] = x == nil and false or x
					if CFG.force_debug then
						R.print("FORCEDBG", path, si, R.type(k0), R.tostring(saved), R.tostring(ok), R.tostring(y),
							R.tostring(R.getmetatable(v) ~= nil))
					end
				else
					x = R.rawget(v, k)
					if x == nil and not derived and forced[v] then
						x = forced[v][k]
					end
					if x == nil then
						fstats.calls += 1
						local ok, y = decodeSlot(v, k)
						if CFG.force_debug and not ok then
							R.print("FORCEDBG", path, si, R.tostring(y))
						end
						if ok and y ~= nil then
							x = y
							if not derived then
								forced[v] = forced[v] or {}
								forced[v][k] = y
								fstats.got += 1
							end
						end
					end
				end
				v = x
			end
			return v, derived
		end
		-- "!<proto path, ~ for ,>!<args, / separated>": call a closure of that
		-- proto (it has no upvalues) with constant arguments; "F" is a fresh
		-- table standing for the caller's register frame. -> the entries the
		-- call wrote into it (LPH_ENCSTR-style decryptors store the string in
		-- a caller register). Nil when it fails or returns values.
		local function callPath(path, derivedCache, forced)
			local pp, as = string.match(path, "^!([^!]*)!(.*)$")
			local proto = pp and decodePath((string.gsub(pp, "~", ",")), derivedCache, forced)
			local f = R.type(proto) == "table" and R.rawget(E.__PK, proto)
			if R.type(f) ~= "function" then return nil end
			local args, n, frame = {}, 0, nil
			for a in string.gmatch(as, "[^/]+") do
				n += 1
				local c, rest = string.sub(a, 1, 1), string.sub(a, 2)
				if c == "n" then args[n] = R.tonumber(rest)
				elseif c == "s" then
					args[n] = (R.gsub(rest, "%x%x", function(h) return string.char(R.tonumber(h, 16)) end))
				elseif c == "t" then args[n] = true
				elseif c == "f" then args[n] = false
				elseif c == "F" then frame = frame or {}; args[n] = frame
				end
			end
			if not frame then return nil end
			fstats.calls += 1
			abortBefore = ABORT_REASON
			local res = table.pack(decodeGuard(R.pcall(decodeStart, f, R.unpack(args, 1, n))))
			if not res[1] or res.n > 1 then return nil end
			local out = {}
			for k, v in R.next, frame do
				local t = R.type(v)
				if R.type(k) == "number" and (t == "string" or t == "number" or t == "boolean") then out[k] = v end
			end
			fstats.got += 1
			return out
		end
		local function decodeAny(path, derivedCache, forced)
			if string.sub(path, 1, 1) == "!" then
				return callPath(path, derivedCache, forced), true
			end
			return decodePath(path, derivedCache, forced)
		end
		if R.type(CFG.force_req) == "string" then
			local derivedCache = {}
			for path in string.gmatch(CFG.force_req, "[^;]+") do
				local v, derived = decodeAny(path, derivedCache, forced)
				if derived then
					fstats.over = fstats.over or {}
					R.insert(fstats.over, path .. "=" .. (v ~= nil and enc(v) or "null"))
				end
			end
		end
		revertBufs(bufRestore)
		local function restoreSnap()
			for t, copy in R.next, snapTabs do
				R.pcall(function()      -- (a frozen table cannot have changed)
					local extra = {}
					for k in R.next, t do
						if copy[k] == nil then R.insert(extra, k) end
					end
					for _, k in R.ipairs(extra) do R.rawset(t, k, nil) end
					for k, v in R.next, copy do R.rawset(t, k, v) end
				end)
			end
			for b, s in R.next, snapBufs do
				buffer.writestring(b, 0, s)
			end
		end
		restoreSnap()
		-- the requested constants themselves stay decoded
		for t, kv in R.next, forced do
			for k, v in R.next, kv do R.rawset(t, k, v) end
		end
		local out = {}
		local protos = {}
		for proto, cap in R.next, PA do
			if R.type(proto) ~= "table" then continue end
			local pid = E.__PID[proto]
			local fields = {}
			for k, v in R.next, cap do
				R.insert(fields, '"' .. R.tostring(k) .. '":' .. enc(v))
			end
			local self = enc(proto)
			R.insert(protos, '"' .. (pid and R.tostring(pid) or ("t" .. ids[proto])) .. '":{"self":' .. self .. ","
				.. R.concat(fields, ",") .. "}")
		end
		-- a lazy table's decoder (its __index metamethod, shared by every
		-- table of one constant pool): the devirtualizer reuses a constant
		-- decoded for operand v by any table with the same decoder
		local function mtIndex(t)
			local mt = R.getmetatable(t)
			local f = R.type(mt) == "table" and R.rawget(mt, "__index") or nil
			return R.type(f) == "function" and enc(f) or "null"
		end
		-- every table reachable from the protos (operand arrays, constants, child protos)
		local function tableJson(i, t, forced)
			local view = {}
			for k, v in R.next, t do view[k] = v end
			if forced[t] then
				for k, v in R.next, forced[t] do view[k] = v end
			end
			local maxn, cnt = 0, 0
			for k in R.next, view do
				if R.type(k) == "number" and k >= 1 and k == R.floor(k) and k < 2 ^ 31 then
					cnt += 1
					if k > maxn then maxn = k end
				end
			end
			local dense = maxn > 0 and cnt * 2 >= maxn
			local parts, kv = {}, {}
			if dense then
				for j = 1, maxn do parts[j] = enc(view[j]) end
			end
			for k, v in R.next, view do
				if not (dense and R.type(k) == "number" and k >= 1 and k <= maxn and k == R.floor(k)) then
					R.insert(kv, "[" .. enc(k) .. "," .. enc(v) .. "]")
				end
			end
			local lateKeys = CHAIN.lazyLate and CHAIN.lazyLate[t]
			local late = ""
			if lateKeys then
				local e = {}
				for k in R.next, lateKeys do R.insert(e, enc(k)) end
				late = ',"late":[' .. R.concat(e, ",") .. "]"
			end
			return '"' .. i .. '":{"arr":[' .. R.concat(parts, ",") .. '],"kv":[' .. R.concat(kv, ",") .. "]" .. late
				.. (R.getmetatable(t) ~= nil and (',"mt":true,"mtf":' .. mtIndex(t) .. "}") or "}")
		end
		local tabs = {}
		local i = 1
		while i <= #queue do
			tabs[i] = tableJson(i, queue[i], forced)
			i += 1
		end
		local pidmap = {}
		for proto, pid in R.next, E.__PID do
			if R.type(proto) == "table" and ids[proto] then R.insert(pidmap, '"' .. ids[proto] .. '":' .. pid) end
		end
		local overs = {}
		for _, o in R.ipairs(fstats.over or {}) do
			local path, val = string.match(o, "^([^=]+)=(.*)$")
			R.insert(overs, '["' .. path .. '",' .. val .. "]")
		end
		-- long-lived harness (CHAIN.serve): the next request must start from
		-- the state the script left, like a fresh run, so the re-inserted
		-- constants go too
		if CFG.serve then
			restoreSnap()
			-- live constant requests until the next dump (devirt Dump.fetch):
			-- decoded like force_req, answered with the values and only the
			-- tables this dump does not have (their ids continue its ids). The
			-- decoders' side effects stay until the next dump, which first
			-- restores this snapshot (CHAIN.fetchEnd), as within one dump call.
			-- the patches stay applied for the session: bufs "=" (no change) or
			-- "+<more>" (added to the applied ones), else a full set
			local sessDerived, sessForced, sessBufs = {}, {}, {}
			-- a new reader of the same dump (the final lift after the last
			-- constant round) marks its first request with "*": that answer
			-- carries every table made since the dump (ids are stable), later
			-- ones only the tables made since the previous answer
			local dumpEnd, sentEnd = #queue, #queue
			CHAIN.fetch = function(req, bufs)
				local t0 = R.clock()
				CHAIN.fetchEnd = function()
					revertBufs(sessBufs)
					restoreSnap()
				end
				if string.sub(bufs, 1, 1) == "+" then
					-- more patches: on top of the applied ones (reverted in reverse)
					for _, r in R.ipairs(applyBufs(string.sub(bufs, 2))) do R.insert(sessBufs, r) end
				elseif bufs ~= "=" then
					revertBufs(sessBufs)
					sessBufs = applyBufs(bufs)
				end
				local vals = {}
				local start = sentEnd + 1
				if string.sub(req, 1, 1) == "*" then
					req = string.sub(req, 2)
					start = dumpEnd + 1
				end
				for path in string.gmatch(req, "[^;]+") do
					local ok, v = R.pcall(decodeAny, path, sessDerived, sessForced)
					R.insert(vals, '["' .. path .. '",' .. (ok and v ~= nil and enc(v) or "null") .. "]")
				end
				local parts = {}
				local j = start
				while j <= #queue do
					R.insert(parts, tableJson(j, queue[j], sessForced))
					j += 1
				end
				sentEnd = #queue
				return '{"t":' .. R.fmt("%.4f", R.clock() - t0) .. ',"values":[' .. R.concat(vals, ",") .. '],"tables":{'
					.. R.concat(parts, ",") .. "}}"
			end
		end
		return '{"root_callee":' .. R.tostring(CHAIN.seen and CHAIN.seen[CHAIN.rootCallee] == "ok" and CHAIN.rootCallee or "null") .. ',"overrides":[' .. R.concat(overs, ",") .. '],"protos":{' .. R.concat(protos, ",") .. '},"tables":{' .. R.concat(tabs, ",") ..
			'},"pid_of_table":{' .. R.concat(pidmap, ",") .. "}}"
	end
end
function noteTrigger()
	-- the last entered function is the corruption routine, the one before it
	-- is the trap function that called it
	local ent = E.__ENT
	local routine = ent[ent.n % 64]
	for i = ent.n - 1, R.max(1, ent.n - 63), -1 do
		local q = ent[i % 64]
		if q ~= routine then
			TRIGGER = q
			return
		end
	end
end

markC(E)
CFUNCS[E.debug.info] = true

-- anything else resolves to a named proxy so executor APIs etc. show up
local unknownGlobals = {}
R.setmetatable(ENV, {
	__index = function(_, k)
		if R.type(k) ~= "string" then return nil end
		-- a hash-like name (`_54776ae771af02794d46e80d`) is an obfuscator's
		-- run-once/cache key, never an API: nil, as in a fresh Roblox state
		if #k >= 12 and R.match(k, "^_*%x+$") and R.find(k, "%d") then return nil end
		local p = globalP(k, "function")
		if CFG.ptrace then R.print("[unknown-global]", k) end
		remember(unknownGlobals, k)
		R.rawset(ENV, k, p)
		return p
	end,
})

-- trace mode: log every global read/write the script performs
local traceWrap
local traceCache = {}
local TRACE_NAMES = {}
local function argStr(...)
	local t = {}
	for i = 1, R.select("#", ...) do
		local v = R.select(i, ...)
		t[i] = isP(v) and ("<" .. R.tostring(INFO[v].name or INFO[v].hint) .. ">") or R.tostring(v)
		if TRACE_NAMES[v] then t[i] = "<" .. TRACE_NAMES[v] .. ">" end
		if R.type(v) == "string" then t[i] = R.fmt("%q", R.sub(v, 1, 60)) end
	end
	return R.concat(t, ", ")
end
function traceWrap(label, v)
	if R.type(v) == "function" then
		if traceCache[v] then return traceCache[v] end
		local w = function(...)
			R.print("[call]", label .. "(" .. argStr(...) .. ")")
			local res = table.pack(v(...))
			R.print("   ->", argStr(R.unpack(res, 1, res.n)))
			return R.unpack(res, 1, res.n)
		end
		CFUNCS[w] = CFUNCS[v]
		FNAME[w] = FNAME[v]
		traceCache[v] = w
		return w
	elseif R.type(v) == "table" and v ~= ENV and not traceCache[v] then
		local proxyT = R.setmetatable({}, {
			__index = function(_, k) return traceWrap(label .. "." .. R.tostring(k), v[k]) end,
			__newindex = v,
			__iter = function() return R.next, v end,
		})
		traceCache[v] = proxyT
		return proxyT
	elseif traceCache[v] then
		return traceCache[v]
	end
	return v
end

-- Like a Roblox script environment, what getfenv() hands out is a nearly
-- empty table whose metatable falls through to the globals; Luraph walks it.
if not CFG.flat_env then
	local GLOBALS = ENV
	ENV = R.setmetatable({ script = GLOBALS.script }, { __index = CFG.getlog and function(_, k)
		R.print("[get]", k)
		return GLOBALS[k]
	end or GLOBALS })
end

-- probe mode: log global reads and calls of the non-hot functions only
if CFG.probe then
	local BACK = ENV
	TRACE_NAMES[BACK] = "ENV"
	for k, v in R.pairs(BACK) do
		if R.type(v) == "table" or R.type(v) == "function" then TRACE_NAMES[v] = R.tostring(k) end
	end
	local HOT = { buffer = true, bit32 = true, table = true, string = true, math = true, coroutine = true,
		unpack = true, setmetatable = true, select = true }
	ENV = R.setmetatable({}, {
		__index = function(_, k)
			local v = BACK[k]
			R.print("[get]", k, R.type(v))
			if HOT[k] then return v end
			local w = traceWrap(k, v)
			if w ~= v and R.type(w) ~= "nil" then TRACE_NAMES[w] = R.tostring(k) end
			return w
		end,
		__newindex = function(_, k, v)
			R.print("[set]", k, R.type(v))
			BACK[k] = v
		end,
	})
end

if CFG.trace then
	local BACK = ENV
	TRACE_NAMES[BACK] = "ENV"
	for k, v in R.pairs(BACK) do
		if R.type(v) == "table" or R.type(v) == "function" then TRACE_NAMES[v] = R.tostring(k) end
	end
	ENV = R.setmetatable({}, {
		__metatable = nil,
		__index = function(_, k)
			local v = BACK[k]
			R.print("[get]", k, R.type(v))
			local w = traceWrap(k, v)
			if w ~= v and R.type(w) ~= "nil" then TRACE_NAMES[w] = R.tostring(k) end
			return w
		end,
		__newindex = function(_, k, v)
			R.print("[set]", k, R.type(v))
			BACK[k] = v
		end,
	})
end

---------------------------------------------------------------------------
-- rendering
---------------------------------------------------------------------------
local present = {}
local used = {}
local names = {}
local nameCount = {}

local function sanitize(h)
	h = R.tostring(h or "v")
	h = R.gsub(h, "[^%w_]", "")
	if h == "" or R.match(h, "^%d") then h = "v" .. h end
	if not isIdent(h) then h = h .. "_" end
	return h
end

local function uniqueName(h)
	h = sanitize(h)
	nameCount[h] = (nameCount[h] or 0) + 1
	return nameCount[h] == 1 and h or (h .. nameCount[h])
end

local function scanBlock(block, fn)
	for _, s in block.lines do
		fn(s)
		if s.block then scanBlock(s.block, fn) end
	end
end

local markText
local function markProxy(id)
	local p = BYID[id]
	if not p then return end
	local info = INFO[p]
	if used[id] then return end
	used[id] = true
	if info.parent then markProxy(INFO[info.parent].id) end
	if info.text then markText(info.text) end
	if info.kind == "call" and info.stmt and present[info.stmt] then
		markText(info.stmt.call)
	end
end
function markText(text)
	for id in string.gmatch(text, "\1(%d+)\2") do
		markProxy(R.tonumber(id))
	end
	for fid in string.gmatch(text, "\3(%d+)\4") do
		local rec = FREC[R.tonumber(fid)]
		if rec and not rec.marked then
			rec.marked = true
			local function mark(s)
				if s.text then markText(s.text) end
				if s.call then markText(s.call) end
				if s.header then markText(s.header) end
			end
			scanBlock(rec.block, mark)
			if rec.alt then scanBlock(rec.alt, mark) end
		end
	end
end

local exprOf
local resolve

CHAIN.exprOf = function(p) return exprOf(p) end
function exprOf(p)
	local info = INFO[p]
	if info.kind == "name" then return info.name end
	if info.kind == "index" then return exprOf(info.parent) .. keySuffix(info.key) end
	if info.kind == "expr" then return resolve(info.text, info.indent or 0) end
	if info.kind == "call" then
		if info.var then return info.var end
		return resolve(info.stmt.call, info.indent or 0)
	end
	return "nil"
end

local renderBlock

function resolve(text, ind)
	text = R.gsub(text, "\1(%d+)\2", function(id)
		local p = BYID[R.tonumber(id)]
		if not p then return "nil" end
		INFO[p].indent = ind
		return exprOf(p)
	end)
	local src = text
	text = R.gsub(text, "()\3(%d+)\4", function(pos, fid)
		local rec = FREC[R.tonumber(fid)]
		-- a function inside a multi-line table sits deeper than the statement
		local k = 0
		local ls = 1
		for i = pos - 1, 1, -1 do
			if R.byte(src, i) == 10 then ls = i + 1 break end
		end
		if ls > 1 then
			while R.byte(src, ls + k) == 9 do k += 1 end
		end
		local lines = { "function(" .. R.concat(rec.params, ", ") .. ")" }
		if rec.alt then
			-- two runs (truthy / false): shared lines stay outside the if
			local a, b = {}, {}
			local was = CHAIN.markers
			CHAIN.markers = false
			renderBlock(rec.block, ind + k + 1, a)
			renderBlock(rec.alt, ind + k + 1, b)
			CHAIN.markers = was
			local pad = R.rep("\t", ind + k + 1)
			local function starts(t, i) -- a statement starts on line i (or the block ends)
				local l = t[i]
				return l == nil or (R.sub(l, 1, #pad) == pad and R.byte(l, #pad + 1) ~= 9
					and not R.match(l, "^%s*[%)}]") and not R.match(l, "^%s*end%f[%W]")
					and not R.match(l, "^%s*else"))
			end
			local p = 0
			local common = 0
			while a[common + 1] ~= nil and a[common + 1] == b[common + 1] do
				common += 1
				if starts(a, common + 1) and starts(b, common + 1) then p = common end
			end
			local s = 0
			common = 0
			while common < #a - p and common < #b - p and a[#a - common] == b[#b - common] do
				common += 1
				if starts(a, #a - common + 1) and starts(b, #b - common + 1) then s = common end
			end
			for i = 1, p do R.insert(lines, a[i]) end
			local st = rec.params[1]
			local function shifted(t)
				local out = {}
				for i = p + 1, #t - s do R.insert(out, "\t" .. (R.gsub(t[i], "\n", "\n\t"))) end
				return out
			end
			local sa, sb = shifted(a), shifted(b)
			if #sa > 0 then
				R.insert(lines, pad .. "if " .. st .. " then")
				for _, l in sa do R.insert(lines, l) end
				if #sb > 0 then
					R.insert(lines, pad .. "else")
					for _, l in sb do R.insert(lines, l) end
				end
				R.insert(lines, pad .. "end")
			elseif #sb > 0 then
				R.insert(lines, pad .. "if not " .. st .. " then")
				for _, l in sb do R.insert(lines, l) end
				R.insert(lines, pad .. "end")
			end
			for i = #a - s + 1, #a do R.insert(lines, a[i]) end
		else
			renderBlock(rec.block, ind + k + 1, lines)
		end
		R.insert(lines, R.rep("\t", ind + k) .. "end")
		return R.concat(lines, "\n")
	end)
	return text
end

-- statement markers for fold.py: "--@<lines> <chain>" before each statement
-- (<lines> = how many output lines the statement takes)
function renderBlock(block, ind, out)
	local pad = R.rep("\t", ind)
	for _, s in block.lines do
		local mark = CHAIN.markers and #out + 1
		if mark then R.insert(out, false) end
		if s.header then
			R.insert(out, pad .. resolve(s.header, ind))
			renderBlock(s.block, ind + 1, out)
			R.insert(out, pad .. "end")
		elseif s.call then
			local p = s.res
			local info = p and INFO[p]
			if info and info.var then
				R.insert(out, pad .. "local " .. info.var .. " = " .. resolve(s.call, ind))
			else
				R.insert(out, pad .. resolve(s.call, ind))
			end
		else
			R.insert(out, pad .. resolve(s.text, ind))
		end
		if mark then
			local n = 0
			for i = mark + 1, #out do
				n += 1
				for _ in string.gmatch(out[i], "\n") do n += 1 end
			end
			out[mark] = pad .. "--@" .. n .. " " .. (s.chain or "")
		end
	end
end

local function render()
	CHAIN.markers = CFG.fold ~= false and CHAIN.pf ~= nil
	-- which call statements survived into the output
	local function collect(block)
		for _, s in block.lines do
			if s.call then present[s] = true end
			if s.block then collect(s.block) end
		end
	end
	collect(ROOT)
	for _, rec in FREC do
		collect(rec.block)
		if rec.alt then collect(rec.alt) end
	end
	-- mark everything referenced from the output
	scanBlock(ROOT, function(s)
		if s.text then markText(s.text) end
		if s.call then markText(s.call) end
		if s.header then markText(s.header) end
	end)
	-- give locals to results that are referenced (in creation order)
	for id = 1, nextId do
		local p = BYID[id]
		local info = INFO[p]
		if info.kind == "call" and info.stmt and present[info.stmt] and (used[id] or info.forceVar) then
			info.var = uniqueName(info.hint)
		end
	end
	local out = {}
	renderBlock(ROOT, 0, out)
	return R.concat(out, "\n")
end

---------------------------------------------------------------------------
-- run
---------------------------------------------------------------------------
TRAMP_ENV = ENV
for _, t in TRAMPS do R.setfenv(t, ENV) end
-- the run section is a function so its locals get a fresh register frame:
-- the top-level chunk is at the 200-local limit (Studio enforces it)
local function runMain()
local chunk, cerr = R.loadstring(__SOURCE, "=Script")
local status
if not chunk then
	status = "compile error: " .. R.tostring(cerr)
else
	if CFG.prelude then
		-- --cfg prelude=CODE: runs first (not traced); G = _G, genv = getgenv(),
		-- e.g. "rawset(G, 'webhook', 'x')" for scripts that read settings,
		-- "setprop(game, 'PlaceId', 1)" for properties of engine objects
		local pf = R.loadstring(CFG.prelude, "=prelude")
		R.setfenv(pf, { G = E._G, genv = GENV, rawset = R.rawset, shared = E.shared, game = E.game, env = E,
			setprop = function(p, k, v) INFO[p].props[k] = v end })
		pf()
		-- the prelude's own writes are setup, not script behaviour
		for t, shadow in R.next, CHAIN.genvShadow or {} do
			for k, v in R.next, t do shadow[k] = v end
		end
	end
	if CFG.plugin_rt then
		-- --cfg plugin_rt=CODE (set by a plugin, e.g. ironbrew1's capture.luau):
		-- harness-side code that runs before the script, gets the runtime's
		-- tables and may add CHAIN.endHooks (their output goes into the result block)
		local pf, perr = R.loadstring(CFG.plugin_rt, "=plugin_rt")
		if not pf then R.error("plugin runtime: " .. R.tostring(perr)) end
		pf({ E = E, CHAIN = CHAIN, R = R, CFG = CFG, isP = isP, INFO = INFO })
	end
	-- Roblox's libraries are frozen (Script42 checks isreadonly(math))
	for _, lib in { "string", "math", "table", "os", "debug", "buffer", "utf8", "task", "bit32", "coroutine", "vector" } do
		local t = R.rawget(E, lib)
		if R.type(t) == "table" and not table.isfrozen(t) then table.freeze(t) end
	end
	R.setfenv(chunk, ENV)
	local handler = function(e)
		if e == LOOP or e == ABORT or e == TAMPER then return e end
		return R.tostring(e) .. "\n" .. debug.traceback()
	end
	-- Roblox runs scripts in their own thread; here that thread's globals are ENV
	local runner = coroutine.create(function()
		R.setfenv(0, ENV)
		return R.xpcall(chunk, handler)
	end)
	local rs = table.pack(coroutine.resume(runner))
	if rs[1] and rs[2] == ABORT and coroutine.status(runner) == "suspended" then rs = { false, ABORT, n = 2 } end
	R.pcall(CHAIN.syncGenv)
	local mainOk = rs[1] and rs[2] ~= false or (rs[1] and coroutine.status(runner) == "suspended")
	local r2 = coroutine.create(function()
		R.setfenv(0, ENV)
		if mainOk then runDeferred() end
		runHandlers()
	end)
	coroutine.resume(r2)
	local ok, err
	if not rs[1] then
		ok, err = false, rs[2]
	elseif coroutine.status(runner) == "suspended" then
		ok, err = true, nil
	else
		ok, err = rs[2], rs[3]
	end
	popTo(1)
	if CFG.inline_probe and not ok and err ~= TAMPER and E.__OPDUMP then
		CFG.dump_last = CFG.dump_err or 3000
		E.__OPDUMP()
	end
	if ok then
		status = "finished"
	elseif err == LOOP then
		status = "stopped in an endless loop (truncated)"
	elseif err == ABORT then
		status = "aborted: " .. R.tostring(ABORT_REASON)
	elseif err == TAMPER then
		status = "Luraph anti-tamper triggered in the main thread (run stopped)"
	else
		status = "script error: " .. R.tostring(err)
	end
end

local body = render()
local header = {}
R.insert(header, "-- run status: " .. R.gsub(status, "\n", "\n--   "))
R.insert(header, R.fmt("-- %d statements recorded in %.2fs", stmtCount, R.clock() - START))
if #urls > 0 then
	R.insert(header, "-- URLs requested:")
	for _, u in R.ipairs(urls) do R.insert(header, "--   " .. u) end
end
if #remotes > 0 then
	R.insert(header, "-- remotes fired/invoked:")
	for _, rp in R.ipairs(remotes) do R.insert(header, "--   " .. exprOf(rp)) end
end
if #unknownGlobals > 0 then
	R.insert(header, "-- non-standard globals touched: " .. R.concat(unknownGlobals, ", "))
end

CFG.heartbeat = nil     -- nothing may land inside the output block
R.print("\0ENVLOG-BEGIN")
if R.rawget(E, "__TR") then
	-- research/optrace.py: ring of executed (loop, pc, op) entries
	local tr = E.__TR
	local N = tr.N
	for i = R.max(1, tr.total - N + 1), tr.total do
		R.print("\0TR " .. R.tostring(tr[(i - 1) % N + 1]))
	end
end
if ALLOC_TRIGGER then
	R.print("\0ALLOCTRIGGER " .. R.tostring(ALLOC_TRIGGER.pid) .. " " .. R.tostring(ALLOC_TRIGGER.kind) .. " " .. R.tostring(ALLOC_TRIGGER.n))
end
if TRIGGER then R.print("\0TRIGGER " .. TRIGGER) end
for _, line in R.ipairs(P2D_LOG) do R.print("\0P2D " .. line) end
if P2D_MISS then R.print("\0P2DMISS") end
for _, hook in R.ipairs(CHAIN.endHooks or {}) do
	local ok, text = R.pcall(hook)
	R.print(ok and text or ("\0HOOKERR " .. R.tostring(text)))
end
if CFG.devirt then
	local ok, js = R.pcall(CHAIN.dumpProtos)
	local fs = CHAIN.forceStats
	if fs then
		R.print(R.fmt("\0FORCE calls=%d decoded=%d in %.1fs, %d buffer patches", fs.calls, fs.got,
			R.clock() - fs.t0, fs.bufs or 0))
	end
	if (CHAIN.unscrambled or 0) > 0 then R.print("\0UNSCRAMBLED " .. CHAIN.unscrambled) end
	R.print("\0PROTOS " .. (ok and js or ("error: " .. R.tostring(js))))
end
for _, key in R.ipairs(NEWCHUNKS) do
	R.print("\0CHUNK " .. key)
	R.print((R.gsub(NEWCHUNKS[key], ".", function(c) return R.fmt("%02x", R.byte(c)) end)))
end
R.print(R.concat(header, "\n"))
R.print("")
R.print(body)
if CFG.dump_strings then
	R.print("\0ENVLOG-STRINGS")
	local seen = {}
	for _, s in collected do
		if not seen[s] then
			seen[s] = true
			R.print(quote(s))
		end
	end
end
R.print("\0ENVLOG-END")
if CFG.serve then R.print(SERVE_PAD) end
if NATIVE then
	for _, p in R.pairs(BYID) do
		local r = REALV[p]
		if r ~= nil and R.typeof(r) == "Instance" then R.pcall(r.Destroy, r) end
	end
	return R.concat(OUTBUF, "\n")
end
end
-- --cfg serve (deob.py HarnessServer): a long-lived harness for the constant
-- rounds. The file is require()d from luau.exe's REPL, which reads requests
-- from stdin: it returns CHAIN.serve; `__S("", "", "start")` runs the script
-- once, later calls only repeat the dump for new force_req/force_buf. stdout to a
-- pipe is block-buffered and Luau cannot flush it: SERVE_PAD fills the buffer.
if CFG.serve then
	SERVE_PAD = R.rep(" ", 16384)
	CHAIN.serve = function(req, buf, mode)
		if mode == "start" then
			-- the run itself, from a REPL statement of its own: inside require()
			-- (a C function) the script would start a few C calls deeper than
			-- in a plain run, and a coroutine inherits that depth (Script42
			-- nests 197 coroutine.wrap calls, which then hit "C stack overflow")
			runMain()
			return
		end
		if mode == "fetch" then
			R.print("\0ENVLOG-BEGIN")
			local ok, js = R.pcall(function() return CHAIN.fetch(req, buf) end)
			R.print("\0FETCH " .. (ok and js or ("error: " .. R.tostring(js))))
			R.print("\0ENVLOG-END")
			R.print(SERVE_PAD)
			return
		end
		if CHAIN.fetchEnd then
			CHAIN.fetchEnd()
			CHAIN.fetchEnd = nil
		end
		CHAIN.fetch = nil
		CFG.force_req, CFG.force_buf = req, buf
		R.print("\0ENVLOG-BEGIN")
		local ok, js = R.pcall(CHAIN.dumpProtos)
		local fs = CHAIN.forceStats
		if fs then
			R.print(R.fmt("\0FORCE calls=%d decoded=%d in %.1fs, %d buffer patches", fs.calls, fs.got,
				R.clock() - fs.t0, fs.bufs or 0))
		end
		R.print("\0PROTOS " .. (ok and js or ("error: " .. R.tostring(js))))
		R.print("\0ENVLOG-END")
		R.print(SERVE_PAD)
	end
	return CHAIN.serve
end
return runMain()
