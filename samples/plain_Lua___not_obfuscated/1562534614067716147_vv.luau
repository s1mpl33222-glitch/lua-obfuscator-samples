local num = 1770062893
local list
local env
local tbl
local v
local v2
local callback
local v3
local v4
local v5
local v6
local v7
local v8
local v9
local v10
local v11
local callback2
local tbl2
local callback3
local v12
local v13
local callback4
local v14
local v15
local tbl3
local v16
local v17
local v18
local callback5
local v19
local callback6
local callback7
local callback8
local v20
local callback9
local v21
local v22
local v23
local v24
local callback10
local callback11
local v25
local v26

list = {
    319,
    475,
    190,
    1024,
    3073,
    273,
    3262,
    1765,
    291,
    3345,
    2701,
    3528,
    3517,
    3485,
    305,
    241,
    424,
    242,
    1428,
    3474,
    1008,
    2579,
    2567,
    3592,
    24,
    31,
    546,
    3497,
    176,
    15,
    261,
    3445,
    1,
    3372,
    3228,
    3412,
    3661,
    xpcall,
    3030,
    229,
    258,
    327,
    3123,
    2225,
    1917,
    64,
    36,
    2702,
    816,
    3222,
    3651,
    3772,
    1811,
    2443,
    202,
    2564,
    3568,
    3212,
    207,
    function(arg1, arg2) -- line 107 · shares: [1] num, [2] callback9, [3] v22, [4] v23, [5] v18, [6] v5, [7] list, [8] env
        if not num then
            num = {
                callback9,
                v22,
                v23,
                "}\228\134\227",
                "qi·",
                v18,
                num,
                v5,
                arg1,
                arg2,
            }
        end

        local xored
        xored = list[list[885]]

        while true do
            xored = bit32.bxor(xored, list[982])

            if not (xored < 6168) then break end
            if xored < 5401 then
                if xored < 4389 then
                    return
                elseif xored < 5400 then
                    return
                else
                    return callback9((list[list[737]](list[list[708]](v18, list[820], list[1037]), buffer.readu8(v18, list[1083]), buffer.readu8(v23, list[789]))))
                end
            end

            if xored < 5402 then
                return
            elseif xored < 5403 then
                return env[arg2]
            elseif xored ~= 5403 then
                break
            else
                xored = if list[list[1049]](arg2, buffer.readu8(v23, list[509]), buffer.readu32(v5, list[601])) then list[935] else list[801]
            end
        end
    end,
    3130,
    262,
    3400,
    3588,
    3649,
    2675,
    259,
    58,
    2786,
    2072,
    3641,
    2428,
    3271,
    174,
    143,
    367,
    45,
    328,
    1336,
    4294967295,
    4,
    1237,
    3276,
    587,
    378,
    400,
    216,
    1891,
    14700,
    337,
    214,
    2250,
    392,
    2686,
    2964,
    2997,
    "",
    3312,
    201,
    199,
    6,
    2672,
    152,
    1729,
    30,
    function(arg1, ...) -- line 195 · shares: [1] num, [2] list, [3] v23, [4] v26, [5] v5
        if not num then
            num = {"qi·", num, list, v23, 1474981348, arg1}
        end

        local v = list[709][list[698](list[10](v26, list[73], list[114]), buffer.readu8(v5, list[875]))](arg1)
        list[709][list[698](list[10](v26, list[655], list[114]), buffer.readu8(v23, list[65]))](v, ...)
        return v
    end,
    231,
    3306,
    1898,
    function(arg1, arg2) -- line 206 · shares: [1] num, [2] callback9, [3] v22, [4] list, [5] v26, [6] v5
        if not num then
            num = {
                1474981348,
                callback9,
                "}\228\134\227",
                v22,
                list,
                num,
                v26,
                v5,
                arg1,
                arg2,
            }
        end

        callback9((list[list[737]](list[list[708]](v26, list[898], list[list[138]]), buffer.readu8(v5, list[1057]), buffer.readu8(v22, list[list[741]]))))
    end,
    194,
    newproxy,
    1730,
    6,
    32,
    23,
    43,
    3361,
    5268,
    2563,
    1681,
    714,
    347,
    338,
    3432,
    22,
    Enum,
    0.67,
    134,
    281,
    405,
    2371,
    56,
    271,
    16843009,
    1709,
    420,
    115,
    1757,
    2734,
    170,
    3100,
    3133,
    381,
    237,
    3197,
    135,
    370,
    16,
    1270,
    203,
    3608,
    104,
    3389,
    91,
    154,
    3613,
    69,
    3600,
    33,
    3401,
    117,
    2118,
    2267,
    2984,
    415,
    2880,
    253,
    2854,
    1993,
    67,
    741,
    217,
    3512,
    3190,
    3489,
    290,
    9,
    413,
    161,
    144,
    3477,
    3505,
    3441,
    3131,
    "FindFirstChild",
    3005,
    function(list, arg2, arg3) -- line 297
        local v = buffer.fromstring(list)
        local count = #list
        local v2 = count - arg3
        local v3 = arg2 * 16843009
        local count2 = 0

        while count2 <= v2 - 4 do
            buffer.writeu32(v, count2, bit32.bxor(buffer.readu32(v, count2), v3))
            count2 += 4
        end

        while count2 < v2 do
            buffer.writeu8(v, count2, bit32.bxor(buffer.readu8(v, count2), arg2))
            count2 += 1
        end

        return buffer.readstring(v, 0, v2)
    end,
    1303,
    1594,
    779,
    2352,
    95,
    289,
    function(list, arg2, arg3) -- line 327
        if type(list) ~= "string" then
            return false
        end

        if #list ~= arg2 then
            return false
        end

        local xored = 5381
        local v = buffer.fromstring(list)
        local count = 0

        while count <= arg2 - 4 do
            local v2 = buffer.readu32(v, count)
            xored = bit32.bxor(xored, v2)
            xored = bit32.band(xored * 33, 4294967295)
            count += 4
        end

        while count < arg2 do
            local v2 = buffer.readu8(v, count)
            xored = bit32.bxor(xored, v2)
            xored = bit32.band(xored * 33, 4294967295)
            count += 1
        end

        return xored == arg3
    end,
    427,
    vector.create,
    6507,
    2496,
    3480,
    408,
    "info",
    287,
    164,
    1032,
    1137,
    168,
    3321,
    1792,
    1550,
    99,
    5,
    2776,
    3101,
    70,
    2917,
    3052,
    133,
    2939,
    3006,
    7,
    1758,
    pcall,
    3028,
    "\0142?z9/((?4.z.2(?;>z9;445.z9;66z}\18..*\29?.\27)#49}zr6;9134=z9;*;8363.#z\b5865\"\t9(3*.sq!cBKQWNLxA^HqPeS\1\00170:;&~6115~v-*?=5~1(;,821)wY[Z+AOWTm#ZORqgt[Abg=hZ*Q`OHB`OTUReNOJBqNOENoUgb4@EvIzQuyrK_{!+9[r^v8Hv,1XCh\23\23<';<:!&/h<:)8h`8$)<.':%h%!;%)<+ aA]3kPEAj#0C,=D)?.7?.;.;86?z2551zr5,?(<65-s03&XAfPJsH(]F}(:tYBA\22%0\":29#wfw:>$$>90w8%w9>;$zXV+P11+#dEF;q0z0-4RoJJCAGJ\6GUUCRVo&1.$tgU0&![*YR;JF/3TD7Tnl**@*\b--$& -a 22$50XREv]M/D;!EKlYDVDuwdnCd^_%teU$\t,,%'!,`!33%456bXx}tcZ@?]z[]Oxgz_AJ.t02e2{_\029881358t5''1 tj7r0[CrSP$-d9cbtG1;Jc7iySib.<?>2!743$5B%UKhsb]}cEKu$q5?w*cUlaQ3/{gnkp[Z_WrWWVWIMLQyjgE}imYJjDlXN3FWQ^:h0}t.Q:x]]TVP]\17PBBTE/w$NFRY!EQ}=vlJXjnE3E*uuCWwwr~stuquuu:Q,ZCWf5,Nh-Y[cFhfQ*-;-wNMSr\25<<571<p1##5$d6,,5k:.NM6viLON^d9/,)T#c\5  )+- l-??)8ZZ[Rgg90soUjQ?];+zK$0djHKLLHHEIIIHHI:,0YnMQ(gU3U[d.sbU66e#ee=RKFAAEH[@MZGA@t^JGz:SOJKql;w[aM)6ziN;#,szpuvuwtts{p7^ggjT=&)_}JrbDbPoC*i@^JDuWW[AZ@gQFB]WQvh-6=960#E$P@Nodp+gS-zI{xr}s}xzz~~x|sr7c/gUOW?si5VMtjy,au(,[L_L[ZLSJ-z[?#mU*QJK5=s0(,ruVA{-^N8QxyywwtxuqwvqVT[nz}L!SH=@!WEQu/6Os!-z_X]_XQeSD@_USYd(0x^lutRJfM[!d.4};bmBYNxNY]NYb&-AH8hXqf]3@-BQ+^=w)5^_#Y@Ywp#!}O9keBFC;}N4nux0=Q_^945mI}KmHHACEH\4EWWAPqLQJF]kLr3:c7s)+!$-nL\01966?=;6z;))?.gMM4Wn?K/wtgurD&HDE7}\5  )+- l-??)8Zl2(j21S^Bs1ewQJLUNNEcFFOMKF\nKYYO^]JkP3M!Mk]V:(4S%OKC%CPVAZGcc_bJmANyJodiX/!Y]s4l!)zx1&dFQX[UPuGMZWdn,4Hy[nN]k]q6+T08.,JtVG`VAEZPVjJoRu{Yn)/b^^_BDl$&[zya+,*76?x*=>=*=6;=x<=,=;,176xp<= qDBQ@\30oo^UGY^TUH\16Y^F_[UT=jh@p)TclnL]hZZL]oL]JAz]H]\\ZjAHGNLMz@NGHE|YYPRTY\21TFFPA[dU9nBhXY*cr^)JJ1,xVJ`J@GV^fz\19h\6nva=LRQiMF_@^-SMA_ZY^][R[RZa{XhPGDFqV}j:^,WXS7.@FEBA@A@FN.{B5$+ATV48Y*_e,A[CJOR_FAMFL35r5[Ex&Qtg^XCNJL4SCKV\27>>753>r3!!7&mF*4Cn^iUgJUSIOH!&319r=$7 4>=%rz\27<$=97\0017 $7 {`EELNHE\tHZZL]HuOO?wVw1J.ttPu00'2@I5(,;cMY(C:74e)f2Gn(45]AsXUQD\16ey\16k\3mM,HX#:[)N2+8P92s\4!!(*,!m,>>(9=%qZscfwil_-oRc,<&?--;*7:dqqifljmmooooknhi|YYPRTY\21TFFPA,M9WnR+pb@]h#RZ]WVKhOY&7H&8?@9?A(-!BVBv^^\0220#!'.'11b'00-0b&'6'!6'&iy%,.:&9'!<=3$M1l6]T)$Ns,4Hp\15**#!'*f'55#22c##h4/4G9?s8x_BEP_RTr^D_E=os?j.Z,cikDb~\4ssEV@TV[[tXBYCuoGkhI_j>.4-??)8%(vccx{x}{~uuzGPVu]KKY_]zMKk]JNQ[]4Ah&neA;{^^WUS^\18SAAWF:T3?uz{1dKFDC[LADIr@HYEBI&.k/.!.=dk\028990249u4&&0!Zuk?t&Sd#G>)'6/'/i{ksMCfoGJ_Avlu7cL@H-9f;bIMpCfGW;j#f?Ex\2''.,*'k*88.?yO=aUXG.CIspr}}rtrvwep7wY=(usmVwjHY`H@B_Tx^LJH`OkB_yLJy^F_[UcUBFUB\16]YC]QDSX9.;k.Fj.VPp?+@go(I]h*efmgldeadac`geg9mUQDQcAPpKPEHiAIKV]qWECAiFFB^TVKxlD]SXo6EoqBzJ$?'(/8$V:@295eqJj#]SuNGBIQUrTOGHAJCeISHRkk@[G@F]ZSPi9;#VY&Hada`bbgbad)vuRy$Ea:DFLEGLBCA@MEFGGApN2\0292)>\b>)->){>))4){xj\17>93\0042%!>42w?88<wfACGHDBDCIBIGHEEZwvp@FMFwQJBMDOF`LVMWgAWWQGGF(WcN0:0{sZxDD@wUDqCI^S\16\\UQ[lp\v}}KXNZXUUzVLWMC@CL@X{Q5fdZuuxwFzXI~UTQYOXS^bnle'($,*(%%Yv,h84k-_RSXB_POSNSUCBYD*'&-7*%:&;& 67,1hhCXDCE^YP\23CEVGHKOKMMHOKJJ@IL@nnhgnhkogjlknfgttrr}}vq|uq||qrm@DWQG@DQqLH@hVGE@BGE@CABCBNBNkikchjkiockhlccZ@NWCSORJJg25&q^YSq^EDCt_^[SbmconlhcimcmkbUS[TZ[PRW[VTWWvFWLUQfJKQ@]QiD@SUCD@UuHLDe@@IKM@\fM__IX\0%%,.(%i(::,=\26??642?s2  6'}XXQSUX\20UGGQ@dAAHJLA\rL^^HY\5  )+- l-??)8\1$$-/)$h);;-<dRZGlCAr&.FM;.:/02847#zy69>4;K^doi=eprtwxsusxvs=mJRKOAwAVRAVDFBDDLAFGGEFE@DGBN@N@E4514Jn[^Q2Wnohlkggkjkg)$9&&4&3#=9eg``ebmamleECL@@AF@AEDFOD,/U!4:dWqZGKvQKZXZMgPXZAPpCP[A``VQ[ZG\31DB}y|r~}{xy~wUDcUBFYSUGDFH@AGCCB#6+)$s$M#?hCBGOjOONO/0: 1 !!%0u]KKY_]wMLWQWTYSPTXWgkcca`aabjRH[G[RCRX%#%&38232uYXXSUBSRmOEGO^XSlNDFN_YRHOGN%Jjj\0\0\0\0\0\0\224?ttBEONS!#2!#(0KzUGjx2K_YWFYDx^H_dIhtVAHKE@-:):-,:UDSWBS/( )w{random)>(.6>rshift0=?<,??55$#3>'<!HKZLU# 1'>COZMF^RGP[QJGV\222]|\188B\226\212\241xNF[\184Ja\196/&\5UGGNV\243|\211\140,a\14\238u\\\223EEJMG\133g\ar\152\201\217)\"\152\208\176%v\239\173q6l\25EBH\4\1720\217&\239\142n1\203ge\128|\136\185\252\202\187\152\179\191g\217#\136\217\210\151\157\255\t\147\169\6\t\156*\16\213\239\173l\186\192\141\239\2-\164\184\220y+nX\5\146Z\180+4\249\0\15\14\249\222^T\131\4N\v\207\14\228\b\136\5_Z\186\187\21\176K\155\240\138\194\186\202 \171s\"\246J\0036t\0\188\163\205\22\190\129If\18V\23=\179Y$\233\v\177\bu\171\211D\147\15\240\137\133\177q#\196\179V>8?/\161\142\f\195\\\v\1\17\221\6\181?U\223g\168\215\149\216=\194\179\0039L\27\n\175\190\130\219'$!2#\202;\6fR\242\223O\130J\191\149;>-<9G\213\234ta\209\14\240;\2167\248\179\221h\179\133o \130)\181\21531!EUQ*!3lg[(0.~-\a]b\27K\20a%e\nP\26;c/D7\197F\0239pE\2\0",
    1994,
    703,
    function(...) -- line 391 · shares: [1] num, [2] list
        if not num then
            num = {"qi·", num, "}\228\134\227", 1474981348, list}
        end

        return ...
    end,
    1974,
    3644,
    3235,
    402,
    ").6!,)$`!2'5-%.4`cq`4/`g-!'.)45$%g`eh6%#4/2`%80%#4%$l`'/4`he7kiei?.mj_zN/nPU5\1<4!'0! dc~cd*+0dcjcd'%((-*#d)!)&!6d\"1*'0-+*d\2-6!\23!62!66&<%77!0- ~kkussr}srqvpreJ=ccxY7!KX}4cDiv6OU1r}c^jfQ%5/6$$2#mxx>91>9>#2.>2;3DM;sgI:u$P(:1O!daZclJ+oxi0\n:+0)-y<!<:,-<=yq* 7-8!y<++6+p{lEBAzG4LM)A7),II}y\21))-\0268)}4.}32)}<}+<149}080?8/}2;YrZ,tzgFuzqb5xzsDLNUDgTOBUHNOr]4kCB[m-KI3iU5)/qHcEan5(N]FC-KcFFOMKF\nKYYO^%drTamgg:5gy{Q{r+@GrF4,4fU((n;4FEBEOABEDOFD@CGgMk;CLA1y4jdKwGADEi4M0FAL@SX\b&+)!&#9>/.j+99/>j&%+./.jbxcP!5&50u%q7Hl).x@Q[AK[zMKMA^McJX[ZXf2I?Yh;!:PPGk%O_t6pO3\0257:8072(/>?{:((>/{74:?>?{sjrYZo1_)K4s%g%Quq{qvqqtz{0;UbGu]X+x(pdr&kj3BUVSnw?5-_@J-='>,,:+eppq\30'\28><7:hm*,}f#+(:v3s9usYtf&HHHNDIKKHKRThLe*:FkC:dG$ZSUF&84BgyOpldwzFKSOXYr$RWhpfv5gt,!HHCSm+ww%x?UMC:TH:*-6616?z.VzqXJ6TVP8;roHpe#3{(ow&Wb%wxX`jahanlnhminmjt+cq*^j$A;B$VJzpawPllNX\30;;206;w6$$2#is)IhYJ8:./PSRWp:Z_71v^C94%6?15xwo!yO(#gtO{p1wMKJ@D,6gEYE-&X)hh^YSRO\23Z^DZVCT_=aT[M&/3ZoAA=Ar)c&g/FATA@Fb-2lK9Uux,K.ra@(?@:-v%5snOhrkw~}~{}xss|DW:;:r;srh*IAp3zYEfdY(ql]::*0);;-<rgg\14$=0=;\18WFEXqs:{4@bfP)w*}rxuuwyqqxtz}TY}-b%p:5D(x/v*+-Sqv6]v'+ 7+/=2'+#YhDjL.j8S+NUzX(cHH}A:$c@_YN5}!:JGcBnn8wRJ):.!F0j]%d3IE,YV;CWQFX25Uu3+[FaDOsf*(0:4FEO^]vVNAjeCVWOGU_HWA@acq}[079R4I1{0@oEM;o(2xI@JOLLMJLLADK8Mg(65]B+Wm!NwvFcGP}\21:!6\0006!%6!s 6?502??s;<<8s{&=#208zrU@UR\15fDUuNU@MlDLNSXtR@FDlC\1XHDME\5\0054;7?9;66z2551zr).;91z5,?(<65-s:~[[RPV[\23VDDRC@dCp(YV6ukOTLTNG9={xsszrssstpv{JvS)JEk9g-9(;l0nO.1#5bbIRNIOTSZxA##V,Gg%./p0)g{Thb:S/z__VTR_\19R@@VGoUz4mVa(SV[$KowFpTfDNLDUSXsg,tvNJSp%:VmMuYCKo{SB-*-8:2y6/<+?56.xLfU%m_JmSRXnk!}Augvji+D25!a/nR#}hA-t]qS%yKeYbhidoohoijj1I6oknMf$o-$C$9@4[S(QXS:rKA*2NyoM7O8((8wke9+=*V}DuBB_Bf[oP#DY4!9v3u:K{OGNYx@a2h_JVSY[N_^|SHINk(;[]^YHoOv}D}~[[RPV[\23VDDRCj{z*}3gb8/_a*Qg_x]]TVP]\17PBBTEczHdFA#mD=v)rgo) +^Pp!6WY0*z,MbQ39;u:Hdu%uI\4\0045:6>8:77{8{>))4){62(6:/83\02322;9?2~?--;*x!JDz,pUXc412SvSSZX^S\31^LLZK{Lm&u8xKoJ_rv(!1+2  6':7i||d`c`gfjedjb`bczWS@FPWSFf[_W7kaZVbJ_D*lFV\4!!(*,!m,>>(9=}*xSjudc*[s335&7}CC(9f[x=xyZF[,K0RO?F%=::>80!480!=:1.KNm;;l^uotdAAHJLA\rL^^HY{b9*bWdKx.y8'7-4&&0!ozz\00309:6<!,fk@u*$aCRgUUCR`CRENuRGRSU\6NIIMfdnaeoegeb`abff_l!ZW&*UK\0217 )*$!e-**.em*3 7#)*2l!1+2  6':7i||kk`gdgkbc`5:=7oG/Do_(DJcZ/A]Y_^.!EXKVSUT[k=0XW30-ZYf+-jF\26??642?s2  6'QeO]N8OT5fGjE@LG]l_LG]KMVmQX;GBo@GMo@[Z]jA@EM~A@JA`ZhhMMDF@M\1@RRDUZ5l7YtAmqTT]_YT\24YKK]Lkq9ujG{XhJSLKBuWLHLQLS@VfJPKQ\1$$-/)$h);;-<[Qghif-^I]YI_XWU3d4[KSYuSeVvJGECpCTUOIHC0zw8MWVd`efeiigdio}cB,}tL4fEIKFzFKSOXLi;dH2vo:<:9,'-,-*$jm/fOkJ4tCKIRCcPCHRdhr*6sJCdSXRSDufcpDW[Sb_[S69;6>:<$%-)O.?^.uzyAPZ@JZz]LY}@DL2{yNAFLAy+jk:l.QZzBYR|MPF[L]PQdEpD@]p8DGK@@DKEECEAKEc@XtCVJOEGRCBuRITGACso\21brTOGHAJCeISHR\029881358t5''1 ]5f)+ +<'-n+6+-;:!< 0*3!!7&h}}\2'<9\nBBAJDBBEDJJJCEAddggcal`lebldlfjkcjjlnnblbjomhdem`fb`dbd`lecesKZPJ@PpWFSwJNFCCGGK@EBGEARIFHuPEPcTRTXGTzSAB34!#+`/6%2&,/7*-8:2y6/<+?56.gbcadbde`fF6b={TSYnXOKT^X(@fjV[Y_s^P9/25.\020118:<1}<..8)bGGNLJG\vJXXN_\v..'%#.b#11'6jOOFDBO\3BPPFWqTT]_YT\24YKK]LhMMDF@M\1@RRDU\01744=?94x9++=,RVB]HXSYKT}4t\4!!(*,!m,>>(9y|pxpyp}px{f~BBFqSBwEOXUOJYH!c6eWDo9dFQX[UPuGMZWqpqqupwuvvnCCAJKCAEKAEf``bbconabgB@@KK@ECCA@olgifngkfofwv~vrquwrrvI@JOL@HHHIOJNHOBJKHJLITQVTRP]TW]PBGKCEA@JKCEeddhabge`e~x~}pzyxp~qZ[^VsVVWVhJ[|J]YFLJDLSBIDSVSQ8989898989eBYdREA^TRdkldkkhdjjwrwqutwspwXBWGXBKC]NmagnitudeX^X[NEONOBK@TTO)t]I^ZI@FKR333333\195?^MC[^Q[S\154\153\153\153\153\153\185?4%26#203&(# ,*8/;?/9>XBED[SXLDHEJFBvTCJIGBreadu32.=;,7*W@VPH@EBWBCE{k\18vWJunpack$&<50%QRVNEHo@CBI3212%&.+0=OHBC^clearjEFGL=-f\182S\174\188\169\211\255ka\180\168\215\199\168Zjz\199\133\211\131\200 n;\254\172\185\237P\233\183\18&\242c\2365\165c\233\178\188'\141\245\r\b\141\212\210\211\134\131\22\220s\209s\247cx\226\n\160z\249b\253\156\163ju\252\217n4qE9\27C\190\183\23f\v\223@\18\vc\227\21&\219\4\176\194d\155%\181hWwG\183\24\249\239\190\142eL\212\251\183\188s!-=m\b\224+\211\137\1473\230\169Q\181\212\244\r\190\213\229c=\15\250\184_z\231G\160\133\24.\140\b\156(->/3*12\230\169\1473\155\142\210\146\0056\208\1862\136\219\14Hq\185\243a&g\167\17LhX.zf\179\197\158\187\222\251\244\214\211\a-\184\231\1838\142\249\210\163\b\135:$6#\151ld\145&08%\128Q\215\200\229\189\2\0\208\184`\218\28\242\189\189:\0\222Q\254\194\6iv\27\212\254\3G\v\187d\16\183\29*'9*\196\194\2168\154\210\177t0;)4=6yfy-$/\0\4dlq30=#\r\5yf\15\bT$\24{4!U\1)6\29a1\3 ",
    270,
    54,
    4301,
    2328,
    3469,
    105,
    3368,
    3453,
    3473,
    175,
    348,
    2164,
    buffer.tostring,
    2748,
    371,
    3496,
    2789,
    158,
    3038,
    84,
    169,
    128,
    2478,
    386,
    3424,
    1949,
    function() -- line 428
        local success, result = xpcall(function() -- line 429
            return game[{}]
        end, function() -- line 431
            return debug.info(2, "f")
        end)

        local success2, result2 = xpcall(function() -- line 434
            return game:__()
        end, function() -- line 436
            return debug.info(2, "f")
        end)

        return result, result2
    end,
    118,
    19,
    3601,
    3311,
    324,
    2828,
    178,
    3436,
    2067,
    827,
    1785,
    42,
    314,
    96,
    3299,
    3221,
    3481,
    3317,
    89,
    368,
    3294,
    3161,
    function(...) -- line 463 · shares: [1] num, [2] v5, [3] v21, [4] v22, [5] v, [6] list, [7] v26, [8] callback9, [9] v12, [10] v19, [11] v16, [12] callback7, [13] v23, [14] v18, [15] callback3
        if not num then
            num = {
                v5,
                "}\228\134\227",
                v21,
                v22,
                "qi·",
                v,
                1474981348,
                list,
                num,
                v26,
                callback9,
                v12,
                v19,
                v16,
                callback7,
            }
        end

        local v2, flag, flag2, v3, v4, v6, v7, v8, v9, v10, v11, v13, v14, v15, v17, v20, v24, v25
        local xored
        xored = list[list[469]]

        while true do
            xored = bit32.bxor(xored, list[list[21]])

            if xored < 11091 then
                if xored < 11034 then
                    if xored < 11013 then
                        if xored < 8747 then
                            return
                        elseif xored < 11010 then
                            if xored < 11008 then
                                return
                            elseif xored < 11009 then
                                flag, v2 = v(function() -- line 483 · shares: [1] v23, [2] list, [3] v22
                                    if not v23 then
                                        ({})[1] = list;
                                        ({})[2] = v22;
                                        ({})[3] = v23
                                    end

                                    local v = list[588]

                                    return v[list[698](list[list[708]](v23, list[666], list[454]), buffer.readu8(v22, list[1120]))](v)
                                end)

                                flag2 = flag
                                xored = if flag2 then list[793] else list[list[633]]
                            else
                                flag2 = v2

                                v2 = list[709][list[list[737]](list[list[708]](v23, list[list[486]], list[469]), buffer.readu8(v26, list[866]), buffer.readu8(v26, list[990]))](flag2)

                                list[709][list[698](list[list[708]](v5, list[1029], list[list[819]]), buffer.readu8(v26, list[list[549]]))](v2)

                                flag = (function(list2, arg2, arg3) -- line 506 · shares: [1] v26, [2] v23, [3] list, [4] v22, [5] v5, [6] v18
                                    if not v26 then
                                        ({})[1] = v26;
                                        ({})[2] = v23;
                                        ({})[3] = list;
                                        ({})[4] = v22;
                                        ({})[5] = v5;
                                        ({})[6] = v18;
                                        ({})[7] = list2;
                                        ({})[8] = arg2;
                                        ({})[9] = arg3
                                    end

                                    local v, v2, v3, v4
                                    local xored
                                    xored = list[list[105]]

                                    while true do
                                        xored = bit32.bxor(xored, list[list[1093]])

                                        if xored < 6506 then
                                            if xored < 6498 then
                                                if xored < 6162 then
                                                    return
                                                elseif xored < 6496 then
                                                    return
                                                elseif xored < 6497 then
                                                    xored = list[list[512]]
                                                else
                                                    return false
                                                end
                                            elseif xored < 6502 then
                                                if xored < 6500 then
                                                    xored = if xored < 6499 then list[935] else list[list[885]]
                                                elseif xored < 6501 then
                                                    local valueType = type(list2)
                                                    xored = if valueType ~= list[698](list[list[708]](v23, list[list[1003]], list[list[819]]), buffer.readu8(v22, list[list[27]])) then list[454] else list[list[819]]
                                                else
                                                    v4 = buffer[list[list[708]](v18, list[1055], list[list[819]])](v2, v3)
                                                    v = bit32[list[list[708]](v22, list[671], list[1002])](v, v4)
                                                    v = bit32[list[list[708]](v18, list[959], list[1002])](v * buffer.readu8(v22, list[1120]), buffer.readu32(v18, list[552]))

                                                    v3 += buffer.readu8(v5, list[642])
                                                    xored = list[list[1043]]
                                                end
                                            else
                                                if xored < 6504 then
                                                    if xored < 6503 then
                                                        return v == arg3
                                                    end

                                                    return false
                                                end

                                                if xored < 6505 then
                                                    v = buffer.readu16(v23, list[972])
                                                    v2 = buffer[list[list[708]](v23, list[list[934]], list[708])](list2)
                                                    v3 = buffer.readu8(v26, list[1083])
                                                    xored = list[list[512]]
                                                else
                                                    xored = list[list[1074]]
                                                end
                                            end
                                        else
                                            if not (xored < 7435) then break end
                                            if xored < 6510 then
                                                if xored < 6508 then
                                                    if xored < 6507 then
                                                        xored = if v3 <= arg2 - buffer.readu8(v18, list[938]) then list[801] else list[list[267]]
                                                    else
                                                        v4 = buffer[list[list[708]](v5, list[list[221]], list[list[378]])](v2, v3)

                                                        v = bit32[list[list[708]](v22, list[671], list[1002])](v, v4)
                                                        v = bit32[list[list[708]](v18, list[959], list[1002])](v * buffer.readu8(v22, list[1120]), buffer.readu32(v18, list[552]))

                                                        v3 += buffer.readu8(v18, list[938])
                                                        xored = list[793]
                                                    end
                                                else
                                                    if xored < 6509 then
                                                        return
                                                    end

                                                    xored = if #list2 ~= arg2 then list[708] else list[532]
                                                end
                                            elseif xored < 6522 then
                                                if xored < 6511 then
                                                    xored = list[732]
                                                else
                                                    if xored ~= 6511 then break end
                                                    xored = if v3 < arg2 then list[650] else list[1092]
                                                end
                                            elseif xored < 6523 then
                                                xored = list[1002]
                                            else
                                                if xored ~= 6523 then break end
                                                xored = list[list[1074]]
                                            end
                                        end
                                    end
                                end)(list[709][list[list[737]](list[list[708]](v23, list[778], list[1088]), buffer.readu8(v26, list[938]), buffer.readu8(v22, list[1083]))](v2), buffer.readu8(v22, list[list[741]]), buffer.readu32(v18, list[856]))

                                xored = list[639]
                            end
                        elseif xored < 11011 then
                            flag = flag2
                            xored = list[list[227]]
                        elseif xored < 11012 then
                            v9 = v8

                            flag2 = list[709][list[list[737]](list[list[708]](v5, list[627], list[454]), buffer.readu8(v18, list[654]), buffer.readu8(v5, list[509]))](flag2)
                            xored = list[1004]
                        else
                            flag = v19
                            flag2 = buffer.readu8(v5, list[642])
                            v3 = buffer.readu8(v26, list[642])
                            v13 = flag2
                            v10 = v3
                            xored = list[978]
                        end
                    elseif xored < 11027 then
                        if xored < 11024 then
                            if xored < 11014 then
                                v7 += list[list[885]]
                                xored = list[443]
                            elseif xored < 11015 then
                                flag2, v3 = v(flag)
                                flag = not flag2
                                xored = if flag then list[list[792]] else list[832]
                            else
                                if xored ~= 11015 then break end
                                v9 = v8
                                v20 = v17

                                flag2 = v2 ~= callback3((list[list[737]](list[list[708]](v26, list[801], list[list[554]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v22, list[list[286]]))))

                                xored = list[list[62]]
                            end
                        elseif xored < 11025 then
                            v2 = v12[list[list[737]](list[list[708]](v18, list[1101], list[list[543]]), buffer.readu8(v26, list[866]), buffer.readu8(v5, list[642]))]

                            flag = nil
                            xored = list[list[512]]
                        elseif xored < 11026 then
                            v15 = v14
                            v25 = v24
                            v9 = v8
                            v20 = v17

                            flag = v3[list[list[737]](list[list[708]](v26, list[list[87]], list[454]), buffer.readu8(v26, list[679]), buffer.readu8(v5, list[509]))](v3, callback3((list[698](list[list[708]](v5, list[906], list[650]), buffer.readu8(v22, list[990])))))

                            xored = list[766]
                        else
                            v9 = v8
                            v20 = v17

                            flag = list[709][list[list[737]](list[list[708]](v23, list[648], list[list[138]]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[642]))](flag)
                            xored = list[list[798]]
                        end
                    elseif xored < 11030 then
                        if xored < 11028 then
                            v2 = nil
                            xored = list[list[251]]
                        else
                            if xored < 11029 then
                                v9 = v8
                                v20 = v17
                                return callback9((list[list[737]](list[list[708]](v26, list[list[160]], list[list[265]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v26, list[990]))))
                            end

                            flag = callback7
                            flag2 = buffer.readu8(v5, list[642])
                            v3 = buffer.readu8(v26, list[642])
                            v13 = flag2
                            v10 = v3
                            xored = list[532]
                        end
                    elseif xored < 11032 then
                        if xored < 11031 then
                            v15 = v14

                            flag = v3[list[698](list[list[708]](v22, list[623], list[1002]), buffer.readu8(v23, list[list[286]]))](v3, callback3((list[698](list[list[708]](v5, list[list[410]], list[650]), buffer.readu8(v23, list[list[741]])))))

                            xored = list[712]
                        else
                            xored = if v2 then list[931] else list[list[1084]]
                        end
                    else
                        if xored < 11033 then
                            v15 = v14
                            return callback9((list[698](list[list[708]](v18, list[621], list[list[633]]), buffer.readu8(v23, list[679]))))
                        end

                        v15 = v14
                        v25 = v24

                        flag2 = v2 ~= callback3((list[698](list[list[708]](v23, list[768], list[629]), buffer.readu8(v18, list[list[741]]))))
                        xored = list[691]
                    end
                elseif xored < 11078 then
                    if xored < 11072 then
                        if xored < 11037 then
                            if xored < 11035 then
                                v9 = v8
                                v20 = v17

                                flag2 = not v2[list[list[737]](list[list[708]](v18, list[list[445]], list[list[239]]), buffer.readu8(v22, list[list[832]]), buffer.readu8(v26, list[list[305]]))](v2, (list[list[737]](list[list[708]](v5, list[899], list[list[591]]), buffer.readu8(v26, list[1057]), buffer.readu8(v5, list[564]))))

                                xored = list[list[419]]
                            elseif xored < 11036 then
                                v24 = v13
                                xored = list[708]
                            else
                                v15 = v14
                                xored = if v(v12[list[698](list[list[708]](v26, list[1015], list[978]), buffer.readu8(v22, list[list[923]]))]) then list[list[138]] else list[801]
                            end
                        elseif xored < 11038 then
                            xored = if v2 then list[list[610]] else list[list[528]]
                        elseif xored < 11039 then
                            xored = list[510]
                        else
                            if xored ~= 11039 then break end
                            flag, v2 = v(function() -- line 794 · shares: [1] v5, [2] list, [3] v23
                                if not v5 then
                                    ({})[1] = list;
                                    ({})[2] = v5;
                                    ({})[3] = v23
                                end

                                local v = list[588]

                                return v[list[list[737]](list[list[708]](v23, list[list[153]], list[656]), buffer.readu8(v5, list[list[923]]), buffer.readu8(v23, list[1083]))](v, {})
                            end)

                            flag2 = flag
                            xored = if flag2 then list[772] else list[454]
                        end
                    elseif xored < 11075 then
                        if xored < 11073 then
                            flag2 = v2
                            v2 = buffer.readu8(v5, list[642])
                            v3 = buffer.readu8(v26, list[642])
                            v7 = v2
                            v4 = v3
                            xored = list[443]
                        else
                            if xored < 11074 then
                                v9 = v8
                                v20 = v17
                                return callback9(list[list[737]](list[list[708]](v22, list[970], list[list[304]]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[492])), {flag, v2})
                            end

                            v13 += list[list[885]]
                            xored = list[532]
                        end
                    elseif xored < 11076 then
                        xored = if flag2 then list[731] else list[1002]
                    elseif xored < 11077 then
                        v2 = flag
                        xored = list[923]
                    else
                        xored = if v13 <= v10 then list[629] else list[list[442]]
                    end
                elseif xored < 11084 then
                    if xored < 11081 then
                        if xored < 11079 then
                            xored = list[1037]
                        elseif xored < 11080 then
                            v15 = v14
                            v25 = v24

                            flag2 = v2 ~= callback3((list[698](list[list[708]](v18, list[801], list[list[368]]), buffer.readu8(v18, list[509]))))

                            xored = list[793]
                        else
                            xored = if flag then list[885] else list[list[543]]
                        end
                    elseif xored < 11082 then
                        v13 += list[list[885]]
                        xored = list[list[90]]
                    elseif xored < 11083 then
                        v13 += list[list[885]]
                        xored = list[978]
                    else
                        xored = if flag2 then list[list[218]] else list[724]
                    end
                elseif xored < 11087 then
                    if xored < 11085 then
                        v15 = v14

                        flag = list[709][list[698](list[list[708]](v26, list[862], list[1002]), buffer.readu8(v23, list[679]))](flag)
                        xored = list[469]
                    elseif xored < 11086 then
                        xored = if flag then list[882] else list[list[239]]
                    else
                        v2 = nil
                        xored = list[list[168]]
                    end
                elseif xored < 11089 then
                    if xored < 11088 then
                        v2 = v12[list[list[737]](list[list[708]](v23, list[1129], list[list[227]]), buffer.readu8(v22, list[1120]), buffer.readu8(v5, list[509]))]

                        flag = nil
                        xored = list[809]
                    else
                        v15 = v14
                        v9 = v8
                        v20 = v17
                        xored = if v(v12[list[698](list[list[708]](v26, list[987], list[list[543]]), buffer.readu8(v26, list[866]))], v12, list[list[541]][list[list[737]](list[list[708]](v23, list[857], list[list[469]]), buffer.readu8(v22, list[1120]), buffer.readu8(v22, list[544]))][list[698](list[list[708]](v18, list[list[614]], list[list[378]]), buffer.readu8(v5, list[1057]))]) then list[list[819]] else list[555]
                    end
                elseif xored < 11090 then
                    v2, v3 = v(flag2)
                    flag2 = not v2
                    xored = if flag2 then list[list[421]] else list[842]
                else
                    xored = list[list[194]]
                end
            elseif xored < 11116 then
                if xored < 11103 then
                    if xored < 11097 then
                        if xored < 11094 then
                            if xored < 11092 then
                                xored = if v13 <= v10 then list[726] else list[1044]
                            elseif xored < 11093 then
                                flag, v2 = v(getfenv, -buffer.readu8(v5, list[642]))
                                flag2 = flag
                                xored = if flag2 then list[691] else list[463]
                            else
                                v8 = v7
                                xored = list[list[325]]
                            end
                        else
                            if xored < 11095 then
                                v9 = v8
                                v20 = v17
                                return callback9((list[list[737]](list[list[708]](v18, list[528], list[931]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v22, list[492]))))
                            end

                            if xored < 11096 then
                                xored = if flag2 then list[1042] else list[list[591]]
                            else
                                flag2 = v2

                                v2 = list[709][list[list[737]](list[list[708]](v22, list[list[486]], list[469]), buffer.readu8(v5, list[654]), buffer.readu8(v26, list[990]))](flag2)

                                list[709][list[698](list[list[708]](v18, list[list[318]], list[list[819]]), buffer.readu8(v22, list[579]))](v2)

                                flag = (function(list2, arg2, arg3) -- line 951 · shares: [1] v26, [2] v18, [3] v22, [4] v23, [5] list, [6] v5
                                    if not v26 then
                                        ({})[1] = v26;
                                        ({})[2] = v18;
                                        ({})[3] = v22;
                                        ({})[4] = v23;
                                        ({})[5] = list;
                                        ({})[6] = list2;
                                        ({})[7] = arg2;
                                        ({})[8] = arg3
                                    end

                                    local v, v2, v3, v4
                                    local xored
                                    xored = list[list[1074]]

                                    while true do
                                        xored = bit32.bxor(xored, list[953])

                                        if xored < 4507 then
                                            if xored < 4500 then
                                                if xored < 4496 then
                                                    if xored < 4492 then
                                                        return
                                                    elseif xored < 4493 then
                                                        local valueType = type(list2)
                                                        xored = if valueType ~= list[list[737]](list[list[708]](v18, list[list[639]], list[978]), buffer.readu8(v26, list[654]), buffer.readu8(v5, list[564])) then list[list[512]] else list[708]
                                                    else
                                                        if xored ~= 4493 then break end
                                                        xored = list[732]
                                                    end
                                                elseif xored < 4498 then
                                                    xored = if xored < 4497 then list[935] else list[1092]
                                                elseif xored < 4499 then
                                                    xored = if v3 <= arg2 - buffer.readu8(v18, list[938]) then list[532] else list[801]
                                                else
                                                    xored = list[list[378]]
                                                end
                                            elseif xored < 4503 then
                                                if xored < 4501 then
                                                    xored = list[732]
                                                else
                                                    if not (xored < 4502) then break end
                                                    return false
                                                end
                                            elseif xored < 4505 then
                                                if xored < 4504 then
                                                    xored = if #list2 ~= arg2 then list[list[819]] else list[1002]
                                                else
                                                    return v == arg3
                                                end
                                            elseif xored < 4506 then
                                                v = buffer.readu16(v23, list[972])
                                                v2 = buffer[list[list[708]](v23, list[list[934]], list[708])](list2)
                                                v3 = buffer.readu8(v26, list[1083])
                                                xored = list[list[378]]
                                            else
                                                xored = list[list[105]]
                                            end
                                        else
                                            if not (xored < 5536) then break end
                                            if xored < 4510 then
                                                if xored < 4508 then
                                                    return false
                                                elseif xored < 4509 then
                                                    v4 = buffer[list[list[708]](v18, list[1055], list[list[819]])](v2, v3)
                                                    v = bit32[list[list[708]](v22, list[671], list[1002])](v, v4)
                                                    v = bit32[list[list[708]](v18, list[959], list[1002])](v * buffer.readu8(v22, list[1120]), buffer.readu32(v18, list[552]))

                                                    v3 += buffer.readu8(v5, list[642])
                                                    xored = list[list[267]]
                                                else
                                                    xored = list[list[1043]]
                                                end
                                            else
                                                if not (xored < 4551) then break end
                                                if xored < 4511 then
                                                    v4 = buffer[list[list[708]](v5, list[list[221]], list[list[378]])](v2, v3)
                                                    v = bit32[list[list[708]](v22, list[671], list[1002])](v, v4)
                                                    v = bit32[list[list[708]](v18, list[959], list[1002])](v * buffer.readu8(v22, list[1120]), buffer.readu32(v18, list[552]))

                                                    v3 += buffer.readu8(v18, list[938])
                                                    xored = list[650]
                                                else
                                                    if xored ~= 4511 then break end
                                                    xored = if v3 < arg2 then list[list[885]] else list[454]
                                                end
                                            end
                                        end
                                    end
                                end)(list[709][list[list[737]](list[list[708]](v22, list[788], list[list[543]]), buffer.readu8(v18, list[861]), buffer.readu8(v23, list[789]))](v2), buffer.readu8(v22, list[list[741]]), buffer.readu32(v18, list[856]))

                                xored = list[list[1088]]
                            end
                        end
                    elseif xored < 11100 then
                        if xored < 11098 then
                            return callback9((list[list[737]](list[list[708]](v22, list[916], list[510]), buffer.readu8(v5, list[875]), buffer.readu8(v18, list[990]))))
                        end

                        if xored < 11099 then
                            v15 = v14
                            v25 = v24

                            flag = list[709][list[698](list[list[708]](v18, list[995], list[1002]), buffer.readu8(v18, list[list[741]]))](flag)
                            xored = list[1088]
                        else
                            xored = if flag2 then list[list[304]] else list[list[368]]
                        end
                    elseif xored < 11101 then
                        v15 = v14
                        v25 = v24

                        flag2 = not v2[list[698](list[list[708]](v23, list[list[46]], list[1002]), buffer.readu8(v5, list[list[741]]))](v2, (list[698](list[list[708]](v22, list[803], list[list[138]]), buffer.readu8(v18, list[861]))))

                        xored = list[772]
                    elseif xored < 11102 then
                        flag2, v3 = v(flag)
                        flag = not flag2
                        xored = if flag then list[list[15]] else list[766]
                    else
                        xored = if v2 then list[442] else list[738]
                    end
                elseif xored < 11109 then
                    if xored < 11106 then
                        if xored < 11104 then
                            flag = setmetatable
                            flag2 = buffer.readu8(v5, list[642])
                            v3 = buffer.readu8(v26, list[642])
                            v13 = flag2
                            v10 = v3
                            xored = list[list[90]]
                        elseif xored < 11105 then
                            v2 = nil
                            xored = list[list[105]]
                        else
                            v15 = v14
                            return callback9((list[698](list[list[708]](v5, list[list[956]], list[list[633]]), buffer.readu8(v26, list[789]))))
                        end
                    else
                        if xored < 11107 then
                            return callback9((list[698](list[list[708]](v22, list[list[352]], list[list[798]]), buffer.readu8(v26, list[789]))))
                        end

                        if xored < 11108 then
                            v2 = flag
                            xored = list[792]
                        else
                            xored = if flag2 then list[list[1074]] else list[785]
                        end
                    end
                elseif xored < 11112 then
                    if xored < 11110 then
                        xored = if v13 <= v10 then list[876] else list[732]
                    elseif xored < 11111 then
                        xored = list[935]
                    else
                        flag, v2 = v(function() -- line 1144 · shares: [1] v5, [2] list
                            if not v5 then
                                ({})[1] = list;
                                ({})[2] = v5
                            end

                            local v = list[588]
                            return v[list[698](list[list[708]](v5, list[773], list[454]), buffer.readu8(v5, list[875]))](v, {})
                        end)

                        flag2 = flag
                        xored = if flag2 then list[list[62]] else list[1082]
                    end
                elseif xored < 11114 then
                    if xored < 11113 then
                        v15 = v14
                        v25 = v24
                        return callback9(list[698](list[list[708]](v23, list[1128], list[454]), buffer.readu8(v26, list[897])), {flag, v2})
                    end

                    v2 = flag
                    xored = list[650]
                elseif xored < 11115 then
                    flag2, v3 = v(flag)
                    flag = not flag2
                    xored = if flag then list[916] else list[712]
                else
                    xored = if v7 <= v4 then list[1092] else list[list[885]]
                end
            elseif xored < 11129 then
                if xored < 11122 then
                    if xored < 11119 then
                        if xored < 11117 then
                            xored = list[list[265]]
                        elseif xored < 11118 then
                            v14 = v13
                            xored = list[656]
                        else
                            flag2 = not list[list[1049]](flag, buffer.readu8(v23, list[861]), buffer.readu32(v23, list[560]))
                            xored = list[list[378]]
                        end
                    elseif xored < 11120 then
                        return
                    elseif xored < 11121 then
                        v9 = v8
                        v20 = v17
                        return callback9((list[list[737]](list[list[708]](v23, list[740], list[882]), buffer.readu8(v5, list[list[923]]), buffer.readu8(v22, list[544]))))
                    else
                        return callback9((list[698](list[list[708]](v5, list[920], list[885]), buffer.readu8(v22, list[1120]))))
                    end
                elseif xored < 11125 then
                    if xored < 11123 then
                        xored = if v(list[588][list[698](list[list[708]](v23, list[list[712]], list[793]), buffer.readu8(v22, list[1120]))], list[588], (list[list[737]](list[list[708]](v26, list[673], list[list[1074]]), buffer.readu8(v26, list[list[741]]), buffer.readu8(v18, list[list[738]])))) then list[list[162]] else list[list[796]]
                    elseif xored < 11124 then
                        v2, flag = v(list[588][list[698](list[list[708]](v22, list[996], list[793]), buffer.readu8(v5, list[613]))], list[588])

                        flag2 = v2
                        xored = if flag2 then list[list[378]] else list[1022]
                    else
                        v15 = v14
                        v25 = v24
                        return callback9(list[698](list[list[708]](v26, list[447], list[list[1074]]), buffer.readu8(v5, list[1057])), {flag, v2})
                    end
                elseif xored < 11127 then
                    if xored < 11126 then
                        flag, v2 = v(function(arg1, arg2, arg3) -- line 1240 · shares: [1] v22, [2] list
                            if not arg3 then
                                ({})[1] = v22;
                                ({})[2] = list;
                                ({})[3] = arg1;
                                ({})[4] = arg2;
                                ({})[5] = arg3
                            end

                            local v = list[588]
                            return v[list[698](list[list[708]](v22, list[800], list[list[378]]), buffer.readu8(v22, list[509]))](v)
                        end)

                        flag2 = flag
                        xored = if flag2 then list[list[419]] else list[768]
                    else
                        v17 = v13
                        xored = list[1031]
                    end
                else
                    if xored < 11128 then
                        v9 = v8
                        v20 = v17
                        return callback9(list[list[737]](list[list[708]](v23, list[522], list[list[239]]), buffer.readu8(v26, list[list[741]]), buffer.readu8(v22, list[861])), {flag, v2})
                    end

                    v9 = v8
                    return callback9((list[list[737]](list[list[708]](v18, list[836], list[list[162]]), buffer.readu8(v18, list[861]), buffer.readu8(v23, list[789]))))
                end
            elseif xored < 11135 then
                if xored < 11132 then
                    if xored < 11130 then
                        v15 = v14
                        v25 = v24
                        return callback9(list[698](list[list[708]](v18, list[933], list[list[62]]), buffer.readu8(v22, list[1120])), {flag, v2})
                    end

                    if xored < 11131 then
                        xored = if flag2 then list[list[526]] else list[700]
                    else
                        return callback9((list[698](list[list[708]](v26, list[list[411]], list[list[798]]), buffer.readu8(v22, list[972]))))
                    end
                elseif xored < 11133 then
                    xored = if flag then list[list[267]] else list[list[398]]
                elseif xored < 11134 then
                    v15 = v14
                    flag = v3[list[698](list[list[708]](v18, list[733], list[1002]), buffer.readu8(v5, list[679]))](v3, callback3((list[698](list[list[708]](v22, list[878], list[650]), buffer.readu8(v23, list[list[305]])))))

                    xored = list[832]
                else
                    v9 = v8
                    flag2 = v3[list[698](list[list[708]](v23, list[list[1079]], list[1002]), buffer.readu8(v5, list[1057]))](v3, callback3((list[list[737]](list[list[708]](v5, list[list[445]], list[list[239]]), buffer.readu8(v22, list[990]), buffer.readu8(v23, list[789])))))

                    xored = list[842]
                end
            else
                if not (xored < 12412 and xored < 11612) or xored ~= 11135 then break end

                v2 = list[588][list[698](list[list[708]](v18, list[list[327]], list[793]), buffer.readu8(v5, list[875]))]
                flag = nil
                xored = list[list[1043]]
            end
        end
    end,
    417,
    2615,
    16294,
    211,
    434,
    76,
    301,
    3214,
    3103,
    1214,
    2762,
    285,
    3549,
    106,
    430,
    1473,
    296,
    193,
    2717,
    2348,
    47,
    65,
    3120,
    8,
    3364,
    3429,
    342,
    39,
    3652,
    3417,
    function(arg1, arg2, arg3) -- line 1368 · shares: [1] num, [2] v5, [3] list, [4] callback9, [5] v23, [6] v22
        if not num then
            num = {
                v5,
                "}\228\134\227",
                list,
                callback9,
                v23,
                v22,
                1474981348,
                num,
                arg1,
                arg2,
                arg3,
            }
        end

        callback9((list[list[737]](list[list[708]](v22, list[692], list[656]), buffer.readu8(v23, list[990]), buffer.readu8(v5, list[509]))))
    end,
    926,
    245,
    6477,
    83,
    5808,
    428,
    3113,
    2914,
    2024,
    48,
    318,
    102,
    224,
    3448,
    265,
    129,
    buffer.readstring,
    1238,
    3083,
    3234,
    2961,
    3513,
    53,
    "tostring",
    294,
    workspace,
    1496,
    373,
    2329,
    1337,
    2332,
    79,
    3,
    3349,
    3180,
    3171,
    Instance,
    256,
    166,
    3163,
    function(arg1, arg2, arg3) -- line 1414 · shares: [1] num, [2] v26, [3] v, [4] v22, [5] v18, [6] v23, [7] callback3, [8] list, [9] v5
        if not num then
            num = {
                "}\228\134\227",
                v26,
                v,
                v22,
                "qi·",
                num,
                v18,
                v23,
                callback3,
                list,
                arg1,
                arg2,
                arg3,
            }
        end

        local v2, v3
        local xored
        xored = list[801]

        while true do
            xored = bit32.bxor(xored, list[list[1006]])

            if not (xored < 5797) then break end
            if xored < 4045 then
                if xored < 1645 then
                    return
                elseif xored < 4044 then
                    return
                else
                    return (list[list[737]](list[list[708]](v26, list[list[76]], list[885]), buffer.readu8(v23, list[list[27]]), buffer.readu8(v26, list[list[923]])))
                end
            end

            if xored < 4046 then
                v2, v3 = v(vector[list[list[708]](v5, list[list[480]], list[list[267]])], arg1)
                xored = if v2 then list[list[885]] else list[935]
            elseif xored < 4047 then
                return
            elseif xored ~= 4047 then
                break
            else
                return v3[list[list[737]](list[list[708]](v23, list[list[871]], list[list[304]]), buffer.readu8(v5, list[list[923]]), buffer.readu8(v18, list[list[305]]))](v3, callback3((list[list[737]](list[list[708]](v22, list[801], list[916]), buffer.readu8(v22, list[579]), buffer.readu8(v5, list[990])))))
            end
        end
    end,
    2905,
    3560,
    3295,
    197,
    393,
    1685,
    11930,
    2048,
    359,
    4045,
    16207,
    1247,
    346,
    3111,
    3080,
    1504,
    130,
    429,
    function() -- line 1488 · shares: [1] num, [2] v8, [3] v26, [4] callback9, [5] v5, [6] v23, [7] list, [8] v22, [9] v18
        if not num then
            num = {
                "}\228\134\227",
                1474981348,
                v8,
                v26,
                num,
                callback9,
                v5,
                v23,
            }
        end

        local v, str, tbl, v2, tbl2
        local xored
        xored = list[list[1074]]

        while true do
            xored = bit32.bxor(xored, list[821])

            if xored < 14821 then
                if xored < 13662 then
                    return
                elseif xored < 14817 then
                    if xored < 14083 then
                        return
                    elseif xored < 14816 then
                        return
                    else
                        xored = list[list[819]]
                    end
                elseif xored < 14819 then
                    if xored < 14818 then
                        xored = if tbl2[buffer.readu8(v5, list[642])] then list[list[512]] else list[801]
                    else
                        list[list[1096]][list[list[737]](list[list[708]](v22, list[list[759]], list[978]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v22, list[list[286]]))](buffer.readf64(v22, list[485]))
                        tbl = {}
                        v2 = v8[list[698](list[list[708]](v26, list[list[747]], list[650]), buffer.readu8(v26, list[654]))](v8, str)

                        tbl2 = {
                            tbl,
                            buffer.readu8(v5, list[642]),
                            v2,
                            (list[698](list[list[708]](v22, list[607], list[708]), buffer.readu8(v5, list[897]))),
                        }

                        setmetatable(tbl2, {})
                        getmetatable(tbl2)[list[list[737]](list[list[708]](v22, list[666], list[454]), buffer.readu8(v5, list[1057]), buffer.readu8(v23, list[509]))] = list[list[737]](list[list[708]](v23, list[495], list[list[138]]), buffer.readu8(v23, list[1120]), buffer.readu8(v18, list[990]))

                        tbl = nil
                        v2 = nil
                        xored = list[list[885]]
                    end
                else
                    xored = if xored < 14820 then list[1002] else list[708]
                end
            elseif xored < 14828 then
                if xored < 14824 then
                    if xored < 14822 then
                        xored = list[1092]
                    elseif xored < 14823 then
                        xored = list[732]
                    else
                        callback9(list[698](list[list[708]](v26, list[869], list[list[138]]), buffer.readu8(v23, list[613])), {v})
                        xored = list[list[1043]]
                    end
                elseif xored < 14826 then
                    if not (xored < 14825) then break end
                    v += buffer.readu8(v5, list[642])
                    xored = list[793]
                elseif xored < 14827 then
                    v = buffer.readu8(v26, list[1083])
                    xored = list[793]
                else
                    xored = list[935]
                end
            elseif xored < 14836 then
                if xored < 14830 then
                    if xored < 14829 then
                        list[list[1096]][list[698](list[list[708]](v5, list[975], list[1002]), buffer.readu8(v23, list[1120]))]()
                        xored = list[list[798]]
                    else
                        xored = list[list[378]]
                    end
                elseif xored < 14831 then
                    list[list[1096]][list[698](list[list[708]](v23, list[list[766]], list[1002]), buffer.readu8(v22, list[579]))](buffer.readf64(v5, list[list[652]]))

                    xored = if tbl2[buffer.readu8(v5, list[list[738]])] then list[454] else list[650]
                else
                    if xored ~= 14831 then break end
                    xored = if v > buffer.readu8(v5, list[list[738]]) then list[532] else list[list[1043]]
                end
            elseif xored < 14838 then
                if xored < 14837 then
                    xored = list[list[267]]
                else
                    v = buffer.readu8(v26, list[1083])
                    str = tostring(math[list[list[708]](v26, list[525], list[list[819]])]())
                    local v10 = list[list[722]][list[698](list[list[708]](v5, list[911], list[532]), buffer.readu8(v22, list[579]))](list[list[737]](list[list[708]](v22, list[624], list[list[62]]), buffer.readu8(v5, list[875]), buffer.readu8(v26, list[509])), v8)

                    v10[list[list[737]](list[list[708]](v26, list[list[1102]], list[list[633]]), buffer.readu8(v26, list[866]), buffer.readu8(v22, list[1083]))] = str

                    xored = list[list[378]]
                end
            else
                if not (xored < 14892) or xored ~= 14838 then break end

                xored = list[list[885]]
            end
        end
    end,
    2246,
    function(...) -- line 1625 · shares: [1] num, [2] list, [3] v16, [4] v6, [5] v13, [6] callback8, [7] tbl2, [8] v26, [9] v23, [10] callback9, [11] v5, [12] callback, [13] v18, [14] v22, [15] v, [16] v7, [17] callback3
        if not num then
            num = {
                list,
                v16,
                v6,
                v13,
                callback8,
                tbl2,
                v26,
                v23,
                1474981348,
                num,
                callback9,
                v5,
                "}\228\134\227",
            }
        end

        local callback2, v2, flag
        local xored
        xored = list[list[267]]

        while true do
            xored = bit32.bxor(xored, list[685])

            if xored < 11989 then
                if xored < 7616 then
                    return
                elseif xored < 11985 then
                    if xored < 10605 then
                        return
                    elseif xored < 11984 then
                        return
                    else
                        v2 = callback

                        flag = list[709][list[698](list[list[708]](v23, list[753], list[list[819]]), buffer.readu8(v5, list[list[923]]))](v2)

                        list[709][list[698](list[list[708]](v18, list[list[130]], list[list[819]]), buffer.readu8(v5, list[list[27]]))](flag)

                        callback2 = (function(list2, arg2, arg3, arg4, arg5) -- line 1653 · shares: [1] list, [2] v22, [3] v23, [4] v18, [5] v26, [6] v5
                            if not arg5 then
                                ({})[1] = list;
                                ({})[2] = v22;
                                ({})[3] = v23;
                                ({})[4] = v18;
                                ({})[5] = v26;
                                ({})[6] = list2;
                                ({})[7] = arg2;
                                ({})[8] = arg3;
                                ({})[9] = arg4;
                                ({})[10] = arg5
                            end

                            local v, v2, v3, v4
                            local xored
                            xored = list[list[1074]]

                            while true do
                                xored = bit32.bxor(xored, list[list[937]])

                                if xored < 1549 then
                                    if xored < 1542 then
                                        if xored < 1539 then
                                            if xored < 1537 then
                                                return
                                            elseif xored < 1538 then
                                                v4 = buffer[list[list[708]](v18, list[1055], list[list[819]])](v2, v3)
                                                v = bit32[list[list[708]](v22, list[671], list[1002])](v, v4)
                                                v = bit32[list[list[708]](v18, list[959], list[1002])](v * buffer.readu8(v22, list[1120]), buffer.readu32(v18, list[552]))

                                                v3 += buffer.readu8(v5, list[642])
                                                xored = list[454]
                                            else
                                                xored = list[1092]
                                            end
                                        elseif xored < 1540 then
                                            v4 = buffer[list[list[708]](v5, list[list[221]], list[list[378]])](v2, v3)
                                            v = bit32[list[list[708]](v22, list[671], list[1002])](v, v4)
                                            v = bit32[list[list[708]](v18, list[959], list[1002])](v * buffer.readu8(v22, list[1120]), buffer.readu32(v18, list[552]))

                                            v3 += buffer.readu8(v18, list[938])
                                            xored = list[list[885]]
                                        else
                                            if xored < 1541 then
                                                return false
                                            end

                                            xored = list[1002]
                                        end
                                    elseif xored < 1545 then
                                        if xored < 1543 then
                                            xored = if v3 < arg2 then list[list[105]] else list[793]
                                        elseif xored < 1544 then
                                            xored = if #list2 ~= arg2 then list[708] else list[list[819]]
                                        else
                                            v = buffer.readu16(v23, list[972])
                                            v2 = buffer[list[list[708]](v23, list[list[934]], list[708])](list2)
                                            v3 = buffer.readu8(v26, list[1083])
                                            xored = list[list[378]]
                                        end
                                    elseif xored < 1547 then
                                        if xored < 1546 then
                                            xored = list[935]
                                        else
                                            return v == arg3
                                        end
                                    elseif xored < 1548 then
                                        xored = list[list[512]]
                                    else
                                        xored = if v3 <= arg2 - buffer.readu8(v18, list[938]) then list[732] else list[801]
                                    end
                                else
                                    if not (xored < 9338) then break end
                                    if xored < 1566 then
                                        if xored < 1550 then
                                            return false
                                        elseif xored < 1551 then
                                            xored = list[list[1043]]
                                        else
                                            if xored ~= 1551 then break end
                                            xored = list[list[378]]
                                        end
                                    else
                                        if not (xored < 4678) then break end
                                        if xored < 1567 then
                                            xored = list[1092]
                                        else
                                            if xored ~= 1567 then break end
                                            local valueType = type(list2)
                                            xored = if valueType ~= list[698](list[list[708]](v22, list[1029], list[list[819]]), buffer.readu8(v26, list[1057])) then list[532] else list[list[267]]
                                        end
                                    end
                                end
                            end
                        end)(list[709][list[698](list[list[708]](v18, list[1045], list[list[819]]), buffer.readu8(v5, list[789]))](flag), buffer.readu8(v22, list[list[741]]), buffer.readu32(v18, list[856]))

                        xored = list[1002]
                    end
                elseif xored < 11987 then
                    if xored < 11986 then
                        return
                    end

                    callback2 = nil
                    xored = list[793]
                elseif xored < 11988 then
                    v2, callback2 = v(callback)
                    flag = v2
                    xored = if flag then list[list[378]] else list[454]
                else
                    callback2 = function(...) -- line 1772 · shares: [1] v, [2] callback, [3] v23, [4] callback9, [5] list, [6] v18, [7] v6, [8] v5
                        if not v then
                            ({})[1] = callback;
                            ({})[2] = v23;
                            ({})[3] = callback9;
                            ({})[4] = list;
                            ({})[5] = v18;
                            ({})[6] = v6
                        end

                        local v2, v3
                        local xored
                        xored = list[801]

                        while true do
                            xored = bit32.bxor(xored, list[list[772]])

                            if xored < 3774 then
                                if xored < 3249 then
                                    return
                                elseif xored < 3769 then
                                    if xored < 3768 then
                                        return
                                    end

                                    v2, v3 = v(function(...) -- line 1789 · shares: [1] v6, [2] v23, [3] list
                                        if not v6 then
                                            ({})[1] = v23;
                                            ({})[2] = v6;
                                            ({})[3] = list
                                        end

                                        v6[list[list[737]](list[578], list[list[162]], buffer.readu8(v23, list[861]))](v6, ...)
                                    end, ...)
                                    xored = if not v2 then list[list[885]] else list[1092]
                                elseif xored < 3772 then
                                    if xored ~= 3769 then break end
                                    xored = list[532]
                                elseif xored < 3773 then
                                    v2, v3 = v(callback, v6, ...)
                                    xored = if not v2 then list[935] else list[1002]
                                else
                                    return callback9(list[list[737]](list[list[708]](v23, list[list[915]], list[738]), buffer.readu8(v18, list[861]), buffer.readu8(v18, list[938])), {v2, v3})
                                end
                            else
                                if not (xored < 8336 and xored < 4423) or not (xored < 3775) then
                                    break
                                end

                                return callback9(list[698](list[list[708]](v5, list[list[647]], list[885]), buffer.readu8(v23, list[679])), {v2, v3})
                            end
                        end
                    end
                    callback2(buffer.readu8(v26, list[1083]), buffer.readu8(v26, list[1083]), v7(v13))
                    xored = list[708]
                end
            elseif xored < 11996 then
                if xored < 11992 then
                    if xored < 11990 then
                        return callback9((list[list[737]](list[list[708]](v22, list[740], list[882]), buffer.readu8(v5, list[789]), buffer.readu8(v5, list[938]))))
                    end

                    if xored < 11991 then
                        xored = if flag then list[list[819]] else list[list[105]]
                    else
                        flag = callback2 ~= callback3((list[698](list[list[708]](v5, list[792], list[785]), buffer.readu8(v26, list[861]))))
                        xored = list[list[378]]
                    end
                elseif xored < 11994 then
                    if xored < 11993 then
                        flag = v2 ~= callback3((list[698](list[list[708]](v22, list[764], list[list[633]]), buffer.readu8(v23, list[1057]))))
                        xored = list[732]
                    else
                        return callback9(list[698](list[list[708]](v26, list[1030], list[list[62]]), buffer.readu8(v23, list[list[305]])), {v2, callback2})
                    end
                elseif xored < 11995 then
                    xored = if callback ~= v6[callback8] then list[801] else list[list[512]]
                else
                    return callback9((list[698](list[list[708]](v22, list[1133], list[list[62]]), buffer.readu8(v22, list[1120]))))
                end
            elseif xored < 11999 then
                if xored < 11997 then
                    xored = if flag then list[935] else list[1092]
                else
                    if xored < 11998 then
                        return callback9(list[698](list[list[708]](v22, list[499], list[list[62]]), buffer.readu8(v5, list[654])), {callback2, v2})
                    end

                    callback2, v2 = v(callback, v6, tbl2)
                    flag = callback2
                    xored = if flag then list[732] else list[532]
                end
            else
                if not (xored < 13420 and xored < 12017) or xored ~= 11999 then break end

                xored = if callback2 then list[650] else list[list[885]]
            end
        end
    end,
    361,
    221,
    3468,
    266,
    209,
    437,
    94,
    250,
    901,
    626,
    410,
    2626,
    1136,
    3236,
    1944,
    3384,
    2530,
    1102,
    426,
    396,
    142,
    46,
    385,
    2288,
    357,
    377,
    3392,
    3356,
    364,
    228,
    233,
    212,
    215,
    302,
    72,
    182,
    137,
    function(arg1, list2) -- line 1944 · shares: [1] num, [2] v23, [3] v18, [4] callback3, [5] tbl, [6] v5, [7] v15, [8] v22, [9] list, [10] v, [11] v26
        if not num then
            num = {
                "}\228\134\227",
                v23,
                v18,
                callback3,
                callback3,
                tbl,
                1474981348,
                v5,
                v15,
                v22,
                list,
                v,
                arg1,
                list2,
            }
        end

        local count, str, v2, v3, v4, callback, callback2, v6, v7, v8, v9, v10
        local xored
        xored = list[691]

        while true do
            xored = bit32.bxor(xored, list[851])

            if xored < 1128 then
                if xored < 1114 then
                    if xored < 1107 then
                        if xored < 1104 then
                            if xored < 1091 then
                                if xored ~= 1090 then break end
                                v10 = v9

                                str ..= list[list[737]](list[list[708]](v18, list[list[134]], list[691]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v26, list[list[305]])) .. count .. list[698](list[list[708]](v26, list[1120], list[list[885]]), buffer.readu8(v18, list[564]))

                                xored = list[list[378]]
                            else
                                if not (xored < 1097) or xored ~= 1091 then break end

                                xored = if count == true then list[list[105]] else list[list[239]]
                            end
                        elseif xored < 1105 then
                            xored = list[list[885]]
                        elseif xored < 1106 then
                            xored = list[list[162]]
                        else
                            v10 = v9
                            xored = if list[list[1049]](v4, buffer.readu8(v23, list[509]), buffer.readu32(v22, list[list[711]])) then list[list[421]] else list[801]
                        end
                    elseif xored < 1110 then
                        if xored < 1108 then
                            xored = list[1037]
                        else
                            xored = if xored < 1109 then list[978] else list[list[1043]]
                        end
                    elseif xored < 1112 then
                        if xored < 1111 then
                            count = list2[v9]
                            v2 = nil
                            xored = list[454]
                        else
                            xored = list[list[796]]
                        end
                    elseif xored < 1113 then
                        v4 = v2
                        v10 = v9
                        xored = if list[list[1049]](v4, buffer.readu8(v23, list[509]), buffer.readu32(v18, list[1039])) then list[931] else list[885]
                    else
                        v10 = v9

                        str ..= list[698](list[list[708]](v22, list[789], list[list[885]]), buffer.readu8(v23, list[990])) .. tostring(list2)
                        xored = list[532]
                    end
                elseif xored < 1121 then
                    if xored < 1117 then
                        if xored < 1115 then
                            v2 = count
                            xored = if v2 then list[1088] else list[639]
                        else
                            if xored < 1116 then
                                return
                            end

                            v3 = list[698](list[list[708]](v5, list[753], list[list[819]]), buffer.readu8(v23, list[613]))
                            xored = list[list[633]]
                        end
                    elseif xored < 1119 then
                        if xored < 1118 then
                            v10 = v9

                            str ..= count .. list[698](list[list[708]](v26, list[969], list[801]), buffer.readu8(v22, list[list[305]]))
                            xored = list[list[885]]
                        else
                            xored = list[list[798]]
                        end
                    elseif xored < 1120 then
                        v10 = v9
                        v2 = list[698](list[list[708]](v23, list[707], list[935]), buffer.readu8(v18, list[1057]))
                        xored = list[1088]
                    else
                        return
                    end
                elseif xored < 1124 then
                    if xored < 1122 then
                        v3, v4 = v(vector[list[list[708]](v5, list[list[480]], list[list[267]])], v2)
                        xored = if v3 then list[list[591]] else list[793]
                    elseif xored < 1123 then
                        xored = if list[list[1049]](count, buffer.readu8(v5, list[990]), buffer.readu32(v26, list[list[841]])) then list[list[227]] else list[list[419]]
                    else
                        v10 = v9
                        v4 = list[list[737]](list[list[708]](v5, list[801], list[792]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v23, list[866]))

                        callback2 = callback[list[698](list[list[708]](v26, list[615], list[1092]), buffer.readu8(v23, list[list[286]]))]
                        xored = list[list[819]]
                    end
                elseif xored < 1126 then
                    if xored < 1125 then
                        count = v3
                        xored = list[list[1088]]
                    else
                        count = callback(v4, callback3(v3))
                        xored = list[list[1088]]
                    end
                elseif xored < 1127 then
                    v4, callback = v(vector[list[list[708]](v5, list[list[480]], list[list[267]])], v3)
                    xored = if v4 then list[list[512]] else list[list[1043]]
                else
                    v9 = v8
                    xored = list[738]
                end
            elseif xored < 1142 then
                if xored < 1135 then
                    if xored < 1131 then
                        if xored < 1129 then
                            xored = if v15 then list[list[62]] else list[935]
                        elseif xored < 1130 then
                            v10 = v9

                            str ..= list[698](list[list[708]](v18, list[544], list[list[885]]), buffer.readu8(v5, list[679]))
                            xored = list[532]
                        else
                            str ..= v2
                            xored = list[1002]
                        end
                    elseif xored < 1133 then
                        xored = if xored < 1132 then list[list[1074]] else list[list[1088]]
                    elseif xored < 1134 then
                        str ..= tostring(count)
                        xored = list[list[304]]
                    else
                        str ..= list[698](list[list[708]](v5, list[972], list[935]), buffer.readu8(v26, list[861]))
                        count = #list2
                        v2 = buffer.readu8(v5, list[642])
                        v8 = v2
                        v6 = count
                        xored = list[732]
                    end
                elseif xored < 1138 then
                    if xored < 1136 then
                        v10 = v9
                        count = list[698](list[list[708]](v26, list[969], list[801]), buffer.readu8(v18, list[579]))
                        xored = list[731]
                    elseif xored < 1137 then
                        v15 = str
                        xored = list[882]
                    else
                        count = nil
                        str = arg1
                        xored = list[650]
                    end
                elseif xored < 1140 then
                    if xored < 1139 then
                        xored = list[list[378]]
                    else
                        xored = if count == false then list[list[267]] else list[list[265]]
                    end
                elseif xored < 1141 then
                    count = v9 == #list2
                    xored = if count then list[656] else list[731]
                else
                    v2 = callback2(callback, callback3(v4))
                    xored = list[1037]
                end
            elseif xored < 1149 then
                if xored < 1145 then
                    if xored < 1143 then
                        xored = list[793]
                    elseif xored < 1144 then
                        v8 += list[list[885]]
                        xored = list[732]
                    else
                        v3 = list[list[737]](list[list[708]](v23, list[801], list[768]), buffer.readu8(v23, list[1120]), buffer.readu8(v22, list[list[741]]))

                        callback = v4[list[list[737]](list[list[708]](v23, list[list[337]], list[691]), buffer.readu8(v18, list[866]), buffer.readu8(v22, list[492]))]

                        xored = list[list[543]]
                    end
                elseif xored < 1147 then
                    if xored < 1146 then
                        v2 = v4
                        xored = list[1037]
                    else
                        v10 = v9
                        str ..= list[698](list[list[708]](v23, list[1012], list[1092]), buffer.readu8(v22, list[list[305]]))
                        xored = list[list[796]]
                    end
                elseif xored < 1148 then
                    v10 = v9
                    v4 = list[list[737]](list[list[708]](v22, list[list[1113]], list[list[796]]), buffer.readu8(v26, list[897]), buffer.readu8(v5, list[579]))

                    xored = list[708]
                else
                    v10 = v9
                    str ..= list[698](list[list[708]](v26, list[473], list[1002]), buffer.readu8(v23, list[938]))
                    xored = list[list[304]]
                end
            else
                if not (xored < 4059) then break end
                if xored < 1150 then
                    v2 = list2
                    xored = list[list[792]]
                elseif xored < 1151 then
                    xored = if v8 <= v6 then list[712] else list[469]
                else
                    if xored ~= 1151 then break end
                    v3 = count
                    xored = list[list[526]]
                end
            end
        end
    end,
    2208,
    326,
    213,
    3536,
    272,
    222,
    398,
    "uYXXSUBSR",
    task,
    150,
    3645,
    3373,
    1652,
    3552,
    380,
    303,
    180,
    790,
    2547,
    204,
    3017,
    280,
    147,
    2656,
    403,
    2799,
    "f",
    68,
    59,
    3461,
    341,
    196,
    2500,
    3121,
    98,
    90,
    "\27'*o,:==*!;o;'=*.+o,.!! ;o,.##oh\a;;?\b*;\14<6!,hog#.,$&!(o,.?.-&#&;6o\29 -# 7\28,=&?;f\14(;9?6?))z?((5(z>?.?9.?>P/@PbpMg0u2H+pTF[pNST!Nh0pBDT?V+;!8**<-0=cvv`jlkmljnjiCcGXkk=7SZL[ZXS%d?]1@/NmcpF*k\22 &07 e\1 =em$&1*7e 77*7e(6\"lNEEx.+cT48soaA_-J[^wGkIXaIAC^Uy_MKIaNjC^xMK\fDCCG(Q)eCVvnG9lV3#wd9a=G:KkYYO^lO^IBy^K^_Yr$Os)B-VN-/m]WmZ=lgJ,88xN?{73gXwGAJApVMEJCHAgKQJPO=Z[hpb8T/?r9lmWO;9)e^Bf+d,<&?--;*7:dqqjgofmimjoi?pT)eDej8Gj{3o]3k1]@3\14!&,\27-:>!+-h ''#h`'>-:.$'?aDLrfWZk#-c/}BkG8kWWSqA[bSJpFQUJ@F5Qo+:ioe+;W*-HKWM4CMW%l$GGb@Qv@WSLF@axC/l0QEB^}!P%byufg5-8?!yq+%ra_WRUQUU_STU_yPQ7%!MD/rS,;f,Gh[lFy_6B;#c0Z9f^OE_UEeBSFb_[S{Ep:9+CQf1rKc{lSSK.r]c4x+&',6+$;':'!76-0!9HvACW,)8Igc)*xs1B2Ax%`EELNHE\tHZZL]cZQQ(}8Mf!jYChC21-?OxGW=uxeckdjk`bgkfdgg#{$jI32kys&oiyqB58/Xt.53mnjjobkmihIo;vujg.Ppq#Y{_@58O,[GAZ7fze;.-#*<o,.!! ;o-*o,6,#&,%Us#y#KO7-GrjUW@VPH@.$nD4S,H%[l7dE4E,Z/Ccd-+VEZ&y,jr^_ET_EaC^GXUTC=qPI0zYwXQe]F)oJH9ff@x`|\aqqGTBVTYYvZ@[A]kqA7Gugmc!M,3Wj8-L\02758:250*-<=y8**<-y?65=<+VOpTvE}EZk%y\029881358t5''1 BP]JogQ=wdB$$RdP[enulDrI@ENVReS@VB@MMbNTOUd=uf;Ls^w:9Ai{RPQYSVQQUPPTRXQWs4q7M}kcz9Mz%6yFLDXt)&5;,:=0%Ty[ejrXfwQ4D26a3ZVi3}iu(VJfDU`RRDUgDUBIrU@UTRbI@OFDErHFO@MRz2;0kZJ4j.-7dSwO$z8qZ4z/,)Zde3@Om&?(#;c\18\18$#)(5m>.?$=9;]Fa0c}fw$VR}rr334<5$_Gv,.WOaGm}+0b@Nb?uomb^*#*vbjhomiiljhbn3a1T:lYc${*)z)0+[z}L/2tZFlFLKZRjv\31d\14b(l:[j5Tt}H_Zn#o1GDRRTQUVRVUPdy5Vu3RHnUVA8p0CA*(fyu7|YYPRTY\21TFFPAq=0)0pF,U2ae%iQ_aA8Y_H[H_^HL,W8)69(8r(Bg0:Di%56GT0t#{VLKMV]JKZ[x^RZkVRZ9[0B1S3)&u3Vi:*0);;-<!,rggyxx}}p|z|{pn4Hd62J,9$5?;4&,.!,ai)FLJyg6Te3PIl:=VyYVQ[UU,7hHQ**&fqq=G{Wf*BzF8ByJ(!(=%bWO-:By&d6Tey$;GdiNB4O*mVt[@WaW@DW@%@6MUQWtCmUA@;oL;uRWzQL@zAYVQFg5pvHI$1Sh1)33JR5yI~JYU]lQU]]Xhr[G@Zf;Me(]5.m%oC\5  )+- l-??)8^t-Pdi3p7Q_(4mNqmHHACEH\4EWWAPi4U9&j47S=SMn))XecdALvPon=xCZ2}K-%O9@U9AB98EYTU^DYVIUHUSED_B@^1&X5/$Q-276&<%77!0- ~kkswtstuwqt||uusbJ+gN}N4og=[hx,$!pq8;yzD&@+=lI8X)i;tBzS7e;K1U3!Y@]Ft^/(->/KcGbh!7z?0.om2X$wGJ/2N!lKSJN@v@WS@WPH!jEv1s,HJDRvbded``i`bf6c2:yEqlT//aFy:+cbbggjf`fajsjuDtZXn]cQ!Qv0\1ez;tez,t\26'/:<+:;j6BuLZG5\27,,1,~-790?2~:7-=100;=*;:9?,=W@vpE{9_iCY%SY;K{Ob)ixzuyy{yz{z3*a906}SKk}Ja)3#9 22$5(%{nnppryxprvxrv_V]pR_G{(Rm&C&ft!5j0dO{\15**#!'*f'55#2^nIqfH7A!a\3!6?<27\18 *=0s{<%6!5?<$zKM^O\17``KPLKMVQX\31VQIPTZ[\017366?>z65=z.2(?;>V3tqRlmjmdjeoonm!]!*RK{%bT5jHYyBYLA`H@B_Tx^LJH`ORDCE^YPSS(*(K[yD(=l%!%).;91z5,?(<65-8hOHXOF(*!*=&,o*7*,:; =D7fg#|^OzHH^O}^OXShOZONH(F695=;944x;944+,9;3xj\01966?=;6z;))?.Sd;zyxWxDIKMaL;0mwB.gr0lSNtVGr@@VGuVGP[`GRGF@BP_F@+IqUU1o&IP}O@JiUUQfDU`RXOB\1MD@J\1\19EBWBCE]ZQPgm7J!&Kv.!-%#!,,`#!,,34!#+:*0);;-<rgg\v:18<!+aV]WVAtcfuAR^VgZ^V~FW]GM]}ZK^zGCKc]V_T_BT0Q$]j27oCDdpl\23aqWLDKBI@fJPKQ'*+ :'(7+6+-;:!<@MFEAFCCDBEVzeAQbI@OFDETlmKMNLdQ\15**#!'*f'55#2^(^).;91z5,?(<65-r&30>7(3$S7_VLk/\6##*(.#o.<<*;Tjonhoikgmfglmojh\b--$& -a 22$5h{`KFJALKBv@WSLF@eel`famdabcebbb;<)+#h'>-:.$'?CHZ9I6AwId@xdXKG@DJF@C@BJCDAmymyyk(T_oF%bD\02322;9?2~?--;*cFFOMKF\nKYYO^\27>>753>r3!!7&`EELNHE\tHZZL]\3&&/-+&j+99/>qVKLYV[]{WMVL|YYPRTY\21TFFPA(9206?d+vCS;o\r((!#%(d%77!0gXCEDP]dBTCB/*1-8h:ARQzn,9/*3,.=8$#$,||WLPWQJMDN8agab``beof,}][TXXXZZUZYGFGEAOBGOBGVVWTQ__SUTSLLIELMLMMMMVS_WQV^_VR^lN_m^GGeJFNmNB@MqM@XDSp_XReSD@_USACGF@GLBAMY.=+,8#%/?? dFWpFQUJ@Fmhkloi`ijahlhj`oo`jnjoilbmlbinkkZQC]ZPQL)*;-4Ig*Gusursrtswuu) '7) 9<9+_R[S_]^XZSaCRuCTPOECoochhmioncj^MAIxEAI =;>(0%0:writeu16OTYHzX%#($'/ 8%%;0=8.+0#eeST^_B83?u)ZT57:8WKs';&06< writeu8!<21768bE^^Y^WP@QJSW,;-+3;BEPEDB&568.:AV@F^Vreadu8'*$05!&,-0;47;32?-#)YLQS^59,;0HSYZ[>jm\r\148+o*Xa\178M\247\22`\208!$7&\242 \176j+L\182\t\31\3\164\129\242.\230\172\29\174\222[\190;\186\197\207\r\214\220\247\138T,\n\147m\2\162\201\axV\152l\19\183\239\220|band-(;*\178\217\f\1982=:0F\136g\173;\\\189\183N\0b\242[&\185\246gW\188\166\253\133\r\210FAI@\222A\190\132\214\201\187\219\229\29\0033Zb\247\222VQ@@\4j\179\\\204J\221gOH@I\165\228\191\159\241g\187\209\255\255\255\255?6\14\235\232\163\214\2143%-0\2160e\133\235\228\221m\238\210\r\215\199\222$\3\22a\208\191\186Q\t\153\171\29a\193n\131\218\0311\207\208\181G\212\4K\206Q\181:\6q\219\1I-\218\21)W\222T6\226hR\193\244\b\130\230Z\b\136\2\27h]\183\166\128\246h\242\1\30\140\179a\203^\16iL/49(\250\168\1815\182\179\191\1548\27\182\f6'*4\188 \210\152?:4DO]83!QHJ!. 5GVmo\255}\30r&ROd\31\4wZH8n*\255A}\\\vM",
    406,
    "8?'0=85q0#6$<4?%qr`q%>qv<06?8%$54vqty'42%>#q4)!42%45}q6>%qyt&zxtx@)1q_PtQm34,;63>z;(=/7?4.zykz.5z}=?.<?4,}zr6?,?6z7/).z8?z454w4?=;.3,?s:5917588t' 57?\v'=.1t9='95 7<?M]fm:[dE@!m-_@dEw(e-{t#/?%<..8)49grreenijielmnO?ADE@tja^kwGPTIA2qd*@_bbE'!2#s%2!:21?6s'2>#6!67Ai;-EislqNd6X2}fQ.Ob{znb.+}MK@Kj\\OYMOBBmA[@Z8(6yCHz^llq9b=,UfFxja(UFqvk93#9 22$5(%{nnyutsyyprrpsqpwq}wgulUMnL8-YM^R2(\3&&/-+&j+99/>2Q_y@TS^05/Kv4q%FYOzTX8zfuHD_I_\v),,%$`%22/2`4(2%!$P}_SMMSRanhe*6eqjdY^BY?+jALH]\t|`\tr\24t8+mEKk:QUHKEB-n6Dtidc3qg!TsyB*tqqspupsxsP*;o0(o&Uxoj;oQO/sC?[I&gPh&jr++|QUF@VQU@`]YQyGAv)cv/5{3[1F9E)hkX^EIL9SBbdFWwLWBOnFNLQZvPBDFnA\3KLLHW?.GA2^++;1{4i&6,5''1 n{{z\23,\02357<1^Q({P#RYme)5xwo_y0p:wX_UbTCGXRTexeUZ%Fe@Q)/D-%Fr4kmQ_=-?{WbNOODBU^}fmhmPr5fP7&40R06zkk8!f]tz5hG&_YF@]@B-.f3lHiM*-l}IN3[%gF%.mu;$$yJ)RJ\14!:-\27-:>-:h&)%-+)$$h ''#h`=&8)+#a+TY8HEEJIHLJIa}wZz*6T9H,XmG}NS1dM4B[bPdO[SQPUUTTZQV[RRPVH4XN$lr$Bezq*yW0}^^X@YlnjklkmnmoJB-V$:hO:Z4hgjxs84e7MT^MEnNBW@KOWEyb](C8NDWD/W[E7oj/TWga&Jjd9xlII@BDI\5DVV@QJ]5bg^/Lb3C=KR}R^-gs(I6;:1+69&:':<*+0-nlxf@LUYBsV:+GY-[m6hJ[|J]YFLJcF__WeHV3IRZ6oS+dU#NLCPg/BGCEFFCNOEI{G?yDf}8YvQQln?gom)=Wwd4\3&&/-+&j+99/>nKH^w,HjgwQ/EkpMMO+lm[^]ZYXV^^]]$#{=+:(s=Ze&F3_fp*QGd(3tBJWeLQ`KJOGG.[p*:j7qNyXw}wKL7RRrT<;.,$o 9*=)# 8)Td)@(Q*gS)K4N-co*aJ)9#:((>/2?attmnlbjkmiih*}h3eCSWUX487!)7I4H9Ues[_6bKJgtOvk{k*J^qi?7n@MOG@E_XIH\f_I^ZEOI{hBtONJ{CTh?RC]FHF^jc,[gRkLln!HQa1b5oBW}=]mky*v#&5$Lm6g+.jOldAQGjSwYe]l$L]OSwHP:'VH?I9+/I}&X1bc5HuOp@]k+YpWR%9E\riv7xiv x\26=0<>#?6'6e=0D}IkZ![mUiTL@ONHErU@UDuXQD!M0=Q/8i4%8Ck;EBJCZEpt8+NFs0{^Yft$Zu6{!ZS_SUg[[_hJ[\15CJNDc::Q]=SK;UXkrQ-tI(X[Y]ZP^Y[Po8ZSHNsaazf^T;cxtqmO|~x}|x~{x}|&w6$sU;,z2eK[#mcnt\30;;206;w6$$2#W^;[X,yI1;iUr(s;fDUuNU@MlDLNSXtR@FDlCZ=yJeWh!3#9 22$5(%{nnpsyuswtqsvqptupvj\17gwQJBMDOF`LVMW20PNuuc@zsqkWWSdFWkIweB/PGS)BanV{59vsTHIRPov%P^)5XHO7mfRy:0sO!9nJd9%&8#29.05:Z+Bi/u69iz(R;qYF*&3$/?$^_w-&7i!I%?+NBksYRv!CESGLEX6@FgS)DK_OT=L:(M^LZw1)96'#.,l;fAcW5hTXh-yDGHZwN_HLYHv?Mfz,@@2Q%zWy4izaxe|RNdNDCRZb~\23l\5j$YG;GnVOp@gh_T^_H}jo|H[W_nSW_g[=9K.OHOZONHgvudLyR=ePyon@JN@R7\028990249u4&&0!B)WBC)g6[VEBec`gm`aaclb2LoG5@F=]93Cf^BZDU@Z_/_1&!0eL=B&QPx4NK@R}u^96]P285*F-2)&T(X*k][MJ]\24|]@;orY53m]q/w4NwUDcUBFYSUqY9HF8:!dSSn@\0%%,.(%i(::,=@Zo(.?4PU%dAAHJLA\rL^^HYTzJgOzt%c)\01966?=;6z;))?.*+J+keogjTLHX^Q}S1M,1d9T;d@$h&+\n-5,(&\16&15&1c&11,1c`rdAAHJLA\rL^^HY9/HywVBKkkZQC]ZPQLoFAt-Ify^Hrx^HHNXXZhn${HBp1FSHr*#(;3I!p/9YV{Y6g[{NRAKHPFGT@14Fb]cVLQCPoiD^Y_DOXYHIjL@HyD@HcU]@qS{?j2vo){D?$@^}KC^$w}@x]dnIL!BG4dzzKDH@FDII\5HLVHDQFMkSBHRXHi^X^RM^pYKH~]UaW@D[QWC.P0mDdL\b--$& -a 22$5l(J9]eUSXSrDWAUWZZuYCXBkmhnckojohkT3b/UOa}\ap`F]UZSXQw[AZ@qm\23``VESGEHHgKQJPXUM]8WXm*C}Jd$b=Q9+!7!DeG@-xv:H[==4?=d.tJM.+K,6-FOBCHRO@_C^CESRITsVCVeRTR^AR|UGD^^^][X[XVZ]Z[[V@@GIBHBHIFCFEHDdgmbgfdecm`g`afx@Q[AK[{MFLcJX[gfegeb``fgdeaonoonfnmifgjlnnfh}JB@[JiZAL[F@AbjmcnhjljiknikmO^dO^]EXAzCDMnmkoajhlnllikoz__VTR_\19R@@VGyyOHBC^w{7+$7~[[RPV[\23VDDRC\028990249u4&&0!vSSZX^S\31^LLZKlII@BDI\5DVV@Q\029881358t5''1 \30;;206;w6$$2#\b--$& -a 22$5tHEGArAVWMKJ!#2 #(0f.))-bGRGuCHBmDVUiUUQfDU`RXOBvWJ\18wJB^]@W@UUM[OKHUnA2mBO]]`OCK4uaBNLA}ALTH_BEDFFAKJJAA]__Z_]^]ZXY~UHDy^DUWUBiFAK|J]YFLJb@QcPIIkDH@gHOErDSWHBD|TBBPVTeHATonimjgknmngAME@GBALEFqsquuwrwtvyyRIURTOHA|WJF|G_PW@fromstringcAPwAVRMGA%'6%',49XKegafa`glcghOTi_HLSY_=)6?2..6- -?<65'80QMCELQQLECL@HNLAALYLTCXWZwriteu32WUGY_@UC?=,?=6.72;=??7rQY\29yXEiEDDOI^@DUWJIZQT@U@^TwLQBBHA@QFBWFlshiftAO]S[Kgmatch,+-618:*; 9=concat&(39&<0&>!~YLY^jH_DYJM@_I!\223\219\v0\147\179S\20z\184\226P\239\159x\170A\2'O\\\1\20\187\rj\127\175w\210\157m\196\209\164\219wn>\153\149\186\207]KC^(' *CDLE\132;d\148.<4!W\148\179\17H^VK\225w\176o}\212\218\26A\165\223J\139\158\217,\26\131f\188$+,&9</>Zz\218\16<q\5P\212\145\167\250\150eO\155iHr\31\192\168kd \131\184\237\177\218&\6%vr\27\145\29\191\144\213\142\176`\237\149\6l\177\158\a}\144A\220vVY^T]Wb\247\182\251\179\230\209\228\3<\142\168\t\150`z\4A@\249\188\172l\152\178B\30\233\213\224\24\152\14\225\158\184\2(\214Lr\28\31\175w\23i\174b\248K6\178H\129|\143\240\228A`\213\134 \f\201\234\184\190\139)?7*8\132\23\227\1\182\v\6pj\15\255(\v\189\178R]ZP\245\30u\232\149w\f\204/8;7\201|\r\221\185\22\2\"\19W\0\5_L\n\170\181\244\180!I@KT]V?5!AM\5\21\f5IX:pB.\128x\6S[JS@\25j(kLiQ\16t\21",
    12,
    3143,
    5381,
    3465,
    2941,
    1067,
    3564,
    350,
    306,
    73,
    3396,
    3060,
    2095,
    167,
    1540483477,
    26,
    136,
    3242,
    3141,
    3541,
    3337,
    2867,
    2641,
    310,
    3488,
    1205,
    282,
    998,
    3091,
    3179,
    1702,
    3204,
    88,
    284,
    2460,
    247,
    3576,
    3501,
    3636,
    5316,
    1819,
    1402,
    3189,
    3170,
    317,
    2367,
    298,
    3153,
    3326,
    3509,
    1033,
    55,
    292,
    2720,
    937,
    3647,
    63,
    3516,
    307,
    353,
    "number",
    "\0220#!'.'11b'00-0b&'6'!6'&iy",
    252,
    3585,
    113,
    3504,
    412,
    101,
    1526,
    2995,
    3050,
    3283,
    311,
    3908,
    235,
    665,
    545,
    227,
    3,
    244,
    97,
    3545,
    2611,
    3553,
    2514,
    2019,
    1434,
    127,
    2630,
    126,
    3642,
    277,
    3638,
    2181,
    2089,
    425,
    2890,
    2802,
    3493,
    3381,
    274,
    60,
    3019,
    2513,
    2548,
    3388,
    3348,
    100,
    3027,
    335,
    3646,
    153,
    function(list2) -- line 2360 · shares: [1] num, [2] v22, [3] callback4, [4] callback6, [5] callback5, [6] tbl3, [7] v26, [8] v5, [9] list, [10] v18
        if not num then
            num = {
                v22,
                "}\228\134\227",
                callback4,
                callback6,
                callback5,
                tbl3,
                v26,
                v5,
                "qi·",
                list2,
            }
        end

        local count, v, v2, v3
        local xored
        xored = list[178]

        while true do
            xored = bit32.bxor(xored, list[119])

            if xored < 5268 then
                if xored < 3717 then
                    return
                elseif xored < 5265 then
                    if xored < 5264 then
                        return
                    end

                    return v2
                elseif xored < 5266 then
                    xored = list[221]
                else
                    xored = if xored < 5267 then list[532] else list[307]
                end
            elseif xored < 5277 then
                if xored < 5270 then
                    if xored < 5269 then
                        v3 = string[list[10](v22, list[1005], list[1002])](list2, v)
                        v2 = callback4(callback6(v2, buffer.readu8(v5, list[509])), tbl3[callback4(callback5(v2, buffer.readu8(v18, list[875])), v3) + buffer.readu8(v5, list[642])])

                        v += buffer.readu8(v5, list[642])
                        count -= buffer.readu8(v5, list[642])
                        xored = list[1092]
                    else
                        v2 += buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083])
                        xored = list[1002]
                    end
                elseif xored < 5271 then
                    return
                elseif xored < 5276 then
                    if xored ~= 5271 then break end
                    v2 = callback4(v2, buffer.readu32(v18, list[552]))
                    xored = if v2 < buffer.readu8(v26, list[1083]) then list[33] else list[1002]
                else
                    xored = if count > buffer.readu8(v26, list[1083]) then list[801] else list[114]
                end
            else
                if not (xored < 11904 and xored < 5583) or xored ~= 5277 then break end

                count = #list2
                v = buffer.readu8(v5, list[642])
                v2 = buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083]) - buffer.readu8(v5, list[642])
                xored = list[221]
            end
        end
    end,
    422,
    2953,
    376,
    1410,
    340,
    2838,
    1615,
    "Connect",
    2642,
    3206,
    3008,
    "mBYNxNY]NYb&-AH8hXqf]3@-BQ+^=w)5^_#",
    3658,
    2893,
    3365,
    2812,
    409,
    3540,
    1924,
    "fromstring",
    2159,
    game,
    3609,
    function(arg1, arg2, arg3, arg4, arg5) -- line 2455 · shares: [1] num, [2] v22, [3] callback11, [4] v18, [5] list, [6] v23, [7] v5, [8] v26
        if not num then
            num = {
                v22,
                callback11,
                "qi·",
                v18,
                num,
                1474981348,
                "}\228\134\227",
                list,
                v23,
                v5,
                arg1,
                arg2,
                arg3,
                arg4,
                arg5,
            }
        end

        local tbl, v, v2, v3, v4, v6, v7, v8
        local xored
        xored = list[list[819]]

        while true do
            xored = bit32.bxor(xored, list[list[1]])

            if xored < 5815 then
                if xored < 5811 then
                    if xored < 5809 then
                        if xored < 5808 then
                            return
                        end

                        v8 = v7
                        tbl[v8] = v
                        xored = list[532]
                    elseif xored < 5810 then
                        v = callback11(arg1, buffer.readu8(v26, list[1083]), buffer.readu8(v18, list[875]))
                        xored = if arg2 then list[list[378]] else list[1002]
                    else
                        return tbl
                    end
                elseif xored < 5813 then
                    if xored < 5812 then
                        v6 += list[list[885]]
                        xored = list[list[512]]
                    else
                        xored = if arg3 then list[list[267]] else list[801]
                    end
                elseif xored < 5814 then
                    v7 = v6
                    xored = list[list[885]]
                else
                    tbl = {}
                    v = buffer.readu8(v5, list[642])
                    v2 = buffer.readu8(v23, list[789])
                    v6 = v
                    v3 = v2
                    xored = list[list[512]]
                end
            else
                if not (xored < 8384) then break end
                if xored < 5817 then
                    if xored < 5816 then
                        v8 = v7
                        v2 = bit32[list[list[708]](v18, list[959], list[1002])](bit32[list[list[708]](v26, list[list[710]], list[list[819]])](arg2, (v8 - buffer.readu8(v5, list[642])) * buffer.readu8(v26, list[list[738]])), buffer.readu8(v18, list[875]))

                        v = bit32[list[list[708]](v22, list[671], list[1002])](v, v2)
                        xored = list[1002]
                    else
                        xored = if v6 <= v3 then list[1092] else list[935]
                    end
                else
                    if not (xored < 5818) then break end
                    v8 = v7
                    v = bit32[list[list[708]](v22, list[671], list[1002])](v, arg3[v8])
                    xored = list[801]
                end
            end
        end
    end,
    304,
    3198,
    3360,
    3336,
    388,
    3444,
    407,
    3404,
    3500,
    function(arg1) -- line 2537 · shares: [1] num, [2] v26, [3] v22, [4] callback11, [5] v18, [6] list, [7] v14, [8] v5
        if not num then
            num = {
                v26,
                v22,
                1474981348,
                callback11,
                num,
                v18,
                list,
                "qi·",
                v14,
                v5,
                "}\228\134\227",
                arg1,
            }
        end

        local str, v, v2, v3, v4, v6, v7, v8
        local xored
        xored = list[532]

        while true do
            xored = bit32.bxor(xored, list[361])

            if xored < 1687 then
                if xored < 1683 then
                    if xored < 1680 then
                        return
                    elseif not (xored < 1681) then
                        break
                    else
                        str ..= string[list[10](v22, list[999], list[1002])](callback11(v14, buffer.readu8(v5, list[1083]), buffer.readu8(v18, list[875])))

                        xored = list[33]
                    end
                elseif xored < 1685 then
                    if xored < 1684 then
                        xored = if v6 <= v3 then list[801] else list[935]
                    else
                        v6 += list[33]
                        xored = list[114]
                    end
                elseif xored < 1686 then
                    v7 = v6
                    xored = list[1092]
                else
                    str = list[188](list[10](v26, list[488], list[221]), buffer.readu8(v22, list[990]), buffer.readu8(v26, list[546]))

                    v = buffer.readu8(v5, list[642])
                    v2 = buffer.readu8(v26, list[509])
                    v6 = v
                    v3 = v2
                    xored = list[114]
                end
            else
                if not (xored < 8350 and xored < 4663 and xored < 3050) or xored ~= 1687 then break end

                return str
            end
        end
    end,
    3385,
    254,
    1673,
    2312,
    3449,
    3243,
    3150,
    3612,
    268,
    411,
    160,
    3456,
    3640,
    1078,
    3327,
    257,
    240,
    1872,
    2983,
    2349,
    2113,
    3533,
    3524,
    3589,
    1943,
    200,
    2927,
    109,
    61,
    165,
    3525,
    2158,
    116,
    278,
    2986,
    226,
    329,
    3318,
    44,
    3556,
    172,
    3655,
    2973,
    13996,
    3071,
    3476,
    332,
    1370,
    function() -- line 2652 · shares: [1] num, [2] v, [3] callback3, [4] v23, [5] v26, [6] v22, [7] v20, [8] list, [9] callback9, [10] v5, [11] v18
        if not num then
            num = {
                "qi·",
                v,
                callback3,
                1474981348,
                "}\228\134\227",
                v23,
                v26,
                v22,
                num,
                v20,
            }
        end

        local flag, list2, count, v2, v3, str, v4, v6, v7, v8, v9, v10, v11, v12, v13, v14
        local xored
        xored = list[712]

        while true do
            xored = bit32.bxor(xored, list[list[255]])

            if xored < 3478 then
                if xored < 3467 then
                    if xored < 3461 then
                        if xored < 3458 then
                            if xored < 3457 then
                                if xored ~= 3456 then break end
                                xored = if list2 then list[885] else list[738]
                            else
                                xored = if flag then list[list[378]] else list[list[138]]
                            end
                        elseif xored < 3459 then
                            count = list2
                            v9 = v8
                            callback9(list[698](list[list[708]](v26, list[list[295]], list[list[105]]), buffer.readu8(v26, list[654])), {count})

                            xored = list[list[633]]
                        elseif xored < 3460 then
                            xored = list[list[633]]
                        else
                            list2 = callback3(count)
                            xored = list[650]
                        end
                    elseif xored < 3464 then
                        if xored < 3462 then
                            v9 = v8

                            return (list[list[737]](list[list[708]](v5, list[522], list[list[239]]), buffer.readu8(v23, list[642]), buffer.readu8(v18, list[990])))
                        end

                        if xored < 3463 then
                            flag = not list[list[1049]](debug[list[698](list[list[708]](v18, list[list[966]], list[1002]), buffer.readu8(v18, list[list[549]]))](buffer.readu8(v5, list[list[738]]), (list[list[737]](list[list[708]](v18, list[954], list[691]), buffer.readu8(v22, list[list[549]]), buffer.readu8(v26, list[list[305]])))), buffer.readu8(v5, list[list[738]]), buffer.readu32(v22, list[874]))

                            xored = if flag then list[list[62]] else list[list[885]]
                        else
                            v9 = v8
                            list2 = count[list[list[737]](list[list[708]](v26, list[list[983]], list[738]), buffer.readu8(v23, list[list[286]]), buffer.readu8(v23, list[861]))]

                            xored = list[list[796]]
                        end
                    elseif xored < 3465 then
                        v7 += list[list[885]]
                        xored = list[list[267]]
                    elseif xored < 3466 then
                        list2 = str
                        xored = list[650]
                    else
                        v9 = v8

                        list2 = {
                            debug[list[698](list[list[708]](v22, list[list[516]], list[1002]), buffer.readu8(v23, list[1120]))](v9, (list[list[737]](list[list[708]](v26, list[list[506]], list[708]), buffer.readu8(v26, list[789]), buffer.readu8(v5, list[990])))),
                        }

                        count = #list2
                        v2 = buffer.readu8(v5, list[642])
                        v12 = v2
                        v10 = count
                        xored = list[801]
                    end
                elseif xored < 3472 then
                    if xored < 3469 then
                        if xored < 3468 then
                            xored = list[1002]
                        else
                            v9 = v8
                            flag[v9] = table[list[list[708]](v23, list[946], list[list[819]])](list2, (list[698](list[list[708]](v26, list[969], list[801]), buffer.readu8(v18, list[897]))))

                            list2, count = v(getfenv, v9)
                            list2 = count[list[list[737]](list[list[708]](v26, list[835], list[list[378]]), buffer.readu8(v26, list[897]), buffer.readu8(v26, list[1083]))]

                            xored = if list2 then list[list[796]] else list[978]
                        end
                    elseif xored < 3470 then
                        xored = list[708]
                    elseif xored < 3471 then
                        v12 += list[list[885]]
                        xored = list[801]
                    else
                        v13 = v12
                        xored = list[935]
                    end
                elseif xored < 3475 then
                    if xored < 3473 then
                        v14 = v13
                        list2[v14] = tostring(list2[v14])
                        xored = list[656]
                    elseif xored < 3474 then
                        list2 = nil
                        xored = list[732]
                    else
                        xored = if v12 <= v10 then list[list[227]] else list[list[239]]
                    end
                elseif xored < 3476 then
                    list2 = debug[list[list[737]](list[list[708]](v26, list[576], list[list[512]]), buffer.readu8(v22, list[1120]), buffer.readu8(v18, list[938]))](buffer.readu8(v5, list[list[738]]), (list[698](list[list[708]](v22, list[866], list[list[885]]), buffer.readu8(v5, list[613]))))

                    flag = list[list[1049]](list2[list[list[737]](list[list[708]](v5, list[849], list[1037]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v18, list[list[305]]))](list2, buffer.readu8(v5, list[642]), buffer.readu8(v5, list[642])), buffer.readu8(v5, list[642]), buffer.readu32(v5, list[862]))

                    xored = list[list[62]]
                else
                    if xored < 3477 then
                        return
                    end

                    callback9(list[list[737]](list[list[708]](v26, list[list[211]], list[931]), buffer.readu8(v18, list[861]), buffer.readu8(v22, list[544])), {
                        debug[list[list[737]](list[list[708]](v18, list[479], list[885]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v5, list[579]))](buffer.readu8(v5, list[list[738]]), (list[698](list[list[708]](v22, list[613], list[list[885]]), buffer.readu8(v26, list[654])))),
                    })

                    xored = list[list[138]]
                end
            elseif xored < 3505 then
                if xored < 3483 then
                    if xored < 3480 then
                        if xored < 3479 then
                            xored = list[650]
                        else
                            v8 = v7
                            xored = list[793]
                        end
                    elseif xored < 3481 then
                        v9 = v8
                        xored = if v2[list[698](list[list[708]](v26, list[667], list[list[1043]]), buffer.readu8(v22, list[654]))] then list[list[512]] else list[list[105]]
                    elseif xored < 3482 then
                        v9 = v8

                        count, list2 = debug[list[list[737]](list[list[708]](v26, list[921], list[list[819]]), buffer.readu8(v26, list[897]), buffer.readu8(v26, list[list[738]]))](v9, (list[698](list[list[708]](v18, list[972], list[935]), buffer.readu8(v26, list[897]))))
                        xored = if not count then list[list[1074]] else list[list[1088]]
                    else
                        v9 = v8

                        v3, count = v2[list[698](list[list[708]](v18, list[558], list[list[1043]]), buffer.readu8(v22, list[list[549]]))]()

                        str = v3 .. list[list[737]](list[list[708]](v5, list[1086], list[532]), buffer.readu8(v22, list[990]), buffer.readu8(v26, list[list[738]])) .. count
                        xored = list[691]
                    end
                elseif xored < 3486 then
                    if xored < 3484 then
                        xored = if v7 <= v4 then list[1092] else list[list[633]]
                    elseif xored < 3485 then
                        xored = list[list[1043]]
                    else
                        v9 = v8
                        count = list[698](list[list[708]](v22, list[list[1038]], list[list[1043]]), buffer.readu8(v26, list[1057]))
                        xored = list[list[543]]
                    end
                elseif xored < 3487 then
                    xored = list[1002]
                elseif xored < 3504 then
                    if xored ~= 3487 then break end
                    v2 = count
                    xored = list[list[469]]
                else
                    xored = list[469]
                end
            else
                if not (xored < 3758) then break end
                if xored < 3507 then
                    if xored < 3506 then
                        xored = if list2 then list[list[798]] else list[list[304]]
                    else
                        flag = list[709][list[list[737]](list[list[708]](v5, list[702], list[726]), buffer.readu8(v23, list[613]), buffer.readu8(v18, list[list[305]]))]()
                        flag = {}
                        list2 = buffer.readu8(v5, list[642])
                        count = buffer.readu8(v26, list[509])
                        v7 = list2
                        v4 = count
                        xored = list[list[267]]
                    end
                elseif xored < 3510 then
                    if xored ~= 3507 then break end
                    xored = if list2 then list[532] else list[1037]
                elseif xored < 3511 then
                    v9 = v8
                    list2 = count[list[list[737]](list[list[708]](v5, list[list[950]], list[1088]), buffer.readu8(v5, list[654]), buffer.readu8(v18, list[list[738]]))]

                    xored = list[list[798]]
                else
                    if xored ~= 3511 then break end
                    v9 = v8
                    list2 = count[list[list[737]](list[list[708]](v18, list[1009], list[454]), buffer.readu8(v26, list[789]), buffer.readu8(v22, list[list[741]]))]

                    xored = list[885]
                end
            end
        end
    end,
    14,
    2994,
    973,
    308,
    3654,
    3289,
    28,
    336,
    38,
    854,
    516,
    344,
    177,
    3605,
    3617,
    3405,
    2926,
    2599,
    2368,
    1999,
    299,
    3508,
    1737,
    2534,
    1304,
    225,
    333,
    3584,
    3257,
    3648,
    557,
    183,
    2716,
    2970,
    2657,
    11995,
    752,
    2442,
    3624,
    3353,
    function(arg1) -- line 2982 · shares: [1] num, [2] v23, [3] list, [4] v18, [5] v26, [6] v22, [7] v5
        if not num then
            num = {
                v23,
                list,
                num,
                v18,
                "}\228\134\227",
                "qi·",
                v26,
                1474981348,
                v22,
                arg1,
            }
        end

        local v = list[709][list[list[737]](list[list[708]](v5, list[list[596]], list[list[378]]), buffer.readu8(v22, list[972]), buffer.readu8(v5, list[642]))](arg1)

        list[709][list[list[737]](list[list[708]](v18, list[1074], list[738]), buffer.readu8(v26, list[list[549]]), buffer.readu8(v18, list[list[305]]))](v)

        return (list[list[1049]](list[709][list[698](list[list[708]](v5, list[815], list[list[819]]), buffer.readu8(v5, list[875]))](v), buffer.readu8(v22, list[list[741]]), buffer.readu32(v18, list[856])))
    end,
    27,
    1701,
    2497,
    356,
    1586,
    219,
    3620,
    function(list, arg2) -- line 3011
        local v = buffer.fromstring(list)
        local count = #list
        local v2 = arg2 * 16843009
        local count2 = 0

        while count2 <= count - 4 do
            buffer.writeu32(v, count2, bit32.bxor(buffer.readu32(v, count2), v2))
            count2 += 4
        end

        while count2 < count do
            buffer.writeu8(v, count2, bit32.bxor(buffer.readu8(v, count2), arg2))
            count2 += 1
        end

        return buffer.tostring(v)
    end,
    2596,
    80,
    300,
    742,
    29,
    2042,
    397,
    1556,
    3633,
    10,
    coroutine,
    358,
    864,
    20,
    3457,
    181,
    286,
    buffer.fromstring,
    3393,
    122,
    3322,
    3597,
    3440,
    351,
    3420,
    3492,
    13444,
    141,
    343,
    382,
    3039,
    unpack,
    41,
    13,
    3421,
    3425,
    2424,
    2951,
    188,
    37,
    function(arg1, arg2) -- line 3074 · shares: [1] num, [2] callback9, [3] v3, [4] list, [5] v23, [6] v17, [7] v5, [8] v22, [9] v26, [10] callback3, [11] v18
        if not num then
            num = {
                callback9,
                v3,
                list,
                num,
                v23,
                v17,
                1474981348,
                v5,
                v22,
                v26,
                callback3,
                arg1,
                arg2,
            }
        end

        local v, fn, v2, flag, v4, v6
        local xored
        xored = list[801]

        while true do
            xored = bit32.bxor(xored, list[1011])

            if not (xored < 9858) then break end
            if xored < 6286 then
                return
            elseif not (xored < 8849) then
                break
            elseif xored < 6287 then
                return
            elseif xored ~= 6287 then
                break
            else
                local v8 = list[588]
                v = v8[list[698](list[list[708]](v23, list[448], list[708]), buffer.readu8(v22, list[list[923]]))](v8, callback3((list[list[737]](list[list[708]](v5, list[1129], list[list[227]]), buffer.readu8(v23, list[list[923]]), buffer.readu8(v22, list[544])))))

                fn = function(arg1, arg2) -- line 3104 · shares: [1] v23, [2] v22, [3] v5, [4] v3, [5] list, [6] v26, [7] callback3, [8] callback9
                    if not arg2 then
                        ({})[1] = v23;
                        ({})[2] = v22;
                        ({})[3] = v5;
                        ({})[4] = v3;
                        ({})[5] = list;
                        ({})[6] = v26;
                        ({})[7] = callback3;
                        ({})[8] = arg1;
                        ({})[9] = arg2
                    end

                    local xored
                    xored = list[list[885]]

                    while true do
                        xored = bit32.bxor(xored, list[493])

                        if xored < 5317 then
                            return
                        elseif xored < 5319 then
                            if xored < 5318 then
                                local v2 = arg1[list[list[737]](list[list[708]](v23, list[list[563]], list[793]), buffer.readu8(v23, list[list[286]]), buffer.readu8(v26, list[list[738]]))]

                                xored = if v2 == callback3((list[698](list[list[708]](v23, list[502], list[1092]), buffer.readu8(v22, list[897])))) then list[532] else list[935]
                            else
                                xored = list[801]
                            end
                        else
                            if not (xored < 9591) or xored ~= 5319 then break end

                            callback9(list[698](list[list[708]](v22, list[1053], list[732]), buffer.readu8(v5, list[list[923]])), {v3(arg1)})

                            xored = list[935]
                        end
                    end
                end
                flag = false

                for key, value in v[list[list[737]](list[list[708]](v26, list[765], list[list[1043]]), buffer.readu8(v5, list[613]), buffer.readu8(v5, list[990]))](v) do
                    v4 = key
                    v6 = value
                    local v14 = v4
                    local v15 = v6
                    local v16
                    v16 = list[801]

                    while true do
                        if v16 < 1 then
                            list[list[1096]][list[698](list[list[708]](v5, list[list[662]], list[1092]), buffer.readu8(v22, list[972]))](fn, v15)
                            v16 = list[935]
                        else
                            if not (v16 < 2) then break end
                            flag = true
                            v16 = list[935]
                        end
                    end

                    if flag then break end
                end

                v17(v[callback3((list[list[737]](list[list[708]](v26, list[680], list[731]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v18, list[list[305]]))))], fn)

                xored = list[list[885]]
            end
        end
    end,
    586,
    312,
    3070,
    92,
    3270,
    2446,
    383,
    140,
    3557,
    3160,
    2687,
    3332,
    3548,
    3269,
    function() -- line 3225 · shares: [1] num, [2] v18, [3] v22, [4] list, [5] v5, [6] callback9
        if not num then
            num = {
                "qi·",
                v18,
                num,
                1474981348,
                v22,
                list,
                v5,
                "}\228\134\227",
            }
        end

        callback9((list[698](list[list[708]](v18, list[914], list[list[633]]), buffer.readu8(v22, list[list[832]]))))

        return (list[list[737]](list[list[708]](v22, list[974], list[list[1088]]), buffer.readu8(v5, list[list[286]]), buffer.readu8(v5, list[938])))
    end,
    157,
    1784,
    3250,
    218,
    375,
    162,
    "readstring",
    2841,
    1369,
    2135,
    2551,
    57,
    110,
    74,
    3357,
    3081,
    function() -- line 3254 · shares: [1] num, [2] v4, [3] v26, [4] v22, [5] v14, [6] v23, [7] list, [8] v5, [9] callback11
        if not num then
            num = {
                v4,
                v26,
                v22,
                num,
                v14,
                v23,
                list,
                "qi·",
                v5,
                callback11,
                1474981348,
            }
        end

        local v, str, v2, v3, v6, v7, v8, v9, v10
        local xored
        xored = list[114]

        while true do
            xored = bit32.bxor(xored, list[236])

            if xored < 4300 then
                if xored < 2225 then
                    return
                elseif xored < 4296 then
                    return
                elseif xored < 4297 then
                    v9 = v8
                    xored = list[801]
                elseif xored < 4299 then
                    if xored ~= 4297 then break end
                    xored = if v8 <= v6 then list[1092] else list[935]
                else
                    v = v4(v14)
                    str = list[698](list[10](v26, list[969], list[801]), buffer.readu8(v5, list[789]))
                    v2 = callback11(v, buffer.readu8(v5, list[509]), buffer.readu8(v23, list[789]))
                    v3 = buffer.readu8(v5, list[642])
                    v8 = v3
                    v6 = v2
                    xored = list[1002]
                end
            else
                if not (xored < 9281) then break end
                if xored < 4302 then
                    if xored < 4301 then
                        v8 += list[33]
                        xored = list[1002]
                    else
                        str ..= string[list[10](v22, list[999], list[1002])](callback11(v, buffer.readu8(v5, list[1083]), buffer.readu8(v26, list[492])))

                        xored = list[33]
                    end
                elseif xored < 4303 then
                    return
                elseif not (xored < 8526) or xored ~= 4303 then
                    break
                else
                    return str
                end
            end
        end
    end,
    52,
    2915,
    230,
    3090,
    251,
    2580,
    1968,
    3205,
    3307,
    2972,
    185,
    505,
    264,
    184,
    123,
    5489,
    288,
    3660,
    2461,
    3593,
    77,
    11,
    362,
    2627,
    276,
    "70(?27:~?,9+3;0*~}o~*1~y3?907*+:;y~{v(;=*1,~;&.;=*;:r~91*~v{)uw{wfg&%+eBWBE\24qSBbYBWZ{S[YDOcEWQS{T\22O_SZR4:QMksFZzrDc](uiE2$-_}/=.B:7Z[)9#:((>/2?attobjbjockhc$3KHJ)[&(USO:]D%{sLYYAJR}Opf^\b>8.)>{?>#{s9:?{>#+742/r[?Y:eX^yn4N@8GK.7z(0%H%p6h;+1(::,=sff?,%&* =0\22(::,=:bw%EMi&ct/P$wL-sWLd_wjryBKNE]YnXK]IKFFiE_D^M,qC^D.AUFU-_;H_bYd.1B(f.u\26??642?s2  6'ljyk;)]1IskZ0#25%06QI[O[.lj0^cF{^^WUS^\18SAAWFHuQJ21E1g&=utb]g_T[7;F(eiuZ=A=9lM`OJFMWfUFMWPHU]DV?p0sAZN05?J3a4v4zJq8!YL_=yBKNE]Y~XCKDMFOiE_D^sb7g[ws*8w5PT}6PAmfv}+/?%<..8)grr+8:<%\00268$s)%)!;Ej[s+!la35[GG2I\r((!#%(d%77!0&SNlXF?plDGEF.i%7A}LU4o%O6x3wXCTbTCGTC\17HXT]U7X@@UScwO*-JNA1PJ}fmlb0(8?*( k$=.9-'$<kc%*&.(*''bkc.99$9k/.;?#b\28=&r3>>=%76r&=r366r&:3&r'<67 r!7&&;<5!oJJCAGJ\6GUUCRa1KxP_:S!Mj6-1hkNn%Wmug_Re@@IKM@\fM__IXl[e*JA0j8o4p,j{-(9hDUms/0YDB[@@TEQt;c=qG?KL?R^j@!?AIHB]kG%U604LNIKOOKEIHMrdrkD4$0Sa%u%*}Nd&:g3vL$kKn|xmZWR_ZORTUh^IMRX^ogh_wktDbq$7Qz%S8\28  $\0191 t815?tf64-!D$3SR@acR]rwMA1slD\1$$-/)$h);;-<%+l5*ov1PN9]0qI8GaGD?&% '208s<%6!5?<$s{=2>602??zs{!60&! 6z\3&&/-+&j+99/>GXG9$E01T$ouP]EuBl7)VA0#%2)4@4:lMa}s/tiR87g*swG38_csUho#Afdn`obnaggdacdcU}RG[Yh9y1&ScGsu]mn@psqqtwsuvqtqwqpu@zcw-3I1R_Ru^bRQ!ARMWCBCLLy);+(ANo.8^kV1_rcJeQ@a]]-[pJjML]PVWJxr1lPQ-r_4i+8K1A#n8utP0]srt{rvqttrvuzsw?QO3x;J=6h6P=@KQ$OqFSOJ@BWFGeJQPW\roL@BOp@QJSW\rb@WLQpRCdREA^TRP7rp6b;0K)5U:uhS&MOkEdSqrutuquvqyvpvssEr$!*):dxvwC#$-eLgr@@VGuVGP[`GRGF@SUWb0Wl&+:Yn.=J,LLCDLMEMA@EMAFMzn1-/ion)rLl-EHwIx\r((!#%(d%77!0Q#G4y,$:@5WP+?n:Oh,\0<<8\15-<h!;h&'<h)h>)$!,h%-%*-:h'.fg`acgnec`doeaeqx:4qsY!Mum[S?@Fb@Qv@WSLF@\5MJJN\5\rpV@Wv@QQLKBV\f9</>0CQo3Et2KcH.-[b$_vSB.+dSVt~XT\\p]M=5el:WniM3PiJVC7EzIejJVHOICOOTZUJNSu7;+o7I*2^R!B#XIEhini`ahaljmdGf7;?AMsS/9OoD(m1fDUoDUVNSJqHOFgYng+q?Ju3C0Es3qSY[SBDOni/hus1;/!N4dUnRL0dj60#2l\29\29+,&':b+,4-)'&o3wPj5uvyVMZlZMIZM3hO;tH:r-zO[H,M,6%U@CMDiVr*+5LNT!eP%u8Ol{LBm1`bbgdeafgga,yZ{A=E+$bU*R;?sCJ6wIjh;44zMVQnWck)3TL_YPt9-='>,,:+6;eppglgmhnnoimnljj\01655<>85y8**<-{8Vv$_&5xKt386'04!09Q,[4C^BVb,MQHyF]H@FYTU^DYVIUHUSED_BHS%qOi3A0*-:'(9><>.<)YrTSZ5DMrB}ZBMvTOKOROPCUeISHRJ9,g,9^X,y}_Ni_HLSY_=k=sJe.e1I/lCQf3m:}[GQ^&RhD}$l7w(dLB3vu<#)mdUb?g970&5nh:sE=ulH@dFWpFQUJ@F6ZGq1[!at)uR53#9 22$5{nn\19./(9\00491-.(53#9 22$5(%{nnuxqyuwtrpy=(+%,:i*(''&=i+,i*0*% *c^S]^IcTA]XRPETUbE^CPVT;<)<=;#G&WFyGBDXxP$-U-\3&&/-+&j+99/>br?kZ{IVspRKTSZmOTPTITKXN~RHSI-;3.v,{S7VY%$g,5}=4sQ1041;=K=DI4w=NjZ*bgN)4#6jUB2@G6{C)cjQ$bx8'7-4&&0!ozz4'2:;{@,&_Z^^S[ZY^YZ%eJOv=&47tYYZ`WZCS?j#A,fKnI;\19<'0\0060'#0'u0'':'uvguJQWVBOjMSVWnBMBDFQgHSDrDSWDS\1LHRL@UBI~IBHI^o|yj^MAIxEAIuNS@@JChB;nZlO^5LC{yy}|}{|sy|dVKu/Mc\3,+!\22 73,& e-**.ewdKGO,(z:WrpcbH,2s}m\20w[X[Fd]W_QF,rF|TBBPVTsDBbTCGXRT:838/4>}8%8>()2/r]FQgQFBQF.8!(Yt`QG@gQFB]WQ5h]E4<>5>)28{>#>8./4)fHT~T^YH@xd\rv\30pbLPzPZ]LD|`\tr\29tjikoncmljlmojllCSK^PTHF]IZX=;Mcbcb`ggkcgegcjgcaadbceaefcfekcljimdmiimnmZZ.pdF]Y]@]BQGw[AZ@_Y[[__QQPQ;9qzS[RRR]]YR[[^R^(/:80{4->)=74,jOOFDBO\3B@WLQoJJCAGJ\6GUUCR@JM[DRU9;!jMd\01877><:7{:((>/{^^WUS^\18SAAWF\25<<571<p1##5$wTXZWkWZB^I}TgBBKIOB\14O]]KZsVV_][V\26[II_N{^K^lZQ[t]OLVRWTUZVWTWSB^SNYRRB3?{.Aoo]_TUFHQ-9ksXUQD\16ey\16k\2mbgckebcebecwritestringuWFtG^^|S_Wae`eec``aiiIL@LH@NJJKHgZAGF}a\bs\26u{TSYnXOKT^X]]YF]AAGQNCf[@FG|`\tr\24tuv}ssruqssp}~zxz~x|{~njoloccnbiPVPS^TW_^VwustsypvyyQRRSSRUPPQq|tt|sw||tqVMpFQUJ@Ft_BNtOWX_Hzxz~~|y}~zKFDKHJEH]]|^Oh^IMRX^'!'$1:010C@KDKEKABWLIDBOBI(,8+;7'(\154\153\153\153\153\153\169?ANBJLNCCnELCJHIzFFBuWFsRDCEXNFZCBYQPzzLKA@]MX_HAZ_ZM^MZ[Mcreate.)/43:tRDShEfreeze 0!:#'f@LDhELKMVQXTXMZQBEONS!6#uJqFF[F '-,1\174+\177{\147\6\215\2053\212\184\232bal\28\189|\177~\244Qkk\167\255\215\194RIDU\195\239`\223\218+\r\216\160\128\184\v\235\rs:+$#)\198\217\176eJj\209\174\16\16\v\190\25\196m\a\233\255\1810MGiI\26\182s \1617\199\241\159\228a\206k\181\n\165\f\226\182\3\135|o/\231\6kn~\147\209\1618?7>c\201pG7\190\v\180Y=\209\1710?82char\t\212f\185\160\210o%\199{\232\28\156\134+\28rqg\162\1500\aw{\165\1\27j\233iC\163\149d\158\166\163\180$bxor\235\164S\1-\226\16_\2260\187\212HG@J\223:e\6\1\\c\230\220Z\214\217'\174\0\nW\196\15\245o\223\185\249\15\165\189\184\223\29\221b\129\r\180.\27\223\5Zy\190iF\255\158e\143\217l\6c\236\201e\138E\207l\22\143\244jp\31\181\182\6YTADs-\4D\127\207\178Gx\145\n\"\227l\2162byte~\143\233\2%.<DMFFM_?\31W\22N_uD$\14Y\17N\2002l,v?\t\18C\28+s^!bg\19",
    1068,
    function(arg1, list2) -- line 3342 · shares: [1] num, [2] v26, [3] v5, [4] v23, [5] list, [6] v22
        if not num then
            num = {
                1474981348,
                "}\228\134\227",
                v26,
                v5,
                "qi·",
                v23,
                num,
                list,
                v22,
                arg1,
                list2,
            }
        end

        local str, v, v2, v3, v4, v6, v7, v8
        local xored
        xored = list[935]

        while true do
            xored = bit32.bxor(xored, list[826])

            if xored < 5950 then
                if xored < 5946 then
                    if xored < 5944 then
                        return
                    elseif xored < 5945 then
                        v8 = v7
                        v = arg1[list[698](list[list[708]](v22, list[list[653]], list[1002]), buffer.readu8(v5, list[1057]))](arg1, v8)

                        str ..= string[list[list[708]](v22, list[999], list[1002])](bit32[list[list[708]](v22, list[671], list[1002])](v, list2[(v8 - buffer.readu8(v5, list[642])) % #list2 + buffer.readu8(v5, list[642])]))

                        xored = list[list[819]]
                    else
                        str = list[698](list[list[708]](v26, list[969], list[801]), buffer.readu8(v22, list[list[923]]))
                        v = arg1[list[698](list[list[708]](v5, list[list[854]], list[532]), buffer.readu8(v23, list[613]))](arg1)
                        v2 = buffer.readu8(v5, list[642])
                        v6 = v2
                        v3 = v
                        xored = list[1002]
                    end
                elseif xored < 5947 then
                    v7 = v6
                    xored = list[532]
                else
                    if xored < 5949 then
                        if xored ~= 5947 then break end
                        return str
                    end

                    v6 += list[list[885]]
                    xored = list[1002]
                end
            else
                if not (xored < 9101) then break end
                if xored < 5951 then
                    return
                elseif not (xored < 8059) or xored ~= 5951 then
                    break
                else
                    xored = if v6 <= v3 then list[list[885]] else list[801]
                end
            end
        end
    end,
    3227,
    0,
    1313,
    1433,
    246,
    354,
    "string",
    2112,
    637,
    81,
    3151,
    2962,
    309,
    320,
    139,
    3281,
    2292,
    17,
    187,
    114,
    1171,
    14820,
    330,
    function(arg1, arg2, list2, arg4, arg5, arg6) -- line 3432 · shares: [1] num, [2] v5, [3] tbl3, [4] v23, [5] callback4, [6] v25, [7] callback6, [8] v26, [9] callback5, [10] v9, [11] v18, [12] v22, [13] v10, [14] list
        if not num then
            num = {
                v5,
                tbl3,
                num,
                v23,
                callback4,
                v25,
                callback6,
                v26,
                callback5,
                v9,
                v18,
                "qi·",
                v22,
                v10,
                arg1,
                arg2,
                list2,
                arg4,
                arg5,
                arg6,
            }
        end

        local count, list3, count2, v, str, v2, v3, v4, v6, v7, v8, v11
        local xored
        xored = list[650]

        while true do
            xored = bit32.bxor(xored, list[list[498]])

            if xored < 6475 then
                if xored < 6469 then
                    if xored < 6466 then
                        if xored < 6464 then
                            return
                        elseif xored < 6465 then
                            xored = list[935]
                        else
                            v11 = v8
                            v2 = v[list[698](list[list[708]](v18, list[720], list[1002]), buffer.readu8(v18, list[1083]))](v, v11)

                            str ..= string[list[list[708]](v22, list[999], list[1002])](bit32[list[list[708]](v22, list[671], list[1002])](v2, count[(v11 - buffer.readu8(v5, list[642])) % #count + buffer.readu8(v5, list[642])]))

                            xored = list[list[1043]]
                        end
                    elseif xored < 6467 then
                        xored = list[1092]
                    elseif xored < 6468 then
                        count = nil
                        xored = list[list[798]]
                    else
                        count = str
                        xored = list[list[378]]
                    end
                elseif xored < 6472 then
                    if xored < 6470 then
                        return
                    elseif xored < 6471 then
                        xored = if v7 <= v4 then list[532] else list[708]
                    else
                        list3 = str
                        xored = list[801]
                    end
                elseif xored < 6473 then
                    str = callback4(str, buffer.readu32(v18, list[552]))
                    xored = if str < buffer.readu8(v26, list[1083]) then list[list[1074]] else list[list[267]]
                elseif xored < 6474 then
                    v = list2
                    count = v25

                    str = list[list[737]](list[list[708]](v18, list[list[276]], list[list[378]]), buffer.readu8(v23, list[642]), buffer.readu8(v26, list[list[27]]))

                    v2 = v[list[list[737]](list[list[708]](v18, list[list[894]], list[1037]), buffer.readu8(v22, list[579]), buffer.readu8(v18, list[list[305]]))](v)
                    v3 = buffer.readu8(v5, list[642])
                    v7 = v3
                    v4 = v2
                    xored = list[793]
                else
                    list3 = nil
                    count2 = count
                    xored = list[1002]
                end
            elseif xored < 6492 then
                if xored < 6478 then
                    if xored < 6476 then
                        v2 = string[list[list[708]](v22, list[1005], list[1002])](list3, v)
                        str = callback4(callback6(str, buffer.readu8(v5, list[509])), tbl3[callback4(callback5(str, buffer.readu8(v18, list[875])), v2) + buffer.readu8(v5, list[642])])

                        v += buffer.readu8(v5, list[642])
                        count2 -= buffer.readu8(v5, list[642])
                        xored = list[list[885]]
                    elseif xored < 6477 then
                        xored = list[732]
                    else
                        list2 = list3
                        count = #list2
                        buffer[list[list[708]](v18, list[496], list[list[512]])](arg1, arg2, count)
                        arg2 += buffer.readu8(v26, list[list[738]])
                        buffer[list[list[708]](v22, list[list[563]], list[793])](arg1, arg2, list2)
                        arg2 += count
                        buffer[list[list[708]](v23, list[485], list[list[512]])](arg1, arg2, count2)
                        arg2 += buffer.readu8(v18, list[938])
                        return arg2
                    end
                elseif xored < 6479 then
                    v8 = v7
                    xored = list[454]
                else
                    if not (xored < 6487) or xored ~= 6479 then break end

                    xored = if count2 > buffer.readu8(v26, list[1083]) then list[list[819]] else list[list[105]]
                end
            else
                if not (xored < 13134) then break end
                if xored < 6493 then
                    str += buffer.readu8(v26, list[list[738]]) ^ buffer.readu8(v5, list[1083])
                    xored = list[list[267]]
                elseif xored < 6495 then
                    if xored ~= 6493 then break end
                    v7 += list[list[885]]
                    xored = list[793]
                else
                    if xored ~= 6495 then break end
                    list3 = list2
                    count2 = #list3
                    v = buffer.readu8(v5, list[642])

                    str = buffer.readu8(v26, list[list[738]]) ^ buffer.readu8(v5, list[1083]) - buffer.readu8(v5, list[642])
                    xored = list[732]
                end
            end
        end
    end,
    372,
    2482,
    5947,
    2877,
    249,
    189,
    148,
    107,
    51,
    145,
    2975,
    3229,
    419,
    124,
    355,
    3521,
    "FindFirstChildWhichIsA",
    263,
    82,
    963,
    2950,
    3049,
    431,
    2902,
    3041,
    1103,
    132,
    1139,
    2479,
    1401,
    1112,
    1157,
    3581,
    1465,
    2864,
    2660,
    1865,
    3653,
    3577,
    function() -- line 3612 · shares: [1] num, [2] callback3, [3] v22, [4] v23, [5] v26, [6] callback9, [7] v18, [8] v24, [9] list, [10] v5, [11] v11
        if not num then
            num = {
                1474981348,
                callback3,
                "qi·",
                v22,
                v23,
                v26,
                callback9,
                v18,
                v24,
                "}\228\134\227",
            }
        end

        local v, v2, v3, flag
        local xored
        xored = list[list[267]]

        while true do
            xored = bit32.bxor(xored, list[1048])

            if xored < 5514 then
                if xored < 5507 then
                    if xored < 5232 then
                        return
                    elseif xored < 5505 then
                        if xored < 5504 then
                            return
                        end

                        flag = v3[list[698](list[list[708]](v22, list[879], list[1002]), buffer.readu8(v18, list[list[27]]))](v3, callback3((list[698](list[list[708]](v22, list[list[842]], list[885]), buffer.readu8(v5, list[list[923]])))), buffer.readu8(v5, list[642]), true)

                        xored = if flag then list[list[378]] else list[732]
                    elseif xored < 5506 then
                        xored = list[1092]
                    else
                        callback9(list[list[737]](list[list[708]](v18, list[1013], list[931]), buffer.readu8(v26, list[789]), buffer.readu8(v23, list[1083])), {v3})

                        xored = list[532]
                    end
                elseif xored < 5510 then
                    if xored < 5508 then
                        v = v11[callback3((list[698](list[list[708]](v26, list[list[75]], list[708]), buffer.readu8(v18, list[654]))))]

                        xored = list[list[1043]]
                    elseif xored < 5509 then
                        v3, v2 = v24(v)

                        flag = v3[list[698](list[list[708]](v18, list[1012], list[1092]), buffer.readu8(v23, list[613]))](v3, (list[list[737]](list[list[708]](v18, list[list[950]], list[1088]), buffer.readu8(v22, list[list[27]]), buffer.readu8(v5, list[509]))))

                        xored = if flag then list[list[819]] else list[935]
                    else
                        xored = list[801]
                    end
                elseif xored < 5512 then
                    if xored < 5511 then
                        callback9(list[list[737]](list[list[708]](v5, list[965], list[931]), buffer.readu8(v22, list[990]), buffer.readu8(v22, list[1083])), {v3})

                        xored = list[list[105]]
                    else
                        xored = if flag then list[list[512]] else list[532]
                    end
                elseif xored < 5513 then
                    flag = v3[list[698](list[list[708]](v22, list[list[784]], list[1092]), buffer.readu8(v26, list[579]))](v3, (list[list[737]](list[list[708]](v23, list[540], list[list[469]]), buffer.readu8(v23, list[679]), buffer.readu8(v23, list[866]))))

                    xored = list[list[819]]
                else
                    xored = list[list[105]]
                end
            else
                if not (xored < 5968) then break end
                if xored < 5517 then
                    if xored < 5515 then
                        xored = list[list[1043]]
                    elseif xored < 5516 then
                        xored = list[650]
                    else
                        xored = if flag then list[454] else list[708]
                    end
                elseif xored < 5519 then
                    if xored < 5518 then
                        flag = v2 == list[list[541]][list[698](list[list[708]](v23, list[845], list[793]), buffer.readu8(v5, list[789]))][list[698](list[list[708]](v22, list[502], list[1092]), buffer.readu8(v5, list[list[741]]))]

                        xored = list[732]
                    else
                        xored = list[793]
                    end
                elseif xored < 5530 then
                    return
                elseif xored ~= 5530 then
                    break
                else
                    xored = list[list[885]]
                end
            end
        end
    end,
    35,
    2690,
    3637,
    414,
    1839,
    1346,
    322,
    315,
    2517,
    295,
    3376,
    3657,
    75,
    1180,
    2759,
    3460,
    159,
    7293,
    40,
    3561,
    325,
    512,
    2825,
    389,
    138,
    1280,
    2464,
    2815,
    3352,
    1866,
    206,
    316,
    3255,
    3656,
    1378,
    283,
    3110,
    267,
    352,
    255,
    223,
    598,
    2731,
    339,
    248,
    3213,
    Random,
    3621,
    3630,
    293,
    2136,
    191,
    384,
    321,
    3172,
    232,
    1271,
    3277,
    1442,
    71,
    3377,
    1564,
    2090,
    3580,
    379,
    435,
    3544,
    49,
    3565,
    2406,
    369,
    2,
    2671,
    210,
    3650,
    275,
    108,
    156,
    1969,
    3433,
    243,
    3093,
    3305,
    function(arg1, arg2) -- line 3832
        if type(arg1) ~= "number" then
            return false
        end

        if arg1 % 1 ~= 0 then
            return false
        end

        local xored = arg1
        xored = bit32.bxor(xored, 1540483477)
        xored = bit32.band(xored * 403 + bit32.lshift(xored, 24), 4294967295)
        xored = bit32.bxor(xored, bit32.rshift(xored, 13))
        return xored == arg2
    end,
    334,
    120,
    391,
    3341,
    3437,
    4509,
    1812,
    2583,
    269,
    395,
    2851,
    3409,
    3663,
    "WaitForChild",
    3220,
    323,
    3249,
    234,
    3293,
    390,
    3520,
    962,
    890,
    345,
    3635,
    3196,
    2018,
    3569,
    3061,
    1918,
    21,
    2387,
    173,
    421,
    5402,
    432,
    462,
    1838,
    3344,
    2186,
    236,
    3537,
    3643,
    363,
    3452,
    3063,
    3340,
    3413,
    3016,
    function(...) -- line 3894 · shares: [1] num, [2] list
        if not num then
            num = {num, "qi·", list, 1474981348}
        end

        return ...
    end,
    220,
    3464,
    3288,
    3472,
    4,
    418,
    85,
    3616,
    365,
    3397,
    11088,
    2903,
    1204,
    6287,
    3331,
    186,
    260,
    2271,
    2141,
    2595,
    331,
    2229,
    3572,
    279,
    62,
    2705,
    2425,
    208,
    504,
    112,
    111,
    3275,
    2409,
    66,
    3256,
    3573,
    93,
    2043,
    3408,
    34,
    433,
    3369,
    3287,
    function(arg1) -- line 3943 · shares: [1] num, [2] v26, [3] v5, [4] list, [5] v22, [6] v23, [7] callback3
        if not num then
            num = {
                v26,
                v5,
                list,
                "}\228\134\227",
                v22,
                "qi·",
                v23,
                1474981348,
                arg1,
            }
        end

        local v, v2
        local xored
        xored = list[935]

        while true do
            xored = bit32.bxor(xored, list[list[1106]])

            if xored < 9675 then
                return
            elseif xored < 16203 then
                return
            elseif xored < 16205 then
                if not (xored < 16204) then break end
                return callback3((list[698](list[list[708]](v5, list[777], list[list[1043]]), buffer.readu8(v22, list[list[549]]))))
            elseif xored < 16206 then
                xored = if arg1[list[698](list[list[708]](v26, list[955], list[list[1043]]), buffer.readu8(v5, list[875]))] then list[801] else list[1002]
            elseif xored < 16207 then
                xored = list[532]
            else
                v2, v = arg1[list[list[737]](list[list[708]](v23, list[1097], list[list[796]]), buffer.readu8(v22, list[list[27]]), buffer.readu8(v22, list[1083]))]()

                local v4 = list[list[737]](list[list[708]](v26, list[912], list[532]), buffer.readu8(v23, list[875]), buffer.readu8(v26, list[list[738]]))

                return v2 .. v4 .. v
            end
        end
    end,
    50,
    149,
    86,
    3282,
    3241,
    2309,
    5514,
    195,
    2390,
    255,
    2066,
    2773,
    151,
    3300,
    2745,
    3639,
    192,
    416,
    3596,
    853,
    676,
    3484,
    3248,
    3140,
    179,
    360,
    18,
    387,
    121,
    1534,
    891,
    2531,
    817,
    1146,
    927,
    704,
    3263,
    349,
    2645,
    399,
    87,
    3662,
    171,
    1170,
    3627,
    2929,
    25,
    297,
    3428,
    103,
    5,
    198,
    3301,
    374,
    423,
    997,
    394,
    2938,
    436,
    2203,
    163,
    3264,
    2612,
    78,
    366,
    239,
    1892,
    125,
    155,
    146,
    function(...) -- line 4058 · shares: [1] num, [2] callback10, [3] v5, [4] callback3, [5] callback9, [6] v, [7] v23, [8] v2, [9] tbl2, [10] v22, [11] v21, [12] list, [13] v26, [14] v18, [15] callback2
        if not num then
            num = {
                callback10,
                v5,
                callback3,
                "qi·",
                callback9,
                "}\228\134\227",
                v,
                v23,
                v2,
                tbl2,
                num,
                v22,
                v21,
                list,
                v26,
                1474981348,
                v18,
                callback2,
            }
        end

        local v3, flag, flag2, v4, v6, v7, v8, v9, v10
        local xored
        xored = list[list[819]]

        while true do
            xored = bit32.bxor(xored, list[list[279]])

            if xored < 14693 then
                if xored < 9380 then
                    return
                elseif xored < 14689 then
                    if xored < 10914 then
                        return
                    elseif xored < 14688 then
                        return
                    else
                        xored = if v3 then list[1092] else list[708]
                    end
                elseif xored < 14691 then
                    if xored < 14690 then
                        xored = if flag2 then list[list[267]] else list[650]
                    else
                        v3 = nil
                        xored = list[list[885]]
                    end
                elseif xored < 14692 then
                    v9 = v8
                    xored = list[list[1043]]
                else
                    flag2 = flag ~= callback3((list[list[737]](list[list[708]](v18, list[1134], list[738]), buffer.readu8(v18, list[509]), buffer.readu8(v22, list[544]))))

                    xored = list[732]
                end
            elseif xored < 14700 then
                if xored < 14696 then
                    if xored < 14694 then
                        return callback9(list[698](list[list[708]](v23, list[list[639]], list[978]), buffer.readu8(v22, list[654])), {v3, flag})
                    end

                    if xored < 14695 then
                        xored = list[list[798]]
                    else
                        v8 += list[list[885]]
                        xored = list[1002]
                    end
                elseif xored < 14698 then
                    if xored < 14697 then
                        xored = if v8 <= v6 then list[list[105]] else list[list[1074]]
                    else
                        v10 = v9
                        return callback9((list[698](list[list[708]](v26, list[1123], list[list[227]]), buffer.readu8(v18, list[564]))))
                    end
                elseif xored < 14699 then
                    xored = if v2 ~= callback10[callback2] then list[list[378]] else list[532]
                else
                    return callback9((list[698](list[list[708]](v26, list[list[166]], list[978]), buffer.readu8(v5, list[1057]))))
                end
            elseif xored < 14703 then
                if xored < 14701 then
                    v10 = v9
                    flag = v4[list[698](list[list[708]](v23, list[1090], list[1002]), buffer.readu8(v23, list[990]))](v4, callback3((list[698](list[list[708]](v18, list[list[410]], list[650]), buffer.readu8(v18, list[861])))))

                    xored = list[935]
                elseif xored < 14702 then
                    flag = v2
                    flag2 = buffer.readu8(v5, list[642])
                    v4 = buffer.readu8(v26, list[642])
                    v8 = flag2
                    v6 = v4
                    xored = list[1002]
                else
                    v3 = flag
                    xored = list[454]
                end
            elseif xored < 14717 then
                if xored < 14716 then
                    if xored ~= 14703 then break end
                    v3, flag = v(v2, callback10, tbl2)
                    flag2 = v3
                    xored = if flag2 then list[732] else list[list[512]]
                else
                    v10 = v9

                    flag = list[709][list[698](list[list[708]](v23, list[list[1109]], list[1002]), buffer.readu8(v22, list[list[549]]))](flag)
                    xored = list[793]
                end
            else
                if not (xored < 14718) then break end
                flag2, v4 = v(flag)
                flag = not flag2
                xored = if flag then list[801] else list[935]
            end
        end
    end,
    205,
    3529,
    238,
    3380,
    3604,
    313,
    119,
    3659,
    404,
    3188,
    1623,
    131,
    401,
    2308,
    3416,
    3316,
    1644,
    2386,
    3532,
    function(arg1, arg2, arg3, arg4) -- line 4192 · shares: [1] num, [2] v26, [3] list, [4] v22, [5] v23, [6] v18, [7] v, [8] callback3, [9] v5
        if not num then
            num = {
                num,
                v26,
                list,
                v22,
                v23,
                "qi·",
                v18,
                v,
                "}\228\134\227",
                callback3,
                1474981348,
                arg1,
                arg2,
                arg3,
                arg4,
            }
        end

        local v2, v3, flag, v4, v6, v7, v8, v9
        local xored
        xored = list[801]

        while true do
            xored = bit32.bxor(xored, list[881])

            if xored < 7293 then
                if xored < 7288 then
                    if xored < 6931 then
                        return
                    elseif xored < 7285 then
                        return
                    elseif xored ~= 7285 then
                        break
                    else
                        v2, v3 = v(arg1)
                        flag = not v2
                        xored = if flag then list[list[819]] else list[list[378]]
                    end
                elseif xored < 7290 then
                    if xored < 7289 then
                        v8 = v7
                        xored = list[532]
                    else
                        v7 += list[list[885]]
                        xored = list[list[885]]
                    end
                elseif xored < 7291 then
                    return flag
                elseif xored < 7292 then
                    v9 = v8
                    flag = v3[list[698](list[list[708]](v23, list[list[93]], list[1002]), buffer.readu8(v22, list[list[549]]))](v3, callback3((list[list[737]](list[list[708]](v18, list[1104], list[list[105]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v5, list[642])))))

                    xored = list[list[378]]
                else
                    xored = if v7 <= v4 then list[1092] else list[list[512]]
                end
            else
                if not (xored < 11042) or not (xored < 7295) then break end

                if xored < 7294 then
                    v2 = buffer.readu8(v5, list[642])
                    v3 = buffer.readu8(v26, list[642])
                    v7 = v2
                    v4 = v3
                    xored = list[list[885]]
                else
                    v9 = v8

                    arg1 = list[709][list[698](list[list[708]](v26, list[791], list[1002]), buffer.readu8(v23, list[875]))](arg1)
                    xored = list[1002]
                end
            end
        end
    end,
    2405,
    780,
}

list[85], list[314], list[505], list[785], list[270], list[1112], list[688], list[532], list[802], list[750] = list[85], list[802], list[785], list[505], list[750], list[688], list[1112], list[532], list[314], list[270]

list[969], list[847], list[774], list[20], list[177], list[53], list[330], list[397], list[252], list[1128], list[286], list[596], list[885], list[640], list[960], list[631] = list[960], list[177], list[397], list[252], list[1128], list[53], list[885], list[640], list[596], list[847], list[774], list[969], list[20], list[330], list[286], list[631]

list[880], list[1080] = list[880], list[1080]
list[139], list[966], list[788], list[624], list[545], list[390], list[537], list[1024], list[834], list[303], list[488], list[890], list[775], list[813], list[547], list[418], list[1067], list[466], list[330] = list[330], list[545], list[547], list[303], list[1067], list[813], list[788], list[488], list[418], list[466], list[390], list[139], list[537], list[624], list[834], list[966], list[1024], list[775], list[890]

list[185], list[705], list[984], list[349], list[896], list[200], list[1105], list[10], list[461], list[724], list[331], list[864], list[276] = list[349], list[896], list[185], list[724], list[461], list[276], list[705], list[331], list[984], list[1105], list[10], list[200], list[864]

list[160], list[318], list[566], list[922], list[726], list[215], list[658], list[846], list[885], list[916], list[779], list[128] = list[916], list[318], list[566], list[128], list[658], list[779], list[922], list[726], list[160], list[215], list[846], list[885]

callback2 = nil
callback8 = nil
callback3 = nil
callback9 = nil
v24 = nil
v15 = nil
v17 = nil
v7 = nil
v10 = nil
tbl = nil
v19 = nil
tbl2 = nil
v = nil
callback7 = nil
v13 = nil
v3 = nil
v22 = nil
v14 = nil
v4 = nil
v23 = nil
v16 = nil
v5 = nil
callback11 = nil
v18 = nil
v26 = nil
v9 = nil
env = nil
callback5 = nil
v11 = nil
callback6 = nil
v2 = nil
v20 = nil
v12 = nil

local v27, callback12, v28, v29, fn, callback13, v30, v31, v32, callback14, v33, v34, v35, v36, v37, callback15, callback16
callback = nil
v21 = nil
callback4 = nil
callback10 = nil
tbl3 = nil
v6 = nil
v25 = nil
v8 = nil

local v38
local v39
local v40
local v41
local count
local tbl4
local list2
local version2
local object
local callback17
local env2
local count2
local flag
local callback18
local count3
local callback19
local version3
local callback20
local callback21
local callback22
local callback23
local callback24
local callback25
local callback26
local v42
local callback27
local str
local tbl5
local v43
local v44
local v45
local v46
local v47
local v48
local v49
local v50
local v51
local v52
local v53
local v54
local v55
local v56
local v57, v58, v59
local xored
xored = list[320]

while true do
    xored = bit32.bxor(xored, list[855])

    if xored < 1249 then
        if xored < 1136 then
            if xored < 1080 then
                if xored < 1052 then
                    if xored < 1038 then
                        if xored < 1031 then
                            if xored < 1027 then
                                if xored < 1025 then
                                    if xored ~= 1024 then break end
                                    local callback28 = table[list[10](v22, list[1040], list[114])]
                                    callback28(callback28)
                                    env2 = getfenv()
                                    xored = list[710]
                                elseif xored < 1026 then
                                    v21 = list[1132]
                                    v20 = list[1041]
                                    v16 = list[690]
                                    v13 = table[list[10](v22, list[753], list[114])](buffer.readu16(v22, list[707]), buffer.readu8(v26, list[1083]))

                                    xored = list[727]
                                else
                                    tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                                    xored = list[1124]
                                end
                            elseif xored < 1029 then
                                if xored < 1028 then
                                    tbl5 = nil
                                    tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                                    tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                                    xored = list[402]
                                else
                                    v50 = v49
                                    callback9((list[188](list[10](v23, list[988], list[324]), buffer.readu8(v23, list[679]), buffer.readu8(v26, list[65]))))

                                    xored = list[610]
                                end
                            else
                                xored = if xored < 1030 then list[724] else list[1014]
                            end
                        elseif xored < 1034 then
                            if xored < 1032 then
                                xored = list[633]
                            else
                                xored = if xored < 1033 then list[923] else list[565]
                            end
                        elseif xored < 1036 then
                            if xored < 1035 then
                                tbl5 = nil
                                tbl5 = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[37])
                                tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                                xored = list[583]
                            else
                                xored = if count <= buffer.readu8(v26, list[37]) then list[741] else list[434]
                            end
                        elseif xored < 1037 then
                            list2 = (list2 + buffer.readu8(v18, list[37])) % buffer.readu8(v23, list[789])
                            xored = list[201]
                        else
                            xored = if str <= buffer.readu8(v23, list[509]) then list[818] else list[274]
                        end
                    elseif xored < 1045 then
                        if xored < 1041 then
                            if xored < 1039 then
                                xored = list[505]
                            elseif xored < 1040 then
                                callback20 += count
                                xored = list[738]
                            else
                                xored = list[545]
                            end
                        elseif xored < 1043 then
                            if xored < 1042 then
                                xored = list[130]
                            else
                                v10 = nil
                                callback17 = nil
                                object = nil
                                count = nil
                                count = buffer.readu8(v26, list[1083])
                                xored = list[991]
                            end
                        elseif xored < 1044 then
                            xored = list[1018]
                        else
                            tbl5 = list[351][callback19((list[698](list[10](v22, list[1112], list[532]), buffer.readu8(v26, list[544]))))]

                            callback10 = nil
                            v43 = list[188](list[10](v5, list[857], list[26]), buffer.readu8(v22, list[1120]), buffer.readu8(v26, list[875]))

                            local v71 = list[588]
                            callback = callback10(tbl5, v71[list[698](list[10](v23, list[448], list[708]), buffer.readu8(v22, list[71]))](v71, callback19((list[188](list[10](v5, list[1133], list[262]), buffer.readu8(v18, list[425]), buffer.readu8(v5, list[509]))))))

                            tbl5 = callback19((list[698](list[10](v23, list[302], list[650]), buffer.readu8(v26, list[312]))))
                            local v73 = list[588]
                            v6 = callback10(callback10, v73[list[188](list[10](v18, list[783], list[731]), buffer.readu8(v26, list[425]), buffer.readu8(v18, list[65]))](v73, callback19(callback19)))

                            do
                                local v74 = callback[callback2]
                            end
                            v2 = v43
                            local v74 = v6[callback3]
                            callback8 = tbl5
                            xored = list[232]
                        end
                    elseif xored < 1048 then
                        if xored < 1046 then
                            local v74 = tbl4 * buffer.readu32(v22, list[12]) + buffer.readu8(v5, list[990]) + buffer.readu8(v23, list[509])

                            xored = if v74 <= tbl4 * buffer.readu32(v22, list[12]) + buffer.readu8(v5, list[990]) + buffer.readu8(v23, list[509]) + buffer.readu8(v5, list[642]) then list[1091] else list[9]
                        elseif xored < 1047 then
                            xored = if str <= buffer.readu8(v5, list[544]) then list[310] else list[772]
                        else
                            v24 = list[910][list[698](list[10](v18, list[1086], list[532]), buffer.readu8(v18, list[546]))]()
                            xored = list[419]
                        end
                    elseif xored < 1050 then
                        if xored < 1049 then
                            v50 = v49
                            count = v12[version3[v50]]
                            xored = if math[list[10](v26, list[525], list[114])]() < buffer.readf64(v26, list[291]) then list[888] else list[15]
                        else
                            callback14 = callback17(list[863])
                            v42 = callback17(callback17)
                            xored = list[838]
                        end
                    elseif xored < 1051 then
                        tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                        xored = list[243]
                    else
                        xored = if version2 then list[383] else list[931]
                    end
                elseif xored < 1066 then
                    if xored < 1059 then
                        if xored < 1055 then
                            if xored < 1053 then
                                v50 = v49

                                v14 = list[910][list[188](list[10](v18, list[906], list[650]), buffer.readu8(v26, list[866]), buffer.readu8(v18, list[37]))](callback20)
                                v40 = nil
                                xored = list[407]
                            elseif xored < 1054 then
                                callback3 = callback8(callback8)
                                xored = list[280]
                            else
                                xored = if v53 <= v51 then list[963] else list[824]
                            end
                        elseif xored < 1057 then
                            if xored < 1056 then
                                callback19 = str
                                xored = list[928]
                            else
                                count = (list2 * buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[1083])) % buffer.readu8(v26, list[37]) + buffer.readu8(v5, list[642])
                                xored = list[368]
                            end
                        elseif xored < 1058 then
                            flag = callback18[callback3((list[698](list[10](v22, list[61], list[708]), buffer.readu8(v23, list[71]))))]
                            xored = list[68]
                        else
                            xored = if str <= buffer.readu8(v23, list[866]) then list[111] else list[950]
                        end
                    elseif xored < 1062 then
                        if xored < 1060 then
                            list2 = (list2 + buffer.readu8(v5, list[579])) % buffer.readu8(v5, list[1057])
                            xored = list[469]
                        elseif xored < 1061 then
                            xored = list[311]
                        else
                            count2 = version2
                            version2 = nil
                            xored = list[919]
                        end
                    elseif xored < 1064 then
                        if xored < 1063 then
                            v53 += list[33]
                            xored = list[1110]
                        else
                            version2 = list[771]()
                            xored = list[611]
                        end
                    elseif xored < 1065 then
                        callback18 = flag
                        xored = if callback18 then list[445] else list[902]
                    else
                        xored = list[747]
                    end
                elseif xored < 1073 then
                    if xored < 1069 then
                        if xored < 1067 then
                            xored = list[342]
                        elseif xored < 1068 then
                            xored = list[500]
                        else
                            callback8 = callback3((list[188](list[10](v18, list[706], list[105]), buffer.readu8(v22, list[509]), buffer.readu8(v26, list[990]))))

                            xored = list[280]
                        end
                    elseif xored < 1071 then
                        if xored < 1070 then
                            tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                            xored = list[117]
                        else
                            str = callback4(str, buffer.readu32(v18, list[552]))
                            xored = if str < buffer.readu8(v26, list[1083]) then list[239] else list[563]
                        end
                    else
                        xored = if xored < 1072 then list[87] else list[437]
                    end
                elseif xored < 1076 then
                    if xored < 1074 then
                        tbl5 = nil
                        tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                        tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                        tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                        tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                        xored = list[983]
                    else
                        xored = if xored < 1075 then list[822] else list[342]
                    end
                elseif xored < 1078 then
                    if xored < 1077 then
                        xored = if list[947]((tbl4 * buffer.readu8(v5, list[579]) + buffer.readu8(v23, list[1057])) % buffer.readu8(v18, list[789]), buffer.readu32(v22, list[1116])) then list[141] else list[784]
                    else
                        local xored2 = bit32.bxor(bit32.bxor(bit32.bxor(bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v22, list[544])), string.byte(tostring(tbl2))), buffer.readu8(v18, list[990])), buffer.readu32(v26, list[713])), buffer.readu32(v26, list[336])), bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v22, list[544])), string.byte(tostring(tbl2))), buffer.readu8(v18, list[990])), buffer.readu32(v23, list[252])), buffer.readu32(v22, list[1127]))), buffer.readu32(v26, list[336])), buffer.readu32(v22, list[1127]))

                        xored = if xored2 ~= bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v22, list[544])), string.byte(tostring(tbl2))), buffer.readu8(v18, list[990])) then list[832] else list[885]
                    end
                else
                    xored = if xored < 1079 then list[372] else list[1044]
                end
            elseif xored < 1108 then
                if xored < 1094 then
                    if xored < 1087 then
                        if xored < 1083 then
                            if xored < 1081 then
                                local xored2 = bit32.bxor(bit32.lrotate(bit32.bxor(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v22, list[312])), string.byte(tostring(callback18))), buffer.readu8(v23, list[861])), buffer.readu32(v18, list[457])), buffer.readu8(v22, list[642])), buffer.readu32(v26, list[717]))

                                xored = if xored2 == bit32.lrotate(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v22, list[312])), string.byte(tostring(callback18))), buffer.readu8(v23, list[861])), buffer.readu8(v22, list[642])) then list[949] else list[1092]
                            elseif xored < 1082 then
                                if not (not (env2 or callback17) or object or env2) and (not (object and callback17 or object) and callback17) or (not (env2 or callback17) or object or env2) or (object and callback17 or object or not callback17) then
                                    xored = list[732]
                                else
                                    xored = list[937]
                                end
                            else
                                tbl5 = nil
                                tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                                tbl5 = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
                                xored = list[16]
                            end
                        elseif xored < 1085 then
                            if xored < 1084 then
                                v50 = v49
                                object = setmetatable(list[698](list[10](v22, list[1064], list[221]), buffer.readu8(v26, list[425])), {})

                                xored = list[477]
                            else
                                xored = list[399]
                            end
                        else
                            xored = if xored < 1086 then list[907] else list[288]
                        end
                    elseif xored < 1090 then
                        if xored < 1088 then
                            callback21 = nil
                            tbl5 = list[414]
                            v15 = tbl5
                            count2 = list[112](true)
                            callback9 = tbl5
                            local mt = getmetatable(getmetatable)
                            mt[list[698](list[10](v23, list[482], list[708]), buffer.readu8(v18, list[425]))] = mt
                            v37 = count2
                            xored = list[147]
                        elseif xored < 1089 then
                            tbl5 = nil
                            tbl5 = buffer.readu8(v26, list[546]) - buffer.readu8(v23, list[509])
                            xored = list[901]
                        else
                            xored = list[630]
                        end
                    elseif xored < 1092 then
                        if xored < 1091 then
                            xored = if list[947]((list2 * buffer.readu8(v23, list[861]) + buffer.readu8(v26, list[425])) % buffer.readu8(v5, list[1057]), buffer.readu32(v22, list[328])) then list[1119] else list[267]
                        else
                            callback11 = callback18[callback3((list[698](list[10](v23, list[187], list[793]), buffer.readu8(v5, list[1057]))))]
                            xored = list[276]
                        end
                    elseif xored < 1093 then
                        local v89 = (list2 * buffer.readu8(v26, list[37]) + buffer.readu8(v22, list[312])) * buffer.readu8(v26, list[546]) % buffer.readu8(v5, list[37])

                        xored = if v89 == ((list2 * buffer.readu8(v26, list[37]) + buffer.readu8(v22, list[312])) * buffer.readu8(v26, list[546]) + buffer.readu8(v23, list[509])) % buffer.readu8(v5, list[37]) then list[327] else list[442]
                    else
                        xored = list[179]
                    end
                elseif xored < 1101 then
                    if xored < 1097 then
                        if xored < 1095 then
                            flag = version2 >= buffer.readu8(v23, list[425])
                            xored = if flag then list[396] else list[836]
                        else
                            xored = if xored < 1096 then list[470] else list[1079]
                        end
                    elseif xored < 1099 then
                        if xored < 1098 then
                            tbl4 = nil
                            tbl4 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                            xored = list[743]
                        else
                            v50 = v49
                            tbl4 = {
                                list[698](list[10](v18, list[594], list[1092]), buffer.readu8(v5, list[897])),
                                list[188](list[10](v23, list[497], list[178]), buffer.readu8(v22, list[972]), buffer.readu8(v26, list[1083])),
                                list[188](list[10](v22, list[191], list[738]), buffer.readu8(v5, list[71]), buffer.readu8(v22, list[642])),
                                list[188](list[10](v22, list[695], list[703]), buffer.readu8(v26, list[579]), buffer.readu8(v22, list[861])),
                                list[698](list[10](v22, list[973], list[307]), buffer.readu8(v18, list[579])),
                                list[698](list[10](v26, list[1094], list[114]), buffer.readu8(v22, list[990])),
                                list[188](list[10](v5, list[659], list[738]), buffer.readu8(v22, list[972]), buffer.readu8(v18, list[990])),
                                list[188](list[10](v18, list[909], list[307]), buffer.readu8(v18, list[312]), buffer.readu8(v5, list[642])),
                                list[188](list[10](v23, list[705], list[221]), buffer.readu8(v18, list[425]), buffer.readu8(v26, list[37])),
                                list[188](list[10](v26, list[614], list[1037]), buffer.readu8(v26, list[866]), buffer.readu8(v18, list[65])),
                                (list[698](list[10](v23, list[159], list[1002]), buffer.readu8(v18, list[1083]))),
                            }

                            count2 = tbl4[list2 % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642])]
                            tbl4 = list2 % buffer.readu8(v5, list[37]) + buffer.readu8(v26, list[37])

                            flag = count2[list[188](list[10](v26, list[508], list[47]), buffer.readu8(v5, list[897]), buffer.readu8(v5, list[579]))](count2)

                            local v94 = tbl4

                            tbl4 = count2[list[188](list[10](v26, list[39], list[793]), buffer.readu8(v18, list[897]), buffer.readu8(v5, list[509]))](count2)

                            callback18 = flag[list[188](list[10](v26, list[121], list[656]), buffer.readu8(v23, list[990]), buffer.readu8(v23, list[861]))](flag, v94)

                            xored = if tbl4 >= callback18[list[188](list[10](v5, list[483], list[178]), buffer.readu8(v23, list[230]), buffer.readu8(v23, list[509]))](callback18) then list[160] else list[917]
                        end
                    elseif xored < 1100 then
                        version2(callback, buffer.readu8(v5, list[642]), version2, v40)
                        v50 = v49

                        local v96 = v41[list[188](list[10](v5, list[499], list[262]), buffer.readu8(v18, list[897]), buffer.readu8(v5, list[509]))][list[188](list[10](v26, list[757], list[221]), buffer.readu8(v26, list[866]), buffer.readu8(v5, list[642]))]

                        local v97 = callback + v96 + list[588][list[188](list[10](v22, list[706], list[105]), buffer.readu8(v26, list[579]), buffer.readu8(v5, list[938]))] + list[588][list[698](list[10](v23, list[550], list[454]), buffer.readu8(v22, list[71]))] + list[588][list[188](list[10](v5, list[1053], list[732]), buffer.readu8(v23, list[71]), buffer.readu8(v23, list[509]))]

                        callback = list[588]
                        xored = list[421]
                    else
                        env2(list[910][list[698](list[10](v22, list[912], list[532]), buffer.readu8(v23, list[642]))](), version3)
                        tbl5 = list[340][list[188](list[10](v18, list[495], list[115]), buffer.readu8(v22, list[51]), buffer.readu8(v5, list[544]))]

                        v43 = v40[list[698](list[10](v23, list[781], list[793]), buffer.readu8(v26, list[866]))]
                        callback20 = tbl5 + v43[list[698](list[10](v23, list[1056], list[650]), buffer.readu8(v18, list[897]))](v43)
                        xored = list[758]
                    end
                elseif xored < 1104 then
                    if xored < 1102 then
                        count = env2 == nil
                        xored = if count then list[390] else list[533]
                    elseif xored < 1103 then
                        local v100 = (count * buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[1083])) % buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[642])
                        xored = list[133]
                    else
                        list2 = (list2 + buffer.readu8(v22, list[230])) % buffer.readu8(v5, list[1057])
                        xored = list[162]
                    end
                elseif xored < 1106 then
                    xored = if xored < 1105 then list[1068] else list[500]
                elseif xored < 1107 then
                    count2 = callback18
                    xored = list[298]
                else
                    xored = list[181]
                end
            elseif xored < 1122 then
                if xored < 1115 then
                    if xored < 1111 then
                        if xored < 1109 then
                            count2 += buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083])
                            xored = list[307]
                        elseif xored < 1110 then
                            callback20 = count3
                            count2 = v25
                            v50 = v49

                            str = list[188](list[10](v22, list[53], list[691]), buffer.readu8(v5, list[425]), buffer.readu8(v26, list[71]))

                            tbl5 = callback20[list[188](list[10](v18, list[538], list[817]), buffer.readu8(v23, list[71]), buffer.readu8(v22, list[544]))](callback20)
                            v43 = buffer.readu8(v5, list[642])
                            v53 = v43
                            v51 = tbl5
                            xored = list[498]
                        else
                            xored = if v53 <= v51 then list[1118] else list[156]
                        end
                    elseif xored < 1113 then
                        if xored < 1112 then
                            v50 = v49
                            local v105 = list[188](list[10](v5, list[788], list[126]), buffer.readu8(v5, list[897]), buffer.readu8(v22, list[312]))
                            count = v25[v105]

                            v41 = count[list[698](list[10](v26, list[348], list[1002]), buffer.readu8(v26, list[312]))](count)
                            xored = list[55]
                        else
                            callback2 = callback3((list[188](list[10](v18, list[893], list[469]), buffer.readu8(v26, list[425]), buffer.readu8(v22, list[544]))))

                            xored = list[1038]
                        end
                    elseif xored < 1114 then
                        xored = list[42]
                    else
                        xored = if str <= buffer.readu8(v23, list[1083]) then list[67] else list[31]
                    end
                elseif xored < 1118 then
                    if xored < 1116 then
                        xored = list[325]
                    elseif xored < 1117 then
                        xored = list[595]
                    else
                        count = #version3
                        tbl4 = buffer.readu8(v5, list[642])
                        v48 = tbl4
                        v46 = count
                        xored = list[516]
                    end
                elseif xored < 1120 then
                    if xored < 1119 then
                        tbl5 = string[list[10](v22, list[1005], list[1002])](callback19, callback20)
                        local callback28 = callback4
                        local v107 = callback6(str, buffer.readu8(v5, list[509]))
                        local v108 = callback4(callback5(str, buffer.readu8(v18, list[875])), tbl5) + buffer.readu8(v5, list[642])
                        str = callback28(v107, tbl3[v108])

                        callback20 += buffer.readu8(v5, list[642])
                        version3 -= buffer.readu8(v5, list[642])
                        xored = list[173]
                    else
                        tbl4 = (tbl4 + buffer.readu8(v22, list[71])) % buffer.readu8(v18, list[789])
                        xored = list[155]
                    end
                elseif xored < 1121 then
                    xored = list[876]
                else
                    xored = if str <= buffer.readu8(v22, list[544]) then list[714] else list[211]
                end
            elseif xored < 1129 then
                if xored < 1125 then
                    if xored < 1123 then
                        callback20(list[910][list[698](list[10](v26, list[1086], list[532]), buffer.readu8(v26, list[861]))](), env2)
                        tbl5 = list[340][list[698](list[10](v23, list[624], list[262]), buffer.readu8(v26, list[866]))]
                        v43 = version3[list[698](list[10](v18, list[435], list[793]), buffer.readu8(v22, list[1120]))]
                        v44 = v43

                        local v112 = tbl5 + v44[list[188](list[10](v22, list[1129], list[703]), buffer.readu8(v22, list[1120]), buffer.readu8(v5, list[564]))](v44)
                        v40 = v43
                        xored = list[758]
                    elseif xored < 1124 then
                        xored = list[1100]
                    else
                        count = (count + buffer.readu8(v26, list[37])) % buffer.readu8(v18, list[938])
                        xored = list[554]
                    end
                elseif xored < 1127 then
                    if xored < 1126 then
                        callback14 = tbl4
                        xored = list[413]
                    else
                        local v112 = string[list[10](v23, list[1040], list[114])]
                        v29 = string
                        callback3 = callback13(callback13)
                        xored = list[1105]
                    end
                else
                    xored = if xored < 1128 then list[908] else list[532]
                end
            elseif xored < 1132 then
                if xored < 1130 then
                    callback19 = count3
                    version3 = #callback19
                    callback20 = buffer.readu8(v5, list[642])
                    str = buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083]) - buffer.readu8(v5, list[642])
                    xored = list[998]
                else
                    xored = if xored < 1131 then list[846] else list[130]
                end
            elseif xored < 1134 then
                if xored < 1133 then
                    xored = list[543]
                else
                    flag = tbl4
                    callback18 = list2
                    count3 = count2
                    count2 = nil
                    xored = list[988]
                end
            elseif xored < 1135 then
                local v112 = callback3((list[188](list[10](v18, list[849], list[1037]), buffer.readu8(v22, list[1120]), buffer.readu8(v26, list[37]))))
                v33 = callback16[v112]

                object = list[588][callback3((list[698](list[10](v5, list[770], list[708]), buffer.readu8(v22, list[509]))))]
                version2 = list[588][callback3((list[188](list[10](v26, list[424], list[832]), buffer.readu8(v18, list[425]), buffer.readu8(v5, list[579]))))]

                xored = list[207]
            else
                xored = if str <= buffer.readu8(v26, list[990]) then list[681] else list[26]
            end
        elseif xored < 1192 then
            if xored < 1164 then
                if xored < 1150 then
                    if xored < 1143 then
                        if xored < 1139 then
                            if xored < 1137 then
                                v = ypcall
                                xored = list[895]
                            elseif xored < 1138 then
                                v50 = v49
                                count = not list[195](type(env2), buffer.readu8(v5, list[990]), buffer.readu32(v26, list[263]))

                                xored = list[390]
                            else
                                xored = list[407]
                            end
                        elseif xored < 1141 then
                            if xored < 1140 then
                                table[list[10](v5, list[1012], list[1092])](version3)
                                version2 = version()
                                xored = list[776]
                            else
                                local xored2 = bit32.bxor(bit32.bxor(bit32.bxor(bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v23, list[789])), string.byte(tostring(callback17))), buffer.readu8(v18, list[37])), buffer.readu32(v18, list[154])), buffer.readu32(v5, list[775])), bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v23, list[789])), string.byte(tostring(callback17))), buffer.readu8(v18, list[37])), buffer.readu32(v26, list[631])), buffer.readu32(v26, list[14]))), buffer.readu32(v5, list[775])), buffer.readu32(v26, list[14]))

                                xored = if xored2 == bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v23, list[789])), string.byte(tostring(callback17))), buffer.readu8(v18, list[37])) then list[99] else list[107]
                            end
                        elseif xored < 1142 then
                            xored = if list[947]((tbl4 * buffer.readu8(v5, list[990]) + buffer.readu8(v26, list[1083])) % buffer.readu8(v5, list[509]), buffer.readu32(v23, list[379])) then list[794] else list[1058]
                        else
                            xored = list[628]
                        end
                    elseif xored < 1146 then
                        if xored < 1144 then
                            xored = list[1100]
                        elseif xored < 1145 then
                            xored = list[401]
                        else
                            xored = if v48 <= v46 then list[46] else list[768]
                        end
                    elseif xored < 1148 then
                        if xored < 1147 then break end

                        callback19 = nil
                        version3 = count2
                        xored = list[1025]
                    else
                        xored = if xored < 1149 then list[1027] else list[399]
                    end
                elseif xored < 1157 then
                    if xored < 1153 then
                        if xored < 1151 then
                            list2 = (list2 + buffer.readu8(v18, list[37])) % buffer.readu8(v5, list[1057])
                            xored = list[158]
                        elseif xored < 1152 then
                            v7 = count
                            v31 = list[709][list[188](list[10](v18, list[868], list[691]), buffer.readu8(v22, list[546]), buffer.readu8(v26, list[875]))]

                            xored = list[929]
                        else
                            callback3 = list[127][callback12(list[127])][callback12((list[188](list[10](v26, list[825], list[1068]), buffer.readu8(v5, list[312]), buffer.readu8(v18, list[37]))))]

                            xored = list[262]
                        end
                    elseif xored < 1155 then
                        if xored < 1154 then
                            count = nil
                            count = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
                            count = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                            count = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[37])
                            xored = list[1006]
                        else
                            xored = list[59]
                        end
                    elseif xored < 1156 then
                        tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                        xored = list[1034]
                    else
                        tbl5 = nil
                        tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                        tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                        tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                        tbl5 = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
                        xored = list[115]
                    end
                elseif xored < 1160 then
                    if xored < 1158 then
                        xored = list[1107]
                    elseif xored < 1159 then
                        local v122 = tbl4 * buffer.readu32(v23, list[999]) + buffer.readu8(v18, list[938]) + buffer.readu8(v5, list[990])

                        xored = if v122 <= tbl4 * buffer.readu32(v23, list[999]) + buffer.readu8(v18, list[938]) + buffer.readu8(v5, list[990]) + buffer.readu8(v23, list[509]) then list[661] else list[17]
                    else
                        xored = if str <= buffer.readu8(v5, list[509]) then list[779] else list[728]
                    end
                elseif xored < 1162 then
                    if xored < 1161 then
                        v50 = v49
                        count = v41[list[188](list[10](v22, list[1003], list[639]), buffer.readu8(v5, list[71]), buffer.readu8(v18, list[65]))]

                        v25 = count[list[188](list[10](v23, list[499], list[262]), buffer.readu8(v5, list[312]), buffer.readu8(v5, list[564]))](count)
                        xored = list[55]
                    else
                        count3 = callback14(list[739])
                        callback23 = callback14(function(arg1, arg2) -- line 5367 · shares: [1] v5, [2] v24, [3] v18, [4] callback14, [5] v38, [6] list, [7] callback3, [8] callback9, [9] v17, [10] v22, [11] v23, [12] v39
                            if not arg2 then
                                ({})[1] = v5;
                                ({})[2] = v24;
                                ({})[3] = v18;
                                ({})[4] = callback14;
                                ({})[5] = v38;
                                ({})[6] = list;
                                ({})[7] = callback3;
                                ({})[8] = callback9;
                                ({})[9] = v17;
                                ({})[10] = v22;
                                ({})[11] = v23;
                                ({})[12] = v39;
                                ({})[13] = arg1;
                                ({})[14] = arg2
                            end

                            local v, v2, v3, v4, v6
                            local xored
                            xored = list[list[885]]

                            while true do
                                xored = bit32.bxor(xored, list[725])

                                if xored < 13443 then
                                    if xored < 13056 then break end

                                    if xored < 13441 then
                                        if xored < 13440 then break end

                                        xored = list[list[819]]
                                    else
                                        xored = if xored < 13442 then list[list[267]] else list[532]
                                    end
                                elseif xored < 13447 then
                                    if xored < 13445 then
                                        if xored < 13444 then
                                            v4, v6, v3 = v24(v2)
                                            xored = if v3 == nil then list[935] else list[793]
                                        else
                                            callback9(list[list[737]](list[list[708]](v18, list[list[368]], list[785]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v18, list[list[305]])), {v4, v6})

                                            xored = list[793]
                                        end
                                    elseif xored < 13446 then
                                        v2 = v38[callback3((list[list[737]](list[list[708]](v5, list[573], list[list[227]]), buffer.readu8(v5, list[1057]), buffer.readu8(v5, list[938]))))]

                                        local v8 = v17(v2, function(arg1, arg2, arg3, arg4) -- line 5417 · shares: [1] v23, [2] list, [3] callback9
                                            if not arg4 then
                                                ({})[1] = v23;
                                                ({})[2] = list;
                                                ({})[3] = callback9;
                                                ({})[4] = arg1;
                                                ({})[5] = arg2;
                                                ({})[6] = arg3;
                                                ({})[7] = arg4
                                            end

                                            local xored
                                            xored = list[532]

                                            while true do
                                                xored = bit32.bxor(xored, list[list[262]])

                                                if not (xored < 7111) then break end
                                                if xored < 1431 then
                                                    if xored < 1429 then
                                                        if xored ~= 1428 then break end
                                                        xored = list[935]
                                                    else
                                                        if not (xored < 1430) then break end
                                                        callback9(list[list[737]](list[515], buffer.readu8(v23, list[990]), list[935]), {arg1, arg2})

                                                        xored = list[801]
                                                    end
                                                else
                                                    if not (xored < 4751 and xored < 3152) or xored ~= 1431 then
                                                        break
                                                    end

                                                    xored = if arg3 == nil then list[list[885]] else list[801]
                                                end
                                            end
                                        end)
                                        callback14(function(arg1, arg2, arg3) -- line 5468 · shares: [1] v18, [2] v5, [3] v8, [4] list, [5] callback9, [6] v23, [7] v22
                                            if not arg3 then
                                                ({})[1] = v18;
                                                ({})[2] = v5;
                                                ({})[3] = v8;
                                                ({})[4] = list;
                                                ({})[5] = callback9;
                                                ({})[6] = v23;
                                                ({})[7] = arg1;
                                                ({})[8] = arg2;
                                                ({})[9] = arg3
                                            end

                                            local xored
                                            xored = list[list[819]]

                                            while true do
                                                xored = bit32.bxor(xored, list[960])

                                                if xored < 15393 then
                                                    return
                                                elseif xored < 16292 then
                                                    if xored < 16289 then
                                                        if xored < 16288 then
                                                            return
                                                        end

                                                        xored = list[532]
                                                    elseif xored < 16290 then
                                                        xored = list[1092]
                                                    elseif xored < 16291 then
                                                        xored = if not v8[list[698](list[list[567]], buffer.readu8(v5, list[875]))] then list[935] else list[801]
                                                    else
                                                        xored = list[list[512]]
                                                    end
                                                elseif xored < 16295 then
                                                    if xored < 16293 then
                                                        callback9((list[698](list[list[708]](v18, list[942], list[1088]), buffer.readu8(v22, list[579]))))

                                                        xored = list[801]
                                                    else
                                                        xored = if xored < 16294 then list[list[885]] else list[list[267]]
                                                    end
                                                elseif xored < 16302 then
                                                    if xored ~= 16295 then break end

                                                    xored = if list[list[1096]][list[698](list[list[708]](v23, list[list[905]], list[1002]), buffer.readu8(v22, list[list[832]]))](buffer.readf64(v5, list[list[68]])) then list[1002] else list[list[378]]
                                                else
                                                    if xored < 16303 then
                                                        return
                                                    end

                                                    xored = list[532]
                                                end
                                            end
                                        end)
                                        xored = list[list[819]]
                                    else
                                        xored = if v4[list[list[737]](list[list[708]](v5, list[list[352]], list[list[798]]), buffer.readu8(v23, list[642]), buffer.readu8(v22, list[544]))](v4, v39) then list[1002] else list[801]
                                    end
                                elseif xored < 13453 then
                                    if xored < 13452 then
                                        if xored ~= 13447 then break end
                                        xored = list[list[378]]
                                    else
                                        xored = list[list[819]]
                                    end
                                else
                                    if xored < 13454 then break end

                                    xored = if xored < 13455 then list[1092] else list[list[512]]
                                end
                            end
                        end)
                        xored = list[957]
                    end
                elseif xored < 1163 then
                    tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                    xored = list[134]
                else
                    count = table[list[10](v5, list[418], list[114])]
                    xored = list[339]
                end
            elseif xored < 1178 then
                if xored < 1171 then
                    if xored < 1167 then
                        if xored < 1165 then
                            tbl5 = {
                                list[698](list[10](v23, list[58], list[307]), buffer.readu8(v5, list[312])),
                                list[698](list[10](v23, list[815], list[114]), buffer.readu8(v18, list[654])),
                                list[698](list[10](v26, list[780], list[1092]), buffer.readu8(v18, list[866])),
                                list[698](list[10](v23, list[483], list[178]), buffer.readu8(v22, list[71])),
                                list[698](list[10](v26, list[98], list[1092]), buffer.readu8(v26, list[897])),
                                list[188](list[10](v18, list[858], list[732]), buffer.readu8(v23, list[65]), buffer.readu8(v26, list[546])),
                                list[188](list[10](v23, list[844], list[793]), buffer.readu8(v26, list[579]), buffer.readu8(v5, list[37])),
                                list[698](list[10](v26, list[1112], list[532]), buffer.readu8(v5, list[546])),
                                (list[188](list[10](v23, list[920], list[885]), buffer.readu8(v22, list[425]), buffer.readu8(v26, list[71]))),
                            }

                            local v125 = tbl5[(tbl4 * buffer.readu8(v22, list[972]) + buffer.readu8(v22, list[897])) % buffer.readu8(v22, list[312]) + buffer.readu8(v5, list[642])]

                            xored = if v125 < tbl5[(tbl4 * buffer.readu8(v22, list[972]) + buffer.readu8(v22, list[897])) % buffer.readu8(v22, list[312]) + buffer.readu8(v5, list[642])] then list[452] else list[384]
                        elseif xored < 1166 then
                            tbl4 = count2
                            xored = list[882]
                        else
                            tbl5 = nil
                            tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v5, list[642])
                            tbl5 = buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[642])
                            tbl5 = buffer.readu8(v5, list[509]) - buffer.readu8(v23, list[509])
                            xored = list[272]
                        end
                    elseif xored < 1169 then
                        if xored < 1168 then
                            v53 += list[33]
                            xored = list[287]
                        else
                            local xored2 = bit32.bxor(bit32.lrotate(bit32.bxor(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v18, list[65])), string.byte(tostring(list2))), buffer.readu8(v22, list[492])), buffer.readu32(v5, list[503])), buffer.readu8(v23, list[789])), buffer.readu32(v5, list[242]))

                            xored = if xored2 == bit32.lrotate(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v18, list[65])), string.byte(tostring(list2))), buffer.readu8(v22, list[492])), buffer.readu8(v23, list[789])) then list[171] else list[116]
                        end
                    elseif xored < 1170 then
                        xored = list[609]
                    else
                        list2 = math[list[10](v26, list[525], list[114])](buffer.readu8(v26, list[37]), buffer.readu8(v5, list[642]))

                        xored = list[639]
                    end
                elseif xored < 1174 then
                    if xored < 1172 then
                        xored = list[446]
                    elseif xored < 1173 then
                        tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                        xored = list[412]
                    else
                        xored = if count <= buffer.readu8(v5, list[37]) then list[193] else list[555]
                    end
                elseif xored < 1176 then
                    if xored < 1175 then
                        tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                        xored = list[25]
                    else
                        xored = if count <= buffer.readu8(v18, list[938]) then list[90] else list[796]
                    end
                else
                    xored = if xored < 1177 then list[462] else list[842]
                end
            elseif xored < 1185 then
                if xored < 1181 then
                    if xored < 1179 then
                        tbl5 = nil
                        tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                        tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                        tbl5 = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
                        tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                        xored = list[405]
                    else
                        xored = if xored < 1180 then list[998] else list[694]
                    end
                elseif xored < 1183 then
                    xored = if xored < 1182 then list[1018] else list[873]
                else
                    xored = if xored < 1184 then list[814] else list[410]
                end
            elseif xored < 1188 then
                if xored < 1186 then
                    tbl5 = nil
                    tbl5 = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[37])
                    tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                    tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                    tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                    xored = list[144]
                elseif xored < 1187 then
                    xored = list[100]
                else
                    xored = if count > buffer.readu8(v26, list[1083]) then list[805] else list[449]
                end
            elseif xored < 1190 then
                if xored < 1189 then
                    v4 = callback18[callback3((list[698](list[10](v5, list[594], list[1092]), buffer.readu8(v5, list[897]))))]
                    v3 = list[588][callback3((list[698](list[10](v18, list[220], list[793]), buffer.readu8(v22, list[897]))))]
                    do
                        local v140 = callback3((list[698](list[10](v5, list[219], list[454]), buffer.readu8(v5, list[312]))))
                        callback7 = callback16[v140]
                    end
                    do
                        local v140 = callback3((list[698](list[10](v26, list[678], list[221]), buffer.readu8(v22, list[71]))))
                        v19 = callback16[v140]
                    end
                    local v140 = callback3((list[188](list[10](v18, list[400], list[978]), buffer.readu8(v26, list[938]), buffer.readu8(v26, list[37]))))
                    v35 = callback16[v140]

                    xored = list[817]
                else
                    local xored2 = bit32.bxor(bit32.bxor(bit32.bxor(bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[938])), string.byte(tostring(v6))), buffer.readu8(v22, list[1083])), buffer.readu32(v5, list[161])), buffer.readu32(v22, list[511])), bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[938])), string.byte(tostring(v6))), buffer.readu8(v22, list[1083])), buffer.readu32(v5, list[28])), buffer.readu32(v22, list[152]))), buffer.readu32(v22, list[511])), buffer.readu32(v22, list[152]))

                    xored = if xored2 == bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[938])), string.byte(tostring(v6))), buffer.readu8(v22, list[1083])) then list[204] else list[295]
                end
            elseif xored < 1191 then
                tbl4 = (tbl4 + buffer.readu8(v26, list[938])) % buffer.readu8(v18, list[789])
                xored = list[782]
            else
                xored = list[636]
            end
        elseif xored < 1220 then
            if xored < 1206 then
                if xored < 1199 then
                    if xored < 1195 then
                        if xored < 1193 then
                            list2 = (list2 + buffer.readu8(v5, list[564])) % buffer.readu8(v23, list[789])
                            xored = list[828]
                        elseif xored < 1194 then
                            tbl4 = (tbl4 + buffer.readu8(v5, list[642])) % buffer.readu8(v5, list[509])
                            xored = list[617]
                        else
                            version2 = list[947](math[list[10](v26, list[525], list[114])](buffer.readu8(v5, list[642]), buffer.readu8(v26, list[37])), buffer.readu32(v23, list[992]))

                            xored = list[77]
                        end
                    elseif xored < 1197 then
                        if xored < 1196 then
                            local v140 = tbl4 * buffer.readu32(v26, list[161]) + buffer.readu8(v23, list[866]) + buffer.readu8(v23, list[509])

                            xored = if v140 <= tbl4 * buffer.readu32(v26, list[161]) + buffer.readu8(v23, list[866]) + buffer.readu8(v23, list[509]) + buffer.readu8(v5, list[642]) then list[1031] else list[1111]
                        else
                            flag = version2 < buffer.readu8(v23, list[425])
                            xored = if flag then list[896] else list[980]
                        end
                    elseif xored < 1198 then
                        v40 = tbl4
                        v55 = v54
                        list[423][list[698](list[10](v18, list[183], list[1002]), buffer.readu8(v26, list[861]))](buffer.readu8(v26, list[509]))

                        xored = list[489]
                    else
                        xored = list[1066]
                    end
                elseif xored < 1202 then
                    if xored < 1200 then
                        xored = if str <= buffer.readu8(v5, list[990]) then list[420] else list[75]
                    elseif xored < 1201 then
                        xored = list[168]
                    else
                        tbl5 = nil
                        tbl5 = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
                        tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                        tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                        tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                        xored = list[373]
                    end
                elseif xored < 1204 then
                    if xored < 1203 then
                        callback14 = nil
                        version2 = nil
                        list2 = nil
                        list2 = buffer.readu8(v5, list[509])
                        xored = list[446]
                    else
                        tbl2 = {}
                        local v148 = buffer.readu8(v5, list[642])
                        tbl2[v148] = tbl2
                        tbl = list[355]
                        xored = list[513]
                    end
                elseif xored < 1205 then
                    count = version2
                    xored = if count then list[339] else list[650]
                else
                    xored = list[676]
                end
            elseif xored < 1213 then
                if xored < 1209 then
                    if xored < 1207 then
                        do
                            local v148 = callback7(callback7)
                            tbl5 = v3[v148]
                        end

                        v19 = nil
                        v43 = callback7((list[698](list[10](v23, list[562], list[793]), buffer.readu8(v26, list[425]))))
                        v35 = list[588][v43]
                        v4 = callback18[callback7(callback7)]
                        do
                            local v151 = callback18[callback7(tbl5)]
                        end
                        callback3 = callback7
                        local v151 = callback18[callback7(list[588])]
                        callback16 = v43
                        xored = list[817]
                    elseif xored < 1208 then
                        v10 = list[799]
                        callback17 = list[823]
                        object = list[590]
                        xored = list[675]
                    else
                        v50 = v49
                        xored = if list[195](list[709][list[188](list[10](v18, list[1067], list[1068]), buffer.readu8(v5, list[875]), buffer.readu8(v23, list[866]))](v42), buffer.readu8(v18, list[938]), buffer.readu32(v23, list[428])) then list[411] else list[626]
                    end
                elseif xored < 1211 then
                    if xored < 1210 then
                        tbl4 = nil
                        tbl4 = buffer.readu8(v5, list[509]) - buffer.readu8(v5, list[990])
                        xored = list[430]
                    else
                        xored = list[436]
                    end
                elseif xored < 1212 then
                    callback15 = list[588][callback3((list[188](list[10](v23, list[529], list[726]), buffer.readu8(v5, list[789]), buffer.readu8(v26, list[71]))))]

                    xored = list[591]
                else
                    callback14 = math[list[10](v26, list[525], list[114])](buffer.readu8(v5, list[642]), buffer.readu8(v26, list[37]))

                    xored = list[77]
                end
            elseif xored < 1216 then
                if xored < 1214 then
                    local xored2 = bit32.bxor(bit32.lrotate(bit32.bxor(bit32.rrotate(bit32.bxor(bit32.lrotate(count, buffer.readu8(v5, list[544])), string.byte(tostring(v10))), buffer.readu8(v23, list[789])), buffer.readu32(v18, list[426])), buffer.readu8(v26, list[37])), buffer.readu32(v26, list[733]))

                    xored = if xored2 == bit32.lrotate(bit32.rrotate(bit32.bxor(bit32.lrotate(count, buffer.readu8(v5, list[544])), string.byte(tostring(v10))), buffer.readu8(v23, list[789])), buffer.readu8(v26, list[37])) then list[1042] else list[819]
                elseif xored < 1215 then
                    xored = list[899]
                else
                    tbl4 = (tbl4 + buffer.readu8(v22, list[71])) % buffer.readu8(v18, list[789])
                    xored = list[837]
                end
            elseif xored < 1218 then
                if xored < 1217 then
                    xored = list[814]
                else
                    tbl4 = callback14
                    xored = list[413]
                end
            else
                xored = if xored < 1219 then list[703] else list[251]
            end
        elseif xored < 1234 then
            if xored < 1227 then
                if xored < 1223 then
                    if xored < 1221 then
                        str = list[588][list[698](list[10](v22, list[962], list[221]), buffer.readu8(v26, list[866]))]
                        v24 = list[588]
                        local v154 = list[698](list[10](v23, list[1046], list[221]), buffer.readu8(v18, list[897]))
                        local v155 = v24[v154]
                        list2 = v24
                        local v156 = list[188](list[10](v26, list[580], list[454]), buffer.readu8(v5, list[546]), buffer.readu8(v5, list[509]))
                        local v157 = v24[v156]

                        v17 = str
                        xored = list[114]
                    elseif xored < 1222 then
                        v49 = v48
                        xored = list[755]
                    else
                        list2 = list[947](math[list[10](v26, list[525], list[114])](buffer.readu8(v5, list[642]), buffer.readu8(v26, list[37])), buffer.readu32(v23, list[992]))

                        xored = list[639]
                    end
                elseif xored < 1225 then
                    if xored < 1224 then
                        callback18 = list[910][list[698](list[10](v18, list[1112], list[532]), buffer.readu8(v18, list[897]))]()
                        xored = list[419]
                    else
                        callback19 = nil
                        version3 = count3
                        xored = list[1003]
                    end
                else
                    xored = if xored < 1226 then list[138] else list[1054]
                end
            elseif xored < 1230 then
                if xored < 1228 then
                    xored = if str <= buffer.readu8(v5, list[642]) then list[616] else list[521]
                elseif xored < 1229 then
                    xored = list[406]
                else
                    v50 = v49
                    callback9((list[188](list[10](v18, list[587], list[126]), buffer.readu8(v18, list[312]), buffer.readu8(v5, list[990]))))

                    xored = list[626]
                end
            elseif xored < 1232 then
                if xored < 1231 then
                    xored = if str <= buffer.readu8(v26, list[37]) then list[255] else list[47]
                else
                    version2 = nil
                    v25 = nil
                    env2 = nil
                    env = nil
                    callback17 = nil
                    tbl4 = nil
                    object = nil
                    list2 = nil
                    list2 = buffer.readu8(v26, list[509])
                    xored = list[1044]
                end
            elseif xored < 1233 then
                count2 = tbl4
                flag = list2
                callback18 = count
                count3 = nil
                xored = list[382]
            else
                tbl5 = {
                    list[188](list[10](v18, list[979], list[262]), buffer.readu8(v26, list[425]), buffer.readu8(v5, list[564])),
                    list[188](list[10](v26, list[507], list[650]), buffer.readu8(v26, list[579]), buffer.readu8(v18, list[938])),
                    list[188](list[10](v5, list[687], list[1068]), buffer.readu8(v23, list[875]), buffer.readu8(v18, list[37])),
                    list[698](list[10](v5, list[800], list[221]), buffer.readu8(v26, list[789])),
                    list[188](list[10](v23, list[1101], list[126]), buffer.readu8(v26, list[938]), buffer.readu8(v23, list[789])),
                    list[698](list[10](v23, list[1064], list[221]), buffer.readu8(v5, list[546])),
                    list[188](list[10](v26, list[925], list[105]), buffer.readu8(v22, list[897]), buffer.readu8(v22, list[492])),
                    list[698](list[10](v5, list[485], list[307]), buffer.readu8(v5, list[312])),
                    (list[188](list[10](v18, list[231], list[221]), buffer.readu8(v18, list[546]), buffer.readu8(v5, list[37]))),
                }

                local v161 = tbl5[(tbl4 * buffer.readu8(v26, list[37]) + buffer.readu8(v18, list[425])) % buffer.readu8(v22, list[312]) + buffer.readu8(v5, list[642])]

                xored = if v161 <= tbl5[(tbl4 * buffer.readu8(v26, list[37]) + buffer.readu8(v18, list[425])) % buffer.readu8(v22, list[312]) + buffer.readu8(v5, list[642])] then list[254] else list[103]
            end
        elseif xored < 1241 then
            if xored < 1237 then
                if xored < 1235 then
                    list2 = version2
                    callback(v41, buffer.readu8(v26, list[37]), tbl4)
                    tbl4 = nil
                    xored = list[137]
                else
                    xored = if xored < 1236 then list[512] else list[297]
                end
            elseif xored < 1239 then
                if xored < 1238 then
                    local v161 = callback18(callback11)
                    local v162 = callback11[v161]
                    callback3 = callback18(callback11)
                    xored = list[276]
                else
                    xored = list[967]
                end
            else
                xored = if xored < 1240 then list[691] else list[168]
            end
        elseif xored < 1245 then
            if xored < 1243 then
                if xored < 1242 then
                    v50 = v49
                    tbl4 = {
                        list[698](list[10](v22, list[1122], list[307]), buffer.readu8(v23, list[230])),
                        list[188](list[10](v26, list[618], list[469]), buffer.readu8(v26, list[544]), buffer.readu8(v5, list[564])),
                        list[698](list[10](v22, list[1046], list[221]), buffer.readu8(v5, list[897])),
                        list[698](list[10](v18, list[524], list[793]), buffer.readu8(v18, list[1083])),
                        list[698](list[10](v18, list[912], list[532]), buffer.readu8(v22, list[509])),
                        list[698](list[10](v23, list[973], list[307]), buffer.readu8(v5, list[875])),
                        list[698](list[10](v22, list[705], list[221]), buffer.readu8(v23, list[230])),
                        (list[698](list[10](v18, list[911], list[532]), buffer.readu8(v22, list[579]))),
                    }

                    count2 = tbl4[list2 % buffer.readu8(v5, list[509]) + buffer.readu8(v5, list[642])]
                    tbl4 = list2 % buffer.readu8(v5, list[37]) + buffer.readu8(v26, list[37])

                    flag = count2[list[188](list[10](v18, list[648], list[115]), buffer.readu8(v26, list[866]), buffer.readu8(v23, list[861]))](count2)

                    local v166 = tbl4

                    tbl4 = count2[list[188](list[10](v5, list[113], list[656]), buffer.readu8(v26, list[789]), buffer.readu8(v23, list[861]))](count2)

                    callback18 = flag[list[188](list[10](v22, list[208], list[1092]), buffer.readu8(v23, list[679]), buffer.readu8(v26, list[37]))](flag, v166)

                    xored = if tbl4 >= callback18[list[188](list[10](v18, list[269], list[116]), buffer.readu8(v5, list[546]), buffer.readu8(v26, list[990]))](callback18) then list[894] else list[261]
                else
                    xored = list[774]
                end
            elseif xored < 1244 then
                version2 = list[730]
                xored = list[931]
            else
                xored = list[520]
            end
        elseif xored < 1247 then
            if xored < 1246 then
                xored = if list[947]((list2 * buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[642])) % buffer.readu8(v23, list[789]), buffer.readu32(v5, list[444])) then list[916] else list[126]
            else
                xored = list[289]
            end
        elseif xored < 1248 then
            xored = list[301]
        else
            tbl5 = nil
            tbl5 = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
            tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
            xored = list[653]
        end
    else
        local fn2, tbl6
        if xored < 1436 then
            if xored < 1305 then
                if xored < 1277 then
                    if xored < 1263 then
                        if xored < 1256 then
                            if xored < 1252 then
                                if xored < 1250 then
                                    xored = list[786]
                                elseif xored < 1251 then
                                    version3 = {
                                        callback3((list[698](list[10](v23, list[1104], list[30]), buffer.readu8(v26, list[654])))),
                                        callback3((list[698](list[10](v23, list[322], list[454]), buffer.readu8(v18, list[425])))),
                                        callback3((list[188](list[10](v5, list[1026], list[731]), buffer.readu8(v23, list[642]), buffer.readu8(v26, list[875])))),
                                        callback3((list[698](list[10](v23, list[102], list[30]), buffer.readu8(v23, list[642])))),
                                        callback3((list[188](list[10](v18, list[573], list[703]), buffer.readu8(v18, list[654]), buffer.readu8(v26, list[990])))),
                                        callback3((list[188](list[10](v5, list[893], list[469]), buffer.readu8(v22, list[509]), buffer.readu8(v5, list[544])))),
                                        callback3((list[188](list[10](v23, list[530], list[731]), buffer.readu8(v5, list[312]), buffer.readu8(v26, list[65])))),
                                        callback3((list[698](list[10](v22, list[735], list[1068]), buffer.readu8(v22, list[65])))),
                                        callback3((list[188](list[10](v23, list[625], list[1088]), buffer.readu8(v23, list[71]), buffer.readu8(v26, list[546])))),
                                        callback3((list[698](list[10](v5, list[102], list[30]), buffer.readu8(v5, list[71])))),
                                        callback3((list[188](list[10](v18, list[84], list[311]), buffer.readu8(v5, list[875]), buffer.readu8(v22, list[492])))),
                                        callback3((list[698](list[10](v5, list[164], list[978]), buffer.readu8(v26, list[425])))),
                                        callback3((list[188](list[10](v22, list[778], list[1088]), buffer.readu8(v18, list[425]), buffer.readu8(v26, list[509])))),
                                        callback3((list[698](list[10](v18, list[572], list[732]), buffer.readu8(v18, list[654])))),
                                        callback3((list[698](list[10](v23, list[256], list[1068]), buffer.readu8(v5, list[875])))),
                                        callback3((list[698](list[10](v26, list[330], list[1068]), buffer.readu8(v5, list[71])))),
                                        callback3((list[188](list[10](v18, list[481], list[276]), buffer.readu8(v22, list[1120]), buffer.readu8(v5, list[564])))),
                                        callback3((list[698](list[10](v26, list[345], list[712]), buffer.readu8(v18, list[425])))),
                                        callback3((list[698](list[10](v26, list[872], list[817]), buffer.readu8(v26, list[579])))),
                                        callback3((list[698](list[10](v18, list[1073], list[817]), buffer.readu8(v26, list[425])))),
                                        callback3((list[188](list[10](v26, list[259], list[1088]), buffer.readu8(v26, list[654]), buffer.readu8(v5, list[509])))),
                                        callback3((list[698](list[10](v5, list[433], list[817]), buffer.readu8(v18, list[425])))),
                                    }

                                    xored = list[940]
                                else
                                    local xored2 = bit32.bxor(bit32.lrotate(bit32.bxor(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v22, list[861])), string.byte(tostring(v6))), buffer.readu8(v22, list[642])), buffer.readu32(v5, list[733])), buffer.readu8(v22, list[642])), buffer.readu32(v23, list[63]))

                                    xored = if xored2 == bit32.lrotate(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v22, list[861])), string.byte(tostring(v6))), buffer.readu8(v22, list[642])), buffer.readu8(v22, list[642])) then list[1028] else list[531]
                                end
                            elseif xored < 1254 then
                                if xored < 1253 then
                                    do
                                        local v170 = callback16((list[698](list[10](v26, list[570], list[115]), buffer.readu8(v5, list[897]))))
                                        tbl5 = v33[v170]
                                    end

                                    version2 = nil
                                    do
                                        local v172 = list[588][callback16((list[698](list[10](v26, list[321], list[708]), buffer.readu8(v22, list[897]))))]
                                    end

                                    callback3 = callback16((list[698](list[10](v26, list[321], list[708]), buffer.readu8(v22, list[897]))))
                                    local v172 = list[588][callback16(list[588])]
                                    object = tbl5
                                    xored = list[207]
                                else
                                    tbl5 = nil
                                    tbl5 = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[642])
                                    tbl5 = buffer.readu8(v26, list[37]) + buffer.readu8(v5, list[642])
                                    tbl5 = buffer.readu8(v5, list[509]) - buffer.readu8(v26, list[37])
                                    tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v23, list[509])
                                    tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v26, list[37])
                                    tbl5 = buffer.readu8(v26, list[37]) + buffer.readu8(v5, list[642])
                                    xored = list[956]
                                end
                            elseif xored < 1255 then
                                tbl5 = nil
                                tbl5 = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[37])
                                xored = list[971]
                            else
                                xored = list[1098]
                            end
                        elseif xored < 1259 then
                            if xored < 1257 then
                                xored = if str <= buffer.readu8(v26, list[509]) then list[364] else list[124]
                            elseif xored < 1258 then
                                tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                                xored = list[194]
                            else
                                callback13 = string[list[10](v23, list[1040], list[114])]
                                v29 = callback3((list[698](list[10](v23, list[810], list[708]), buffer.readu8(v23, list[71]))))
                                xored = list[1105]
                            end
                        elseif xored < 1261 then
                            if xored < 1260 then
                                xored = if version3 > buffer.readu8(v26, list[1083]) then list[696] else list[1070]
                            else
                                str += buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083])
                                xored = list[563]
                            end
                        elseif xored < 1262 then
                            v50 = v49
                            env2 = setmetatable({}, {
                                [list[698](list[10](v26, list[50], list[221]), buffer.readu8(v22, list[897]))] = list[802],
                                [list[188](list[10](v23, list[164], list[978]), buffer.readu8(v5, list[312]), buffer.readu8(v18, list[37]))] = list[110],
                                [list[188](list[10](v26, list[192], list[262]), buffer.readu8(v5, list[312]), buffer.readu8(v22, list[312]))] = list[754],
                            })

                            xored = list[477]
                        else
                            xored = if str <= buffer.readu8(v22, list[861]) then list[380] else list[439]
                        end
                    elseif xored < 1270 then
                        if xored < 1266 then
                            if xored < 1264 then
                                str = (tbl4 * buffer.readu8(v23, list[789]) + buffer.readu8(v26, list[37])) % buffer.readu8(v26, list[875]) + buffer.readu8(v5, list[642])
                                xored = list[467]
                            else
                                xored = if xored < 1265 then list[436] else list[196]
                            end
                        elseif xored < 1268 then
                            if xored < 1267 then
                                xored = list[346]
                            else
                                callback(v41, buffer.readu8(v5, list[642]), callback20, version2)
                                v50 = v49

                                callback20 = callback20 + v40[list[188](list[10](v22, list[958], list[732]), buffer.readu8(v26, list[938]), buffer.readu8(v26, list[37]))][list[698](list[10](v22, list[815], list[114]), buffer.readu8(v22, list[1120]))] + list[588][list[698](list[10](v22, list[275], list[114]), buffer.readu8(v22, list[1120]))] + list[588][list[188](list[10](v5, list[237], list[712]), buffer.readu8(v18, list[425]), buffer.readu8(v5, list[509]))] + list[588][list[188](list[10](v18, list[620], list[262]), buffer.readu8(v23, list[642]), buffer.readu8(v23, list[866]))]

                                xored = list[421]
                            end
                        else
                            xored = if xored < 1269 then list[712] else list[486]
                        end
                    elseif xored < 1273 then
                        if xored < 1271 then
                            xored = list[1079]
                        elseif xored < 1272 then
                            object = list[799]
                            v10 = list[823]
                            callback17 = list[590]
                            xored = list[675]
                        else
                            local v184 = (tbl4 * buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[1083])) % buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[642])
                            xored = list[978]
                        end
                    elseif xored < 1275 then
                        if xored < 1274 then
                            xored = list[636]
                        else
                            table[list[10](v22, list[1040], list[114])](env2)
                            env = getfenv()
                            xored = list[710]
                        end
                    else
                        xored = if xored < 1276 then list[884] else list[1125]
                    end
                elseif xored < 1291 then
                    if xored < 1284 then
                        if xored < 1280 then
                            if xored < 1278 then
                                callback12 = list[127][callback3((list[188](list[10](v18, list[487], list[304]), buffer.readu8(v18, list[897]), buffer.readu8(v18, list[65]))))][callback3((list[188](list[10](v23, list[400], list[712]), buffer.readu8(v22, list[897]), buffer.readu8(v5, list[544]))))]

                                xored = list[262]
                            elseif xored < 1279 then
                                xored = list[395]
                            else
                                v42 = callback14(list[863])
                                callback17 = callback14(list[374])
                                xored = list[838]
                            end
                        elseif xored < 1282 then
                            if xored < 1281 then
                                tbl5 = nil
                                tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                                tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                                xored = list[352]
                            else
                                xored = list[767]
                            end
                        elseif xored < 1283 then
                            tbl5 = nil
                            tbl5 = buffer.readu8(v18, list[37]) - buffer.readu8(v5, list[990])
                            xored = list[831]
                        else
                            xored = if str <= buffer.readu8(v23, list[789]) then list[597] else list[33]
                        end
                    elseif xored < 1287 then
                        if xored < 1285 then
                            xored = list[86]
                        elseif xored < 1286 then
                            v50 = v49
                            env2[list[188](list[10](v5, list[977], list[469]), buffer.readu8(v18, list[866]), buffer.readu8(v22, list[492]))] = env2

                            setfenv(setfenv, setmetatable(list[188](list[10](v23, list[69], list[732]), buffer.readu8(v18, list[425]), buffer.readu8(v23, list[509])), env))

                            xored = list[353]
                        else
                            v20 = list[1132]
                            v21 = list[1041]
                            v13 = list[690]
                            v16 = table[list[10](v22, list[753], list[114])](buffer.readu8(v26, list[1083]), list[1041])
                            xored = list[727]
                        end
                    elseif xored < 1289 then
                        if xored < 1288 then
                            xored = if count <= buffer.readu8(v5, list[642]) then list[221] else list[387]
                        else
                            tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                            xored = list[830]
                        end
                    elseif xored < 1290 then
                        flag = version2 - buffer.readu8(v23, list[425])
                        xored = list[836]
                    else
                        local xored2 = bit32.bxor(bit32.lrotate(bit32.bxor(bit32.rrotate(bit32.bxor(bit32.lrotate(list2, buffer.readu8(v22, list[642])), string.byte(tostring(v25))), buffer.readu8(v22, list[1083])), buffer.readu32(v23, list[584])), buffer.readu8(v22, list[861])), buffer.readu32(v26, list[951]))

                        xored = if xored2 == bit32.lrotate(bit32.rrotate(bit32.bxor(bit32.lrotate(list2, buffer.readu8(v22, list[642])), string.byte(tostring(v25))), buffer.readu8(v22, list[1083])), buffer.readu8(v22, list[861])) then list[153] else list[3]
                    end
                elseif xored < 1298 then
                    if xored < 1294 then
                        if xored < 1292 then
                            list2 = (list2 + buffer.readu8(v18, list[37])) % buffer.readu8(v5, list[1057])
                            xored = list[377]
                        elseif xored < 1293 then
                            v25 = tbl4
                            tbl4 = nil
                            xored = list[571]
                        else
                            callback14 = callback23(list[739])
                            count3 = callback23(function(arg1, arg2) -- line 6605 · shares: [1] v5, [2] v24, [3] v18, [4] callback14, [5] v38, [6] list, [7] callback3, [8] callback9, [9] v17, [10] v22, [11] v23, [12] v39
                                if not arg2 then
                                    ({})[1] = v5;
                                    ({})[2] = v24;
                                    ({})[3] = v18;
                                    ({})[4] = callback14;
                                    ({})[5] = v38;
                                    ({})[6] = list;
                                    ({})[7] = callback3;
                                    ({})[8] = callback9;
                                    ({})[9] = v17;
                                    ({})[10] = v22;
                                    ({})[11] = v23;
                                    ({})[12] = v39;
                                    ({})[13] = arg1;
                                    ({})[14] = arg2
                                end

                                local v, v2, v3, v4, v6
                                local xored
                                xored = list[list[885]]

                                while true do
                                    xored = bit32.bxor(xored, list[725])

                                    if xored < 13443 then
                                        if xored < 13056 then break end

                                        if xored < 13441 then
                                            if xored < 13440 then break end

                                            xored = list[list[819]]
                                        else
                                            xored = if xored < 13442 then list[list[267]] else list[532]
                                        end
                                    elseif xored < 13447 then
                                        if xored < 13445 then
                                            if xored < 13444 then
                                                v4, v6, v3 = v24(v2)
                                                xored = if v3 == nil then list[935] else list[793]
                                            else
                                                callback9(list[list[737]](list[list[708]](v18, list[list[368]], list[785]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v18, list[list[305]])), {v4, v6})

                                                xored = list[793]
                                            end
                                        elseif xored < 13446 then
                                            v2 = v38[callback3((list[list[737]](list[list[708]](v5, list[573], list[list[227]]), buffer.readu8(v5, list[1057]), buffer.readu8(v5, list[938]))))]

                                            local v8 = v17(v2, function(arg1, arg2, arg3, arg4) -- line 6655 · shares: [1] v23, [2] list, [3] callback9
                                                if not arg4 then
                                                    ({})[1] = v23;
                                                    ({})[2] = list;
                                                    ({})[3] = callback9;
                                                    ({})[4] = arg1;
                                                    ({})[5] = arg2;
                                                    ({})[6] = arg3;
                                                    ({})[7] = arg4
                                                end

                                                local xored
                                                xored = list[532]

                                                while true do
                                                    xored = bit32.bxor(xored, list[list[262]])

                                                    if not (xored < 7111) then break end
                                                    if xored < 1431 then
                                                        if xored < 1429 then
                                                            if xored ~= 1428 then break end
                                                            xored = list[935]
                                                        else
                                                            if not (xored < 1430) then break end
                                                            callback9(list[list[737]](list[515], buffer.readu8(v23, list[990]), list[935]), {arg1, arg2})

                                                            xored = list[801]
                                                        end
                                                    else
                                                        if not (xored < 4751 and xored < 3152) or xored ~= 1431 then
                                                            break
                                                        end

                                                        xored = if arg3 == nil then list[list[885]] else list[801]
                                                    end
                                                end
                                            end)
                                            callback14(function(arg1, arg2, arg3) -- line 6706 · shares: [1] v18, [2] v5, [3] v8, [4] list, [5] callback9, [6] v23, [7] v22
                                                if not arg3 then
                                                    ({})[1] = v18;
                                                    ({})[2] = v5;
                                                    ({})[3] = v8;
                                                    ({})[4] = list;
                                                    ({})[5] = callback9;
                                                    ({})[6] = v23;
                                                    ({})[7] = arg1;
                                                    ({})[8] = arg2;
                                                    ({})[9] = arg3
                                                end

                                                local xored
                                                xored = list[list[819]]

                                                while true do
                                                    xored = bit32.bxor(xored, list[960])

                                                    if xored < 15393 then
                                                        return
                                                    elseif xored < 16292 then
                                                        if xored < 16289 then
                                                            if xored < 16288 then
                                                                return
                                                            end

                                                            xored = list[532]
                                                        elseif xored < 16290 then
                                                            xored = list[1092]
                                                        elseif xored < 16291 then
                                                            xored = if not v8[list[698](list[list[567]], buffer.readu8(v5, list[875]))] then list[935] else list[801]
                                                        else
                                                            xored = list[list[512]]
                                                        end
                                                    elseif xored < 16295 then
                                                        if xored < 16293 then
                                                            callback9((list[698](list[list[708]](v18, list[942], list[1088]), buffer.readu8(v22, list[579]))))

                                                            xored = list[801]
                                                        else
                                                            xored = if xored < 16294 then list[list[885]] else list[list[267]]
                                                        end
                                                    elseif xored < 16302 then
                                                        if xored ~= 16295 then break end

                                                        xored = if list[list[1096]][list[698](list[list[708]](v23, list[list[905]], list[1002]), buffer.readu8(v22, list[list[832]]))](buffer.readf64(v5, list[list[68]])) then list[1002] else list[list[378]]
                                                    else
                                                        if xored < 16303 then
                                                            return
                                                        end

                                                        xored = list[532]
                                                    end
                                                end
                                            end)
                                            xored = list[list[819]]
                                        else
                                            xored = if v4[list[list[737]](list[list[708]](v5, list[list[352]], list[list[798]]), buffer.readu8(v23, list[642]), buffer.readu8(v22, list[544]))](v4, v39) then list[1002] else list[801]
                                        end
                                    elseif xored < 13453 then
                                        if xored < 13452 then
                                            if xored ~= 13447 then break end
                                            xored = list[list[378]]
                                        else
                                            xored = list[list[819]]
                                        end
                                    else
                                        if xored < 13454 then break end

                                        xored = if xored < 13455 then list[1092] else list[list[512]]
                                    end
                                end
                            end)
                            xored = list[957]
                        end
                    elseif xored < 1296 then
                        if xored < 1295 then
                            tbl4 = (tbl4 + buffer.readu8(v26, list[938])) % buffer.readu8(v18, list[789])
                            xored = list[300]
                        else
                            count2 = callback4(count2, buffer.readu32(v18, list[552]))
                            xored = if count2 < buffer.readu8(v26, list[1083]) then list[381] else list[307]
                        end
                    elseif xored < 1297 then
                        xored = list[726]
                    else
                        count3 = callback19
                        count2 = #count3
                        buffer[list[10](v18, list[496], list[307])](flag, callback18, count2)
                        callback18 += buffer.readu8(v26, list[37])
                        buffer[list[10](v22, list[335], list[793])](flag, callback18, count3)
                        callback18 += count2
                        buffer[list[10](v23, list[485], list[307])](flag, callback18, version3)
                        callback18 += buffer.readu8(v18, list[938])
                        version2 = callback18
                        xored = list[1082]
                    end
                elseif xored < 1301 then
                    if xored < 1299 then
                        xored = list[398]
                    elseif xored < 1300 then
                        count = v31
                        local v191 = list[709][list[698](list[10](v26, list[791], list[1002]), buffer.readu8(v23, list[875]))]
                        v7 = list[709]
                        xored = list[929]
                    else
                        str = callback4(str, buffer.readu32(v18, list[552]))
                        xored = if str < buffer.readu8(v26, list[1083]) then list[416] else list[637]
                    end
                elseif xored < 1303 then
                    if xored < 1302 then
                        xored = list[656]
                    else
                        tbl5 = nil
                        tbl5 = buffer.readu8(v26, list[509]) - buffer.readu8(v23, list[509])
                        tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v18, list[938])
                        xored = list[904]
                    end
                elseif xored < 1304 then
                    tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                    xored = list[424]
                else
                    xored = list[1109]
                end
            elseif xored < 1335 then
                if xored < 1319 then
                    if xored < 1312 then
                        if xored < 1308 then
                            if xored < 1306 then
                                local xored2 = bit32.bxor(bit32.lrotate(bit32.bxor(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[990])), string.byte(tostring(v24))), buffer.readu8(v23, list[866])), buffer.readu32(v23, list[599])), buffer.readu8(v22, list[492])), buffer.readu32(v5, list[1039]))

                                xored = if xored2 == bit32.lrotate(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[990])), string.byte(tostring(v24))), buffer.readu8(v23, list[866])), buffer.readu8(v22, list[492])) then list[487] else list[701]
                            elseif xored < 1307 then
                                v57 = v56
                                v50 = v49

                                tbl5 = callback20[list[188](list[10](v18, list[146], list[307]), buffer.readu8(v26, list[866]), buffer.readu8(v18, list[938]))](callback20, v57)

                                str ..= string[list[10](v22, list[999], list[1002])](bit32[list[10](v22, list[671], list[1002])](tbl5, count2[(v57 - buffer.readu8(v5, list[642])) % #count2 + buffer.readu8(v5, list[642])]))

                                xored = list[85]
                            else
                                count = nil
                                count = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                                count = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                                count = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                                xored = list[1089]
                            end
                        elseif xored < 1310 then
                            if xored < 1309 then
                                local v201 = tbl4 * buffer.readu32(v18, list[839]) + buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[37])

                                xored = if v201 >= tbl4 * buffer.readu32(v18, list[839]) + buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[37]) + buffer.readu8(v5, list[642]) then list[93] else list[454]
                            else
                                xored = list[1027]
                            end
                        elseif xored < 1311 then
                            count = list[600]()
                            tbl4 = buffer[list[10](v22, list[753], list[114])](buffer.readu16(v5, list[707]))
                            list2 = buffer.readu8(v26, list[1083])
                            version2 = nil
                            xored = list[1004]
                        else
                            tbl4 = nil
                            tbl4 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                            xored = list[526]
                        end
                    elseif xored < 1315 then
                        if xored < 1313 then
                            tbl4 = list2
                            xored = if tbl4 then list[785] else list[841]
                        elseif xored < 1314 then
                            list2 = v14
                            version2 = v40
                            count2 = v25
                            flag = {}
                            callback18 = buffer.readu8(v5, list[642])
                            count3 = buffer.readu8(v23, list[789])
                            v53 = callback18
                            v51 = count3
                            xored = list[1110]
                        else
                            v15 = nil
                            callback9 = list[414]
                            v37 = list[112](true)
                            count2 = nil
                            getmetatable(v37)[list[188](list[10](v5, list[495], list[115]), buffer.readu8(v5, list[613]), buffer.readu8(v22, list[492]))] = list[649]

                            callback21 = list[376]
                            xored = list[147]
                        end
                    elseif xored < 1317 then
                        if xored < 1316 then
                            tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                            xored = list[18]
                        else
                            xored = list[131]
                        end
                    elseif xored < 1318 then
                        str = nil
                        str = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                        xored = list[966]
                    else
                        callback18 = flag
                        xored = if callback18 then list[409] else list[948]
                    end
                elseif xored < 1326 then
                    if xored < 1322 then
                        if xored < 1320 then
                            callback20 = callback18
                            count3 = v25
                            v50 = v49

                            str = list[188](list[10](v26, list[969], list[801]), buffer.readu8(v18, list[546]), buffer.readu8(v26, list[1083]))

                            tbl5 = callback20[list[698](list[10](v5, list[912], list[532]), buffer.readu8(v18, list[579]))](callback20)
                            v43 = buffer.readu8(v5, list[642])
                            v53 = v43
                            v51 = tbl5
                            xored = list[287]
                        elseif xored < 1321 then
                            tbl5 = list[197]((tbl4 * buffer.readu8(v5, list[990]) + buffer.readu8(v22, list[312])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v5, list[642]) + buffer.readu8(v23, list[509])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[509])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                            v43 = list[197]((tbl4 * buffer.readu8(v26, list[37]) + buffer.readu8(v5, list[642])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v22, list[312]) + buffer.readu8(v5, list[37])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v22, list[312]) + buffer.readu8(v23, list[509])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                            v44 = list[197]((tbl4 * buffer.readu8(v18, list[938]) + buffer.readu8(v5, list[642])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v23, list[509]) + buffer.readu8(v5, list[642])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v26, list[546]) + buffer.readu8(v5, list[37])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                            v45 = list[197]((tbl4 * buffer.readu8(v18, list[938]) + buffer.readu8(v26, list[546])) % buffer.readu8(v5, list[990]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v5, list[990]) + buffer.readu8(v23, list[509])) % buffer.readu8(v26, list[546]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[37])) % buffer.readu8(v22, list[312]) + buffer.readu8(v5, list[642]))

                            local v211 = vector.dot(vector.cross(tbl5, vector.cross(v43, v44)), v45)

                            xored = if v211 == vector.dot(v43 * vector.dot(tbl5, v44) - v44 * vector.dot(tbl5, v43), v45) + buffer.readu8(v5, list[642]) then list[833] else list[123]
                        else
                            v26 = list[716](list[225])
                            v18 = list[716](list[451])
                            v5 = list[716](list[233])
                            v23 = list[716](list[453])
                            v22 = list[716](list[797])
                            v27 = script[list[188](list[10](v22, list[199], list[817]), buffer.readu8(v18, list[897]), buffer.readu8(v5, list[544]))]

                            v39 = script[list[698](list[10](v22, list[781], list[793]), buffer.readu8(v22, list[509]))](script)
                            v40 = getfenv()[list[698](list[10](v18, list[744], list[114]), buffer.readu8(v5, list[71]))]
                            v40[list[698](list[10](v22, list[334], list[221]), buffer.readu8(v26, list[654]))](v40)
                            getfenv()[list[698](list[10](v23, list[275], list[114]), buffer.readu8(v23, list[1057]))] = nil
                            script = nil

                            tbl3 = {
                                buffer.readu8(v26, list[1083]),
                                buffer.readu32(v22, list[478]),
                                buffer.readu32(v26, list[1039]),
                                buffer.readu32(v18, list[1114]),
                                buffer.readu32(v22, list[63]),
                                buffer.readu32(v22, list[64]),
                                buffer.readu32(v5, list[553]),
                                buffer.readu32(v22, list[599]),
                                buffer.readu32(v5, list[839]),
                                buffer.readu32(v26, list[241]),
                                buffer.readu32(v23, list[623]),
                                buffer.readu32(v26, list[309]),
                                buffer.readu32(v18, list[581]),
                                buffer.readu32(v22, list[892]),
                                buffer.readu32(v5, list[296]),
                                buffer.readu32(v23, list[1001]),
                                buffer.readu32(v5, list[663]),
                                buffer.readu32(v18, list[118]),
                                buffer.readu32(v5, list[631]),
                                buffer.readu32(v18, list[241]),
                                buffer.readu32(v23, list[36]),
                                buffer.readu32(v18, list[336]),
                                buffer.readu32(v5, list[182]),
                                buffer.readu32(v5, list[118]),
                                buffer.readu32(v18, list[161]),
                                buffer.readu32(v23, list[612]),
                                buffer.readu32(v5, list[959]),
                                buffer.readu32(v22, list[927]),
                                buffer.readu32(v23, list[404]),
                                buffer.readu32(v22, list[490]),
                                buffer.readu32(v5, list[14]),
                                buffer.readu32(v5, list[154]),
                                buffer.readu32(v5, list[581]),
                                buffer.readu32(v18, list[791]),
                                buffer.readu32(v23, list[397]),
                                buffer.readu32(v22, list[1063]),
                                buffer.readu32(v23, list[519]),
                                buffer.readu32(v18, list[535]),
                                buffer.readu32(v18, list[32]),
                                buffer.readu32(v22, list[258]),
                                buffer.readu32(v18, list[263]),
                                buffer.readu32(v23, list[968]),
                                buffer.readu32(v18, list[713]),
                                buffer.readu32(v23, list[511]),
                                buffer.readu32(v22, list[608]),
                                buffer.readu32(v26, list[426]),
                                buffer.readu32(v18, list[601]),
                                buffer.readu32(v22, list[612]),
                                buffer.readu32(v26, list[665]),
                                buffer.readu32(v5, list[813]),
                                buffer.readu32(v5, list[1033]),
                                buffer.readu32(v18, list[631]),
                                buffer.readu32(v23, list[697]),
                                buffer.readu32(v26, list[989]),
                                buffer.readu32(v23, list[874]),
                                buffer.readu32(v22, list[428]),
                                buffer.readu32(v23, list[1131]),
                                buffer.readu32(v26, list[277]),
                                buffer.readu32(v18, list[313]),
                                buffer.readu32(v26, list[839]),
                                buffer.readu32(v22, list[125]),
                                buffer.readu32(v5, list[622]),
                                buffer.readu32(v18, list[622]),
                                buffer.readu32(v5, list[951]),
                                buffer.readu32(v23, list[478]),
                                buffer.readu32(v18, list[775]),
                                buffer.readu32(v18, list[664]),
                                buffer.readu32(v26, list[184]),
                                buffer.readu32(v26, list[622]),
                                buffer.readu32(v22, list[24]),
                                buffer.readu32(v18, list[14]),
                                buffer.readu32(v22, list[986]),
                                buffer.readu32(v18, list[1007]),
                                buffer.readu32(v26, list[457]),
                                buffer.readu32(v23, list[671]),
                                buffer.readu32(v23, list[12]),
                                buffer.readu32(v23, list[593]),
                                buffer.readu32(v5, list[457]),
                                buffer.readu32(v5, list[932]),
                                buffer.readu32(v22, list[1131]),
                                buffer.readu32(v22, list[404]),
                                buffer.readu32(v22, list[560]),
                                buffer.readu32(v18, list[503]),
                                buffer.readu32(v18, list[943]),
                                buffer.readu32(v23, list[864]),
                                buffer.readu32(v22, list[349]),
                                buffer.readu32(v18, list[975]),
                                buffer.readu32(v22, list[930]),
                                buffer.readu32(v22, list[559]),
                                buffer.readu32(v5, list[426]),
                                buffer.readu32(v23, list[460]),
                                buffer.readu32(v26, list[313]),
                                buffer.readu32(v22, list[397]),
                                buffer.readu32(v18, list[748]),
                                buffer.readu32(v26, list[581]),
                                buffer.readu32(v5, list[713]),
                                buffer.readu32(v18, list[348]),
                                buffer.readu32(v18, list[296]),
                                buffer.readu32(v26, list[183]),
                                buffer.readu32(v22, list[968]),
                                buffer.readu32(v23, list[1127]),
                                buffer.readu32(v26, list[883]),
                                buffer.readu32(v23, list[240]),
                                buffer.readu32(v5, list[535]),
                                buffer.readu32(v22, list[249]),
                                buffer.readu32(v5, list[313]),
                                buffer.readu32(v18, list[734]),
                                buffer.readu32(v5, list[856]),
                                buffer.readu32(v22, list[159]),
                                buffer.readu32(v18, list[444]),
                                buffer.readu32(v23, list[1005]),
                                buffer.readu32(v23, list[1117]),
                                buffer.readu32(v23, list[721]),
                                buffer.readu32(v23, list[892]),
                                buffer.readu32(v22, list[464]),
                                buffer.readu32(v23, list[357]),
                                buffer.readu32(v5, list[32]),
                                buffer.readu32(v26, list[157]),
                                buffer.readu32(v22, list[379]),
                                buffer.readu32(v22, list[723]),
                                buffer.readu32(v26, list[238]),
                                buffer.readu32(v26, list[601]),
                                buffer.readu32(v26, list[154]),
                                buffer.readu32(v5, list[689]),
                                buffer.readu32(v26, list[13]),
                                buffer.readu32(v22, list[357]),
                                buffer.readu32(v18, list[309]),
                                buffer.readu32(v26, list[32]),
                                buffer.readu32(v23, list[879]),
                                buffer.readu32(v18, list[663]),
                                buffer.readu32(v22, list[1090]),
                                buffer.readu32(v5, list[664]),
                                buffer.readu32(v26, list[720]),
                                buffer.readu32(v23, list[308]),
                                buffer.readu32(v5, list[952]),
                                buffer.readu32(v5, list[1007]),
                                buffer.readu32(v5, list[943]),
                                buffer.readu32(v23, list[403]),
                                buffer.readu32(v18, list[951]),
                                buffer.readu32(v5, list[769]),
                                buffer.readu32(v26, list[182]),
                                buffer.readu32(v26, list[943]),
                                buffer.readu32(v22, list[584]),
                                buffer.readu32(v23, list[1063]),
                                buffer.readu32(v26, list[1114]),
                                buffer.readu32(v5, list[748]),
                                buffer.readu32(v18, list[517]),
                                buffer.readu32(v5, list[791]),
                                buffer.readu32(v23, list[249]),
                                buffer.readu32(v26, list[995]),
                                buffer.readu32(v26, list[1007]),
                                buffer.readu32(v22, list[268]),
                                buffer.readu32(v5, list[720]),
                                buffer.readu32(v5, list[238]),
                                buffer.readu32(v23, list[268]),
                                buffer.readu32(v18, list[182]),
                                buffer.readu32(v22, list[752]),
                                buffer.readu32(v5, list[241]),
                                buffer.readu32(v5, list[734]),
                                buffer.readu32(v23, list[646]),
                                buffer.readu32(v18, list[491]),
                                buffer.readu32(v22, list[721]),
                                buffer.readu32(v5, list[157]),
                                buffer.readu32(v26, list[517]),
                                buffer.readu32(v18, list[176]),
                                buffer.readu32(v18, list[184]),
                                buffer.readu32(v26, list[775]),
                                buffer.readu32(v23, list[752]),
                                buffer.readu32(v22, list[34]),
                                buffer.readu32(v26, list[975]),
                                buffer.readu32(v26, list[491]),
                                buffer.readu32(v23, list[174]),
                                buffer.readu32(v22, list[240]),
                                buffer.readu32(v26, list[748]),
                                buffer.readu32(v26, list[959]),
                                buffer.readu32(v22, list[57]),
                                buffer.readu32(v18, list[813]),
                                buffer.readu32(v23, list[258]),
                                buffer.readu32(v22, list[1001]),
                                buffer.readu32(v18, list[932]),
                                buffer.readu32(v23, list[1060]),
                                buffer.readu32(v5, list[263]),
                                buffer.readu32(v23, list[152]),
                                buffer.readu32(v26, list[769]),
                                buffer.readu32(v18, list[553]),
                                buffer.readu32(v23, list[677]),
                                buffer.readu32(v26, list[444]),
                                buffer.readu32(v18, list[242]),
                                buffer.readu32(v22, list[593]),
                                buffer.readu32(v18, list[473]),
                                buffer.readu32(v23, list[723]),
                                buffer.readu32(v18, list[924]),
                                buffer.readu32(v5, list[184]),
                                buffer.readu32(v5, list[924]),
                                buffer.readu32(v5, list[995]),
                                buffer.readu32(v18, list[717]),
                                buffer.readu32(v26, list[952]),
                                buffer.readu32(v18, list[28]),
                                buffer.readu32(v26, list[553]),
                                buffer.readu32(v23, list[608]),
                                buffer.readu32(v26, list[813]),
                                buffer.readu32(v23, list[986]),
                                buffer.readu32(v22, list[594]),
                                buffer.readu32(v18, list[589]),
                                buffer.readu32(v5, list[336]),
                                buffer.readu32(v5, list[277]),
                                buffer.readu32(v18, list[665]),
                                buffer.readu32(v23, list[594]),
                                buffer.readu32(v5, list[717]),
                                buffer.readu32(v26, list[331]),
                                buffer.readu32(v26, list[589]),
                                buffer.readu32(v18, list[989]),
                                buffer.readu32(v26, list[503]),
                                buffer.readu32(v18, list[952]),
                                buffer.readu32(v23, list[1036]),
                                buffer.readu32(v5, list[605]),
                                buffer.readu32(v18, list[1033]),
                                buffer.readu32(v23, list[927]),
                                buffer.readu32(v26, list[856]),
                                buffer.readu32(v26, list[296]),
                                buffer.readu32(v22, list[1020]),
                                buffer.readu32(v23, list[930]),
                                buffer.readu32(v5, list[348]),
                                buffer.readu32(v22, list[677]),
                                buffer.readu32(v5, list[665]),
                                buffer.readu32(v18, list[13]),
                                buffer.readu32(v26, list[242]),
                                buffer.readu32(v26, list[932]),
                                buffer.readu32(v5, list[1114]),
                                buffer.readu32(v18, list[689]),
                                buffer.readu32(v22, list[1036]),
                                buffer.readu32(v23, list[34]),
                                buffer.readu32(v22, list[403]),
                                buffer.readu32(v22, list[834]),
                                buffer.readu32(v5, list[309]),
                                buffer.readu32(v26, list[663]),
                                buffer.readu32(v5, list[331]),
                                buffer.readu32(v5, list[473]),
                                buffer.readu32(v22, list[1117]),
                                buffer.readu32(v22, list[598]),
                                buffer.readu32(v5, list[517]),
                                buffer.readu32(v26, list[552]),
                                buffer.readu32(v23, list[994]),
                                buffer.readu32(v22, list[519]),
                                buffer.readu32(v5, list[13]),
                                buffer.readu32(v22, list[994]),
                                buffer.readu32(v18, list[883]),
                                buffer.readu32(v26, list[734]),
                                buffer.readu32(v5, list[989]),
                                buffer.readu32(v26, list[689]),
                                buffer.readu32(v18, list[862]),
                                buffer.readu32(v18, list[331]),
                                buffer.readu32(v22, list[992]),
                                buffer.readu32(v26, list[535]),
                                buffer.readu32(v22, list[460]),
                                buffer.readu32(v26, list[605]),
                            }

                            callback4 = bit32[list[10](v22, list[671], list[1002])]
                            v40 = bit32[list[10](v23, list[1029], list[114])]
                            callback6 = bit32[list[10](v26, list[358], list[114])]
                            callback5 = bit32[list[10](v18, list[959], list[1002])]
                            v9 = list[566]
                            v32 = list[260]
                            v28 = list[228]
                            callback3 = list[997]
                            local v214 = list[588]
                            v40 = v214[list[698](list[10](v18, list[810], list[708]), buffer.readu8(v18, list[425]))](v214, (list[188](list[10](v5, list[1077], list[726]), buffer.readu8(v18, list[897]), buffer.readu8(v18, list[65]))))

                            local v215 = list[588]

                            v41 = v215[list[188](list[10](v22, list[150], list[885]), buffer.readu8(v26, list[654]), buffer.readu8(v26, list[875]))](v215, callback3((list[698](list[10](v5, list[393], list[817]), buffer.readu8(v18, list[425])))))
                            local v217 = list[588]

                            v8 = v217[list[188](list[10](v23, list[205], list[276]), buffer.readu8(v26, list[312]), buffer.readu8(v23, list[861]))](v217, callback3((list[188](list[10](v22, list[22], list[149]), buffer.readu8(v5, list[312]), buffer.readu8(v5, list[990])))))

                            local v218 = list[588]
                            v41 = v218[list[698](list[10](v5, list[482], list[708]), buffer.readu8(v26, list[312]))](v218, callback3((list[698](list[10](v5, list[448], list[708]), buffer.readu8(v26, list[654])))))

                            local v220 = list[588]

                            v38 = v220[list[188](list[10](v22, list[1052], list[116]), buffer.readu8(v5, list[71]), buffer.readu8(v5, list[544]))](v220, callback3((list[698](list[10](v26, list[213], list[732]), buffer.readu8(v26, list[425])))))
                            local v221 = list[588]

                            v12 = v221[list[188](list[10](v22, list[170], list[1088]), buffer.readu8(v23, list[71]), buffer.readu8(v5, list[564]))](v221, callback3((list[698](list[10](v23, list[208], list[1092]), buffer.readu8(v26, list[866])))))
                            local v222 = list[588]
                            callback16 = v222[list[698](list[10](v18, list[976], list[708]), buffer.readu8(v5, list[71]))](v222, callback3((list[188](list[10](v18, list[659], list[738]), buffer.readu8(v5, list[789]), buffer.readu8(v22, list[492])))))

                            local v223 = list[588]
                            v11 = v223[list[698](list[10](v26, list[333], list[708]), buffer.readu8(v5, list[1057]))](v223, callback3((list[188](list[10](v23, list[687], list[1068]), buffer.readu8(v22, list[509]), buffer.readu8(v5, list[509])))))

                            local v224 = list[588]
                            count = v224[list[698](list[10](v23, list[996], list[793]), buffer.readu8(v26, list[312]))](v224, callback3((list[698](list[10](v18, list[270], list[30]), buffer.readu8(v26, list[425])))))

                            v36 = v41[list[188](list[10](v22, list[1085], list[1037]), buffer.readu8(v26, list[579]), buffer.readu8(v26, list[65]))](v41)
                            local v226 = list[188](list[10](v23, list[1085], list[1037]), buffer.readu8(v5, list[71]), buffer.readu8(v22, list[492]))

                            v41 = v8[v226](v8, (list[698](list[10](v5, list[369], list[708]), buffer.readu8(v18, list[546]))))
                            v = list[223]
                            count = list[106]
                            xored = if list[947](math[list[10](v26, list[525], list[114])](buffer.readu8(v5, list[642]), buffer.readu8(v26, list[37])), buffer.readu32(v23, list[992])) then list[316] else list[895]
                        end
                    elseif xored < 1324 then
                        if xored < 1323 then
                            xored = list[913]
                        else
                            local callback28 = buffer[list[10](v18, list[964], list[221])]

                            local callback29 = bit32[list[10](v22, list[671], list[1002])]
                            local v226 = buffer.readu8(v5, list[642])
                            callback28(tbl4, list2, callback29(count2, v25[v226]))

                            list2 += buffer.readu8(v5, list[642])
                            version2 = v15
                            xored = if version2 then list[611] else list[760]
                        end
                    elseif xored < 1325 then
                        xored = list[1084]
                    else
                        callback27 = false
                        callback22 = {}
                        fn2 = function(...) -- line 7458 · shares: [1] callback3, [2] fn, [3] v17, [4] v, [5] list, [6] callback12, [7] v19, [8] v35, [9] v26, [10] fn2, [11] v18, [12] v22, [13] callback9, [14] v23, [15] callback16, [16] v5, [17] v33
                            if not callback3 then
                                ({})[1] = fn;
                                ({})[2] = v17;
                                ({})[3] = v;
                                ({})[4] = callback3;
                                ({})[5] = list;
                                ({})[6] = callback12;
                                ({})[7] = v19;
                                ({})[8] = v35;
                                ({})[9] = v26;
                                ({})[10] = fn2;
                                ({})[11] = v18;
                                ({})[12] = v22;
                                ({})[13] = callback9;
                                ({})[14] = v23;
                                ({})[15] = callback16
                            end

                            local tbl
                            local tbl2
                            local v2
                            local flag
                            local v3
                            local v4
                            local v6
                            local flag2
                            local v7
                            local v8
                            local v9
                            local v10
                            local v11
                            local v12
                            local v13
                            local v14
                            local flag3
                            local v15
                            local v16
                            local xored
                            xored = list[801]

                            while true do
                                xored = bit32.bxor(xored, list[787])

                                if xored < 5495 then
                                    if xored < 5489 then
                                        if xored < 4675 or xored < 5473 then break end

                                        if xored < 5488 then
                                            if xored ~= 5473 then break end
                                            flag = v35
                                            v3 = buffer.readu8(v5, list[642])
                                            v4 = buffer.readu8(v26, list[642])
                                            v11 = v3
                                            v9 = v4
                                            xored = list[650]
                                        else
                                            flag = v2
                                            xored = if flag then list[1092] else list[532]
                                        end
                                    elseif xored < 5492 then
                                        if xored < 5490 then
                                            tbl2 = {
                                                [callback3((list[698](list[list[708]](v18, list[1035], list[list[1088]]), buffer.readu8(v18, list[579]))))] = callback3((list[list[737]](list[list[708]](v5, list[list[100]], list[list[1074]]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v5, list[509])))),
                                                [callback3((list[list[737]](list[list[708]](v18, list[540], list[list[469]]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[list[27]]))))] = callback3((list[698](list[list[708]](v5, list[1040], list[list[819]]), buffer.readu8(v22, list[509])))),
                                                [callback3((list[698](list[list[708]](v22, list[807], list[list[633]]), buffer.readu8(v18, list[579]))))] = callback3((list[list[737]](list[list[708]](v22, list[list[680]], list[list[1074]]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v5, list[list[738]])))),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[647]], list[885]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v26, list[509]))))] = callback3((list[698](list[list[708]](v23, list[1099], list[454]), buffer.readu8(v22, list[509])))),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[40]], list[1088]), buffer.readu8(v23, list[875]), buffer.readu8(v5, list[list[738]]))))] = callback3((list[698](list[list[708]](v23, list[list[948]], list[list[378]]), buffer.readu8(v5, list[613])))),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[640]], list[772]), buffer.readu8(v22, list[990]), buffer.readu8(v5, list[579]))))] = callback3((list[list[737]](list[list[708]](v23, list[548], list[list[633]]), buffer.readu8(v18, list[654]), buffer.readu8(v5, list[544])))),
                                                [callback3((list[list[737]](list[list[708]](v18, list[759], list[639]), buffer.readu8(v22, list[579]), buffer.readu8(v23, list[1083]))))] = callback3((list[list[737]](list[list[708]](v23, list[461], list[list[419]]), buffer.readu8(v5, list[897]), buffer.readu8(v18, list[990])))),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[758]], list[772]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v5, list[579]))))] = callback3((list[698](list[list[708]](v22, list[1099], list[454]), buffer.readu8(v5, list[1057])))),
                                                [callback3((list[698](list[list[708]](v26, list[list[307]], list[691]), buffer.readu8(v22, list[579]))))] = callback3((list[list[737]](list[list[708]](v26, list[list[470]], list[656]), buffer.readu8(v5, list[1057]), buffer.readu8(v23, list[789])))),
                                                [callback3((list[list[737]](list[list[708]](v23, list[822], list[list[792]]), buffer.readu8(v18, list[579]), buffer.readu8(v22, list[861]))))] = callback3((list[list[737]](list[list[708]](v18, list[920], list[885]), buffer.readu8(v22, list[list[832]]), buffer.readu8(v22, list[861])))),
                                                [callback3((list[698](list[list[708]](v18, list[list[420]], list[691]), buffer.readu8(v26, list[861]))))] = callback3((list[list[737]](list[list[708]](v23, list[list[77]], list[469]), buffer.readu8(v26, list[654]), buffer.readu8(v18, list[list[738]])))),
                                                [callback3((list[698](list[list[708]](v23, list[603], list[656]), buffer.readu8(v18, list[579]))))] = callback3((list[698](list[list[708]](v22, list[536], list[list[105]]), buffer.readu8(v26, list[866])))),
                                                [callback3((list[698](list[list[708]](v5, list[868], list[691]), buffer.readu8(v23, list[679]))))] = callback3((list[698](list[list[708]](v22, list[list[595]], list[list[105]]), buffer.readu8(v5, list[897])))),
                                                [callback3((list[698](list[list[708]](v22, list[985], list[691]), buffer.readu8(v22, list[list[27]]))))] = callback3((list[list[737]](list[list[708]](v26, list[list[670]], list[list[469]]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v23, list[789])))),
                                                [callback3((list[698](list[list[708]](v5, list[list[315]], list[list[633]]), buffer.readu8(v23, list[679]))))] = callback3((list[698](list[list[708]](v22, list[list[712]], list[793]), buffer.readu8(v5, list[897])))),
                                                [callback3((list[list[737]](list[list[708]](v23, list[818], list[931]), buffer.readu8(v26, list[1057]), buffer.readu8(v26, list[list[305]]))))] = callback3((list[698](list[list[708]](v22, list[list[818]], list[793]), buffer.readu8(v23, list[642])))),
                                                [callback3((list[list[737]](list[list[708]](v5, list[850], list[772]), buffer.readu8(v26, list[861]), buffer.readu8(v22, list[642]))))] = callback3((list[list[737]](list[list[708]](v22, list[782], list[1042]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v26, list[list[305]])))),
                                                [callback3((list[698](list[list[708]](v18, list[list[324]], list[list[105]]), buffer.readu8(v5, list[679]))))] = list[list[737]](list[list[708]](v22, list[list[531]], list[726]), buffer.readu8(v18, list[list[549]]), buffer.readu8(v23, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[list[339]], list[650]), buffer.readu8(v26, list[613]))))] = list[list[737]](list[list[708]](v23, list[632], list[list[633]]), buffer.readu8(v26, list[866]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v22, list[900], list[708]), buffer.readu8(v26, list[789]))))] = list[list[737]](list[list[708]](v22, list[1095], list[639]), buffer.readu8(v22, list[509]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[list[1026]], list[list[796]]), buffer.readu8(v18, list[579]), buffer.readu8(v23, list[861]))))] = list[list[737]](list[list[708]](v23, list[788], list[list[543]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v22, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v22, list[list[148]], list[708]), buffer.readu8(v5, list[list[549]]))))] = list[list[737]](list[list[708]](v23, list[list[141]], list[1088]), buffer.readu8(v5, list[654]), buffer.readu8(v23, list[866])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[1010], list[885]), buffer.readu8(v23, list[990]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v23, list[572], list[732]), buffer.readu8(v26, list[list[549]])),
                                                [callback3((list[698](list[list[708]](v26, list[542], list[list[105]]), buffer.readu8(v5, list[list[286]]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v5, list[575], list[list[105]]), buffer.readu8(v23, list[list[305]]))))] = list[list[737]](list[list[708]](v26, list[list[659]], list[1037]), buffer.readu8(v22, list[list[923]]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[248]], list[list[239]]), buffer.readu8(v23, list[654]), buffer.readu8(v26, list[990]))))] = list[list[737]](list[list[708]](v18, list[list[326]], list[list[105]]), buffer.readu8(v18, list[579]), buffer.readu8(v26, list[list[738]])),
                                                [callback3((list[698](list[list[708]](v23, list[list[234]], list[list[105]]), buffer.readu8(v18, list[list[27]]))))] = list[list[737]](list[list[708]](v5, list[540], list[list[469]]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v22, list[861])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[906], list[650]), buffer.readu8(v23, list[579]), buffer.readu8(v18, list[938]))))] = list[list[737]](list[list[708]](v18, list[886], list[732]), buffer.readu8(v23, list[938]), buffer.readu8(v26, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[696]], list[454]), buffer.readu8(v22, list[972]), buffer.readu8(v26, list[list[738]]))))] = list[698](list[list[708]](v5, list[958], list[732]), buffer.readu8(v22, list[1120])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[788], list[list[543]]), buffer.readu8(v26, list[1057]), buffer.readu8(v18, list[list[738]]))))] = list[698](list[list[708]](v23, list[572], list[732]), buffer.readu8(v26, list[list[549]])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[145]], list[712]), buffer.readu8(v23, list[897]), buffer.readu8(v26, list[509]))))] = list[list[737]](list[list[708]](v23, list[list[1098]], list[1037]), buffer.readu8(v23, list[938]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[4]], list[list[798]]), buffer.readu8(v23, list[938]), buffer.readu8(v26, list[list[27]]))))] = list[list[737]](list[list[708]](v5, list[603], list[list[227]]), buffer.readu8(v26, list[654]), buffer.readu8(v23, list[789])),
                                                [callback3((list[698](list[list[708]](v22, list[936], list[list[105]]), buffer.readu8(v18, list[564]))))] = list[list[737]](list[list[708]](v5, list[954], list[691]), buffer.readu8(v22, list[list[832]]), buffer.readu8(v22, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[706], list[list[239]]), buffer.readu8(v23, list[579]), buffer.readu8(v26, list[990]))))] = list[list[737]](list[list[708]](v26, list[list[916]], list[list[633]]), buffer.readu8(v5, list[654]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v18, list[684], list[list[105]]), buffer.readu8(v22, list[579]))))] = list[698](list[list[708]](v23, list[list[750]], list[732]), buffer.readu8(v18, list[579])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[736], list[793]), buffer.readu8(v26, list[789]), buffer.readu8(v5, list[642]))))] = list[list[737]](list[list[708]](v5, list[list[661]], list[885]), buffer.readu8(v26, list[654]), buffer.readu8(v26, list[990])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[756], list[691]), buffer.readu8(v23, list[1120]), buffer.readu8(v23, list[789]))))] = list[698](list[list[708]](v5, list[list[158]], list[732]), buffer.readu8(v26, list[1057])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[931]], list[738]), buffer.readu8(v18, list[1120]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v5, list[484], list[656]), buffer.readu8(v5, list[789]), buffer.readu8(v5, list[564])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[740], list[882]), buffer.readu8(v22, list[654]), buffer.readu8(v18, list[990]))))] = list[698](list[list[708]](v22, list[582], list[732]), buffer.readu8(v23, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[743]], list[978]), buffer.readu8(v5, list[679]), buffer.readu8(v23, list[509]))))] = list[698](list[list[708]](v22, list[858], list[732]), buffer.readu8(v23, list[list[286]])),
                                                [callback3((list[698](list[list[708]](v18, list[643], list[793]), buffer.readu8(v22, list[list[738]]))))] = list[list[737]](list[list[708]](v18, list[699], list[list[1043]]), buffer.readu8(v26, list[897]), buffer.readu8(v5, list[list[738]])),
                                                [callback3((list[698](list[list[708]](v26, list[556], list[793]), buffer.readu8(v23, list[list[738]]))))] = list[698](list[list[708]](v18, list[886], list[732]), buffer.readu8(v23, list[938])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[648], list[list[138]]), buffer.readu8(v23, list[990]), buffer.readu8(v23, list[1083]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[698](list[list[708]](v26, list[list[1092]], list[708]), buffer.readu8(v23, list[938]))))] = list[list[737]](list[list[708]](v23, list[573], list[list[227]]), buffer.readu8(v22, list[972]), buffer.readu8(v23, list[789])),
                                                [callback3((list[698](list[list[708]](v23, list[684], list[list[105]]), buffer.readu8(v5, list[654]))))] = list[698](list[list[708]](v18, list[list[158]], list[732]), buffer.readu8(v18, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[931]], list[738]), buffer.readu8(v18, list[1120]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[647]], list[885]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v22, list[492]))))] = list[698](list[list[708]](v5, list[582], list[732]), buffer.readu8(v23, list[990])),
                                                [callback3((list[698](list[list[708]](v5, list[list[929]], list[793]), buffer.readu8(v23, list[564]))))] = list[list[737]](list[list[708]](v26, list[877], list[1037]), buffer.readu8(v23, list[875]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[698](list[list[708]](v23, list[770], list[708]), buffer.readu8(v26, list[789]))))] = list[list[737]](list[list[708]](v5, list[list[639]], list[978]), buffer.readu8(v22, list[1120]), buffer.readu8(v5, list[509])),
                                                [callback3((list[698](list[list[708]](v22, list[1065], list[708]), buffer.readu8(v22, list[list[549]]))))] = list[list[737]](list[list[708]](v26, list[1075], list[1037]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1056], list[650]), buffer.readu8(v5, list[654]), buffer.readu8(v18, list[938]))))] = list[698](list[list[708]](v22, list[list[158]], list[732]), buffer.readu8(v18, list[list[549]])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[974], list[list[1088]]), buffer.readu8(v5, list[679]), buffer.readu8(v5, list[544]))))] = list[698](list[list[708]](v5, list[572], list[732]), buffer.readu8(v18, list[654])),
                                                [callback3((list[698](list[list[708]](v5, list[729], list[793]), buffer.readu8(v26, list[564]))))] = list[list[737]](list[list[708]](v23, list[list[759]], list[978]), buffer.readu8(v26, list[866]), buffer.readu8(v5, list[509])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[1050], list[list[62]]), buffer.readu8(v22, list[1057]), buffer.readu8(v18, list[938]))))] = list[list[737]](list[list[708]](v23, list[764], list[list[633]]), buffer.readu8(v23, list[1057]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v18, list[1056], list[650]), buffer.readu8(v18, list[list[286]]))))] = list[list[737]](list[list[708]](v26, list[672], list[656]), buffer.readu8(v18, list[1083]), buffer.readu8(v5, list[564])),
                                                [callback3((list[698](list[list[708]](v5, list[472], list[708]), buffer.readu8(v23, list[990]))))] = list[list[737]](list[list[708]](v18, list[list[727]], list[712]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v26, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[843], list[list[796]]), buffer.readu8(v23, list[938]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v18, list[575], list[list[105]]), buffer.readu8(v18, list[509]), buffer.readu8(v26, list[list[738]])),
                                                [callback3((list[698](list[list[708]](v18, list[811], list[793]), buffer.readu8(v22, list[938]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[698](list[list[708]](v18, list[770], list[708]), buffer.readu8(v22, list[990]))))] = list[list[737]](list[list[708]](v22, list[822], list[639]), buffer.readu8(v23, list[679]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[479], list[885]), buffer.readu8(v23, list[564]), buffer.readu8(v22, list[492]))))] = list[list[737]](list[list[708]](v26, list[983], list[list[162]]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v18, list[990])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[459], list[list[796]]), buffer.readu8(v18, list[list[832]]), buffer.readu8(v23, list[861]))))] = list[698](list[list[708]](v5, list[550], list[732]), buffer.readu8(v18, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[850]], list[list[62]]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[list[741]]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v23, list[472], list[708]), buffer.readu8(v5, list[679]))))] = list[698](list[list[708]](v22, list[582], list[732]), buffer.readu8(v23, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v18, list[523], list[793]), buffer.readu8(v22, list[list[738]]))))] = list[698](list[list[708]](v26, list[list[2]], list[732]), buffer.readu8(v23, list[875])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[1087], list[454]), buffer.readu8(v18, list[579]), buffer.readu8(v5, list[642]))))] = list[list[737]](list[list[708]](v18, list[843], list[list[796]]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[492])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[624], list[list[62]]), buffer.readu8(v23, list[1120]), buffer.readu8(v22, list[list[741]]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[list[680]], list[list[1074]]), buffer.readu8(v22, list[875]), buffer.readu8(v5, list[list[738]]))))] = list[698](list[list[708]](v22, list[886], list[732]), buffer.readu8(v22, list[509])),
                                                [callback3((list[698](list[list[708]](v22, list[483], list[list[267]]), buffer.readu8(v18, list[list[286]]))))] = list[698](list[list[708]](v23, list[440], list[732]), buffer.readu8(v26, list[654])),
                                                [callback3((list[698](list[list[708]](v23, list[795], list[list[105]]), buffer.readu8(v18, list[613]))))] = list[list[737]](list[list[708]](v22, list[530], list[731]), buffer.readu8(v26, list[861]), buffer.readu8(v22, list[642])),
                                                [callback3((list[698](list[list[708]](v18, list[list[630]], list[793]), buffer.readu8(v18, list[1120]))))] = list[698](list[list[708]](v18, list[958], list[732]), buffer.readu8(v23, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v23, list[575], list[list[105]]), buffer.readu8(v5, list[866]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[577], list[793]), buffer.readu8(v5, list[679]))))] = list[list[737]](list[list[708]](v26, list[905], list[list[526]]), buffer.readu8(v5, list[789]), buffer.readu8(v26, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[844], list[793]), buffer.readu8(v23, list[679]), buffer.readu8(v26, list[1083]))))] = list[list[737]](list[list[708]](v26, list[list[963]], list[list[1088]]), buffer.readu8(v22, list[509]), buffer.readu8(v18, list[list[738]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[1071], list[list[239]]), buffer.readu8(v22, list[938]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v22, list[858], list[732]), buffer.readu8(v23, list[list[286]])),
                                                [callback3((list[698](list[list[708]](v22, list[list[774]], list[708]), buffer.readu8(v5, list[list[549]]))))] = list[698](list[list[708]](v22, list[572], list[732]), buffer.readu8(v26, list[679])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[829]], list[885]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v18, list[1053], list[732]), buffer.readu8(v22, list[579])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[1128], list[454]), buffer.readu8(v26, list[list[832]]), buffer.readu8(v26, list[list[738]]))))] = list[list[737]](list[list[708]](v22, list[list[871]], list[list[304]]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[875])),
                                                [callback3((list[698](list[list[708]](v26, list[1023], list[list[105]]), buffer.readu8(v18, list[list[741]]))))] = list[698](list[list[708]](v18, list[582], list[732]), buffer.readu8(v5, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1035], list[list[1088]]), buffer.readu8(v22, list[972]), buffer.readu8(v22, list[list[741]]))))] = list[698](list[list[708]](v22, list[582], list[732]), buffer.readu8(v23, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[702], list[726]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[1108], list[469]), buffer.readu8(v26, list[679]), buffer.readu8(v23, list[789]))))] = list[list[737]](list[list[708]](v22, list[1097], list[list[796]]), buffer.readu8(v23, list[938]), buffer.readu8(v22, list[492])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[750], list[738]), buffer.readu8(v23, list[990]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v22, list[860], list[469]), buffer.readu8(v22, list[990]), buffer.readu8(v5, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[1077], list[726]), buffer.readu8(v18, list[564]), buffer.readu8(v23, list[861]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[list[489]], list[650]), buffer.readu8(v23, list[list[305]]))))] = list[list[737]](list[list[708]](v23, list[596], list[list[796]]), buffer.readu8(v26, list[list[549]]), buffer.readu8(v22, list[492])),
                                                [callback3((list[698](list[list[708]](v23, list[list[324]], list[list[105]]), buffer.readu8(v22, list[579]))))] = list[list[737]](list[list[708]](v26, list[list[381]], list[691]), buffer.readu8(v23, list[list[27]]), buffer.readu8(v22, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[1061], list[738]), buffer.readu8(v26, list[613]), buffer.readu8(v22, list[492]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[970], list[list[304]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v26, list[658], list[list[469]]), buffer.readu8(v23, list[list[27]]), buffer.readu8(v22, list[861])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[1026], list[731]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v18, list[list[305]]))))] = list[list[737]](list[list[708]](v18, list[529], list[list[526]]), buffer.readu8(v5, list[897]), buffer.readu8(v26, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[316]], list[list[543]]), buffer.readu8(v26, list[789]), buffer.readu8(v23, list[866]))))] = list[list[737]](list[list[708]](v5, list[list[134]], list[691]), buffer.readu8(v22, list[579]), buffer.readu8(v22, list[544])),
                                                [callback3((list[698](list[list[708]](v5, list[523], list[793]), buffer.readu8(v22, list[579]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[list[234]], list[list[105]]), buffer.readu8(v18, list[list[286]]), buffer.readu8(v18, list[938]))))] = list[698](list[list[708]](v5, list[550], list[732]), buffer.readu8(v18, list[1083])),
                                                [callback3((list[698](list[list[708]](v23, list[906], list[650]), buffer.readu8(v23, list[list[305]]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[698](list[list[708]](v5, list[643], list[793]), buffer.readu8(v22, list[972]))))] = list[698](list[list[708]](v23, list[886], list[732]), buffer.readu8(v22, list[list[832]])),
                                                [callback3((list[698](list[list[708]](v22, list[619], list[793]), buffer.readu8(v26, list[679]))))] = list[list[737]](list[list[708]](v26, list[595], list[639]), buffer.readu8(v18, list[579]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v5, list[811], list[793]), buffer.readu8(v18, list[list[286]]))))] = list[698](list[list[708]](v18, list[958], list[732]), buffer.readu8(v23, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v26, list[945], list[708]), buffer.readu8(v5, list[866]))))] = list[list[737]](list[list[708]](v22, list[1101], list[list[543]]), buffer.readu8(v23, list[938]), buffer.readu8(v22, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v26, list[455], list[708]), buffer.readu8(v26, list[list[286]]))))] = list[698](list[list[708]](v5, list[958], list[732]), buffer.readu8(v22, list[1120])),
                                                [callback3((list[698](list[list[708]](v5, list[524], list[793]), buffer.readu8(v22, list[875]))))] = list[698](list[list[708]](v26, list[list[467]], list[732]), buffer.readu8(v18, list[861])),
                                                [callback3((list[698](list[list[708]](v5, list[645], list[708]), buffer.readu8(v18, list[861]))))] = list[list[737]](list[list[708]](v23, list[list[4]], list[list[798]]), buffer.readu8(v18, list[579]), buffer.readu8(v5, list[990])),
                                                [callback3((list[698](list[list[708]](v5, list[684], list[list[105]]), buffer.readu8(v5, list[654]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[674], list[885]), buffer.readu8(v5, list[list[549]]), buffer.readu8(v26, list[875]))))] = list[list[737]](list[list[708]](v22, list[list[641]], list[726]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v23, list[861])),
                                                [callback3((list[698](list[list[708]](v18, list[645], list[708]), buffer.readu8(v23, list[613]))))] = list[698](list[list[708]](v23, list[582], list[732]), buffer.readu8(v5, list[654])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[977], list[469]), buffer.readu8(v18, list[564]), buffer.readu8(v5, list[564]))))] = list[list[737]](list[list[708]](v26, list[list[3]], list[list[227]]), buffer.readu8(v18, list[564]), buffer.readu8(v23, list[789])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1009], list[454]), buffer.readu8(v18, list[861]), buffer.readu8(v5, list[642]))))] = list[list[737]](list[list[708]](v26, list[list[913]], list[885]), buffer.readu8(v18, list[897]), buffer.readu8(v26, list[990])),
                                                [callback3((list[698](list[list[708]](v26, list[501], list[708]), buffer.readu8(v23, list[679]))))] = list[list[737]](list[list[708]](v18, list[1129], list[list[227]]), buffer.readu8(v23, list[875]), buffer.readu8(v23, list[789])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[568], list[793]), buffer.readu8(v22, list[1057]), buffer.readu8(v26, list[1083]))))] = list[list[737]](list[list[708]](v22, list[list[1061]], list[list[138]]), buffer.readu8(v26, list[861]), buffer.readu8(v22, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[793]], list[list[105]]), buffer.readu8(v26, list[1057]), buffer.readu8(v18, list[938]))))] = list[list[737]](list[list[708]](v26, list[list[196]], list[list[227]]), buffer.readu8(v5, list[897]), buffer.readu8(v23, list[789])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[745], list[list[798]]), buffer.readu8(v23, list[544]), buffer.readu8(v5, list[list[738]]))))] = list[list[737]](list[list[708]](v26, list[list[718]], list[726]), buffer.readu8(v23, list[875]), buffer.readu8(v23, list[861])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[763], list[list[138]]), buffer.readu8(v23, list[list[738]]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[652], list[list[796]]), buffer.readu8(v18, list[579]), buffer.readu8(v23, list[861]))))] = list[list[737]](list[list[708]](v26, list[list[628]], list[469]), buffer.readu8(v26, list[897]), buffer.readu8(v5, list[544])),
                                                [callback3((list[698](list[list[708]](v5, list[1104], list[list[105]]), buffer.readu8(v22, list[875]))))] = list[698](list[list[708]](v23, list[582], list[732]), buffer.readu8(v5, list[654])),
                                                [callback3((list[698](list[list[708]](v22, list[465], list[708]), buffer.readu8(v23, list[1057]))))] = list[list[737]](list[list[708]](v5, list[942], list[1088]), buffer.readu8(v26, list[866]), buffer.readu8(v23, list[866])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[529], list[list[526]]), buffer.readu8(v18, list[1120]), buffer.readu8(v5, list[579]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v18, list[472], list[708]), buffer.readu8(v23, list[897]))))] = list[698](list[list[708]](v18, list[582], list[732]), buffer.readu8(v5, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[133]], list[list[1043]]), buffer.readu8(v23, list[list[738]]), buffer.readu8(v23, list[509]))))] = list[list[737]](list[list[708]](v5, list[list[86]], list[712]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[539], list[list[1088]]), buffer.readu8(v23, list[875]), buffer.readu8(v22, list[544]))))] = list[list[737]](list[list[708]](v26, list[list[935]], list[731]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[642])),
                                                [callback3((list[698](list[list[708]](v22, list[476], list[list[105]]), buffer.readu8(v23, list[list[305]]))))] = list[list[737]](list[list[708]](v5, list[list[133]], list[list[1043]]), buffer.readu8(v5, list[679]), buffer.readu8(v5, list[list[738]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[691]], list[731]), buffer.readu8(v5, list[list[549]]), buffer.readu8(v18, list[990]))))] = list[list[737]](list[list[708]](v5, list[list[84]], list[list[543]]), buffer.readu8(v23, list[679]), buffer.readu8(v22, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v23, list[619], list[793]), buffer.readu8(v22, list[875]))))] = list[698](list[list[708]](v23, list[886], list[732]), buffer.readu8(v22, list[list[832]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1134], list[738]), buffer.readu8(v23, list[613]), buffer.readu8(v26, list[875]))))] = list[698](list[list[708]](v23, list[list[750]], list[732]), buffer.readu8(v18, list[579])),
                                                [callback3((list[698](list[list[708]](v26, list[1080], list[list[105]]), buffer.readu8(v22, list[list[27]]))))] = list[698](list[list[708]](v26, list[list[467]], list[732]), buffer.readu8(v18, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[859], list[list[105]]), buffer.readu8(v26, list[789]))))] = list[698](list[list[708]](v26, list[list[467]], list[732]), buffer.readu8(v18, list[861])),
                                                [callback3((list[698](list[list[708]](v22, list[1056], list[650]), buffer.readu8(v23, list[897]))))] = list[list[737]](list[list[708]](v26, list[1016], list[list[633]]), buffer.readu8(v26, list[544]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v23, list[645], list[708]), buffer.readu8(v22, list[1057]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[698](list[list[708]](v5, list[795], list[list[105]]), buffer.readu8(v5, list[654]))))] = list[list[737]](list[list[708]](v5, list[759], list[639]), buffer.readu8(v18, list[897]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[686], list[726]), buffer.readu8(v18, list[1120]), buffer.readu8(v26, list[list[923]]))))] = list[list[737]](list[list[708]](v26, list[661], list[639]), buffer.readu8(v18, list[list[549]]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[887]], list[1037]), buffer.readu8(v18, list[642]), buffer.readu8(v5, list[938]))))] = list[list[737]](list[list[708]](v18, list[603], list[list[227]]), buffer.readu8(v22, list[list[923]]), buffer.readu8(v23, list[789])),
                                                [callback3((list[698](list[list[708]](v26, list[list[193]], list[793]), buffer.readu8(v18, list[list[832]]))))] = list[698](list[list[708]](v22, list[list[158]], list[732]), buffer.readu8(v18, list[list[549]])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[573], list[list[227]]), buffer.readu8(v22, list[990]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v26, list[list[254]], list[732]), buffer.readu8(v26, list[866])),
                                                [callback3((list[698](list[list[708]](v22, list[651], list[793]), buffer.readu8(v23, list[564]))))] = list[698](list[list[708]](v26, list[list[380]], list[732]), buffer.readu8(v23, list[679])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[878], list[650]), buffer.readu8(v22, list[990]), buffer.readu8(v26, list[1083]))))] = list[list[737]](list[list[708]](v18, list[list[661]], list[885]), buffer.readu8(v23, list[list[27]]), buffer.readu8(v26, list[990])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[459], list[list[796]]), buffer.readu8(v22, list[972]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[399]], list[list[304]]), buffer.readu8(v23, list[938]), buffer.readu8(v23, list[1083]))))] = list[698](list[list[708]](v22, list[list[750]], list[732]), buffer.readu8(v23, list[list[923]])),
                                                [callback3((list[698](list[list[708]](v26, list[865], list[list[105]]), buffer.readu8(v22, list[938]))))] = list[list[737]](list[list[708]](v5, list[1074], list[738]), buffer.readu8(v22, list[972]), buffer.readu8(v5, list[938])),
                                                [callback3((list[698](list[list[708]](v18, list[736], list[793]), buffer.readu8(v22, list[679]))))] = list[698](list[list[708]](v26, list[762], list[732]), buffer.readu8(v5, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v5, list[list[630]], list[793]), buffer.readu8(v22, list[875]))))] = list[list[737]](list[list[708]](v5, list[1108], list[469]), buffer.readu8(v18, list[1083]), buffer.readu8(v5, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[1098]], list[1037]), buffer.readu8(v18, list[579]), buffer.readu8(v22, list[1083]))))] = list[list[737]](list[list[708]](v23, list[759], list[639]), buffer.readu8(v23, list[938]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[480]], list[708]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v26, list[1083]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[729], list[793]), buffer.readu8(v22, list[1057]), buffer.readu8(v5, list[642]))))] = list[698](list[list[708]](v26, list[list[1072]], list[732]), buffer.readu8(v23, list[1057])),
                                                [callback3((list[698](list[list[708]](v5, list[976], list[708]), buffer.readu8(v26, list[679]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[698](list[list[708]](v5, list[984], list[708]), buffer.readu8(v26, list[1057]))))] = list[698](list[list[708]](v23, list[958], list[732]), buffer.readu8(v5, list[679])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[857], list[list[469]]), buffer.readu8(v22, list[972]), buffer.readu8(v23, list[789]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[695], list[list[227]]), buffer.readu8(v18, list[1083]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v18, list[886], list[732]), buffer.readu8(v23, list[938])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[100]], list[list[1074]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v23, list[509]))))] = list[list[737]](list[list[708]](v18, list[1053], list[732]), buffer.readu8(v22, list[579]), buffer.readu8(v26, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[706], list[list[239]]), buffer.readu8(v26, list[1057]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v22, list[list[750]], list[732]), buffer.readu8(v23, list[list[923]])),
                                                [callback3((list[698](list[list[708]](v22, list[466], list[708]), buffer.readu8(v18, list[579]))))] = list[698](list[list[708]](v5, list[858], list[732]), buffer.readu8(v23, list[613])),
                                                [callback3((list[698](list[list[708]](v18, list[448], list[708]), buffer.readu8(v23, list[list[741]]))))] = list[list[737]](list[list[708]](v5, list[list[759]], list[978]), buffer.readu8(v18, list[654]), buffer.readu8(v5, list[509])),
                                                [callback3((list[698](list[list[708]](v23, list[465], list[793]), buffer.readu8(v22, list[579]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v22, list[list[383]], list[list[105]]), buffer.readu8(v18, list[564]))))] = list[698](list[list[708]](v26, list[list[2]], list[732]), buffer.readu8(v23, list[875])),
                                                [callback3((list[698](list[list[708]](v22, list[845], list[793]), buffer.readu8(v26, list[861]))))] = list[list[737]](list[list[708]](v18, list[list[315]], list[list[633]]), buffer.readu8(v26, list[897]), buffer.readu8(v26, list[509])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[1026]], list[list[796]]), buffer.readu8(v26, list[list[286]]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v5, list[582], list[732]), buffer.readu8(v23, list[990])),
                                                [callback3((list[698](list[list[708]](v5, list[list[998]], list[793]), buffer.readu8(v26, list[897]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[698](list[list[708]](v18, list[482], list[708]), buffer.readu8(v23, list[list[305]]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[698](list[list[708]](v22, list[list[702]], list[708]), buffer.readu8(v23, list[list[305]]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v5, list[list[327]], list[793]), buffer.readu8(v5, list[list[832]]))))] = list[list[737]](list[list[708]](v26, list[1062], list[726]), buffer.readu8(v26, list[679]), buffer.readu8(v23, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[635], list[793]), buffer.readu8(v22, list[list[27]]))))] = list[698](list[list[708]](v5, list[886], list[732]), buffer.readu8(v5, list[list[923]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[836], list[list[162]]), buffer.readu8(v18, list[list[832]]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[808], list[list[526]]), buffer.readu8(v26, list[897]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v23, list[651], list[793]), buffer.readu8(v22, list[679]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                            }

                                            tbl = {
                                                callback3((list[list[737]](list[list[708]](v5, list[list[257]], list[list[526]]), buffer.readu8(v22, list[list[27]]), buffer.readu8(v26, list[990])))),
                                                callback3((list[698](list[list[708]](v22, list[548], list[list[633]]), buffer.readu8(v18, list[579])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[1126], list[712]), buffer.readu8(v5, list[654]), buffer.readu8(v18, list[938])))),
                                                callback3((list[698](list[list[708]](v5, list[699], list[list[1043]]), buffer.readu8(v18, list[564])))),
                                                callback3((list[list[737]](list[list[708]](v5, list[481], list[list[796]]), buffer.readu8(v18, list[861]), buffer.readu8(v22, list[list[286]])))),
                                                callback3((list[list[737]](list[list[708]](v23, list[list[257]], list[list[526]]), buffer.readu8(v5, list[679]), buffer.readu8(v26, list[990])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[1026], list[731]), buffer.readu8(v26, list[1057]), buffer.readu8(v22, list[list[286]])))),
                                                callback3((list[698](list[list[708]](v18, list[list[432]], list[list[798]]), buffer.readu8(v18, list[861])))),
                                                callback3((list[list[737]](list[list[708]](v5, list[list[636]], list[1088]), buffer.readu8(v5, list[654]), buffer.readu8(v23, list[509])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[528], list[931]), buffer.readu8(v23, list[1057]), buffer.readu8(v26, list[875])))),
                                                callback3((list[list[737]](list[list[708]](v5, list[list[783]], list[1042]), buffer.readu8(v22, list[972]), buffer.readu8(v26, list[list[305]])))),
                                            }

                                            xored = if not fn2 then list[732] else list[list[378]]
                                        elseif xored < 5491 then
                                            flag = v(v35, list[588])
                                            xored = list[1092]
                                        else
                                            v2 = flag
                                            xored = list[list[885]]
                                        end
                                    elseif xored < 5493 then
                                        xored = if flag then list[list[105]] else list[list[819]]
                                    else
                                        if xored < 5494 then break end

                                        v2 = nil
                                        xored = list[list[1043]]
                                    end
                                elseif xored < 5500 then
                                    if xored < 5497 then
                                        if xored < 5496 then
                                            flag3 = false
                                            for key, value in tbl2 do
                                                v15 = key
                                                v16 = value
                                                local v28 = v15
                                                local v29 = v16
                                                local v30
                                                v30 = list[1002]

                                                while true do
                                                    if v30 < 2 then
                                                        if v30 < 1 then break end

                                                        v13 = v12
                                                        callback9(list[list[737]](list[list[708]](v5, list[530], list[731]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v5, list[544])), {v28, v29})

                                                        v30 = list[935]
                                                    elseif v30 < 3 then
                                                        v30 = list[801]
                                                    elseif v30 < 4 then
                                                        flag3 = true
                                                        v30 = list[801]
                                                    else
                                                        tbl2 = v35(callback16, v28)
                                                        if tbl2 == callback12 then
                                                            v30 = list[list[885]]
                                                        else
                                                            v30 = list[935]
                                                        end
                                                    end
                                                end

                                                if flag3 then break end
                                            end

                                            xored = list[1002]
                                        else
                                            v11 += list[list[885]]
                                            xored = list[650]
                                        end
                                    elseif xored < 5498 then
                                        v13 = v12

                                        flag = v4[list[list[737]](list[list[708]](v5, list[621], list[list[633]]), buffer.readu8(v23, list[679]), buffer.readu8(v22, list[1083]))](v4, callback3((list[list[737]](list[list[708]](v18, list[list[759]], list[978]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v26, list[list[27]])))))

                                        xored = list[935]
                                    elseif xored < 5499 then
                                        v13 = v12

                                        flag = list[709][list[list[737]](list[list[708]](v22, list[522], list[list[239]]), buffer.readu8(v22, list[list[549]]), buffer.readu8(v26, list[list[305]]))](flag)
                                        xored = list[list[267]]
                                    else
                                        local v37, v38 = v(flag)
                                        v4 = v38
                                        flag = not v37
                                        xored = if flag then list[list[512]] else list[935]
                                    end
                                elseif xored < 5503 then
                                    if xored < 5501 then
                                        fn2 = true
                                        flag2 = false
                                        for key, value in tbl2 do
                                            v7 = key
                                            v8 = value
                                            local v42 = v7
                                            local v43 = v8
                                            local v44
                                            v44 = list[list[885]]

                                            while true do
                                                if v44 < 1 then
                                                    flag2 = true
                                                    v44 = list[935]
                                                else
                                                    if not (v44 < 2) then break end
                                                    v17(v33(callback16, v42), function(arg1) -- line 9692 · shares: [1] callback12, [2] v5, [4] callback9, [5] v22, [6] list, [8] v23 · uses: [3] v43, [7] v42
                                                        if not callback12 then
                                                            ({})[1] = v5;
                                                            ({})[2] = v43;
                                                            ({})[3] = callback9;
                                                            ({})[4] = v22;
                                                            ({})[5] = list;
                                                            ({})[6] = v42;
                                                            ({})[7] = arg1
                                                        end

                                                        local xored
                                                        xored = list[801]

                                                        while true do
                                                            xored = bit32.bxor(xored, list[527])

                                                            if not (xored < 9460) then break end
                                                            if xored < 3910 then
                                                                if xored < 3908 then
                                                                    return
                                                                elseif not (xored < 3909) then
                                                                    break
                                                                else
                                                                    xored = if arg1 == callback12 then list[935] else list[532]
                                                                end
                                                            else
                                                                if not (xored < 4827) then break end
                                                                if xored < 3911 then
                                                                    callback9(list[list[737]](list[list[708]](v5, list[461], list[list[419]]), buffer.readu8(v23, list[938]), buffer.readu8(v22, list[544])), {v42, v43})

                                                                    xored = list[532]
                                                                else
                                                                    if xored ~= 3911 then break end
                                                                    xored = list[list[885]]
                                                                end
                                                            end
                                                        end
                                                    end)
                                                    v44 = list[935]
                                                end
                                            end

                                            if flag2 then break end
                                        end

                                        fn[#fn + buffer.readu8(v5, list[642])] = list[list[1096]][list[698](list[list[708]](v26, list[list[634]], list[1092]), buffer.readu8(v26, list[938]))](function() -- line 9753 · shares: [1] tbl, [2] v19, [3] v35, [4] callback9, [5] callback12, [6] callback16, [7] v5, [8] list, [9] v18, [10] v22, [11] v23
                                            if not tbl then
                                                ({})[1] = tbl;
                                                ({})[2] = v19;
                                                ({})[3] = v35;
                                                ({})[4] = callback9;
                                                ({})[5] = callback12;
                                                ({})[6] = callback16;
                                                ({})[7] = v5
                                            end

                                            local count, v, v2, v3, v4, v6, v7
                                            local xored
                                            xored = list[list[819]]

                                            while true do
                                                xored = bit32.bxor(xored, list[638])

                                                if xored < 3324 then
                                                    if xored < 3316 then
                                                        if xored < 3312 then
                                                            return
                                                        elseif xored < 3314 then
                                                            if xored < 3313 then
                                                                xored = list[793]
                                                            else
                                                                count = tbl[v6]
                                                                v19(callback16, count)
                                                                xored = if v35(callback16, count) == callback12 then list[454] else list[532]
                                                            end
                                                        else
                                                            if not (xored < 3315) then break end
                                                            count = #tbl
                                                            v = buffer.readu8(v5, list[642])
                                                            v4 = v
                                                            v2 = count
                                                            xored = list[935]
                                                        end
                                                    elseif xored < 3319 then
                                                        if xored < 3317 then
                                                            xored = if v4 <= v2 then list[list[885]] else list[list[512]]
                                                        else
                                                            xored = if xored < 3318 then list[732] else list[1092]
                                                        end
                                                    elseif xored < 3322 then
                                                        if xored < 3320 then
                                                            v6 = v4
                                                            xored = list[list[378]]
                                                        else
                                                            if xored ~= 3320 then break end
                                                            xored = list[801]
                                                        end
                                                    elseif xored < 3323 then
                                                        v7 = v6
                                                        callback9(list[list[737]](list[list[708]](v18, list[1076], list[list[304]]), buffer.readu8(v22, list[990]), buffer.readu8(v23, list[866])), {count})

                                                        xored = list[532]
                                                    else
                                                        v4 += list[list[885]]
                                                        xored = list[935]
                                                    end
                                                else
                                                    if not (xored < 5549) then break end
                                                    if xored < 3327 then
                                                        if xored < 3325 then
                                                            xored = list[1002]
                                                        elseif xored < 3326 then
                                                            xored = list[708]
                                                        else
                                                            list[list[1096]][list[698](list[list[708]](v23, list[1116], list[1002]), buffer.readu8(v18, list[897]))](buffer.readu8(v5, list[642]))
                                                            xored = list[list[267]]
                                                        end
                                                    else
                                                        if not (xored < 3790 and xored < 3566) or xored ~= 3327 then
                                                            break
                                                        end

                                                        xored = list[793]
                                                    end
                                                end
                                            end
                                        end)
                                        xored = list[list[378]]
                                    elseif xored < 5502 then
                                        v12 = v11
                                        xored = list[793]
                                    else
                                        callback9((list[698](list[list[708]](v5, list[539], list[list[1088]]), buffer.readu8(v18, list[list[549]]))))

                                        xored = list[list[819]]
                                    end
                                else
                                    if not (xored < 5685) or xored ~= 5503 then break end

                                    xored = if v11 <= v9 then list[454] else list[708]
                                end
                            end
                        end
                        fn = function(...) -- line 9878 · shares: [1] callback3, [2] v26, [3] v36, [4] callback15, [5] v18, [6] v22, [7] list, [8] callback9, [9] v23, [10] v5, [11] v
                            if not callback3 then
                                ({})[1] = v26;
                                ({})[2] = v36;
                                ({})[3] = callback15;
                                ({})[4] = callback3;
                                ({})[5] = v18;
                                ({})[6] = v22;
                                ({})[7] = list;
                                ({})[8] = callback9;
                                ({})[9] = v23
                            end

                            local list2, count, v2, flag, v3, v4, v6, v7, v8, v9, flag2, v10, v11
                            local xored
                            xored = list[454]

                            while true do
                                xored = bit32.bxor(xored, list[list[794]])

                                if xored < 11925 then
                                    if xored < 8692 then
                                        return
                                    elseif xored < 11921 then
                                        if xored < 11914 then
                                            return
                                        elseif xored < 11920 then
                                            if xored ~= 11914 then break end
                                            v8 = v7
                                            callback9(list[list[737]](list[list[708]](v23, list[674], list[885]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v22, list[544])), {list2[v8]})

                                            xored = list[list[512]]
                                        else
                                            xored = if v6 <= v3 then list[650] else list[935]
                                        end
                                    elseif xored < 11923 then
                                        if xored < 11922 then
                                            return
                                        end

                                        xored = list[1092]
                                    elseif xored < 11924 then
                                        v8 = v7
                                        count = list[947](v8, buffer.readu32(v5, list[444]))
                                        xored = list[1002]
                                    else
                                        v7 = v6
                                        xored = list[list[819]]
                                    end
                                elseif xored < 11932 then
                                    if xored < 11928 then
                                        if xored < 11926 then
                                            xored = list[1092]
                                        elseif xored < 11927 then
                                            list2 = {
                                                callback3((list[list[737]](list[list[708]](v18, list[550], list[732]), buffer.readu8(v5, list[789]), buffer.readu8(v26, list[list[738]])))),
                                                callback3((list[698](list[list[708]](v22, list[1130], list[list[62]]), buffer.readu8(v5, list[list[923]])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[1061], list[738]), buffer.readu8(v26, list[938]), buffer.readu8(v22, list[list[286]])))),
                                                callback3((list[698](list[list[708]](v18, list[list[234]], list[list[105]]), buffer.readu8(v26, list[list[549]])))),
                                                callback3((list[list[737]](list[list[708]](v26, list[669], list[1088]), buffer.readu8(v18, list[654]), buffer.readu8(v5, list[509])))),
                                            }

                                            count = #list2
                                            v2 = buffer.readu8(v5, list[642])
                                            v6 = v2
                                            v3 = count
                                            xored = list[708]
                                        else
                                            xored = list[list[1043]]
                                        end
                                    elseif xored < 11930 then
                                        if xored < 11929 then
                                            v8 = v7

                                            list2 = {
                                                callback3((list[list[737]](list[list[708]](v26, list[711], list[738]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v26, list[875])))),
                                                callback3((list[698](list[list[708]](v22, list[list[360]], list[list[1074]]), buffer.readu8(v5, list[789])))),
                                                callback3((list[698](list[list[708]](v22, list[632], list[list[633]]), buffer.readu8(v5, list[789])))),
                                                callback3((list[list[737]](list[list[708]](v26, list[list[978]], list[list[796]]), buffer.readu8(v5, list[875]), buffer.readu8(v23, list[1083])))),
                                                callback3((list[list[737]](list[list[708]](v18, list[461], list[list[162]]), buffer.readu8(v5, list[list[923]]), buffer.readu8(v26, list[list[305]])))),
                                            }

                                            count = #list2
                                            v2 = buffer.readu8(v5, list[642])
                                            flag2 = false
                                            for i = v2, count do
                                                local v20
                                                v10 = i
                                                local v24
                                                v24 = list[list[819]]

                                                while true do
                                                    if v24 < 3 then
                                                        if v24 < 1 then break end

                                                        if v24 < 2 then
                                                            if flag then
                                                                v24 = list[935]
                                                            else
                                                                v24 = list[1092]
                                                            end
                                                        else
                                                            v11 = v10
                                                            callback9(list[698](list[list[708]](v22, list[list[445]], list[list[239]]), buffer.readu8(v26, list[list[549]])), {v2, count})

                                                            v24 = list[1092]
                                                        end
                                                    elseif v24 < 5 then
                                                        if v24 < 4 then
                                                            v11 = v10
                                                            flag = not list[list[1049]](count, buffer.readu8(v18, list[list[549]]), buffer.readu32(v26, list[664]))

                                                            v24 = list[list[885]]
                                                        else
                                                            flag2 = true
                                                            v24 = list[801]
                                                        end
                                                    elseif v24 < 6 then
                                                        v24 = list[801]
                                                    else
                                                        v11 = v10
                                                        local v30 = list2[v11]
                                                        v2, count = v(function() -- line 10076 · shares: [1] v30, [2] v5, [3] v26, [4] list
                                                            if not v30 then
                                                                ({})[1] = v5;
                                                                ({})[2] = v30;
                                                                ({})[3] = v26;
                                                                ({})[4] = list
                                                            end

                                                            local settings = UserSettings()

                                                            return settings[list[list[737]](list[list[708]](v26, list[list[273]], list[885]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v26, list[875]))](settings, v30)
                                                        end)

                                                        flag = v2
                                                        if flag then
                                                            v24 = list[list[885]]
                                                        else
                                                            v24 = list[532]
                                                        end
                                                    end
                                                end

                                                if flag2 then break end
                                            end

                                            xored = list[793]
                                        else
                                            v8 = v7
                                            count = list[947](v8, buffer.readu32(v26, list[list[656]]))
                                            xored = if count then list[1002] else list[list[267]]
                                        end
                                    elseif xored < 11931 then
                                        xored = if count then list[list[105]] else list[732]
                                    else
                                        xored = if v36 then list[532] else list[list[1043]]
                                    end
                                else
                                    if not (xored < 13208) then break end
                                    if xored < 11934 then
                                        if xored < 11933 then
                                            v8 = v7
                                            xored = if callback15(list[588], list2[v8]) then list[list[885]] else list[list[512]]
                                        else
                                            v8 = v7
                                            count = list[947](v8, buffer.readu32(v23, list[834]))
                                            xored = list[801]
                                        end
                                    elseif xored < 11935 then
                                        xored = if count then list[801] else list[list[378]]
                                    else
                                        if xored ~= 11935 then break end
                                        v6 += list[list[885]]
                                        xored = list[708]
                                    end
                                end
                            end
                        end
                        xored = list[30]
                    end
                elseif xored < 1329 then
                    if xored < 1327 then
                        xored = list[691]
                    elseif xored < 1328 then
                        xored = list[656]
                    else
                        callback19 = callback18
                        version3 = #callback19
                        callback20 = buffer.readu8(v5, list[642])
                        str = buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083]) - buffer.readu8(v5, list[642])
                        xored = list[595]
                    end
                elseif xored < 1333 then
                    if xored < 1332 then
                        if xored ~= 1329 then break end
                        xored = list[1021]
                    else
                        tbl4 = (tbl4 + buffer.readu8(v22, list[71])) % buffer.readu8(v18, list[789])
                        xored = list[74]
                    end
                elseif xored < 1334 then
                    tbl5 = {
                        list[698](list[10](v5, list[183], list[1002]), buffer.readu8(v23, list[312])),
                        list[188](list[10](v22, list[389], list[1037]), buffer.readu8(v22, list[71]), buffer.readu8(v26, list[65])),
                        list[698](list[10](v23, list[177], list[1092]), buffer.readu8(v23, list[938])),
                        list[698](list[10](v23, list[800], list[221]), buffer.readu8(v23, list[613])),
                        list[698](list[10](v5, list[946], list[114]), buffer.readu8(v22, list[71])),
                        list[188](list[10](v22, list[704], list[25]), buffer.readu8(v23, list[875]), buffer.readu8(v23, list[1083])),
                        list[698](list[10](v18, list[215], list[307]), buffer.readu8(v26, list[544])),
                        list[698](list[10](v18, list[1032], list[221]), buffer.readu8(v23, list[65])),
                        list[188](list[10](v23, list[344], list[885]), buffer.readu8(v26, list[866]), buffer.readu8(v22, list[642])),
                        list[698](list[10](v22, list[1060], list[1002]), buffer.readu8(v23, list[546])),
                        list[698](list[10](v18, list[471], list[221]), buffer.readu8(v5, list[679])),
                        (list[188](list[10](v18, list[522], list[105]), buffer.readu8(v23, list[1057]), buffer.readu8(v23, list[861]))),
                    }

                    v43 = tbl5[tbl4 % buffer.readu8(v23, list[866]) + buffer.readu8(v5, list[642])]
                    tbl5 = tbl4 % buffer.readu8(v5, list[37]) + buffer.readu8(v26, list[37])
                    v44 = v43[list[698](list[10](v22, list[7], list[221]), buffer.readu8(v23, list[642]))](v43)
                    local v231 = tbl5

                    tbl5 = v43[list[188](list[10](v5, list[695], list[703]), buffer.readu8(v5, list[613]), buffer.readu8(v26, list[65]))](v43)

                    v45 = v44[list[188](list[10](v22, list[400], list[712]), buffer.readu8(v26, list[897]), buffer.readu8(v22, list[230]))](v44, v231)

                    xored = if tbl5 >= v45[list[188](list[10](v23, list[777], list[149]), buffer.readu8(v23, list[1120]), buffer.readu8(v5, list[544]))](v45) then list[290] else list[378]
                else
                    tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                    xored = list[1113]
                end
            elseif xored < 1421 then
                if xored < 1414 then
                    if xored < 1410 then
                        if xored < 1408 then
                            if xored ~= 1335 then break end
                            xored = if str <= buffer.readu8(v5, list[37]) then list[40] else list[793]
                        elseif xored < 1409 then
                            tbl5 = nil
                            tbl5 = buffer.readu8(v23, list[509]) - buffer.readu8(v18, list[938])
                            tbl5 = buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[642])
                            tbl5 = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
                            tbl5 = buffer.readu8(v23, list[509]) - buffer.readu8(v5, list[990])
                            xored = list[248]
                        else
                            xored = list[286]
                        end
                    elseif xored < 1412 then
                        if xored < 1411 then
                            tbl4 = count
                            xored = list[785]
                        else
                            callback25 = list[688]
                            tbl6 = list[283]
                            callback24 = {}
                            callback26 = function(...) -- line 10237 · shares: [1] v32, [2] v22, [3] tbl6, [4] v21, [5] list, [6] v26, [7] callback9, [8] v27, [9] v18, [10] v, [11] callback3, [12] v31, [13] v23, [14] v6, [15] callback13, [16] v20, [17] v5, [18] v28, [19] v29, [20] v39, [21] v37
                                if not v32 then
                                    ({
                                        v22,
                                        tbl6,
                                        v21,
                                        list,
                                        v26,
                                        callback9,
                                        v27,
                                        v18,
                                        v,
                                        callback3,
                                        callback3,
                                        v31,
                                        v23,
                                        v6,
                                        callback13,
                                        callback3,
                                    })[17] = v20;
                                    ({
                                        v22,
                                        tbl6,
                                        v21,
                                        list,
                                        v26,
                                        callback9,
                                        v27,
                                        v18,
                                        v,
                                        callback3,
                                        callback3,
                                        v31,
                                        v23,
                                        v6,
                                        callback13,
                                        callback3,
                                    })[18] = callback3
                                end

                                local fn
                                local flag
                                local v2
                                local v3
                                local flag2
                                local v4
                                local v7
                                local str
                                local v8
                                local v9
                                local v10
                                local v11
                                local v12
                                local v13
                                local v14
                                local v15
                                local v16
                                local v17
                                local v19
                                local v24
                                local xored
                                xored = list[724]

                                while true do
                                    xored = bit32.bxor(xored, list[683])

                                    if xored < 2998 then
                                        if xored < 2970 then
                                            if xored < 2956 then
                                                if xored < 2949 then
                                                    if xored < 2946 then
                                                        if xored < 2944 then
                                                            return
                                                        elseif xored < 2945 then
                                                            flag2 = not fn[list[698](list[list[708]](v22, list[list[784]], list[1092]), buffer.readu8(v26, list[579]))](fn, v27)
                                                            xored = list[list[442]]
                                                        else
                                                            v12 = v11
                                                            v17 = v16
                                                            v24 = v19
                                                            v2 = list[698](list[list[708]](v18, list[list[235]], list[list[798]]), buffer.readu8(v23, list[list[741]]))

                                                            v3 = nil
                                                            xored = list[785]
                                                        end
                                                    elseif xored < 2947 then
                                                        v2, flag2 = v(getfenv, v3)
                                                        v3 = v2
                                                        xored = if v3 then list[1002] else list[list[168]]
                                                    elseif xored < 2948 then
                                                        callback9(v2, {v3})
                                                        xored = list[list[162]]
                                                    else
                                                        fn = function() -- line 10300
                                                            return game:WaitForChild("", 5)
                                                        end

                                                        flag = list[list[1096]][list[list[737]](list[list[708]](v18, list[list[934]], list[708]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v5, list[990]))](fn)
                                                        fn = buffer.readu8(v26, list[1083])
                                                        v2 = buffer.readu8(v5, list[642])
                                                        v3 = buffer.readu8(v26, list[509])
                                                        v15 = v2
                                                        v13 = v3
                                                        xored = list[450]
                                                    end
                                                elseif xored < 2952 then
                                                    if xored < 2950 then
                                                        return callback9(list[698](list[list[708]](v5, list[list[420]], list[691]), buffer.readu8(v23, list[list[305]])), {fn, flag})
                                                    end

                                                    if xored < 2951 then
                                                        xored = if v15 <= v13 then list[list[1084]] else list[534]
                                                    else
                                                        xored = list[list[287]]
                                                    end
                                                elseif xored < 2954 then
                                                    if xored < 2953 then
                                                        v4 = v3
                                                        xored = list[list[398]]
                                                    else
                                                        callback9(list[list[737]](list[list[708]](v23, list[1133], list[list[62]]), buffer.readu8(v26, list[list[549]]), buffer.readu8(v26, list[1083])), {
                                                            tbl6[list[list[737]](list[list[708]](v26, list[494], list[691]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v22, list[492]))],
                                                            v2,
                                                        })

                                                        xored = list[list[554]]
                                                    end
                                                elseif xored < 2955 then
                                                    v15 += list[list[885]]
                                                    xored = list[450]
                                                else
                                                    tbl6[list[698](list[list[708]](v22, list[list[68]], list[list[512]]), buffer.readu8(v26, list[list[741]]))] = v2

                                                    xored = list[list[267]]
                                                end
                                            elseif xored < 2963 then
                                                if xored < 2959 then
                                                    if xored < 2957 then
                                                        v24 = v19

                                                        v3, v7 = v4[list[list[737]](list[list[708]](v22, list[list[77]], list[469]), buffer.readu8(v5, list[1057]), buffer.readu8(v26, list[509]))]()
                                                        v12 = v11
                                                        v17 = v16

                                                        str = v3 .. list[698](list[list[708]](v23, list[list[832]], list[list[885]]), buffer.readu8(v22, list[875])) .. v7
                                                        xored = list[732]
                                                    elseif xored < 2958 then
                                                        xored = if fn then list[532] else list[list[90]]
                                                    else
                                                        xored = list[935]
                                                    end
                                                elseif xored < 2961 then
                                                    if xored < 2960 then
                                                        xored = list[766]
                                                    else
                                                        v24 = v19
                                                        xored = if v4[list[list[737]](list[list[708]](v18, list[list[518]], list[656]), buffer.readu8(v5, list[1057]), buffer.readu8(v23, list[866]))] then list[list[543]] else list[list[301]]
                                                    end
                                                elseif xored < 2962 then
                                                    fn = flag
                                                    xored = list[list[633]]
                                                else
                                                    xored = if v2 then list[691] else list[list[162]]
                                                end
                                            elseif xored < 2966 then
                                                if xored < 2964 then
                                                    xored = if tbl6[list[698](list[list[708]](v22, list[list[662]], list[1092]), buffer.readu8(v22, list[897]))] ~= v3 then list[731] else list[list[591]]
                                                else
                                                    xored = if xored < 2965 then list[list[138]] else list[list[227]]
                                                end
                                            elseif xored < 2968 then
                                                if xored < 2967 then
                                                    v12 = v11
                                                    v17 = v16
                                                    v24 = v19

                                                    v3, v2 = debug[list[698](list[list[708]](v18, list[605], list[1002]), buffer.readu8(v26, list[list[741]]))](flag, v24, (list[698](list[list[708]](v18, list[502], list[1092]), buffer.readu8(v22, list[list[832]]))))

                                                    xored = if not v3 then list[743] else list[list[1088]]
                                                else
                                                    flag2 = str
                                                    xored = list[list[227]]
                                                end
                                            elseif xored < 2969 then
                                                xored = list[1088]
                                            else
                                                return callback9((list[list[737]](list[list[708]](v26, list[list[554]], list[list[528]]), buffer.readu8(v22, list[579]), buffer.readu8(v23, list[861]))))
                                            end
                                        elseif xored < 2984 then
                                            if xored < 2977 then
                                                if xored < 2973 then
                                                    if xored < 2971 then
                                                        v12 = v11
                                                        v17 = v16
                                                        v24 = v19
                                                        v2 = flag2[list[698](list[list[708]](v5, list[list[948]], list[list[378]]), buffer.readu8(v23, list[938]))]

                                                        xored = list[list[512]]
                                                    elseif xored < 2972 then
                                                        v24 = v19
                                                        callback9(list[list[737]](list[list[708]](v23, list[list[437]], list[772]), buffer.readu8(v5, list[679]), buffer.readu8(v5, list[938])), {buffer.readu8(v5, list[642]), fn})

                                                        xored = list[list[526]]
                                                    else
                                                        flag = v3
                                                        fn = flag2
                                                        xored = list[978]
                                                    end
                                                elseif xored < 2975 then
                                                    if xored < 2974 then
                                                        v12 = v11

                                                        flag = list[709][list[698](list[list[708]](v5, list[491], list[1002]), buffer.readu8(v22, list[list[27]]))](flag)
                                                        xored = list[510]
                                                    else
                                                        v3 = flag2
                                                        xored = list[list[168]]
                                                    end
                                                else
                                                    if xored < 2976 then
                                                        return
                                                    end

                                                    xored = if flag2 then list[list[421]] else list[list[368]]
                                                end
                                            elseif xored < 2980 then
                                                if xored < 2978 then
                                                    v2, v3 = v(getfenv, buffer.readu8(v26, list[1083]))
                                                    flag2 = v2
                                                    xored = if flag2 then list[list[15]] else list[1037]
                                                elseif xored < 2979 then
                                                    v12 = v11
                                                    v17 = v16
                                                    v24 = v19

                                                    v7, flag2 = v4[list[698](list[list[708]](v23, list[699], list[list[1043]]), buffer.readu8(v18, list[list[549]]))]()

                                                    str = v7 .. list[698](list[list[708]](v5, list[1120], list[list[885]]), buffer.readu8(v18, list[579])) .. flag2
                                                    xored = list[list[419]]
                                                else
                                                    v3 = flag
                                                    v2 = fn
                                                    xored = if tbl6[list[698](list[list[708]](v18, list[list[784]], list[1092]), buffer.readu8(v18, list[861]))] == nil then list[885] else list[842]
                                                end
                                            elseif xored < 2982 then
                                                if xored < 2981 then
                                                    fn = nil
                                                    xored = list[738]
                                                else
                                                    v10 += list[list[885]]
                                                    xored = list[486]
                                                end
                                            elseif xored < 2983 then
                                                xored = list[list[105]]
                                            else
                                                v24 = v19
                                                xored = if v4[list[list[737]](list[list[708]](v18, list[list[257]], list[list[526]]), buffer.readu8(v23, list[990]), buffer.readu8(v26, list[875]))] then list[list[218]] else list[882]
                                            end
                                        elseif xored < 2991 then
                                            if xored < 2987 then
                                                if xored < 2985 then
                                                    return callback9((list[list[737]](list[list[708]](v5, list[674], list[885]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v5, list[642]))))
                                                end

                                                if xored < 2986 then
                                                    v11 = v10
                                                    xored = list[list[378]]
                                                else
                                                    xored = if fn then list[1042] else list[list[194]]
                                                end
                                            elseif xored < 2989 then
                                                if xored < 2988 then
                                                    v3 = callback3(flag2)
                                                    xored = list[935]
                                                else
                                                    fn += buffer.readu8(v5, list[642])
                                                    xored = list[list[1043]]
                                                end
                                            elseif xored < 2990 then
                                                v4 = flag2
                                                xored = list[list[1021]]
                                            else
                                                xored = list[list[105]]
                                            end
                                        elseif xored < 2994 then
                                            if xored < 2992 then
                                                fn, flag = v28(function() -- line 10581 · shares: [1] v29, [2] v, [3] list, [4] v5, [5] callback13, [6] v39, [7] v22, [8] v23, [9] v26, [10] v31
                                                    if not v29 then
                                                        ({})[1] = v;
                                                        ({})[2] = list;
                                                        ({})[3] = v5;
                                                        ({})[4] = callback13;
                                                        ({})[5] = v39;
                                                        ({})[6] = v22;
                                                        ({})[7] = v29
                                                    end

                                                    local v2, v3, v4, v6, flag, v7, flag2, v8
                                                    local xored
                                                    xored = list[list[378]]

                                                    while true do
                                                        xored = bit32.bxor(xored, list[644])

                                                        if xored < 13992 then break end

                                                        if xored < 13997 then
                                                            if xored < 13994 then
                                                                if xored < 13993 then
                                                                    return buffer.readu8(v5, list[642]), {v4, v3}
                                                                end

                                                                flag = not list[947](v3, buffer.readu32(v23, list[list[25]]))

                                                                xored = list[list[885]]
                                                            else
                                                                if xored < 13995 then break end

                                                                if xored < 13996 then
                                                                    v3 = buffer.readu8(v26, list[1083])
                                                                    local function fn() -- line 10610 · shares: [1] v3, [2] v29, [3] v31, [4] fn
                                                                        v3 = v3 + 1
                                                                        if 195 < v3 then
                                                                            game:GetService(v29)
                                                                        end

                                                                        return v31(fn)()
                                                                    end

                                                                    v4, v6 = v(fn)
                                                                    flag = v4
                                                                    xored = if flag then list[list[885]] else list[1092]
                                                                else
                                                                    v4 = buffer.readu8(v26, list[1083])
                                                                    flag2 = false
                                                                    for item in callback13(v6, v39) do
                                                                        v8 = item
                                                                        local v12 = v8
                                                                        local v13
                                                                        v13 = list[list[885]]

                                                                        while true do
                                                                            if v13 < 1 then
                                                                                flag2 = true
                                                                                v13 = list[935]
                                                                            else
                                                                                if not (v13 < 2) then
                                                                                    break
                                                                                end

                                                                                v4 += buffer.readu8(v5, list[642])
                                                                                v13 = list[935]
                                                                            end
                                                                        end

                                                                        if flag2 then break end
                                                                    end

                                                                    xored = if not list[947](v4, buffer.readu32(v23, list[list[25]])) then list[532] else list[935]
                                                                end
                                                            end
                                                        elseif xored < 13999 then
                                                            if xored < 13998 then
                                                                xored = if flag then list[1002] else list[801]
                                                            else
                                                                xored = list[list[819]]
                                                            end
                                                        else
                                                            if not (xored < 15121) or xored ~= 13999 then
                                                                break
                                                            end

                                                            return buffer.readu8(v26, list[list[738]]), {buffer.readu8(v22, list[564]), v4}
                                                        end
                                                    end
                                                end)()
                                                xored = if fn then list[1031] else list[list[239]]
                                            elseif xored < 2993 then
                                                v3 = str
                                                xored = list[935]
                                            else
                                                xored = list[443]
                                            end
                                        elseif xored < 2996 then
                                            if xored < 2995 then
                                                v12 = v11
                                                v17 = v16
                                                v24 = v19
                                                flag2 = list[698](list[list[708]](v22, list[1017], list[list[1043]]), buffer.readu8(v23, list[list[305]]))

                                                xored = list[931]
                                            else
                                                callback9(list[list[737]](list[list[708]](v5, list[1072], list[list[304]]), buffer.readu8(v26, list[654]), buffer.readu8(v26, list[990])), {
                                                    tbl6[list[698](list[list[708]](v22, list[1012], list[1092]), buffer.readu8(v23, list[1057]))],
                                                    v3,
                                                })

                                                xored = list[list[591]]
                                            end
                                        else
                                            if xored < 2997 then
                                                return callback9(list[698](list[list[708]](v26, list[993], list[708]), buffer.readu8(v22, list[list[832]])), {flag, fn})
                                            end

                                            xored = if tbl6[list[698](list[list[708]](v23, list[1122], list[list[512]]), buffer.readu8(v26, list[866]))] ~= v2 then list[list[62]] else list[list[554]]
                                        end
                                    elseif xored < 3025 then
                                        if xored < 3011 then
                                            if xored < 3004 then
                                                if xored < 3001 then
                                                    if xored < 2999 then
                                                        v15 += list[list[885]]
                                                        xored = list[656]
                                                    elseif xored < 3000 then
                                                        xored = if list[947](fn, buffer.readu32(v26, list[list[656]])) then list[876] else list[650]
                                                    else
                                                        xored = if flag2 then list[916] else list[list[528]]
                                                    end
                                                elseif xored < 3002 then
                                                    fn = flag
                                                    xored = list[list[265]]
                                                elseif xored < 3003 then
                                                    xored = list[list[239]]
                                                else
                                                    tbl6[list[698](list[list[708]](v5, list[502], list[1092]), buffer.readu8(v18, list[list[549]]))] = v3

                                                    xored = list[842]
                                                end
                                            elseif xored < 3007 then
                                                if xored < 3005 then
                                                    flag2 = callback3(v3)
                                                    xored = list[list[227]]
                                                elseif xored < 3006 then
                                                    xored = list[1092]
                                                else
                                                    v12 = v11
                                                    v17 = v16
                                                    return callback9(list[698](list[list[708]](v22, list[596], list[list[796]]), buffer.readu8(v23, list[679])), flag)
                                                end
                                            elseif xored < 3009 then
                                                if xored < 3008 then
                                                    flag = v2
                                                    v2 = buffer.readu8(v5, list[642])
                                                    flag2 = buffer.readu8(v26, list[642])
                                                    v10 = v2
                                                    v8 = flag2
                                                    xored = list[486]
                                                else
                                                    xored = if v15 <= v13 then list[list[746]] else list[1044]
                                                end
                                            elseif xored < 3010 then
                                                v12 = v11
                                                v17 = v16

                                                flag = v3[list[698](list[list[708]](v22, list[list[93]], list[1002]), buffer.readu8(v18, list[1083]))](v3, callback3((list[list[737]](list[list[708]](v23, list[1010], list[1037]), buffer.readu8(v18, list[509]), buffer.readu8(v26, list[990])))))

                                                xored = list[793]
                                            else
                                                xored = if v10 <= v8 then list[832] else list[700]
                                            end
                                        elseif xored < 3018 then
                                            if xored < 3014 then
                                                if xored < 3012 then
                                                    xored = list[629]
                                                elseif xored < 3013 then
                                                    v19 = v15
                                                    xored = list[454]
                                                else
                                                    v24 = v19
                                                    v3 = list[list[737]](list[list[708]](v18, list[list[204]], list[978]), buffer.readu8(v18, list[509]), buffer.readu8(v5, list[990]))

                                                    xored = list[726]
                                                end
                                            elseif xored < 3016 then
                                                if xored < 3015 then
                                                    xored = list[1044]
                                                else
                                                    v24 = v19
                                                    v2 = flag2[list[list[737]](list[list[708]](v23, list[984], list[708]), buffer.readu8(v23, list[990]), buffer.readu8(v5, list[list[738]]))]

                                                    xored = if v2 then list[list[512]] else list[801]
                                                end
                                            elseif xored < 3017 then
                                                xored = if tbl6[list[list[737]](list[list[708]](v26, list[list[116]], list[list[1043]]), buffer.readu8(v23, list[1057]), buffer.readu8(v5, list[509]))] == nil then list[list[1074]] else list[list[267]]
                                            else
                                                v12 = v11
                                                v17 = v16

                                                flag = list[709][list[698](list[list[708]](v18, list[769], list[1002]), buffer.readu8(v18, list[list[27]]))](flag)
                                                xored = list[639]
                                            end
                                        elseif xored < 3021 then
                                            if xored < 3019 then
                                                v2, flag2 = v(flag)
                                                flag = not v2
                                                xored = if flag then list[442] else list[list[796]]
                                            elseif xored < 3020 then
                                                v2, v3 = list[list[726]](function() -- line 10848 · shares: [1] list
                                                    if not list then
                                                        ({})[1] = list
                                                    end

                                                    return list[588][{}]
                                                end, function() -- line 10853 · shares: [1] v26, [2] v5, [3] v18, [4] list, [5] v23
                                                    if not v26 then
                                                        ({})[1] = v5;
                                                        ({})[2] = v18;
                                                        ({})[3] = list;
                                                        ({})[4] = v23
                                                    end

                                                    return debug[list[698](list[list[708]](v23, list[559], list[1002]), buffer.readu8(v18, list[897]))](buffer.readu8(v26, list[list[738]]), (list[698](list[list[708]](v5, list[list[305]], list[list[885]]), buffer.readu8(v23, list[990]))))
                                                end)

                                                v2, flag2 = list[list[726]](function() -- line 10870 · shares: [1] list
                                                    if not list then
                                                        ({})[1] = list
                                                    end

                                                    return list[588]:__()
                                                end, function(arg1, arg2, arg3) -- line 10875 · shares: [1] v5, [2] list, [3] v22, [4] v18, [5] v26, [6] v23
                                                    if not arg3 then
                                                        ({})[1] = v5;
                                                        ({})[2] = list;
                                                        ({})[3] = v22;
                                                        ({})[4] = v18;
                                                        ({})[5] = v26;
                                                        ({})[6] = v23;
                                                        ({})[7] = arg1;
                                                        ({})[8] = arg2;
                                                        ({})[9] = arg3
                                                    end

                                                    return debug[list[list[737]](list[list[708]](v23, list[list[445]], list[list[239]]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v26, list[list[305]]))](buffer.readu8(v26, list[list[738]]), (list[list[737]](list[list[708]](v18, list[707], list[935]), buffer.readu8(v18, list[866]), buffer.readu8(v5, list[642]))))
                                                end)

                                                xored = list[list[819]]
                                            else
                                                xored = if not list[947](fn, buffer.readu32(v23, list[992])) then list[list[885]] else list[list[526]]
                                            end
                                        elseif xored < 3023 then
                                            if xored < 3022 then
                                                v24 = v19
                                                v2 = v3[list[list[737]](list[list[708]](v5, list[1126], list[712]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v5, list[544]))]

                                                xored = list[449]
                                            else
                                                xored = if v3 then list[1034] else list[443]
                                            end
                                        elseif xored < 3024 then
                                            v12 = v11
                                            v17 = v16
                                            v24 = v19
                                            v2 = list[698](list[list[708]](v18, list[1047], list[712]), buffer.readu8(v23, list[613]))

                                            flag2 = nil
                                            xored = list[list[798]]
                                        else
                                            flag2 = flag[list[698](list[list[708]](v26, list[751], list[1092]), buffer.readu8(v5, list[list[27]]))](flag, v27)
                                            xored = list[list[610]]
                                        end
                                    elseif xored < 3039 then
                                        if xored < 3032 then
                                            if xored < 3028 then
                                                if xored < 3026 then
                                                    v12 = v11
                                                    v17 = v16
                                                    return callback9(list[698](list[list[708]](v22, list[list[257]], list[list[526]]), buffer.readu8(v26, list[544])), flag)
                                                end

                                                if xored < 3027 then
                                                    xored = if flag2 then list[list[469]] else list[1022]
                                                else
                                                    xored = list[712]
                                                end
                                            elseif xored < 3030 then
                                                if xored < 3029 then
                                                    fn = nil
                                                    flag = nil
                                                    xored = list[809]
                                                else
                                                    fn, flag = v(function(arg1, arg2) -- line 10953 · shares: [1] v26, [2] list
                                                        if not arg2 then
                                                            ({})[1] = v26;
                                                            ({})[2] = list;
                                                            ({})[3] = arg1;
                                                            ({})[4] = arg2
                                                        end

                                                        local v = list[588]

                                                        return v[list[list[737]](list[list[708]](v26, list[list[991]], list[list[1088]]), buffer.readu8(v26, list[866]), buffer.readu8(v26, list[509]))](v)
                                                    end)

                                                    flag2 = fn
                                                    xored = if flag2 then list[list[610]] else list[768]
                                                end
                                            elseif xored < 3031 then
                                                fn = nil
                                                xored = list[923]
                                            else
                                                xored = list[list[528]]
                                            end
                                        elseif xored < 3035 then
                                            if xored < 3033 then
                                                xored = if list[947](fn, buffer.readu32(v23, list[992])) then list[list[304]] else list[list[792]]
                                            elseif xored < 3034 then
                                                v16 = v15
                                                xored = list[list[325]]
                                            else
                                                xored = list[708]
                                            end
                                        elseif xored < 3037 then
                                            if xored < 3036 then
                                                flag2 = v3
                                                xored = list[1037]
                                            else
                                                v12 = v11
                                                v17 = v16
                                                v24 = v19
                                                v2 = v3[list[698](list[list[708]](v23, list[list[596]], list[list[378]]), buffer.readu8(v23, list[613]))]

                                                xored = if v2 then list[449] else list[1082]
                                            end
                                        elseif xored < 3038 then
                                            flag = v3
                                            v2 = buffer.readu8(v5, list[642])
                                            v3 = buffer.readu8(v26, list[642])
                                            v15 = v2
                                            v13 = v3
                                            xored = list[656]
                                        else
                                            v12 = v11

                                            flag = flag2[list[698](list[list[708]](v26, list[924], list[1002]), buffer.readu8(v5, list[list[923]]))](flag2, callback3((list[698](list[list[708]](v5, list[906], list[650]), buffer.readu8(v22, list[990])))))

                                            xored = list[list[796]]
                                        end
                                    else
                                        if not (xored < 6396) then break end
                                        if xored < 3066 then
                                            if xored < 3064 then
                                                if xored ~= 3039 then break end
                                                xored = list[712]
                                            elseif xored < 3065 then
                                                xored = if v2 then list[1004] else list[792]
                                            else
                                                callback9(v2, {flag2})
                                                xored = list[792]
                                            end
                                        else
                                            if not (xored < 4006) then break end
                                            if xored < 3067 then
                                                v6[list[list[737]](list[list[708]](v22, list[list[949]], list[list[1043]]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v23, list[509]))](v6, {[v37] = true})
                                                flag, fn = v(function(arg1, arg2) -- line 11044 · shares: [1] list
                                                    if not arg2 then
                                                        ({})[1] = list;
                                                        ({})[2] = arg1;
                                                        ({})[3] = arg2
                                                    end

                                                    return list[588][{}]
                                                end)

                                                flag2 = flag
                                                xored = if flag2 then list[list[442]] else list[469]
                                            else
                                                if xored ~= 3067 then break end
                                                v2, v3 = v(flag)
                                                flag = not v2
                                                xored = if flag then list[list[1110]] else list[793]
                                            end
                                        end
                                    end
                                end
                            end
                            xored = list[567]
                        end
                    elseif xored < 1413 then
                        xored = list[1]
                    else
                        tbl5 = list[197]((tbl4 * buffer.readu8(v5, list[642]) + buffer.readu8(v22, list[312])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v26, list[509]) + buffer.readu8(v22, list[312])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v23, list[866]) + buffer.readu8(v23, list[789])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                        v43 = list[197]((tbl4 * buffer.readu8(v5, list[990]) + buffer.readu8(v5, list[37])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v26, list[546]) + buffer.readu8(v18, list[938])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v5, list[564]) + buffer.readu8(v5, list[544])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                        v44 = list[197]((tbl4 * buffer.readu8(v5, list[990]) + buffer.readu8(v26, list[546])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v18, list[37]) + buffer.readu8(v23, list[509])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v5, list[990]) + buffer.readu8(v26, list[37])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                        v45 = list[197]((tbl4 * buffer.readu8(v23, list[509]) + buffer.readu8(v23, list[509])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v23, list[509]) + buffer.readu8(v5, list[642])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (tbl4 * buffer.readu8(v5, list[564]) + buffer.readu8(v5, list[37])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                        local v243 = vector.dot(vector.cross(tbl5, v43), vector.cross(v44, v45))
                        xored = if v243 == vector.dot(tbl5, v44) * vector.dot(v43, v45) - vector.dot(tbl5, v45) * vector.dot(v43, v44) then list[718] else list[941]
                    end
                elseif xored < 1417 then
                    if xored < 1415 then
                        xored = list[965]
                    elseif xored < 1416 then
                        xored = list[786]
                    else
                        xored = if str <= buffer.readu8(v22, list[312]) then list[715] else list[1095]
                    end
                elseif xored < 1419 then
                    xored = if xored < 1418 then list[324] else list[712]
                elseif xored < 1420 then
                    v59 = v58
                    flag[v59] = callback18
                    xored = list[1102]
                else
                    v56 = v53
                    xored = list[166]
                end
            elseif xored < 1428 then
                if xored < 1424 then
                    if xored < 1422 then
                        xored = list[809]
                    elseif xored < 1423 then
                        xored = if str <= buffer.readu8(v22, list[230]) then list[318] else list[129]
                    else
                        xored = list[634]
                    end
                elseif xored < 1426 then
                    if xored < 1425 then
                        local v245 = tbl4 * buffer.readu32(v23, list[490]) + buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[642])

                        xored = if v245 >= tbl4 * buffer.readu32(v23, list[490]) + buffer.readu8(v5, list[642]) + buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[37]) then list[1069] else list[850]
                    else
                        count = nil
                        count = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[37])
                        count = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[37])
                        count = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                        xored = list[1081]
                    end
                elseif xored < 1427 then
                    xored = list[6]
                else
                    xored = if str <= buffer.readu8(v5, list[564]) then list[463] else list[359]
                end
            elseif xored < 1432 then
                if xored < 1430 then
                    if xored < 1429 then
                        xored = list[569]
                    else
                        tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                        xored = list[1037]
                    end
                elseif xored < 1431 then
                    xored = list[1107]
                else
                    xored = if list[947]((count * buffer.readu8(v5, list[37]) + buffer.readu8(v5, list[642])) % buffer.readu8(v18, list[938]), buffer.readu32(v5, list[444])) then list[641] else list[870]
                end
            elseif xored < 1434 then
                if xored < 1433 then
                    callback3 = flag[callback18(callback18)]
                    xored = list[68]
                else
                    env2 = callback18[callback3((list[698](list[10](v23, list[7], list[221]), buffer.readu8(v22, list[71]))))]
                    xored = list[880]
                end
            elseif xored < 1435 then
                callback19 = str
                xored = list[1121]
            else
                xored = list[935]
            end
        elseif xored < 1492 then
            if xored < 1464 then
                if xored < 1450 then
                    if xored < 1443 then
                        if xored < 1439 then
                            if xored < 1437 then
                                xored = list[408]
                            elseif xored < 1438 then
                                xored = list[1043]
                            else
                                local xored2 = bit32.bxor(bit32.bxor(bit32.bxor(bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[938])), string.byte(tostring(callback10))), buffer.readu8(v26, list[990])), buffer.readu32(v5, list[552])), buffer.readu32(v26, list[176])), bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[938])), string.byte(tostring(callback10))), buffer.readu8(v26, list[990])), buffer.readu32(v5, list[176])), buffer.readu32(v22, list[697]))), buffer.readu32(v26, list[176])), buffer.readu32(v22, list[697]))

                                xored = if xored2 == bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v5, list[938])), string.byte(tostring(callback10))), buffer.readu8(v26, list[990])) then list[746] else list[305]
                            end
                        elseif xored < 1441 then
                            if xored < 1440 then
                                xored = list[1014]
                            else
                                xored = if str <= buffer.readu8(v26, list[546]) then list[91] else list[915]
                            end
                        elseif xored < 1442 then
                            callback3 = list[588][callback15((list[188](list[10](v5, list[878], list[650]), buffer.readu8(v5, list[613]), buffer.readu8(v5, list[37]))))]

                            xored = list[591]
                        else
                            xored = list[462]
                        end
                    elseif xored < 1446 then
                        if xored < 1444 then
                            v7 = nil
                            v31 = nil
                            callback13 = nil
                            v29 = nil
                            callback8 = nil
                            callback2 = nil
                            callback12 = nil
                            callback19 = nil
                            v6 = nil
                            callback10 = nil
                            callback = nil
                            v2 = nil
                            callback15 = nil
                            callback18 = nil
                            flag = nil
                            callback11 = nil
                            env2 = nil
                            v4 = nil
                            v3 = nil
                            callback7 = nil
                            v19 = nil
                            v35 = nil
                            v33 = nil
                            object = nil
                            version2 = nil
                            list2 = nil
                            v17 = nil
                            v24 = nil
                            v21 = nil
                            v13 = nil
                            tbl2 = nil
                            v15 = nil
                            v37 = nil
                            count2 = nil
                            callback21 = nil
                            callback26 = nil
                            callback25 = nil
                            tbl6 = nil
                            callback24 = nil
                            fn2 = nil
                            fn = nil
                            callback27 = nil
                            callback22 = nil
                            v42 = nil
                            callback17 = nil
                            count3 = nil
                            callback23 = nil
                            version3 = nil
                            callback20 = nil
                            v20 = nil
                            v16 = nil
                            tbl = nil
                            callback9 = nil
                            tbl4 = nil
                            tbl4 = buffer.readu8(v5, list[1083])
                            xored = list[809]
                        elseif xored < 1445 then
                            xored = list[289]
                        else
                            callback26 = list[688]
                            callback25 = list[283]
                            tbl6 = {}
                            callback24 = function(...) -- line 11357 · shares: [1] v32, [2] v22, [3] tbl6, [4] v21, [5] list, [6] v26, [7] callback9, [8] v27, [9] v18, [10] v, [11] callback3, [12] v31, [13] v23, [14] v6, [15] callback13, [16] v20, [17] v5, [18] v28, [19] v29, [20] v39, [21] v37
                                if not v32 then
                                    ({
                                        v22,
                                        tbl6,
                                        v21,
                                        list,
                                        v26,
                                        callback9,
                                        v27,
                                        v18,
                                        v,
                                        callback3,
                                        callback3,
                                        v31,
                                        v23,
                                        v6,
                                        callback13,
                                        callback3,
                                    })[17] = v20;
                                    ({
                                        v22,
                                        tbl6,
                                        v21,
                                        list,
                                        v26,
                                        callback9,
                                        v27,
                                        v18,
                                        v,
                                        callback3,
                                        callback3,
                                        v31,
                                        v23,
                                        v6,
                                        callback13,
                                        callback3,
                                    })[18] = callback3
                                end

                                local fn
                                local flag
                                local v2
                                local v3
                                local flag2
                                local v4
                                local v7
                                local str
                                local v8
                                local v9
                                local v10
                                local v11
                                local v12
                                local v13
                                local v14
                                local v15
                                local v16
                                local v17
                                local v19
                                local v24
                                local xored
                                xored = list[724]

                                while true do
                                    xored = bit32.bxor(xored, list[683])

                                    if xored < 2998 then
                                        if xored < 2970 then
                                            if xored < 2956 then
                                                if xored < 2949 then
                                                    if xored < 2946 then
                                                        if xored < 2944 then
                                                            return
                                                        elseif xored < 2945 then
                                                            flag2 = not fn[list[698](list[list[708]](v22, list[list[784]], list[1092]), buffer.readu8(v26, list[579]))](fn, v27)
                                                            xored = list[list[442]]
                                                        else
                                                            v12 = v11
                                                            v17 = v16
                                                            v24 = v19
                                                            v2 = list[698](list[list[708]](v18, list[list[235]], list[list[798]]), buffer.readu8(v23, list[list[741]]))

                                                            v3 = nil
                                                            xored = list[785]
                                                        end
                                                    elseif xored < 2947 then
                                                        v2, flag2 = v(getfenv, v3)
                                                        v3 = v2
                                                        xored = if v3 then list[1002] else list[list[168]]
                                                    elseif xored < 2948 then
                                                        callback9(v2, {v3})
                                                        xored = list[list[162]]
                                                    else
                                                        fn = function() -- line 11420
                                                            return game:WaitForChild("", 5)
                                                        end

                                                        flag = list[list[1096]][list[list[737]](list[list[708]](v18, list[list[934]], list[708]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v5, list[990]))](fn)
                                                        fn = buffer.readu8(v26, list[1083])
                                                        v2 = buffer.readu8(v5, list[642])
                                                        v3 = buffer.readu8(v26, list[509])
                                                        v15 = v2
                                                        v13 = v3
                                                        xored = list[450]
                                                    end
                                                elseif xored < 2952 then
                                                    if xored < 2950 then
                                                        return callback9(list[698](list[list[708]](v5, list[list[420]], list[691]), buffer.readu8(v23, list[list[305]])), {fn, flag})
                                                    end

                                                    if xored < 2951 then
                                                        xored = if v15 <= v13 then list[list[1084]] else list[534]
                                                    else
                                                        xored = list[list[287]]
                                                    end
                                                elseif xored < 2954 then
                                                    if xored < 2953 then
                                                        v4 = v3
                                                        xored = list[list[398]]
                                                    else
                                                        callback9(list[list[737]](list[list[708]](v23, list[1133], list[list[62]]), buffer.readu8(v26, list[list[549]]), buffer.readu8(v26, list[1083])), {
                                                            tbl6[list[list[737]](list[list[708]](v26, list[494], list[691]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v22, list[492]))],
                                                            v2,
                                                        })

                                                        xored = list[list[554]]
                                                    end
                                                elseif xored < 2955 then
                                                    v15 += list[list[885]]
                                                    xored = list[450]
                                                else
                                                    tbl6[list[698](list[list[708]](v22, list[list[68]], list[list[512]]), buffer.readu8(v26, list[list[741]]))] = v2

                                                    xored = list[list[267]]
                                                end
                                            elseif xored < 2963 then
                                                if xored < 2959 then
                                                    if xored < 2957 then
                                                        v24 = v19

                                                        v3, v7 = v4[list[list[737]](list[list[708]](v22, list[list[77]], list[469]), buffer.readu8(v5, list[1057]), buffer.readu8(v26, list[509]))]()
                                                        v12 = v11
                                                        v17 = v16

                                                        str = v3 .. list[698](list[list[708]](v23, list[list[832]], list[list[885]]), buffer.readu8(v22, list[875])) .. v7
                                                        xored = list[732]
                                                    elseif xored < 2958 then
                                                        xored = if fn then list[532] else list[list[90]]
                                                    else
                                                        xored = list[935]
                                                    end
                                                elseif xored < 2961 then
                                                    if xored < 2960 then
                                                        xored = list[766]
                                                    else
                                                        v24 = v19
                                                        xored = if v4[list[list[737]](list[list[708]](v18, list[list[518]], list[656]), buffer.readu8(v5, list[1057]), buffer.readu8(v23, list[866]))] then list[list[543]] else list[list[301]]
                                                    end
                                                elseif xored < 2962 then
                                                    fn = flag
                                                    xored = list[list[633]]
                                                else
                                                    xored = if v2 then list[691] else list[list[162]]
                                                end
                                            elseif xored < 2966 then
                                                if xored < 2964 then
                                                    xored = if tbl6[list[698](list[list[708]](v22, list[list[662]], list[1092]), buffer.readu8(v22, list[897]))] ~= v3 then list[731] else list[list[591]]
                                                else
                                                    xored = if xored < 2965 then list[list[138]] else list[list[227]]
                                                end
                                            elseif xored < 2968 then
                                                if xored < 2967 then
                                                    v12 = v11
                                                    v17 = v16
                                                    v24 = v19

                                                    v3, v2 = debug[list[698](list[list[708]](v18, list[605], list[1002]), buffer.readu8(v26, list[list[741]]))](flag, v24, (list[698](list[list[708]](v18, list[502], list[1092]), buffer.readu8(v22, list[list[832]]))))

                                                    xored = if not v3 then list[743] else list[list[1088]]
                                                else
                                                    flag2 = str
                                                    xored = list[list[227]]
                                                end
                                            elseif xored < 2969 then
                                                xored = list[1088]
                                            else
                                                return callback9((list[list[737]](list[list[708]](v26, list[list[554]], list[list[528]]), buffer.readu8(v22, list[579]), buffer.readu8(v23, list[861]))))
                                            end
                                        elseif xored < 2984 then
                                            if xored < 2977 then
                                                if xored < 2973 then
                                                    if xored < 2971 then
                                                        v12 = v11
                                                        v17 = v16
                                                        v24 = v19
                                                        v2 = flag2[list[698](list[list[708]](v5, list[list[948]], list[list[378]]), buffer.readu8(v23, list[938]))]

                                                        xored = list[list[512]]
                                                    elseif xored < 2972 then
                                                        v24 = v19
                                                        callback9(list[list[737]](list[list[708]](v23, list[list[437]], list[772]), buffer.readu8(v5, list[679]), buffer.readu8(v5, list[938])), {buffer.readu8(v5, list[642]), fn})

                                                        xored = list[list[526]]
                                                    else
                                                        flag = v3
                                                        fn = flag2
                                                        xored = list[978]
                                                    end
                                                elseif xored < 2975 then
                                                    if xored < 2974 then
                                                        v12 = v11

                                                        flag = list[709][list[698](list[list[708]](v5, list[491], list[1002]), buffer.readu8(v22, list[list[27]]))](flag)
                                                        xored = list[510]
                                                    else
                                                        v3 = flag2
                                                        xored = list[list[168]]
                                                    end
                                                else
                                                    if xored < 2976 then
                                                        return
                                                    end

                                                    xored = if flag2 then list[list[421]] else list[list[368]]
                                                end
                                            elseif xored < 2980 then
                                                if xored < 2978 then
                                                    v2, v3 = v(getfenv, buffer.readu8(v26, list[1083]))
                                                    flag2 = v2
                                                    xored = if flag2 then list[list[15]] else list[1037]
                                                elseif xored < 2979 then
                                                    v12 = v11
                                                    v17 = v16
                                                    v24 = v19

                                                    v7, flag2 = v4[list[698](list[list[708]](v23, list[699], list[list[1043]]), buffer.readu8(v18, list[list[549]]))]()

                                                    str = v7 .. list[698](list[list[708]](v5, list[1120], list[list[885]]), buffer.readu8(v18, list[579])) .. flag2
                                                    xored = list[list[419]]
                                                else
                                                    v3 = flag
                                                    v2 = fn
                                                    xored = if tbl6[list[698](list[list[708]](v18, list[list[784]], list[1092]), buffer.readu8(v18, list[861]))] == nil then list[885] else list[842]
                                                end
                                            elseif xored < 2982 then
                                                if xored < 2981 then
                                                    fn = nil
                                                    xored = list[738]
                                                else
                                                    v10 += list[list[885]]
                                                    xored = list[486]
                                                end
                                            elseif xored < 2983 then
                                                xored = list[list[105]]
                                            else
                                                v24 = v19
                                                xored = if v4[list[list[737]](list[list[708]](v18, list[list[257]], list[list[526]]), buffer.readu8(v23, list[990]), buffer.readu8(v26, list[875]))] then list[list[218]] else list[882]
                                            end
                                        elseif xored < 2991 then
                                            if xored < 2987 then
                                                if xored < 2985 then
                                                    return callback9((list[list[737]](list[list[708]](v5, list[674], list[885]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v5, list[642]))))
                                                end

                                                if xored < 2986 then
                                                    v11 = v10
                                                    xored = list[list[378]]
                                                else
                                                    xored = if fn then list[1042] else list[list[194]]
                                                end
                                            elseif xored < 2989 then
                                                if xored < 2988 then
                                                    v3 = callback3(flag2)
                                                    xored = list[935]
                                                else
                                                    fn += buffer.readu8(v5, list[642])
                                                    xored = list[list[1043]]
                                                end
                                            elseif xored < 2990 then
                                                v4 = flag2
                                                xored = list[list[1021]]
                                            else
                                                xored = list[list[105]]
                                            end
                                        elseif xored < 2994 then
                                            if xored < 2992 then
                                                fn, flag = v28(function() -- line 11701 · shares: [1] v29, [2] v, [3] list, [4] v5, [5] callback13, [6] v39, [7] v22, [8] v23, [9] v26, [10] v31
                                                    if not v29 then
                                                        ({})[1] = v;
                                                        ({})[2] = list;
                                                        ({})[3] = v5;
                                                        ({})[4] = callback13;
                                                        ({})[5] = v39;
                                                        ({})[6] = v22;
                                                        ({})[7] = v29
                                                    end

                                                    local v2, v3, v4, v6, flag, v7, flag2, v8
                                                    local xored
                                                    xored = list[list[378]]

                                                    while true do
                                                        xored = bit32.bxor(xored, list[644])

                                                        if xored < 13992 then break end

                                                        if xored < 13997 then
                                                            if xored < 13994 then
                                                                if xored < 13993 then
                                                                    return buffer.readu8(v5, list[642]), {v4, v3}
                                                                end

                                                                flag = not list[947](v3, buffer.readu32(v23, list[list[25]]))

                                                                xored = list[list[885]]
                                                            else
                                                                if xored < 13995 then break end

                                                                if xored < 13996 then
                                                                    v3 = buffer.readu8(v26, list[1083])
                                                                    local function fn() -- line 11730 · shares: [1] v3, [2] v29, [3] v31, [4] fn
                                                                        v3 = v3 + 1
                                                                        if 195 < v3 then
                                                                            game:GetService(v29)
                                                                        end

                                                                        return v31(fn)()
                                                                    end

                                                                    v4, v6 = v(fn)
                                                                    flag = v4
                                                                    xored = if flag then list[list[885]] else list[1092]
                                                                else
                                                                    v4 = buffer.readu8(v26, list[1083])
                                                                    flag2 = false
                                                                    for item in callback13(v6, v39) do
                                                                        v8 = item
                                                                        local v12 = v8
                                                                        local v13
                                                                        v13 = list[list[885]]

                                                                        while true do
                                                                            if v13 < 1 then
                                                                                flag2 = true
                                                                                v13 = list[935]
                                                                            else
                                                                                if not (v13 < 2) then
                                                                                    break
                                                                                end

                                                                                v4 += buffer.readu8(v5, list[642])
                                                                                v13 = list[935]
                                                                            end
                                                                        end

                                                                        if flag2 then break end
                                                                    end

                                                                    xored = if not list[947](v4, buffer.readu32(v23, list[list[25]])) then list[532] else list[935]
                                                                end
                                                            end
                                                        elseif xored < 13999 then
                                                            if xored < 13998 then
                                                                xored = if flag then list[1002] else list[801]
                                                            else
                                                                xored = list[list[819]]
                                                            end
                                                        else
                                                            if not (xored < 15121) or xored ~= 13999 then
                                                                break
                                                            end

                                                            return buffer.readu8(v26, list[list[738]]), {buffer.readu8(v22, list[564]), v4}
                                                        end
                                                    end
                                                end)()
                                                xored = if fn then list[1031] else list[list[239]]
                                            elseif xored < 2993 then
                                                v3 = str
                                                xored = list[935]
                                            else
                                                xored = list[443]
                                            end
                                        elseif xored < 2996 then
                                            if xored < 2995 then
                                                v12 = v11
                                                v17 = v16
                                                v24 = v19
                                                flag2 = list[698](list[list[708]](v22, list[1017], list[list[1043]]), buffer.readu8(v23, list[list[305]]))

                                                xored = list[931]
                                            else
                                                callback9(list[list[737]](list[list[708]](v5, list[1072], list[list[304]]), buffer.readu8(v26, list[654]), buffer.readu8(v26, list[990])), {
                                                    tbl6[list[698](list[list[708]](v22, list[1012], list[1092]), buffer.readu8(v23, list[1057]))],
                                                    v3,
                                                })

                                                xored = list[list[591]]
                                            end
                                        else
                                            if xored < 2997 then
                                                return callback9(list[698](list[list[708]](v26, list[993], list[708]), buffer.readu8(v22, list[list[832]])), {flag, fn})
                                            end

                                            xored = if tbl6[list[698](list[list[708]](v23, list[1122], list[list[512]]), buffer.readu8(v26, list[866]))] ~= v2 then list[list[62]] else list[list[554]]
                                        end
                                    elseif xored < 3025 then
                                        if xored < 3011 then
                                            if xored < 3004 then
                                                if xored < 3001 then
                                                    if xored < 2999 then
                                                        v15 += list[list[885]]
                                                        xored = list[656]
                                                    elseif xored < 3000 then
                                                        xored = if list[947](fn, buffer.readu32(v26, list[list[656]])) then list[876] else list[650]
                                                    else
                                                        xored = if flag2 then list[916] else list[list[528]]
                                                    end
                                                elseif xored < 3002 then
                                                    fn = flag
                                                    xored = list[list[265]]
                                                elseif xored < 3003 then
                                                    xored = list[list[239]]
                                                else
                                                    tbl6[list[698](list[list[708]](v5, list[502], list[1092]), buffer.readu8(v18, list[list[549]]))] = v3

                                                    xored = list[842]
                                                end
                                            elseif xored < 3007 then
                                                if xored < 3005 then
                                                    flag2 = callback3(v3)
                                                    xored = list[list[227]]
                                                elseif xored < 3006 then
                                                    xored = list[1092]
                                                else
                                                    v12 = v11
                                                    v17 = v16
                                                    return callback9(list[698](list[list[708]](v22, list[596], list[list[796]]), buffer.readu8(v23, list[679])), flag)
                                                end
                                            elseif xored < 3009 then
                                                if xored < 3008 then
                                                    flag = v2
                                                    v2 = buffer.readu8(v5, list[642])
                                                    flag2 = buffer.readu8(v26, list[642])
                                                    v10 = v2
                                                    v8 = flag2
                                                    xored = list[486]
                                                else
                                                    xored = if v15 <= v13 then list[list[746]] else list[1044]
                                                end
                                            elseif xored < 3010 then
                                                v12 = v11
                                                v17 = v16

                                                flag = v3[list[698](list[list[708]](v22, list[list[93]], list[1002]), buffer.readu8(v18, list[1083]))](v3, callback3((list[list[737]](list[list[708]](v23, list[1010], list[1037]), buffer.readu8(v18, list[509]), buffer.readu8(v26, list[990])))))

                                                xored = list[793]
                                            else
                                                xored = if v10 <= v8 then list[832] else list[700]
                                            end
                                        elseif xored < 3018 then
                                            if xored < 3014 then
                                                if xored < 3012 then
                                                    xored = list[629]
                                                elseif xored < 3013 then
                                                    v19 = v15
                                                    xored = list[454]
                                                else
                                                    v24 = v19
                                                    v3 = list[list[737]](list[list[708]](v18, list[list[204]], list[978]), buffer.readu8(v18, list[509]), buffer.readu8(v5, list[990]))

                                                    xored = list[726]
                                                end
                                            elseif xored < 3016 then
                                                if xored < 3015 then
                                                    xored = list[1044]
                                                else
                                                    v24 = v19
                                                    v2 = flag2[list[list[737]](list[list[708]](v23, list[984], list[708]), buffer.readu8(v23, list[990]), buffer.readu8(v5, list[list[738]]))]

                                                    xored = if v2 then list[list[512]] else list[801]
                                                end
                                            elseif xored < 3017 then
                                                xored = if tbl6[list[list[737]](list[list[708]](v26, list[list[116]], list[list[1043]]), buffer.readu8(v23, list[1057]), buffer.readu8(v5, list[509]))] == nil then list[list[1074]] else list[list[267]]
                                            else
                                                v12 = v11
                                                v17 = v16

                                                flag = list[709][list[698](list[list[708]](v18, list[769], list[1002]), buffer.readu8(v18, list[list[27]]))](flag)
                                                xored = list[639]
                                            end
                                        elseif xored < 3021 then
                                            if xored < 3019 then
                                                v2, flag2 = v(flag)
                                                flag = not v2
                                                xored = if flag then list[442] else list[list[796]]
                                            elseif xored < 3020 then
                                                v2, v3 = list[list[726]](function() -- line 11968 · shares: [1] list
                                                    if not list then
                                                        ({})[1] = list
                                                    end

                                                    return list[588][{}]
                                                end, function() -- line 11973 · shares: [1] v26, [2] v5, [3] v18, [4] list, [5] v23
                                                    if not v26 then
                                                        ({})[1] = v5;
                                                        ({})[2] = v18;
                                                        ({})[3] = list;
                                                        ({})[4] = v23
                                                    end

                                                    return debug[list[698](list[list[708]](v23, list[559], list[1002]), buffer.readu8(v18, list[897]))](buffer.readu8(v26, list[list[738]]), (list[698](list[list[708]](v5, list[list[305]], list[list[885]]), buffer.readu8(v23, list[990]))))
                                                end)

                                                v2, flag2 = list[list[726]](function() -- line 11990 · shares: [1] list
                                                    if not list then
                                                        ({})[1] = list
                                                    end

                                                    return list[588]:__()
                                                end, function(arg1, arg2, arg3) -- line 11995 · shares: [1] v5, [2] list, [3] v22, [4] v18, [5] v26, [6] v23
                                                    if not arg3 then
                                                        ({})[1] = v5;
                                                        ({})[2] = list;
                                                        ({})[3] = v22;
                                                        ({})[4] = v18;
                                                        ({})[5] = v26;
                                                        ({})[6] = v23;
                                                        ({})[7] = arg1;
                                                        ({})[8] = arg2;
                                                        ({})[9] = arg3
                                                    end

                                                    return debug[list[list[737]](list[list[708]](v23, list[list[445]], list[list[239]]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v26, list[list[305]]))](buffer.readu8(v26, list[list[738]]), (list[list[737]](list[list[708]](v18, list[707], list[935]), buffer.readu8(v18, list[866]), buffer.readu8(v5, list[642]))))
                                                end)

                                                xored = list[list[819]]
                                            else
                                                xored = if not list[947](fn, buffer.readu32(v23, list[992])) then list[list[885]] else list[list[526]]
                                            end
                                        elseif xored < 3023 then
                                            if xored < 3022 then
                                                v24 = v19
                                                v2 = v3[list[list[737]](list[list[708]](v5, list[1126], list[712]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v5, list[544]))]

                                                xored = list[449]
                                            else
                                                xored = if v3 then list[1034] else list[443]
                                            end
                                        elseif xored < 3024 then
                                            v12 = v11
                                            v17 = v16
                                            v24 = v19
                                            v2 = list[698](list[list[708]](v18, list[1047], list[712]), buffer.readu8(v23, list[613]))

                                            flag2 = nil
                                            xored = list[list[798]]
                                        else
                                            flag2 = flag[list[698](list[list[708]](v26, list[751], list[1092]), buffer.readu8(v5, list[list[27]]))](flag, v27)
                                            xored = list[list[610]]
                                        end
                                    elseif xored < 3039 then
                                        if xored < 3032 then
                                            if xored < 3028 then
                                                if xored < 3026 then
                                                    v12 = v11
                                                    v17 = v16
                                                    return callback9(list[698](list[list[708]](v22, list[list[257]], list[list[526]]), buffer.readu8(v26, list[544])), flag)
                                                end

                                                if xored < 3027 then
                                                    xored = if flag2 then list[list[469]] else list[1022]
                                                else
                                                    xored = list[712]
                                                end
                                            elseif xored < 3030 then
                                                if xored < 3029 then
                                                    fn = nil
                                                    flag = nil
                                                    xored = list[809]
                                                else
                                                    fn, flag = v(function(arg1, arg2) -- line 12073 · shares: [1] v26, [2] list
                                                        if not arg2 then
                                                            ({})[1] = v26;
                                                            ({})[2] = list;
                                                            ({})[3] = arg1;
                                                            ({})[4] = arg2
                                                        end

                                                        local v = list[588]

                                                        return v[list[list[737]](list[list[708]](v26, list[list[991]], list[list[1088]]), buffer.readu8(v26, list[866]), buffer.readu8(v26, list[509]))](v)
                                                    end)

                                                    flag2 = fn
                                                    xored = if flag2 then list[list[610]] else list[768]
                                                end
                                            elseif xored < 3031 then
                                                fn = nil
                                                xored = list[923]
                                            else
                                                xored = list[list[528]]
                                            end
                                        elseif xored < 3035 then
                                            if xored < 3033 then
                                                xored = if list[947](fn, buffer.readu32(v23, list[992])) then list[list[304]] else list[list[792]]
                                            elseif xored < 3034 then
                                                v16 = v15
                                                xored = list[list[325]]
                                            else
                                                xored = list[708]
                                            end
                                        elseif xored < 3037 then
                                            if xored < 3036 then
                                                flag2 = v3
                                                xored = list[1037]
                                            else
                                                v12 = v11
                                                v17 = v16
                                                v24 = v19
                                                v2 = v3[list[698](list[list[708]](v23, list[list[596]], list[list[378]]), buffer.readu8(v23, list[613]))]

                                                xored = if v2 then list[449] else list[1082]
                                            end
                                        elseif xored < 3038 then
                                            flag = v3
                                            v2 = buffer.readu8(v5, list[642])
                                            v3 = buffer.readu8(v26, list[642])
                                            v15 = v2
                                            v13 = v3
                                            xored = list[656]
                                        else
                                            v12 = v11

                                            flag = flag2[list[698](list[list[708]](v26, list[924], list[1002]), buffer.readu8(v5, list[list[923]]))](flag2, callback3((list[698](list[list[708]](v5, list[906], list[650]), buffer.readu8(v22, list[990])))))

                                            xored = list[list[796]]
                                        end
                                    else
                                        if not (xored < 6396) then break end
                                        if xored < 3066 then
                                            if xored < 3064 then
                                                if xored ~= 3039 then break end
                                                xored = list[712]
                                            elseif xored < 3065 then
                                                xored = if v2 then list[1004] else list[792]
                                            else
                                                callback9(v2, {flag2})
                                                xored = list[792]
                                            end
                                        else
                                            if not (xored < 4006) then break end
                                            if xored < 3067 then
                                                v6[list[list[737]](list[list[708]](v22, list[list[949]], list[list[1043]]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v23, list[509]))](v6, {[v37] = true})
                                                flag, fn = v(function(arg1, arg2) -- line 12164 · shares: [1] list
                                                    if not arg2 then
                                                        ({})[1] = list;
                                                        ({})[2] = arg1;
                                                        ({})[3] = arg2
                                                    end

                                                    return list[588][{}]
                                                end)

                                                flag2 = flag
                                                xored = if flag2 then list[list[442]] else list[469]
                                            else
                                                if xored ~= 3067 then break end
                                                v2, v3 = v(flag)
                                                flag = not v2
                                                xored = if flag then list[list[1110]] else list[793]
                                            end
                                        end
                                    end
                                end
                            end
                            xored = list[567]
                        end
                    elseif xored < 1448 then
                        if xored < 1447 then
                            local tbl7 = {
                                version3((version3((version3((version3((version3((list[698](list[10](v5, list[48], list[30]), buffer.readu8(v5, list[789])))))))))))),
                                version3((version3((version3((list[698](list[10](v5, list[48], list[30]), buffer.readu8(v5, list[789])))))))),
                                version3((version3(version3))),
                                version3((list[698](list[10](v23, list[102], list[30]), buffer.readu8(v23, list[642])))),
                                version3((version3((list[698](list[10](v23, list[102], list[30]), buffer.readu8(v23, list[642])))))),
                                version3((list[698](list[10](v5, list[48], list[30]), buffer.readu8(v5, list[789])))),
                                version3((version3((list[698](list[10](v5, list[48], list[30]), buffer.readu8(v5, list[789])))))),
                                version3((version3(version3))),
                                version3(version3),
                                version3((version3((version3((version3((list[698](list[10](v5, list[48], list[30]), buffer.readu8(v5, list[789])))))))))),
                                version3((version3(version3))),
                                version3(version3),
                                version3((version3((list[698](list[10](v22, list[550], list[454]), buffer.readu8(v22, list[51])))))),
                                version3((list[698](list[10](v22, list[550], list[454]), buffer.readu8(v22, list[51])))),
                                version3(version3),
                                version3((list[698](list[10](v26, list[66], list[30]), buffer.readu8(v26, list[425])))),
                                version3(version3),
                                version3((list[698](list[10](v23, list[735], list[1068]), buffer.readu8(v26, list[938])))),
                                version3((list[188](list[10](v18, list[1018], list[639]), buffer.readu8(v22, list[71]), buffer.readu8(v26, list[65])))),
                                version3(version3),
                                version3(version3),
                                version3((list[698](list[10](v23, list[557], list[817]), buffer.readu8(v5, list[312])))),
                            }

                            callback3 = version3
                            xored = list[940]
                        else
                            xored = list[545]
                        end
                    elseif xored < 1449 then
                        callback3 = callback2((list[698](list[10](v26, list[458], list[454]), buffer.readu8(v22, list[71]))))
                        xored = list[1038]
                    else
                        local v250 = env2[callback18(callback18)]

                        callback3 = list[188](list[10](v22, list[687], list[1068]), buffer.readu8(v18, list[425]), buffer.readu8(v18, list[37]))

                        xored = list[880]
                    end
                elseif xored < 1457 then
                    if xored < 1453 then
                        if xored < 1451 then
                            xored = if count <= buffer.readu8(v5, list[990]) then list[417] else list[1002]
                        elseif xored < 1452 then
                            v48 += list[33]
                            xored = list[516]
                        elseif (version2 and list2 or not (list2 or list2)) and (not list2 and version2 or version2 and version2) and not ((version2 and list2 or not (list2 or list2)) and (not list2 and version2 or version2 and version2)) then
                            xored = list[766]
                        else
                            xored = list[304]
                        end
                    elseif xored < 1455 then
                        xored = if xored < 1454 then list[324] else list[311]
                    elseif xored < 1456 then
                        xored = list[939]
                    else
                        v59 = v58
                        count3 = bit32[list[10](v18, list[959], list[1002])](bit32[list[10](v26, list[358], list[114])](version2, (v59 - buffer.readu8(v5, list[642])) * buffer.readu8(v26, list[37])), buffer.readu8(v18, list[875]))

                        callback18 = bit32[list[10](v22, list[671], list[1002])](callback18, count3)
                        xored = list[78]
                    end
                elseif xored < 1460 then
                    if xored < 1458 then
                        tbl5 = {
                            list[698](list[10](v5, list[214], list[708]), buffer.readu8(v18, list[425])),
                            list[188](list[10](v26, list[816], list[712]), buffer.readu8(v22, list[509]), buffer.readu8(v22, list[544])),
                            list[698](list[10](v26, list[96], list[793]), buffer.readu8(v23, list[1120])),
                            list[188](list[10](v23, list[985], list[691]), buffer.readu8(v23, list[546]), buffer.readu8(v26, list[990])),
                            list[188](list[10](v23, list[433], list[817]), buffer.readu8(v26, list[654]), buffer.readu8(v5, list[544])),
                            list[188](list[10](v23, list[172], list[726]), buffer.readu8(v5, list[875]), buffer.readu8(v18, list[65])),
                            list[698](list[10](v18, list[108], list[1092]), buffer.readu8(v18, list[564])),
                            (list[188](list[10](v22, list[438], list[30]), buffer.readu8(v5, list[789]), buffer.readu8(v18, list[938]))),
                        }

                        local v253 = tbl5[(tbl4 * buffer.readu8(v26, list[897]) + buffer.readu8(v18, list[546])) % buffer.readu8(v5, list[509]) + buffer.readu8(v5, list[642])]

                        xored = if v253 < tbl5[(tbl4 * buffer.readu8(v26, list[897]) + buffer.readu8(v18, list[546])) % buffer.readu8(v5, list[509]) + buffer.readu8(v5, list[642])] then list[1013] else list[1096]
                    elseif xored < 1459 then
                        tbl4 = list[197]((list2 * buffer.readu8(v5, list[990]) + buffer.readu8(v26, list[546])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642]), (list2 * buffer.readu8(v22, list[312]) + buffer.readu8(v22, list[312])) % buffer.readu8(v5, list[544]) + buffer.readu8(v5, list[642]), (list2 * buffer.readu8(v18, list[938]) + buffer.readu8(v22, list[544])) % buffer.readu8(v22, list[230]) + buffer.readu8(v5, list[642]))

                        xored = if list[947](vector.dot(vector.floor(tbl4) + vector.ceil(tbl4 * buffer.readi8(v18, list[71])), vector.floor(tbl4) + vector.ceil(tbl4 * buffer.readi8(v18, list[71]))), buffer.readu32(v22, list[36])) then list[804] else list[657]
                    else
                        list2 = (list2 + buffer.readu8(v5, list[71])) % buffer.readu8(v5, list[1057])
                        xored = list[510]
                    end
                elseif xored < 1462 then
                    if xored < 1461 then
                        v50 = v49

                        count = list[910][list[188](list[10](v23, list[1052], list[116]), buffer.readu8(v26, list[425]), buffer.readu8(v26, list[990]))]()

                        callback20 += count[list[188](list[10](v18, list[695], list[703]), buffer.readu8(v5, list[312]), buffer.readu8(v22, list[1083]))](count, buffer.readu8(v26, list[1083]), buffer.readu8(v18, list[679]))
                        xored = list[738]
                    else
                        tbl4 = (tbl4 + buffer.readu8(v18, list[564])) % buffer.readu8(v18, list[789])
                        xored = list[41]
                    end
                elseif xored < 1463 then
                    count = (list2 * buffer.readu8(v5, list[990]) + buffer.readu8(v5, list[990])) % buffer.readu8(v23, list[509]) + buffer.readu8(v5, list[642])
                    xored = list[149]
                else
                    xored = list[662]
                end
            elseif xored < 1478 then
                if xored < 1471 then
                    if xored < 1467 then
                        if xored < 1465 then
                            xored = if v53 <= v51 then list[329] else list[203]
                        elseif xored < 1466 then
                            list2 = nil
                            tbl4 = nil
                            tbl4 = buffer.readu8(v26, list[1083])
                            xored = list[179]
                        else
                            tbl5 = {
                                list[188](list[10](v23, list[756], list[691]), buffer.readu8(v5, list[679]), buffer.readu8(v23, list[789])),
                                list[188](list[10](v22, list[322], list[454]), buffer.readu8(v5, list[312]), buffer.readu8(v5, list[990])),
                                list[698](list[10](v23, list[282], list[178]), buffer.readu8(v23, list[613])),
                                list[188](list[10](v26, list[356], list[454]), buffer.readu8(v22, list[546]), buffer.readu8(v5, list[37])),
                                list[188](list[10](v18, list[798], list[276]), buffer.readu8(v22, list[546]), buffer.readu8(v26, list[65])),
                                list[698](list[10](v18, list[208], list[1092]), buffer.readu8(v22, list[990])),
                                list[698](list[10](v5, list[1064], list[221]), buffer.readu8(v23, list[230])),
                                list[698](list[10](v5, list[810], list[708]), buffer.readu8(v26, list[312])),
                                list[188](list[10](v23, list[860], list[469]), buffer.readu8(v23, list[312]), buffer.readu8(v22, list[861])),
                                (list[188](list[10](v5, list[914], list[116]), buffer.readu8(v5, list[789]), buffer.readu8(v5, list[564]))),
                            }

                            v43 = tbl5[tbl4 % buffer.readu8(v26, list[509]) + buffer.readu8(v5, list[642])]
                            tbl5 = v43[list[698](list[10](v23, list[1086], list[532]), buffer.readu8(v18, list[654]))](v43)

                            v44 = v43[list[188](list[10](v5, list[206], list[1037]), buffer.readu8(v22, list[71]), buffer.readu8(v18, list[990]))](v43, list[188](list[10](v18, list[484], list[656]), buffer.readu8(v18, list[1083]), buffer.readu8(v23, list[861])), list[188](list[10](v18, list[878], list[650]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[509])), tbl4 % buffer.readu8(v5, list[37]) % buffer.readu8(v26, list[37]) + buffer.readu8(v5, list[642]))

                            xored = if tbl5 <= v44[list[188](list[10](v23, list[1126], list[712]), buffer.readu8(v26, list[897]), buffer.readu8(v22, list[230]))](v44) then list[235] else list[722]
                        end
                    elseif xored < 1469 then
                        if xored < 1468 then
                            xored = if str <= buffer.readu8(v18, list[938]) then list[145] else list[887]
                        else
                            v54 = v53
                            xored = list[244]
                        end
                    elseif xored < 1470 then
                        xored = list[257]
                    else
                        list2 = list[423][list[698](list[10](v26, list[719], list[1092]), buffer.readu8(v26, list[679]))]
                        xored = list[981]
                    end
                elseif xored < 1474 then
                    if xored < 1472 then
                        xored = if str <= buffer.readu8(v18, list[37]) then list[944] else list[431]
                    elseif xored < 1473 then
                        count = os[list[698](list[10](v18, list[177], list[1092]), buffer.readu8(v23, list[613]))]()
                        callback21()
                        callback26()
                        callback24()
                        callback25()
                        callback22()
                        callback27()
                        v50 = v49
                        xored = if list[195](list[709][list[188](list[10](v5, list[1076], list[47]), buffer.readu8(v23, list[546]), buffer.readu8(v18, list[990]))](callback23), buffer.readu8(v18, list[938]), buffer.readu32(v23, list[428])) then list[759] else list[629]
                    else
                        callback18 = callback11(list2, buffer.readu8(v26, list[1083]), buffer.readu8(v18, list[875]))
                        xored = if version2 then list[812] else list[78]
                    end
                elseif xored < 1476 then
                    if xored < 1475 then
                        xored = if version3 > buffer.readu8(v26, list[1083]) then list[148] else list[549]
                    else
                        str += buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083])
                        xored = list[637]
                    end
                elseif xored < 1477 then
                    v50 = v49
                    local v262 = list[188](list[10](v18, list[226], list[1088]), buffer.readu8(v18, list[1083]), buffer.readu8(v23, list[1083]))
                    env[v262] = env2

                    setfenv(buffer.readu8(v5, list[642]), setmetatable({}, {[list[698](list[10](v18, list[200], list[221]), buffer.readu8(v23, list[71]))] = list[60]}))

                    xored = list[353]
                else
                    xored = if count then list[640] else list[610]
                end
            elseif xored < 1485 then
                if xored < 1481 then
                    if xored < 1479 then
                        v58 = v53
                        xored = list[265]
                    else
                        xored = if xored < 1480 then list[991] else list[6]
                    end
                elseif xored < 1483 then
                    if xored < 1482 then
                        v59 = v58
                        callback18 = bit32[list[10](v22, list[671], list[1002])](callback18, count2[v59])
                        xored = list[234]
                    else
                        count2 = str
                        xored = list[602]
                    end
                elseif xored < 1484 then
                    callback18 = version2
                    xored = list[409]
                else
                    count3 = str
                    xored = list[792]
                end
            elseif xored < 1488 then
                if xored < 1486 then
                    xored = if count2 then list[647] else list[234]
                elseif xored < 1487 then
                    xored = list[561]
                else
                    xored = if str <= buffer.readu8(v22, list[1083]) then list[279] else list[934]
                end
            elseif xored < 1490 then
                if xored < 1489 then
                    count2 = callback18
                    xored = list[298]
                else
                    list2 = count
                    count = #list2
                    version2 = buffer.readu8(v5, list[642])
                    count2 = buffer.readu8(v26, list[37]) ^ buffer.readu8(v5, list[1083]) - buffer.readu8(v5, list[642])
                    xored = list[131]
                end
            elseif xored < 1491 then
                tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                xored = list[337]
            else
                xored = list[829]
            end
        elseif xored < 1520 then
            if xored < 1506 then
                if xored < 1499 then
                    if xored < 1495 then
                        if xored < 1493 then
                            xored = list[737]
                        elseif xored < 1494 then
                            table[list[10](v5, list[1012], list[1092])](table)
                            version3 = version()
                            xored = list[776]
                        else
                            xored = list[670]
                        end
                    elseif xored < 1497 then
                        if xored < 1496 then
                            tbl5 = nil
                            tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                            tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                            tbl5 = buffer.readu8(v18, list[938]) - buffer.readu8(v5, list[37])
                            xored = list[253]
                        else
                            xored = list[801]
                        end
                    elseif xored < 1498 then
                        v55 = v54
                        tbl5 = callback20[list[698](list[10](v26, list[474], list[1002]), buffer.readu8(v5, list[546]))](callback20, v55)

                        str ..= string[list[10](v22, list[999], list[1002])](bit32[list[10](v22, list[671], list[1002])](tbl5, count3[(v55 - buffer.readu8(v5, list[642])) % #count3 + buffer.readu8(v5, list[642])]))

                        xored = list[708]
                    else
                        tbl = {}
                        local v270 = buffer.readu8(v5, list[642])
                        tbl[v270] = tbl
                        tbl2 = list[355]
                        xored = list[513]
                    end
                elseif xored < 1502 then
                    if xored < 1500 then
                        flag = version2 + buffer.readu8(v23, list[425])
                        xored = list[980]
                    elseif xored < 1501 then
                        tbl5 = {
                            list[188](list[10](v18, list[857], list[26]), buffer.readu8(v18, list[1083]), buffer.readu8(v26, list[990])),
                            list[698](list[10](v18, list[238], list[1002]), buffer.readu8(v22, list[509])),
                            list[698](list[10](v22, list[562], list[793]), buffer.readu8(v22, list[897])),
                            list[698](list[10](v5, list[208], list[1092]), buffer.readu8(v18, list[861])),
                            list[188](list[10](v5, list[589], list[1002]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[1083])),
                            list[188](list[10](v22, list[625], list[1088]), buffer.readu8(v26, list[1057]), buffer.readu8(v22, list[544])),
                            list[188](list[10](v23, list[237], list[712]), buffer.readu8(v22, list[509]), buffer.readu8(v23, list[866])),
                            list[188](list[10](v23, list[890], list[691]), buffer.readu8(v22, list[71]), buffer.readu8(v5, list[938])),
                            list[188](list[10](v22, list[440], list[732]), buffer.readu8(v22, list[1120]), buffer.readu8(v26, list[546])),
                            (list[698](list[10](v18, list[185], list[178]), buffer.readu8(v18, list[564]))),
                        }

                        v43 = tbl5[tbl4 % buffer.readu8(v26, list[509]) + buffer.readu8(v5, list[642])]
                        tbl5 = tbl4 % buffer.readu8(v5, list[37]) + buffer.readu8(v26, list[37])
                        v44 = v43[list[698](list[10](v26, list[1103], list[221]), buffer.readu8(v22, list[546]))](v43)
                        local v275 = tbl5
                        tbl5 = v43[list[698](list[10](v23, list[1112], list[532]), buffer.readu8(v26, list[425]))](v43)

                        v45 = v44[list[188](list[10](v26, list[1019], list[978]), buffer.readu8(v26, list[544]), buffer.readu8(v22, list[861]))](v44, v275)

                        xored = if tbl5 <= v45[list[698](list[10](v22, list[1086], list[532]), buffer.readu8(v23, list[642]))](v45) then list[1022] else list[506]
                    else
                        fn2 = false
                        fn = {}
                        callback27 = function(...) -- line 12711 · shares: [1] callback3, [2] fn, [3] v17, [4] v, [5] list, [6] callback12, [7] v19, [8] v35, [9] v26, [10] fn2, [11] v18, [12] v22, [13] callback9, [14] v23, [15] callback16, [16] v5, [17] v33
                            if not callback3 then
                                ({})[1] = fn;
                                ({})[2] = v17;
                                ({})[3] = v;
                                ({})[4] = callback3;
                                ({})[5] = list;
                                ({})[6] = callback12;
                                ({})[7] = v19;
                                ({})[8] = v35;
                                ({})[9] = v26;
                                ({})[10] = fn2;
                                ({})[11] = v18;
                                ({})[12] = v22;
                                ({})[13] = callback9;
                                ({})[14] = v23;
                                ({})[15] = callback16
                            end

                            local tbl
                            local tbl2
                            local v2
                            local flag
                            local v3
                            local v4
                            local v6
                            local flag2
                            local v7
                            local v8
                            local v9
                            local v10
                            local v11
                            local v12
                            local v13
                            local v14
                            local flag3
                            local v15
                            local v16
                            local xored
                            xored = list[801]

                            while true do
                                xored = bit32.bxor(xored, list[787])

                                if xored < 5495 then
                                    if xored < 5489 then
                                        if xored < 4675 or xored < 5473 then break end

                                        if xored < 5488 then
                                            if xored ~= 5473 then break end
                                            flag = v35
                                            v3 = buffer.readu8(v5, list[642])
                                            v4 = buffer.readu8(v26, list[642])
                                            v11 = v3
                                            v9 = v4
                                            xored = list[650]
                                        else
                                            flag = v2
                                            xored = if flag then list[1092] else list[532]
                                        end
                                    elseif xored < 5492 then
                                        if xored < 5490 then
                                            tbl2 = {
                                                [callback3((list[698](list[list[708]](v18, list[1035], list[list[1088]]), buffer.readu8(v18, list[579]))))] = callback3((list[list[737]](list[list[708]](v5, list[list[100]], list[list[1074]]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v5, list[509])))),
                                                [callback3((list[list[737]](list[list[708]](v18, list[540], list[list[469]]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[list[27]]))))] = callback3((list[698](list[list[708]](v5, list[1040], list[list[819]]), buffer.readu8(v22, list[509])))),
                                                [callback3((list[698](list[list[708]](v22, list[807], list[list[633]]), buffer.readu8(v18, list[579]))))] = callback3((list[list[737]](list[list[708]](v22, list[list[680]], list[list[1074]]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v5, list[list[738]])))),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[647]], list[885]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v26, list[509]))))] = callback3((list[698](list[list[708]](v23, list[1099], list[454]), buffer.readu8(v22, list[509])))),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[40]], list[1088]), buffer.readu8(v23, list[875]), buffer.readu8(v5, list[list[738]]))))] = callback3((list[698](list[list[708]](v23, list[list[948]], list[list[378]]), buffer.readu8(v5, list[613])))),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[640]], list[772]), buffer.readu8(v22, list[990]), buffer.readu8(v5, list[579]))))] = callback3((list[list[737]](list[list[708]](v23, list[548], list[list[633]]), buffer.readu8(v18, list[654]), buffer.readu8(v5, list[544])))),
                                                [callback3((list[list[737]](list[list[708]](v18, list[759], list[639]), buffer.readu8(v22, list[579]), buffer.readu8(v23, list[1083]))))] = callback3((list[list[737]](list[list[708]](v23, list[461], list[list[419]]), buffer.readu8(v5, list[897]), buffer.readu8(v18, list[990])))),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[758]], list[772]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v5, list[579]))))] = callback3((list[698](list[list[708]](v22, list[1099], list[454]), buffer.readu8(v5, list[1057])))),
                                                [callback3((list[698](list[list[708]](v26, list[list[307]], list[691]), buffer.readu8(v22, list[579]))))] = callback3((list[list[737]](list[list[708]](v26, list[list[470]], list[656]), buffer.readu8(v5, list[1057]), buffer.readu8(v23, list[789])))),
                                                [callback3((list[list[737]](list[list[708]](v23, list[822], list[list[792]]), buffer.readu8(v18, list[579]), buffer.readu8(v22, list[861]))))] = callback3((list[list[737]](list[list[708]](v18, list[920], list[885]), buffer.readu8(v22, list[list[832]]), buffer.readu8(v22, list[861])))),
                                                [callback3((list[698](list[list[708]](v18, list[list[420]], list[691]), buffer.readu8(v26, list[861]))))] = callback3((list[list[737]](list[list[708]](v23, list[list[77]], list[469]), buffer.readu8(v26, list[654]), buffer.readu8(v18, list[list[738]])))),
                                                [callback3((list[698](list[list[708]](v23, list[603], list[656]), buffer.readu8(v18, list[579]))))] = callback3((list[698](list[list[708]](v22, list[536], list[list[105]]), buffer.readu8(v26, list[866])))),
                                                [callback3((list[698](list[list[708]](v5, list[868], list[691]), buffer.readu8(v23, list[679]))))] = callback3((list[698](list[list[708]](v22, list[list[595]], list[list[105]]), buffer.readu8(v5, list[897])))),
                                                [callback3((list[698](list[list[708]](v22, list[985], list[691]), buffer.readu8(v22, list[list[27]]))))] = callback3((list[list[737]](list[list[708]](v26, list[list[670]], list[list[469]]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v23, list[789])))),
                                                [callback3((list[698](list[list[708]](v5, list[list[315]], list[list[633]]), buffer.readu8(v23, list[679]))))] = callback3((list[698](list[list[708]](v22, list[list[712]], list[793]), buffer.readu8(v5, list[897])))),
                                                [callback3((list[list[737]](list[list[708]](v23, list[818], list[931]), buffer.readu8(v26, list[1057]), buffer.readu8(v26, list[list[305]]))))] = callback3((list[698](list[list[708]](v22, list[list[818]], list[793]), buffer.readu8(v23, list[642])))),
                                                [callback3((list[list[737]](list[list[708]](v5, list[850], list[772]), buffer.readu8(v26, list[861]), buffer.readu8(v22, list[642]))))] = callback3((list[list[737]](list[list[708]](v22, list[782], list[1042]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v26, list[list[305]])))),
                                                [callback3((list[698](list[list[708]](v18, list[list[324]], list[list[105]]), buffer.readu8(v5, list[679]))))] = list[list[737]](list[list[708]](v22, list[list[531]], list[726]), buffer.readu8(v18, list[list[549]]), buffer.readu8(v23, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[list[339]], list[650]), buffer.readu8(v26, list[613]))))] = list[list[737]](list[list[708]](v23, list[632], list[list[633]]), buffer.readu8(v26, list[866]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v22, list[900], list[708]), buffer.readu8(v26, list[789]))))] = list[list[737]](list[list[708]](v22, list[1095], list[639]), buffer.readu8(v22, list[509]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[list[1026]], list[list[796]]), buffer.readu8(v18, list[579]), buffer.readu8(v23, list[861]))))] = list[list[737]](list[list[708]](v23, list[788], list[list[543]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v22, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v22, list[list[148]], list[708]), buffer.readu8(v5, list[list[549]]))))] = list[list[737]](list[list[708]](v23, list[list[141]], list[1088]), buffer.readu8(v5, list[654]), buffer.readu8(v23, list[866])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[1010], list[885]), buffer.readu8(v23, list[990]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v23, list[572], list[732]), buffer.readu8(v26, list[list[549]])),
                                                [callback3((list[698](list[list[708]](v26, list[542], list[list[105]]), buffer.readu8(v5, list[list[286]]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v5, list[575], list[list[105]]), buffer.readu8(v23, list[list[305]]))))] = list[list[737]](list[list[708]](v26, list[list[659]], list[1037]), buffer.readu8(v22, list[list[923]]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[248]], list[list[239]]), buffer.readu8(v23, list[654]), buffer.readu8(v26, list[990]))))] = list[list[737]](list[list[708]](v18, list[list[326]], list[list[105]]), buffer.readu8(v18, list[579]), buffer.readu8(v26, list[list[738]])),
                                                [callback3((list[698](list[list[708]](v23, list[list[234]], list[list[105]]), buffer.readu8(v18, list[list[27]]))))] = list[list[737]](list[list[708]](v5, list[540], list[list[469]]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v22, list[861])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[906], list[650]), buffer.readu8(v23, list[579]), buffer.readu8(v18, list[938]))))] = list[list[737]](list[list[708]](v18, list[886], list[732]), buffer.readu8(v23, list[938]), buffer.readu8(v26, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[696]], list[454]), buffer.readu8(v22, list[972]), buffer.readu8(v26, list[list[738]]))))] = list[698](list[list[708]](v5, list[958], list[732]), buffer.readu8(v22, list[1120])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[788], list[list[543]]), buffer.readu8(v26, list[1057]), buffer.readu8(v18, list[list[738]]))))] = list[698](list[list[708]](v23, list[572], list[732]), buffer.readu8(v26, list[list[549]])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[145]], list[712]), buffer.readu8(v23, list[897]), buffer.readu8(v26, list[509]))))] = list[list[737]](list[list[708]](v23, list[list[1098]], list[1037]), buffer.readu8(v23, list[938]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[4]], list[list[798]]), buffer.readu8(v23, list[938]), buffer.readu8(v26, list[list[27]]))))] = list[list[737]](list[list[708]](v5, list[603], list[list[227]]), buffer.readu8(v26, list[654]), buffer.readu8(v23, list[789])),
                                                [callback3((list[698](list[list[708]](v22, list[936], list[list[105]]), buffer.readu8(v18, list[564]))))] = list[list[737]](list[list[708]](v5, list[954], list[691]), buffer.readu8(v22, list[list[832]]), buffer.readu8(v22, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[706], list[list[239]]), buffer.readu8(v23, list[579]), buffer.readu8(v26, list[990]))))] = list[list[737]](list[list[708]](v26, list[list[916]], list[list[633]]), buffer.readu8(v5, list[654]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v18, list[684], list[list[105]]), buffer.readu8(v22, list[579]))))] = list[698](list[list[708]](v23, list[list[750]], list[732]), buffer.readu8(v18, list[579])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[736], list[793]), buffer.readu8(v26, list[789]), buffer.readu8(v5, list[642]))))] = list[list[737]](list[list[708]](v5, list[list[661]], list[885]), buffer.readu8(v26, list[654]), buffer.readu8(v26, list[990])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[756], list[691]), buffer.readu8(v23, list[1120]), buffer.readu8(v23, list[789]))))] = list[698](list[list[708]](v5, list[list[158]], list[732]), buffer.readu8(v26, list[1057])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[931]], list[738]), buffer.readu8(v18, list[1120]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v5, list[484], list[656]), buffer.readu8(v5, list[789]), buffer.readu8(v5, list[564])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[740], list[882]), buffer.readu8(v22, list[654]), buffer.readu8(v18, list[990]))))] = list[698](list[list[708]](v22, list[582], list[732]), buffer.readu8(v23, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[743]], list[978]), buffer.readu8(v5, list[679]), buffer.readu8(v23, list[509]))))] = list[698](list[list[708]](v22, list[858], list[732]), buffer.readu8(v23, list[list[286]])),
                                                [callback3((list[698](list[list[708]](v18, list[643], list[793]), buffer.readu8(v22, list[list[738]]))))] = list[list[737]](list[list[708]](v18, list[699], list[list[1043]]), buffer.readu8(v26, list[897]), buffer.readu8(v5, list[list[738]])),
                                                [callback3((list[698](list[list[708]](v26, list[556], list[793]), buffer.readu8(v23, list[list[738]]))))] = list[698](list[list[708]](v18, list[886], list[732]), buffer.readu8(v23, list[938])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[648], list[list[138]]), buffer.readu8(v23, list[990]), buffer.readu8(v23, list[1083]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[698](list[list[708]](v26, list[list[1092]], list[708]), buffer.readu8(v23, list[938]))))] = list[list[737]](list[list[708]](v23, list[573], list[list[227]]), buffer.readu8(v22, list[972]), buffer.readu8(v23, list[789])),
                                                [callback3((list[698](list[list[708]](v23, list[684], list[list[105]]), buffer.readu8(v5, list[654]))))] = list[698](list[list[708]](v18, list[list[158]], list[732]), buffer.readu8(v18, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[931]], list[738]), buffer.readu8(v18, list[1120]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[647]], list[885]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v22, list[492]))))] = list[698](list[list[708]](v5, list[582], list[732]), buffer.readu8(v23, list[990])),
                                                [callback3((list[698](list[list[708]](v5, list[list[929]], list[793]), buffer.readu8(v23, list[564]))))] = list[list[737]](list[list[708]](v26, list[877], list[1037]), buffer.readu8(v23, list[875]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[698](list[list[708]](v23, list[770], list[708]), buffer.readu8(v26, list[789]))))] = list[list[737]](list[list[708]](v5, list[list[639]], list[978]), buffer.readu8(v22, list[1120]), buffer.readu8(v5, list[509])),
                                                [callback3((list[698](list[list[708]](v22, list[1065], list[708]), buffer.readu8(v22, list[list[549]]))))] = list[list[737]](list[list[708]](v26, list[1075], list[1037]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v23, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1056], list[650]), buffer.readu8(v5, list[654]), buffer.readu8(v18, list[938]))))] = list[698](list[list[708]](v22, list[list[158]], list[732]), buffer.readu8(v18, list[list[549]])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[974], list[list[1088]]), buffer.readu8(v5, list[679]), buffer.readu8(v5, list[544]))))] = list[698](list[list[708]](v5, list[572], list[732]), buffer.readu8(v18, list[654])),
                                                [callback3((list[698](list[list[708]](v5, list[729], list[793]), buffer.readu8(v26, list[564]))))] = list[list[737]](list[list[708]](v23, list[list[759]], list[978]), buffer.readu8(v26, list[866]), buffer.readu8(v5, list[509])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[1050], list[list[62]]), buffer.readu8(v22, list[1057]), buffer.readu8(v18, list[938]))))] = list[list[737]](list[list[708]](v23, list[764], list[list[633]]), buffer.readu8(v23, list[1057]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v18, list[1056], list[650]), buffer.readu8(v18, list[list[286]]))))] = list[list[737]](list[list[708]](v26, list[672], list[656]), buffer.readu8(v18, list[1083]), buffer.readu8(v5, list[564])),
                                                [callback3((list[698](list[list[708]](v5, list[472], list[708]), buffer.readu8(v23, list[990]))))] = list[list[737]](list[list[708]](v18, list[list[727]], list[712]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v26, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[843], list[list[796]]), buffer.readu8(v23, list[938]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v18, list[575], list[list[105]]), buffer.readu8(v18, list[509]), buffer.readu8(v26, list[list[738]])),
                                                [callback3((list[698](list[list[708]](v18, list[811], list[793]), buffer.readu8(v22, list[938]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[698](list[list[708]](v18, list[770], list[708]), buffer.readu8(v22, list[990]))))] = list[list[737]](list[list[708]](v22, list[822], list[639]), buffer.readu8(v23, list[679]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[479], list[885]), buffer.readu8(v23, list[564]), buffer.readu8(v22, list[492]))))] = list[list[737]](list[list[708]](v26, list[983], list[list[162]]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v18, list[990])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[459], list[list[796]]), buffer.readu8(v18, list[list[832]]), buffer.readu8(v23, list[861]))))] = list[698](list[list[708]](v5, list[550], list[732]), buffer.readu8(v18, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[850]], list[list[62]]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[list[741]]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v23, list[472], list[708]), buffer.readu8(v5, list[679]))))] = list[698](list[list[708]](v22, list[582], list[732]), buffer.readu8(v23, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v18, list[523], list[793]), buffer.readu8(v22, list[list[738]]))))] = list[698](list[list[708]](v26, list[list[2]], list[732]), buffer.readu8(v23, list[875])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[1087], list[454]), buffer.readu8(v18, list[579]), buffer.readu8(v5, list[642]))))] = list[list[737]](list[list[708]](v18, list[843], list[list[796]]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[492])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[624], list[list[62]]), buffer.readu8(v23, list[1120]), buffer.readu8(v22, list[list[741]]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[list[680]], list[list[1074]]), buffer.readu8(v22, list[875]), buffer.readu8(v5, list[list[738]]))))] = list[698](list[list[708]](v22, list[886], list[732]), buffer.readu8(v22, list[509])),
                                                [callback3((list[698](list[list[708]](v22, list[483], list[list[267]]), buffer.readu8(v18, list[list[286]]))))] = list[698](list[list[708]](v23, list[440], list[732]), buffer.readu8(v26, list[654])),
                                                [callback3((list[698](list[list[708]](v23, list[795], list[list[105]]), buffer.readu8(v18, list[613]))))] = list[list[737]](list[list[708]](v22, list[530], list[731]), buffer.readu8(v26, list[861]), buffer.readu8(v22, list[642])),
                                                [callback3((list[698](list[list[708]](v18, list[list[630]], list[793]), buffer.readu8(v18, list[1120]))))] = list[698](list[list[708]](v18, list[958], list[732]), buffer.readu8(v23, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v23, list[575], list[list[105]]), buffer.readu8(v5, list[866]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[577], list[793]), buffer.readu8(v5, list[679]))))] = list[list[737]](list[list[708]](v26, list[905], list[list[526]]), buffer.readu8(v5, list[789]), buffer.readu8(v26, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[844], list[793]), buffer.readu8(v23, list[679]), buffer.readu8(v26, list[1083]))))] = list[list[737]](list[list[708]](v26, list[list[963]], list[list[1088]]), buffer.readu8(v22, list[509]), buffer.readu8(v18, list[list[738]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[1071], list[list[239]]), buffer.readu8(v22, list[938]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v22, list[858], list[732]), buffer.readu8(v23, list[list[286]])),
                                                [callback3((list[698](list[list[708]](v22, list[list[774]], list[708]), buffer.readu8(v5, list[list[549]]))))] = list[698](list[list[708]](v22, list[572], list[732]), buffer.readu8(v26, list[679])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[829]], list[885]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v18, list[1053], list[732]), buffer.readu8(v22, list[579])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[1128], list[454]), buffer.readu8(v26, list[list[832]]), buffer.readu8(v26, list[list[738]]))))] = list[list[737]](list[list[708]](v22, list[list[871]], list[list[304]]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[875])),
                                                [callback3((list[698](list[list[708]](v26, list[1023], list[list[105]]), buffer.readu8(v18, list[list[741]]))))] = list[698](list[list[708]](v18, list[582], list[732]), buffer.readu8(v5, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1035], list[list[1088]]), buffer.readu8(v22, list[972]), buffer.readu8(v22, list[list[741]]))))] = list[698](list[list[708]](v22, list[582], list[732]), buffer.readu8(v23, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[702], list[726]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[1108], list[469]), buffer.readu8(v26, list[679]), buffer.readu8(v23, list[789]))))] = list[list[737]](list[list[708]](v22, list[1097], list[list[796]]), buffer.readu8(v23, list[938]), buffer.readu8(v22, list[492])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[750], list[738]), buffer.readu8(v23, list[990]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v22, list[860], list[469]), buffer.readu8(v22, list[990]), buffer.readu8(v5, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[1077], list[726]), buffer.readu8(v18, list[564]), buffer.readu8(v23, list[861]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[list[489]], list[650]), buffer.readu8(v23, list[list[305]]))))] = list[list[737]](list[list[708]](v23, list[596], list[list[796]]), buffer.readu8(v26, list[list[549]]), buffer.readu8(v22, list[492])),
                                                [callback3((list[698](list[list[708]](v23, list[list[324]], list[list[105]]), buffer.readu8(v22, list[579]))))] = list[list[737]](list[list[708]](v26, list[list[381]], list[691]), buffer.readu8(v23, list[list[27]]), buffer.readu8(v22, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[1061], list[738]), buffer.readu8(v26, list[613]), buffer.readu8(v22, list[492]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[970], list[list[304]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v26, list[list[305]]))))] = list[list[737]](list[list[708]](v26, list[658], list[list[469]]), buffer.readu8(v23, list[list[27]]), buffer.readu8(v22, list[861])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[1026], list[731]), buffer.readu8(v23, list[list[741]]), buffer.readu8(v18, list[list[305]]))))] = list[list[737]](list[list[708]](v18, list[529], list[list[526]]), buffer.readu8(v5, list[897]), buffer.readu8(v26, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[316]], list[list[543]]), buffer.readu8(v26, list[789]), buffer.readu8(v23, list[866]))))] = list[list[737]](list[list[708]](v5, list[list[134]], list[691]), buffer.readu8(v22, list[579]), buffer.readu8(v22, list[544])),
                                                [callback3((list[698](list[list[708]](v5, list[523], list[793]), buffer.readu8(v22, list[579]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[list[234]], list[list[105]]), buffer.readu8(v18, list[list[286]]), buffer.readu8(v18, list[938]))))] = list[698](list[list[708]](v5, list[550], list[732]), buffer.readu8(v18, list[1083])),
                                                [callback3((list[698](list[list[708]](v23, list[906], list[650]), buffer.readu8(v23, list[list[305]]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[698](list[list[708]](v5, list[643], list[793]), buffer.readu8(v22, list[972]))))] = list[698](list[list[708]](v23, list[886], list[732]), buffer.readu8(v22, list[list[832]])),
                                                [callback3((list[698](list[list[708]](v22, list[619], list[793]), buffer.readu8(v26, list[679]))))] = list[list[737]](list[list[708]](v26, list[595], list[639]), buffer.readu8(v18, list[579]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v5, list[811], list[793]), buffer.readu8(v18, list[list[286]]))))] = list[698](list[list[708]](v18, list[958], list[732]), buffer.readu8(v23, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v26, list[945], list[708]), buffer.readu8(v5, list[866]))))] = list[list[737]](list[list[708]](v22, list[1101], list[list[543]]), buffer.readu8(v23, list[938]), buffer.readu8(v22, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v26, list[455], list[708]), buffer.readu8(v26, list[list[286]]))))] = list[698](list[list[708]](v5, list[958], list[732]), buffer.readu8(v22, list[1120])),
                                                [callback3((list[698](list[list[708]](v5, list[524], list[793]), buffer.readu8(v22, list[875]))))] = list[698](list[list[708]](v26, list[list[467]], list[732]), buffer.readu8(v18, list[861])),
                                                [callback3((list[698](list[list[708]](v5, list[645], list[708]), buffer.readu8(v18, list[861]))))] = list[list[737]](list[list[708]](v23, list[list[4]], list[list[798]]), buffer.readu8(v18, list[579]), buffer.readu8(v5, list[990])),
                                                [callback3((list[698](list[list[708]](v5, list[684], list[list[105]]), buffer.readu8(v5, list[654]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[674], list[885]), buffer.readu8(v5, list[list[549]]), buffer.readu8(v26, list[875]))))] = list[list[737]](list[list[708]](v22, list[list[641]], list[726]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v23, list[861])),
                                                [callback3((list[698](list[list[708]](v18, list[645], list[708]), buffer.readu8(v23, list[613]))))] = list[698](list[list[708]](v23, list[582], list[732]), buffer.readu8(v5, list[654])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[977], list[469]), buffer.readu8(v18, list[564]), buffer.readu8(v5, list[564]))))] = list[list[737]](list[list[708]](v26, list[list[3]], list[list[227]]), buffer.readu8(v18, list[564]), buffer.readu8(v23, list[789])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1009], list[454]), buffer.readu8(v18, list[861]), buffer.readu8(v5, list[642]))))] = list[list[737]](list[list[708]](v26, list[list[913]], list[885]), buffer.readu8(v18, list[897]), buffer.readu8(v26, list[990])),
                                                [callback3((list[698](list[list[708]](v26, list[501], list[708]), buffer.readu8(v23, list[679]))))] = list[list[737]](list[list[708]](v18, list[1129], list[list[227]]), buffer.readu8(v23, list[875]), buffer.readu8(v23, list[789])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[568], list[793]), buffer.readu8(v22, list[1057]), buffer.readu8(v26, list[1083]))))] = list[list[737]](list[list[708]](v22, list[list[1061]], list[list[138]]), buffer.readu8(v26, list[861]), buffer.readu8(v22, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[793]], list[list[105]]), buffer.readu8(v26, list[1057]), buffer.readu8(v18, list[938]))))] = list[list[737]](list[list[708]](v26, list[list[196]], list[list[227]]), buffer.readu8(v5, list[897]), buffer.readu8(v23, list[789])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[745], list[list[798]]), buffer.readu8(v23, list[544]), buffer.readu8(v5, list[list[738]]))))] = list[list[737]](list[list[708]](v26, list[list[718]], list[726]), buffer.readu8(v23, list[875]), buffer.readu8(v23, list[861])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[763], list[list[138]]), buffer.readu8(v23, list[list[738]]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[652], list[list[796]]), buffer.readu8(v18, list[579]), buffer.readu8(v23, list[861]))))] = list[list[737]](list[list[708]](v26, list[list[628]], list[469]), buffer.readu8(v26, list[897]), buffer.readu8(v5, list[544])),
                                                [callback3((list[698](list[list[708]](v5, list[1104], list[list[105]]), buffer.readu8(v22, list[875]))))] = list[698](list[list[708]](v23, list[582], list[732]), buffer.readu8(v5, list[654])),
                                                [callback3((list[698](list[list[708]](v22, list[465], list[708]), buffer.readu8(v23, list[1057]))))] = list[list[737]](list[list[708]](v5, list[942], list[1088]), buffer.readu8(v26, list[866]), buffer.readu8(v23, list[866])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[529], list[list[526]]), buffer.readu8(v18, list[1120]), buffer.readu8(v5, list[579]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v18, list[472], list[708]), buffer.readu8(v23, list[897]))))] = list[698](list[list[708]](v18, list[582], list[732]), buffer.readu8(v5, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[133]], list[list[1043]]), buffer.readu8(v23, list[list[738]]), buffer.readu8(v23, list[509]))))] = list[list[737]](list[list[708]](v5, list[list[86]], list[712]), buffer.readu8(v18, list[861]), buffer.readu8(v26, list[list[27]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[539], list[list[1088]]), buffer.readu8(v23, list[875]), buffer.readu8(v22, list[544]))))] = list[list[737]](list[list[708]](v26, list[list[935]], list[731]), buffer.readu8(v5, list[679]), buffer.readu8(v22, list[642])),
                                                [callback3((list[698](list[list[708]](v22, list[476], list[list[105]]), buffer.readu8(v23, list[list[305]]))))] = list[list[737]](list[list[708]](v5, list[list[133]], list[list[1043]]), buffer.readu8(v5, list[679]), buffer.readu8(v5, list[list[738]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[691]], list[731]), buffer.readu8(v5, list[list[549]]), buffer.readu8(v18, list[990]))))] = list[list[737]](list[list[708]](v5, list[list[84]], list[list[543]]), buffer.readu8(v23, list[679]), buffer.readu8(v22, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v23, list[619], list[793]), buffer.readu8(v22, list[875]))))] = list[698](list[list[708]](v23, list[886], list[732]), buffer.readu8(v22, list[list[832]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[1134], list[738]), buffer.readu8(v23, list[613]), buffer.readu8(v26, list[875]))))] = list[698](list[list[708]](v23, list[list[750]], list[732]), buffer.readu8(v18, list[579])),
                                                [callback3((list[698](list[list[708]](v26, list[1080], list[list[105]]), buffer.readu8(v22, list[list[27]]))))] = list[698](list[list[708]](v26, list[list[467]], list[732]), buffer.readu8(v18, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[859], list[list[105]]), buffer.readu8(v26, list[789]))))] = list[698](list[list[708]](v26, list[list[467]], list[732]), buffer.readu8(v18, list[861])),
                                                [callback3((list[698](list[list[708]](v22, list[1056], list[650]), buffer.readu8(v23, list[897]))))] = list[list[737]](list[list[708]](v26, list[1016], list[list[633]]), buffer.readu8(v26, list[544]), buffer.readu8(v26, list[509])),
                                                [callback3((list[698](list[list[708]](v23, list[645], list[708]), buffer.readu8(v22, list[1057]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[698](list[list[708]](v5, list[795], list[list[105]]), buffer.readu8(v5, list[654]))))] = list[list[737]](list[list[708]](v5, list[759], list[639]), buffer.readu8(v18, list[897]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[686], list[726]), buffer.readu8(v18, list[1120]), buffer.readu8(v26, list[list[923]]))))] = list[list[737]](list[list[708]](v26, list[661], list[639]), buffer.readu8(v18, list[list[549]]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[887]], list[1037]), buffer.readu8(v18, list[642]), buffer.readu8(v5, list[938]))))] = list[list[737]](list[list[708]](v18, list[603], list[list[227]]), buffer.readu8(v22, list[list[923]]), buffer.readu8(v23, list[789])),
                                                [callback3((list[698](list[list[708]](v26, list[list[193]], list[793]), buffer.readu8(v18, list[list[832]]))))] = list[698](list[list[708]](v22, list[list[158]], list[732]), buffer.readu8(v18, list[list[549]])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[573], list[list[227]]), buffer.readu8(v22, list[990]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v26, list[list[254]], list[732]), buffer.readu8(v26, list[866])),
                                                [callback3((list[698](list[list[708]](v22, list[651], list[793]), buffer.readu8(v23, list[564]))))] = list[698](list[list[708]](v26, list[list[380]], list[732]), buffer.readu8(v23, list[679])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[878], list[650]), buffer.readu8(v22, list[990]), buffer.readu8(v26, list[1083]))))] = list[list[737]](list[list[708]](v18, list[list[661]], list[885]), buffer.readu8(v23, list[list[27]]), buffer.readu8(v26, list[990])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[459], list[list[796]]), buffer.readu8(v22, list[972]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[list[399]], list[list[304]]), buffer.readu8(v23, list[938]), buffer.readu8(v23, list[1083]))))] = list[698](list[list[708]](v22, list[list[750]], list[732]), buffer.readu8(v23, list[list[923]])),
                                                [callback3((list[698](list[list[708]](v26, list[865], list[list[105]]), buffer.readu8(v22, list[938]))))] = list[list[737]](list[list[708]](v5, list[1074], list[738]), buffer.readu8(v22, list[972]), buffer.readu8(v5, list[938])),
                                                [callback3((list[698](list[list[708]](v18, list[736], list[793]), buffer.readu8(v22, list[679]))))] = list[698](list[list[708]](v26, list[762], list[732]), buffer.readu8(v5, list[list[741]])),
                                                [callback3((list[698](list[list[708]](v5, list[list[630]], list[793]), buffer.readu8(v22, list[875]))))] = list[list[737]](list[list[708]](v5, list[1108], list[469]), buffer.readu8(v18, list[1083]), buffer.readu8(v5, list[544])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[list[1098]], list[1037]), buffer.readu8(v18, list[579]), buffer.readu8(v22, list[1083]))))] = list[list[737]](list[list[708]](v23, list[759], list[639]), buffer.readu8(v23, list[938]), buffer.readu8(v18, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[480]], list[708]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v26, list[1083]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[729], list[793]), buffer.readu8(v22, list[1057]), buffer.readu8(v5, list[642]))))] = list[698](list[list[708]](v26, list[list[1072]], list[732]), buffer.readu8(v23, list[1057])),
                                                [callback3((list[698](list[list[708]](v5, list[976], list[708]), buffer.readu8(v26, list[679]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[698](list[list[708]](v5, list[984], list[708]), buffer.readu8(v26, list[1057]))))] = list[698](list[list[708]](v23, list[958], list[732]), buffer.readu8(v5, list[679])),
                                                [callback3((list[list[737]](list[list[708]](v22, list[857], list[list[469]]), buffer.readu8(v22, list[972]), buffer.readu8(v23, list[789]))))] = list[698](list[list[708]](v5, list[440], list[732]), buffer.readu8(v22, list[897])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[695], list[list[227]]), buffer.readu8(v18, list[1083]), buffer.readu8(v22, list[861]))))] = list[698](list[list[708]](v18, list[886], list[732]), buffer.readu8(v23, list[938])),
                                                [callback3((list[list[737]](list[list[708]](v23, list[list[100]], list[list[1074]]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v23, list[509]))))] = list[list[737]](list[list[708]](v18, list[1053], list[732]), buffer.readu8(v22, list[579]), buffer.readu8(v26, list[1083])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[706], list[list[239]]), buffer.readu8(v26, list[1057]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v22, list[list[750]], list[732]), buffer.readu8(v23, list[list[923]])),
                                                [callback3((list[698](list[list[708]](v22, list[466], list[708]), buffer.readu8(v18, list[579]))))] = list[698](list[list[708]](v5, list[858], list[732]), buffer.readu8(v23, list[613])),
                                                [callback3((list[698](list[list[708]](v18, list[448], list[708]), buffer.readu8(v23, list[list[741]]))))] = list[list[737]](list[list[708]](v5, list[list[759]], list[978]), buffer.readu8(v18, list[654]), buffer.readu8(v5, list[509])),
                                                [callback3((list[698](list[list[708]](v23, list[465], list[793]), buffer.readu8(v22, list[579]))))] = list[698](list[list[708]](v26, list[551], list[732]), buffer.readu8(v22, list[list[305]])),
                                                [callback3((list[698](list[list[708]](v22, list[list[383]], list[list[105]]), buffer.readu8(v18, list[564]))))] = list[698](list[list[708]](v26, list[list[2]], list[732]), buffer.readu8(v23, list[875])),
                                                [callback3((list[698](list[list[708]](v22, list[845], list[793]), buffer.readu8(v26, list[861]))))] = list[list[737]](list[list[708]](v18, list[list[315]], list[list[633]]), buffer.readu8(v26, list[897]), buffer.readu8(v26, list[509])),
                                                [callback3((list[list[737]](list[list[708]](v18, list[list[1026]], list[list[796]]), buffer.readu8(v26, list[list[286]]), buffer.readu8(v26, list[990]))))] = list[698](list[list[708]](v5, list[582], list[732]), buffer.readu8(v23, list[990])),
                                                [callback3((list[698](list[list[708]](v5, list[list[998]], list[793]), buffer.readu8(v26, list[897]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[698](list[list[708]](v18, list[482], list[708]), buffer.readu8(v23, list[list[305]]))))] = list[698](list[list[708]](v18, list[440], list[732]), buffer.readu8(v18, list[564])),
                                                [callback3((list[698](list[list[708]](v22, list[list[702]], list[708]), buffer.readu8(v23, list[list[305]]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                                [callback3((list[698](list[list[708]](v5, list[list[327]], list[793]), buffer.readu8(v5, list[list[832]]))))] = list[list[737]](list[list[708]](v26, list[1062], list[726]), buffer.readu8(v26, list[679]), buffer.readu8(v23, list[861])),
                                                [callback3((list[698](list[list[708]](v26, list[635], list[793]), buffer.readu8(v22, list[list[27]]))))] = list[698](list[list[708]](v5, list[886], list[732]), buffer.readu8(v5, list[list[923]])),
                                                [callback3((list[list[737]](list[list[708]](v5, list[836], list[list[162]]), buffer.readu8(v18, list[list[832]]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v23, list[858], list[732]), buffer.readu8(v22, list[972])),
                                                [callback3((list[list[737]](list[list[708]](v26, list[808], list[list[526]]), buffer.readu8(v26, list[897]), buffer.readu8(v22, list[642]))))] = list[698](list[list[708]](v23, list[1053], list[732]), buffer.readu8(v5, list[list[27]])),
                                                [callback3((list[698](list[list[708]](v23, list[651], list[793]), buffer.readu8(v22, list[679]))))] = list[698](list[list[708]](v18, list[list[750]], list[732]), buffer.readu8(v26, list[861])),
                                            }

                                            tbl = {
                                                callback3((list[list[737]](list[list[708]](v5, list[list[257]], list[list[526]]), buffer.readu8(v22, list[list[27]]), buffer.readu8(v26, list[990])))),
                                                callback3((list[698](list[list[708]](v22, list[548], list[list[633]]), buffer.readu8(v18, list[579])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[1126], list[712]), buffer.readu8(v5, list[654]), buffer.readu8(v18, list[938])))),
                                                callback3((list[698](list[list[708]](v5, list[699], list[list[1043]]), buffer.readu8(v18, list[564])))),
                                                callback3((list[list[737]](list[list[708]](v5, list[481], list[list[796]]), buffer.readu8(v18, list[861]), buffer.readu8(v22, list[list[286]])))),
                                                callback3((list[list[737]](list[list[708]](v23, list[list[257]], list[list[526]]), buffer.readu8(v5, list[679]), buffer.readu8(v26, list[990])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[1026], list[731]), buffer.readu8(v26, list[1057]), buffer.readu8(v22, list[list[286]])))),
                                                callback3((list[698](list[list[708]](v18, list[list[432]], list[list[798]]), buffer.readu8(v18, list[861])))),
                                                callback3((list[list[737]](list[list[708]](v5, list[list[636]], list[1088]), buffer.readu8(v5, list[654]), buffer.readu8(v23, list[509])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[528], list[931]), buffer.readu8(v23, list[1057]), buffer.readu8(v26, list[875])))),
                                                callback3((list[list[737]](list[list[708]](v5, list[list[783]], list[1042]), buffer.readu8(v22, list[972]), buffer.readu8(v26, list[list[305]])))),
                                            }

                                            xored = if not fn2 then list[732] else list[list[378]]
                                        elseif xored < 5491 then
                                            flag = v(v35, list[588])
                                            xored = list[1092]
                                        else
                                            v2 = flag
                                            xored = list[list[885]]
                                        end
                                    elseif xored < 5493 then
                                        xored = if flag then list[list[105]] else list[list[819]]
                                    else
                                        if xored < 5494 then break end

                                        v2 = nil
                                        xored = list[list[1043]]
                                    end
                                elseif xored < 5500 then
                                    if xored < 5497 then
                                        if xored < 5496 then
                                            flag3 = false
                                            for key, value in tbl2 do
                                                v15 = key
                                                v16 = value
                                                local v28 = v15
                                                local v29 = v16
                                                local v30
                                                v30 = list[1002]

                                                while true do
                                                    if v30 < 2 then
                                                        if v30 < 1 then break end

                                                        v13 = v12
                                                        callback9(list[list[737]](list[list[708]](v5, list[530], list[731]), buffer.readu8(v23, list[list[305]]), buffer.readu8(v5, list[544])), {v28, v29})

                                                        v30 = list[935]
                                                    elseif v30 < 3 then
                                                        v30 = list[801]
                                                    elseif v30 < 4 then
                                                        flag3 = true
                                                        v30 = list[801]
                                                    else
                                                        tbl2 = v35(callback16, v28)
                                                        if tbl2 == callback12 then
                                                            v30 = list[list[885]]
                                                        else
                                                            v30 = list[935]
                                                        end
                                                    end
                                                end

                                                if flag3 then break end
                                            end

                                            xored = list[1002]
                                        else
                                            v11 += list[list[885]]
                                            xored = list[650]
                                        end
                                    elseif xored < 5498 then
                                        v13 = v12

                                        flag = v4[list[list[737]](list[list[708]](v5, list[621], list[list[633]]), buffer.readu8(v23, list[679]), buffer.readu8(v22, list[1083]))](v4, callback3((list[list[737]](list[list[708]](v18, list[list[759]], list[978]), buffer.readu8(v18, list[list[741]]), buffer.readu8(v26, list[list[27]])))))

                                        xored = list[935]
                                    elseif xored < 5499 then
                                        v13 = v12

                                        flag = list[709][list[list[737]](list[list[708]](v22, list[522], list[list[239]]), buffer.readu8(v22, list[list[549]]), buffer.readu8(v26, list[list[305]]))](flag)
                                        xored = list[list[267]]
                                    else
                                        local v37, v38 = v(flag)
                                        v4 = v38
                                        flag = not v37
                                        xored = if flag then list[list[512]] else list[935]
                                    end
                                elseif xored < 5503 then
                                    if xored < 5501 then
                                        fn2 = true
                                        flag2 = false
                                        for key, value in tbl2 do
                                            v7 = key
                                            v8 = value
                                            local v42 = v7
                                            local v43 = v8
                                            local v44
                                            v44 = list[list[885]]

                                            while true do
                                                if v44 < 1 then
                                                    flag2 = true
                                                    v44 = list[935]
                                                else
                                                    if not (v44 < 2) then break end
                                                    v17(v33(callback16, v42), function(arg1) -- line 14945 · shares: [1] callback12, [2] v5, [4] callback9, [5] v22, [6] list, [8] v23 · uses: [3] v43, [7] v42
                                                        if not callback12 then
                                                            ({})[1] = v5;
                                                            ({})[2] = v43;
                                                            ({})[3] = callback9;
                                                            ({})[4] = v22;
                                                            ({})[5] = list;
                                                            ({})[6] = v42;
                                                            ({})[7] = arg1
                                                        end

                                                        local xored
                                                        xored = list[801]

                                                        while true do
                                                            xored = bit32.bxor(xored, list[527])

                                                            if not (xored < 9460) then break end
                                                            if xored < 3910 then
                                                                if xored < 3908 then
                                                                    return
                                                                elseif not (xored < 3909) then
                                                                    break
                                                                else
                                                                    xored = if arg1 == callback12 then list[935] else list[532]
                                                                end
                                                            else
                                                                if not (xored < 4827) then break end
                                                                if xored < 3911 then
                                                                    callback9(list[list[737]](list[list[708]](v5, list[461], list[list[419]]), buffer.readu8(v23, list[938]), buffer.readu8(v22, list[544])), {v42, v43})

                                                                    xored = list[532]
                                                                else
                                                                    if xored ~= 3911 then break end
                                                                    xored = list[list[885]]
                                                                end
                                                            end
                                                        end
                                                    end)
                                                    v44 = list[935]
                                                end
                                            end

                                            if flag2 then break end
                                        end

                                        fn[#fn + buffer.readu8(v5, list[642])] = list[list[1096]][list[698](list[list[708]](v26, list[list[634]], list[1092]), buffer.readu8(v26, list[938]))](function() -- line 15006 · shares: [1] tbl, [2] v19, [3] v35, [4] callback9, [5] callback12, [6] callback16, [7] v5, [8] list, [9] v18, [10] v22, [11] v23
                                            if not tbl then
                                                ({})[1] = tbl;
                                                ({})[2] = v19;
                                                ({})[3] = v35;
                                                ({})[4] = callback9;
                                                ({})[5] = callback12;
                                                ({})[6] = callback16;
                                                ({})[7] = v5
                                            end

                                            local count, v, v2, v3, v4, v6, v7
                                            local xored
                                            xored = list[list[819]]

                                            while true do
                                                xored = bit32.bxor(xored, list[638])

                                                if xored < 3324 then
                                                    if xored < 3316 then
                                                        if xored < 3312 then
                                                            return
                                                        elseif xored < 3314 then
                                                            if xored < 3313 then
                                                                xored = list[793]
                                                            else
                                                                count = tbl[v6]
                                                                v19(callback16, count)
                                                                xored = if v35(callback16, count) == callback12 then list[454] else list[532]
                                                            end
                                                        else
                                                            if not (xored < 3315) then break end
                                                            count = #tbl
                                                            v = buffer.readu8(v5, list[642])
                                                            v4 = v
                                                            v2 = count
                                                            xored = list[935]
                                                        end
                                                    elseif xored < 3319 then
                                                        if xored < 3317 then
                                                            xored = if v4 <= v2 then list[list[885]] else list[list[512]]
                                                        else
                                                            xored = if xored < 3318 then list[732] else list[1092]
                                                        end
                                                    elseif xored < 3322 then
                                                        if xored < 3320 then
                                                            v6 = v4
                                                            xored = list[list[378]]
                                                        else
                                                            if xored ~= 3320 then break end
                                                            xored = list[801]
                                                        end
                                                    elseif xored < 3323 then
                                                        v7 = v6
                                                        callback9(list[list[737]](list[list[708]](v18, list[1076], list[list[304]]), buffer.readu8(v22, list[990]), buffer.readu8(v23, list[866])), {count})

                                                        xored = list[532]
                                                    else
                                                        v4 += list[list[885]]
                                                        xored = list[935]
                                                    end
                                                else
                                                    if not (xored < 5549) then break end
                                                    if xored < 3327 then
                                                        if xored < 3325 then
                                                            xored = list[1002]
                                                        elseif xored < 3326 then
                                                            xored = list[708]
                                                        else
                                                            list[list[1096]][list[698](list[list[708]](v23, list[1116], list[1002]), buffer.readu8(v18, list[897]))](buffer.readu8(v5, list[642]))
                                                            xored = list[list[267]]
                                                        end
                                                    else
                                                        if not (xored < 3790 and xored < 3566) or xored ~= 3327 then
                                                            break
                                                        end

                                                        xored = list[793]
                                                    end
                                                end
                                            end
                                        end)
                                        xored = list[list[378]]
                                    elseif xored < 5502 then
                                        v12 = v11
                                        xored = list[793]
                                    else
                                        callback9((list[698](list[list[708]](v5, list[539], list[list[1088]]), buffer.readu8(v18, list[list[549]]))))

                                        xored = list[list[819]]
                                    end
                                else
                                    if not (xored < 5685) or xored ~= 5503 then break end

                                    xored = if v11 <= v9 then list[454] else list[708]
                                end
                            end
                        end
                        callback22 = function(...) -- line 15131 · shares: [1] callback3, [2] v26, [3] v36, [4] callback15, [5] v18, [6] v22, [7] list, [8] callback9, [9] v23, [10] v5, [11] v
                            if not callback3 then
                                ({})[1] = v26;
                                ({})[2] = v36;
                                ({})[3] = callback15;
                                ({})[4] = callback3;
                                ({})[5] = v18;
                                ({})[6] = v22;
                                ({})[7] = list;
                                ({})[8] = callback9;
                                ({})[9] = v23
                            end

                            local list2, count, v2, flag, v3, v4, v6, v7, v8, v9, flag2, v10, v11
                            local xored
                            xored = list[454]

                            while true do
                                xored = bit32.bxor(xored, list[list[794]])

                                if xored < 11925 then
                                    if xored < 8692 then
                                        return
                                    elseif xored < 11921 then
                                        if xored < 11914 then
                                            return
                                        elseif xored < 11920 then
                                            if xored ~= 11914 then break end
                                            v8 = v7
                                            callback9(list[list[737]](list[list[708]](v23, list[674], list[885]), buffer.readu8(v22, list[list[305]]), buffer.readu8(v22, list[544])), {list2[v8]})

                                            xored = list[list[512]]
                                        else
                                            xored = if v6 <= v3 then list[650] else list[935]
                                        end
                                    elseif xored < 11923 then
                                        if xored < 11922 then
                                            return
                                        end

                                        xored = list[1092]
                                    elseif xored < 11924 then
                                        v8 = v7
                                        count = list[947](v8, buffer.readu32(v5, list[444]))
                                        xored = list[1002]
                                    else
                                        v7 = v6
                                        xored = list[list[819]]
                                    end
                                elseif xored < 11932 then
                                    if xored < 11928 then
                                        if xored < 11926 then
                                            xored = list[1092]
                                        elseif xored < 11927 then
                                            list2 = {
                                                callback3((list[list[737]](list[list[708]](v18, list[550], list[732]), buffer.readu8(v5, list[789]), buffer.readu8(v26, list[list[738]])))),
                                                callback3((list[698](list[list[708]](v22, list[1130], list[list[62]]), buffer.readu8(v5, list[list[923]])))),
                                                callback3((list[list[737]](list[list[708]](v22, list[1061], list[738]), buffer.readu8(v26, list[938]), buffer.readu8(v22, list[list[286]])))),
                                                callback3((list[698](list[list[708]](v18, list[list[234]], list[list[105]]), buffer.readu8(v26, list[list[549]])))),
                                                callback3((list[list[737]](list[list[708]](v26, list[669], list[1088]), buffer.readu8(v18, list[654]), buffer.readu8(v5, list[509])))),
                                            }

                                            count = #list2
                                            v2 = buffer.readu8(v5, list[642])
                                            v6 = v2
                                            v3 = count
                                            xored = list[708]
                                        else
                                            xored = list[list[1043]]
                                        end
                                    elseif xored < 11930 then
                                        if xored < 11929 then
                                            v8 = v7

                                            list2 = {
                                                callback3((list[list[737]](list[list[708]](v26, list[711], list[738]), buffer.readu8(v5, list[list[741]]), buffer.readu8(v26, list[875])))),
                                                callback3((list[698](list[list[708]](v22, list[list[360]], list[list[1074]]), buffer.readu8(v5, list[789])))),
                                                callback3((list[698](list[list[708]](v22, list[632], list[list[633]]), buffer.readu8(v5, list[789])))),
                                                callback3((list[list[737]](list[list[708]](v26, list[list[978]], list[list[796]]), buffer.readu8(v5, list[875]), buffer.readu8(v23, list[1083])))),
                                                callback3((list[list[737]](list[list[708]](v18, list[461], list[list[162]]), buffer.readu8(v5, list[list[923]]), buffer.readu8(v26, list[list[305]])))),
                                            }

                                            count = #list2
                                            v2 = buffer.readu8(v5, list[642])
                                            flag2 = false
                                            for i = v2, count do
                                                local v20
                                                v10 = i
                                                local v24
                                                v24 = list[list[819]]

                                                while true do
                                                    if v24 < 3 then
                                                        if v24 < 1 then break end

                                                        if v24 < 2 then
                                                            if flag then
                                                                v24 = list[935]
                                                            else
                                                                v24 = list[1092]
                                                            end
                                                        else
                                                            v11 = v10
                                                            callback9(list[698](list[list[708]](v22, list[list[445]], list[list[239]]), buffer.readu8(v26, list[list[549]])), {v2, count})

                                                            v24 = list[1092]
                                                        end
                                                    elseif v24 < 5 then
                                                        if v24 < 4 then
                                                            v11 = v10
                                                            flag = not list[list[1049]](count, buffer.readu8(v18, list[list[549]]), buffer.readu32(v26, list[664]))

                                                            v24 = list[list[885]]
                                                        else
                                                            flag2 = true
                                                            v24 = list[801]
                                                        end
                                                    elseif v24 < 6 then
                                                        v24 = list[801]
                                                    else
                                                        v11 = v10
                                                        local v30 = list2[v11]
                                                        v2, count = v(function() -- line 15329 · shares: [1] v30, [2] v5, [3] v26, [4] list
                                                            if not v30 then
                                                                ({})[1] = v5;
                                                                ({})[2] = v30;
                                                                ({})[3] = v26;
                                                                ({})[4] = list
                                                            end

                                                            local settings = UserSettings()

                                                            return settings[list[list[737]](list[list[708]](v26, list[list[273]], list[885]), buffer.readu8(v5, list[list[27]]), buffer.readu8(v26, list[875]))](settings, v30)
                                                        end)

                                                        flag = v2
                                                        if flag then
                                                            v24 = list[list[885]]
                                                        else
                                                            v24 = list[532]
                                                        end
                                                    end
                                                end

                                                if flag2 then break end
                                            end

                                            xored = list[793]
                                        else
                                            v8 = v7
                                            count = list[947](v8, buffer.readu32(v26, list[list[656]]))
                                            xored = if count then list[1002] else list[list[267]]
                                        end
                                    elseif xored < 11931 then
                                        xored = if count then list[list[105]] else list[732]
                                    else
                                        xored = if v36 then list[532] else list[list[1043]]
                                    end
                                else
                                    if not (xored < 13208) then break end
                                    if xored < 11934 then
                                        if xored < 11933 then
                                            v8 = v7
                                            xored = if callback15(list[588], list2[v8]) then list[list[885]] else list[list[512]]
                                        else
                                            v8 = v7
                                            count = list[947](v8, buffer.readu32(v23, list[834]))
                                            xored = list[801]
                                        end
                                    elseif xored < 11935 then
                                        xored = if count then list[801] else list[list[378]]
                                    else
                                        if xored ~= 11935 then break end
                                        v6 += list[list[885]]
                                        xored = list[708]
                                    end
                                end
                            end
                        end
                        xored = list[30]
                    end
                elseif xored < 1504 then
                    if xored < 1503 then
                        callback19 = list[351][callback3((list[698](list[10](v18, list[1112], list[532]), buffer.readu8(v18, list[897]))))]
                        local v278 = list[588]
                        v6 = callback19(callback3((list[698](list[10](v26, list[217], list[793]), buffer.readu8(v23, list[546])))), v278[list[698](list[10](v22, list[749], list[708]), buffer.readu8(v26, list[938]))](v278, callback3((list[188](list[10](v22, list[603], list[656]), buffer.readu8(v5, list[875]), buffer.readu8(v26, list[990]))))))

                        local v279 = list[588]
                        callback10 = callback19(callback3((list[188](list[10](v5, list[822], list[77]), buffer.readu8(v22, list[1120]), buffer.readu8(v18, list[65])))), v279[list[188](list[10](v23, list[807], list[116]), buffer.readu8(v5, list[1057]), buffer.readu8(v5, list[544]))](v279, callback3((list[698](list[10](v26, list[175], list[307]), buffer.readu8(v18, list[897]))))))

                        callback = v6[callback8]
                        v2 = callback10[callback2]
                        xored = list[232]
                    else
                        xored = if count <= buffer.readu8(v5, list[642]) then list[450] else list[867]
                    end
                else
                    xored = if xored < 1505 then list[633] else list[1051]
                end
            elseif xored < 1513 then
                if xored < 1509 then
                    if xored < 1507 then
                        xored = list[326]
                    elseif xored < 1508 then
                        list2 = (list2 + buffer.readu8(v5, list[71])) % buffer.readu8(v5, list[1057])
                        xored = list[847]
                    else
                        tbl4 = (tbl4 + buffer.readu8(v5, list[544])) % buffer.readu8(v18, list[789])
                        xored = list[480]
                    end
                elseif xored < 1511 then
                    if xored < 1510 then
                        callback18 = version2
                        xored = list[445]
                    else
                        tbl4 = (tbl4 + buffer.readu8(v22, list[71])) % buffer.readu8(v18, list[789])
                        xored = list[518]
                    end
                elseif xored < 1512 then
                    flag = string[list[10](v22, list[1005], list[1002])](list2, version2)
                    local callback29 = callback4
                    local v279 = callback6(count2, buffer.readu8(v5, list[509]))
                    local v280 = callback4(callback5(count2, buffer.readu8(v18, list[875])), flag) + buffer.readu8(v5, list[642])
                    count2 = callback29(v279, tbl3[v280])

                    version2 += buffer.readu8(v5, list[642])
                    count -= buffer.readu8(v5, list[642])
                    xored = list[284]
                else
                    v50 = v49

                    count = {
                        list[698](list[10](v23, list[464], list[1002]), buffer.readu8(v18, list[1083])),
                        list[698](list[10](v18, list[773], list[454]), buffer.readu8(v26, list[544])),
                        list[698](list[10](v26, list[606], list[221]), buffer.readu8(v5, list[546])),
                        list[698](list[10](v26, list[354], list[178]), buffer.readu8(v5, list[1057])),
                        list[698](list[10](v18, list[157], list[1002]), buffer.readu8(v26, list[861])),
                        list[188](list[10](v5, list[798], list[276]), buffer.readu8(v26, list[861]), buffer.readu8(v5, list[938])),
                        list[698](list[10](v5, list[1122], list[307]), buffer.readu8(v23, list[642])),
                        list[698](list[10](v23, list[912], list[532]), buffer.readu8(v18, list[546])),
                        list[188](list[10](v5, list[820], list[1037]), buffer.readu8(v26, list[425]), buffer.readu8(v5, list[938])),
                        list[698](list[10](v26, list[118], list[1002]), buffer.readu8(v5, list[613])),
                        list[188](list[10](v26, list[660], list[731]), buffer.readu8(v26, list[897]), buffer.readu8(v18, list[990])),
                        (list[698](list[10](v5, list[1046], list[221]), buffer.readu8(v5, list[789]))),
                    }

                    local v282 = count[(list2 * buffer.readu8(v23, list[1057]) + buffer.readu8(v23, list[71])) % buffer.readu8(v23, list[866]) + buffer.readu8(v5, list[642])]

                    xored = if v282 < count[(list2 * buffer.readu8(v23, list[1057]) + buffer.readu8(v23, list[71])) % buffer.readu8(v23, list[866]) + buffer.readu8(v5, list[642])] then list[218] else list[541]
                end
            elseif xored < 1516 then
                if xored < 1514 then
                    local xored2 = bit32.bxor(bit32.bxor(bit32.bxor(bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v26, list[546])), string.byte(tostring(v19))), buffer.readu8(v23, list[861])), buffer.readu32(v22, list[646])), buffer.readu32(v23, list[328])), bit32.bxor(bit32.band(bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v26, list[546])), string.byte(tostring(v19))), buffer.readu8(v23, list[861])), buffer.readu32(v23, list[1020])), buffer.readu32(v26, list[1033]))), buffer.readu32(v23, list[328])), buffer.readu32(v26, list[1033]))

                    xored = if xored2 ~= bit32.rrotate(bit32.bxor(bit32.lrotate(tbl4, buffer.readu8(v26, list[546])), string.byte(tostring(v19))), buffer.readu8(v23, list[861])) then list[534] else list[528]
                elseif xored < 1515 then
                    list2 = version2
                    version2 = callback11(v14, buffer.readu8(v26, list[1083]), buffer.readu8(v18, list[875]))
                    count2 = nil
                    xored = if v15 ~= nil then list[731] else list[1049]
                else
                    xored = if list2 then list[871] else list[981]
                end
            elseif xored < 1518 then
                xored = if xored < 1517 then list[907] else list[180]
            else
                xored = if xored < 1519 then list[151] else list[1106]
            end
        elseif xored < 1534 then
            if xored < 1527 then
                if xored < 1523 then
                    if xored < 1521 then
                        xored = list[429]
                    elseif xored < 1522 then
                        tbl4 = flag
                        xored = list[360]
                    else
                        v50 = v49
                        callback9((list[188](list[10](v23, list[836], list[117]), buffer.readu8(v23, list[312]), buffer.readu8(v5, list[938]))))

                        xored = list[629]
                    end
                elseif xored < 1525 then
                    if xored < 1524 then
                        tbl5 = nil
                        tbl5 = buffer.readu8(v26, list[546]) - buffer.readu8(v18, list[938])
                        tbl5 = buffer.readu8(v5, list[37]) - buffer.readu8(v26, list[37])
                        tbl5 = buffer.readu8(v26, list[546]) - buffer.readu8(v23, list[509])
                        tbl5 = buffer.readu8(v26, list[1083]) + buffer.readu8(v5, list[642])
                        xored = list[273]
                    else
                        tbl5 = nil
                        tbl5 = buffer.readu8(v26, list[37]) - buffer.readu8(v5, list[642])
                        xored = list[29]
                    end
                elseif xored < 1526 then
                    tbl4 = (tbl4 + buffer.readu8(v26, list[938])) % buffer.readu8(v18, list[789])
                    xored = list[1115]
                else
                    xored = if str <= buffer.readu8(v22, list[492]) then list[443] else list[1059]
                end
            elseif xored < 1530 then
                if xored < 1528 then
                    tbl5 = string[list[10](v22, list[1005], list[1002])](callback19, callback20)
                    local callback29 = callback4
                    local v292 = callback6(str, buffer.readu8(v5, list[509]))
                    local v293 = callback4(callback5(str, buffer.readu8(v18, list[875])), tbl5) + buffer.readu8(v5, list[642])
                    str = callback29(v292, tbl3[v293])

                    callback20 += buffer.readu8(v5, list[642])
                    version3 -= buffer.readu8(v5, list[642])
                    xored = list[105]
                elseif xored < 1529 then
                    local v293 = tbl4 * buffer.readu32(v22, list[174]) + buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[37])

                    xored = if v293 <= tbl4 * buffer.readu32(v22, list[174]) + buffer.readu8(v5, list[642]) + buffer.readu8(v26, list[37]) + buffer.readu8(v5, list[642]) then list[537] else list[62]
                else
                    xored = list[1066]
                end
            elseif xored < 1532 then
                if xored < 1531 then
                    list2 = list[588][list[188](list[10](v18, list[777], list[149]), buffer.readu8(v22, list[1120]), buffer.readu8(v22, list[312]))]

                    v17 = list2[list[188](list[10](v23, list[227], list[726]), buffer.readu8(v22, list[1120]), buffer.readu8(v18, list[65]))]

                    v24 = list2[list[188](list[10](v23, list[1130], list[262]), buffer.readu8(v18, list[897]), buffer.readu8(v5, list[564]))]

                    xored = list[114]
                else
                    tbl5 = nil
                    tbl5 = buffer.readu8(v5, list[990]) - buffer.readu8(v18, list[938])
                    xored = list[178]
                end
            elseif xored < 1533 then
                tbl5 = {
                    list[188](list[10](v23, list[264], list[1092]), buffer.readu8(v23, list[1120]), buffer.readu8(v26, list[1083])),
                    list[698](list[10](v18, list[1000], list[114]), buffer.readu8(v22, list[579])),
                    list[698](list[10](v26, list[911], list[532]), buffer.readu8(v18, list[546])),
                    list[188](list[10](v5, list[827], list[732]), buffer.readu8(v23, list[71]), buffer.readu8(v23, list[509])),
                    list[698](list[10](v18, list[984], list[708]), buffer.readu8(v18, list[509])),
                    list[698](list[10](v26, list[43], list[708]), buffer.readu8(v23, list[990])),
                    list[188](list[10](v23, list[56], list[149]), buffer.readu8(v22, list[425]), buffer.readu8(v18, list[37])),
                    list[698](list[10](v5, list[883], list[1002]), buffer.readu8(v23, list[679])),
                    list[188](list[10](v26, list[303], list[116]), buffer.readu8(v26, list[1057]), buffer.readu8(v22, list[230])),
                    list[188](list[10](v23, list[704], list[25]), buffer.readu8(v5, list[875]), buffer.readu8(v23, list[789])),
                    (list[698](list[10](v5, list[275], list[114]), buffer.readu8(v18, list[564]))),
                }

                local v297 = tbl5[(tbl4 * buffer.readu8(v22, list[71]) + buffer.readu8(v5, list[1083])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642])]

                xored = if v297 < tbl5[(tbl4 * buffer.readu8(v22, list[71]) + buffer.readu8(v5, list[1083])) % buffer.readu8(v18, list[37]) + buffer.readu8(v5, list[642])] then list[700] else list[1093]
            else
                xored = list[923]
            end
        else
            if not (xored < 12097) or not (xored < 5290) then break end

            if xored < 1535 then
                callback18 = callback19
                count3 = #callback18
                buffer[list[10](v18, list[496], list[307])](count2, flag, count3)
                flag += buffer.readu8(v26, list[37])
                buffer[list[10](v22, list[335], list[793])](count2, flag, callback18)
                flag += count3
                buffer[list[10](v23, list[485], list[307])](count2, flag, version3)
                flag += buffer.readu8(v18, list[938])
                version2 = flag
                xored = list[76]
            else
                if not (xored < 2097) or xored ~= 1535 then break end

                v53 += list[33]
                xored = list[498]
            end
        end
    end
end
