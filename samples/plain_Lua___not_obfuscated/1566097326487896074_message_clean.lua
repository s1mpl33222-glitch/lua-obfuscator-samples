local players = game:GetService("Players")
local starterPlayer = game:GetService("StarterPlayer")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local v1 = game:GetService("Workspace")
local httpService = game:GetService("HttpService")
local tweenService = game:GetService("TweenService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local virtualUser = game:GetService("VirtualUser")

local v2 = {
  "w'(ih^\"(`Sm", "wm'tdmJTUcH9OO+)0i)", "wP/ZQ^&,", "w[\\\\R?/Q", "wPUWKI^<o",
  "w'X5W3!3QIj,dnFrm&9HS^J=", "wZ;8GB4+/", "w]BCQ+<an_P", "w-gPD\"jJSHE)dBa'JbI", "wCh*Po`/",
  "w]@8MBI.Rj9:\"C1rS5qK7\\Ao^", "w`Od5asP3t]jMu/6>rOX=90", "w`#m;/P16_\"!3.pkqpbQ`",
  "w^C2q%SG=", "w`/$E_B0G<", "wP$!3DoW*sX", "w\\'>d", "wL$A`U", "w*!RHkrOi", "wd@^^h\\b",
  "wIhr#ln?!1X", "wn,nAk", "wt:FC;e_C*Hga", "wmAumfD5k-LQZ", "w^^@Y+>a\\J*S^",
  "wMFr!DD)+U7FtsK&C)I\"%", "w*#i<H", "wl0t&Lpc", "w-XNrM9O-]t2%tN^&(", "wJ69XZ3[m$-UAWWuW/6il",
  "wm,[>pnbCDAfM)_CJU", "w!d&k1eCQp3Z,<al1%:dL", "wB*#Hibug", "w)`GgRm)", "w4SIHOq]!,W0p6",
  "wQWMRko193", "wutPH],-J:D", "w*1g7uk[<`K#'@", "wWm*&-HSZ", "wS8*r#", "w>n\\(h:#@(",
  "weru2JTNF!;HGOL\"MWjs0C<", "w%-1U<;W(X_", "wC'XU;#&Z%", "wF%e:", "wd_N9pt)S\"\"5I?S",
  "w7aPm", "wYf(,@", "wUHGS>7mk2:fAXA_1P-", "wPIPu.@V*lm?p", "wCn<er[GbR0OOo4Qn<cRa,h_<7c\\b",
  "w+l+;", "wZ,0=$f_t", "w%&iG5N#8", "wjA8k", "wm6':?-d$]_o`Ci^&WX",
  "w;24gNY/+**F@9,HZf+*9D$LY+Y(L7R6Ub4q>OK2cF.<1^r\"nP3s/[DSDJ!$V5`17n]^\"l",
  "wOlG[H-it)F$-`#m!nG/I", "weOX0`G[$", "wjqAB>7Z", "w-5jh88k(>H/N4^:GpGdD'm$M!B,'", "wM9X0stG",
  "waY5Jo%t<D", "w9AdF@&4r<j7P8LV4X", "w3?f4A", "wUH-P=46e", "w2U<\\_", "w9;b$ATZaKb",
  "wu.P!7\"D+leM')3WD2X<r8?+", "wM)E'C,f*", "wN,", "wTCX-Boag`u", "wCKdfr&Z", "wb_'r\\WFn@S",
  "wS,tV", "wc.2i#olR<", "wd-TbGjoB", "wPL,%56O)i$'Lu", "wN`b&@jM\\Y6]%1", "w`/",
  "wL)0iSfj!MK[9=VKKN'^[<&!6", "w2VFE>mP8;b7p*\\+t&\"", "w`3\"a95Uo3i`a", "wSTp!q",
  "w1+\"Ed.!dVpMd<t", "w1u9:-2nBp#`9\"3U1$<>KXG\\", "wWLidM\"8P.", "w)?q3I23_aH))81q9ZR",
  "wJaZL9R'e,cT\"3XTAjjF3a_eQW]])&D#RoV", "wT=''U-#G+0)cW4a$p.V", "wG(S#@", "w\"s7S$O(",
  "wgiSB=6QuC", "w$iP'<CU/IZ", "w@T.lHH9c@3$Q", "wF+oWTcBCI8VY<%/@SH:", "weR1/>mPa4t7%G",
  "w!2Rc[gs7e`^2`)\"Q,8M:?qBOts(s", "wCp`e", "wOcqC_P^", "wAl/^=Y7", "wdbO", "wItA7^AuRtFj+Fa",
  "w?rRL*kU\\C?g6F\\?V)g", "w)`?t&m#)CSfjJoEt3'", "wjO5C]mU7[Qo^uC#U!",
  "wsBaQu5I7JoUG`;:8L0B7L<9EYj8lEbG`9b(ZWc.,3qor@/'9!XT4h", "w''#$])ii%;", "wK8FE.@24\\5",
  "w]&?St?C6\"o9W'EGb1%BOkVX,7O#ct)^Do*m4C6F:&1uFBRPu", "wH-De", "wdb", "wk[;U<bZ+?F",
  "wJ!+J\"JU", "w63T?:dNkn<^ijCWL#,)27;p_^aZ*H'S!", "wOst_c=Y", "wPFIGBNF]-Pa^_", "wI%OQrJr5d",
  "wuS+=Qn/", "wtVHadmnSp", "wi1$?d3%I$CY&`!-Jk+(J67A,kTlm", "w'L<@#", "wDNmDB",
  "w&g(j\\MbP)(+N`X<",
  "w\\(hNYp`EARq0P\"&bi>1[m[H_-.tt;cZpc5hG43$9PE^!-^s$dm7@=:/\">9AmXA#&0P#da&ta8KbfPP(ggPD#d-(k5449ZW",
  "w!!", "w-&#!@@MaV+nbG,NmY", "wG6>.C%T3aH", "w1*es%OY.AM", "w:DUD[QI!@Z6_t:d`Y6@",
  "wm&9Dt1o-gLP,,d_oqTWm", "wXI5l", "wJ)uj", "wR*6VV.6FC^KX", "wBl^2R#QMn/", "w#/O*u@m\\j0BWn",
  "wqU!O&Smj3kkt]L$YO_\"", "w:3C\"*</", "w#mb/0K\\", "w\"FU7(nQ9d.7Z", "wDOe*kD)V",
  "wB=U8d\\9t", "w?5qMG", "wP*44Ikuq+U\"f", "waS$I^;L^Qh", "w.e*K5", "wJT/nBnbj4",
  "wlTWoTXN8B&01", "wL_qfmCYL%c%u", "wF+;7`:t`ZP", "w&>_Bo*in)nIf", "wKBDs*#ct/f^5D?X",
  "w!..RG3`r", "w@4N]+", "wj?#ohP#%k&c)\\", "wjQdp>.X/", "w;ZlmZ%5", "w:U#Jc", "whGV-P:4",
  "wgW+W3Yd=Q!eRs?bQ(", "w&U=nP078N#&]n/+mnG", "wBtFP?,b", "w8gB?i", "wUGRaf1_IM!JbSRCJ/",
  "wWZFU", "w:,EU2^Q", "w3,Bn2<;(\\", "w2MA+lql5KO)YeS", "wlZj8", "w%sg\"b",
  "w*G\"V<0cJmam8h`H", "w]3pSF*Ne7Jpu", "w*r&WFf\\X')QW!]2", "wJF20`", "wT)OP\\so4D\"",
  "wbL\\*F6i.:[jbpEanS5*W", "w>M0jLA_UKb-Y#$(j/Eu=VVSY", "w&\\lWc\"Er", "w\"%(a>O(",
  "w\\@`&*[\"CWO#^<KpSN=Zjb`<Af2sqp", "wgnnf94b", "w7R&8ab?WG", "w*'%NdWg",
  "w7W:P#ti=[i-%;`c*(Z", "wu_-!uX2<G/", "w)3T=/epBFN3Z", "wfm.<i_9l?(<eQkKBl9",
  "wjNXq$jNX>qmo-8\"eVc\"knd#I%mD`", "wqEr6", "wkQcK?5&", "w05'/nfq+", "w+%g2Tq(f%",
  "w@I/l(f6(jOJ)HL", "wl9o5<0ap:1epo5B^@-[Hbt8", "wHX&cYld,6", "w/@hDNLRN7o", "wO\\I#(i@WT%",
  "w_qLYNXVO7J", "wQu(m_tI>t\\9KF_r", "w2XR;h)X]G7Vs*a9R^", "weR1/>*#([81e>",
  "wJ<jpu)T4W3e$*[/90", "w=#!VT1j5\"h", "wDAX>3Aam", "w5haI^Xje[Z.HLnMtbc52I[-jQ", "wOJbcQdQS",
  "wSUmnQ5-<a", "wobT", "wOQ[gZq__NS", "wW16j", "wLVH\"(R:%<u*3qfVI?'rb", "wCDQj.Lp0N&",
  "w%[pi1V_.", "wnbWgAUuN", "w38I0A", "w-F+4mnpPM<9@H#52+", "wXg`d", "w/DC7\\)f#5%K#OY",
  "w:fZNa", "wVc=:t)i", "wMM[)L;st", "w;fdoIi3R", "wO^97H", "w7]X69*'6t9e0*4M1H&",
  "wT=Sp]8GC\\L\\fef)[XV`", "wot8ZrfY!Ji1G?5;", "wFd]%AJ.Z", "w>5V7b", "wTY", "w9*DLP-U",
  "wr<Y>*S,>?W]iSrR6=V*I1'5<", "wFk3Q;ZgN", "w`Qr_+N(", "w1is7_eV0", "wUG_I))\\=iF9Q3,:9R",
  "wi2V3(", "w[B32iN[6N4Q,", "w)&MmBJI/Si4O/b3tIl", "wj.Man*&.[", "wMr5`Rna", "wf1DbBdcb#%",
  "w*#i<Hj^01jn[7J:", "w--bGp", "wW*C\"TLos!", "wcR", "w-;XWO7(", "w>gGgGb6.0FAf",
  "w@=n4gp:0jG@.P_]", "wu=(Sddf>uS", "wkWigD9aIY*", "wuIBFbj[;nLIPKQ!.\\#TV5SR<",
  "w1ao'(fb&161'E\"!", "w4DXG2A4Ql*3=$PF", "wX=@(GHXhM", "w.23u$", "waQUPA/3<f.", "w\"U#;0&A1Z",
  "woPHr.%i", "wn+,4]2rUJ", "w1]1J", "wj\\)'", "w-_'&=M)90", "wooC8YKdXUo", "wtikBLs7$hd",
  "w*(#jR*ouNjn0j+a", "waeu[7j-", "werkR^SZS\"den", "wQ.tG*f`3r", "w9Z?nb7<]*27(",
  "woQ.[a&=OK,9`'2i2F\"", "w7<K", "wBXRKUO]<", "wAZ3*#", "wCht1i?A,", "w#&\"&", "w+/", "wsaH=]",
  "w%P\\9G$8doV", "wI#s*ckmSYl", "wc;M0s", "wtp=/[)X(X;)i$", "wc>.BH-!4", "w8N7q",
  "w9sXq5me.$<7WC;-", "wQUoE", "wknPm9", "wNA[7LI_i7&[\\", "w7M',`CeX8]>4)!", "w/XL[", "wrEd)A",
  "w0d$9c'+RpZB3rRf8(#)&C2\"`gW(*", "wL7rg)^5AQ8g4fu*", "wL*eiQI+",
  "wo<@lna0p<R<<4R\"77m#qmP7V`)#W", "w,l^#Hb\"8", "wQHj#Fel(8m\"XJpn", "we%X'M1EPF", "wD$",
  "w62_BV", "wa:pZ(", "wWeDWbbrlnr", "wqNZ$O+`EdD", "wm/apioO(", "wJ%Y_/U7Y4[*6b=X-/", "w@m`d)",
  "wU[tRZulLV%D4#1`A5k", "wtg\")25ZafUQ48Jbo<", "w-Y@jmThn", "wkCtj", "w*Csr", "wRPuDPJi8#,)u",
  "w+WG5<:,)=_VYr", "w!n+g", "w[rprI`P\"PokKSe9=Y", "w\"&LI'0fQ8+\\b", "wt]WP-fA)-iUeNRC",
  "w20iuOtgJ8d1mL9_e4s", "w5,Wfr-d@lQ7CEH2mY", "w06p`(UCl:", "w`*\"kJ", "w`URaQc$", "wr7N5&ib",
  "w7f_.9`OYP", "w15F$5077O\\&5P*bJ\\@", "wcV=Y:Af", "wQQq&+bR",
  "waWQ\\Y+h_e<2NUk>6go?m\\$hOSQ0;*)`'3'COFJ?$#rc!BW`Wl_NA0T%Uh9R%nA9AE[\"p-n5Zf/&l@7MR%`@;d<a",
  "wkLq7A?<", "w$,NSR3!ID", "wtgQ]\\mk4iZt0pJH", "wA_.K", "w9^Za+jg", "w2b$o7", "wjJ#oAn/",
  "wjQC9H", "woSuIu[H;MGM`4", "w%u.T?G,W<2>3i", "w95RC\"M6+", "ws#t'L`a", "w+?No8'STr.lY",
  "w1H\\u87<?^", "wU2^A1X58YFja\\]7DqAUu", "w>uEkT4T7X&gjQ2/f2o", "w*aR]M9!jZ-1u_b%4f]",
  "wN^7Vd6k'A", "wBQa5?R/b", "wbg%Q3!ljh`T,U$N?C5Z`", "w-dT0$Q5rkIJdf$'fu",
  "w:e;/7`Pbkc\\rq2L!`+4C", "w`1CAX*X4&pSg[SkC/Kj2", "w)M'Wm#+", "w8[p,]]&!", "w#'",
  "wJg@N30G1>5tG", "w`$jL;mY", "wC>jhSZ&", "w)`G`doQ+?C", "w7m;nej!NA0JpNDp",
  "w9^5(\"9,`L2e0q1Pj-", "wJ[G9/", "wmX/@Y\"C25]'/", "wsmZ<_)%adt6n$%0CdoHpj>l]J",
  "w0V_N\"T4XO*", "wK*%Yl?p",
  "w/i,JT5CoLn]K[un@aO38TkTjg6]f^#J67.BFoU^//g8-WpL[oS4EBc1Na]5-1^rGK8PUON:R=TJ", "weHK",
  "wk#IFC/Q", "w<-o2Atsg9\"l)", "w*OG#bWRG", "w?Q26=nkRC", "w<`aP", "wABW5:",
  "wnb%pV4KN2cjJTLj2<=", "waU_?", "wBTI=De$\\Q&\\es)j8AT\"A\\b", "w&UbjC", "wC6ha", "w8+%_P?g",
  "w%k-8:", "w?JumNHlCai98dk*O2QW9%Tq@OG51Lk,7%-FtPVKEeO)L5^<-$9>@3O:",
  "wk?,#GI'o)KYAZ\\/W!DM_bdk@F", "w@JY)rQ!)dEo1KMFY7", "wR>N_g[Vq?", "w\\_[Qk", "wM7m#,gfe,",
  "wN&A43", "w%!Xoec/Kjl\"J*", "w@g(SP", "wTa$A", "waZ", "w9R", "w2&AS*", "w6jO0!rDN",
  "wn)X2hNb8`O", "wUacp45(<", "wCU.U4I+", "wfN!O", "weV;hTf:u'>U!", "wBg.)0;W$,",
  "w!;%O^=)oQE@To", "wkE>jD", "w4o^?=j1VP:J0\\Ne)5", "w0ljn9LYBb", "wlY", "w9QNoj7<_i$Yoh@g%?%",
  "w*O1TtD0", "wf63PfVr", "wsuNNXL3F", "w/9ru,4uklhMR./m4c;/[]lT", "w7]]M@", "wmfI:m8\"OGABA<>",
  "w<=:-L:8]N][D2Moo)rL", "w7;V+QgU", "w6f&=:XXksG.IskonB3r8'#W.m", "w@9@e%", "w)b%3kjQu\"?fjK",
  "w*tDEEeY7&K)5", "wjY]KoIr=Zl", "wZBWNk7Z", "wBf$JG", "w><", "w<[6Hg:CH", "wW/o/", "ws_:Zj9$",
  "wK>*K5", "wkcu)uL'%'M,9", "wlKSJ=T+J<e", "w1HuV!))7A3Q=P/R", "w1/pl%ZR",
  "w4u(:c\\B)3on'dCO%)'1u0DIs>S!!", "wAX6rjF/s", "wQAILAmBN5N90",
  "wjQ8^(C%g4+/u9;<7AG3O[F!4[QbcN", "wU+CNCd`.`gtXJmc>d=", "wU^", "woe.>q'OR_W7a:kO-h+/H",
  "w$5du#", "wLg0aXZ\\fp$", "wXB-DC28Ks", "w8%*[V7fGS", "wA\\lGpY]-", "w*r^RB0G^5/fR*]UQga",
  "w4oKXtjh;';1'E.$jS)", "w2`Z'", "w[>3A", "w&:&)?", "wn>m&njNb`V1a\\ON&Z",
  "w9*lrf*/\\(q*D:u2m8#", "wQmM4qo?dsV05]nTtRb", "wC\"W?\\Y<^", "w@e5LYaSrqQ", "wDdp4sB`",
  "wMK^uhFukY", "wj-U", "w2m#\\/J/", "w%4FGEBS;qW", "wPQltZ`C%6<",
  "w;/GM/.?X@nW[<)kNQ7.#YNj^,Q[*", "w)Kct_2nDph", "w:i^W42;@", "w8$]!=C*V", "wo?B2Q7.Tc)n&QkI",
  "w\"cJK`O7>Q^", "w_uH,03(", "w.+OEJ/I9G3!IJV\"", "weU4a7_f", "wYXZ&,pP<2nXcF_]",
  "w0fM5?1e'k!eF+d=4rp", "wdJseN-WQuN", "wWq1>)+e=2-*J", "w*aN#:)Tu1L9ELE%j<",
  "w$>'V:/[=fs!(b\\!p@`h8", "wf91Hfn3NsM)M50?", "w,\\H,T#u\\Ab?'mbTI@kRp8,TZj", "w!BCfd7\"(gD",
  "wD@MKLb%l!", "w5=_&rq#/8b[oh&K", "w-k_?)u$", "w.4", "w#q@VtiC_i", "wWO7l",
  "wp\"uMb?tBr7W%Jr9ku&", "w\"&!_", "w_s[",
  "w,g&COGX0\\$iX%Wp3YuQ)LR-I4#*n_h?ZY3J8.7RE$3br`tKXuG,X", "wH$qOI/fIiYW>If7?GcSeDIDe",
  "w)j4*L5QC_/J3.nc", "w&F->$`@SD5g\\Ll]f1T!Q", "w^l#/BVr", "w2VXo0", "wt&H\\IfAm",
  "w<T\"7Y]7Ys^.ThIad']]G.]&OYg'N6", "wV'7Ks,9", "wQG>+W", "wND?%&+1<DA", "w5Km1iA][",
  "w0]1ohtn", "w<8P7OJ$4XE", "wnT\\BI", "w:Fh4IA0nF", "w'1b`6", "wb87s", "wJ0`lZ#t27G",
  "wQP4=)ShADC", "w7P`R4_+", "w1HMCQel'8:o!HT[4O+", "w14Ej+eli", "wn[YupC%", "wO7nf*/ieR,>p",
  "wof+r`lL,<Un'Kh_j&s2Z:)A@6,[]", "wA)P1G`1p", "wO-=pW", "wXptOZXB64OYEF",
  "w2M1@`91)@_mf(P:77O", "w&<qb1$W_L/", "wm,Xg+24R-[U5UYR7Z",
  "w@AqSLD.uqF$ouYD4QUD:M9G&F`\"umQQ7]-V%)#]i-:hp;4=7,G]R^fTR?3hV*.:I;ml:j[4aT@f]jVK[/7FK,mY",
  "w]4Uld", "wR+sOK", "wa+htkb4\\.(MY", "wj1#2707M/bUul!\"", "w`7n1lS1", "wB@Mo$M\\eSHP-R#B",
  "w`,HOMoICKG", "wTb:W]BlTnKoT=:9gFM^?b$CjT9g]", "w\\?`P_2+", "wI%p/plb[N",
  "w$#S]\"4fS\\08sT*H?$rNlD='0@1Bsuu", "wP8K)", "wAKYa@IQEhoRg^Vi+Af", "w7[n#\"uai9W7(",
  "w9N`I\"[XM)", "w:084s8(", "wUd(TlJa", "w)&T@6)?(Wam($VI", "wo[gXQj^t8'Q4JaOQ(", "wC4$>",
  "wJ<lV7&8d``Roc_jA<bn,`9bJ\"H&N;Nq>Ek", "w`5VoM:KD!!!7_%bG<HDE", "w9ol^6?)B", "wko8mQ^QgtM",
  "wJbBaR41:H!Ue//e", "w5H6N9d-Pl]1^", "wM=A3s9Kj0+5&", "wR?qs$idD.*;DCl\\F&X)8", "w$XSdGpUCk6",
  "wafo9$cCYm", "w%3pkPj$uA9", "w%nbT", "wjO5ComenJG", "w[A%h", "wZQu#t+Au8",
  "w?=E7u3FNJMB_8hX,p%C,t?n5oQP[", "w#>fBjF8gN:#sG:g!\"I", "wD8$jH1ID@&", "w63Ei=tESeN<%hUkcQm",
  "w\\g#r", "w^bl+", "wDb_q;=?N.QNi0hfV>8;Y\\33Y'T8B", "wW5T`RLu", "w1(KQ89`g5=eY]", "w#oug0",
  "wNgC)1\"f", "w/b`.A]Yu", "wJbsRp<R7@hS(t", "w+CQgpnGAk14WaC$3\\'uV?+(", "wq6XE$1jOln",
  "w1ee[1", "w&po3/5,jW\"fd,_7", "w\"$l=rX_Jc", "w2&1S", "w1Ic'amU,oN!1d\"", "wnY;S'7gEFI^PfST",
  "w8jIU(qY3", "wNs1=Q\\9", "w&1NMBH\\", "waHO\"m03ua&", "wbq.6-D8HE<-+3\"1D2rq-QH>/",
  "w4r8mc)9'.U7mo,b2+", "wrIqPk[07", "wRK/hT", "wQ<DpKf`o", "wl--7Y", "wlE%,='sN%!V(%bQ#h\"$'",
  "w4(p\"a2.FrS7gL5W", "w_);(_Gc", "w_+S<4", "wSsaVG:.mEea%Do7OH3krL?>V*hp\"L", "wa[c]`",
  "w3t0B", "w#\\PfE#3msccJ]gl", "w9EFm+Uu9T", "w2?2`\\^=ii", "wV7S^3", "w$Lq9%", "wO](\\",
  "wOs", "w3pY@Q/Z5,F;T]%'LRd`u&!'h=Qs", "wu:ug\"qcb", "w22EDe#o-o<.4n", "wHGK65/lu",
  "wB(/48WbIFL!N", "waaaTk><rf&\"]K", "wNmafqZo4S", "wi(YF=gU", "wqG0/g/,L",
  "w5U$U1^E@e8:&Rn.ul4\"", "w]Vh\\r", "wK\"&)RHI(S'sNrTTur!(4gp[P&>-RCOIH<", "w$Yi?p8$;B",
  "w)Vg'", "w[ss]23jgAc", "w-m3g_`-=f", "w%0rs\\N0Z$@fQ<?)V5n", "wn)]0sbhsb5ku", "wB]!k`,9",
  "wZ8Uf", "w<C;MOC%", "waP!-", "wjNXq$jNX>qmo-8\"eVP", "wPlW.2F2+QkILu'oAf",
  "wNGQPspWM`^nb=J4S'3AfLu", "w,PqV<;oCkEtM=4", "w*mi]J4BH=^j1A>?1!", "wA#C1`", "wsEtD",
  "wo)gs0", "wV)s*E;c;FFdEX&dT.mdn7[F3b<de", "w)^))64Mo^Xg#+", "we=O_", "wiYZQ_", "w:'$f?C<",
  "wdT'I^D0", "wojdS6&<VLRJ>e.N", "w\"tnY\\", "wu6oIk9R", "w*Bom>\\fI",
  "w^JAZ:)5?jh;@Qq<bi,3@YUFSIca2", "woB0'i", "wk?8:D\"+", "w'-R/s>ZEC\\",
  "w,2,2&,?E\\3Y]ZdR\\X", "w>p7O52jp", "wqgZJ'b&[\\r", "wUq_8#1P=1Qo!HWa", "wf)427&]Y(8m/2+i4b",
  "wYY&_6AG", "w<]O8uLuf#0?p", "w&BX^l", "wDnM$;a(", "w&d)t'4'N@",
  "wp-IfFf5sC^q7BjHs`Ah5Sg'4.We\"9", "wfj+?Vnb6r", "w2c46@90", "w8H]f.Ir9_H&ZrVYsd2'_j-",
  "wpXGW-DcB=", "wo5?", "w,F+o", "w5\"0ku2XC&i5>Y;&cR", "wJ&:)4)RkL]mn\"%f", "w!'C^X",
  "w6s5%`]g", "wG<&Z!p)FM", "w-ukNCj:NM6", "wibYp%;<", "ws$]5W2*b",
  "w$sR%I'_0U7dH0Lh\"5H%XJkB[-$;Oar@Q.KfbfJ2O\"c'=?rX", "w5Zr<J)GM.m`U", "wS@%",
  "w#XLAb`:f&Q$LSj", "wleGn?", "wq)", "w-F)b@78q>sf:qTO", "we9q3c", "wL(!6", "wWgYJQN/*",
  "wB$<&", "wJ\\>A\\mq,+7Jpn@p&4S", "wlAKoeMDCIj", "w\"I3IP.UQg`", "w1QX!`#'", "w94)UJM`",
  "w9BhX5VWZ_4", "wo!59Ao1Q", "w%Sm3`@moYA67_@0iD%Mh",
  "wL2EUY%,fH0ZsMG]Uq?e9I<(394qCk(.HB]0X]7oiUNU>Kg)7pc8Yi1rr,fP$;,nQ9sGVdoB#TcY;]T8])D87;tqptGbj\\ZE",
  "wB*Gp", "wQIp3/8BnPgP^", "w*aQLt0md!_4sp\"GQ,", "w1=-^8f`f:+f`Ng:me.(=",
  "w\\Ns\\$g\\1s/9dun<=34uN^_G@dq`lI", "w%ou`>nR@", "wLIXmWjf\\]#pCb])b9\"h(4\\", "wYWHX_WO`<<",
  "wF(+b", "w[B_qZ?<", "w!N", "wg;Ib5j3P+&M;n", "w4X", "wkAppi5R",
  "wnnJHfKHqIu0TX8R?Resp5g]%[bu`", "wVc`iTa/R_@@o'pK/C!PM.W*r", "w>=$d?u]0+`[&/%,)'pgan(\"",
  "w+/5WBO@Cjb$]fYkA+", "wKL>", "wCKW=G", "w_#L2.+C`(", "wj_KN", "w<u&\"#", "w)b%3k9Egd5fjK",
  "wP(>?ZZfUt#", "wr[so[qY", "wT't>sOD(-", "w9EA_[7<-5#o!O", "wgCS47?8^68", "w$<P0",
  "w4*N&oM'Q", "w<6:(/", "wa2W(#\"G", "w!%Rmflc>\"#6=ep`me2o", "w2BoA@;g", "w<7Kj`",
  "wQ]RoQ1'dM!e]I5e", "w`qp3X4mkk,Mo')o'DPV!", "w4,t!0;g", "wnElCY_f", "wF:6g4", "wqXK,",
  "w-Oaf\"fj1aN]<&dH;9or(", "woTo):@M$E", "w!\\20c2]#DOeSE<", "w[MLK;nQQ:1", "w0!8PI",
  "wt!0F7FUh-ZTY", "wt1X&`", "wQ#Y^63f(", "w-[m^kt4d=n)Mu9e", "wguh]>*@4Ou%cP\\h>&7%[er6)",
  "w.?9nn;g", "wmrfpTtC.&k*Uft[U=<", "wQgUH$n/ug6)5", "w$Cd9t*QHs", "w!?@#", "ws,^Ze",
  "w)q?\\!:r+]", "wG:7ucqem`(^pe", "w,fZ1X", "wbI^r.V'+\\t.!Dj", "wGg6cc:i",
  "wLIq<uOI8j=#1:@uY@'2H", "w1S$?UYdM", "wVsI8#^WM+iU^mgEHOQG-QX#AR", "w@rrnj7PGhT",
  "wtCkba0mu[VQ%'+Z&p1", "wjO5C*eIV\",UuN", "w3YmF0>:$", "wa;AKr1/A6M$[2,6Lq)Ss", "wOc#Y",
  "wm7b\\nUH`U#", "waonF", "wMM?pB<mIm8Hg1nMKh#_$/d3", "w.@.PC", "wF?,$grn6Nopcnl^/JK)",
  "wfLjXg", "w@7KQhj?0ot", "w;Ih$K", "w&Z", "wMq&/Q", "w+HQ;,!nWl.fpTi\\DCk",
  "w+IRDLe%Z4J'LgPERK[icI]mkML_<(`", "w*7gMVO-o[anU", "wnXl&W@>MH", "wsQhg6WNLs", "w9(>0Hf)u;-",
  "wiFKaBQb-", "w&Nl^V79A8", "weR*$pU^", "w>67aAF+", "w%#7<f&1G?#", "w4G89N2!j3B", "wNr",
  "wW4cQL9l5iu;1Fq(s=\"", "wD/WG][\\", "wc:_`\\8<eH", "w0b[4\\=@L*Bspp)W", "wVR1U", "wFrGP'",
  "wjO5C0m8ddVoQ`X", "w-!8WA", "w1Cjb1`U", "w*SRu[bKU;g!(N", "wc03aNG2o", "wt0el'5C2VL",
  "w$i+c57!di.P(6Y/@`", "wFC,:", "w?YF99,9a=", "wK_o.", "wB$\\-_D=9kgcGIY_O,",
  "wjS&#e*8'!Vt3dJD7s", "wbP[SXDUdu", "wm7bGr7]j'h", "wA)?%T5te'<", "wX]W7L", "wb09OLC-`",
  "wfT2g_Ufgttr6t$o5&", "w)`)Rut3Ts9QPCs<j<", "w2\"f``>SpW", "wFX<>95\"W", "w18jDY9sb@Z9Y6r-",
  "w_,+#", "wrkt:J`joiFjo%DgT$2-5C3pDH]`8=o9Z\\rJ`lqq!fN&L-o0[6CqbjD4Y^E;?sDpXg\\+PC4Or",
  "w#0JCD<4%1", "w9Z?nb7<]1(7Ic#", "wQ/W5.UP@d:Ui]I.2C3", "w0^", "w2Dai1C(eG'r=>h+A:r$1",
  "wWZUn?u&", "wlj4HJG#t!-", "w3F$gPC./O", "wmen9=", "wUuE&(4;K[q&.i`(UcN", "wtj7$^V&V",
  "w\\5J$8e+", "wi2-S^F0j#1O0%N", "wB\\L?S^^", "w:%AUb", "wK,a,LA&t[#m3Asd5`RK%l+!N)kjr",
  "wHr86ju[844_\"[5", "w/b[fD'T.C@P8%k_!`N*>L&jhcI+", "wS1*QV7Z", "w`T3D[f<8=;c/KZM+$[",
  "woYj\\Q1U1\"L*GqP+m)", "wBcmr'&KYc", "w)e.T1Ib1ej", "wHbk6", "wQ._*", "w&Hb#Aj\\+9H*r3I0",
  "wJXms8)Ychbo:_s\\", "w1+&u:tg24f5)]h#15)", "wr@O.01cFZPjYV5WmY", "w[8h+CC).8/8T%H,'f,4",
  "wf`7I-U^", "ws=St#", "waUW]ikQMa", "wh,@S", "wmUOVt7.)", "w_S3[gg,SZ_!OZQPkTa81",
  "w21JIAIailh0$d9l.`\"/I?f<'KnJ0", "wu\"RbC#'_3K'CB+S>;&ksGQFmtQ\"\\", "w2O=;h",
  "w?saWfbr#WD1JB", "wN\"t6", "wXP>W", "w'+a%c4[k0", "wnTs2GoQ`?uoQgqhf`N\"#fi", "w@khhe]-",
  "wD!)rk6^qg*KX", "w-f]m\\*J", "wX@MYQ", "wqtgL4T1$rF*:ZL#`N&", "wJ$@Y@&pc/T*U)MHU1",
  "wjO5C07.SA&f?:HM4+s)l4X", "wX;kL=", "w6:WsqWe$rC`$po%d\\", "w>?8KBenV'OM*\"", "wI_P(iW^%U",
  "wB5jRA\"2B(<b[T<q6g", "w5[W\"=BJhYN/^", "wR;n6Jfo<Jr", "wT`", "wN+X0#%O!i<&dU,",
  "woO+m/eF_CVeVjN", "wCN^3^OA@u*mK^q", "wn1\\I_SYgA", "w*#MhGJgiWL0e%#'", "w@_Qc",
  "wI\"_TK:p2#0Gc", "w$12$$?<", "wd]<=", "w#-nY9eCL", "wskIW", "wZ4J;O", "wXK,!fP!",
  "w18=!8e&jX746MJN*Y", "w)sOEF>@V7", "wOcTC", "w\\El(r[!/3_jt(B[",
  "wXl!mT9?tPW!EX(\"jW+Ypik6[;)D*5", "wruD<&/uG5", "wb9An?>WXb\"**,;S:]\"RK", "wJP'F=fdB9LR!",
  "wjP,Y", "w[*C1D.u-%>Y\"\\", "w/pS1#gdTBC32,bd#Q.WdJR?<\\", "w1H\\u87<?`", "w#BSOL#.M",
  "wTu/%J#+5rF_qeA,J(Zn", "wnjC&^Y$2,AONsuG%nd/.o<", "w_T,Ou@5u<GF4>M<Z2//<f5", "wftgL1j#dE=",
  "w1Eoh\\TK-p", "w4Kc-", "wJ8/n", "wi)LBiT%JJMb=smK", "w$V1o=u$B", "wHoA0u*HnPqkpG9",
  "wBru-\"*J", "w4.M(dJt-u(GVkVG_f", "w21V,A+A*I?", "wQ(P`+ga]Mr4:fX`t3P(Sfua", "w@bmSG;V[>-",
  "w?C[$'om^ICQ\"H", "wW.d0tj-", "wn+X\"j", "w#!`Q+D`]", "wN[$_1[^ESQ[dQ+",
  "w&\\Vk#i`@Ie2`W`@C*N", "wZ\"d", "wA3mHRiX", "wKB:ZOfu", "wp+'6T\"1ps", "w2_Wk9_A@JogB#",
  "w8LWg/ga", "w&aW#D7<%g0&W`Sr9tV", "wnRD^hUG7GBmEd>j)u", "wN\"cs\"n.:ol`=LE1",
  "w6g]1<YV4heH.]U)Rq**E<SW:]1*!h2MTPbu%TA;mj$g_i-G)D%", "wWc#_&;M+o!$Y_;5\"X!5kQ-kbC",
  "wY<S(j.mmMWd>*h", "wf:uc:", "w*nkb(9:I!,)VlDh", "w/)gd@A\"F", "w*8!Qa*;r/ctiX/stG",
  "w8f1+It+", "wpprTjH=iBBH0<", "wAoFQ?,\\?0g7s", "wT\\ZL'g/", "wQi2hIQg>TM&7%(/",
  "wjQ@OOe.sYU-3rQD", "w@$_qZ[hA6WqX0", "w3f;W.^DuUgRAJT.J@;YM,S!", "w-e;sI9Z^qq\"m5<Edb",
  "w\"1BttN(", "wfYae#U^", "wd6qO[", "w&&9[j7YP`q", "wN+`*)3)WtbjWR.Y[b", "wUl\"_(*2QX",
  "w*G7I.Qq[Q\\2<GUXtG", "w4n(Y]7<+,591?Z&*G+", "wk9FA89QpNG^V*E", "w.u", "wmsT3/j!/J22%/ta9s^",
  "wM$>b]?3u_G<`/#aH:@[TN_!#CDHb", "wRrJ_AUV>LCRlC:", "w#B3lePY:2Xdor>1cT]ld",
  "w`WPS;?UN=Z8mrs=NK'RS54$YQU:SZM58R6", "wK9YGArX", "w#D`B7", "w)USf", "w?+FU3pCALe+/",
  "w_s#%k*&Vj[", "wj/c'lM`", "w0iPjH*eh9.r'@T9n0i", "wXJdj\";F^", "wNIs+J/P*G", "wUg2,",
  "w$-k?J*`", "wg&!fOm@G7N9g]", "w^Pl0V[An*XTJ", "wFG", "wnhjdVWp", "w1_JF[`Z)TGU^",
  "w*0L.HgaZED", "w15O%tjtkr.&<a7u", "w*)bm\\hD'[_%jMc\"Xa'Z", "wZor$", "wLO:Y8ZI;",
  "w%=qU\\:ZUhUS0T^Q'ie", "w^+:0`Sn<@J", "wsj<o:]-", "wRMJAW", "w9ZMF<>h'7]WUZU5):F)Z'U6",
  "w1c3:H7m:8B7s", "w1=-\\", "w1H\\u87<L<O*a^=Of\\C4\"oOr", "wIO:eZ?\\5:BV4p1INAgi-:;UK#",
  "wh@95H*-]qA8]\"^/6C:Ruk\"?_H\\;T", "wt=h+m!#5*pdIO`t9nOLA$6d", "w@laLE9l9c\"AC#Hg\"U.bc",
  "w0Yf<C6s_", "w,%^_9-a", "w-(fO", "wiU#.!XR", "w7%=[rUG'dul!*", "w/ah?^.o65fJ7k",
  "wZ#W/,'TJ=$BLg$OM0(0Qg?R\"J;pJ", "wt]Ns@", "w\"#jDT", "w=4ZPRu>G", "w5M.$R$qX6BOF,\"",
  "wRl?d[Vn#cO", "w\\C#MUO`KJ)8:,$caZ@BC4b", "w?_#P7P\"S", "wB&Zas6XM%:l\\U*%be6",
  "w:[')+l(b`QMQ,BE]aPmp53h@\"R[Y>", "w2f0\\E@uc5U", "w_gP/;OZ1KQ", "wMaCd", "wQc5:^",
  "wr'hMulW7o%Z$", "wdQ9`[B4FT(>>e$Vp5", "w@^kGr_/YWRi]]M", "w]\"t:g,5[5", "w_^*]KM[)@cqCQ7",
  "wnbC0AfL(#'1578b9@r@$46e", "wD\"jQ", "w+<Idm4]]", "wRkP*C?g%3c.jr+pA5G9dIjX9:",
  "wdUcE0u=euIBDLR=/Q_\\UHF&%-a:to", "w-U>X&?L.t^4P)k.b3", "w;!0+1R(S.\"", "wTV(*YL`^f.",
  "wG>N<h", "wt9F/Yt#[8i%)kq_)YeG13s", "w73OS&_G", "w*PZ4km,G,$r@a>C", "w=;R%:9R", "wBe2.52L?:",
  "w'Uo)-Ya", "w)`?MJ4hb?A7Z", "wZ%)UG", "wpA35VB3K&", "wPR,M_OgC9g", "wUW(`Ji-=5*q@$[K\"+",
  "wZJ2\"1C>n$", "w9&F!", "wf;5A", "wWBb\".aV2\"Zku", "wJp9", "w)`?p", "w.9]9%[b",
  "wo?d`o-$OWB*Ed2!7pg", "w%j(h`l$7!S/l4", "wtHu!_mGa", "w2q+ZZg<4gnC:nRZG>nsD0^", "we_m:+KMa",
  "weT&YD11", "wCB/sfb?R", "wZ`-C_T^QnP", "wm-_FB", "wHKh<!fTGHUSg?HFZAlTmI0$=T=fQ",
  "wokbl4b0C/'", "w@!@D7NN0\\O/GKN\"*DfMVr]Yj", "wG&=jM", "w^J$186MoWM],j=9=`", "wfDaj",
  "wBd`Eo=o`DID<J<Nnr!7\\8ko$:)D?@6n%-La3NtcjDbk9poG^aO!Y1(+`W.ieA+S(,%s\"'MU;S&9/#AU+JCE)**nIaU_cHs",
  "wo#*mHVtS`V>p", "wCOKTMsBQL0hS77YnRlTZlf3%7d\\,pN", "w3n3)SO,", "w6P3grS\"J",
  "w@T>SB\"h-I\\S.p7", "wUgS]r", "w*c[NU-/", "w!VC(C8jAK*", "wUHpsRf:u'>", "wNXc;uP(K", "w\\X",
  "wJ_XK\"2Akh3", "w-?hXsYtp&>7,", "w6/.QC", "wWb3YblY", "w7gHck5?G",
  "w09_T.a!LKu)U,s%8,<R]5V#ShtJ`1$d;+\\", "w.?2M<uTJ", "wD<Xp9n<(", "wXIf0dPX0tLs-7",
  "wBj/rk//p<", "w'@HW`X&", "w!R+g^74_", "w-D1'.f?l^", "wbnAc", "wF,YX#<_I5Gb&", "wjiT!-Wg",
  "wasnP6OSMig4.m", "wjg", "wb(IWAe&GAe", "w)br;FBn\\", "wrfH1/TId", "wk3M<0</", "wZUQLT5BXF.",
  "wRW<\"r!U&k", "wF/\\e&U*MPK", "wUbb4E@7e5.", "we+", "w0TMFkMETs", "w'A)o6\"%+//#uu8RnLX",
  "w^j=k7]8]>2d1HJI\"*g", "wd,DdpfB&&8XqeGu-L=WC", "w.da*jJ!\"`K", "w)Bnhi.Tq1j", "w-U4f",
  "wCQG?", "wUb*ka])Pi", "w9@N!b0PJDhf)u;P", "wG5\\J", "wOJm_4", "w%7:upMF[-KGoBMOo47J0",
  "wc^00l", "wC?*X", "w-RJN/*a73g4'oI+tn", "wm7cnl", "w4.@e", "w_>fdsC>Jp<nm!?%#F;",
  "wML#-:Uh_^%-ai", "w9OA/Ne2p<ij)W[.jtu", "wAXnHjLK@r3TPhR^uonhFlOPo", "weG>F(",
  "wtLVQD\"ACoi", "w%es?G$_8Kh3V?-,cToE;*Y", "we:LS", "wq5rlaT7ArIT)<", "w9*EWqn$.Lr-<3DV*Y",
  "wr/V?>8J#!M", "w>8h@445HWJIWV;h", "w-IkJS4r/gMm7s\\U", "wq(u[aXabj3+7", "wq1;!$&q.N8?Y(Z",
  "w7H9/", "woj\\924B>S(oXD87", "wDB`Il0-QM0", "wO_?.^B)", "wsq27", "w`U", "wM)",
  "wdZ#6TrF)q(HA9OHJkpUd", "wk$G3K00Zn", "wnU`>", "w;;/A?1\\[LNT(@n<k\\\\/Q", "w!!.;)", "w'n(6",
  "w%-Wut`tkM3Y#ql_A#o", "wB5OD", "wMbmIhn6c", "wG$\\T", "wdK/o9", "w<IuSQnNm3",
  "w5)'Td9Ke-Yn%/F`", "w\"gNcV;%W<H\\?DD", "w2Ro*VJ%\"-[-VSRO4\\", "w19cqF", "wH+%m",
  "w@e6.2Os", "wXM)0NtH,N?UM\\#oa0/!N", "w3KSCqfnT", "w-k)5I1Bk",
  "wR`S`K'9c:Sj*^(]I0_+1O4lR/4TE", "w8uG%___r8jqa3BUVYi", "w2pe:*t.E\\i9D;9We]G", "wCd!5",
  "w:Mj26F>0PLfUb5HQ,]]FIR'M)'C$", "wG;hf'TU,8pnD#,", "wI[T7O8I_''6g", "w0#HbJ4(>\"Nnp!O97,",
  "wTh@f=", "woj4-&tI:1_J%_F,", "wX::VR", "w435?", "wVRWOYi0+uD", "wSt^;9=`", "wd6(^IZb?mp",
  "w\\b", "wiior%X&", "w2kV&DJpD", "w)=+Wd^>4J[*Z3^&Vm-dkFG", "w-^A[q1Xg82V2LKoNO-eNM.&",
  "wA6&IX", "w,2<$d", "w*'GW%5@+s9&.*hlen", "w)`G+ReFAm\"Uu(,j", "wSjt\\CFG", "wVj%B", "wR^",
  "wm^\\%tBS<=k", "wnl&sN", "w!QYr&]u>kJ=XqK_d*aL[Rt6Ktjm'@D", "ws4QTL", "wAGet1mK%0+`aVQ8QD;",
  "w>MC)*", "w+/R;aRUkkI1[b=H2?\":<&THR3cA>", "wYUj&4\"+", "wq!fi\"", "wt0flT2V:C@1i=IZ",
  "w5+?_uATjg!", "wJbNEjo\\^j77Ir)q\\b", "w2$cO+)3m\"&)jbtDm/o", "wpC.V6-a",
  "wt<_M\"5J(DY-3(CK", "w_*HLs[pj", "wA6sH0*Y", "wB]l4Sog", "w)UQ5kIf", "w@Z`'eN!pj1IG%Q",
  "wuRnL$", "wfcgs:", "waf4F", "wq%rpp9$", "wq&s5@6V.aZg[W\\YS!", "wBQG^#8o:e:/@J/fn/", "weUlK",
  "w7ar;-QaF;Zo!D-^", "w5)Jtln.N75U+5bX", "w.A/=MYkV49@J%A2j<", "w%3\\!W!$F;!/]U6JG-&mBSC[T-?p",
  "w`icC5", "w78EAo77EMc07M@G", "w?#S[$bope", "wVF=61Hf>=", "w?(\\8\"", "w51mKd3rgSS@!o",
  "wu\\Mt.B>ZC_1J(Z1[TCc", "w^KTmHgU", "wY7", "wYss=3", "w&GHDVlnt$1FIO3%>*mAI\"Ba1LOM?",
  "w<lWZQI2sg", "w-B!f_AhKrs#a*71", "w3,Y]", "w6dO7cX3j56#44=-aU__+t4b&",
  "w`n)IGDl'_CAQ8*,C3rM:t\"3OGD_(H2", "w3oHQ@", "wSLQC\"nAL'1=J", "wgFGZS",
  "wBV2Mij0;Hnq\"cFrcba", "w+uJStm[S?H", "wbgt\\", "wTf[r+", "wjQ[4\\0i8JctpmsG180",
  "w$/\\C,VIi", "wVi7O:", "w)#<XoTK/2SV6js^F4um;", "wIP;d4@\"r9IU0#p", "w8geMb$!", "wt5W]&",
  "w0;utH]MCe", "wF:4+,XQr/'G2'\\L\\Qb4sV^IgtQ4c", "w!t8=-", "w<0-d$s&", "wX3AJk'`%XpQ,",
  "wkfM>PYlB%I", "wnbC>,eV0", "w0Rm)Z7&mRO", "wM)kn#", "wH9rR4D$", "w-:^h/[X", "wBI[UmoFNXkQ(",
  "w*(+%heRh$'1747LU=f", "wtQR^JTJ", "w@sTH9@*Zq2", "wm*CNGt<5&!AEZAH", "wQ.cJ+",
  "wC';qY`<::iW#_>", "w#[>kTupOqU", "w0ZX\\>X/?#i#G-2s>%", "wD)ghS", "wcWaS5P1X$d]-",
  "wWR]^kD6&", "wVnFA-qR*$2W4QnpiDLp=", "wkH%\\@", "wMm:j\"rAb1l", "w4q$M", "wq3dC",
  "wQ<Za*5QuL9)Mo$n9\"V", "wm+'!15r9\\-&%Hc:U_J", "wQg'.<", "w>I&V9]kX(IjCLj", "wS%hQ",
  "wq^pt\"L=X", "wI[4c'", "wZ(V]6*`ib", "wt%d3>", "wJ<s1UUa2;1&H>fSj-", "w<]c/'", "wBDAS[",
  "w3Dnh", "wnlRu=4QtARQg>6\\05H", "wm*ST20>[6P*6cN@8s", "w:u^UM/!B5", "wH\\",
  "wZBWK+menJ@oN<`", "wG+;S1TSrKH\"+CM6!Xi", "wK*E5(aX22.e\"QB%o<", "wRLKK11$n6\\8,",
  "wo/AHjd,%nJt_`Ws#>*", "ws,u#-=ldJ", "wh\\d[!V6g", "wn\\\"CenR-#T-bJY+jA,", "w2G(8",
  "w<#l[d]rB+j0#3q", "wLk2Le=3W", "wF0PK", "w?Wr%C/+J$c<BNVhXIajc1-80F5*5", "w9sXq5meH",
  "wa,4$[u,a3", "w3s1T4@/F&M@@M", "w5-RR]", "wH0Y>l]bad", "wB`", "wNrb/\\Gu", "wQ3LNUjPE",
  "wZBW3Hfj+(", "w!4JmD&7oI)$Q", "w2WM!N1/!h#n96sZj<", "weHH", "w3\\#g#lf\\PFcJGj",
  "w)Jf!>jO5u", "wnTs-EfL(K", "wm#g52f`NoGotm6q", "wKq-EH\\NZGqJ2`\\GX@<#*>=I0aI(k", "wj-/apJU",
  "w8F9Q", "wjp0#h", "w@;.EiUH3nhFq>\"Vt3BR+I5r", "wLg.", "w>b)Ent+(.u=(*c", "wRbb5\\?L=O[",
  "w?jQ<=", "w&m]NQsL-n", "wS;0V-=`", "w)C4.^>ac0O", "w9,VPVjO43Q22r7+7,", "wSOj4\"`:S;<S;fdJ",
  "wm8sTlQuH854!L4<*`", "wU=PWDU!", "w%5", "w,tYd6/`#^s7Iq)'", "w\\1m^`2'+a%C<",
  "w9Kg:4nTK@/o1ZG", "wm+0U?184\\Z0=?&?", "wJtTET$SeosIu*P^>?^3+!2?k-/rgl", "w[X25@U)2",
  "wOmFU$XbRCJ", "w16mu,XW$[", "w2R]4Qmek(Ot0<!$nd?", "wZJ[`V+(_", "w;-9I;Ja",
  "w7W:D6o!c#am/3D", "wi!tX\"ecY^", "w)_cK+BH!L2:CQ-&o/AJks[P", "wZ7%Q", "w;^pXm",
  "w\\BVoA2/io(N<WVk@S$Mi,9", "wJ2A,B6:a@k_aZ", "w\"cqKhWJ^D", "w^PenEr\"r5;]RKcRc2$f",
  "w1FTLT", "wk+<CfB)\\@FP1", "wNZ-S%'7cp", "wTA-'B", "w2q.F$\\U[", "w6dpK", "woC(AkgN2tK&Z",
  "w^@W\\", "w`me&V/6elpjeq3mG=]2u/)@IG%=-+", "wPWG'\\$Q", "w9-(VkH,nE5S=?)", "wnTs-(m8F",
  "wVZ$&nAL!XT+)kb", "wm#g5'eV;RE7CCsh", "w8@Kj=9V_", "w]B7p4BBpYjgcL,", "wHlc3", "w:23H>lfM4",
  "wH0g9", "wU\"3=88MBA;f@,sh!Ne=", "wPFXG?;S!G", "w`;di_!Q*G", "wKUokgaou", "w)[/GK1c3%tepoXi",
  "wjIR!B\\-t]9O,.Q", "wsr*<<7uWH;", "w/^", "wZ5>`U>0Li.", "weT#m2d.qa9+/", "wC5%fU6g",
  "wQpM\\t", "w$<Z!<Wg", "wQ,?U", "wr1nj&+anhuJ/", "wTb9!TJTL", "wK0\"H)s$Wbru,Z$a7U^DGN,",
  "w$)3'!]a61F;$E'(.jAi>'%jugVR?", "wOGsucGG<cL", "wK^l3X^UN9+", "w1/1DBo));Y9hS9&",
  "wUg-hOD]<", "wVA+>1Ta$(<8_WWQ1k$\\l", "wkg+Y<^Y?doo&%", "w*S8B[Z=1lK\"RXSpTJ",
  "w<Rfs(Z,L?lLr;4", "wV/le38,", "wX5\\s", "wN_n$HY/hO/<%p1M%c,", "w5f`@tT`", "wS-;.+", "w,X",
  "w>s-]", "wr9&[+", "wfBJ=VlNbu75jt:0Z4q%r:V$Q[Y(W", "ws0Bb*5kdr.Wp", "w0a!FH)3[*--I:uM",
  "wjOuu$\\N+6fRtW", "wG_Is4cNlF#", "wre45P", "wY$O'g[H3D,cN=2J3_JO", "wqQTU#_G",
  "w3HCVA;b/6*f3XaA[.]?A", "w54U;a4MT9^Rc28Z.Nd0S=X^", "wP#pRFfqgKq5&", "wa\\b_", "wC]tX",
  "wDT+(@%?YNo3T@]\"DeLaTIcT+r.Nq", "wJ/", "w<qq-L", "wr@VB<-IYu,74aA9", "wjj)Ef-d[$$)jm)?",
  "wM`", "w0iNui&7YL32gp0b7(", "w?oJJ1i9LH", "w1:C>C-a", "w8,",
  "wr\\*WpAC35,=]n[9BKA('i]'OI\"s7", "w>)h(,G2s[\\", "w.%LS+WeV$", "w3(", "wKXTTo", "wj+ks",
  "w$(#G\\", "wjO5C*n>=Ut", "wj\\hsGsR", "wHgEWkM:Y^m", "w8lk')0p+h", "wHF*b",
  "wepk:_9O`2;9!]Kb&aE", "wLbq;h7C?G,=J", "wO_?t=#\\jE", "wJeKa`$%)p", "wZ:M3V#X.", "wd9sBrA+",
  "wJI8<$o`s1a*64aZ", "wX,K$9:l#3s9E$4", "w6/H*B", "w'>'&sI'hFi", "w^426lg;ruo=DG^5",
  "woQ3ua3,", "wb*ac6LJ!I'k3aJMRSVgMHVCs@[b", "w4'sL;U4CM=)Jsh4", "w'NMCc`(9", "w.u^uF01",
  "wfFQI3cX$>6VS@2lFG", "wP+,VLRL,*NYc06IFn", "wU7<%5tC<GJ)L3op0U9", "wYn]`@", "wtR'Xu",
  "w4,8?0j?\"1J1=FQm7Z", "w)FO>LS\\WI(", "w9(?p", "w.X+P(D0", "wQ8MJL26DD=",
  "wfbqT?e.%8P0mE(.1^", "w:8_Q\"X3NE0", "w$'c5pF_kRf)=(5_U^", "w-[[[()\"T()1/R'(e+",
  "w1a9[r4fQQDt]-\\a", "wR*Kc%", "w%J=dhb3", "wu1:Ilr^_^AUq;X1^H@O=", "wp?d:]=n@j_:,G[",
  "w<_\\PY", "wgQ+/*F,\\a'", "w^))*9*J", "w`^BU4Q6J[LGc", "wn:X7#", "wcLsS)", "w`.Y3R", "w2+",
  "wD0", "w+_U5>n['LI@J", "wF#<BBsePo<5qr)l#b3$Ka@W", "wDIG;4l7>$\\", "wJOqr;j-", "wTfT\\?",
  "wt-QmK9AH<Yj:ouaJU", "w2R,^k9OVkYtlDH0*Y", "w1#ds(mYDf+F+", "wjo+P011", "wJrE+1ZFoccid)%",
  "w'Kre4DOi?.0,E.J.6BsUU(2nL$/24$7N=", "wj\"5Ud", "wjNXq$jNX>qmZh.Lf`3h0U8ItjeIVe=",
  "we0=sU*kV6+mUQ?A-%U", "w4pPL", "wG0O^", "wQLb)^)i", "wM]('\\;@SXuf#%B+<7", "wY\"qiab3Y_!7(",
  "wrGP=<qdN7ZR0/aDWbMN", "wc\":=.", "wkb`6", "wahtu", "wo8R(es%4", "wKB*FBAgQ9,C)@PAW;(aJ",
  "w%?:V*Jj[C)#jU\\arEf7ZKF]l7@YSn", "wJgcSoAK?00-<[q", "wIAAUVVkj\"", "w@CoT1W<", "wI2h@",
  "woO+td", "wmpr;Q9Eq,[nM2", "wn9p0a", "w&bu", "wQ.tG37.U_Sf[9`;", "w&efRB%u", "wpTSRjt9-KrXR",
  "w<5ppl", "wRk$q", "w,>HB6i*u,", "w-?$l[", "wb&7i&t:^gp", "w8s1VVS;k=InZ?Pml:irZ", "w4+lS*D$",
  "wN[+U1", "w$%$#\\!$Z", "w]XIHc", "w4*c#;*Pkh(n2ZZi", "wUR@US@dh",
  "w:,5Upifo,HV:j.9%3>t?:59qV*NgW1n\"<", "we\\7=XNLBVo/4kJ#M5;rHBY", "w`]1f", "wn#b9",
  "wRcWEM^SV_uJ/3of", "wSs\\L@2!Xa@", "wm;n]V5SSBZjBjlptn", "wD#7OG'q^q",
  "w[V;/%&'0#k@kQT5>`g'9k+*=", "wU6#W-a&6", "wO,", "w$Q[ue", "wePA&27LKdGKeb", "w'^eR6",
  "wUq/R!7<,", "wOPTEe", "w3&P0G`#k697P,+Y]ICS_A5%", "w;OrC", "wmUOVt", "w&&)l", "wk@ThZM(pm",
  "wKia@!/PKmYBY", "w`-CfIVA\\G40%B5_", "w9nc3Ud'Mc,Kr9d\"XL2\\Mp8pA<:`m",
  "w9Tima125[g5<;2$eSl1", "w&)\\2#H!c`NI4`", "w'Z97]aYQ", "wICY-", "w8Fr;n", "wJhhA",
  "wM.*'SFBh7\\l`", "woHlR", "wU=11>e+", "w,dQ+rRf'>", "w8N6C@M`", "wmI*A", "wVZmJs,9@7=",
  "woN;Z*U^", "wi,.M", "wcLVAY'._Lq", "wDa0db$Q", "wOM%\\o_qihC", "w1hNWknOa3M@VE",
  "w*E!RfQ/oCD7m9l2UeJ", "wfP2;!7=Knh-!*0qAA27ugCZVr7>`", "w9s9CsUkC", "wABI,aK)dUT@Le9]-o7gh",
  "w!h%/2", "wF6EMW/X6_a0dH", "wqDAs8,&Y0d]g", "wC:J)99J[\\gKX", "w)A[%`f\"j'cUu$h61^",
  "w^<b3=", "wRg$N+K=U\":", "wl0@bC", "wO$Q&G?$0TZ)u", "wo5No\"F3c<=P1", "wKA5P,mY",
  "wXC<PqoP@_I", "w?QFdk_5Jm9/c&", "w\"+Mg`s#/Zd7)Z", "w]jfu2a(", "w4YCY(+7",
  "w5*.h)0es:\"j:H\"1e2]", "wV!V1,jn!NS5oj-;Q(p>c!HO", "wedlrJ=)s", "wFbsJ",
  "wfT._8-$R-u9A(9r74'", "wL@NcmMdmhYI2@[kr=TE*3s", "w/K,g", "wTKhUD\\PH]C@4_;G+7",
  "wo]8,O!*T,lI$A%i:W@U>/QEFH<mW", "w6XqlMY#_Qa5ur1uO8r)8`m!2hG\\l4", "wLeUo[", "wV`qm&U!",
  "wB/ER", "wh]gN", "wONsq2", "wro2-@se>G+JHuC=$Kl:", "wTA.)K@bD$+]-_3r9NaK=W)1(=R9V", "wBBHV>",
  "wj5W(U&0Yt2", "w?R;?4:sR", "wMBI]%G52\"IZ+4UuN[LHC[fL^U^I^WK+Wa__PdHl2NIt9G=i5Xc5C7",
  "wr)Eq.9PgPQ/!&!f-p?#[oK#bZumF6", "w*.eprV:PF?", "w44^%o", "wm`", "w4dp*jR\"2<j", "w9esBl",
  "w;MaCaVm\\?S[3+3!=NuKNOch", "wOE2$,$s2bbs58s=m`", "weC8R4jQda-jX#",
  "wl:SLTad$@0JI4/N44j$2K&H\\6Z1W", "w/!", "w\\VO[/0^", "w,-TSM%02?", "w9\"bPa7]$", "w0KlbBjDC",
  "wjNX>LQ.J(>f`o", "wN^l+m", "wsOX#aO%*Gp", "wfV>jX4KQBefMF7l1^", "wU&jdYqa_Vg", "wrLRK^",
  "w#j8/", "wA1LH47J7", "w!aXEC", "wZ1OA]6h7Zu:\\-", "w$>cj@BNrsE40/[8*`", "w07^2u5D1VS&qFO$",
  "wKtQ?K", "wNZPCp#'", "wR^k1H*f9]5RencLd/tF?", "w5aNH", "w9tuGl&PdKQQ%A&39S@",
  "w#j>#(+uJqZijcUCS[NYjSCI7gsBKHObk6VQlrhib\\6>jGLqd$6Y28N$=M0c?,hA;$", "wU5,V:*o\\u@U46;=tn",
  "wk`9c18XVC#fJ'NhL!U", "wLu", "wuP,lc", "wf:uJhm#YJaoQ4", "wgn:c7?S%", "wOV-U%'YiS", "w]e!M",
  "wp5*e>UJa\"%Ns", "w01", "wm8rWc", "waH4I2oTM<'a!0f2X*MABHN)!kA=Z", "wf(AlY", "wQ.JuNo!E;Kog",
  "wob;W/f`&sge34LgQZ", "w?0P%+_Ju$Ys$B3Qm`", "wSXu!G!!IDLp3EeKD&lS[", "wR[Ssq*#Mu/",
  "wmR)iXki", "wB\\('<A8h=bh\\>KoP1", "wQWMRko19$.o1iC:U!", "w]d*m]ki",
  "w%Aet6r25a8\"k$U\"['5J", "wWZbrbn+#daX5=-Y\"eW", "w\"s#\\Iomq?[,mFR]_\"M", "w6[G1J)r$[;",
  "wj!?c)<W+7", "wCIB1l", "w3)bP:68Q", "wlN7tT", "wM><B/", "wWtsKana", "w\"VQ<g\"8tuLQb^oS",
  "w#a$9.e-hI;SiV", "wgq%t", "w4sJ\\Ru'^#V@q\"1(o0^\\", "wP?T/", "w@Q=fr2)*/jm@uoS+LZ",
  "wtI:nXn96m@nU", "w\"3oV$", "wAcSj#Zt`<94mNL", "wT!!iQRQ", "wTOL(*P?B", "w5S^*9&Ji",
  "wmef^Af5", "wb.V47V4bcSafbNQm`", "wU:CG", "w-%5s.Q]0>$77B6;mn%", "wj8;^OstHCB\"88&dio4cX",
  "wq(42G01", "w8?.^5&O#k", "w^*!^`IXq/\\Xq''D3q\\+8CYK#OXe2<n", "w]<", "wbl^e.iX",
  "wWfe?\"&F>fd9$", "w2T1=ImTnr%JJa\"", "wXC\\/%Cp", "wjO5C2f`3Z>7WC-:mUj", "w!p404\"pgH",
  "wg.i051!", "w74^s]JF3`.0U`jG&Z", "wY#%9dIG", "wh&qdD,X", "w53gpjs4<U1", "w&\\QoIZi2]",
  "wl2USH_'B#Y1*%", "wK16I", "w4+Bb[]3/", "w4n]7rfLiB>f5", "wj:>Ro2l33.2&2g17Z",
  "wepCH>51SW\\fJ^P9f&T", "wgI<h*Gc&rk[/j_%L:%", "w)i", "wbt3Y=^k*'i,X", "w", "w&H(#F3kCuT",
  "w4+>VTU7Im<J[Zqdf5", "wkh8E:B)", "wbiK6&Wu%e.Ls&", "wfiPp", "wm;2QZ?.3IdGI;7)UbihkT(kD5CJD",
  "w@F7SBO&AW", "w%8\\ss@m:^EFhDp", "wFp<JP", "w7h3hX*N**", "wR_-2J%5", "w9Z?nb7<i",
  "w20Wl!7.0'54+5r>Uau", "w/p8U@cKq#tj]-BX[EY]!]<", "w7ka;iUKc$W8s", "wqd4r]`rW*:l^=",
  "wt3$A#nXX\"\"9JGh$-U", "wf$&[B2RiBc&4ZL[o\"<", "w8&l14", "w4JFOl\"\"A",
  "w13u>\"\"SYZA'i+mZS]]X", "wU=8\":%OY8B", "wXZR#s", "w#):Y>V9??", "w>!UWB.G7*", "w0hu5tY[l",
  "w/.Ed2'bS", "w+H'.WHA7$cY5KA", "wH+bqm'/", "w1@!B_>$B;aR^", "w[tL+W", "wnHKq_s+MIhb<L",
  "wicc)eB%b", "wg#A.CgmCV)\\X", "wYNpm>%sJ2+.>(uIN,", "wR.h@9QXO@!J`\\&hsR", "wQQGZrlY", "wqY",
  "wrZnMMZ*0hoMk,", "wtRbI\\<&&<ChDq*Ja,", "wNW9;l%i", "w!r$t',X", "wmot6P2&3&Be.o5QQ(",
  "wlGE>F", "w1iKXXndQ2#o1ZT67Z", "wnpq6SR^", "wth1R6IjoU%$C%2]1!",
  "wTp\\\"J!:J,YS/Dqf,m/OFY*,:", "wuAS\\>", "wYCer#99n=s", "wcYP6", "wo.r[TMYCb", "wM+)B",
  "wKK05kML[I", "w_6:5V", "wRa#,l+7", "w0@W,,", "wFn", "wZBW4\"", "w*,q,F*#T!>otQ!Loh]",
  "w9D>Tn'J)sAI@/(E#n", "wM75Km,9", "w^@q)pB2@Ku;g", "wCRW7C", "w5Dac1\\^;@etjKba3fc", "w8cEXH",
  "w5ZB@09,II'jLim?", "wtWZl`9`%lE15V2>4b", "w'Yh,7r)[WBR!", "w*m)iJSP`",
  "wYbpC4f`j<^a\"CgO5>Y", "wo)@\\Z", "w4fV3QmaK[Ef5", "wW-,[bOQ[^", "wsqV*$6Eirl", "w]K)$",
  "weR1'Hr,GB]5)`fan-(", "w4\\:dA", "w]q'QO&s", "wN\\cLYUH);%mY", "w9^%\\,n320[Uuu*B1c%",
  "w!&N]@iuribgb%Xi\"*-?pI>+'&'i$s*b,Grim,0", "w?<", "w#-(2dTus(", "wU'bm6rGb3!7=ff]na",
  "wt>-C>", "wN$-Co-Tf@FtpXMY", "wru>;j**@h\"FAc@'oV;tCLmHYc*#T2I3\\:1pVB8l=F#*", "w'.QU",
  "w,K0YX\\b", "wVsNZ$G&T", "wqCpPn:,D!\\", "wK\"1qs-<?e>Tn>E7'Il6(k#_2O&`r", "wp#hl\"m)",
  "w0fBHO*em-k)Y9j37,", "wrE2bRU;*NgFUs", "wScr)+cp*CgM)", "w)8iQ[aE8FpX$ZS#", "wZ*=GR590",
  "wYQkjd", "wer<N=]VrR\\KlmZl", "w&af(u4E$Pdf:lHir@R^", "wt`L8lKXp-c*.r", "wl)", "wpFL;",
  "wmPa4t7%G", "w7ImuooJDg%)lX-e*Y", "wN5=\\=", "wAaPMDg8Ou/)Z?rttD@[", "w1f%^J2.NBKJ\\XW[",
  "wnX6Ia7]?<E7]?IG7.G", "wNh7%f\\X", "w_MaN)?h=.+\"X?>CI_@R", "w&<mg?16$DS99n1D",
  "wot7-9m84L8U#RY6Q(", "we2JEB&7<saJI!YU*J", "wj\\$A", "wj;3H&DZdhi[kMB2\\lbJ+", "w`F^E_",
  "wY'rp)IVYBJ@T1R!H;_", "w>Hbl4uWcZ[J)bo#BA\"1O", "w551,9?nBk@bJE", "w?XcnD", "wf/!C", "wc$",
  "w1H\\u87<L<OtFk'3o!EBIot$l", "wU3O,IebS@-RbQ0p", "wj-=7q*J", "wJ.<;un\\t2Bo[_3^04p",
  "w\\l.fR&WM%#uRPt0lc+!", "wi7coK", "wP'3OV-^du", "wsu1]gr-)QJ2T<!<1I^", "w\"42-?", "w]afu5",
  "wRAn\\5AXMo\"", "wQLTC-aS8", "wLALnlk=\"_", "wo?,7pJQN", "wF+eQM\"(c_L;pR07uE;;M7S.s^29Q",
  "wXXOsU#)f\"<m&)?:Y/", "w?1Ok_", "wg\"ePjp=!", "wZ8'dB>L(D;l7=",
  "w\\#`3BZIF)Q0/29sM?F^T!chL%>p", "w@_Kh", "wU/XDbjSQ_,jN5e@J/", "w:\"sDAG5",
  "wTc%/IB/dleTL&/=", "wKK=JScRB", "w+OPUu1^", "w,d`Thb&", "wo('g'S<(J=DCkr+5N/8WLC6iSP^",
  "wfeE$X", "wq?;t", "wDOISD\\)H()u`E.", "w7qu;#Q=Kd&j^V\"ef`?", "wg'S#<", "w9)tHY&<OOB75g:%)i",
  "wK@MRY@nB@3", "wBf)A8rpQ*&ki", "wjO5Cof`7h]oOr", "wbtE\"", "w>Z+Y11@hW$AIC:",
  "w8g[;A5qlWDlH-S]i^@C+ed#@</\\.gF)I+qN>%", "wU#Oo;$]3", "w^KkJ%H$JAO", "wb8qZd", "w8l2L'",
  "we%5^ff\\,\"foQ%7D)T1", "wiM0BkHl\\", "wn\\3#SoOK", "wU6_$03Z", "wlQ=jO^E\\",
  "w\"(.>'3YS[iIRHh", "w>)&DRM)", "w4pIe\"#*]0CR3(", "wKb", "w5p'o*f].>_uBM*s1\\:",
  "wf#p9d:pcX", "w184h%8o`JB)HChn", "wUao2Z#X.", "wQ.t6", "wW[XY", "w'7Oogc#nd)", "wuLF\"0m`",
  "waAo'f/REb[\\khXD]ej?\"-/", "wQq4)'t.@Jifjk2h", "wJ\\^(,C0k", "wd6J7", "w!dV6\\", "wj-",
  "wdi)?q2-hE'*8PZ?cF9qOVSNeI6g", "w8b2G)/1c,O", "w9T2q[\\LPV", "w*!PSsC;1'-^Y2OAcnG5$QZ",
  "wjO5C-7<-5#o!(J>tI:nCU!", "wR!", "wG^j#@j*K", "wWQCsUF8RNibo?@;R<gKccYm#U#dXU",
  "wjNXq$jNX>qmo-8\"eVc*?9KA2[U!", "w:lV1R&j>&3.Bd0Z/Q", "wqq1W&$LJhGcUW", "w0,\"B<dm2D",
  "w50<1m?g", "wVIPNEN(", "w3/VCb$e@DrCf\"N45*J69K\\", "wI[Rd,", "w@8*CE",
  "wfVbEQ6*M^b)b=X_\\ll?:4b", "wtI]Fj",
  "wck];5mbE-?UpXF6[DahsaC-/8^>UTB.FgNq4B)#.duqKc=f<D_gPFftKCan\"?Ge2Trl#Tm>lb0M5\\R6Fs7?AJe^5",
  "wB$T^rCW+]30B[Oc=TuV", "wugShm", "w6SKV`", "wec)dAZ'0U+]<", "w+&5-", "wGo[1R", "w\\D3Vt6g",
  "w<mCU.mBMCq[X", "w*Fmb2A`&2*H.0", "wNAWd)s1fQ!sR-", "w+sE/n`a",
  "wg)C\"(5FW$<$Yu65)#p/bl1f5GJ;EX", "wH0.N`_lEJ/", "wmVO_Cgk,H", "wQ]0J^*KqN(7]dN\\Jpb",
  "wm+PS)eum=k&uBs.&%R", "wtCY6On2Ml3tR)CT*J", "w]Jqrd.o=EH", "wX$fYAYBWR6",
  "wCJl9cL>SCUY@G.rP1", "wk\\nE84kEXo9uS>D?i`]", "w]XgnCBiOF4B6^", "wuO^YJi]m@J>7st", "wAQ9",
  "wh2%Wk,P'J59p8", "w:]m>Qm`", "wgJe$TXnnK8", "wUZ1S", "wFI\"=I#^5", "w52+VZki", "w1ee[12G",
  "wBn%0!a(", "wo-23YIG=_\"&Z", "wrt))R!Q", "wga", "w9s9l;f?<<", "wQWh5kf`33",
  "w>YkgG]eWRL[l/cNp5", "wa%&N", "w:qd0C]sI/\"'3'O", "wo)J-V&aj@@*U?\\41!", "wMT^[(", "wo[,6l",
  "w!W+Ppam=", "w6<", "wRRCp\"P1", "woh-NcelniH7.hafnpg", "wfi", "w@9FJTt:<\"FS'n7l_et'#Kb",
  "w\\Dm01",
}

for index, value in ipairs({ { 1, 1991 }, { 1, 344 }, { 345, 1991 } }) do
  while value[1] < value[2] do
    v2[value[1]], v2[value[2]], value[1], value[2] = v2[value[2]], v2[value[1]], value[1] + 1, value[2] - 1
  end
end

do
  local sub = string.sub
  local floor = math.floor
  local v3 = type

  local v4 = {
    ["1"] = 23,
    ["+"] = 19,
    v = 1,
    J = 48,
    X = 53,
    ["9"] = 26,
    l = 60,
    Z = 24,
    N = 6,
    i = 55,
    A = 44,
    q = 47,
    U = 13,
    ["6"] = 21,
    p = 43,
    e = 7,
    F = 12,
    n = 25,
    w = 30,
    a = 28,
    k = 18,
    S = 39,
    s = 5,
    L = 57,
    G = 0,
    ["5"] = 45,
    y = 31,
    ["0"] = 37,
    T = 8,
    j = 50,
    P = 40,
    K = 29,
    ["3"] = 11,
    f = 20,
    ["4"] = 42,
    C = 33,
    B = 10,
    ["8"] = 62,
    c = 14,
    ["2"] = 4,
    V = 17,
    R = 16,
    g = 38,
    o = 36,
    d = 46,
    M = 49,
    t = 56,
    H = 15,
    I = 3,
    u = 35,
    r = 52,
    W = 54,
    m = 9,
    O = 61,
    Q = 41,
    h = 34,
    ["7"] = 63,
    E = 2,
    b = 51,
    z = 22,
    x = 58,
    ["/"] = 59,
    Y = 32,
    D = 27,
  }

  local len = string.len
  local insert = table.insert

  local v5 = {
    ["1"] = 27,
    e = 34,
    ["@"] = 1,
    c = 12,
    D = 3,
    o = 31,
    _ = 61,
    ["2"] = 16,
    K = 56,
    ["0"] = 18,
    G = 5,
    F = 43,
    P = 9,
    j = 22,
    ["\""] = 52,
    ["]"] = 13,
    ["9"] = 21,
    ["3"] = 44,
    ["<"] = 69,
    [">"] = 76,
    O = 80,
    ["'"] = 6,
    a = 8,
    J = 24,
    U = 36,
    ["-"] = 15,
    C = 67,
    ["`"] = 51,
    n = 33,
    k = 59,
    d = 74,
    ["5"] = 39,
    E = 83,
    ["\\"] = 20,
    ["."] = 68,
    ["%"] = 41,
    h = 82,
    ["7"] = 35,
    ["="] = 10,
    t = 25,
    ["/"] = 63,
    H = 65,
    I = 70,
    W = 40,
    i = 11,
    s = 57,
    [";"] = 58,
    V = 71,
    r = 29,
    [")"] = 23,
    Y = 78,
    Z = 30,
    R = 72,
    g = 42,
    L = 50,
    ["4"] = 38,
    ["?"] = 49,
    ["+"] = 60,
    ["6"] = 4,
    N = 53,
    f = 32,
    [","] = 2,
    q = 64,
    ["*"] = 28,
    T = 19,
    m = 37,
    ["("] = 84,
    ["$"] = 45,
    b = 75,
    Q = 26,
    u = 66,
    ["^"] = 54,
    M = 46,
    l = 73,
    ["8"] = 62,
    ["!"] = 81,
    ["#"] = 7,
    X = 48,
    A = 79,
    S = 0,
    ["["] = 47,
    ["&"] = 17,
    B = 55,
    p = 14,
    [":"] = 77,
  }

  local char = string.char
  local concat = table.concat

  for i = 1, #v2 do
    local v6 = v2[i]

    if v3(v6) == "string" then
      local v7 = sub(v6, 1, 1)

      if v7 == "m" then
        v6 = sub(v6, 2)
        local v8 = len(v6)
        local v9 = {}
        local v10 = 1
        local v11 = 0
        local v12 = 0

        while v10 <= v8 do
          local v13 = sub(v6, v10, v10)
          local v14 = v4[v13]

          if v14 then
            v11 = v11 + v14 * 64 ^ (3 - v12)
            v12 = v12 + 1

            if v12 == 4 then
              v12 = 0
              insert(v9, char(floor(v11 / 65536), floor(v11 % 65536 / 256), v11 % 256))
              v11 = 0
            end
          elseif v13 == "=" then
            insert(v9, char(floor(v11 / 65536)))

            if v10 >= v8 or sub(v6, v10 + 1, v10 + 1) ~= "=" then
              insert(v9, char(floor(v11 % 65536 / 256)))
            end

            break
          end

          v10 = v10 + 1
        end

        v2[i] = concat(v9)
      elseif v7 == "w" then
        v6 = sub(v6, 2)
        local v15 = len(v6)
        local v16 = {}
        local v17 = 1

        while v17 <= v15 do
          local v18 = v15 - v17 + 1
          local v19 = v18 >= 5 and 5 or v18
          local v20 = 0
          local v21 = v19 > 1

          for j = 0, 4 do
            local v22

            if j < v19 then
              v22 = v5[sub(v6, v17 + j, v17 + j)]

              if not v22 then
                v21 = false
                break
              end
            else
              v22 = 84
            end

            v20 = v20 * 85 + v22
          end

          if v21 then
            local v23 = floor(v20 / 16777216) % 256
            local v24 = floor(v20 / 65536) % 256
            local v25 = floor(v20 / 256) % 256
            local v26 = v20 % 256

            if v19 == 5 then
              insert(v16, char(v23, v24, v25, v26))
            elseif v19 == 4 then
              insert(v16, char(v23, v24, v25))
            elseif v19 == 3 then
              insert(v16, char(v23, v24))
            elseif v19 == 2 then
              insert(v16, char(v23))
            end
          end

          v17 = v17 + v19
        end

        v2[i] = concat(v16)
      end
    end
  end
end

local localPlayer = players.LocalPlayer

local function f1()
  local playerGui, waitForChild

  if gethui then
    local v27, v28 = pcall(gethui)

    if v27 and v28 then
      return v28
    end

    playerGui = localPlayer:FindFirstChild("PlayerGui")

    waitForChild = playerGui
    waitForChild = playerGui or localPlayer:WaitForChild("PlayerGui", 5)

    return waitForChild
  end

  playerGui = localPlayer:FindFirstChild("PlayerGui")

  waitForChild = playerGui
  waitForChild = playerGui or localPlayer:WaitForChild("PlayerGui", 5)

  return waitForChild
end

local v29 = f1()

local f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, f17, f18, f19, f20,
  maxSPEED, boostPOWER, v30, v31, v32, v33, v34, v35, v36, v37, scooterFlySpeed, v38,
  mobileScooterFlySpeed, speedMult, v39, v40, v41, maxSpeed, mobileMaxSpeed, v42,
  mobileBoostPower, v43, v44, v45, mobileSteeringMultiplier, v46, v47, v48, v49, v50, v51,
  instance, instance2, connect, v52, instance3, instance4, connect2, v53, cframe, v54, connect3,
  v55, v56, v57, seatPart, antiCrashToggle, antiCrashToggle2, v58, values, v59, f21, v60, f22,
  f23, v61, connect4, v62, steeringMultiplier, v63, brakePower, v64, suspensionForce, v65,
  maybachSpeed, v66, rightShift, v67, espOutlineTransparency, v68, v69, v70, huge, dropdown,
  v71, connect5, f24, raycastParams, suavleysGUI, f25, frame, textBox, textButton, f26, f27,
  f28, f29, toggle, toggle2, f30, f31, f32, f33, f34, f35, raycastParams2, f36

if not v29 then
  return
else
  if v29:FindFirstChild("SuavleysGUI") then
    v29.SuavleysGUI:Destroy()
  end

  maxSPEED = 240
  boostPOWER = 0
  v30 = false
  v31 = false
  v32 = false
  v33 = false
  v34 = false
  v35 = false
  v36 = false
  v37 = false
  scooterFlySpeed = 50
  v38 = false
  mobileScooterFlySpeed = 50
  speedMult = 3
  v39 = nil
  v40 = nil
  v41 = nil
  maxSpeed = nil
  mobileMaxSpeed = 240
  v42 = false
  mobileBoostPower = 1.5
  v43 = false
  v44 = 0.05
  v45 = false
  mobileSteeringMultiplier = 1.5
  v46 = false
  v47 = 0.8
  v48 = {}
  v49 = 0
  v50 = 0
  v51 = false
  instance = nil
  instance2 = nil
  connect = nil
  v52 = 0
  instance3 = nil
  instance4 = nil
  connect2 = nil
  v53 = 0
  cframe = nil
  v54 = nil
  connect3 = nil
  v55 = false
  v56 = false
  v57 = false
  seatPart = nil
  antiCrashToggle = nil
  antiCrashToggle2 = nil

  v58 = {
    AutoOpen = false,
    SelectedCrates = { "Basic Crate" },
    OpenAmount = 1,
    Delay = 1,
    AutoLearn = true,
    LearnedRemote = nil,
    LearnedArgsTemplate = nil,
  }

  values = { "Basic Crate", "Charms Crate", "Sticker Pack", "Hardware Crate", "G5 Crate" }
  v59 = {}

  local function f37()
    table.clear(v59)
    local v72 = { "crate", "pack", "case", "unbox", "open", "roll", "spin", "chest", "box" }

    for index2, value2 in ipairs(replicatedStorage:GetDescendants()) do
      if value2:IsA("RemoteEvent") or value2:IsA("RemoteFunction") then
        local v73 = string.lower(value2.Name)
        local v74 = value2.Parent and string.lower(value2.Parent.Name) or ""

        for index3, value3 in ipairs(v72) do
          if string.find(v73, value3) or string.find(v74, value3) then
            table.insert(v59, value2)
            break
          end
        end
      end
    end
  end

  f37()

  pcall(function()
    if not hookmetamethod or not getnamecallmethod then
      return
    end

    local v75 = nil

    v75 = hookmetamethod(game, "__namecall", newcclosure(function(p1, ...)
      local v76 = getnamecallmethod()
      local v77 = { ... }

      if v58.AutoLearn and (v76 == "FireServer" or v76 == "InvokeServer") and not checkcaller() then
        local lower = string.lower
        local v78 = v77[1]
        local v79 = lower(tostring(p1.Name))
        local v80 = v78 and string.lower(tostring(v77[1])) or ""

        if string.find(v79, "crate") or string.find(v79, "pack") or string.find(v79, "unbox")
          or string.find(v79, "open") or string.find(v80, "crate") or string.find(v80, "pack") then
          v58.LearnedRemote = p1
          v58.LearnedArgsTemplate = v77
        end
      end

      return v75(p1, ...)
    end))
  end)

  function f5(p2, ...)
    local v81 = { ... }

    task.spawn(function()
      pcall(function()
        if p2:IsA("RemoteEvent") then
          p2:FireServer(unpack(v81))
        elseif p2:IsA("RemoteFunction") then
          p2:InvokeServer(unpack(v81))
        end
      end)
    end)
  end

  function f2(p3)
    local playerGui2 = localPlayer:FindFirstChild("PlayerGui")

    if not playerGui2 or not firesignal then
      return
    else
      local v82 = p3 == 3 and "3" or "1"

      for index4, value4 in ipairs(playerGui2:GetDescendants()) do
        local v83 = value4

        if v83:IsA("TextButton") or v83:IsA("ImageButton") then
          local v84 = string.lower(v83.Name)
          local v85 = v83:IsA("TextButton") and string.lower(v83.Text) or ""

          if string.find(v84, "open") or string.find(v85, "open") or string.find(v84, "buy") then
            if string.find(v84, v82) or string.find(v85, v82) then
              pcall(function()
                firesignal(v83.MouseButton1Click)
                firesignal(v83.Activated)
              end)
            end
          end
        end
      end

      return
    end
  end

  function f21(p4, p5)
    if v58.LearnedRemote then
      local learnedRemote = v58.LearnedRemote
      local learnedArgsTemplate = v58.LearnedArgsTemplate or {}

      if #learnedArgsTemplate >= 2 and type(learnedArgsTemplate[2]) == "number" then
        f5(learnedRemote, p4, p5)
      elseif #learnedArgsTemplate >= 1 and type(learnedArgsTemplate[1]) == "table" then
        f5(learnedRemote, {
          Crate = p4,
          Name = p4,
          Amount = p5,
          Count = p5,
        })
      else
        f5(learnedRemote, p4, p5)

        if p5 == 3 then
          local count = 0

          while true do
            count = 1 + count

            if not (3 >= count) then
              break
            end

            f5(learnedRemote, p4)
            task.wait(0.08)
          end
        else
          f5(learnedRemote, p4)
        end
      end

      return
    end

    for index5, value5 in ipairs(v59) do
      f5(value5, p4, p5)
      f5(value5, "Open", p4, p5)
      f5(value5, { Crate = p4, Amount = p5 })

      if p5 == 3 then
        f5(value5, p4, "3x")
        f5(value5, p4, true)

        for k = 1, 3 do
          f5(value5, p4)
          task.wait(0.05)
        end
      else
        f5(value5, p4)
        f5(value5, p4, "1x")
      end
    end

    f2(p5)
  end

  v60 = { VehicleImpactClient = true, PoliceHitClient = true, HeadImpactClient = true }

  function f3(p6)
    if v57 then
      return
    end

    v57 = true
    v56 = p6

    pcall(function()
      if antiCrashToggle and antiCrashToggle.Set then
        antiCrashToggle:Set(p6)
      end

      if antiCrashToggle2 and antiCrashToggle2.Set then
        antiCrashToggle2:Set(p6)
      end
    end)

    f22(p6)
    v57 = false
  end

  function f22(p7)
    local playerScripts = localPlayer:FindFirstChild("PlayerScripts")
    local starterPlayerScripts = starterPlayer:FindFirstChild("StarterPlayerScripts")

    local function f38(p8)
      if not p8 then
        return
      end

      for index6, value6 in ipairs(p8:GetDescendants()) do
        local v86 = value6

        if v60[v86.Name] then
          pcall(function()
            if v86:IsA("LocalScript") or v86:IsA("Script") then
              v86.Disabled = p7
              v86.Enabled = not p7
            end
          end)
        end
      end
    end

    f38(playerScripts)
    f38(starterPlayerScripts)
  end

  function f23()
    if v35 or v36 or v37 or v38 then
      f22(true)
    else
      f22(v56)
    end
  end

  task.spawn(function()
    local v87 = 0

    while true do
      task.wait(1)

      if v56 then
        local character = localPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
          if humanoid.SeatPart and humanoid.Sit then
            v87 = 0
            seatPart = humanoid.SeatPart
          elseif not humanoid.SeatPart and seatPart and seatPart.Parent then
            v87 = v87 + 1

            if v87 <= 5 then
              pcall(function()
                humanoid.PlatformStand = false
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart then
                  humanoidRootPart.CFrame = seatPart.CFrame + Vector3.new(0, 1.5, 0)
                end

                seatPart:Sit(humanoid)
              end)
            else
              f3(false)
              v87 = 0
            end
          end
        end
      else
        v87 = 0
      end
    end
  end)

  v61 = false
  connect4 = nil
  v62 = false
  steeringMultiplier = 1
  v63 = false
  brakePower = 0.05
  v64 = false
  suspensionForce = 5
  v65 = false
  maybachSpeed = 3
  v66 = false
  rightShift = Enum.KeyCode.RightShift
  v67 = false
  espOutlineTransparency = 0
  v68 = {}
  v69 = 0
  v70 = nil
  huge = math.huge
  dropdown = nil
  v71 = false
  connect5 = nil

  function f4(p9)
    v71 = p9

    if p9 then
      if not connect5 then
        connect5 = localPlayer.Idled:Connect(function()
          virtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
          task.wait(1)
          virtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        end)
      end

      f24()
    elseif connect5 then
      connect5:Disconnect()
      connect5 = nil
    end
  end

  function f24()
    local waitForChild2 = localPlayer:WaitForChild("PlayerGui", 5)
    local afkNotice, frame2

    if not waitForChild2 then
      return
    else
      if waitForChild2:FindFirstChild("AFK_Notice") then
        waitForChild2.AFK_Notice:Destroy()
      end

      afkNotice = Instance.new("ScreenGui")
      afkNotice.Name = "AFK_Notice"
      afkNotice.ResetOnSpawn = false
      afkNotice.IgnoreGuiInset = false
      afkNotice.Parent = waitForChild2

      frame2 = Instance.new("Frame")
      frame2.Size = UDim2.new(0, 560, 0, 60)
      frame2.Position = UDim2.new(0.5, 0, 0, -150)
      frame2.AnchorPoint = Vector2.new(0.5, 0)
      frame2.BackgroundColor3 = Color3.fromRGB(70, 90, 70)
      frame2.BackgroundTransparency = 0
      frame2.BorderSizePixel = 0
      frame2.ZIndex = 10
      frame2.Parent = afkNotice

      local uiCorner = Instance.new("UICorner")
      uiCorner.CornerRadius = UDim.new(0, 12)
      uiCorner.Parent = frame2

      local uiStroke = Instance.new("UIStroke")
      uiStroke.Color = Color3.fromRGB(180, 255, 180)
      uiStroke.Thickness = 2
      uiStroke.Transparency = 0.05
      uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
      uiStroke.Parent = frame2

      local textLabel = Instance.new("TextLabel")
      textLabel.Size = UDim2.new(1, -20, 1, -10)
      textLabel.Position = UDim2.new(0, 10, 0, 5)
      textLabel.BackgroundTransparency = 1
      textLabel.Text = "✅ Anti-Afk Executed. You can now afk without being kicked."
      textLabel.Font = Enum.Font.GothamSemibold
      textLabel.TextSize = 18
      textLabel.TextColor3 = Color3.fromRGB(240, 255, 240)
      textLabel.TextWrapped = true
      textLabel.TextXAlignment = Enum.TextXAlignment.Left
      textLabel.TextYAlignment = Enum.TextYAlignment.Center
      textLabel.ZIndex = 11
      textLabel.Parent = frame2

      tweenService:Create(
        frame2, TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        { Position = UDim2.new(0.5, 0, 0, -50) }
      ):Play()

      task.delay(10, function()
        if afkNotice and afkNotice.Parent then
          local create = tweenService:Create(frame2, TweenInfo.new(
            2, Enum.EasingStyle.Quint, Enum.EasingDirection.In
          ), { Position = UDim2.new(0.5, 0, 0, -120) })

          create:Play()
          create.Completed:Wait()

          afkNotice:Destroy()
        end
      end)

      return
    end
  end

  RaycastParams.new().FilterType = Enum.RaycastFilterType.Exclude

  raycastParams = RaycastParams.new()
  raycastParams.FilterType = Enum.RaycastFilterType.Exclude
  raycastParams.IgnoreWater = true

  local function f39(p10)
    if not p10 then
      return
    end

    task.spawn(function()
      local waitForChild3 = p10:WaitForChild("Head", 5)

      if not waitForChild3 or waitForChild3:FindFirstChild("DiscordWatermark") then
        return
      else
        local discordWatermark = Instance.new("BillboardGui")
        local udim = UDim2.new(0, 350, 0, 60)
        local vector = Vector3.new(0, 3.5, 0)

        discordWatermark.Name = "DiscordWatermark"
        discordWatermark.Size = udim
        discordWatermark.StudsOffset = vector
        discordWatermark.AlwaysOnTop = true
        discordWatermark.Parent = waitForChild3

        local textLabel2 = Instance.new("TextLabel")
        textLabel2.Size = UDim2.new(1, 0, 1, 0)
        textLabel2.BackgroundTransparency = 1
        textLabel2.Text = "https://discord.gg/qGGs3U3t76"

        local color = Color3.fromRGB(0, 220, 255)
        local color2 = Color3.fromRGB(0, 0, 0)

        textLabel2.TextColor3 = color
        textLabel2.TextStrokeTransparency = 0
        textLabel2.TextStrokeColor3 = color2
        textLabel2.Font = Enum.Font.GothamBold
        textLabel2.TextSize = 22
        textLabel2.Parent = discordWatermark

        return
      end
    end)
  end

  if localPlayer.Character then
    f39(localPlayer.Character)
  end

  localPlayer.CharacterAdded:Connect(f39)
  suavleysGUI = Instance.new("ScreenGui")
  local global = Enum.ZIndexBehavior.Global

  suavleysGUI.Name = "SuavleysGUI"
  suavleysGUI.ResetOnSpawn = false
  suavleysGUI.ZIndexBehavior = global

  function f6(p11)
    local v88 = string.lower(p11.Name .. " " .. (p11.Parent and p11.Parent.Name or "") .. " "
      .. (p11:IsA("TextButton") and p11.Text or ""))

    if string.find(v88, "gas") or string.find(v88, "forward") or string.find(v88, "drive")
      or string.find(v88, "accel") or string.find(v88, "vor") or string.find(v88, "up")
      or string.find(v88, "throttle") or v88 == "w" then
      return 1, 0
    end

    if string.find(v88, "brake") or string.find(v88, "back") or string.find(v88, "reverse")
      or string.find(v88, "bremse") or string.find(v88, "down") or string.find(v88, "stop")
      or v88 == "s" then
      return -1, 0
    end

    if string.find(v88, "left") or string.find(v88, "links") or v88 == "a" then
      return 0, -1
    end

    if string.find(v88, "right") or string.find(v88, "rechts") or v88 == "d" then
      return 0, 1
    end

    return 0, 0
  end

  function f7()
    v49 = 0
    v50 = 0

    for key, value7 in pairs(v48) do
      if key and key.Parent then
        if value7[1] ~= 0 then
          v49 = value7[1]
        end

        if value7[2] ~= 0 then
          v50 = value7[2]
        end
      else
        v48[key] = nil
      end
    end
  end

  suavleysGUI.DisplayOrder = 999999
  suavleysGUI.IgnoreGuiInset = true
  suavleysGUI.Parent = v29

  function f25(p12)
    if not p12:IsA("GuiButton") then
      return
    end

    if p12:IsDescendantOf(suavleysGUI) then
      return
    end

    if string.find(string.lower(p12:GetFullName()), "windui") then
      return
    end

    p12.InputBegan:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        local v89, v90 = f6(p12)

        if v89 ~= 0 or v90 ~= 0 then
          v48[p12] = { v89, v90 }
          f7()
        end
      end
    end)

    p12.InputEnded:Connect(function(input2)
      if input2.UserInputType == Enum.UserInputType.Touch
        or input2.UserInputType == Enum.UserInputType.MouseButton1 then
        if v48[p12] then
          v48[p12] = nil
          f7()
        end
      end
    end)
  end

  task.spawn(function()
    local waitForChild4 = localPlayer:WaitForChild("PlayerGui", 5)

    if waitForChild4 then
      for index7, value8 in ipairs(waitForChild4:GetDescendants()) do
        f25(value8)
      end

      waitForChild4.DescendantAdded:Connect(f25)
    end
  end)

  frame = Instance.new("Frame")
  local udim2 = UDim2.new(0, 320, 0, 240)
  local udim3 = UDim2.new(0.5, -160, 0.35, 0)
  local color3 = Color3.fromRGB(18, 18, 24)

  frame.Size = udim2
  frame.Position = udim3
  frame.BackgroundColor3 = color3
  frame.BorderSizePixel = 0
  frame.Active = true
  frame.Parent = suavleysGUI

  Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

  local uiStroke2 = Instance.new("UIStroke")
  uiStroke2.Color = Color3.fromRGB(0, 200, 255)
  uiStroke2.Thickness = 2
  uiStroke2.Parent = frame

  local textLabel3 = Instance.new("TextLabel")
  local udim4 = UDim2.new(1, 0, 0, 35)
  local color4 = Color3.fromRGB(0, 220, 255)
  local gothamBold = Enum.Font.GothamBold

  textLabel3.Size = udim4
  textLabel3.BackgroundTransparency = 1
  textLabel3.Text = "KEY SYSTEM"
  textLabel3.TextColor3 = color4
  textLabel3.Font = gothamBold
  textLabel3.TextSize = 16
  textLabel3.Parent = frame

  local textLabel4 = Instance.new("TextLabel")
  local udim5 = UDim2.new(1, -20, 0, 30)
  local udim6 = UDim2.new(0, 10, 0, 35)

  textLabel4.Size = udim5
  textLabel4.Position = udim6
  textLabel4.BackgroundTransparency = 1

  local color5 = Color3.fromRGB(180, 180, 180)
  local gotham = Enum.Font.Gotham

  textLabel4.Text = "join https://discord.gg/qGGs3U3t76 to receive key"
  textLabel4.TextColor3 = color5
  textLabel4.Font = gotham
  textLabel4.TextSize = 11
  textLabel4.TextWrapped = true
  textLabel4.Parent = frame

  textBox = Instance.new("TextBox")
  local udim7 = UDim2.new(0.92, 0, 0, 38)
  local udim8 = UDim2.new(0.04, 0, 0, 75)
  local color6 = Color3.fromRGB(32, 32, 42)

  textBox.Size = udim7
  textBox.Position = udim8
  textBox.BackgroundColor3 = color6

  local color7 = Color3.fromRGB(255, 255, 255)
  local color8 = Color3.fromRGB(120, 120, 120)
  local gotham2 = Enum.Font.Gotham

  textBox.PlaceholderText = "Enter Key here..."
  textBox.Text = ""
  textBox.TextColor3 = color7
  textBox.PlaceholderColor3 = color8
  textBox.Font = gotham2
  textBox.TextSize = 14
  textBox.Parent = frame

  Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 8)
  local textButton2 = Instance.new("TextButton")
  local udim9 = UDim2.new(0.92, 0, 0, 36)
  local udim10 = UDim2.new(0.04, 0, 0, 120)
  local color9 = Color3.fromRGB(0, 150, 255)

  textButton2.Size = udim9
  textButton2.Position = udim10
  textButton2.BackgroundColor3 = color9

  local color10 = Color3.fromRGB(255, 255, 255)
  local gothamBold2 = Enum.Font.GothamBold

  textButton2.Text = "SUBMIT KEY"
  textButton2.TextColor3 = color10
  textButton2.Font = gothamBold2
  textButton2.TextSize = 14
  textButton2.Parent = frame

  Instance.new("UICorner", textButton2).CornerRadius = UDim.new(0, 8)
  textButton = Instance.new("TextButton")
  local udim11 = UDim2.new(0.92, 0, 0, 36)
  local udim12 = UDim2.new(0.04, 0, 0, 164)
  local color11 = Color3.fromRGB(60, 60, 80)

  textButton.Size = udim11
  textButton.Position = udim12
  textButton.BackgroundColor3 = color11

  local color12 = Color3.fromRGB(255, 255, 255)
  local font = Enum.Font

  function f8(p13, p14, p15, p16, text, fillColor, p17)
    if p16[p13] then
      return
    else
      local highlight = Instance.new("Highlight")
      highlight.Adornee = p14
      highlight.FillColor = fillColor
      highlight.OutlineColor = p17
      highlight.FillTransparency = 0.5
      highlight.OutlineTransparency = espOutlineTransparency
      highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
      highlight.Parent = p14

      local billboardGui = Instance.new("BillboardGui")
      billboardGui.Adornee = p15
      billboardGui.Size = UDim2.new(0, 150, 0, 24)
      billboardGui.StudsOffset = Vector3.new(0, 3, 0)
      billboardGui.AlwaysOnTop = true
      billboardGui.MaxDistance = 5000
      billboardGui.Parent = p15

      local textLabel5 = Instance.new("TextLabel")
      textLabel5.Size = UDim2.new(1, 0, 1, 0)
      textLabel5.BackgroundTransparency = 1
      textLabel5.Text = text
      textLabel5.TextColor3 = p17
      textLabel5.TextStrokeTransparency = 0.2
      textLabel5.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
      textLabel5.Font = Enum.Font.GothamBold
      textLabel5.TextSize = 11
      textLabel5.Parent = billboardGui

      p16[p13] = { highlight = highlight, billboard = billboardGui }
      return
    end
  end

  local gothamBold3 = font.GothamBold

  textButton.Text = "COPY DISCORD"
  textButton.TextColor3 = color12
  textButton.Font = gothamBold3
  textButton.TextSize = 14
  textButton.Parent = frame

  function f9()
    v46 = false

    if connect2 then
      connect2:Disconnect()
      connect2 = nil
    end

    if instance4 then
      instance4:Destroy()
      instance4 = nil
    end

    if instance3 then
      instance3:Destroy()
      instance3 = nil
    end
  end

  local instance5 = Instance.new("UICorner", textButton)
  local udim13 = UDim.new(0, 8)

  function f10()
    for key2, value9 in pairs(v68) do
      if value9.highlight then
        value9.highlight.OutlineTransparency = espOutlineTransparency
      end
    end
  end

  instance5.CornerRadius = udim13

  function f11(p18, canCollide)
    if p18 and p18.Parent then
      for index8, value10 in ipairs(p18:GetConnectedParts(true)) do
        if value10:IsA("BasePart") then
          value10.CanCollide = canCollide
        end
      end
    end

    if localPlayer.Character then
      for index9, value11 in ipairs(localPlayer.Character:GetDescendants()) do
        if value11:IsA("BasePart") then
          value11.CanCollide = canCollide
        end
      end
    end
  end

  function f12(p19, p20, p21)
    local throttleFloat = 0
    local steerFloat = 0

    if p20 and p20:IsA("VehicleSeat") then
      if math.abs(p20.ThrottleFloat) > 0.05 then
        throttleFloat = p20.ThrottleFloat
      elseif p20.Throttle ~= 0 then
        throttleFloat = p20.Throttle
      end

      if math.abs(p20.SteerFloat) > 0.05 then
        steerFloat = p20.SteerFloat
      elseif p20.Steer ~= 0 then
        steerFloat = p20.Steer
      end
    end

    if throttleFloat == 0 and v49 ~= 0 then
      throttleFloat = v49
    end

    if steerFloat == 0 and v50 ~= 0 then
      steerFloat = v50
    end

    if throttleFloat == 0 and p19 and p19.MoveDirection.Magnitude > 0.05 then
      local cframe2 = p20 and p20.CFrame

      local cframe3 = cframe2
      cframe3 = cframe2 or p21 and p21.CFrame

      if cframe3 then
        local vectorToObjectSpace = cframe3:VectorToObjectSpace(p19.MoveDirection)

        if vectorToObjectSpace.Z < -0.15 then
          throttleFloat = 1
        elseif vectorToObjectSpace.Z > 0.15 then
          throttleFloat = -1
        end

        if steerFloat == 0 and math.abs(vectorToObjectSpace.X) > 0.15 then
          steerFloat = vectorToObjectSpace.X > 0 and 1 or -1
        end
      end
    end

    return throttleFloat, steerFloat
  end

  local mouseButton1Click = textButton.MouseButton1Click

  function f13(p22)
    if not p22 or not p22.Parent then
      return false
    elseif p22:IsA("VehicleSeat") then
      return true
    elseif p22:IsA("Seat") then
      local v91 = string.lower(p22.Name)
      local v92 = p22.Parent and string.lower(p22.Parent.Name) or ""

      if string.find(v91, "drive") or string.find(v91, "ride_") or string.find(v92, "ride_")
        or string.find(v92, "scooter") then
        return true
      end

      return false
    else
      return false
    end
  end

  mouseButton1Click:Connect(function()
    if setclipboard then
      setclipboard("https://discord.gg/qGGs3U3t76")
      textButton.Text = "COPIED!"
      task.wait(1.5)
      textButton.Text = "COPY DISCORD"
    else
      textButton.Text = "NOT SUPPORTED"
      task.wait(1.5)
      textButton.Text = "COPY DISCORD"
    end
  end)

  function f26()
    local character2 = localPlayer.Character
    return character2 and character2:FindFirstChildOfClass("Humanoid"), character2 and character2:FindFirstChild("HumanoidRootPart")
  end

  function f14()
    return v35 or v36
  end

  function f15()
    local v93, v94 = f27()

    if not v93 or not v94 then
      return false
    end

    raycastParams.FilterDescendantsInstances = { localPlayer.Character, v93 }

    if v1:Raycast(v94.Position, Vector3.new(0, -7.5, 0), raycastParams) then
      return true
    end

    return v1:Raycast(
      v94.Position - v94.CFrame.LookVector * 2.5, Vector3.new(0, -7.5, 0), raycastParams
    ) ~= nil
  end

  function f27()
    local character3 = localPlayer.Character

    if not character3 then
      return nil, nil
    else
      local humanoid2 = character3:FindFirstChildOfClass("Humanoid")

      if humanoid2 and humanoid2.SeatPart and humanoid2.SeatPart.Parent then
        local parent = humanoid2.SeatPart.Parent

        return parent, humanoid2.SeatPart.AssemblyRootPart or parent.PrimaryPart
          or parent:FindFirstChild("Chassis") or parent:FindFirstChild("Main")
          or parent:FindFirstChildWhichIsA("BasePart") or humanoid2.SeatPart
      end

      return character3, character3:FindFirstChild("HumanoidRootPart")
    end
  end

  function f16()
    local v95 = {}
    local v96, v97 = f26()

    for index10, value12 in ipairs(players:GetPlayers()) do
      if value12 ~= localPlayer and value12.Character
        and value12.Character:FindFirstChild("HumanoidRootPart") and v97 then
        if (v97.Position - value12.Character.HumanoidRootPart.Position).Magnitude <= huge then
          table.insert(v95, value12.Name)
        end
      end
    end

    if #v95 == 0 then
      table.insert(v95, "No Players in Range")
    end

    return v95
  end

  function f17()
    v51 = false

    if connect then
      connect:Disconnect()
      connect = nil
    end

    if instance2 then
      instance2:Destroy()
      instance2 = nil
    end

    if instance then
      instance:Destroy()
      instance = nil
    end
  end

  function f28()
    if connect3 then
      connect3:Disconnect()
    end

    connect3 = runService.Heartbeat:Connect(function()
      if not f14() then
        if connect3 then
          connect3:Disconnect()
          connect3 = nil
        end

        return
      else
        local character4 = localPlayer.Character

        if not character4 then
          return
        else
          local humanoid3 = character4:FindFirstChildOfClass("Humanoid")

          if humanoid3 and v54 and v54.Parent then
            if v54.Occupant ~= humanoid3 then
              v54:Sit(humanoid3)
            end
          end

          return
        end
      end
    end)
  end

  function f29(p23)
    f28()

    local function f40()
      return p23 and v36 or not p23 and v35
    end

    while f40() do
      local character5 = localPlayer.Character

      if not character5 then
        break
      else
        local humanoidRootPart2 = character5:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart2 then
          break
        else
          local assemblyRootPart = humanoidRootPart2.AssemblyRootPart or humanoidRootPart2
          local v98 = p23 and math.clamp(v47, 0.2, 1.5) or 1

          if not v54 or not v54.Parent then
            for index11, value13 in ipairs(assemblyRootPart:GetConnectedParts(true)) do
              if value13:IsA("Seat") or value13:IsA("VehicleSeat") then
                v54 = value13
                break
              end
            end
          end

          f11(assemblyRootPart, false)

          local findFirstChild = character5:FindFirstChild("VehicleImpactClient", true)
            or v1:FindFirstChild("VehicleImpactClient", true)

          if findFirstChild then
            if findFirstChild:IsA("LuaSourceContainer") then
              findFirstChild.Disabled = true
            elseif findFirstChild:IsA("BasePart") then
              findFirstChild.CanCollide = false
            end
          end

          local v99 = 0.35 / v98
          local total = 0
          local position = humanoidRootPart2.Position

          humanoidRootPart2.CFrame = CFrame.new(position)
            * (humanoidRootPart2.CFrame - position) * CFrame.Angles(math.rad(-60), 0, 0)

          while total < v99 and f40() do
            total = total + task.wait()

            humanoidRootPart2.AssemblyLinearVelocity = humanoidRootPart2.CFrame.LookVector
                * (20 * v98)
              + Vector3.new(0, 5, 0)
          end

          if not f40() then
            break
          end

          humanoidRootPart2.AssemblyLinearVelocity = humanoidRootPart2.CFrame.LookVector * 15
            + Vector3.new(0, 60, 0)

          task.wait(0.2 / v98)

          if not f40() then
            break
          else
            local v100 = p23 and 9 or 8
            local v101 = 1.6 / v98
            local total2 = 0

            while total2 < v101 and f40() do
              local v102 = task.wait()
              total2 = total2 + v102
              humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
              local v103 = math.rad(360 * v100 / v101 * v102 * -1)
              local position2 = humanoidRootPart2.Position

              humanoidRootPart2.CFrame = humanoidRootPart2.CFrame * CFrame.Angles(v103, 0, 0)
              humanoidRootPart2.Position = position2
            end

            if not f40() then
              break
            else
              local position3 = humanoidRootPart2.Position
              local lookVector = humanoidRootPart2.CFrame.LookVector
              local unit = Vector3.new(lookVector.X, 0, lookVector.Z).Unit

              if unit.Magnitude > 0 then
                humanoidRootPart2.CFrame = CFrame.new(position3, position3 + unit)
              end

              humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, -20 * v98, 0)

              local raycastParams3 = RaycastParams.new()

              raycastParams3.FilterDescendantsInstances = {
                character5, assemblyRootPart:GetConnectedParts(true),
              }

              raycastParams3.FilterType = Enum.RaycastFilterType.Exclude

              while f40() do
                task.wait(0.05)

                if v1:Raycast(humanoidRootPart2.Position, Vector3.new(0, -5, 0), raycastParams3) then
                  f11(assemblyRootPart, false)
                  break
                end
              end

              if not f40() then
                break
              end

              if f40() and cframe then
                f11(assemblyRootPart, false)
                local v104 = 1 / v98
                local total3 = 0
                local cframe4 = assemblyRootPart.CFrame

                while total3 < v104 and f40() do
                  total3 = total3 + runService.RenderStepped:Wait()
                  local v105 = math.clamp(total3 / v104, 0, 1)

                  assemblyRootPart.CFrame = cframe4:Lerp(cframe, v105 * v105 * (3 - 2 * v105))
                  assemblyRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                  assemblyRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end

                if f40() then
                  assemblyRootPart.CFrame = cframe
                  assemblyRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                  assemblyRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
              end

              if not f40() then
                break
              end

              task.wait(0.4 / v98)
            end
          end
        end
      end
    end
  end

  function f18()
    local v106 = {}

    if listfiles then
      local v107, v108 = pcall(listfiles, "")

      if v107 and v108 then
        for index12, value14 in ipairs(v108) do
          local v109 = string.match(value14, "SuavleyGUI_(.+)%.json$")

          if v109 then
            table.insert(v106, v109)
          end
        end
      end
    end

    if #v106 == 0 then
      table.insert(v106, "default")
    end

    return v106
  end

  toggle = nil

  function f19(p24, p25, p26)
    if v55 then
      return
    end

    if p24 then
      local character6 = localPlayer.Character
      local humanoid4 = character6 and character6:FindFirstChildOfClass("Humanoid")
      local seatPart2 = humanoid4 and humanoid4.SeatPart

      if not humanoid4 or not humanoid4.Sit or not seatPart2 or not f13(seatPart2) then
        v55 = true

        if p25 then
          v36 = false

          pcall(function()
            if toggle2 and toggle2.Set then
              toggle2:Set(false)
            end
          end)
        else
          v35 = false

          pcall(function()
            if toggle and toggle.Set then
              toggle:Set(false)
            end
          end)
        end

        v55 = false

        pcall(function()
          local windUI = getgenv().WindUI or _G.WindUI

          if windUI and windUI.Notify then
            windUI:Notify({
              Title = "Autofarm Error",
              Content = "You must be sitting on a scooter to start the autofarm!",
              Duration = 3,
            })
          end
        end)

        return
      end
    end

    v55 = true

    if p25 then
      v36 = p24

      if p24 and v35 then
        v35 = false

        pcall(function()
          if toggle and toggle.Set then
            toggle:Set(false)
          end
        end)
      end
    else
      v35 = p24

      if p24 and v36 then
        v36 = false

        pcall(function()
          if toggle2 and toggle2.Set then
            toggle2:Set(false)
          end
        end)
      end
    end

    v55 = false
    local character7 = localPlayer.Character

    local humanoidRootPart3 = character7
    humanoidRootPart3 = character7 and character7:FindFirstChild("HumanoidRootPart")

    local assemblyRootPart2 = humanoidRootPart3

    assemblyRootPart2 = humanoidRootPart3
      and (humanoidRootPart3.AssemblyRootPart or humanoidRootPart3)

    if p24 then
      if humanoidRootPart3 and assemblyRootPart2 then
        cframe = assemblyRootPart2.CFrame

        for index13, value15 in ipairs(assemblyRootPart2:GetConnectedParts(true)) do
          if value15:IsA("Seat") or value15:IsA("VehicleSeat") then
            v54 = value15
            break
          end
        end

        f11(assemblyRootPart2, false)
      end

      if p26 then
        p26:SetDesc(p25 and "MOBILE MONEY FARM ACTIVE" or "MONEY FARM ACTIVE")
      end

      f23()
      task.spawn(function() f29(p25) end)
    else
      if not f14() then
        if assemblyRootPart2 then
          f11(assemblyRootPart2, true)
        end

        if connect3 then
          connect3:Disconnect()
          connect3 = nil
        end

        if p26 then
          p26:SetDesc("Status: Idle")
        end
      end

      f23()
    end
  end

  toggle2 = nil

  function f20(p27)
    for key3, value16 in pairs(p27) do
      f30(value16)
      p27[key3] = nil
    end
  end

  function f30(p28)
    if not p28 then
      return
    end

    if p28.highlight and p28.highlight.Parent then
      p28.highlight:Destroy()
    end

    if p28.billboard and p28.billboard.Parent then
      p28.billboard:Destroy()
    end
  end

  function f31()
    if not v67 then
      f20(v68)
      return
    else
      local v110 = {}

      for index14, value17 in ipairs(players:GetPlayers()) do
        if value17 ~= localPlayer and value17.Character
          and value17.Character:FindFirstChild("Head") then
          v110[value17] = true

          f8(
            value17, value17.Character, value17.Character.Head, v68,
            value17.DisplayName or value17.Name, Color3.fromRGB(80, 180, 255),
            Color3.fromRGB(120, 200, 255)
          )
        end
      end

      for key4 in pairs(v68) do
        if not v110[key4] then
          f30(v68[key4])
          v68[key4] = nil
        end
      end

      return
    end
  end

  function f32(p29, p30)
    local v111, v112 = f27()

    if not v111 or not v112 then
      return
    end

    local getPivot = v111:IsA("Model") and v111:GetPivot() or v112.CFrame
    local v113 = os.clock()

    task.spawn(function()
      while true do
        local v114 = math.clamp((os.clock() - v113) / (p30 or 0.8), 0, 1)

        if v112 and v112.Parent then
          local zero = Vector3.zero
          v112.AssemblyLinearVelocity = Vector3.zero
          v112.AssemblyAngularVelocity = zero
        end

        if v111:IsA("Model") then
          v111:PivotTo(getPivot:Lerp(p29, v114))
        else
          v112.CFrame = getPivot:Lerp(p29, v114)
        end

        if v114 >= 1 then
          break
        end

        runService.Heartbeat:Wait()
      end
    end)
  end

  userInputService.InputBegan:Connect(function(input3, p31)
    if p31 then
      return
    end

    if input3.KeyCode == Enum.KeyCode.W or input3.KeyCode == Enum.KeyCode.Up then
      v31 = true
    elseif input3.KeyCode == Enum.KeyCode.S or input3.KeyCode == Enum.KeyCode.Down then
      v32 = true
    elseif input3.KeyCode == Enum.KeyCode.A or input3.KeyCode == Enum.KeyCode.Left then
      v33 = true
    elseif input3.KeyCode == Enum.KeyCode.D or input3.KeyCode == Enum.KeyCode.Right then
      v34 = true
    end
  end)

  userInputService.InputEnded:Connect(function(input4, p32)
    if input4.KeyCode == Enum.KeyCode.W or input4.KeyCode == Enum.KeyCode.Up then
      v31 = false
    elseif input4.KeyCode == Enum.KeyCode.S or input4.KeyCode == Enum.KeyCode.Down then
      v32 = false
    elseif input4.KeyCode == Enum.KeyCode.A or input4.KeyCode == Enum.KeyCode.Left then
      v33 = false
    elseif input4.KeyCode == Enum.KeyCode.D or input4.KeyCode == Enum.KeyCode.Right then
      v34 = false
    end
  end)

  textButton2.MouseButton1Click:Connect(function()
    if textBox.Text == "jbhh" then
      if frame then
        frame:Destroy()
      end

      loadWindUI()
    else
      textBox.Text = ""
      textBox.PlaceholderText = "Wrong Key!"
    end
  end)

  function loadWindUI()
    local v115, v116 = pcall(function()
      return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
    end)

    local suavleysGuiWindow, statusParagraph, boostToggle, betterSteeringToggle,
      betterBrakesToggle, wheelieAssistToggle, toggle3, rainbowEScooterToggle, suspensionToggle,
      maybachSuspensionToggle, playerESPToggle, toggle4, toggle5, toggle6, toggle7,
      autofarmStatusParagraph, keybind, v117, selectConfigDropdown

    if not v115 or not v116 then
      return
    else
      getgenv().WindUI = v116

      pcall(function()
        v116:Notify({
          Title = "System Notice",
          Content = "Some features might not work anymore because the game got a new anti-cheat.",
          Duration = 6,
        })
      end)

      suavleysGuiWindow = v116:CreateWindow({
        Title = "suavleys gui",
        Icon = "https://raw.githubusercontent.com/semhi365-max/1/refs/heads/main/image0.jpeg",
        Author = "Made by suavley",
        Folder = "SuavleysGUI",
        Size = UDim2.fromOffset(530, 420),
        Theme = "Dark",
        Transparent = true,
        ToggleKey = rightShift,
      })

      local aboutTab = suavleysGuiWindow:Tab({ Title = "About", Icon = "info" })
      local scooterTab = suavleysGuiWindow:Tab({ Title = "Scooter", Icon = "bike" })

      local mobileBetaTab = suavleysGuiWindow:Tab({
        Title = "Mobile (beta)",
        Icon = "smartphone",
      })

      local optikTab = suavleysGuiWindow:Tab({ Title = "Optik", Icon = "palette" })
      local autofarmTab = suavleysGuiWindow:Tab({ Title = "Autofarm", Icon = "coins" })
      local cratesTab = suavleysGuiWindow:Tab({ Title = "Crates", Icon = "package" })
      local funTab = suavleysGuiWindow:Tab({ Title = "Fun", Icon = "shield" })
      local otherTab = suavleysGuiWindow:Tab({ Title = "Other", Icon = "compass" })
      local configTab = suavleysGuiWindow:Tab({ Title = "Config", Icon = "settings" })
      suavleysGuiWindow:SelectTab(1)

      aboutTab:Paragraph({
        Title = "Made by suavley",
        Desc = "Join the discord for more",
        Image = "https://raw.githubusercontent.com/semhi365-max/1/refs/heads/main/image0.jpeg",
        ImageSize = 90,
        Buttons = {
          {
            Title = "Copy Discord",
            Icon = "copy",
            Callback = function()
              if setclipboard then
                setclipboard("https://discord.gg/qGGs3U3t76")
              end
            end,
          },
        },
      })

      aboutTab:Paragraph({
        Title = "Notice",
        Desc = "Some features might not work anymore because the game got a new anti-cheat.",
      })

      aboutTab:Paragraph({ Title = "Discord", Desc = "https://discord.gg/qGGs3U3t76" })

      statusParagraph = scooterTab:Paragraph({ Title = "Status", Desc = "Ready" })
      boostToggle = nil
      betterSteeringToggle = nil
      betterBrakesToggle = nil
      wheelieAssistToggle = nil
      toggle3 = nil
      rainbowEScooterToggle = nil
      suspensionToggle = nil
      maybachSuspensionToggle = nil
      playerESPToggle = nil
      toggle4 = nil
      toggle5 = nil
      toggle6 = nil
      toggle7 = nil

      scooterTab:Slider({
        Title = "Speed Cap",
        Step = 1,
        Value = { Min = 30, Max = 1000, Default = maxSPEED },
        Callback = function(value18) maxSPEED = value18 end,
      })

      scooterTab:Slider({
        Title = "Acceleration",
        Step = 0.1,
        Value = { Min = 0, Max = 15, Default = boostPOWER },
        Callback = function(value19) boostPOWER = value19 end,
      })

      scooterTab:Slider({
        Title = "Speed Multiplier",
        Desc = "turn it down if you get teleported back the game got a new anti cheat",
        Step = 0.1,
        Value = { Min = 1, Max = 10, Default = speedMult },
        Callback = function(value20) speedMult = value20 end,
      })

      boostToggle = scooterTab:Toggle({
        Title = "Boost",
        Value = v30,
        Callback = function(value21)
          v30 = value21
          statusParagraph:SetDesc(value21 and "BOOST ACTIVE" or "BOOST OFF")
        end,
      })

      scooterTab:Slider({
        Title = "Fly Speed",
        Step = 5,
        Value = { Min = 10, Max = 1000, Default = scooterFlySpeed },
        Callback = function(value22) scooterFlySpeed = value22 end,
      })

      scooterTab:Toggle({
        Title = "Scooter Fly (PC)",
        Value = v37,
        Callback = function(value23)
          v37 = value23
          f23()
        end,
      })

      scooterTab:Slider({
        Title = "Steering Power",
        Step = 0.1,
        Value = { Min = 0.2, Max = 3, Default = steeringMultiplier },
        Callback = function(value24) steeringMultiplier = value24 end,
      })

      betterSteeringToggle = scooterTab:Toggle({
        Title = "Better Steering",
        Value = v62,
        Callback = function(value25) v62 = value25 end,
      })

      scooterTab:Slider({
        Title = "Brake Power",
        Desc = "make it lower when you crash while braking",
        Step = 0.01,
        Value = { Min = 0.01, Max = 0.2, Default = brakePower },
        Callback = function(value26) brakePower = value26 end,
      })

      betterBrakesToggle = scooterTab:Toggle({
        Title = "Better Brakes",
        Value = v63,
        Callback = function(value27) v63 = value27 end,
      })

      antiCrashToggle = scooterTab:Toggle({
        Title = "Anti Crash",
        Value = v56,
        Callback = function(value28) f3(value28) end,
      })

      toggle3 = scooterTab:Toggle({
        Title = "Glue on Floor",
        Desc = "Keeps vehicle upright and firmly grounded",
        Value = v61,
        Callback = function(value29)
          v61 = value29

          if value29 then
            if not connect4 then
              connect4 = runService.RenderStepped:Connect(function()
                local character8 = localPlayer.Character

                if not character8 then
                  return
                else
                  local humanoid5 = character8:FindFirstChildOfClass("Humanoid")

                  if not humanoid5 or not humanoid5.Sit or not humanoid5.SeatPart then
                    return
                  else
                    local assemblyRootPart3 = humanoid5.SeatPart.AssemblyRootPart
                      or humanoid5.SeatPart

                    if not assemblyRootPart3 then
                      return
                    else
                      if f15() then
                        local assemblyLinearVelocity = assemblyRootPart3.AssemblyLinearVelocity

                        if assemblyLinearVelocity.Y > 2 then
                          assemblyRootPart3.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y
                            * 0.25, assemblyLinearVelocity.Z)
                        end
                      end

                      local v118 = { assemblyRootPart3.CFrame:ToOrientation() }

                      assemblyRootPart3.CFrame = CFrame.new(assemblyRootPart3.Position)
                        * CFrame.Angles(0, v118[2], 0)

                      local assemblyAngularVelocity = assemblyRootPart3.AssemblyAngularVelocity

                      assemblyRootPart3.AssemblyAngularVelocity = Vector3.new(assemblyAngularVelocity.X
                        * 0.1, assemblyAngularVelocity.Y, assemblyAngularVelocity.Z
                        * 0.1)

                      return
                    end
                  end
                end
              end)
            end
          elseif connect4 then
            connect4:Disconnect()
            connect4 = nil
          end
        end,
      })

      wheelieAssistToggle = scooterTab:Toggle({
        Title = "Wheelie Assist",
        Desc = "wheelies for you",
        Value = v51,
        Callback = function(value30)
          local seatPart3

          if value30 then
            local v119 = f26()
            seatPart3 = v119 and v119.SeatPart

            if seatPart3 and f13(seatPart3) then
              instance = Instance.new("Attachment", seatPart3)

              instance2 = Instance.new("AlignOrientation", seatPart3)
              instance2.Mode = Enum.OrientationAlignmentMode.OneAttachment
              instance2.Attachment0 = instance

              local v120 = instance2
              local v121 = instance2
              instance2.MaxTorque = 100000000
              v120.MaxAngularVelocity = 35
              v121.Responsiveness = 30

              local v122, v123
              v122, v52, v123 = seatPart3.CFrame:ToOrientation()

              connect = runService.Heartbeat:Connect(function(delta)
                local v124 = f26()

                if not seatPart3 or not seatPart3.Parent or not v124
                  or v124.SeatPart ~= seatPart3 then
                  f17()
                  return
                else
                  local steerFloat2 = v33 and -1
                    or v34 and 1
                    or seatPart3:IsA("VehicleSeat")
                      and (seatPart3.SteerFloat ~= 0 and seatPart3.SteerFloat or seatPart3.Steer)
                    or 0

                  if steerFloat2 ~= 0 then
                    v52 = v52 - steerFloat2 * 3 * delta
                  end

                  instance2.CFrame = CFrame.Angles(0, v52, 0)
                    * CFrame.Angles(math.rad(35), 0, 0)

                  return
                end
              end)

              v51 = true
            end
          else
            f17()
          end
        end,
      })

      mobileBetaTab:Paragraph({
        Title = "Notice",
        Desc = "If stuff from the normal categories don't work try the mobile version",
      })

      antiCrashToggle2 = mobileBetaTab:Toggle({
        Title = "Anti Crash",
        Value = v56,
        Callback = function(value31) f3(value31) end,
      })

      mobileBetaTab:Slider({
        Title = "Mobile Speed Cap",
        Step = 1,
        Value = { Min = 30, Max = 1000, Default = mobileMaxSpeed },
        Callback = function(value32) mobileMaxSpeed = value32 end,
      })

      mobileBetaTab:Slider({
        Title = "Mobile Boost Power",
        Step = 0.1,
        Value = { Min = 0.5, Max = 10, Default = mobileBoostPower },
        Callback = function(value33) mobileBoostPower = value33 end,
      })

      toggle4 = mobileBetaTab:Toggle({
        Title = "Mobile Speed Boost",
        Value = v42,
        Callback = function(value34) v42 = value34 end,
      })

      mobileBetaTab:Slider({
        Title = "Mobile Fly Speed",
        Step = 5,
        Value = { Min = 10, Max = 1000, Default = mobileScooterFlySpeed },
        Callback = function(value35) mobileScooterFlySpeed = value35 end,
      })

      mobileBetaTab:Toggle({
        Title = "Scooter Fly (Mobile)",
        Value = v38,
        Callback = function(value36)
          v38 = value36
          f23()
        end,
      })

      mobileBetaTab:Slider({
        Title = "Mobile Brake Power",
        Desc = "turn it off or down if you keep on falling",
        Step = 0.01,
        Value = { Min = 0, Max = 0.2, Default = v44 },
        Callback = function(value37) v44 = math.clamp(value37, 0, 0.2) end,
      })

      toggle5 = mobileBetaTab:Toggle({
        Title = "Mobile Better Brakes",
        Value = v43,
        Callback = function(value38) v43 = value38 end,
      })

      mobileBetaTab:Slider({
        Title = "Mobile Steering Power",
        Step = 0.1,
        Value = { Min = 0.5, Max = 3, Default = mobileSteeringMultiplier },
        Callback = function(value39) mobileSteeringMultiplier = value39 end,
      })

      toggle6 = mobileBetaTab:Toggle({
        Title = "Mobile Better Steering",
        Value = v45,
        Callback = function(value40) v45 = value40 end,
      })

      toggle7 = mobileBetaTab:Toggle({
        Title = "Mobile Auto Wheelie",
        Value = v46,
        Callback = function(value41)
          local seatPart4

          if value41 then
            local v125, v126 = f26()
            seatPart4 = v125 and v125.SeatPart

            if seatPart4 and f13(seatPart4) then
              instance3 = Instance.new("Attachment", seatPart4)

              instance4 = Instance.new("AlignOrientation", seatPart4)
              instance4.Mode = Enum.OrientationAlignmentMode.OneAttachment
              instance4.Attachment0 = instance3

              local v127 = instance4
              local v128 = instance4
              instance4.MaxTorque = 100000000
              v127.MaxAngularVelocity = 35
              v128.Responsiveness = 30
              local v129, v130
              v130, v53, v129 = seatPart4.CFrame:ToOrientation()

              connect2 = runService.Heartbeat:Connect(function(delta2)
                local v131, v132 = f26()

                if not seatPart4 or not seatPart4.Parent or not v131
                  or v131.SeatPart ~= seatPart4 then
                  f9()
                  return
                else
                  local v133, v134 = f12(v131, seatPart4, v132)
                  local v135 = v134 ~= 0 and v134 or v33 and -1 or v34 and 1 or 0

                  if v135 ~= 0 then
                    v53 = v53 - v135 * 3 * delta2
                  end

                  instance4.CFrame = CFrame.Angles(0, v53, 0)
                    * CFrame.Angles(math.rad(35), 0, 0)

                  return
                end
              end)

              v46 = true
            end
          else
            f9()
          end
        end,
      })

      rainbowEScooterToggle = optikTab:Toggle({
        Title = "Rainbow EScooter",
        Value = v66,
        Callback = function(value42) v66 = value42 end,
      })

      optikTab:Slider({
        Title = "Suspension Force",
        Step = 1,
        Value = { Min = 1, Max = 10, Default = suspensionForce },
        Callback = function(value43) suspensionForce = value43 end,
      })

      suspensionToggle = optikTab:Toggle({
        Title = "Suspension",
        Value = v64,
        Callback = function(value44) v64 = value44 end,
      })

      optikTab:Slider({
        Title = "Maybach Speed",
        Step = 1,
        Value = { Min = 0, Max = 10, Default = maybachSpeed },
        Callback = function(value45) maybachSpeed = value45 end,
      })

      maybachSuspensionToggle = optikTab:Toggle({
        Title = "Maybach Suspension",
        Value = v65,
        Callback = function(value46) v65 = value46 end,
      })

      autofarmTab:Paragraph({
        Title = "⚠️ WARNING ⚠️",
        Desc = "FARMING TO MUCH MONEY MIGHT GET YOU BANNED FROM THIS GAME",
      })

      autofarmStatusParagraph = autofarmTab:Paragraph({
        Title = "Autofarm Status",
        Desc = "Idle",
      })

      toggle = autofarmTab:Toggle({
        Title = "Farm Money (Scooter)",
        Value = false,
        Callback = function(value47) f19(value47, false, autofarmStatusParagraph) end,
      })

      autofarmTab:Slider({
        Title = "Mobile Farm Speed",
        Desc = "make it slower if it doesnt work for you",
        Step = 0.05,
        Value = { Min = 0.2, Max = 1.5, Default = v47 },
        Callback = function(value48) v47 = math.clamp(value48, 0.2, 1.5) end,
      })

      toggle2 = autofarmTab:Toggle({
        Title = "Mobile Farm Money",
        Value = false,
        Callback = function(value49) f19(value49, true, autofarmStatusParagraph) end,
      })

      cratesTab:Paragraph({
        Title = "Info",
        Desc = "might not work on sUNC executers like xeno or solara",
      })

      cratesTab:Dropdown({
        Title = "Select Crates",
        Values = values,
        Value = { "Basic Crate" },
        Multi = true,
        Callback = function(value50)
          v58.SelectedCrates = {}

          if type(value50) == "table" then
            for key5, value51 in pairs(value50) do
              if type(key5) == "number" and type(value51) == "string" then
                table.insert(v58.SelectedCrates, value51)
              elseif type(key5) == "string" and value51 == true then
                table.insert(v58.SelectedCrates, key5)
              end
            end
          elseif type(value50) == "string" then
            table.insert(v58.SelectedCrates, value50)
          end
        end,
      })

      cratesTab:Dropdown({
        Title = "Open Amount",
        Values = { "1x", "3x" },
        Value = "1x",
        Multi = false,
        Callback = function(value52) v58.OpenAmount = value52 == "3x" and 3 or 1 end,
      })

      cratesTab:Toggle({
        Title = "Auto Open",
        Value = false,
        Callback = function(value53)
          v58.AutoOpen = value53

          if value53 then
            task.spawn(function()
              while v58.AutoOpen do
                local selectedCrates = v58.SelectedCrates

                if #selectedCrates == 0 then
                  selectedCrates = { "Basic Crate" }
                end

                for index15, value54 in ipairs(selectedCrates) do
                  if not v58.AutoOpen then
                    break
                  end

                  f21(value54, v58.OpenAmount)
                  task.wait(v58.Delay)
                end

                task.wait(0.1)
              end
            end)
          end
        end,
      })

      funTab:Paragraph({ Title = "Information", Desc = "you cant drive when the siren goes on" })

      funTab:Button({
        Title = "Steal Nearest Police Car",
        Callback = function()
          local v136, v137 = f26()

          local humanoid6 = localPlayer.Character
            and localPlayer.Character:FindFirstChildOfClass("Humanoid")

          if not v137 or not humanoid6 then
            v116:Notify({ Title = "Error", Content = "Character not found!", Duration = 2 })
            return
          else
            local v138 = nil
            local huge2 = math.huge

            for index16, value55 in ipairs(v1:GetDescendants()) do
              if value55:IsA("VehicleSeat") or value55:IsA("Seat") then
                local v139 = string.lower(value55.Parent.Name .. " " .. value55.Name)

                if string.find(v139, "police") or string.find(v139, "cop")
                  or string.find(v139, "polizei") or string.find(v139, "sheriff") then
                  local magnitude = (v137.Position - value55.Position).Magnitude

                  if magnitude < huge2 then
                    v138 = value55
                    huge2 = magnitude
                  end
                end
              end
            end

            if v138 then
              humanoid6.PlatformStand = false
              v138:Sit(humanoid6)

              v116:Notify({
                Title = "Success",
                Content = "Successfully jumped into nearest police car!",
                Duration = 2,
              })
            else
              v116:Notify({
                Title = "Not Found",
                Content = "No police car found nearby!",
                Duration = 2,
              })
            end

            return
          end
        end,
      })

      otherTab:Toggle({
        Title = "Anti-AFK",
        Value = v71,
        Callback = function(value56) f4(value56) end,
      })

      playerESPToggle = otherTab:Toggle({
        Title = "Player ESP",
        Value = v67,
        Callback = function(value57)
          v67 = value57

          if not value57 then
            f20(v68)
          end
        end,
      })

      otherTab:Slider({
        Title = "ESP Outline Strength",
        Step = 0.05,
        Value = { Min = 0, Max = 1, Default = espOutlineTransparency },
        Callback = function(value58)
          espOutlineTransparency = value58
          f10()
        end,
      })

      local v140 = f16()
      v70 = v140[1]

      dropdown = otherTab:Dropdown({
        Title = "Players in Range",
        Values = v140,
        Default = v140[1],
        Callback = function(value59) v70 = value59 end,
      })

      otherTab:Button({
        Title = "Refresh Players",
        Callback = function()
          local v141 = f16()
          v70 = v141[1]

          if dropdown and dropdown.Refresh then
            dropdown:Refresh(v141)
          end

          v116:Notify({
            Title = "Teleport",
            Content = "Players in range refreshed!",
            Duration = 2,
          })
        end,
      })

      otherTab:Button({
        Title = "Teleport to Selected Player",
        Callback = function()
          if not v70 or v70 == "No Players in Range" then
            v116:Notify({
              Title = "Error",
              Content = "No valid player in range selected!",
              Duration = 2,
            })

            return
          else
            local findFirstChild2 = players:FindFirstChild(v70)

            if findFirstChild2 and findFirstChild2.Character
              and findFirstChild2.Character:FindFirstChild("HumanoidRootPart") then
              f32(findFirstChild2.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 3), 0.6)

              v116:Notify({
                Title = "Teleport",
                Content = "Teleporting to " .. findFirstChild2.Name .. "...",
                Duration = 2,
              })
            else
              v116:Notify({
                Title = "Error",
                Content = "Player character not found!",
                Duration = 2,
              })
            end

            return
          end
        end,
      })

      task.spawn(function()
        while true do
          task.wait(5)
          local v142 = f16()

          if dropdown and dropdown.Refresh then
            dropdown:Refresh(v142)

            if not table.find(v142, v70) then
              v70 = v142[1]
            end
          end
        end
      end)

      keybind = configTab:Keybind({
        Title = "Toggle UI Key",
        Desc = "Keybind to open/close the menu",
        Value = rightShift.Name,
        Callback = function(value60)
          local v143 = typeof(value60) == "EnumItem"
          local v144

          if v143 and value60.EnumType == Enum.KeyCode then
            v144 = value60
          elseif typeof(value60) == "string" and value60 ~= "" and value60 ~= "None"
            and Enum.KeyCode[value60] then
            v144 = Enum.KeyCode[value60]
          end

          if v144 and v144 ~= Enum.KeyCode.Unknown then
            rightShift = v144
            suavleysGuiWindow:SetToggleKey(v144)
          end
        end,
      })

      v117 = "default"
      local v145 = f18()

      selectConfigDropdown = configTab:Dropdown({
        Title = "Select Config",
        Values = v145,
        Default = v145[1] or "default",
        Callback = function(value61) v117 = value61 end,
      })

      configTab:Input({
        Title = "New Config Name",
        Default = "default",
        Callback = function(value62)
          if value62 and value62 ~= "" then
            v117 = value62
          end
        end,
      })

      configTab:Button({
        Title = "Save Configuration",
        Callback = function()
          local v146 = {
            MAX_SPEED = maxSPEED,
            BOOST_POWER = boostPOWER,
            speedMult = speedMult,
            steeringMultiplier = steeringMultiplier,
            brakePower = brakePower,
            suspensionForce = suspensionForce,
            maybachSpeed = maybachSpeed,
            espOutlineTransparency = espOutlineTransparency,
            toggleKeybind = rightShift.Name,
            boostEnabled = v30,
            steeringEnabled = v62,
            brakesEnabled = v63,
            antiCrashEnabled = v56,
            glueOnFloorEnabled = v61,
            wheelieEnabled = v51,
            rainbowEnabled = v66,
            suspensionEnabled = v64,
            maybachEnabled = v65,
            playerEspEnabled = v67,
            mobileMaxSpeed = mobileMaxSpeed,
            mobileBoostEnabled = v42,
            mobileBrakesEnabled = v43,
            mobileSteeringEnabled = v45,
            mobileWheelieEnabled = v46,
            mobileBoostPower = mobileBoostPower,
            mobileBrakePower = v44,
            mobileSteeringMultiplier = mobileSteeringMultiplier,
            mobileFarmSpeed = v47,
            antiAfkEnabled = v71,
            scooterFlySpeed = scooterFlySpeed,
            mobileScooterFlySpeed = mobileScooterFlySpeed,
          }

          if writefile then
            pcall(writefile, "SuavleyGUI_" .. v117 .. ".json", httpService:JSONEncode(v146))

            v116:Notify({
              Title = "Config",
              Content = "Config '" .. v117 .. "' saved!",
              Duration = 2,
            })

            if selectConfigDropdown and selectConfigDropdown.Refresh then
              selectConfigDropdown:Refresh(f18())
            end
          end
        end,
      })

      configTab:Button({
        Title = "Load Configuration",
        Callback = function()
          local v147 = "SuavleyGUI_" .. v117 .. ".json"

          if isfile and isfile(v147) and readfile then
            local v148, v149 = pcall(function() return httpService:JSONDecode(readfile(v147)) end)

            if v148 and type(v149) == "table" then
              maxSPEED = v149.MAX_SPEED or maxSPEED
              boostPOWER = v149.BOOST_POWER or boostPOWER
              speedMult = v149.speedMult or speedMult
              steeringMultiplier = v149.steeringMultiplier or steeringMultiplier
              brakePower = v149.brakePower or brakePower
              suspensionForce = v149.suspensionForce or suspensionForce
              maybachSpeed = v149.maybachSpeed or maybachSpeed

              espOutlineTransparency = v149.espOutlineTransparency
                or v149.espOutlineTransparency

              mobileMaxSpeed = v149.mobileMaxSpeed or mobileMaxSpeed
              mobileBoostPower = v149.mobileBoostPower or mobileBoostPower
              v44 = math.clamp(v149.mobileBrakePower or v44, 0, 0.2)

              mobileSteeringMultiplier = v149.mobileSteeringMultiplier
                or mobileSteeringMultiplier

              v47 = math.clamp(v149.mobileFarmSpeed or v47, 0.2, 1.5)
              scooterFlySpeed = v149.scooterFlySpeed or scooterFlySpeed
              mobileScooterFlySpeed = v149.mobileScooterFlySpeed or mobileScooterFlySpeed

              if v149.toggleKeybind and Enum.KeyCode[v149.toggleKeybind] then
                rightShift = Enum.KeyCode[v149.toggleKeybind]
                suavleysGuiWindow:SetToggleKey(rightShift)

                pcall(function()
                  if keybind and keybind.Set then
                    keybind:Set(rightShift.Name)
                  end
                end)
              end

              if v149.boostEnabled ~= nil and boostToggle then
                boostToggle:Set(v149.boostEnabled)
              end

              if v149.steeringEnabled ~= nil and betterSteeringToggle then
                betterSteeringToggle:Set(v149.steeringEnabled)
              end

              if v149.brakesEnabled ~= nil and betterBrakesToggle then
                betterBrakesToggle:Set(v149.brakesEnabled)
              end

              if v149.antiCrashEnabled ~= nil then
                f3(v149.antiCrashEnabled)
              end

              if v149.glueOnFloorEnabled ~= nil and toggle3 then
                toggle3:Set(v149.glueOnFloorEnabled)
              end

              if v149.wheelieEnabled ~= nil and wheelieAssistToggle then
                wheelieAssistToggle:Set(v149.wheelieEnabled)
              end

              if v149.rainbowEnabled ~= nil and rainbowEScooterToggle then
                rainbowEScooterToggle:Set(v149.rainbowEnabled)
              end

              if v149.suspensionEnabled ~= nil and suspensionToggle then
                suspensionToggle:Set(v149.suspensionEnabled)
              end

              if v149.maybachEnabled ~= nil and maybachSuspensionToggle then
                maybachSuspensionToggle:Set(v149.maybachEnabled)
              end

              if v149.playerEspEnabled ~= nil and playerESPToggle then
                playerESPToggle:Set(v149.playerEspEnabled)
              end

              if v149.mobileBoostEnabled ~= nil and toggle4 then
                toggle4:Set(v149.mobileBoostEnabled)
              end

              if v149.mobileBrakesEnabled ~= nil and toggle5 then
                toggle5:Set(v149.mobileBrakesToggle)
              end

              if v149.mobileSteeringEnabled ~= nil and toggle6 then
                toggle6:Set(v149.mobileSteeringEnabled)
              end

              if v149.mobileWheelieEnabled ~= nil and toggle7 then
                toggle7:Set(v149.mobileWheelieEnabled)
              end

              if v149.antiAfkEnabled ~= nil then
                f4(v149.antiAfkEnabled)
              end

              f10()

              v116:Notify({
                Title = "Config",
                Content = "Config '" .. v117 .. "' loaded!",
                Duration = 2,
              })
            end
          end
        end,
      })

      configTab:Button({
        Title = "Delete Configuration",
        Callback = function()
          local v150 = "SuavleyGUI_" .. v117 .. ".json"

          if delfile and isfile and isfile(v150) then
            pcall(delfile, v150)

            v116:Notify({
              Title = "Config",
              Content = "Config '" .. v117 .. "' deleted!",
              Duration = 2,
            })

            if selectConfigDropdown and selectConfigDropdown.Refresh then
              selectConfigDropdown:Refresh(f18())
            end
          else
            v116:Notify({
              Title = "Error",
              Content = "Config not found or cannot be deleted!",
              Duration = 2,
            })
          end
        end,
      })

      return
    end
  end

  function f33()
    if v39 then
      v39.Force = Vector3.zero
      v39:Destroy()
      v39 = nil
    end

    if v40 then
      v40:Destroy()
      v40 = nil
    end

    v41 = nil
    maxSpeed = nil
  end

  function f34(p33)
    if v41 ~= p33 or not v39 or not v39.Parent then
      f33()
      v41 = p33

      local kukirinCleanAttachment = Instance.new("Attachment")
      kukirinCleanAttachment.Name = "KukirinCleanAttachment"
      kukirinCleanAttachment.Parent = p33

      v40 = kukirinCleanAttachment

      local kukirinCleanForce = Instance.new("VectorForce")
      kukirinCleanForce.Name = "KukirinCleanForce"
      kukirinCleanForce.Attachment0 = kukirinCleanAttachment
      kukirinCleanForce.ApplyAtCenterOfMass = true
      kukirinCleanForce.RelativeTo = Enum.ActuatorRelativeTo.World
      kukirinCleanForce.Force = Vector3.zero
      kukirinCleanForce.Parent = p33

      v39 = kukirinCleanForce
    end

    return v39
  end

  function f35(p34, p35, p36)
    if not p36 or not p35.Sit then
      return false
    end

    if p35.Health <= 0 or p35.PlatformStand then
      return false
    else
      local getState = p35:GetState()

      if getState == Enum.HumanoidStateType.Physics
        or getState == Enum.HumanoidStateType.Ragdoll
        or getState == Enum.HumanoidStateType.FallingDown
        or getState == Enum.HumanoidStateType.GettingUp
        or getState == Enum.HumanoidStateType.Dead then
        return false
      else
        for key6, value63 in pairs(p34:GetAttributes()) do
          local lower2 = key6:lower()

          if (lower2:find("ragdoll") or lower2:find("bail") or lower2:find("crash"))
            and value63 == true then
            return false
          end
        end

        local humanoidRootPart4 = p34:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart4 or (humanoidRootPart4.Position - p36.Position).Magnitude > 6.5 then
          return false
        end

        return true
      end
    end
  end

  raycastParams2 = RaycastParams.new()
  raycastParams2.FilterType = Enum.RaycastFilterType.Exclude
  raycastParams2.IgnoreWater = true

  function f36(p37)
    local rightVector = p37.RightVector
    local vector2 = Vector3.new(-rightVector.Z, 0, rightVector.X)

    if vector2.Magnitude > 0.01 then
      local lookVector2 = p37.LookVector
      local vector3 = Vector3.new(lookVector2.X, 0, lookVector2.Z)

      if vector3.Magnitude > 0.01 and vector2:Dot(vector3) < 0 then
        vector2 = -vector2
      end

      return vector2.Unit
    else
      local lookVector3 = p37.LookVector
      local vector4 = Vector3.new(lookVector3.X, 0, lookVector3.Z)
      return vector4.Magnitude > 0.01 and vector4.Unit or Vector3.new(0, 0, -1)
    end
  end

  runService.Heartbeat:Connect(function(delta3)
    v69 = v69 + delta3

    if v69 >= 0.5 then
      v69 = 0
      f31()
    end

    local character9 = localPlayer.Character

    if not character9 then
      f33()
    else
      local humanoid7 = character9:FindFirstChildOfClass("Humanoid")

      if not humanoid7 then
        f33()
      else
        local seatPart5 = humanoid7.SeatPart

        if not f35(character9, humanoid7, seatPart5) then
          f33()
        else
          raycastParams2.FilterDescendantsInstances = {
            character9, seatPart5:FindFirstAncestorOfClass("Model") or seatPart5,
          }

          local raycast = workspace:Raycast(
            seatPart5.Position, Vector3.new(0, -7.5, 0), raycastParams2
          )

          local assemblyLinearVelocity2 = seatPart5.AssemblyLinearVelocity
          local v151 = v37 or v38
          local v152 = v37 and scooterFlySpeed or mobileScooterFlySpeed

          if v151 then
            local currentCamera = workspace.CurrentCamera

            if currentCamera then
              local unit2 = currentCamera.CFrame.LookVector.Unit
              local unit3 = currentCamera.CFrame.RightVector.Unit
              local zero2 = Vector3.zero

              if v37 then
                if not userInputService:GetFocusedTextBox() then
                  if v31 then
                    zero2 = zero2 + unit2
                  end

                  if v32 then
                    zero2 = zero2 - unit2
                  end

                  if v33 then
                    zero2 = zero2 - unit3
                  end

                  if v34 then
                    zero2 = zero2 + unit3
                  end
                end
              elseif v38 then
                local v153, v154 = f12(humanoid7, seatPart5, seatPart5)

                if v153 ~= 0 then
                  zero2 = zero2 + unit2 * v153
                end

                if v154 ~= 0 then
                  zero2 = zero2 + unit3 * v154
                end
              end

              if zero2.Magnitude > 0.01 then
                seatPart5.AssemblyLinearVelocity = zero2.Unit * v152

                if unit2.Magnitude > 0.1 then
                  seatPart5.CFrame = CFrame.new(seatPart5.Position, seatPart5.Position + unit2)
                end
              else
                seatPart5.AssemblyLinearVelocity = Vector3.zero

                if raycast then
                  local v155 = { seatPart5.CFrame:ToOrientation() }

                  seatPart5.CFrame = CFrame.new(seatPart5.Position)
                    * CFrame.Angles(0, v155[2], 0)
                elseif unit2.Magnitude > 0.1 then
                  seatPart5.CFrame = CFrame.new(seatPart5.Position, seatPart5.Position + unit2)
                end
              end

              seatPart5.AssemblyAngularVelocity = Vector3.zero
            end
          elseif not raycast then
            if v39 then
              v39.Force = Vector3.zero
            end
          elseif not v30 or speedMult <= 1 then
            if v39 then
              v39.Force = Vector3.zero
            end
          else
            local throttleFloat2 = 0

            if not userInputService:GetFocusedTextBox() then
              if userInputService:IsKeyDown(Enum.KeyCode.W)
                or userInputService:IsKeyDown(Enum.KeyCode.Up) then
                throttleFloat2 = 1
              elseif userInputService:IsKeyDown(Enum.KeyCode.S)
                or userInputService:IsKeyDown(Enum.KeyCode.Down) then
                throttleFloat2 = -1
              end
            end

            if throttleFloat2 == 0 and seatPart5:IsA("VehicleSeat")
              and math.abs(seatPart5.ThrottleFloat) > 0.05 then
              throttleFloat2 = seatPart5.ThrottleFloat
            end

            local v156 = f36(seatPart5.CFrame)
            local dot = assemblyLinearVelocity2:Dot(v156)
            local v157 = math.max(seatPart5.AssemblyMass, 10)

            if throttleFloat2 <= 0 or dot < -0.5 then
              if v39 then
                v39.Force = Vector3.zero
              end
            else
              if not maxSpeed or maxSpeed < 5 then
                maxSpeed = 30

                if seatPart5:IsA("VehicleSeat") and seatPart5.MaxSpeed > 5 then
                  maxSpeed = seatPart5.MaxSpeed
                end
              end

              local v158 = maxSpeed * speedMult
              local v159 = 0

              if dot < v158 then
                v159 = v157 * (22 * speedMult)
                  * math.clamp((v158 - dot) / math.max(v158 * 0.4, 15), 0.2, 1) * throttleFloat2
              end

              local v160 = v156 * v159
              f34(seatPart5).Force = Vector3.new(v160.X, 0, v160.Z)
            end
          end
        end
      end
    end

    local v161, v162 = f26()
    local seatPart6 = v161 and v161.SeatPart
    local v163, v164 = f27()
    local v165 = 0
    local v166 = 0

    if seatPart6 and v164 then
      v166, v165 = f12(v161, seatPart6, v164)
    end

    local v167 = v33 and -1 or v34 and 1 or 0
    local v168 = v167 ~= 0 and v167 or v165

    if v62 then
      if seatPart6 and v164 and v168 ~= 0 then
        v164.AssemblyAngularVelocity = Vector3.new(
          v164.AssemblyAngularVelocity.X, -v168 * steeringMultiplier * 1.2,
          v164.AssemblyAngularVelocity.Z
        )
      end
    end

    if v45 and seatPart6 and v164 then
      if v168 ~= 0 then
        v164.AssemblyAngularVelocity = Vector3.new(
          v164.AssemblyAngularVelocity.X, -v168 * mobileSteeringMultiplier * 1.2,
          v164.AssemblyAngularVelocity.Z
        )
      end
    end

    if v63 then
      if seatPart6 and v164 then
        local v169 = v168 ~= 0

        if (v32 or v166 < -0.1) and not isStenewUserActive and not v169 then
          local assemblyLinearVelocity3 = v164.AssemblyLinearVelocity
          local magnitude2 = assemblyLinearVelocity3.Magnitude

          if magnitude2 > 0.5 then
            local v170 = math.max(0, magnitude2 - brakePower * 5)
            v164.AssemblyLinearVelocity = assemblyLinearVelocity3.Unit * v170
          end
        end
      end
    end

    if v43 and seatPart6 and v164 then
      if v166 < -0.05 then
        local assemblyLinearVelocity4 = v164.AssemblyLinearVelocity
        local v171 = v44 * 0.15

        v164.AssemblyLinearVelocity = Vector3.new(
          assemblyLinearVelocity4.X * (1 - v171), assemblyLinearVelocity4.Y,
          assemblyLinearVelocity4.Z * (1 - v171)
        )
      end
    end

    if v42 and seatPart6 and v164 then
      if v166 > 0.05 and f15() then
        local v172 = f36(seatPart6.CFrame)
        local assemblyLinearVelocity5 = v164.AssemblyLinearVelocity
        local vector5 = Vector3.new(assemblyLinearVelocity5.X, 0, assemblyLinearVelocity5.Z)
        local v173 = math.min(mobileMaxSpeed, vector5.Magnitude + mobileBoostPower * 1.5)

        v164.AssemblyLinearVelocity = Vector3.new(
          v172.X * v173, assemblyLinearVelocity5.Y, v172.Z * v173
        )

        if v168 == 0 then
          local vectorToObjectSpace2 = seatPart6.CFrame:VectorToObjectSpace(v164.AssemblyAngularVelocity)

          v164.AssemblyAngularVelocity = seatPart6.CFrame:VectorToWorldSpace(Vector3.new(vectorToObjectSpace2.X, 0, vectorToObjectSpace2.Z
            * 0.2))
        end
      end
    end

    if v64 and seatPart6 and v164 then
      if v164.AssemblyLinearVelocity.Y > 0 then
        v164.AssemblyLinearVelocity = Vector3.new(v164.AssemblyLinearVelocity.X, v164.AssemblyLinearVelocity.Y
          - suspensionForce * 0.2, v164.AssemblyLinearVelocity.Z)
      end
    end

    if v65 and maybachSpeed > 0 and seatPart6 and v164 then
      v164.AssemblyLinearVelocity = Vector3.new(v164.AssemblyLinearVelocity.X, math.sin(os.clock() * (maybachSpeed * 3))
        * (maybachSpeed / 10 * 12), v164.AssemblyLinearVelocity.Z)
    end

    if v66 then
      if v163 then
        local color13 = Color3.fromHSV(os.clock() * 0.4 % 1, 1, 1)

        for index17, value64 in ipairs(v163:GetDescendants()) do
          if value64:IsA("BasePart") then
            value64.Color = color13
          end
        end
      end
    end

    if v30 and v31 then
      if seatPart6 and v164 and f15() then
        local v174 = f36(seatPart6.CFrame)
        local assemblyLinearVelocity6 = v164.AssemblyLinearVelocity
        local vector6 = Vector3.new(assemblyLinearVelocity6.X, 0, assemblyLinearVelocity6.Z)
        local v175 = math.min(maxSPEED, vector6.Magnitude + boostPOWER * 0.5)

        v164.AssemblyLinearVelocity = Vector3.new(
          v174.X * v175, assemblyLinearVelocity6.Y, v174.Z * v175
        )

        if v168 == 0 then
          local vectorToObjectSpace3 = seatPart6.CFrame:VectorToObjectSpace(v164.AssemblyAngularVelocity)

          v164.AssemblyAngularVelocity = seatPart6.CFrame:VectorToWorldSpace(Vector3.new(vectorToObjectSpace3.X, 0, vectorToObjectSpace3.Z
            * 0.2))
        end
      end
    end
  end)

  return
end
