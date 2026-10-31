-- This file was generated at discord.gg/syncrypt

local Env = getfenv();
local F = {};
local v1 = {...};
local r1 = "SRNoG5IOC";
for o = 0, 2 do
    if o == 0 then
        if r1 ~= "SRNoG5IOC" then
            while true do end;
        end;
        r1 = true;
    else
        if o == 1 then
            if r1 == true then
            end;
        else
            if o == 2 then
                r1 = true;
            end;
        end;
    end; 
end;
local r17 = 2;
local r18 = math.floor;
local r19 = 0;
local r20 = {};
local v2 = {};
for e = 1, 256 do
    v2[e] = e; 
end;
repeat
    e = table.remove(v2, math.random(1, #v2));
    i = r20;
    i[e] = string.char(e - 1);
until #v2 == 0;
local r21 = {};
local function r22(...)
    if #r21 == 0 then
        r19 = (r19 * 213 + 27552854471197) % 35184372088832;
        repeat
            r17 = r17 * 201 % 257;
        until r17 ~= 1;
        v1 = r17 % 32;
        o = r18(r19 / 2 ^ (13 - (r17 - v1) / 32)) % 4294967296 / 2 ^ v1;
        W = r18(o % 1 * 4294967296) + r18(o);
        T = W % 65536;
        q = (W - T) / 65536;
        r21 = {
            T % 256,
            (T - T % 256) / 256,
            q % 256,
            (q - q % 256) / 256
        };
    end;
    v1 = #r21;
    o = r21;
    o[v1] = nil;
    return r21[v1]; 
end;
local r23 = {};
local r15 = setmetatable({}, {
    ["__index"] = r23,
    ["__metatable"] = nil
});
local function r16(arg1, arg2, ...)
    z = arg2;
    o = r23;
    v1 = arg1;
    if o[z] then
        return z;
    end;
    r21 = {};
    r19 = z % 35184372088832;
    r17 = z % 255 + 2;
    o[z] = "";
    S = 204;
    for f = 1, #v1 do
        L, M = nil, "" .. r20[(string.byte(v1, v2) + r22() + 204) % 256 + 1]; 
    end;
    o[z] = "";
    return z; 
end;
task[r15[r16("\xe1\xf3\xbb\\\xc8", 22126428612671)]](function(...)
    v1 = r15[r16("i\x13\x9d\x05\x14G\x07 \xc7\xdf\xc4\x11{f\xac돇\x1f-\xdd)\x8cd\xa8", 12834712622936)];
    if getgenv()[v1] then
        if getgenv()[r15[r16("\xc1\x11\x9c\xe7̷/\xcf챪,\xfc\x80z\x1ep\x1a\x83", 18063688655067)]] then
            getgenv()[r15[r16("\xbf\xc0\xa2\xa4\x9a\xb6\x8b\x0f\x06\x03\xdf~\xafSx\xfc\xfd@\x8d", 33503604964593)]]();
        end;
        task[r15[r16("J\xe2\x9e\x14", 32235748178594)]](0.5);
    end;
    getgenv();
    P[v1] = true;
    r24 = true;
    getgenv();
    P[r15[r16("}w\xe9\xf3\xddè\x19\x01\xd0\x12r\x1e9\xdfx\xc1\x98p", 22367117977775)]] = function(...)
        r24 = false; 
    end;
    I = game;
    r25 = I.GetService(I, r15[r16("\x98\xd6,\x8f\x8c\xa2 ", 25237642063336)]);
    I = game;
    r26 = I.GetService(I, r15[r16("`\xf9\xa1u#+g\xd7\xccp\x81", 4982196996368)]);
    I = game;
    r27 = I.GetService(I, r15[r16("C\x0bi\":צ\xd8\xcc\x10\x9f$\x84\x91\xc34\x1d", 21355818788568)]);
    I = game;
    I.GetService(I, r15[r16("\xdfV\x15\xa5d\x98\xc6F~\xbe", 573525377291)]);
    I = game;
    I.GetService(I, r15[r16("\x9d\x96\xfa\xbfZ\x1f\n", 8545818513291)]);
    r28 = r25[r15[r16("\x80H\x00!\x87\xc4\xc1\xef4o\xba", 4828406859976)]];
    I = game;
    r29 = I.GetService(I, r15[r16("\xbe\x01jh\xb0\xad\xe1(1\x8f\x1e", 28294454145911)]);
    I = game;
    r30 = I.GetService(I, r15[r16("\xcb;#\xaa%\xd2$\x95\x15;\xa5<\xc7hX", 5512655374855)]);
    v2 = _G[r15[r16("\xc1\xfc\x14\x99\xc6G\xd2\xdf'\xf0Y\xbe\x13\xe8\x10\xb4", 14106976754089)]] or nil;
    r31 = v2[r15[r16("匊M\x9dRz\xf9\xa8\xa1@", 4566595373134)]];
    r32 = v2[r15[r16("ZG\xb0\xf61\x8f", 3828369377014)]];
    r33 = v2[r15[r16("\xeax(\xc8\n\xdaz", 35146531930094)]];
    r34 = v2[r15[r16("\xde\xf2\x19\xc0\x04+\xd5", 7679232167415)]];
    r35 = v2[r15[r16("\xfd\xd4h^>\xbe{\xf4", 18047204221139)]];
    r36 = v2[r15[r16("\x0c \x81\x82\x91\xe7\xab ", 29523637089716)]];
    r37 = v2[r15[r16("<\xda\xe6\x15\xe8", 21555347826485)]];
    r38 = v2[r15[r16("N\x10\xe1ސ\xce\x16", 10415686587122)]];
    r39 = v2[r15[r16("\x1b\xe5\x0c\x8e\x951", 22431876212941)]];
    r40 = v2[r15[r16("%\x16n\xaa\xa7\x07", 18446715576717)]];
    r41 = v2[r15[r16("\x84\x14\x14\xae\xc3", 17366407470998)]];
    r42 = v2[r15[r16(".\xfe\x14e\xd5ؾ", 34226478399041)]];
    r43 = v2[r15[r16("\x89?0q\xecF", 10292019385016)]];
    r44 = v2[r15[r16("0\xe5S\xb9", 27139736252765)]];
    r45 = v2[r15[r16("_Y\xa4\xa8\x02\xe0+|bG\xbc", 18533191344566)]];
    r46 = v2[r15[r16("\xe4/Y)\x9fsR", 27088934891846)]];
    r47 = v2[r15[r16("932\xc7\x11m\xb1\x1d\x1d\xb0\x0f", 14081792760221)]];
    r48 = v2[r15[r16("VDŵ\x0b\xb2u\xed", 31367903967502)]];
    r49 = v2[r15[r16("\xd8;\xfa\xd4\x11\x903", 9968251441697)]];
    r50 = v2[r15[r16("\xa3\x80\xc4\x0c\x0e\x7f", 12401025635982)]];
    r51 = v2[r15[r16("\x9a\x198\xc6F-/\x01\x1f\x92\xf8h", 28419280057265)]];
    KY = v2[r15[r16("5\xaf\xcbE\n)\x9f`\x16\x1c\x9br\xf7n(", 32335369419473)]];
    r52 = v2[r15[r16("90\xf0\xa9\x8e\x04m1]\xf5\xda", 2454295594102)]];
    IY = v2[r15[r16("\xb5\x87\xc8\x0e\xb8\xb1\xd3", 33401477053633)]] or v2[r15[r16("m\x9f\xa6\xd9\x08O\x0c", 18506816119209)]];
    r53 = v2[r15[r16("l\xa2h\xf8Y\xf9\xe4w4,\xb9\x8e\x8d", 3027820971393)]];
    I = {
        [r15[r16("\xe3\xf2 \xbbr\t\xc3\x7f\x83", 6762923478093)]] = true,
        [r15[r16("\xe0˒h~Y\xc5", 23335222979186)]] = true
    };
    r54 = I;
    r55 = _G[r15[r16("\x0cA\xf4\x8d", 31322275133689)]] or getgenv;
    PY = I;
    FY = r55;
    if FY then
        UY = r55[r15[r16("\xf8\x9a\xcc\x0b\x85", 2257827628059)]]();
    end;
    I, P = PY, FY;
    if FY then
        r56 = UY;
        PY = r55;
        P, I = PY and r55[r15[r16("\xf2\x13\xddP\x8b", 16103948229962)]](r56), I;
        if PY then
            NH[9] = 10745588929419;
            r57 = {
                [r15[r16("I\x89\x8b", 8383730569023)]] = r15[r16("\x02\x91T$Q,c", 34151152451102)],
                [r15[r16("\xcd\x1a\xbb\xe9\xfa0\xa0\x85\x9a\x83\x91\xcc{R", 31743624559037)]] = r28[r15[r16("b\xb8\xa1a", 29939078395509)]],
                [r15[r16("\xe2\xdf\x10Ep~s\xf9\xdd\xfe\x93", 9382466949393)]] = r28[r15[r16("OXq\x14", 18991128666763)]],
                [r15[r16("i\xe3\x0b`!\xf9h", 13201421867011)]] = r15[r16("", 26748874420391)],
                [r15[r16("\"\x92\xff.}%W5\x8e", 18033234960589)]] = 10,
                [r15[r16("\xdc\r\xc2\xc0M", 23493441252027)]] = r15[r16("\x83\xd1y\xfb#\xfd.", 18704238584325)],
                [r15[r16("j\xf9\xfe\xb4\xef\xd3\xec\xa9", 1382054216323)]] = r15[r16("\xce", 15398004038658)],
                [r15[r16("\xe0˶\xdev\xa2\xbf>}", 32786031344547)]] = r15[r16("ZT\x80\xf4;\xa9\xa4", 32749958183826)],
                [r15[r16("V\x17\xb7ԇ\xa1:\x96\xb2\xcb\xd4\xe5", 25366255496740)]] = r15[r16("'9gN\xd9", 10002684875313)],
                [r15[r16("\xc7\xe8\xd0\xc1\xe3Gп\x9f\xcd", 25984866135876)]] = r15[r16("", 22517252810997)],
                [r15[r16("k\xd1\xdd5\xc2?", 12456980485800)]] = r15[r16("", 24201971100677)],
                [r15[r16("7\xbb\x15@\xe6\xb3b\xdf", 5839696824991)]] = r15[r16("\x12\x80", 15484801457194)],
                [r15[r16("\x88J\xf6E~\xf6\xa5v*\xef\xfc\xec\x8c2\xbb\xf0", 30964894578771)]] = r15[r16("\xc1", 29174919804177)],
                [r15[r16("\\W\x83\x16۫d\xf1\x19\xc1\xed\xde\xdcZ8\x11F", 11622704485668)]] = r28[r15[r16("\xccM\xf1\xac", 8056101326503)]]
            };
            r59 = false;
            r60 = false;
            r61 = false;
            r63 = false;
            r64 = false;
            r65 = 0;
            r67 = true;
            NH[4] = 11106229621811;
            r71 = false;
            r73 = true;
            r74 = {};
            pcall(function(...)
                z = getconnections(r27[r15[r16("]\xda&\x13\xd8]\xd6", 31432747448621)]][r15[r16("\xb0\x81E\x04\x18\xb2v\x1c\xe5\x84\x18", 12327202887276)]][r15[r16("\xb6\xbbUKe\x04\xc3v\x8e\x88\x81l\xda)\x1e", 24160049556466)]])[1][r15[r16("\xb3'\x99ݷ\tF\xed", 33652734901558)]];
                getupvalue(z, 1);
                I = next;
                for T, M in 1, getupvalue(getupvalue(z, 2), 1) do
                    P = r74;
                    p, S = I, T;
                    v2 = M.sub(M, 1, 2) == r15[r16("A\xb4", 20710933472684)] and M.sub(M, 3);
                    I = I;
                    if v2 then
                        I = I;
                        P[v2] = getupvalue(z, 1)[T];
                    else
                        L = M;
                    end; 
                end; 
            end);
            LY = game;
            LY = loadstring(LY.HttpGet(LY, r15[r16("\x07g\xe4mS\x8aP\r\xc3\xe0\xa1\xfb\x97O4R\xad\xaeK\xb9rI1\x96\x8b\xa0+\xea?,̣\x91E\x05\xff\xb2}fx\x86\xe0/", 23126829902353)] .. tostring(tick())))();
            NH[5] = 19541320606603;
            r75 = LY.Window(LY, {
                [r15[r16("\xd8U{\x96\xb0", 30211987355380)]] = r15[r16("\x98\xf2A(>\xa2o\xaeU", 15465639762977)],
                [r15[r16("\xf8\xb4\x87\xb4\xe3\xde\xe7\xa7R", 32509296851746)]] = true,
                [r15[r16("\xaf5٬\xa6\xdb\xde\xe9", 14018743933311)]] = r15[r16("\xc1%\xb8\xad\xfaS\xf40(\x8c9|\xa5\x9f\xa5\xdb?-\xd4k\x0c'VؒT\xceLO\x8e\xb31\x1d", 28667061646373)],
                [r15[r16("6\x90L\xa7", 24073799183306)]] = UDim2[r15[r16("\xa5\x98\x80\xcb\xd9\xc7\x14vZ\xfa", 32051978893901)]](868, 350),
                [r15[r16("\xa5k\x81\xb2\xe6\x8f7E\xe1", 16976130793185)]] = 1,
                [r15[r16("\x93\xfb\xa0\x07\x17\x0e-x\xe3\x1e\xe1\x97", 7593665662416)]] = true,
                [r15[r16("\xe7ciw|Z\xbc", 33434033110224)]] = Enum[r15[r16("\x97ו\xb6\x99I\x03", 32374134848227)]][r15[r16("V\xfa\xf9\xf8o\xed\xb1\xf9\xcf\xf2-\xb7", 5195324901747)]],
                [r15[r16("\xa9\x02\xed\xf4\xa0\x1bvi+\xe4\xfe", 30999619205219)]] = true
            });
            P = getgenv();
            P[r15[r16("\xe1\xf1\x18!?^\xdc\x11\xff\x04\x14", 22556018239751)]] = r75;
            P = getgenv();
            P[r15[r16("\xa5\x91$e\xaa\x04", 15198009793445)]] = r75;
            I = _G;
            I[r15[r16("\xe96\xf0\xaaDL\xeb\x0e\xb8\xd3N", 21800113235879)]] = r75;
            NH[1] = 3477532608083;
            I = _G;
            I[r15[r16("[m\x0c\xdb\xe6b", 9888898945532)]] = r75;
            I = r75;
            I.SetUserInfoState(I, true, r15[r16("s&\xad\x90$\xf3ݽCC\r\x94ީ\xf7\x1bu\x9d\x06\x9eX\x8bJ\xd8\xd1V\xdc", 27654990279245)] .. (PY and F[yY][r15[r16("\xf2\x13\xddP\x8b", 16103948229962)]](F[UY])) .. r15[r16("\xbfʄ9IA\x0f", 10817712231341)]);
            local function r76(arg1_2, arg2_2, arg3_2, ...)
                r77 = arg1_2;
                r78 = arg2_2;
                r79 = arg3_2;
                if r73 then
                    return;
                end;
                pcall(function(...)
                    I = r16;
                    p = I;
                    I.Notify(I, {
                        [F[k[3]][F[k[4]]("HM\x93\xeeA", 15728595786908)]] = r77,
                        [F[k[3]][F[k[4]]("\x03\x03B\x04\xcc{T\xc2@\xf6\xd1", 7955419631224)]] = r78,
                        [F[k[3]][F[k[4]]("0ͮI\x82", 6598234704896)]] = Color3[F[k[3]][F[k[4]]("\xeb\x16\xd2\xcb\x0c\xb65", 9719143485869)]](120, 180, 255),
                        [F[k[3]][F[k[4]]("\xc9\xca6^\xa8\xb1)\xa7", 19578124133276)]] = r79 or 5
                    }); 
                end); 
            end;
            local function r80(...)
                return true; 
            end;
            local function r81(arg1_3, arg2_3, arg3_3, ...)
                r82 = arg3_3;
                I = r75;
                I.Dialog(I, {
                    [r15[r16("\x86\x03\x05\xba\xaf", 34647868997382)]] = arg1_3,
                    [r15[r16("s3X\xf2l\x1a;\xb1Q\x05\xc6", 32897528167383)]] = arg2_3,
                    [r15[r16("/\xa3S\xfc\x18\xfbX", 24081768147917)]] = {
                        {
                            [r15[r16("\x07\xbf>\x01", 13482240825478)]] = r15[r16("\xde\xef\x01?\xf5QF", 26380217708540)],
                            [r15[r16("\xf6\x06\xaf\x0e\x19", 12971195226008)]] = Color3[r15[r16("?K1\x95y\x8e\x9b", 10349847630547)]](46, 204, 113),
                            [r15[r16("\x9e\x1a\x1f\xe4m\x9f\xceW", 8171976396509)]] = function(...)
                                if r82 then
                                    r82();
                                end; 
                            end
                        },
                        {
                            [r15[r16("\xa5|\xabW", 20564860888424)]] = r15[r16("9\x9av\x96=\x84", 8599508635556)],
                            [r15[r16("G\xb1\x068\xe5", 5361739139520)]] = Color3[r15[r16("\x89\xb9\xe0\xc39\xcc\xfd", 25760185806555)]](255, 80, 80)
                        }
                    }
                }); 
            end;
            wY = r75;
            hY = r75;
            JY = r75;
            xY = r75;
            EY = r75;
            uY = r75;
            wY = {
                [r15[r16("\xa4U.\\\xbe\xd5^\xf9qTH\x83", 4414755735559)]] = wY.GlobalSetting(wY, {
                    [r15[r16("\xafo\x99^", 27917757379272)]] = r15[r16(":!dDQ\x13\xaa", 5773823494784)],
                    [r15[r16("\xa9\x10z\x1eЫ\x96", 26214868987823)]] = hY.GetAcrylicBlurState(hY),
                    [r15[r16("\x99\xb9\x85`L\t\x83\xd2", 2622284235973)]] = function(arg1_4, ...)
                        I = r75;
                        v1 = arg1_4;
                        I.SetAcrylicBlurState(I, v1);
                        I = r75;
                        if v1 then
                            L = r15[r16("\xbe4\xa7\xeb\x9c\xe8\x8f", 8446443835229)];
                        end;
                        I = I;
                        I.Notify(I, {
                            [r15[r16("e\x82\x9c9a", 33428813774030)]] = r75[r15[r16("\xe49|\x06<\xf4\xdbM", 1848209113948)]][r15[r16("\x84\x95\x88\xbd\xb3", 18350880022881)]],
                            [r15[r16("\r\x0bt\xd4\xd4\x0c\xc4\x06\xcf\xf6b", 6199861300039)]] = (v1 or r15[r16("oJ\xa3\xd1B\x92v\x1f", 28070023508751)]) .. r15[r16("\x1f\xfcH\xfa\xbf\xf9sQ", 25777985433315)],
                            [r15[r16("f\x01a\xcb\xf3\xec\\\xc0", 23100779866629)]] = 5
                        }); 
                    end
                }),
                [r15[r16("\xf0\x1cw\n\xdd\xf5\x9db}\xfd6\xf6\xfa\x1du\xf8\xdb\xf2\x85", 34037542354409)]] = JY.GlobalSetting(JY, {
                    [r15[r16("\xa5\xc1\xad\x12", 22498940365036)]] = r15[r16("\x8bO\x9f_\x96;\x11ï\x114\xe4\xcb", 26730793365663)],
                    [r15[r16("\xc0\x11*\nX\x85\xd0", 3289051891195)]] = xY.GetNotificationsState(xY),
                    [r15[r16("\x91n\xc5\x172\xe8\x03\x01", 4746456647842)]] = function(arg1_5, ...)
                        v1 = arg1_5;
                        I = r75;
                        I.SetNotificationsState(I, v1);
                        I = r75;
                        M = I;
                        S, I = v1 and r15[r16("m8d\xe0\xceh\xee", 16234789625223)], I;
                        if v1 then
                            I, v1 = 5, nil;
                            I.Notify(I, {
                                [r15[r16("\x95H7G\xc2", 18303264661835)]] = r75[r15[r16("7FI&\xd1L\xde\xd3", 2752548783361)]][r15[r16("\xfe\x8b M\xa7", 2459612710009)]],
                                [r15[r16("y\xe2\xaf,6\xa5y\xf4ܯ{", 7200660704537)]] = (L and r15[r16("m8d\xe0\xceh\xee", 16234789625223)]) .. r15[r16("\xbb\x1f\xa4\x94\xde{\n\xa4\x01[\xba@\xe7\xc6", 20171855946929)],
                                [r15[r16("2p\xe4\xdf\x00\xd3\xdd\n", 26584637255771)]] = 5
                            });
                            return;
                        else
                            S = r15[r16("\xa2\x19\x1c3f]\xcdp", 28839830418549)];
                        end; 
                    end
                }),
                [r15[r16("XOd\xb3\x0bCȕ\x03S\xff\xc5", 1827434726226)]] = EY.GlobalSetting(EY, {
                    [r15[r16("e\x8ei\xfd", 5552344730137)]] = r15[r16("\xff\xf6\x95A\x1br\xb8\x88\xb8\xcfGzW\x02", 35184145891327)],
                    [r15[r16("\xb5\xce\xff\"\xd5\xf2\xd5", 7189173865747)]] = uY.GetUserInfoState(uY),
                    [r15[r16("F\xb5\xf9\x01\xdc\xeb\xb5M", 31312530536693)]] = function(arg1_6, ...)
                        v1 = arg1_6;
                        I = r75;
                        I.SetUserInfoState(I, v1);
                        I = r75;
                        M = I;
                        if v1 then
                            L = r15[r16("Ĭ{\x97", 2544843392161)];
                        end;
                        I, S = I, v1;
                        if v1 then
                            I.Notify(I, {
                                [r15[r16("\t\x13\xafh\xad", 4414529538055)]] = r75[r15[r16("\xe6f\xfd\xf2\x18\xb3\xc5\xd3", 35106931261403)]][r15[r16("I\x16\xa6\xe0\xe1", 1901981926261)]],
                                [r15[r16("9\xe7l;9\x98\x1f+γ\xfd", 30629398525878)]] = S .. r15[r16("o\x9f\xe8\xf6\xc4R\x8c\xe9z\x96", 32477607639827)],
                                [r15[r16("\xec\x03\xdd\x18k6\xbd\x13", 20895723415042)]] = 5
                            });
                            return;
                        else
                            S = r15[r16("\xef\xec\xf2\xa0\xf2\xb8\x8d\xd5", 146423595076)];
                        end; 
                    end
                })
            };
            lY = r75;
            RY = r75;
            lY = {
                [r15[r16("\xe3\x95n\x94", 6346284911499)]] = lY.TabGroup(lY),
                [r15[r16("\xf2Rg\xfd\x8f\x87\x88?Z\x07FC`", 5739679369840)]] = RY.TabGroup(RY)
            };
            JY = lY[r15[r16("\x86$܂", 32124270344815)]];
            EY = lY[r15[r16("O\xbf)\xdf", 24185295268862)]];
            hY = lY[r15[r16("\xa96\xecO", 20300366308589)]];
            NH[6] = 512965050606;
            xY = lY[r15[r16("g\xa5,\x9f", 29316974900563)]];
            uY = lY[r15[r16("\xe9\xc6\x1c5", 31784377448912)]];
            ZY = lY[r15[r16("\x9fС>", 31277103593700)]];
            NH[2] = 5969011165915;
            gY = lY[r15[r16("\xb7+\x0f{Z5\xbe\xf3J\xffe\x02\x96", 24650873531606)]];
            rH = lY[r15[r16("\xdf'\xb9\x8bp\xa9\x90D\xcc\xd8܊D", 7869210463824)]];
            JY = {
                [r15[r16("Bs\x88/", 13781374818577)]] = JY.Tab(JY, {
                    [r15[r16("O1\xb8\xca", 28840459252853)]] = r15[r16("\xb8\xe9s\xd0", 12634545067771)],
                    [r15[r16("\xbdE+\x1a\xb7", 19438838604635)]] = r15[r16("2A\xfd\x01IU\xe4L\xf7\x90\x97\xeb\x003\xb0\x15\xe9͈#k\x9b\x02\x06\x89\x92\xd7", 20386880513301)]
                }),
                [r15[r16("\xa4\xe9\xfdd", 15923596958967)]] = EY.Tab(EY, {
                    [r15[r16("\xe5w\xff\xcc", 3505773069920)]] = r15[r16("\xc3\xf0u\xb5", 18676145758712)],
                    [r15[r16("gd\x9cB\x84", 26644907978871)]] = r15[r16(":\\\x8c\xc2\xd9\xce\xfc\xb39\xa6NrN\xda[Ez\xe3\xc7k\xe4s\xb2\x90", 10706433774457)]
                }),
                [r15[r16("\x90R\x92\x9f\x9a\xa9i", 34910935383936)]] = hY.Tab(hY, {
                    [r15[r16("\x858\x8dK", 30878289721386)]] = r15[r16("\x80\xe1\xc1p\xb1\xcf3", 26311200534492)],
                    [r15[r16("U\x92\xf9\xad\xda", 22127801034816)]] = r15[r16("\x9dH\x1d\x04\xffFukQ\xf6\xa0ޅ\x0fЕ\x97b\x0e\x9cȖY\xee", 1246262362692)]
                }),
                [r15[r16("'\xd7\xf6\x9fA{\\\xe0`\x04*\x1f", 26310974320604)]] = xY.Tab(xY, {
                    [r15[r16("\x94xI\x91", 32558792899385)]] = r15[r16("e\xc4\xca\x1a\xe3", 30725503858659)],
                    [r15[r16("\x85pW\xa0\xc4", 29239534056751)]] = r15[r16(".{\x1dÞ\x1bc\x93I\x8c\xe2b\xdaHwj\x9f\x92(o\\d#]", 34460774842031)]
                }),
                [r15[r16(">\x1d\x9d@\x01", 26170530279322)]] = uY.Tab(uY, {
                    [r15[r16("0\xc4\x1f\x98", 34607198437107)]] = r15[r16("\xec'\xdf\xfdd\x07k-\xd4\xf1", 23463765830318)],
                    [r15[r16("\xff\xf2\x0fU\x17", 17495728758739)]] = r15[r16("C[y\xa1\xa1\x07\x06^\x04\xddG\\\x00\xff\xcf\x01\x8f\xae!B}\x88\xab9\x9d\xf8˦", 5769111243390)]
                }),
                [r15[r16("<\x89\xaf\x1e", 29203445200158)]] = ZY.Tab(ZY, {
                    [r15[r16("\x00&\x9e\xf6", 2709009499373)]] = r15[r16("\xfc\xe1\xe8_ù+m\x0f\x80\xd9#\xd3", 22859532347796)],
                    [r15[r16("\x06\xda\x1d\x10U", 8727276556255)]] = r15[r16("\x97T<\x8anQ\x90EE\x91:\x0b\x81\x10\xdd\xd01F勔\xe2w\xbf,\xaa\xec\xb4", 22147848104009)]
                }),
                [r15[r16("թج\xd8a", 8062040755882)]] = gY.Tab(gY, {
                    [r15[r16("\x99gN\xd0", 11148771267655)]] = r15[r16("\xbd\x07\t\x07\xe9]", 11567813825802)],
                    [r15[r16("1\x01.+\x8c", 8142647185103)]] = r15[r16("\xa1\xf7\xf4T\x12w+\x90/\xca\xdb\x0f\x90\x05\xe7;\xb7\x7f*\x1a<\"(K", 2609307157695)]
                }),
                [r15[r16("\xf5\x19G\xd87\xfc\x99\x1f", 22274247616644)]] = rH.Tab(rH, {
                    [r15[r16("\xec\x9e\xf1\x89", 22909673466284)]] = r15[r16("\x95\x8b\xb9\xafK|\xe3\x1d\xd0\x16l\xbc\xdd\xe2\xc9\x18\xaf\xd1", 17968165232815)],
                    [r15[r16("\xcb\xdd֥\x80", 34180410998316)]] = r15[r16("\xe5yɐ\xcc\r\xeaD\xc6\xc9\x19\x11\x8e\\[\xd4:B\xc9<\x98\xfb\x89.", 9853102395884)]
                })
            };
            NH[3] = 14115535608237;
            local function r83(...)
                return {
                    [r15[r16("\xe3W\xe9\xe5\x12.\xef", 19214427595507)]] = r44,
                    [r15[r16("\xea\"m\xf1\x03-9\xe1\xbc\xc3AQ\xfe:Pֳ", 25307013213704)]] = r31,
                    [r15[r16("\xc6\xd1-I\t>\x08\xe4\x04\x89\xe8\xbf\x13J\x93\xee@L\"", 3985705191231)]] = r41,
                    [r15[r16("6\x10A>ԙy\xec-Ld\xc1\x1bY@w\x9c\x82\xe2", 16588848406060)]] = r32,
                    [r15[r16("\xdd\xc4:\x02\xdeV}\x1fA\xb4V`c\xd3\xc4/\x90", 20848144983532)]] = r34,
                    [r15[r16("G\xed.4R\xf7\x11dk\xf3M\xf1\xf0", 33225239264367)]] = r42,
                    [r15[r16(">\x8d&\xb9L\xfe\x17\xcdL\x0cʍ", 15865251142875)]] = r43,
                    [r15[r16("k\xe4\xc0\x81Ȧv_(=l\xc7[Z-rv\xcc", 11834303157638)]] = r33,
                    [r15[r16("q\xdaз\x00\x07l\x08\x19:\xc0\x1b,\xe4\x83I\xa6N", 29825244608064)]] = r35,
                    [r15[r16("\xd8\x7f\xba<\xb4\xfd:}.\x9c\xa9\\y", 15288077474767)]] = r36,
                    [r15[r16("\x03\xc8>ַ&Õ\x9b", 113696882740)]] = r37,
                    [r15[r16("\xd7g\xc9fw\xe3G\x9e\x82\x15S\x80Ӽ\xfbF]o", 12136601277971)]] = r38,
                    [r15[r16("\xa8`\r\xec\xf2\xc0\xd2\x0c\xe6o>r.VK\xfb", 21057188734541)]] = r39,
                    [r15[r16("\x01\x89\xc0\xb2u\x90$(\xc5O\xdd\x05՛m\x9f", 29317142099283)]] = r40
                }; 
            end;
            local function r84(arg1_7, ...)
                v1 = arg1_7;
                I = type(v1) ~= r15[r16("C\xc4jM\x14\xc3", 8229332766456)];
                if I then
                    return 0;
                end;
                return (tonumber(v1.match(v1, r15[r16("{.\xf7\xf4\xb4\xf0", 23766198233915)])) or 0) * 60 + (tonumber(v1.match(v1, r15[r16("\x1d\xb3\xc9}6-", 16992302341864)])) or 0); 
            end;
            local function r85(arg1_8, arg2_8, ...)
                o = arg1_8;
                q = "ipairs";
                for T, M in ipairs(arg2_8) do
                    S = T;
                    if not o then
                        return nil;
                    else
                        v1.FindFirstChild(v1, M);
                    end; 
                end;
                return o; 
            end;
            local function r86(arg1_9, ...)
                r87 = arg1_9;
                pcall(function(...)
                    o = "ipairs";
                    for z, T in ipairs(getconnections(r87[r15[r16("\x9f\x08)^\xca", 16956609322712)]])) do
                        W = z;
                        T.Disable(T); 
                    end; 
                end); 
            end;
            local function r88(...)
                r86(r28);
                I = r68;
                if I then
                    I = r68;
                    I.Disconnect(I);
                end;
                I = r28[r15[r16("\x83\xeak\xe3\xbd", 10729674232708)]];
                r68 = I.Connect(I, function(...)
                    I = r29;
                    I.CaptureController(I);
                    I = r29;
                    I.ClickButton2(I, Vector2[r15[r16("F\xb5D", 25054343114130)]]()); 
                end);
                r67 = true; 
            end;
            local function r89(...)
                if r68 then
                    I = r68;
                    I.Disconnect(I);
                end;
                r67 = false; 
            end;
            NH[8] = 13446311073909;
            local function r90(...)
                v1 = {};
                W = r25;
                W = "ipairs";
                for o, q in ipairs(W.GetPlayers(W)) do
                    T = o;
                    table[r15[r16(";\x00\xdar n", 6423110749102)]](v1, q[r15[r16("\x17\xcfѾ", 21878445516747)]]); 
                end;
                return v1; 
            end;
            I = JY[r15[r16(":3\x15\x9a", 1437784834717)]];
            uY = I.Section(I, {
                [r15[r16("Ϸ\xbf<", 14565757934206)]] = r15[r16("\x05\xb3\x00,", 24487752674443)]
            });
            uY.Header(uY, {
                [r15[r16("\xa7\x1b/X", 23712032451361)]] = r15[r16("N6Jrw!\xf0\xa4\rm\x1e\xc3n\x1a=\xd0I)", 22434968398031)]
            });
            local function r91(...)
                P = game;
                v1 = P.GetService(P, r15[r16("\x0c\x1b\xfb\xaf\xa9<\xb0", 12213054035511)])[r15[r16("ml\x93E\xaf\xbdG\xe0\xc8\xc0\xf1", 6495825595344)]];
                I = game;
                P = I.GetService(I, r15[r16("͌\x17\x9c\xc6lhqN\x931\xdc\x02\x9fR3\xd1", 21431007291131)]);
                z = P.FindFirstChild(P, r15[r16("\xfa-\x8b3\xff", 22066156431395)]);
                if z then
                    P = v1;
                end;
                if z then
                    o = z.FindFirstChild(z, v1[r15[r16("%MWE", 25710253190852)]]);
                    if o then
                        W = o.FindFirstChild(o, r15[r16("\xb1\x89\xe3\xf8\x19qzr", 11553648416004)]);
                        if W then
                            M = W.FindFirstChild(W, r15[r16("\x1c\x82\xf8\x9d\x93[", 32401793399536)]);
                            if M then
                                o.FindFirstChild(o, P);
                                q = math[r15[r16("\xbaLҞ\xdd", 24092728781779)]](tonumber(I[r15[r16("\xe2ۋ\x9c\r\xfe", 22979980634572)]][r15[r16("h\xe2\xc1{\xbb", 9051724451959)]]) or 0);
                            end;
                            I = o.FindFirstChild(o, P);
                            L = I;
                            p = W.FindFirstChild(W, r15[r16("M\xea:", 18733601301011)]);
                            S = I;
                            if p then
                                e = o.FindFirstChild(o, P);
                                M = math[r15[r16("'\x80\xfe\xba?", 3083686020507)]](tonumber(W[r15[r16("m\xed\x8d", 9165421351083)]][r15[r16("\xb04\x9e\xbb\x97", 30870202578983)]]) or 0);
                            end;
                            M = v2;
                            v2 = W.FindFirstChild(W, r15[r16("^r\x07_\x86\xc7", 24140874755049)]);
                            if v2 then
                                i = L;
                                L = math[r15[r16("a\xcc4\x04\xb4", 3298191345151)]](tonumber(W[r15[r16("Ul3\x10\xf2\xec", 3915163240223)]][r15[r16("_\xf0Y\x04\xe8", 12722700883748)]]) or 0);
                            end;
                            b = W.FindFirstChild(W, r15[r16("\x98\".\xe9\xde\x7f\x1a", 20290493687016)]);
                            if b then
                                w = L;
                                p = math[r15[r16("\x0e\x98\xcf\x08\xa8", 20871772562935)]](tonumber(W[r15[r16("\xde\t۲\x1b\x9c\x8e", 23452375116456)]][r15[r16("\xdfq\x81\x17\xde", 10160464695931)]]) or 0);
                            end;
                            I = b or 0;
                            L = b or 0;
                            return W[r15[r16("\xab(\xd2\xef&", 26051861622627)]] or r15[r16("", 7114729491697)], M or 0, p or 0, v2 or 0, L;
                        end;
                    end;
                end;
                return 0, 0, 0, 0, 0; 
            end;
            r92 = uY.Label(uY, {
                [r15[r16("\x7f7\xbb\xe6", 27294883328422)]] = r15[r16("\x06\xb3*\xe9\xe1\x84\xd2\xc1\t\x1c@)\xb2\x97hz]@\xe7\x9ff", 10146448527988)] .. r91()
            });
            r93 = uY.Label(uY, {
                [r15[r16("I+\xc8\xf4", 11598249547032)]] = r15[r16("\t\xb8\xd1ڍ\xd0^*", 6676269157412)] .. rH[2] .. r15[r16("\x85", 34634201202431)]
            });
            r94 = uY.Label(uY, {
                [r15[r16("e\x9e\xb0g", 125909893178)]] = r15[r16("m\xe9\xf9W\xf8", 29111237571827)] .. rH[3] .. r15[r16("\xbd", 11662883132726)]
            });
            r95 = uY.Label(uY, {
                [r15[r16("\xca^\xec\xb1", 6621735488523)]] = r15[r16("\xa6\xaai\xc5\x07\xe1\x84\xe3", 15357872757743)] .. rH[4] .. r15[r16("\xde", 33729039564122)]
            });
            r96 = uY.Label(uY, {
                [r15[r16("\xa06\x96\xf9", 32331988695759)]] = r15[r16("oڋ\xa0\xb4\x97\xa3\x93\\", 26911521173747)] .. rH[5] .. r15[r16("/", 24596529097917)]
            });
            task[r15[r16("\x0fR0\xa2\xa3", 4262346082240)]](function(...)
                while task[r15[r16("\xab\xa6/`", 24128942468067)]](15) do
                    pcall(function(...)
                        I = r92;
                        I.UpdateName(I, r15[r16("\xd0+g\x81\xc9\xf9Z)\xbf#[k3\xeb\xfa\xfe\xf0\xb8\x87fD", 13504885774480)] .. r91());
                        I = r93;
                        I.UpdateName(I, r15[r16(">>a=\xf6\xf8\xd0X", 27242326733197)] .. T[2] .. r15[r16("\x8b", 33180666936410)]);
                        I = r94;
                        I.UpdateName(I, r15[r16("31\x89\xc1&", 32238487075492)] .. T[3] .. r15[r16("\xe4", 30326012753705)]);
                        I = r95;
                        I.UpdateName(I, r15[r16("`\xc6w\x07\x15\x94\xce\x01", 7161716182278)] .. T[4] .. r15[r16("-", 27924317549259)]);
                        I = r96;
                        I.UpdateName(I, r15[r16("\xf5\xa3N\x7f\rC\xa1W\x1d", 19282515403539)] .. T[5] .. r15[r16("\xa8", 10459907527430)]); 
                    end); 
                end; 
            end);
            I = JY[r15[r16("\xf9\xd5-\xcb", 31839480789482)]];
            r97 = I.Section(I, {
                [r15[r16("~\x9a\xed\xca", 32005216287287)]] = r15[r16("\x9e!\xcb\xe6\xc3", 30750401214447)]
            });
            I = r97;
            NH[7] = 13377614551125;
            I.Header(I, {
                [r15[r16(",\x15\xab~", 17526881263585)]] = r15[r16("PYE\x97(S9\xa6\xf0\x8cK\xc66\xc5\xd9", 20273219298528)]
            });
            task[r15[r16("\xfc0\xdam\x94", 5726493821546)]](function(...)
                pcall(function(...)
                    P = game;
                    I = P.GetService(P, r15[r16("^\x81u\x08-m\xd9", 9637392486791)])[r15[r16("n+\x0c\xe0\xe5̎![\xf2X", 30419667842901)]];
                    v1 = I.FindFirstChild(I, r15[r16("\xa2\xe1\xcbً\xb9Z\xf8\xb4", 17324743368579)]);
                    if not v1 then
                        return;
                    end;
                    W = r15;
                    z = v1.FindFirstChild(v1, W[r16("\xe9\x96|l*\x87\"\xca\x01", 16313661644204)]) and W.FindFirstChild(W, r15[r16("\xcdg~\xfcX\xaf", 17450653261758)]);
                    o = false;
                    if z then
                        S = {
                            z.GetChildren(z)
                        };
                        for q, L in ipairs(K(P)) do
                            M = q;
                            if L.IsA(L, r15[r16("\n\xf9p\xc1\xf5\xa2\x0e\xaae", 10332878443211)]) and string[r15[r16("\xe3\xa1kL\xff", 4034515027798)]](L[r15[r16("\xf6\x88\xaa\x8b", 30453298968420)]], r15[r16("m\x90!\xc0۩7k\xf3r\xb7\xadN", 25368135970340)]) == nil then
                                p = L.FindFirstChild(L, r15[r16("\xa9\xf3ښ\xa2\xcb", 24907337002318)]);
                                if p then
                                    v2 = p.FindFirstChild(p, r15[r16("\xb8\x84\x96awQ\xc7|m\xb1", 7419783105919)]);
                                    b = p.FindFirstChild(p, r15[r16("\x1b\x14H\x83\x91\x16:*\xaa", 16673662033492)]);
                                    e = p.FindFirstChild(p, r15[r16("\xf4\x04\xf1\xe5\x11\xf7=5\x15", 30440857679711)]);
                                    if v2 then
                                        if b then
                                            if I then
                                                J = p.FindFirstChild(p, r15[r16("\xb8\x84\x96awQ\xc7|m\xb1", 7419783105919)])[r15[r16("\x1bV\xbe\x90", 3304499004930)]] ~= r15[r16("", 3502931330655)];
                                            end;
                                            p.FindFirstChild(p, r15[l]);
                                            w = I;
                                        end;
                                        I, i = p.FindFirstChild(p, r15[l]), b;
                                    end;
                                    if v2 then
                                        i = v2[r15[r16("\xe1\x0c<r", 13471952967809)]];
                                        w = r15[r16("9\x12\xbc", 10617345250128)] .. b[r15[r16("o\x8f\xb4\x02", 23120351390222)]] .. r15[r16("\xa4iZ", 28467510391752)] .. e[r15[r16("*95\xff", 4633857263725)]];
                                        l = i .. r15[r16("\x19", 1812286702411)] .. w;
                                        J = ({})[l];
                                        if not J then
                                            W[l] = true;
                                            J = r97;
                                            o = true;
                                            J.Paragraph(J, {
                                                [r15[r16("\xb3\xee}`y\xbc", 1879629923179)]] = i,
                                                [r15[r16("ĝ\x08t", 16104436276555)]] = w
                                            });
                                        end;
                                    end;
                                end;
                            end; 
                        end;
                    end;
                    W = not o;
                    if W then
                        W = r97;
                        W.Paragraph(W, {
                            [r15[r16("atA\x91L2", 27474362724857)]] = r15[r16("\x84\x7f\xe9\xfcE($9Q\xda", 24350275054666)],
                            [r15[r16("\x88\x81\xef\xe3", 15571203988562)]] = r15[r16("\xe9Qͷ[\x9c\xd4\xea4N7\x8fk:\r\xf9\xb5O\xa6\x86\xc8\xff<\x15\x0bE\x86\xa0\xabU\xbd)", 4190855628703)]
                        });
                    end; 
                end); 
            end);
            I = JY[r15[r16("|Ś\xe9", 20745997346236)]];
            yH = I.Section(I, {
                [r15[r16("j)\xf7\xde", 20358903768328)]] = r15[r16("\xa6\xac\xebg", 18644171301353)]
            });
            yH.Header(yH, {
                [r15[r16("\xc2\x8a\x87\n", 20936293721621)]] = r15[r16("\x19m\xbc\xdcr\x04wX", 12733816805161)]
            });
            r98 = 0;
            pcall(function(...)
                I = game;
                P = I.GetService(I, r15[r16("\xbeD\xb0*\xf7^\x12\x9cl\xcdF\"\x874\x0c\x00\xf2", 10706092626809)]);
                I = P.FindFirstChild(P, r15[r16("VH\x9e\x8a\x1b", 31269172164832)]);
                if I then
                    P = I.FindFirstChild(I, r28[r15[r16("&\xc85\xbe", 16768331832960)]]);
                end;
                if I then
                    I = I[r28[r15[r16("\x0c^\xad\xd5", 5975019490014)]]];
                    z = I.FindFirstChild(I, r15[r16("\xe2\xd9\r\xe2\xc3", 21452936046341)]);
                    if z then
                        r98 = z[r15[r16("ye\ns\xa7", 18498082136485)]];
                    end;
                end; 
            end);
            r99 = yH.Label(yH, {
                [r15[r16("\xaa>\xc04", 21776500877212)]] = r15[r16("\xeb\xe4\x1a\x1fB0\xfa\x94\x93\x02\xd10\x98ƙ\x95(ٵGF\x07C", 20976789890600)]
            });
            r100 = yH.Label(yH, {
                [r15[r16("\xd9`?\x85", 8221047033588)]] = r15[r16("~\x00\xf8\xafD\xec8\x0e\x01N\xa8F\x08\xcc", 29196283983131)]
            });
            r101 = yH.Label(yH, {
                [r15[r16("#p\x17\x81", 2466079818876)]] = r15[r16("\\\x93\xcfA\x14ᠠ\xf0C\xba\xbc\x9b\xe8z\xa9\xb7", NH[1])]
            });
            NH[1] = 32500783004446;
            NH[1] = "\x97樼vp\xb2_Xu\xa2\x8f\xfff\x1e+\x15\xf0x\xebʅ\xdfz\xa4\xb05\xacE\xec\xb4\xf1\x91\xed\xae";
            NH[2] = 16949485575892;
            r102 = yH.Label(yH, {
                [r15[r16("l\xa6p\xcc", NH[1])]] = r15[r16(NH[1], NH[2])]
            });
            NH[1] = "\x84l9\x0b\xf0";
            task[r15[r16(NH[1], NH[2])]](function(...)
                while task[r15[r16("P\x9b \x06", 7933756149358)]](20) do
                    if not r24 then
                        break;
                    else
                        pcall(function(...)
                            I = game;
                            P = I.GetService(I, r15[r16("\xf8ˀ=F\xe0ʂ±\xa4\xf2\xf1ü\xae\x81", 29089362556137)]);
                            v1 = P.FindFirstChild(P, r15[r16("\xe9\x0eA\x9e\x83", 10232623878812)]);
                            if v1 then
                                P = v1.FindFirstChild(v1, r28[r15[r16("m\xaeOy", 12567613429468)]]);
                            end;
                            if v1 then
                                z = v1[r28[r15[r16("+\xa7@\x90", 30901649258549)]]];
                                o = z.FindFirstChild(z, r15[r16("\x99\x12\xdd", 12112253801992)]);
                                if o then
                                    I = z.FindFirstChild(z, P);
                                    q = I;
                                    I = I;
                                    S = z.FindFirstChild(z, r15[r16("\xc6v\xf6\x0e\x0b", 7776075714085)]);
                                    M = 0;
                                    if S then
                                        if S[r15[r16("%T3z\x9f", 6967230057644)]] - r98 < 0 then
                                            M = 0;
                                        end;
                                    end;
                                    p = r99;
                                    p.UpdateName(p, r15[r16("\xa7\x15\x10\x809F\x92\xbaַ\x8d\xf4T", 21548387346226)] .. tostring(o[r15[r16("bð94", 28672049706023)]] or r15[r16("x\xb3\x9cT", 23191639878191)]));
                                    p = r100;
                                    p.UpdateName(p, r15[r16("(\x02\x18\n\x05\xbbM\xfdJ\xbaF\x03", 3860875790085)] .. tostring(o.FindFirstChild(o, r15[r16("̜\xab\x8c\x82q9=Ss", 1278156751443)]) and o[r15[r16("\xaa2\xcc;վh,Sm", 9058881589370)]][r15[r16("pw\xffZ\x94", 27382495523278)]] or 0) .. r15[r16("z", 23735561906988)]);
                                    p = r101;
                                    p.UpdateName(p, r15[r16("\x9d\xcf\xcf\x13{t\x88\xea]\x19\xc3\xff\xb5T\xe78", 27523406836240)] .. tostring(o.FindFirstChild(o, r15[r16("\x00\xd3,Gkƅί\xdc\xf5\xca\xcc", 22024154097679)]) and o[r15[r16("\xe0\x97څ\xddYе\xb6\x8b~`4", 29417785357698)]][r15[r16("\x1cQ\xe8$S", 10842294719416)]] or 0));
                                    p = r102;
                                    p.UpdateName(p, r15[r16("\x90\xee\xe0^\xe9\\Y\xa6,N\xf0\xe3\x9b\xdcUF\x1f,\xdb\xee\xbc!\xd4\xdc!TLy\xfd#\xdfO8I", 25313811836427)] .. tostring(M));
                                end;
                            end; 
                        end);
                    end; 
                end; 
            end);
            NH[1] = 7049271938258;
            I = JY[r15[r16("\xe1\x89\x0f\xdc", NH[1])]];
            NH[2] = "f5?\xef";
            NH[1] = r16(NH[2], NH[3]);
            NH[3] = "a\xb2\x91q\xa1";
            NH[1] = r16;
            NH[2] = NH[1](NH[3], NH[4]);
            NH[3] = 15270318971846;
            oH, NH[4], NH[2] = I.Section(I, {
                [r15[NH[1]]] = r15[NH[2]]
            }), 8127447502536, "8T[\x99";
            NH[1] = r16(NH[2], NH[3]);
            NH[3] = "JR\x00\xe7AŬ\x8a\xbb$";
            NH[1] = r16;
            NH[2] = NH[1](NH[3], NH[4]);
            NH[3] = 18747851579930;
            NH[1] = "<\xe69";
            oH.Header(oH, {
                [r15[NH[1]]] = r15[NH[2]]
            });
            NH[2] = 13572309440688;
            NH[2] = "cݹ\x05\xf2\x82:\xdc";
            NH[1] = r16(NH[2], NH[3]);
            NH[3] = "\x18\xdc\xf5\xe1 \xde\x15";
            NH[4] = 5443858401766;
            NH[1] = r16;
            NH[2] = NH[1](NH[3], NH[4]);
            NH[4] = "\xd2\x7f\x13\xbc{\xba";
            NH[1] = r15;
            NH[2] = r16;
            NH[3] = NH[2](NH[4], NH[5]);
            NH[2] = r15;
            NH[3] = r16;
            NH[5] = "nHG\x9bpB\x8e\xcd]";
            NH[4] = NH[3](NH[5], NH[6]);
            NH[1] = NH[2][NH[4]];
            NH[6] = "ac\x9e\x18\xc6\x1c\x08\x9d\x1bu\x99f";
            NH[3] = r15;
            NH[4] = r16;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[7] = "9\x92\x1e\x9b/";
            NH[2] = NH[3][NH[5]];
            NH[4] = r15;
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[8] = "^a\xbe\xaf\x849\x02";
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            r103 = {
                r15[r16(NH[1], NH[2])],
                r15[NH[1]],
                r15[NH[2]],
                NH[1][NH[3]],
                NH[1],
                NH[2],
                NH[3],
                NH[4]
            };
            r104 = {};
            NH[2] = r103;
            NH[3] = {
                ipairs(NH[2])
            };
            NH[2], NH[1], YH = NH[3][1], NH[3][3], NH[3][2];
            NH[1], NH[4] = NH[2](YH, NH[1]);
            while NH[1] do
                NH[3] = NH[1];
                I = r104;
                NH[13] = "\x8b\xde#1\xd2Q\xb8+\x87kߋ\x91K";
                NH[8] = r15;
                NH[14], NH[12], NH[11] = 9163588227243, 25945227980593, "5b\xe6e";
                NH[9] = r16;
                NH[3] = nil;
                NH[10] = NH[9](NH[11], NH[12]);
                NH[7] = NH[8][NH[10]];
                NH[10] = r15;
                NH[11] = r16;
                NH[12] = NH[11](NH[13], NH[14]);
                NH[9] = NH[10][NH[12]];
                NH[8] = NH[4] .. NH[9];
                NH[5], NH[6] = "Label", {
                    [NH[7]] = NH[8]
                };
                NH[5] = oH[NH[5]];
                NH[5] = NH[5](oH, NH[6]);
                I[NH[4]] = NH[5];
                NH[4] = nil; 
            end;
            NH[1], NH[5], NH[6] = "task", "\x939\xfd\xd7z", 22857842731412;
            NH[2] = r15;
            NH[10] = "\xc19\x85\xa8N\xd6%";
            NH[3] = r16;
            NH[4] = NH[3](NH[5], NH[6]);
            NH[7], NH[5] = 14098696231333, 18243620299055;
            NH[1] = NH[2][NH[4]];
            NH[1] = function(...)
                while task[r15[r16("=\x18 B", 19432905581401)]](25) do
                    if not r24 then
                        break;
                    else
                        pcall(function(...)
                            I = game;
                            P = I.GetService(I, r15[r16("\x08D\xe6hH\xb3\x0e\xec\xe0\xf1ݟ\xf4\xc6\xef\x80\x01", 32355228121818)]);
                            I = P.FindFirstChild(P, r15[r16("\x97\x08nH\xbe", 24135999499239)]);
                            if I then
                                P = I.FindFirstChild(I, r28[r15[r16("f\x88SG", 28491787170771)]]);
                            end;
                            if I then
                                I = I[r28[r15[r16("\xeb[F\x9e", 24553351539881)]]];
                                z = I.FindFirstChild(I, r15[r16("F\xfa\x10\xc6\xd9jC>x", 10975781491702)]);
                                if z then
                                    o, P = ("F\xfa\x10\xc6\xd9jC>x")[2], ("F\xfa\x10\xc6\xd9jC>x")[1];
                                    for W, S in ipairs(r103) do
                                        q = W;
                                        M = P.FindFirstChild(P, S);
                                        if M then
                                            p = I.FindFirstChild(I, r15[r16("\x80\xe9", 211274154082)]);
                                            if p then
                                                e = p[r15[r16("\x01Uh\xf6\xa3", 18751857222172)]];
                                            end;
                                            I = I;
                                            b = r104[S];
                                            if b then
                                                b = r104[S];
                                                b.UpdateName(b, S .. r15[r16("}\xc1|\x90EE", 29692430497282)] .. tostring(I[r15[r16("T+T\xfa\x8e", 22725200439638)]] or 0) .. r15[r16("\x8cC\x87", 21759661500308)] .. tostring(p or 0) .. r15[r16("F\x8a]", 22612733012257)]);
                                            end;
                                        end; 
                                    end;
                                end;
                            end; 
                        end);
                    end; 
                end; 
            end;
            NH[17], NH[4] = 39599292434, "\x10\xbe\x8e\xf8";
            Env[NH[1]][NH[1]](NH[1]);
            NH[1] = r15;
            NH[11], NH[23], NH[18], NH[8] = 2236339700753, 6374043536280, 200872575069, 12742172743469;
            NH[2] = r16;
            NH[3] = NH[2](NH[4], NH[5]);
            I = JY[NH[1][NH[3]]];
            NH[6] = "\x03j\xc5\xd9";
            NH[3] = r15;
            NH[4] = r16;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[2] = NH[3][NH[5]];
            NH[7] = "\x93Z~7\xc2";
            NH[4] = r15;
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[12] = 24126690683874;
            NH[3] = NH[4][NH[6]];
            NH[19], NH[8], NH[1], NH[13] = 10739636097929, 28214231855954, {
                [NH[2]] = NH[3]
            }, 6601165655041;
            YH = I.Section(I, NH[1]);
            NH[3] = r15;
            NH[7] = 25292892237313;
            NH[4] = r16;
            NH[6] = "\xa5\xa3=I";
            NH[5] = NH[4](NH[6], NH[7]);
            NH[2] = NH[3][NH[5]];
            NH[7] = "\xe38\xe3.;\x85\x19yw";
            NH[4] = r15;
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[1], NH[7], NH[6] = {
                [NH[2]] = NH[3]
            }, 23848402365281, "\xa1\xd2>U";
            YH.Header(YH, NH[1]);
            NH[3] = r15;
            NH[16] = 19978780206167;
            NH[4] = r16;
            NH[9] = 1157307253274;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[8] = 5378839103944;
            NH[2] = NH[3][NH[5]];
            NH[15] = 24639655750865;
            NH[4] = r15;
            NH[7], NH[14] = "\x9ab\x0f\x96\xddB\x0f\xa4\xa4v", 21777660323741;
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[20] = 9203187519677;
            NH[6] = r16;
            NH[8] = "\xc2\\\xffY{\xc2\x05";
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[7] = r15;
            NH[8] = r16;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[11] = "Y\xeb,{M噑\xaf\xfeΪ\xdegg=k";
            NH[6] = NH[7][NH[9]];
            NH[8] = r15;
            NH[9] = r16;
            NH[10] = NH[9](NH[11], NH[12]);
            NH[12] = "\xf3q&\n\xec\xdd\\\xab\xb8T\xb7\xc0\xc7\xc8\xf3\xe3\x15\xa1p";
            NH[7] = NH[8][NH[10]];
            NH[9] = r15;
            NH[10] = r16;
            NH[11] = NH[10](NH[12], NH[13]);
            NH[13] = "\xea.\xe1ϕ\x04@\xa9[\xb8=\xb7\x9c\xe2\xf9K\x0c>\x90";
            NH[8] = NH[9][NH[11]];
            NH[10] = r15;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[11] = r15;
            NH[24], NH[14] = 12010342716888, "\x83\x86\x97\x80\x19\xae\xf8\x88\xa5\xb4p\x81j\xb1ٳ'";
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[15] = "\xad\x02\x19]\x9fe6\xff\xb6\xa8\x15\xf9 ";
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[16] = "߮\xcfr\x8aw\x92\xa9+%\xc2\x99";
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[22] = 30172541679330;
            NH[14] = r15;
            NH[15] = r16;
            NH[17] = "s$\n\x13/`\xff\x9e$\xc8\x12\xae\xe56\xe0i{\x9d";
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[15] = r15;
            NH[18] = "\xf9\x8b;A\xd7Lr$,\xea\xd3\xec\x8e";
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[16] = r15;
            NH[17] = r16;
            NH[19], NH[21] = "\xc9J\xab\xcb\xf5\xfc/\x80/\x00I\xe9\xc0\xf9\xb9\xbd9\xdf", 23058715322865;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[17] = r15;
            NH[18] = r16;
            NH[20] = "\xa5~\xb3>C\xc1\xb3\x13;";
            NH[19] = NH[18](NH[20], NH[21]);
            NH[21] = "\x0b@\x7f\x05'\x81\xabOg\xfd\xb4Ͻ\xb9MI\xbf\xcb";
            NH[16] = NH[17][NH[19]];
            NH[18] = r15;
            NH[19] = r16;
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[22] = "f.\xa4\xf3\x15\x843x\xd3͛\xb5\xa9\x9cS\xb0";
            NH[19] = r15;
            NH[20] = r16;
            NH[21] = NH[20](NH[22], NH[23]);
            NH[18] = NH[19][NH[21]];
            NH[20] = r15;
            NH[21] = r16;
            NH[23] = "\xad\xb3\xae\xad\xe5p\xdaH\n\xa1>a_\x0b\xb7;";
            NH[22] = NH[21](NH[23], NH[24]);
            NH[19] = NH[20][NH[22]];
            NH[5] = {
                NH[6],
                NH[7],
                NH[8],
                NH[9],
                NH[10],
                NH[11],
                NH[12],
                NH[13],
                NH[14],
                NH[15],
                NH[16],
                NH[17],
                NH[18],
                NH[19]
            };
            NH[12], NH[11] = "\x91\x1b\xf2k\xc6E\xb6Q", 23479956761269;
            NH[7] = r15;
            NH[10], NH[16] = "1\xcd$\"E\xa6\x93", 31215469885639;
            NH[8] = r16;
            NH[13] = 30927395076161;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[7] = 1;
            NH[9] = r15;
            NH[10] = r16;
            NH[11] = NH[10](NH[12], NH[13]);
            NH[8] = NH[9][NH[11]];
            NH[9] = function(arg1_10, ...)
                I = r57;
                I[r15[r16("\xa3CN", 22986124208591)]] = arg1_10; 
            end;
            NH[1] = {
                [NH[2]] = NH[3],
                [NH[4]] = NH[5],
                [NH[6]] = NH[7],
                [NH[8]] = NH[9]
            };
            NH[3] = r15;
            NH[6], NH[7] = "l$\xe4m#\xcd\x0fq\xf8", 11020785095691;
            NH[4] = r16;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[6] = "\x08\xc9\xf0\x1c";
            NH[2] = NH[3][NH[5]];
            YH.Dropdown(YH, NH[1], NH[2]);
            NH[7] = 31138669230244;
            NH[3] = r15;
            NH[4] = r16;
            NH[8] = 6553609325547;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[2] = NH[3][NH[5]];
            NH[4] = r15;
            NH[5] = r16;
            NH[7], NH[9] = "K\xcae\xfac\x07\x18tm&G\x07u\xbc}", 5528843487758;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[11] = 33042669976602;
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[6] = r16;
            NH[8] = "\xfde\xd6\xc2=-={";
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[5] = function(...)
                v1 = r57[r15[r16("\x1bӿ", 17713958625336)]] or r15[r16("\xac\x03\xe2\xa3\xc5\xc5\x15", 29166342337805)];
                I = r74[r15[r16("\xf4\xceD]\xabG", 23772463803197)]];
                I.InvokeServer(I, {
                    [r15[r16("A\xe4IS", 31812654873053)]] = v1
                });
                r76(r15[r16("\x0c]\xb4\xc6g~\xc3w", 6724142976059)], r15[r16("O5\xa8\xf6ᔉY\xf9a9\xb3q\xa6G", 13880983935295)] .. v1, 3); 
            end;
            NH[7], NH[1] = 24842514623792, {
                [NH[2]] = NH[3],
                [NH[4]] = NH[5]
            };
            NH[3] = r15;
            NH[4] = r16;
            NH[6] = "Yo9\xe4npt\t%\xef\xa4\x1az";
            NH[5] = NH[4](NH[6], NH[7]);
            NH[2] = NH[3][NH[5]];
            NH[8], NH[6], NH[7], NH[12] = 19259823055624, "8\xc1\x89\x11", 30572545341340, 14512941161062;
            YH.Button(YH, NH[1], NH[2]);
            NH[9] = 25999821877067;
            NH[3] = r15;
            NH[4] = r16;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[7], NH[10] = "\x83\xa0q|\xf6d4\x01?Wy'\xdd\xe1\x10", "\xb9\x98\x17\xad\x02c\x14\x16";
            NH[2] = NH[3][NH[5]];
            NH[4] = r15;
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[8] = "\xbeQ\x9dW \xb6I7";
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[5] = function(...)
                v1 = pcall(function(...)
                    I = r74[r15[r16("\xba\x93\x94<aΛv", 32808885058477)]];
                    I.FireServer(I, {}); 
                end);
                if not v1 then
                    r76(r15[r16("~\xae\x15q\xf3", 8202141634283)], r15[r16("}\xfa\xa7\xd1\xfa\xf1\xfe\xc1\xb3\xa7\xa4;\xe9\xbd%\xe6S\x98\xe1\xdcB\xad\x9a_", 32600987532109)], 5);
                end; 
            end;
            NH[1] = {
                [NH[2]] = NH[3],
                [NH[4]] = NH[5]
            };
            NH[3] = r15;
            NH[6], NH[7] = "\r\xbd\xf4\x8e\xed\x16\xca\x00\xab\x9a\xbb\xa0H", 19402173277002;
            NH[4] = r16;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[2] = NH[3][NH[5]];
            NH[6] = "\xee\xc0l\xf7";
            YH.Button(YH, NH[1], NH[2]);
            NH[3] = r15;
            NH[4] = r16;
            NH[8], NH[7] = 17395395633060, 32841797385149;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[7] = "\x90\x92\x05\xb4\x83±U\xd3p6\xe0T\xda\x0e";
            NH[2] = NH[3][NH[5]];
            NH[4] = r15;
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[9], NH[8] = 19441772569437, "\x8c\xaa\x1f\x01\x11)\xcc";
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[5] = false;
            NH[7] = r15;
            NH[8] = r16;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[24] = 33740295945567;
            NH[6] = NH[7][NH[9]];
            NH[7] = function(arg1_11, ...)
                if arg1_11 then
                    if r58 and r58[r15[r16("\xe1\x1a*\xf4\x1f\xe7\xa2?s\xa6\x89\x19", 28135031730989)]] then
                        I = F[zY];
                        I.stopAutoFarm(I);
                    end;
                    z = r83()[r57[r15[r16("-Ql", 28644960089114)]]];
                    if z then
                        P = z[r15[r16("\x80\xf2\xbf\xf7\xad\xb0\xa6\x13\x85\x11Ar\xbe", 20917013194252)]];
                    end;
                    if z then
                        z.startAutoFarm(z);
                        r58 = z;
                        r76(r15[r16("\x1b\x00VHi\x02&", 23123201321487)], r15[r16("\x81\x16\xcb\x18\xa0$\xba\x17c_\xee\xa1n\xcd=\xda\x13-", 35019003641778)] .. tostring(r57[r15[r16("@\x8d\x12", 32927355911140)]]), 5);
                    else
                        r76(r15[r16("\xa8\x1c\xa6\x1c,", 11418785977541)], r15[r16("\x81\xf5\xeaI\xf5\x99F\x08\r\xf7\x07>Y\xc0;it\x85\xb4D\x96\xa8t\xc5\x06\xcd\xdb\xf6ڒ:\xec\xc6", 30762026612724)], 4);
                    end;
                else
                    P = r58 and r58[r15[r16("\x9e\xae\xb1\xe9\x0e7\xf7\x92\x1f\xa2\xce\xe4", 20729108014516)]];
                    I = "Toggle";
                    if P then
                        P = F[zY];
                        P.stopAutoFarm(P);
                    end;
                    r76(r15[r16("\xd9\x16SR\xe5\xac\xec\x8eqv\x97", 22439571073233)], r15[r16("\xc3s\xc8K)\x91\xf4\x08\x97\xbaJ\xe5\xb3\x13\x9fv[o:\x1aV;wiH\x14", 26716323754136)], 4);
                    return;
                end; 
            end;
            NH[1] = {
                [NH[2]] = NH[3],
                [NH[4]] = NH[5],
                [NH[6]] = NH[7]
            };
            NH[7] = 27282717356448;
            NH[3] = r15;
            NH[4] = r16;
            NH[6], NH[10] = "\x16\xde2\xb2\xf9:\xdd9\x14\xbfP\x1eە", 30716707665887;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[2] = NH[3][NH[5]];
            NH[8], NH[5] = 9245910274257, "\xbe\xeaW\x8f";
            YH.Toggle(YH, NH[1], NH[2]);
            NH[6] = 27968414560991;
            NH[2] = r15;
            NH[9], NH[11] = 21264687589038, 23377003817605;
            NH[3] = r16;
            NH[4] = NH[3](NH[5], NH[6]);
            NH[1] = NH[2][NH[4]];
            I = JY[NH[1]];
            NH[7] = "+1]\xfb";
            NH[4] = r15;
            NH[13] = "\x04}\xfa\xb9\xcb\x0c\xa4\x97";
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[1], NH[17], NH[8] = "Section", 32836608277434, "z)\xc1n";
            NH[5] = r15;
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[19] = 15761948712107;
            NH[4] = NH[5][NH[7]];
            NH[1], NH[2] = I[NH[1]], {
                [NH[3]] = NH[4]
            };
            NH[1] = NH[1](I, NH[2]);
            NH[4] = r15;
            NH[9] = 5874193042095;
            NH[5] = r16;
            NH[7], NH[8] = "X\xa3\x93\xe1", 16556506258973;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[8] = "\x99Z\xe3e(\xc1G/";
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[8] = 27988830581481;
            NH[4] = NH[5][NH[7]];
            NH[18], NH[2] = 6089171208979, {
                [NH[3]] = NH[4]
            };
            NH[1].Header(NH[1], NH[2]);
            NH[4] = r15;
            NH[5] = r16;
            NH[7] = "N\x97Q\"";
            NH[6] = NH[5](NH[7], NH[8]);
            NH[9] = 30437490210653;
            NH[3] = NH[4][NH[6]];
            NH[8] = "\xb0+\x8b\x943j\x86\x00";
            NH[5] = r15;
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[9] = "<4\xb0:;\x85\xecK\x13";
            NH[4] = NH[5][NH[7]];
            NH[6] = r15;
            NH[7] = r16;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[10] = "\x1a\xbf$npo\xecw\x0c\x80\x08\xda\xe00\xf3\xd0F2\xa8\xc7}\xb0\xc3/:4\x84\xd7\xf3\x10\xb5\x13\xdd\xfcv\xab\xad";
            NH[7] = r15;
            NH[8] = r16;
            NH[14] = 21532157437738;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[8] = r15;
            NH[9] = r16;
            NH[11] = "\xf2%^\xd2C\xbb\xb1";
            NH[10] = NH[9](NH[11], NH[12]);
            NH[7] = NH[8][NH[10]];
            NH[8] = true;
            NH[10] = r15;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[10] = function(arg1_12, ...)
                if arg1_12 then
                    r88();
                else
                    r89();
                end; 
            end;
            NH[2] = {
                [NH[3]] = NH[4],
                [NH[5]] = NH[6],
                [NH[7]] = NH[8],
                [NH[9]] = NH[10]
            };
            NH[7] = "*Y\xd8?~O\x16";
            NH[4] = r15;
            NH[13] = "s\xaenL1t.\x7f";
            NH[5] = r16;
            NH[8] = 21001516770867;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[1].Toggle(NH[1], NH[2], NH[3]);
            NH[7], NH[8] = "\xc4m\t\xd4", 22715082795345;
            NH[4] = r15;
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[8], NH[22] = "\x04*\xa3|\x0e\xaeT\x11\x16`M\xe5<\xed.~L\x89\x06+", 22483137276133;
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[6] = r16;
            NH[9] = 18948772864631;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[6] = r15;
            NH[9], NH[12], NH[10] = "\xef\xc59\xa4ȩVΑ", 1159796408860, 5219317942654;
            NH[7] = r16;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[7] = r15;
            NH[8] = r16;
            NH[10], NH[11] = "\x0ez\xaf/E\xe0\xa0\xe9\xea[\x18x\xa8\x0f\x9e\x1e*\x9ed\xabd\xa4\xb5L\xf0Vˢ\x86.R\xeb\x89\xe95\xd6\x16\xc6\x16\x9d<\x04N", 20372508091662;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[8] = r15;
            NH[14], NH[11] = 24661090512091, "\x1523\x08\x16\xac\x1d";
            NH[9] = r16;
            NH[10] = NH[9](NH[11], NH[12]);
            NH[7] = NH[8][NH[10]];
            NH[10] = r15;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[8] = false;
            NH[9] = NH[10][NH[12]];
            NH[10] = function(arg1_13, ...)
                v1 = arg1_13;
                P = getgenv();
                P[r15[r16(";\x10\xe7C\x13\x95\xf6m\xe8]\xc0\x04Јloo", 18230805963049)]] = v1;
                if v1 then
                    task[r15[r16("\xa0\"\xbc\xa5\x04", 29294828139849)]](function(...)
                        while getgenv()[r15[r16("$\x17\x88\xac\x8fUc\xe7|d\xc1\xa7\xb6\x185F\xfb", 18121678512374)]] do
                            pcall(function(...)
                                W = game;
                                v1 = W.GetService(W, r15[r16("\xa3\xae&\x0b\xf3\xdf@", 3963447052085)])[r15[r16("֍x\xc5\x1b\x19\x83\xb0zxh", 17233657356121)]][r15[r16("\xbc\x1e\xe7#\x83\xe7I\xf7\xab", 17956310048937)]][r15[r16("\x1cQ7\xffh\x7f\x91", 1706430858010)]][r15[r16("1\xf2\xbd\x8d\xc0\x19E\x16\xcf\xe9\xd0ӻ", 28652443333662)]][r15[r16("\xec\xb0\xff\xc4$", 13533964556446)]];
                                if v1 then
                                    firesignal(v1[r15[r16("\x13\x8c+Oy\x00\xcdN\xd5", 22435538872527)]]);
                                end; 
                            end);
                            task[r15[r16("DzZ\x9f", 15907642301679)]](30); 
                        end; 
                    end);
                end; 
            end;
            NH[2] = {
                [NH[3]] = NH[4],
                [NH[5]] = NH[6],
                [NH[7]] = NH[8],
                [NH[9]] = NH[10]
            };
            NH[4] = r15;
            NH[5] = r16;
            NH[8], NH[7] = 5065916205367, "i\x05\x8c8]`2\xfd'G\xe9\xfa\xdbRKt\xf0";
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[9] = 8691684773839;
            NH[1].Toggle(NH[1], NH[2], NH[3]);
            NH[4] = r15;
            NH[5] = r16;
            NH[7], NH[8] = "y\x83\xf9\xf1", 14533884123759;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[8] = "H%\xe9\x18\xfbt\x03\x04iU]W\xd5׽";
            NH[3] = NH[4][NH[6]];
            NH[5] = r15;
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[10], NH[11] = 14311826496008, 614199623966;
            NH[4] = NH[5][NH[7]];
            NH[25], NH[9] = 25921979035430, "^\r`\xceZ\x1a}\x10a";
            NH[6] = r15;
            NH[7] = r16;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[10] = "\x1f\xa5\x03\x925u\xdf\x00\x05\xeeư\x1c\xa2v\x932z,O\xb0\xd0=\xf2Z\xf3e65\x1b-\xc9\xef\xa8\x18\xca\x05\xd5\x1a\x80\x11Ҍ\r\xe0\xe2\xf8O\xf2\xe1\x1e";
            NH[5] = NH[6][NH[8]];
            NH[7] = r15;
            NH[8] = r16;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[12] = 25248191032813;
            NH[8] = r15;
            NH[9] = r16;
            NH[11] = "\x15\xb8{5\x99\xa2\x0f\xa1";
            NH[10] = NH[9](NH[11], NH[12]);
            NH[7] = NH[8][NH[10]];
            NH[8] = function(...)
                if r49 and r49[r15[r16("I\xbc0\xeb\xeaDso(\x91Yh\xe9", 20186019538103)]] then
                    r49[r15[r16("\xb0<\xc8\xdf\xd7\xd3i\xe8ƒ\r\xec$", 28603030205447)]](true);
                    r76(r15[r16("\xe5\x0b\xf7\xf5\x99 [s\xb2\x1a_\x17\x85\x18\xfd", 20501309138250)], r15[r16("\xd9C\xbe\x0ejڮ", 15718355115159)], 5);
                else
                    r76(r15[r16("\xbbы\xf9\r", 16795661917837)], r15[r16("\x88\xe2\xf9\x9a\x12\x14\xc3\x03C\x8f\n%\"t\xda\x16\xb1wH\xfd\xf6\xdc\x047\xaeo", 35014250299312)], 5);
                end; 
            end;
            NH[9], NH[2] = 22544961005826, {
                [NH[3]] = NH[4],
                [NH[5]] = NH[6],
                [NH[7]] = NH[8]
            };
            NH[4] = r15;
            NH[8], NH[7] = 2066140447682, "Q0aK{_\xc4bf\x85)T=";
            NH[5] = r16;
            NH[6] = NH[5](NH[7], NH[8]);
            NH[3] = NH[4][NH[6]];
            NH[7] = 2612806599872;
            NH[1].Button(NH[1], NH[2], NH[3]);
            NH[6] = "^\x03m\x15";
            NH[3] = r15;
            NH[4] = r16;
            NH[5] = NH[4](NH[6], NH[7]);
            NH[2] = NH[3][NH[5]];
            NH[8] = "\x04\xcbZ\xf6";
            I = JY[NH[2]];
            NH[5] = r15;
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[6] = r15;
            NH[9] = "}S,\xd7";
            NH[7] = r16;
            NH[10] = 21014913328697;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[10], NH[2] = 7733096992273, "Section";
            NH[5] = NH[6][NH[8]];
            NH[9], NH[8], NH[2], NH[3] = 7832124542527, "\x03\xa3\xe1\xb8", I[NH[2]], {
                [NH[4]] = NH[5]
            };
            NH[2] = NH[2](I, NH[3]);
            NH[5] = r15;
            NH[6] = r16;
            NH[11], NH[12] = 25963902955322, 16285165772191;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[6] = r15;
            NH[7] = r16;
            NH[9] = "\x08\x94\xbe\xff\xab$\xef\x93q";
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[3], NH[9] = {
                [NH[4]] = NH[5]
            }, 22174709737557;
            NH[2].Header(NH[2], NH[3]);
            NH[5] = r15;
            NH[6] = r16;
            NH[8] = "\xfb\x86)\xed#!";
            NH[7] = NH[6](NH[8], NH[9]);
            NH[9] = "\xf1\x11\xe0\x8a\xc4\xc9\xf2#";
            NH[4] = NH[5][NH[7]];
            NH[6] = r15;
            NH[7] = r16;
            NH[10] = 32493215071002;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[10] = "\x99\x9co\xc6";
            NH[7] = r15;
            NH[8] = r16;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[11] = "p\x0c\\\x1cS-ۻ`\x98\x07\xae5O\xe96\x9f~\xa3\x06\x98\xf1+\xa9\x05hQ\x04\xa1\xfbҒ{N\"i\xa1\x06\x81\x1b\xf2՚i\x97W\xfaʶ\x96\x17n=\xf7&\xbd^V7yC(q\x88\xa1\xd3ʿp\xbf\xe5I\x93:\xd3fm\x9f\x91\x01\xcf\x0chN\xce\x0c\xdbɿ\xfd\x90t8\xecW\xba\xeaPB\xdd\xc2SLX\xdbI{RW\xff\xb6\xc0h\xccM\xa7\x8d\xbc\x8d\xdf\x03\xa7\xd4@xf\xe5xƗ\x1a]آ(_r\xc0C\x8b\xc0[\x17:]՘\tf:A\x8c\x86\x10\xa9N\xafGf:\xc0\xfah\xd8}y\x91\xad3\xeb\xe7\"\x98\t:\xac\xf6\x97\xaan\x92\xfbG\xad\xf4\xb5\x98O\x05\x9e\xa5٣\xea\x9c\xc6\n\xa4N\xb9\x15\x13\xaa";
            NH[8] = r15;
            NH[9] = r16;
            NH[10] = NH[9](NH[11], NH[12]);
            NH[7] = NH[8][NH[10]];
            NH[10], NH[3] = 29927350007408, {
                [NH[4]] = NH[5],
                [NH[6]] = NH[7]
            };
            NH[2].Paragraph(NH[2], NH[3]);
            NH[5] = r15;
            NH[14] = "@\xc1\x0e\x9f\xfe";
            NH[6] = r16;
            NH[8], NH[9] = "\x81۪\x99", 15430521478161;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            NH[11] = 33518823144696;
            NH[6] = r15;
            NH[13] = 33386831527098;
            NH[7] = r16;
            NH[9] = "~ۉQ\x08\x87\x7f\x9a\x92\xc4\x10\x060";
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[7] = r15;
            NH[15] = 31633780865418;
            NH[8] = r16;
            NH[10] = "\x8d\xee+,A\x15\x13";
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[12] = "\xdc:t\x9e\x12\xfa\xaa";
            NH[7] = r90;
            NH[8] = NH[7]();
            NH[9] = r15;
            NH[10] = r16;
            NH[11] = NH[10](NH[12], NH[13]);
            NH[7] = NH[9][NH[11]];
            NH[11] = r15;
            NH[9] = 1;
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[11] = function(arg1_14, ...)
                I = r57;
                I[r15[r16("\x90\xa9\x9e\x81\xe0j\xbc\x16\xbd\xf6a\n\x13\xf5", 26986894373142)]] = arg1_14; 
            end;
            NH[3] = {
                [NH[4]] = NH[5],
                [NH[6]] = NH[8],
                [NH[7]] = NH[9],
                [NH[10]] = NH[11]
            };
            NH[5] = r15;
            NH[12] = 16802340200080;
            NH[6] = r16;
            NH[8], NH[9] = "\xf6\xb9\xaf\x95Lp(T\xa4A", 11736423978329;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[9], NH[10] = "\xd4\xcf\xd5\t", 18884947632729;
            NH[4] = NH[5][NH[7]];
            NH[3] = 17;
            F[NH[3]] = NH[2].Dropdown(NH[2], NH[3], NH[4]);
            NH[6] = r15;
            NH[7] = r16;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[7] = r15;
            NH[10] = "@\xa0\x10uz\x87w\xec|";
            NH[8] = r16;
            NH[11] = 7710164585990;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[14] = 19730850931683;
            NH[6] = NH[7][NH[9]];
            NH[8] = r15;
            NH[11] = "\xf9\xed\x85b\xd19\x99\xe0";
            NH[9] = r16;
            NH[10] = NH[9](NH[11], NH[12]);
            NH[7] = NH[8][NH[10]];
            NH[10] = 9062979309692;
            NH[8] = function(...)
                if r74[r15[r16("\xa7Y\xac\x91\xad\x1c", 33418831772873)]] then
                    I = r74[r15[r16("\x00.%{+\x88", 16401849359829)]];
                    I.InvokeServer(I, {
                        [r15[r16("\x86\x10l\xfd\x96\xba", 31114166696088)]] = r57[r15[r16("m\xbbV\xa8\xc7\x11\n\x82-\xdcy\x117\xc2", 34033031396839)]]
                    });
                    r76(r15[r16("f\xeds\xcb\xe8\xb1K", 6465668287426)], r15[r16("𥭹\xb7\xf6\xef\x87\x07/)\xfd<?", 16115814128976)] .. tostring(r57[r15[r16("l\x93\x8b\x9b\xebdQ\x0c6{\xb9v\xefl", 27451689497071)]]), 3);
                else
                    r76(r15[r16("\x83\t\xf1\xaa\x1d", 26966977442061)], r15[r16("\xc0\x8f\x11\x10\xe3ЩW\x0c)\x95\xda޻ jQ)\\\x87&\x8f\x01", 31834169244135)], 4);
                end; 
            end;
            NH[4] = {
                [NH[5]] = NH[6],
                [NH[7]] = NH[8]
            };
            NH[6] = r15;
            NH[7] = r16;
            NH[9] = "\x12\x111\x9a\xf9\x15A\xba";
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[2].Button(NH[2], NH[4], NH[5]);
            NH[6] = r15;
            NH[10], NH[9] = 26796855636158, "1\x13\xa1\xa8";
            NH[7] = r16;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[13], NH[11] = 14157444536768, 33900309708202;
            NH[5] = NH[6][NH[8]];
            NH[7] = r15;
            NH[10] = "9Vp,X\xfe\xd2W\xed\x9f\xc1\xb4A;\xdaI";
            NH[8] = r16;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[8] = r15;
            NH[9] = r16;
            NH[11], NH[12] = "\xf8\xc1\x97\x17\x15cY\x1cN\xb3\x82", 11675785909564;
            NH[10] = NH[9](NH[11], NH[12]);
            NH[12] = "\ry\x03\xc3.\xb3";
            NH[7] = NH[8][NH[10]];
            NH[9] = r15;
            NH[10] = r16;
            NH[11] = NH[10](NH[12], NH[13]);
            NH[8] = NH[9][NH[11]];
            NH[10] = r15;
            NH[13] = "\x00\xeb%\xe3\xdcNEv";
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[10] = function(arg1_15, ...)
                P = getgenv();
                I = r15[r16("\xd3\xeeh>\xd0j3\x1dOѱ\x830\x8e", 19507910468476)];
                o = I;
                P[I] = tonumber(arg1_15) or 100000; 
            end;
            NH[4] = {
                [NH[5]] = NH[6],
                [NH[7]] = NH[8],
                [NH[9]] = NH[10]
            };
            NH[6] = r15;
            NH[15] = 27116098777426;
            NH[7] = r16;
            NH[10], NH[9] = 21890541529041, "\xd4ǩ\x13\xe5\xea-\x86a\x16\xe2\xe9\xbd3";
            NH[8] = NH[7](NH[9], NH[10]);
            NH[5] = NH[6][NH[8]];
            NH[2].Input(NH[2], NH[4], NH[5]);
            NH[9], NH[11], NH[10] = "\xf5\xcb\xf2j", 16816753434262, 6721188564025;
            NH[6] = r15;
            NH[7] = r16;
            NH[12] = 12670072379147;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[10] = "k\x0e(\xceX\x07_\xf3z\xf9\x00\x02\xc2w";
            NH[5] = NH[6][NH[8]];
            NH[7] = r15;
            NH[8] = r16;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[11] = "z|\tj=\xc6\xd3";
            NH[8] = r15;
            NH[13], NH[14] = "\xf7\xaa\x18\xbbr&\x90\x0b", 23006354336217;
            NH[9] = r16;
            NH[10] = NH[9](NH[11], NH[12]);
            NH[7] = NH[8][NH[10]];
            NH[8] = false;
            NH[10] = r15;
            NH[21] = 27979712754405;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[10] = function(arg1_16, ...)
                if not r48 then
                    r76(r15[r16("c}\xed\x16\x82", 32247274912424)], r15[r16("ב\xa7\x8f\x88$ CǶ\x1e.Si#\x93-W\xb1T݁[\xc3XV", 7413050281339)], 4);
                    return;
                end;
                if arg1_16 then
                    if r48[r15[r16("lq\x15\xdf4\x19\xd0?\xc5", 21340805375697)]] and not r48[r15[r16("\xa0=ڵ}\x8c7\xc6b", 30449734334307)]](r57[r15[r16("\xa5\xe6jim\xc7\xd443\xed\xffq\xce<", 3862459041542)]]) then
                        r76(r15[r16("<\xeam\xc6\xdb", 13143327660008)], r15[r16("\xf0\x90\x9cz36\xfaԠ=\xe3)Ȗ\x8db@\xa91", 7001786207420)], 4);
                        return;
                    end;
                    if r48[r15[r16("M~\xfe\xa96j\x88\x19\x1c\x9e\x91\xa2i", 22747406690656)]] then
                        r48[r15[r16("%P0\xdd873\x8e\xf7\x89ո\xa3", 20853492245998)]]();
                    end;
                else
                    if r48[r15[r16("\xa8\xe5\x1e\xedZ8\xf5\xec'\x7f\t\xa8", 23804126407500)]] then
                        r48[r15[r16("\x08f\x86\xed\xb7K\xa3qpw\xf0\xb2", 20981866358314)]]();
                    end;
                    return;
                end; 
            end;
            NH[4] = {
                [NH[5]] = NH[6],
                [NH[7]] = NH[8],
                [NH[9]] = NH[10]
            };
            NH[6] = r15;
            NH[7] = r16;
            NH[9], NH[10] = "\xa30K!:\x1eW%;\x12J\xef", 2070969500612;
            NH[8] = NH[7](NH[9], NH[10]);
            NH[9] = 19733920998373;
            NH[5] = NH[6][NH[8]];
            NH[2].Toggle(NH[2], NH[4], NH[5]);
            NH[11] = 19830525649938;
            NH[5] = r15;
            NH[10], NH[8] = "$\xe3\xa92", "\x84\x91\x8f\xc4";
            NH[6] = r16;
            NH[7] = NH[6](NH[8], NH[9]);
            NH[4] = NH[5][NH[7]];
            I = JY[NH[4]];
            NH[7] = r15;
            NH[12] = 8536637788039;
            NH[8] = r16;
            NH[4] = "Section";
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[20] = 17160146640694;
            NH[8] = r15;
            NH[4] = I[NH[4]];
            NH[9] = r16;
            NH[11] = "\xaa1\x9e\xf9\xa6";
            NH[10] = NH[9](NH[11], NH[12]);
            NH[7] = NH[8][NH[10]];
            NH[5] = {
                [NH[6]] = NH[7]
            };
            NH[4] = NH[4](I, NH[5]);
            NH[11], NH[12] = 665363038517, 12097843041793;
            NH[7] = r15;
            NH[10] = "\"\xa9-\xd7";
            NH[8] = r16;
            NH[9] = NH[8](NH[10], NH[11]);
            NH[6] = NH[7][NH[9]];
            NH[8] = r15;
            NH[9] = r16;
            NH[11] = "E\x99r\x9f\x90\x96\x8e\xe2\x85\x02\xec\xbf";
            NH[10] = NH[9](NH[11], NH[12]);
            NH[12], NH[13] = 319243124884, 32499532282653;
            NH[7] = NH[8][NH[10]];
            NH[5] = {
                [NH[6]] = NH[7]
            };
            NH[4].Header(NH[4], NH[5]);
            NH[6] = 18;
            NH[5] = 19;
            NH[11] = "h>3?\x0e|m\x83\x1b";
            F[NH[5]] = 40;
            F[NH[6]] = 5;
            NH[8] = r15;
            NH[9] = r16;
            NH[10] = NH[9](NH[11], NH[12]);
            NH[12], NH[14] = "Z\xd9QN\x83\xa8", 21160822351485;
            NH[7] = NH[8][NH[10]];
            NH[9] = r15;
            NH[10] = r16;
            NH[11] = NH[10](NH[12], NH[13]);
            NH[13] = "\xf0 u\x10\xd5\"d\xad";
            NH[8] = NH[9][NH[11]];
            NH[10] = r15;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[11] = r15;
            NH[14] = "\x01*\x1f\x85(\xc1\x80\xc6\x15\xefU";
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[15] = "\xc2t\x9bD\xa6\rq3\xa3\x16\xf0\x90\"\xb8";
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[16] = ">\x94\xb0P@";
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[14] = r15;
            NH[17] = "']މ\x14ũ";
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[15] = r15;
            NH[18] = "wz\x10{\x07E\x94B\xc4\xefm";
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[19] = "\x1d[\xe8K\\4\xceJ0]\x11\xe4\x8f_";
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[20] = "x?x\x94\xa5\xf7\x8a\x1b\x143\xf6\xf2c\xb9\xeb#D";
            NH[17] = r15;
            NH[18] = r16;
            NH[19] = NH[18](NH[20], NH[21]);
            NH[16] = NH[17][NH[19]];
            NH[18] = r15;
            NH[19] = r16;
            NH[21] = "\xffZ8f\xeb9\x87W\nu_\xc6,[`\x10\xa7\r";
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[7] = 20;
            F[NH[7]] = {
                NH[7],
                NH[8],
                NH[9],
                NH[10],
                NH[11],
                NH[12],
                NH[13],
                NH[14],
                NH[15],
                NH[16],
                NH[17]
            };
            NH[10] = r15;
            NH[13], NH[15], NH[16] = "\x9f\xf8\xe9;<<", 5465413028337, 10305119523518;
            NH[11] = r16;
            NH[14] = 33976900074957;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[11] = r15;
            NH[14] = "QM\x05n\x91p\xbd\xd8";
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[15] = "\xb4\xd4\xe9\xeb";
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[16] = "ұ\x90\xae\x94\x866\x07*ʂ\xc3\xc6\x1a=\xeaO?P\xda\xd6ac\x94\x1cӾ\xb4\x166\x98\x82\xed\xd1*\xb6\x8a\x8f\\\xf2\x99c\xe3'X\x05\x8aۑ\xfd{\xfe\xeb\x86U\xcaN\x10\xc4x\xb0\xe6\xbc\xdd\xce\xeb\xca&\xf9\xf1\x12\x08B搇\xeel\x8bmE\xe5\x92\x1a\xf0cX{\xa0;\x15\xed˂ݪ\xbd\x8bs!@\x84\xba\x01\xbaۉ\xa5\x1e\x0f9\xf0";
            NH[13] = r15;
            NH[14] = r16;
            NH[17] = 31039802882166;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[14], NH[8], NH[13] = 12878463326061, {
                [NH[9]] = NH[10],
                [NH[11]] = NH[12]
            }, "\x93\xcf\x10\xfe";
            NH[4].Paragraph(NH[4], NH[8]);
            NH[10] = r15;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[15] = 31645924899216;
            NH[11] = r15;
            NH[12] = r16;
            NH[14] = "\x84\x8a\xb3\xe2|\xaf\xb7\xfcԩ\x9b }\xfa\x18\xd9\xd4\x0cx";
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[15], NH[16] = "\xa4\xa2Q\x98\x19ھ~\xb3H\xd9", 26305165111257;
            NH[12] = r15;
            NH[18] = 9604880454008;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[17] = 16740922367603;
            NH[14] = r16;
            NH[16] = "Ɋ";
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[17] = "0y\x1e\x16\xfa\x9959";
            NH[14] = r15;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[14] = function(arg1_17, ...)
                F[NH[5]] = tonumber(arg1_17) or 40; 
            end;
            NH[15], NH[8] = 30458372700007, {
                [NH[9]] = NH[10],
                [NH[11]] = NH[12],
                [NH[13]] = NH[14]
            };
            NH[13], NH[16], NH[14] = "\t\xbf\x85\xf4}\x1dS\xb8\x88\xce", 21926705637346, 33306951318677;
            NH[10] = r15;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[13] = "L?\x14\x13";
            NH[9] = NH[10][NH[12]];
            NH[4].Input(NH[4], NH[8], NH[9]);
            NH[14] = 4303956953044;
            NH[10] = r15;
            NH[18] = 32529342200619;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[14] = "\xef/\x7fr&\xefl\x0e\x8f?\xd1#\xac\xf6#\x9b&\xff5\xd4K";
            NH[9] = NH[10][NH[12]];
            NH[11] = r15;
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[13] = r16;
            NH[15] = "o\xe5\x81\xda\tG\xbd\x1b\x11\xaf\x13";
            NH[14] = NH[13](NH[15], NH[16]);
            NH[16] = "@";
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[17] = 25285823311358;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[14] = r15;
            NH[17] = "XȠy\x16W\xa3\x94";
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[14] = function(arg1_18, ...)
                F[NH[6]] = tonumber(arg1_18) or 5; 
            end;
            NH[8] = {
                [NH[9]] = NH[10],
                [NH[11]] = NH[12],
                [NH[13]] = NH[14]
            };
            NH[14], NH[15] = 6476254530503, 5881607899826;
            NH[10] = r15;
            NH[13] = "\xf7]+T\x0f\x01\xbe\x0bx\x81\x11\x9c\x9b";
            NH[11] = r16;
            NH[18] = 16249824271758;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[4].Input(NH[4], NH[8], NH[9]);
            NH[10] = r15;
            NH[14], NH[13] = 9931976856080, "\xabtK0";
            NH[11] = r16;
            NH[21] = 21512109827873;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[16] = 7141617569021;
            NH[9] = NH[10][NH[12]];
            NH[11] = r15;
            NH[12] = r16;
            NH[14] = "\xeb\x9dö\xb1\xc6q\x08\xf6Y";
            NH[13] = NH[12](NH[14], NH[15]);
            NH[17] = "\x8e\xba\x8aA\xb9\r\x86\xc8";
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[13] = r16;
            NH[15] = "7\x92-\xb7#\x1b\xc1x";
            NH[14] = NH[13](NH[15], NH[16]);
            NH[22], NH[13] = 18684054282748, "H\xb6\x92K/(y\"\xe6\xf6";
            NH[11] = NH[12][NH[14]];
            NH[26] = 12101997090307;
            NH[12] = function(...)
                r76(r15[r16("L\xee\xac4", 22029819897874)], r15[r16("\xaf\x0cFܝ\x02l\x10\x86\xc6\x05\x9a\xfa\x93\xdc\x01", 6200851024711)] .. tostring(F[NH[5]]) .. r15[r16("\xa9|q\x1f\x9b*\xabi\xaf", 4456777762843)] .. tostring(F[NH[6]]) .. r15[r16("!s\xd6\xe5Q\x83\xa8", 8006270160528)], 3); 
            end;
            NH[8], NH[14] = {
                [NH[9]] = NH[10],
                [NH[11]] = NH[12]
            }, 33316949802138;
            NH[10] = r15;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[15] = 5658506332746;
            NH[9] = NH[10][NH[12]];
            NH[4].Button(NH[4], NH[8], NH[9]);
            NH[13] = "7/x*";
            NH[10] = r15;
            NH[11] = r16;
            NH[14] = 487875543267;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            NH[14], NH[16] = "\xa9\x1d\xf9\xe8\xf0+qy\x1b\xac+\x95", 4221748922285;
            NH[11] = r15;
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[13] = r16;
            NH[15] = "\xf3\xc7\xff\xb8\xab\r\x1b";
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[14] = r15;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[12], NH[15] = false, 28477199070156;
            NH[14] = function(arg1_19, ...)
                v1 = arg1_19;
                r63 = v1;
                if not v1 then
                    r76(r15[r16("Pi\xb2\x9e&k\x8c\xc6`\x01\x18\x95", 22818652973441)], r15[r16("\xd9\x06ف\xe4(\xaa\xcf", 32201461676690)], 3);
                    return;
                end;
                task[r15[r16("#\xfdA2\x1e", 3548589442676)]](function(...)
                    v1 = r63;
                    P = r24;
                    while not v1 do
                        if P then
                            task[r15[r16("j-\xaa<", 21611180943183)]](1);
                            if r64 then
                                if os[r15[r16("\xf5\xfcL\xd5", 2482502599812)]]() >= r65 then
                                    r64 = false;
                                    I = false;
                                    r105 = r66 or r57[r15[r16("-{\xb2", 13853708966195)]];
                                    pcall(function(...)
                                        if r58 and r58[r15[r16("J;\x841\xff>%Ş\xafv>", 17466611720133)]] then
                                            I = r58;
                                            I.stopAutoFarm(I);
                                        end;
                                        v1 = r28[r15[r16("\xd1\x182\xc8\xf1\xfe\xf3\xe3p", 15360965925873)]];
                                        if v1 then
                                            P = v1.FindFirstChild(v1, r15[r16("XJ\")\x1b\x8c\\\x8c", 10315261776579)]);
                                        end;
                                        if v1 then
                                            P = v1[r15[r16("o\xb2KoLj\x15s", 8587404726174)]];
                                            P[r15[r16("^.\xc0\xd6", 32101888309860)]] = true;
                                        end;
                                        task[r15[r16("\xf0i\xdf\x1e", 19920142230588)]](1.5);
                                        P = r74[r15[r16("\x12ndO\xb6\x89\x00\xd8", 6709983939636)]];
                                        P.FireServer(P, {});
                                        task[r15[r16("\xc7\xebf`", 1221473157688)]](0.5);
                                        P = r74[r15[r16("w\xd4g\x0e?\x0f\xdf\x15", 15194142841763)]];
                                        P.FireServer(P, {});
                                        P = r74[r15[r16("`\x01\xd6ƣ<", 28636689576982)]];
                                        P.InvokeServer(P, {
                                            [r15[r16("\xcaז\xb0", 26507296485431)]] = r105
                                        });
                                        task[r15[r16(">y\xb5X", 12539112937166)]](8);
                                        z = r83()[r105];
                                        if z then
                                            P = z[r15[r16("b\x93\xb9$UYx\xa6\xcaS\xdf`&", 35112944123870)]];
                                        end;
                                        if z then
                                            z.startAutoFarm(z);
                                            r58 = z;
                                            r76(r15[r16("\x1c\xd0N}\x8eAU73\x02\x98w", 1254901236296)], r15[r16("O\xde}\x98\xa8\xb1\xbf{5\xe81*ך6\xdeJ\x7f\x8e\x04\xc1`+*\xe8F", 18420720836993)], 4);
                                        end; 
                                    end);
                                end;
                            else
                                pcall(function(...)
                                    I = r28;
                                    v1 = I.FindFirstChild(I, r15[r16("\x17z\no\x06p\xf6\x19\xee", 7070189587676)]);
                                    if not v1 then
                                        return;
                                    end;
                                    z = r85(v1, F[NH[7]]);
                                    if not z then
                                        return;
                                    end;
                                    if r84(z[r15[r16("\x99=sb", 23284721150554)]]) >= F[NH[5]] then
                                        r64 = true;
                                        r65 = os[r15[r16("+\xe2\xb0\t", 24621571878089)]]() + F[NH[6]] * 60;
                                        r66 = r57[r15[r16("\xb2S\xeb", 11526967350519)]];
                                        T = r58 and r58[r15[r16("\xe8\x05\xdaM3\x1b\xbf\xb5B\xfeor", 31290991311083)]];
                                        if T then
                                            T = F[NH[6]];
                                            T.stopAutoFarm(T);
                                        end;
                                        q = r28[r15[r16("\xf71\r\xf0\xab\xfaO\xc2\x10", 22754149575011)]];
                                        if q then
                                            S = q.FindFirstChild(q, r15[r16("i\xa9\xe5\xa8\rҊ\xca", 12014842910170)]);
                                        end;
                                        I = true;
                                        if q then
                                            S = q[r15[r16("`\xaa\xedT'\x01\xee-", 1765125538613)]];
                                            S[r15[r16("\xfcy\x83\xb6", 26975898497297)]] = true;
                                        end;
                                        task[r15[r16("\xc0E\xc1C", 28264667181929)]](2);
                                        S = r74[r15[r16("\"\x8f\xe51d\x08~\xdb", 24583778512055)]];
                                        S.FireServer(S, {});
                                        r76(r15[r16("\xb6l\x1f\xe4\x08\xcc\xcc+\x90\xe3\x18\x0e", 23992988068772)], r15[r16("\xc7\x16\xbcM\x1dm\xfd\xb5\xd4p\x93Y", 31813256624606)] .. tostring(F[NH[6]]) .. r15[r16("\xdb\x10@\x1f\x94\xf4\x9d\xee\x88", 11010587350023)], 4);
                                    end; 
                                end);
                            end;
                        end;
                        return; 
                    end;
                    P = r24; 
                end); 
            end;
            NH[8] = {
                [NH[9]] = NH[10],
                [NH[11]] = NH[12],
                [NH[13]] = NH[14]
            };
            NH[13] = "\x7f\x0c\xbb\x01\x80_[\xa9\x07]\xbc\xbf";
            NH[10] = r15;
            NH[14] = 26475490684968;
            NH[11] = r16;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[16] = 6652084505625;
            NH[9] = NH[10][NH[12]];
            NH[4].Toggle(NH[4], NH[8], NH[9]);
            NH[9] = r15;
            NH[12], NH[27], NH[13] = "3\x80\x14\xab", 12664341665545, 10482593501969;
            NH[10] = r16;
            NH[14] = "Nr\xd5\x16";
            NH[11] = NH[10](NH[12], NH[13]);
            NH[8] = NH[9][NH[11]];
            I = JY[NH[8]];
            NH[11] = r15;
            NH[12] = r16;
            NH[17] = 8590215630752;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[8], NH[15] = "Section", "\xe3UG\x84\xcf";
            NH[8] = I[NH[8]];
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[9], NH[14] = {
                [NH[10]] = NH[11]
            }, "\xbc\xee\xbd8";
            NH[8] = NH[8](I, NH[9]);
            NH[16] = 1880231691115;
            NH[11] = r15;
            NH[12] = r16;
            NH[15] = 20797855278548;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[13] = r16;
            NH[15] = ")\xd4\xd8҈ct\x1f9v\xecI";
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[14], NH[9], NH[15] = "^Ⓙ", {
                [NH[10]] = NH[11]
            }, 3569600710270;
            NH[8].Header(NH[8], NH[9]);
            NH[11] = r15;
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[15], NH[16] = "\x8d屃(\xbd2c\xc4", 5533625403920;
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[16] = "\x17V\xef*?\x1bt";
            NH[13] = r15;
            NH[14] = r16;
            NH[18] = "\x0c\xe2r\xbd65N\xcc";
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[15] = r15;
            NH[13], NH[19] = true, 4791073884343;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[15] = function(arg1_20, ...)
                if r53 and r53[r15[r16("yڒ\x02:(\xa8p\"", 20727768245684)]] then
                    r53[r15[r16("\x9ev_DF]\xb9\x17\x10", 2042533118903)]](r15[r16("[Ky\xf8", 31298370369774)], arg1_20);
                end; 
            end;
            NH[9] = {
                [NH[10]] = NH[11],
                [NH[12]] = NH[13],
                [NH[14]] = NH[15]
            };
            NH[11] = r15;
            NH[17], NH[14] = 16503229931012, "\x1a\xf5Ӵ\xa1w\xa8J\x8a\x9d";
            NH[12] = r16;
            NH[15] = 33266881199235;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[15], NH[16] = 1971105137557, 32553271606070;
            NH[10] = NH[11][NH[13]];
            NH[8].Toggle(NH[8], NH[9], NH[10]);
            NH[19], NH[14] = 9041294725234, "e6\x0cB";
            NH[11] = r15;
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[15] = "ehw\xa6\xa9\x83\x1b\xb2";
            NH[13] = r16;
            NH[20] = 31307501910258;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[16] = "\xce\x16\xf7J;\xde\xf1";
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[15] = r15;
            NH[16] = r16;
            NH[18], NH[13] = "\xa6\xd6\xe8&\x8a,(\xfc", true;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[15] = function(arg1_21, ...)
                z = r53;
                if z then
                    P = r53[r15[r16("\xe2#\x8d@\xba\x06\xe46\x8c", 20653620651409)]];
                end;
                if z then
                    r53[r15[r16("a\xad\x14\x8d\xb2\x1b\xb5_K", 5940429703886)]](r15[r16("|G\x1c\xa9", 20568262092137)], arg1_21);
                end; 
            end;
            NH[9] = {
                [NH[10]] = NH[11],
                [NH[12]] = NH[13],
                [NH[14]] = NH[15]
            };
            NH[15] = 16760239857276;
            NH[11] = r15;
            NH[12] = r16;
            NH[14], NH[17] = "\x95м\xe0\xe9\xee\xf5\xe0\xea|", 18525365395890;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[8].Toggle(NH[8], NH[9], NH[10]);
            NH[14] = "\xc8tjz";
            NH[11] = r15;
            NH[12] = r16;
            NH[18], NH[16], NH[15] = "\x9bH\x7f\xe1\xc6]j6", 32583105002308, 28694579295281;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[15] = "\xab\xc1\xba";
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[16] = "b\xe3q\xc0\xac]\xfb";
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[14] = r16;
            NH[19], NH[23] = 20486105687363, 28898007905424;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[15] = r15;
            NH[13] = true;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[15] = function(arg1_22, ...)
                z = r53;
                if z then
                    P = r53[r15[r16("\x1e\xd6U\xa9O\xb0\xe1\xa72", 25663400079022)]];
                end;
                if z then
                    r53[r15[r16("\x89\xb7j\x19\xb9@h6\xae", 7924771802730)]](r15[r16("Y?L", 9294721667304)], arg1_22);
                end; 
            end;
            NH[9] = {
                [NH[10]] = NH[11],
                [NH[12]] = NH[13],
                [NH[14]] = NH[15]
            };
            NH[14] = "\xf1\xb7Z\x8b\x14\x99b\x13d";
            NH[11] = r15;
            NH[15], NH[16] = 22292284598412, 585840247056;
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[8].Toggle(NH[8], NH[9], NH[10]);
            NH[15], NH[14] = 18935359152753, "\xfc\x020\xc2";
            NH[11] = r15;
            NH[12] = r16;
            NH[17] = 32774878100381;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[15], NH[19] = "(*\xe9\xe1=7\x9f", 12228186117694;
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[16] = "S\xf9\xf0\xcd7\x8ch";
            NH[13] = r15;
            NH[14] = r16;
            NH[18] = "\xc6\x17\x92\x12\x1b\x95{\xf4";
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[15] = r15;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[13] = true;
            NH[14] = NH[15][NH[17]];
            NH[15] = function(arg1_23, ...)
                if r53 and r53[r15[r16("=\xe6\x0f\x0f_2\xaf\x11\r", 7237924752682)]] then
                    r53[r15[r16("k\x96\xfa\xac\xd3|\xa8\"\xd4", 18388361273714)]](r15[r16("\xd6\xd1Q\x98", 14108417808809)], arg1_23);
                end; 
            end;
            NH[9] = {
                [NH[10]] = NH[11],
                [NH[12]] = NH[13],
                [NH[14]] = NH[15]
            };
            NH[11] = r15;
            NH[12] = r16;
            NH[18], NH[14], NH[16], NH[15] = "5\x87\x1fj&\xb3\xc82", "\x8b\xa4߬\xf7\xc7\xd4\x7fZ\x8e", 22698633455945, 10807525479336;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[15] = 23921986694019;
            NH[10] = NH[11][NH[13]];
            NH[8].Toggle(NH[8], NH[9], NH[10]);
            NH[14] = "\xa7\xed\xd8q";
            NH[11] = r15;
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[12] = r15;
            NH[15], NH[17] = "\xb6^|\xafo_\x19\x07\xab\x85m'\"\xa9\x06\x95\x18Z", 15598599363679;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[14] = r16;
            NH[16] = "\x1e\x8a\xc5%\x0c\xb6\xf8!";
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[15] = 24741166574849;
            NH[13] = function(...)
                I = r74[r15[r16("'\xdbz\xa2N_\x18\x19", 9465382834487)]];
                I.InvokeServer(I, {}); 
            end;
            NH[9] = {
                [NH[10]] = NH[11],
                [NH[12]] = NH[13]
            };
            NH[11] = r15;
            NH[14] = "\t\xd1ke\xb7\x1e\xa8\x9a\x1f\x84WC\x8e\xe0\x1c\xe8";
            NH[12] = r16;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[8].Button(NH[8], NH[9], NH[10]);
            NH[15] = 11712597628238;
            NH[11] = r15;
            NH[12] = r16;
            NH[16], NH[14] = 7547891928506, "Q\x9e\\\x8f";
            NH[13] = NH[12](NH[14], NH[15]);
            NH[19], NH[15] = 9081497129092, "F\xee\xf6r\x87\x93\x1b\xd2͟\xe3\xe3\x98ߍ\xbc\x0e";
            NH[10] = NH[11][NH[13]];
            NH[17] = 26712271712406;
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[14] = r16;
            NH[16] = "鸏\xbe\xaf\x87 ";
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[15] = r15;
            NH[13] = false;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[15] = function(arg1_24, ...)
                v1 = arg1_24;
                if not r53 then
                    return;
                end;
                if v1 then
                    P = r53[r15[r16("\x81\xaa\x8c\x85\xe6\xf5CF!\xd6+\xc9\x07\x1e\x80", 24051121875903)]];
                end;
                if v1 then
                    r53[r15[r16("K\xe0\x19G\xb2o\xa0\xffV\x18\x08\xc4T`z", 569194332425)]]();
                else
                    if not arg1_24 and r53[r15[r16("\xfap\x88\x97\x8d\xec\x85\x0b\xcbK%\xe1\xe8L", 29735117796886)]] then
                        r53[r15[r16("\x1c\x04\x8e\x97xg?F\x87\xddסfG", 29991551579789)]]();
                    end;
                    return;
                end; 
            end;
            NH[9] = {
                [NH[10]] = NH[11],
                [NH[12]] = NH[13],
                [NH[14]] = NH[15]
            };
            NH[11] = r15;
            NH[16], NH[14] = 23501758769855, "\x18\x91?\x0cX\xb2\x14\xde/I";
            NH[12] = r16;
            NH[15] = 21137456424562;
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            NH[13] = "y\xf4\x05\x1b";
            NH[8].Toggle(NH[8], NH[9], NH[10]);
            NH[10] = r15;
            NH[15] = "\x82\x07\x0b\x9d";
            NH[11] = r16;
            NH[14] = 11310985548947;
            NH[12] = NH[11](NH[13], NH[14]);
            NH[9] = NH[10][NH[12]];
            I = JY[NH[9]];
            NH[17] = 18536189321655;
            NH[12] = r15;
            NH[19] = "\xf6\xb9?(\xe59>";
            NH[13] = r16;
            NH[18] = 18098214035691;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[13] = r15;
            NH[14] = r16;
            NH[16], NH[9] = "\x08\xd3@\x0f", "Section";
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[17], NH[10], NH[16], NH[9] = 8803492368387, {
                [NH[11]] = NH[12]
            }, 29836350961221, I[NH[9]];
            NH[9] = NH[9](I, NH[10]);
            NH[12] = r15;
            NH[15] = "\xf8҇y";
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[16] = "\xb2\xf2\xeb\x13\xbc?";
            NH[13] = r15;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[16], NH[17] = 9015217295462, 2576750658735;
            NH[12] = NH[13][NH[15]];
            NH[15], NH[10] = "/\xa5\xdf\xf4", {
                [NH[11]] = NH[12]
            };
            NH[9].Header(NH[9], NH[10]);
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[16] = "?\xea\x90v\x8a\xcc\xd4K}\xb1\x82\xa4";
            NH[13] = r15;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[17] = "\xa7\xfe\xa2$\x11\xfe-";
            NH[14] = r15;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[17] = r15;
            NH[20] = "\x9cѷ\xf1\xd2r/]h";
            NH[18] = r16;
            NH[19] = NH[18](NH[20], NH[21]);
            NH[16] = NH[17][NH[19]];
            NH[18] = r15;
            NH[19] = r16;
            NH[21] = "X 7\x82\xc1\x84\x88\xce\x1a\xfcPf";
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[22] = "\x91\x12\xddGe\xe5\x94\x1c";
            NH[19] = r15;
            NH[20] = r16;
            NH[21] = NH[20](NH[22], NH[23]);
            NH[23] = "\xa5\x9bt@\xec\x14\x0e";
            NH[18] = NH[19][NH[21]];
            NH[20] = r15;
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[19] = NH[20][NH[22]];
            NH[21] = r15;
            NH[22] = r16;
            NH[24] = "CD\x89_\xd3";
            NH[23] = NH[22](NH[24], NH[25]);
            NH[20] = NH[21][NH[23]];
            NH[22] = r15;
            NH[23] = r16;
            NH[25] = "e\x04a\x8d&,>d";
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[23] = r15;
            NH[26] = "\xa2C\x15\xc07\x82";
            NH[24] = r16;
            NH[25] = NH[24](NH[26], NH[27]);
            NH[22] = NH[23][NH[25]];
            NH[14] = {
                NH[15],
                NH[16],
                NH[17],
                NH[18],
                NH[19],
                NH[20],
                NH[21],
                NH[22]
            };
            NH[20], NH[21], NH[19], NH[22] = 1545132409551, "\xbaos'8\x1c\x90\x9d", "\xe5\xc9q6Jj\x05", 839611679110;
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[18] = r15;
            NH[19] = r16;
            NH[16] = 1;
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[18] = function(arg1_25, ...)
                I = r57;
                I[r15[r16("\xabv\x9d\x86k", 178603016275)]] = arg1_25; 
            end;
            NH[10] = {
                [NH[11]] = NH[12],
                [NH[13]] = NH[14],
                [NH[15]] = NH[16],
                [NH[17]] = NH[18]
            };
            NH[15], NH[16] = "\xddP\x83&\x8b\xc6_\xe86n\xa8\xc5\x1a@\xb8", 17143731773231;
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[9].Dropdown(NH[9], NH[10], NH[11]);
            NH[12] = r15;
            NH[19], NH[15], NH[16] = "\xbb\x9e\xae\xe1\x02\x95?\xa5", "\xa9\xfb7\x19", 10304994513598;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[18], NH[16] = 28856329401469, "\xfe\x0bV\xe8fb\x0cP\x8f\xedӡ\xd2tn";
            NH[13] = r15;
            NH[14] = r16;
            NH[17] = 24919769591124;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[14] = r15;
            NH[20], NH[17] = 17852886458489, "\xed\xe2\xb3dW\xa1\xfd";
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[16] = r15;
            NH[17] = r16;
            NH[14] = false;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[16] = function(arg1_26, ...)
                v1 = arg1_26;
                r61 = v1;
                if v1 then
                    r76(r15[r16("ز4\xf8\xea|", 6719636229177)], r15[r16("=\x89\xc6`]~<F%in\x12\x0b", 17016863530740)] .. (r57[r15[r16("\x1e\xa5\xa9\xb2\xb1", 16447669198315)]] or r15[r16("\xa8\xbcƫ4n\xbc", 2753454441730)]), 3);
                    I = v1;
                    if r62 and coroutine[r15[r16("]\xd5}\x98\xc8\xdf", 32488572238616)]](r62) ~= r15[r16("\x8b\x9br\xdb", 1526815703750)] then
                        return;
                    end;
                    r62 = task[r15[r16("\x06_\xb7ۖ", 2969947866470)]](function(...)
                        v1 = r61;
                        P = r24;
                        while not v1 do
                            if P then
                                v1 = r57[r15[r16("\x84\xac^\x88\xdd", 8615185682347)]] or r15[r16("\x0c\xf07UI\n\x9f", 25028574489990)];
                                if r45 and r45[v1] then
                                    pcall(F[k[8]][v1]);
                                end;
                                I = task[r15[r16("\x97\x1f\x14\x94", 21506137188126)]];
                                o = I;
                                I(r54[v1] and 1 or 2);
                            end;
                            return; 
                        end;
                        P = r24; 
                    end);
                else
                    r76(r15[r16("\xac\xe2\x7f\xf4\x9e\xe2", 3267164538353)], r15[r16("\xa4\x88p\xd2\xeb\x8fIT\x99\xe54\x1d\x12\xe8\xaeY", 33832066858378)] .. z, 3);
                    if r45 then
                        pcall(function(...)
                            if r45[r15[r16("\xea\xdaS\x93;\x13\xced}<\x95", 30521354499972)]] then
                                r45[r15[r16("@\xbfg\x009bɸb/\xa2", 5843915213473)]]();
                            end; 
                        end);
                        pcall(function(...)
                            if r45[r15[r16("\xf7p\xe9\xc6[\xcd\xe4\x85|\xa3\x17W\x8b", 16745908788853)]] then
                                r45[r15[r16("\xf96\xd9i\xa1\x9ea\xf8$\xb7\xae\x15\xb7", 26644484305015)]]();
                            end; 
                        end);
                    end;
                    return;
                end; 
            end;
            NH[10] = {
                [NH[11]] = NH[12],
                [NH[13]] = NH[14],
                [NH[15]] = NH[16]
            };
            NH[12] = r15;
            NH[20], NH[15], NH[17] = 26167570001817, "p\x12\xc6LH㴏j6Q\xb2\xad", 20358120105223;
            NH[13] = r16;
            NH[16] = 27356025041346;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[15] = "\xb8߅\xe3";
            NH[9].Toggle(NH[9], NH[10], NH[11]);
            NH[18] = 25911948881698;
            NH[12] = r15;
            NH[13] = r16;
            NH[16] = 245590966386;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[16] = "\xa1\xaf\xfe8\xbb-I\xa1\x8d\xff\x8e\x82";
            NH[13] = r15;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[14] = r15;
            NH[15] = r16;
            NH[17] = "\xd2g5s\xc2j\x95";
            NH[16] = NH[15](NH[17], NH[18]);
            NH[19] = "\xc6\xd5\x12w}\xcc[\x10";
            NH[13] = NH[14][NH[16]];
            NH[16] = r15;
            NH[14] = false;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[16] = function(arg1_27, ...)
                v1 = arg1_27;
                if r45 then
                    I = r45;
                    z = arg1_27;
                    I[r15[r16(",\xf7\x80y\x1a\xd7\xc8fw\xd2\t", 32460117195531)]] = z;
                end;
                if not r46 then
                    return;
                end;
                if v1 then
                    P = r46[r15[r16("\x7f\xf6$\xfe\x13\x04|\x81\xf3\xd9\xce\x161", 3391918442027)]];
                end;
                if v1 then
                    r46[r15[r16("\x06\xd3\xd7/\xfay6\xb5\xe1\x1c\"\x16\xcb", 27712702427752)]]();
                else
                    if not arg1_27 and r46[r15[r16(")<_\xd7\x1e+c\xacbI!\x92", 33299728874642)]] then
                        r46[r15[r16("\xc3<\xfd\xef\xab=\xb6\x8e\xe50\x95\xaf", 3570521458302)]]();
                    end;
                    return;
                end; 
            end;
            NH[10] = {
                [NH[11]] = NH[12],
                [NH[13]] = NH[14],
                [NH[15]] = NH[16]
            };
            NH[15], NH[16] = "\x17n\x00\xde\xe9%\x1b\x81\xc1\x15\xf9\xef\xa0\\\x9e", 9672062095767;
            NH[12] = r15;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            NH[9].Toggle(NH[9], NH[10], NH[11]);
            if r67 then
                NH[10] = r88();
            end;
            NH[14], NH[18], NH[19] = "\x1a\x97\xdfȋ\x92\xed1\xe9V\x99\x99", 3344019408405, 26770451689649;
            NH[11] = r15;
            NH[15] = 8420351299409;
            NH[12] = r16;
            NH[17], NH[16] = 28490291049426, "J\x06\xaeR";
            NH[13] = NH[12](NH[14], NH[15]);
            NH[10] = NH[11][NH[13]];
            I = JY[NH[10]];
            NH[13] = r15;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            NH[14] = r15;
            NH[17], NH[10] = "\xe2=\xf4\xcd", "Section";
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[11], NH[10] = {
                [NH[12]] = NH[13]
            }, I[NH[10]];
            NH[10] = NH[10](I, NH[11]);
            NH[13] = r15;
            NH[18] = 9753588142525;
            NH[14] = r16;
            NH[16], NH[17] = "9\x02e\xcd", 26273237757898;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[35], NH[17], NH[21] = 19820297741325, "8W\xe4\xed\xd0!\xc9~h=hҬ\x08Ƚ\x82a", "\xbc%\x00(\xcf-\xe33";
            NH[12] = NH[13][NH[15]];
            NH[14] = r15;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[15], NH[17] = "\xcb\xff%\xa1ŏ\xd6\xe0\x8co\xa4p", "\\'\x8b\xbf";
            NH[13] = NH[14][NH[16]];
            NH[22], NH[11] = 2859259233587, {
                [NH[12]] = NH[13]
            };
            NH[10].Header(NH[10], NH[11]);
            NH[12] = r15;
            NH[16] = 6097473850135;
            NH[13] = r16;
            NH[14] = NH[13](NH[15], NH[16]);
            NH[11] = NH[12][NH[14]];
            I = JY[NH[11]];
            NH[14] = r15;
            NH[18] = 32992873987075;
            NH[15] = r16;
            NH[20] = 24363892075601;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[18] = "\x9f\xb4\xf8[\xca";
            NH[13] = NH[14][NH[16]];
            NH[15] = r15;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[11], NH[19], NH[18] = "Section", 34519689690826, 3401673983536;
            NH[11], NH[12] = I[NH[11]], {
                [NH[13]] = NH[14]
            };
            NH[11] = NH[11](I, NH[12]);
            NH[14] = r15;
            NH[15] = r16;
            NH[17] = "\xd8\xfd\xd74";
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[15] = r15;
            NH[18] = "\xa9≤\xc4.w\xff\xd6'\x82qo\x12r\x94";
            NH[16] = r16;
            NH[37] = 30681773406159;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[18] = 29740399556120;
            NH[14] = NH[15][NH[17]];
            NH[17], NH[12] = "+\xab\xab\xbd", {
                [NH[13]] = NH[14]
            };
            NH[11].Header(NH[11], NH[12]);
            NH[19] = 12016859665883;
            NH[14] = r15;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[23], NH[18] = 3853553731330, "C\xa9\x7f\xbf\xb6\xe9@.߹\xdbI՘\xff\xfa\xe7\x05y\x80\x87";
            NH[13] = NH[14][NH[16]];
            NH[15] = r15;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[19] = "Y$k\xb9\xdd\xc0J\xa0";
            NH[14] = NH[15][NH[17]];
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[17] = "\xedЕ}";
            NH[16] = function(...)
                I = r74[r15[r16("y\x85Cx.\x03.~\xb1\xc4\xfa\xd1}", 16062164639031)]];
                I.InvokeServer(I, {
                    [r15[r16("Fu\xa7\xa5\xeb\x92-\xb4Փv\xbc", 15284024220621)]] = r15[r16("\x07\x8d\xa6=u(!\xab6\x81.\x1akSj\x80\x19M\xc3\x16\xb3\xc13<\xce2", 23011586828763)]
                }); 
            end;
            NH[12], NH[19] = {
                [NH[13]] = NH[14],
                [NH[15]] = NH[16]
            }, 21127939434094;
            NH[10].Button(NH[10], NH[12]);
            NH[14] = r15;
            NH[18] = 11399147033788;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[18], NH[20] = ",\xc9|y$\xf7\x18\x11\x00\x8f\xd4\xefܲ\xa5\r\xc5\x06\x9c`\xd4>u", 4573123512401;
            NH[15] = r15;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[16] = r15;
            NH[17] = r16;
            NH[19] = "A\xc7v\x1c\xfd\x8c<";
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[18] = r15;
            NH[19] = r16;
            NH[25], NH[16] = 13651400300756, false;
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[18] = function(arg1_28, ...)
                v1 = arg1_28;
                I = getgenv()[r15[r16("3k\x90\xd2x/", 13299592370225)]];
                I[r15[r16("|\xda\xc5Y\xd1\x01\\|\xfb6\xccO\x7f", 4818714478787)]] = v1;
                if v1 then
                    r76(r15[r16("\x9fNM\xbf\xe1\x80P\xf1\x11\x8fŉ", 23217379355195)], r15[r16("\x05\xa1\x9b\xe8\x0f[vt\x95\xdbRC\xcc\xebO\xf6b?ݖ\xec\x08^1i!\x1d!\x16\x7f\x93", 4027169146707)], 3);
                else
                    r76(r15[r16("GkS\x9c^\x00|`\x08\x98Y\x0e\x19", 30986284496989)], r15[r16(":\x16=\xb0\xee\xbc\x0e\x93\x07\xa6\x17\xd9zS\x8e!A2\xa1ѹ\x99y\xd5u\xdcu3\xba\xb8\x0b!", 20493124445510)], 3);
                end; 
            end;
            NH[22], NH[12] = 18117698183412, {
                [NH[13]] = NH[14],
                [NH[15]] = NH[16],
                [NH[17]] = NH[18]
            };
            NH[18], NH[19], NH[17] = 7419087605118, 18608481231321, "VdWK\xfaf`\r\x03\xe5\x1d\xbc\x8d,\x1c\xaa\x8b\xa9\x0c\xc1\xd0\xcc[";
            NH[14] = r15;
            NH[15] = r16;
            NH[33] = "B\x9c^|\x83Z\xec\xb8";
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[10].Toggle(NH[10], NH[12], NH[13]);
            NH[40] = 29154529096968;
            NH[14] = r15;
            NH[21], NH[20], NH[17] = "\x91r\xef\x17*6@\x9c", 10989609063421, "\xc8\xe1ě";
            NH[15] = r16;
            NH[18] = 23514614819525;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            NH[15] = r15;
            NH[16] = r16;
            NH[18] = "\x05\xbd\xf3.a'\x9b\xa4\xa5\xb9\x07H\xa0PH\xec";
            NH[17] = NH[16](NH[18], NH[19]);
            NH[19] = "tIG\x01ӣ\xc4&";
            NH[14] = NH[15][NH[17]];
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[16] = function(...)
                I = r74[r15[r16("v\xf3\xf8k\xb6!\xd4\xf3\x01\xad:6\x0b\x93\xe0R\xefNi\x86U\xad\xd6", 33186676915293)]];
                I.InvokeServer(I, {}); 
            end;
            NH[27], NH[12] = ".\xca\xdfxUU\x06\xa4.\x1bK\xe4\x95", {
                [NH[13]] = NH[14],
                [NH[15]] = NH[16]
            };
            NH[11].Button(NH[11], NH[12]);
            NH[14] = r15;
            NH[15] = r16;
            NH[18], NH[19] = 27028832530730, 4295528024016;
            NH[17] = "\xa0_\xc0\xd5";
            NH[16] = NH[15](NH[17], NH[18]);
            NH[20] = 1346324218482;
            NH[13] = NH[14][NH[16]];
            NH[15] = r15;
            NH[18] = "\xfc\x1b\x85}\xb3\xeazz\x87Rs\xc7)4K&\x8cn\xf3\xe7$";
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[19] = "\xca*.K\x14\x01\x1d";
            NH[14] = NH[15][NH[17]];
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[16] = false;
            NH[18] = r15;
            NH[19] = r16;
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[18] = function(arg1_29, ...)
                v1 = arg1_29;
                if type(getgenv()[r15[r16("\x81\x88\x15\xb2\x14\x0f", 14049116166542)]][r15[r16("F\x0b%\xc46\xceo\xe1\x03\xe3\xaa", 7443798068618)]]) ~= r15[r16("\x19KF\xe1!j\x1dK", 15926200065272)] then
                    r76(r15[r16("@-\xc5\xc4S", 5635195750976)], r15[r16("\xf6%\x95^+\xebϱL\xb2\x10Jc\x9d5\xdd\xcd\x00\x8d\x938\x90\x81\x1c_\x98\x81U$\x17\x15^\x9e\x94", 10845472052154)], 3);
                    return;
                end;
                getgenv()[r15[r16("o\xa3tߝ\xc8", 15261517650882)]][r15[r16("\x89:\x84\xb6Cؿx\xc3\x1dG", 191223201881)]](v1);
                if v1 then
                    r76(r15[r16("\x19,3\x81\x84܈r\x07\xad\xd3{", 22862331734422)], r15[r16("\x9dg\xe7\x11\x1e\xf1y\x1b\x0e)QUoF0\xe5\x06\xd5)A\xa6ĸN\x19ڰ\xfa\xf2", 4441037637652)], 3);
                else
                    r76(r15[r16("\xa3^\xa8Z\xc8\xd4\x1b%,c\xf7\x06\x9b", 16253387857296)], r15[r16("ʡ\xddf| |Nc/\xa5\x1f~ڌ%\x8be\x16\xfb\xae\xf6'˶\x07\x14I\x9e\xec", 2961983849827)], 3);
                end; 
            end;
            NH[21], NH[43], NH[12] = 6232312695638, 4989016541459, {
                [NH[13]] = NH[14],
                [NH[15]] = NH[16],
                [NH[17]] = NH[18]
            };
            NH[14] = r15;
            NH[17], NH[20], NH[18] = "\xf2\xbalm\xa7\x87\xd4V$\xd0\xe8UN\x16\xe0\xf7\x03&\xc1\x0c\\", 32025747995201, 27452624466415;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[24], NH[18] = "\xd3\x12\x91c\x8a\xbf\x1b\x0c", "\xe4F\x06\xbe";
            NH[13] = NH[14][NH[16]];
            NH[19] = 24089923283921;
            NH[11].Toggle(NH[11], NH[12], NH[13]);
            NH[17], NH[16] = 27652534891084, "24\xf2\x8a\x85J\x02";
            NH[13] = r15;
            NH[14] = r16;
            NH[15] = NH[14](NH[16], NH[17]);
            NH[12] = NH[13][NH[15]];
            I = JY[NH[12]];
            NH[15] = r15;
            NH[16] = r16;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[19] = "\xda)\xf2j";
            NH[14] = NH[15][NH[17]];
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[12] = "Section";
            NH[15] = NH[16][NH[18]];
            NH[19], NH[12], NH[13], NH[18] = 30511794141056, I[NH[12]], {
                [NH[14]] = NH[15]
            }, "D\x92\x92\xa9";
            NH[12] = NH[12](I, NH[13]);
            NH[22] = 32646374865762;
            NH[15] = r15;
            NH[16] = r16;
            NH[20] = 2205143548930;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[19] = "V\xde\xf8yw\xc1iG\x16s\x8c\xce\xf3";
            NH[14] = NH[15][NH[17]];
            NH[26] = 4890656147685;
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[13], NH[19] = {
                [NH[14]] = NH[15]
            }, 1660090368773;
            NH[12].Header(NH[12], NH[13]);
            NH[15] = r15;
            NH[18] = "\xeco\x10\x82";
            NH[16] = r16;
            NH[20] = 18544801391035;
            NH[17] = NH[16](NH[18], NH[19]);
            NH[19] = "o\xc1l\x8d\xf6$\x8cU#NAěm\xfc\xaa\x07\xaa\xb5^\xf7";
            NH[14] = NH[15][NH[17]];
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[20] = "\xf0\xf9Y\x80\x1e\xb9Fbp";
            NH[15] = NH[16][NH[18]];
            NH[17] = r15;
            NH[18] = r16;
            NH[19] = NH[18](NH[20], NH[21]);
            NH[16] = NH[17][NH[19]];
            NH[18] = r15;
            NH[21] = "2;\xe5\t\xf6\xde\xe9YԄ\xf8\xb6\xa9\xb2\x8e\x9a\x85\x7fL\xd9KX\x85\\\xef\xbf\xf4\x18K݂\xf8\x86i\xce\x02o\xaf\xc0:\xba\xc7BDm\xfe!%\x0f\x03\x11\x01b\xfa\x95\x1b\xa8\x95\x9b\x13xv\x84\xfbp\x97=\\\x88&\x87\xd7v\x0c\x7f\xdff7\xc2\xfa\xdf\xe4M\xc1\t\xb5t\xcb|\x10\x967\xc1\n\x15\x0e\xd5m]\xfd";
            NH[19] = r16;
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[19] = r15;
            NH[22] = "6\x9ae\xc2\xc7\xc1;";
            NH[20] = r16;
            NH[21] = NH[20](NH[22], NH[23]);
            NH[18] = NH[19][NH[21]];
            NH[21] = r15;
            NH[22] = r16;
            NH[19] = false;
            NH[23] = NH[22](NH[24], NH[25]);
            NH[8] = nil;
            NH[20] = NH[21][NH[23]];
            NH[21] = function(arg1_30, ...)
                v1 = arg1_30;
                if v1 then
                    P = not r80();
                end;
                if v1 then
                    r60 = false;
                    return;
                end;
                r60 = v1;
                if v1 then
                    task[r15[r16("\xae\x01\x95V\xc7", 20976617580072)]](function(...)
                        v1 = r60;
                        P = v1;
                        while not v1 do
                            if P then
                                task[r15[r16("S\xb0m\x02", 22462034962651)]](5);
                                if not r60 then
                                    break;
                                else
                                    pcall(function(...)
                                        I = r28;
                                        v1 = I.FindFirstChild(I, r15[r16("\xa8\x9b\xfc\xf3X\x17\xb3a\xaf", 24641009380562)]);
                                        if not v1 then
                                            return;
                                        end;
                                        z = v1.FindFirstChild(v1, r15[r16(">\x95]\xa5O\xabV}\x01Ԗ", 18978922406533)]);
                                        if not z then
                                            return;
                                        end;
                                        o = z.FindFirstChild(z, r15[r16("\x14\x02\xeb\xf8\xf5\x9d2\x94j\xf7", 14306495388165)]);
                                        if not o then
                                            return;
                                        end;
                                        T = r15;
                                        W = o.FindFirstChild(o, r15[r16("\x9f\xfa\x16C\x01", 28936537404578)]);
                                        T = o.FindFirstChild(o, T[r16("\x18c\x8c\x11r\xd2b\xb0\x88\x81\x08", 20325246625016)]);
                                        if not W or not T then
                                            return;
                                        end;
                                        if W[r15[r16("\x80^q\xc1", 32424193571578)]] == r15[r16("v~\xf0\xb5D\xad\xb5G\x07#", 7801281465904)] then
                                            M = {
                                                T.GetChildren(T)
                                            };
                                            for S, p in ipairs(K("ipairs")) do
                                                L = S;
                                                v2 = p.FindFirstChild(p, r15[r16("\xdd \xfdE\xe6\xf4q\xdb\x04", 27769044710018)]);
                                                if v2 then
                                                    b = v2[r15[r16("\xa1\xe5\x9b\xd9", 13166021531634)]] == r15[r16("\x10\x85\r", 13436477233264)];
                                                end;
                                                if v2 then
                                                    firesignal(p[r15[r16("\x05\xa2\x8e٥f\x0cxx", 3430144656957)]]);
                                                    r76(r15[r16("+<\xc7\xed\x99\xea\x00U", 28427539198901)], r15[r16("\xc2:\xb6\xef\xf0\x9e\x11\xdb\xfb\xe8P\x93\xa9\xa3\x0b\xddJo\x01\xf7S\xde \xd3@\x16\x13\xcf\xc9ȧy\xe2", 13627700435145)], 3);
                                                end; 
                                            end;
                                        end; 
                                    end);
                                end;
                            end;
                            return; 
                        end;
                        P = r24; 
                    end);
                    r76(r15[r16("\xf0\xf8\x7f\xf8\x9e;$\x86", 26292476391379)], r15[r16("\x05\x1f\x91C\xe7.\x9c\x9b\xe2\xe5߹û\xb8I\xb9m\x81\x80_\xb4y\x1b\x0f", 32868576836553)], 3);
                else
                    r76(r15[r16("Xߧ\x173\x81Wk", 29881088292442)], r15[r16("\xf9\xe7\x89|\x1c\xf5\xd7\x1e*\xcf\xdb\n\x12\xd5\xf1w\x17\x1bB\xe5\x8b\x16\x1eJ\xeb\xcc", 29254460241206)], 3);
                end; 
            end;
            NH[13] = {
                [NH[14]] = NH[15],
                [NH[16]] = NH[17],
                [NH[18]] = NH[19],
                [NH[20]] = NH[21]
            };
            NH[20] = 18160011419912;
            NH[15] = r15;
            NH[19] = 25136829197753;
            NH[16] = r16;
            NH[18] = "\xd8G\xffJN\xb3\xf8\x05\xbd\xd8d";
            NH[17] = NH[16](NH[18], NH[19]);
            NH[14] = NH[15][NH[17]];
            NH[17], NH[22] = "\xc6Eo\xdf<\\:", 26597467680865;
            NH[12].Toggle(NH[12], NH[13], NH[14]);
            NH[18] = 22349251094695;
            NH[14] = r15;
            NH[15] = r16;
            NH[16] = NH[15](NH[17], NH[18]);
            NH[13] = NH[14][NH[16]];
            I = JY[NH[13]];
            NH[21] = 21978205087738;
            NH[16] = r15;
            NH[23], NH[25] = "\xa7۴\x95i\x07G", ";\xbc\x9aל\xbc\xf3";
            NH[17] = r16;
            NH[19] = "\xb6\xba \x8e";
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[17] = r15;
            NH[20] = ";m@\x82\xb0";
            NH[18] = r16;
            NH[19] = NH[18](NH[20], NH[21]);
            NH[16] = NH[17][NH[19]];
            NH[19], NH[13], NH[24] = "/_\xa6\xe0", "Section", 21100298233441;
            NH[13], NH[20] = I[NH[13]], 17676673130535;
            NH[14] = {
                [NH[15]] = NH[16]
            };
            NH[13] = NH[13](I, NH[14]);
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[17] = r15;
            NH[21], NH[20] = 20365154968843, "\xa7!qC$J\x93<*#\x02,\x1a";
            NH[18] = r16;
            NH[19] = NH[18](NH[20], NH[21]);
            NH[16] = NH[17][NH[19]];
            NH[21], NH[20], NH[30], NH[19], NH[14] = 1037102416354, 23638295472895, 27352691126721, "\xdc@\x9e\x00", {
                [NH[15]] = NH[16]
            };
            NH[13].Header(NH[13], NH[14]);
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[17] = r15;
            NH[20] = "\xa1\x1b\x7f\xe7\xf7\xae\xfd3ZȘ\xd6\n";
            NH[18] = r16;
            NH[19] = NH[18](NH[20], NH[21]);
            NH[16] = NH[17][NH[19]];
            NH[28] = 5064495876406;
            NH[18] = r15;
            NH[19] = r16;
            NH[21] = "NH\xa5\x18\xad\xf8\xac";
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[20] = r15;
            NH[18], NH[29] = 40, 6892543724681;
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[19] = NH[20][NH[22]];
            NH[20] = 0;
            NH[22] = r15;
            NH[23] = r16;
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[31] = "\x00%\x80\xaae\xca\xca";
            NH[24] = r15;
            NH[22] = 100;
            NH[25] = r16;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[25] = r15;
            NH[26] = r16;
            NH[28] = "\x0f\xd5t\xcf\x12\x0b\x0e";
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[26] = r15;
            NH[27] = r16;
            NH[29] = "\xb1\xca$I\x80wF\xca";
            NH[28] = NH[27](NH[29], NH[30]);
            NH[25] = NH[26][NH[28]];
            NH[26] = function(arg1_31, ...)
                I = r57;
                I[r15[r16("\"&\x0b2 \xc7iE\xc1M\x81", 29705505256968)]] = arg1_31; 
            end;
            NH[14] = {
                [NH[15]] = NH[16],
                [NH[17]] = NH[18],
                [NH[19]] = NH[20],
                [NH[21]] = NH[22],
                [NH[23]] = NH[24],
                [NH[25]] = NH[26]
            };
            NH[20], NH[19] = 25871466131215, "\x8fV\x10\x14>\xcc`'츎_S-Ϣ;";
            NH[16] = r15;
            NH[29] = 16880657424052;
            NH[17] = r16;
            NH[22], NH[21] = 11012340651016, 23457670556331;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[19], NH[28], NH[20], NH[48] = "\xbf\x1e\x0b\xca", 3597013255818, 6474814409671, 11473512682718;
            NH[15] = NH[16][NH[18]];
            NH[24] = 3714635892417;
            NH[13].Slider(NH[13], NH[14], NH[15]);
            NH[16] = r15;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[15] = NH[16][NH[18]];
            NH[20] = "Q\xd2\xe3\xc9\xe6og\xbf";
            NH[17] = r15;
            NH[18] = r16;
            NH[19] = NH[18](NH[20], NH[21]);
            NH[16] = NH[17][NH[19]];
            NH[21] = "\x1d\x03喅\x1fg";
            NH[18] = r15;
            NH[25] = "\tĿ\xef\xaaÁ";
            NH[19] = r16;
            NH[20] = NH[19](NH[21], NH[22]);
            NH[17] = NH[18][NH[20]];
            NH[23], NH[18], NH[30], NH[26] = "\xca\xfb\xb0ZIU\xd1", 100, 9511057166668, 31258952038620;
            NH[20] = r15;
            NH[21] = r16;
            NH[27] = "\x88]\xb8\xcd\xff4\x95\\5z\x98q\x19";
            NH[6] = nil;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[19] = NH[20][NH[22]];
            NH[22] = r15;
            NH[20] = 0;
            NH[23] = r16;
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[24] = r15;
            NH[22] = 100;
            NH[25] = r16;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[25] = r15;
            NH[26] = r16;
            NH[28] = "\xc5ݱP\xbf\x7f0";
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[29] = "\xcb\xfeky\xc7\xdf{N";
            NH[26] = r15;
            NH[27] = r16;
            NH[28] = NH[27](NH[29], NH[30]);
            NH[25] = NH[26][NH[28]];
            NH[28] = 17835473805425;
            NH[26] = function(arg1_32, ...)
                I = r57;
                I[r15[r16("\xe2\xf9\xc0\x00Fdo\xe7\xad8", 7027157929160)]] = arg1_32; 
            end;
            NH[14] = {
                [NH[15]] = NH[16],
                [NH[17]] = NH[18],
                [NH[19]] = NH[20],
                [NH[21]] = NH[22],
                [NH[23]] = NH[24],
                [NH[25]] = NH[26]
            };
            NH[16] = r15;
            NH[24], NH[23], NH[19], NH[20] = 23138757601814, "\xb1XH\x82", "\xaa\xaaܢ\x96\xb9\xb5\xd0\x10\xbf/P\x02\xf5\xc58", 10123824517738;
            NH[17] = r16;
            NH[18] = NH[17](NH[19], NH[20]);
            NH[25] = 33319634320539;
            NH[15] = NH[16][NH[18]];
            NH[16] = true;
            NH[17] = 116;
            NH[18] = 117;
            NH[13].Slider(NH[13], NH[14], NH[15]);
            NH[15], NH[14] = true, true;
            F[NH[17]] = true;
            F[NH[18]] = NH[14];
            NH[14] = 118;
            F[NH[14]] = NH[15];
            NH[15] = 119;
            F[NH[15]] = NH[16];
            NH[20] = r15;
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[24] = "\xf7\x8a\xfc\x9djj(\x1aL";
            NH[19] = NH[20][NH[22]];
            NH[21] = r15;
            NH[22] = r16;
            NH[23] = NH[22](NH[24], NH[25]);
            NH[20] = NH[21][NH[23]];
            NH[25], NH[26] = "n\x89O\xa1\x0f\xd4\x13", 7808029249075;
            NH[22] = r15;
            NH[23] = r16;
            NH[24] = NH[23](NH[25], NH[26]);
            NH[29] = "\x0c\x81\x0ex\x8a\x15\xd2\xfd";
            NH[21] = NH[22][NH[24]];
            NH[27], NH[22] = "7\xfd\x0f\xe8|{\ra", true;
            NH[24] = r15;
            NH[25] = r16;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[24] = function(arg1_33, ...)
                if not r80() then
                    return;
                end;
                F[NH[17]] = arg1_33; 
            end;
            NH[16] = {
                [NH[19]] = NH[20],
                [NH[21]] = NH[22],
                [NH[23]] = NH[24]
            };
            NH[20] = r15;
            NH[23] = "\x97\xfb$2n\xd5\xcd";
            NH[21] = r16;
            NH[24] = 27389722472914;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[26], NH[23] = 10365361787610, "2 \x9b*";
            NH[19] = NH[20][NH[22]];
            NH[13].Toggle(NH[13], NH[16], NH[19]);
            NH[24] = 32944858463213;
            NH[20] = r15;
            NH[28] = 19738691445735;
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[19] = NH[20][NH[22]];
            NH[25] = 5000352794904;
            NH[21] = r15;
            NH[24] = "u\xb7_i\xcd|魜\xf11\xb3\"";
            NH[22] = r16;
            NH[23] = NH[22](NH[24], NH[25]);
            NH[25] = "_\x19\x83\xbd\x9f\xa7\xd8";
            NH[20] = NH[21][NH[23]];
            NH[27] = "!\xe6ca\xca\xd0v8";
            NH[22] = r15;
            NH[23] = r16;
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[24] = r15;
            NH[25] = r16;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[28] = 22143612348487;
            NH[23] = NH[24][NH[26]];
            NH[24] = function(arg1_34, ...)
                if not r80() then
                    return;
                end;
                F[NH[18]] = arg1_34; 
            end;
            NH[22] = true;
            NH[16], NH[25] = {
                [NH[19]] = NH[20],
                [NH[21]] = NH[22],
                [NH[23]] = NH[24]
            }, 8192614813414;
            NH[23] = "\xe2\x1d\x1f\xe8^J\xd7r\x82\xb9\x91";
            NH[20] = r15;
            NH[24], NH[50] = 22677025925439, "p\xa0\xca!Xi\x9d6";
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[24], NH[23] = 30730516772838, "\xe0\x19\xedB";
            NH[19] = NH[20][NH[22]];
            NH[13].Toggle(NH[13], NH[16], NH[19]);
            NH[20] = r15;
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[26] = 23714128341794;
            NH[19] = NH[20][NH[22]];
            NH[21] = r15;
            NH[24] = "\xb2\x05\xac.Q\x80\xf8CB\xcb|4";
            NH[22] = r16;
            NH[23] = NH[22](NH[24], NH[25]);
            NH[20] = NH[21][NH[23]];
            NH[25], NH[27] = "\xf6\n\x15\xd2\x0e\xcc4", "\xa9\x8c7\xea\x05\xd6j\x9c";
            NH[22] = r15;
            NH[23] = r16;
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[24] = r15;
            NH[25] = r16;
            NH[22], NH[42] = true, 30516161836930;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[24] = function(arg1_35, ...)
                if not r80() then
                    return;
                end;
                F[NH[14]] = arg1_35; 
            end;
            NH[16] = {
                [NH[19]] = NH[20],
                [NH[21]] = NH[22],
                [NH[23]] = NH[24]
            };
            NH[24], NH[26], NH[23], NH[27], NH[25], NH[28] = 29292913063240, 1001084682706, "\x89\x14\x93UZ\xe4\x80{`\xd9", "4\x14ڿB\xb9\x94y", 27208108224893, 20773103510985;
            NH[20] = r15;
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[19] = NH[20][NH[22]];
            NH[23] = "D\xa1\xe8\xf4";
            NH[13].Toggle(NH[13], NH[16], NH[19]);
            NH[20] = r15;
            NH[21] = r16;
            NH[24] = 28604784489480;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[19] = NH[20][NH[22]];
            NH[21] = r15;
            NH[24] = "aB\x1f\xd5<-l\x03ڝ\x0c\xd5";
            NH[22] = r16;
            NH[23] = NH[22](NH[24], NH[25]);
            NH[20] = NH[21][NH[23]];
            NH[22] = r15;
            NH[23] = r16;
            NH[25] = "\xc96\x06?\xed\xfe\xe4";
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[24] = r15;
            NH[25] = r16;
            NH[22], NH[30] = true, 2700519359721;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[24] = function(arg1_36, ...)
                if not r80() then
                    return;
                end;
                F[NH[15]] = arg1_36; 
            end;
            NH[16], NH[26], DY = {
                [NH[19]] = NH[20],
                [NH[21]] = NH[22],
                [NH[23]] = NH[24]
            }, 26872550813921, nil;
            NH[23] = ",\xfe\xaf\xf6\xbcO\x11\x13\xeb-";
            NH[20] = r15;
            NH[24] = 21729241393030;
            NH[21] = r16;
            NH[22] = NH[21](NH[23], NH[24]);
            NH[27] = 27247917937040;
            NH[19] = NH[20][NH[22]];
            NH[13].Toggle(NH[13], NH[16], NH[19]);
            NH[16] = 120;
            NH[25] = "\x00\x1d\x10'";
            F[NH[16]] = false;
            NH[19] = 121;
            F[NH[19]] = nil;
            NH[22] = r15;
            NH[28] = 10002539844145;
            NH[23] = r16;
            NH[10] = nil;
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[23] = r15;
            NH[24] = r16;
            NH[26] = "\xb0VY\x04\xe0\xafN\xaf'\x8dI\x14\x00\x1e\xb7";
            NH[25] = NH[24](NH[26], NH[27]);
            NH[22] = NH[23][NH[25]];
            NH[27] = "lP\xb5\x95p\xbc\xa7";
            NH[24] = r15;
            NH[25] = r16;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[24] = false;
            NH[26] = r15;
            NH[27] = r16;
            NH[28] = NH[27](NH[29], NH[30]);
            NH[25] = NH[26][NH[28]];
            NH[26] = function(arg1_37, ...)
                v1 = arg1_37;
                r59 = v1;
                if not r80() then
                    return;
                end;
                if v1 then
                    r76(r15[r16("\xa5S\xce#", 30962553829458)], r15[r16("\x1b\xb7D?\xdc\xdb\x13\x9d1\x02\xa7\xa1\x1b~\xdd\x1a\xf2Ҵ", 6077119777549)], 10);
                    F[NH[16]] = false;
                    F[NH[19]] = task[r15[r16("\xc9\x01m\xfa\x10", 6297532631924)]](function(...)
                        v1 = r59;
                        P = r24;
                        while not v1 do
                            if P then
                                if not pcall(function(...)
                                    z = v1;
                                    r106 = r57[r15[r16("(@\r\xe2or\xe4F\xd4\xf7", 15588176944218)]] or 90;
                                    o = r57[r15[r16("\xb2\xb5\x8d", 13324690561084)]];
                                    P = r27;
                                    W = P.WaitForChild(P, r15[r16("'\x8bd\x03\xd6", 22782663682417)]);
                                    W = W.FindFirstChild(W, r28[r15[r16("Q\x927\xac", 3542562457201)]]);
                                    if W then
                                        P = W.FindFirstChild(W, r15[r16("j\xb0\x9a\x05q\xf9Mi", 11459952776408)]);
                                    end;
                                    if not W then
                                        return;
                                    end;
                                    q = {};
                                    if F[NH[17]] and W.FindFirstChild(W, r15[r16("\xe7\x91[", 30590692931492)]) then
                                        table[r15[r16("*Q\xaev]C", 21378036262626)]](q, W[r15[r16("\x82M\xe4", 3665303144106)]][r15[r16("\x9cwA\x81\x9b", 28351179289490)]]);
                                    end;
                                    if F[NH[18]] and W.FindFirstChild(W, r15[r16("\x8a\xe7$\xe9\xcf\xe0\xcb", 26378389057531)]) then
                                        table[r15[r16("XO\x17\x80\x86\xcd", 14030664948101)]](q, W[r15[r16("6\x82\xcao\xb3}o", 12905498646393)]][r15[r16("Y\xf4\x9f\xfdm", 13871042877755)]]);
                                    end;
                                    if F[NH[14]] and W.FindFirstChild(W, r15[r16("y\xcd_\xa2n\xec", 9576809615723)]) then
                                        table[r15[r16("\x87\x85\x01\xe3\xc7\xfa", 21098113459808)]](q, W[r15[r16("\x9e\xc8ם\xe3X", 2400799114333)]][r15[r16("i\x8d\xab\x92\xa0", 31720421964210)]]);
                                    end;
                                    M = F[NH[15]];
                                    if M then
                                        P = W.FindFirstChild(W, r15[r16("\x10b\x9a\x92I\xf9", 15206654417833)]);
                                    end;
                                    I = v1;
                                    if M then
                                        table[r15[r16("٠\x1d\xe3&\x80", 31005583603814)]](q, W[r15[r16("\x98\x14\x84\xee;k", 23744158083888)]][r15[r16("\x19\x8e\xa0\x16Y", 16207739100539)]]);
                                    end;
                                    if #q > 0 then
                                        S = math[r15[r16("3\x0c\xc8", 16594315025967)]](table[r15[r16("\x99/\xf0\xc0W\xbc", 10289027371703)]](q));
                                    end;
                                    L = I;
                                    I = L;
                                    if (r57[r15[r16("\xa6\xd7\x7f\xd0e\xf6\xa0T״:", 12658839148294)]] or 10) > 0 and o then
                                        F[NH[16]] = true;
                                        r76(r15[r16("\xce\xd6\x12c`Kߥ\x11C", 7895917809244)], r15[r16("\xab\x1d\x05¨fM:)\x06\x8a\xbd\x85>\xfc\x0b\x10\xef\xa9", 8657860857791)] .. math[r15[r16("\x1asERL", 20291567232232)]](100) .. r15[r16("\x05\x17\xb8\x01\xe7\xc8]ħ:v6\x0e\xece\x96\x08¹\xa0.", 10596437185350)], 5);
                                        L = r28[r15[r16("\x08\x9f\x14\x04\xf0\x13\xea\x1aF", 4436042582033)]];
                                        if L then
                                            p = L.FindFirstChild(L, r15[r16("B\xa6\xee\x00wųU", 26368687009782)]);
                                        end;
                                        if L then
                                            p[r15[r16("\x98\xe4\xfc\xa3", 16893969817274)]] = true;
                                        end;
                                        task[r15[r16("\x06&\xac\xdc", 17094881730328)]](1);
                                        if r58 and r58[r15[r16("\x86\xa6\xf8r^\xaa\x85\x19\xd8\xd6:\xe3", 6772491865169)]] then
                                            v2 = r58;
                                            v2.stopAutoFarm(v2);
                                        end;
                                        b = r74[r15[r16("\xca\x07\x84WN\xaf", 30218660378359)]];
                                        b.InvokeServer(b, {
                                            [r15[r16("ρ%\xb5\x94\xce", 4693173307529)]] = r28[r15[r16("\x11\xaf\tP", 10315054322371)]]
                                        });
                                        task[r15[r16("\xec\xe4\xc1\xe7", 6494241049552)]](4);
                                        b = r74[r15[r16("\xc23ᙶ\xfd\rx", 99494150190)]];
                                        b.FireServer(b, {});
                                        task[r15[r16("q\x99\x98|", 31693090584998)]](.3);
                                        b = r74[r15[r16("\x91Q\x9f\\\xf9\xba\x82\xa4", 10159544210042)]];
                                        b.FireServer(b, {});
                                        l = r16;
                                        task[r15[l("\x17*\x04Q", 28450673439680)]](1);
                                        if r52 and r52[r15[r16("\x0e͋e;\xa5\x14\xca\xf3%\x1b\x81", 22887107537313)]] then
                                            if not pcall(function(...)
                                                r52[r15[r16("\r0\x8d\x0e-\xd5\xe6\t4\x99\xae\xad", 24190209158144)]]({
                                                    [r15[r16("U\xe8r|E", 6171799980857)]] = r106,
                                                    [r15[r16("\xa00\xb5", 1573778309852)]] = F[NH[17]],
                                                    [r15[r16("]\x15.\xffy\xafS", 33767018773867)]] = F[NH[18]],
                                                    [r15[r16("\xb7o*%\xd4$", 27269913457050)]] = F[NH[14]],
                                                    [r15[r16("pEz\x8a%&", 3974577424186)]] = F[NH[15]]
                                                }); 
                                            end) then
                                                warn(r15[r16("\xf4O\xd9L)\xc1\x7f\x94cZx\x0bo", 30303068632862)], l[2]);
                                            end;
                                        else
                                            warn(r15[r16("\xbe\xb2\x9a\x8a\xba\xbe~8\x8e,B\x05\x05\xa0O\xc0\xb2e\x0cE\x00Q", 7292195769667)]);
                                        end;
                                        task[r15[r16("&\xc1\xf9\x01", 23701887593245)]](1);
                                        l = (function(...)
                                            I = r27;
                                            P = I.WaitForChild(I, r15[r16("Hhoq\x95", 34980161028000)]);
                                            v1 = P.FindFirstChild(P, r28[r15[r16("0\x87\x8d\xc1", 18862854611535)]]);
                                            z = v1 and v1.FindFirstChild(v1, r15[r16("\xa5\xdf{A\x9ea\xa4P", 23499934886591)]);
                                            if not z then
                                                return true;
                                            end;
                                            if F[NH[17]] and z[r15[r16("y\xac\xf1", 16390103948752)]][r15[r16("\x14\x07H\x97?", 29151881999622)]] < r106 then
                                                return false;
                                            end;
                                            if F[NH[18]] and z[r15[r16("\x82K\xa8?=aH", 31395852695835)]][r15[r16("\xf7^궓", 25047964806543)]] < r106 then
                                                return false;
                                            end;
                                            if F[NH[14]] and z[r15[r16("ge䇹N", 14259077126639)]][r15[r16("\x97/\n\x8a\xee", 6807917775970)]] < r106 then
                                                return false;
                                            end;
                                            if F[NH[15]] and z[r15[r16("%\xf8\x9f\xdf<\xc0", 29484007388577)]][r15[r16("\xc2\x99\xbd\xce\xfe", 5443392031206)]] < r106 then
                                                return false;
                                            end;
                                            return true; 
                                        end)();
                                        i = l;
                                        while l do
                                            I = L;
                                            if i then
                                                i = r74[r15[r16("\xb4;\x0b\xe5\xa1_", 11394517030073)]];
                                                i.InvokeServer(i, {
                                                    [r15[r16("\x19-\x14/", 12215883896376)]] = o
                                                });
                                                task[r15[r16("\xb3'\xdd\xcf", 18736175866388)]](3);
                                                i = r83()[o];
                                                l = w;
                                                if i then
                                                    w = i[r15[r16("\x8d\xea\xb8v;\x87\x07=\xf9\xa7\xcd]3", 16087690337603)]];
                                                end;
                                                I = l;
                                                if i then
                                                    i.startAutoFarm(i);
                                                    r58 = i;
                                                    r76(r15[r16("\xb4\xbcs\x05\xf8\xe4H%\x12\x86\xdb", 22530938218747)], r15[r16("{\x11$\xfb\xf6+\xa8υ\x9f_[Wj{1S\xbe", 25230416932324)] .. r57[r15[r16("\xb2\xb5\x8d", 13324690561084)]], 3);
                                                end;
                                                F[NH[16]] = false;
                                                break;
                                            end; 
                                        end;
                                        i = tick() > tick() + 60;
                                    end; 
                                end) then
                                    warn(r15[r16("\xddA>\xf1q$?\x9f\x1c\xc6T\xa8\xdfs\xb4\x11", 16187184487793)], o[2]);
                                end;
                                task[r15[r16("\xa0\r6\xa5", 19039656698530)]](5);
                            end;
                            return; 
                        end;
                        P = r24; 
                    end);
                else
                    r76(r15[r16("\xc1\xb1\x8c[", 205589037151)], r15[r16("\x11\xa1\xf8\xb8\x9cM㭰Tw\x8bSB&(\xd1\xf1", 9453485838642)], 3);
                    if F[NH[19]] then
                        task[r15[r16("\xd0\xe5]\x14}A", 6742392130627)]](F[NH[19]]);
                        F[NH[19]] = nil;
                    end;
                    F[NH[16]] = false;
                    return;
                end; 
            end;
            NH[20] = {
                [NH[21]] = NH[22],
                [NH[23]] = NH[24],
                [NH[25]] = NH[26]
            };
            NH[26] = 24395798195296;
            NH[22] = r15;
            NH[32] = 18340233470300;
            NH[23] = r16;
            NH[27], NH[25] = 8316170440480, "\x98\xa2\xcfH3`\xddģG\xd0\x1a\xfd";
            NH[24] = NH[23](NH[25], NH[26]);
            NH[21] = NH[22][NH[24]];
            NH[13].Toggle(NH[13], NH[20], NH[21]);
            NH[25] = 15625285819500;
            NH[21] = r15;
            NH[28], NH[24] = 22978444863948, "\x9dM\x8a\x83~";
            NH[22] = r16;
            NH[23] = NH[22](NH[24], NH[25]);
            NH[20] = NH[21][NH[23]];
            I = JY[NH[20]];
            NH[23] = r15;
            NH[26], NH[20] = "[R\xc4\xf9", "Section";
            NH[24] = r16;
            NH[25] = NH[24](NH[26], NH[27]);
            NH[22] = NH[23][NH[25]];
            NH[24] = r15;
            NH[25] = r16;
            NH[27], NH[20] = "\xbd\x1e\x16\xed", I[NH[20]];
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[21] = {
                [NH[22]] = NH[23]
            };
            NH[20] = NH[20](I, NH[21]);
            NH[27] = 7710827171334;
            NH[23] = r15;
            NH[24] = r16;
            NH[26] = "ԩ4\xe9";
            NH[25] = NH[24](NH[26], NH[27]);
            NH[27] = "|\x01\xc6%'\xe3\x15\x9a\xa4p";
            NH[22] = NH[23][NH[25]];
            NH[24] = r15;
            NH[28], NH[34] = 12290747864667, 10002210918961;
            NH[25] = r16;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[21], NH[27] = {
                [NH[22]] = NH[23]
            }, "\xb3\x84\xfc\x94";
            NH[20].Header(NH[20], NH[21]);
            NH[21] = 122;
            F[NH[21]] = function(...)
                v1 = {};
                I = workspace;
                z = I.FindFirstChild(I, r15[r16("A\xc5~\x92\xc6", 18097141391595)]);
                if not z then
                    return v1;
                end;
                T = r25;
                T = "ipairs";
                for W, S in ipairs(T.GetPlayers(T)) do
                    q = W;
                    if z.FindFirstChild(z, r15[r16("\xf5B\x8cVI", 15003022957386)] .. S[r15[r16("\x11 \x1d\xdf", 12086536803836)]]) then
                        table[r15[r16("\xc3\xf5mbߑ", 1775623897914)]]({}, S[r15[r16("\xbc\xf5\xe4\x19", 3318585738761)]]);
                    end; 
                end;
                return v1; 
            end;
            NH[24] = r15;
            NH[39], NH[28] = "\x7f\xdbE\xaaǰ4\x84", 28476640752588;
            NH[25] = r16;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[29] = 30927505897537;
            NH[23] = NH[24][NH[26]];
            NH[25] = r15;
            NH[26] = r16;
            NH[28] = "\x84\xcdz[\x9e\xfc\x81\xbb\x84ײ7P";
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[26] = r15;
            NH[27] = r16;
            NH[53], NH[29], NH[30] = 20285653001446, "U\x06\x9b\x16[\x001", 34714438434597;
            NH[28] = NH[27](NH[29], NH[30]);
            NH[25] = NH[26][NH[28]];
            NH[26] = F[NH[21]];
            NH[27] = NH[26]();
            NH[28] = r15;
            NH[29] = r16;
            NH[30] = NH[29](NH[31], NH[32]);
            NH[26] = NH[28][NH[30]];
            NH[30] = r15;
            NH[28] = 1;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[30] = function(arg1_38, ...)
                I = r57;
                I[r15[r16("L\x89\x12\x94_\x00\xe4\xc5NN\"", 6337984121735)]] = arg1_38; 
            end;
            NH[22] = {
                [NH[23]] = NH[24],
                [NH[25]] = NH[27],
                [NH[26]] = NH[28],
                [NH[29]] = NH[30]
            };
            NH[28] = 12639868753661;
            NH[24] = r15;
            NH[25] = r16;
            NH[46], NH[27] = 32817032969137, "\x12\xa6{\x1b\xbf\x0c\xf2(ַ\xcax=\x15\x98\x84\x13";
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            NH[28] = "ė\xa2h";
            NH[22] = 123;
            NH[30], NH[29], NH[31] = 30039871714980, 15445602966552, 24034385783735;
            F[NH[22]] = NH[20].Dropdown(NH[20], NH[22], NH[23]);
            NH[25] = r15;
            NH[26] = r16;
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[29] = "\xb0\xe1\xc0\xeaG\x01\xf1\xe6\xbcG\x0bL8\xc5\xcf\x1e";
            NH[26] = r15;
            NH[41] = 13426446653548;
            NH[27] = r16;
            NH[28] = NH[27](NH[29], NH[30]);
            NH[30] = "jV{\x15r&\x0c\xa4";
            NH[25] = NH[26][NH[28]];
            NH[27] = r15;
            NH[32] = 21174901352068;
            NH[28] = r16;
            NH[29] = NH[28](NH[30], NH[31]);
            NH[28], NH[30] = "\xa0e\x01抅\xdf#O3\xef\xcc\xd4\xe7", 18730115260945;
            NH[26] = NH[27][NH[29]];
            NH[27] = function(...)
                v1 = r57[r15[r16("t\n\xfe[\xb0\xde\xef\x1e`\x97\xfc", 27661486862928)]];
                if not v1 or v1 == r15[r16("", 13591675492537)] then
                    r76(r15[r16("\x00\xd9.;e", 4937704032507)], r15[r16("\x17\xda\x11\x88\x04-\xf7e\xa0\xc5\x18\xb1N뷖\x1c}`\x0b\xc7\xcbt\xe6\xd7\n\xd5\x0c\xeb<\xa0\xc2:?\x87J\xff\xee\xfau\x19\x19", 15008052992844)], 3);
                    return;
                end;
                if r74[r15[r16("L]p\x06o\xe6", 3637720319645)]] then
                    I = r74[r15[r16("@\xa9+YN\xe3", 21124888520301)]];
                    I.InvokeServer(I, {
                        [r15[r16("\xa8a4 \x0f\x94", 34047709691374)]] = v1
                    });
                    r76(r15[r16("\xef\x06\xe0\xff\xd9\x15\x19", 3843309356797)], r15[r16("`J`b\x897\x03\x9c'\xed\x80\xec\xbe:", 30578374358943)] .. v1 .. r15[r16("\xf8\x8c\xd2I\xb8\xb8ZD", 5605729733170)], 3);
                else
                    r76(r15[r16(">\xb9'\xc8O", 28239107552093)], r15[r16("\x95\xf1\x1a>[\x87R\x93\xcf(\xe9Z\x13\x8c\xc2~\xb6\x04\x85\xe6\xef\xcb\xea\x8f", 11019288089611)], 3);
                end; 
            end;
            NH[23], NH[29] = {
                [NH[24]] = NH[25],
                [NH[26]] = NH[27]
            }, 13921900173650;
            NH[25] = r15;
            NH[33] = 29397688956281;
            NH[26] = r16;
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[20].Button(NH[20], NH[23], NH[24]);
            NH[25] = r15;
            NH[28], NH[51] = "\x8c$0\xcb", 11185956885592;
            NH[26] = r16;
            NH[29] = 16033180310826;
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[29] = "G\xdd:*\x9dZ\xac\x80_r";
            NH[26] = r15;
            NH[27] = r16;
            NH[28] = NH[27](NH[29], NH[30]);
            NH[31] = 26212648054702;
            NH[25] = NH[26][NH[28]];
            NH[30] = "\x94\xf0Gu\x0f\x04yf";
            NH[27] = r15;
            NH[28] = r16;
            NH[29] = NH[28](NH[30], NH[31]);
            NH[26] = NH[27][NH[29]];
            NH[27] = function(...)
                r107 = r57[r15[r16("\x90FQqr\xa3\xde\xfa\xf0\x8e\x05", 34130321702421)]];
                if not r107 or r107 == r15[r16("", 33733138218332)] then
                    r76(r15[r16("\xa5\x89\x18\x86\x84", 3114812753322)], r15[r16("\x98\x11a\xd8#,\x1f\x02\xbc\xa4\xb3\x83\xf2\xfe\x14#J7\xa0\x8f\x15Y\x85\xf8\x07\xdd\x11\x8c\x18w1ћ\x93\xf9\x1bf", 721573495120)], 3);
                    return;
                end;
                task[r15[r16("\xbd[J\xcb;", 1867351851877)]](function(...)
                    if r47 and r47[r15[r16("\x12\x86\xed\xf6\xe2(\xd8}\xb8\xd6", 31591453505910)]] then
                        v1 = r47[r15[r16("\x1c\xf3\xc5)\t\x01\np\xd3\xf2", 31649079409041)]](r107);
                        if v1 then
                            r76(r15[r16("\x80\xc0Tlv\x01%", 1397418197642)], r15[r16("\x8b\x7f\x08}\x02\xb2#\r\x14\n$\xb0\xf4\x9bB\xbd\xdf\x11O\xec\x95", 14747314870995)] .. r107, 3);
                        else
                            r76(r15[r16("\xbc\xa5(\xaaW", 6466918222787)], r15[r16("a\x030\x1esS\xed!\xb8\xbc\x85\x06\xec\xce!%;渝\xac[\x92>\xfc;", 7735402319378)] .. r107, 3);
                        end;
                    else
                        r76(r15[r16("p\xb1\\\x8d\xc0", 27387183641041)], r15[r16("\x16\r\x15\x00\xb12)R͂T}Y\x0c\x98\xc1\xf9\xaa.\xe0\x12\xbbr", 21912521189339)], 3);
                    end; 
                end); 
            end;
            NH[23] = {
                [NH[24]] = NH[25],
                [NH[26]] = NH[27]
            };
            NH[25] = r15;
            NH[29] = 2590901929142;
            NH[26] = r16;
            NH[28] = "\xc0v\xe7s\xeaꜽ[";
            NH[27] = NH[26](NH[28], NH[29]);
            NH[30] = 14389635963436;
            NH[24] = NH[25][NH[27]];
            NH[20].Button(NH[20], NH[23], NH[24]);
            NH[29] = 16237197319561;
            NH[25] = r15;
            NH[28] = "\x1d\x89\xeac";
            NH[26] = r16;
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[26] = r15;
            NH[27] = r16;
            NH[29], NH[31] = "\x89\xdeR#\x90<\xa3\xec\xa6\xe27", 16182577421679;
            NH[28] = NH[27](NH[29], NH[30]);
            NH[30] = "h)(\x11\xd1\x04\xa9zU";
            NH[25] = NH[26][NH[28]];
            NH[27] = r15;
            NH[28] = r16;
            NH[29] = NH[28](NH[30], NH[31]);
            NH[26] = NH[27][NH[29]];
            NH[31] = "\x1aWxme\xe6x\x01\x93\xf4\xaa8n9\xc9\xde\xda~\xba\x7f\xf9\xad\x0f\xb2\xfc\x94\x89k\xeb,\x8a\xa7\x93\xb0\x9e\xbe\x9d\xb4\x04\xbd\xe0':\x95I\x13Q\x8a~gd\xdf\x1b@\tF\xb6C\xbfC7\xc9\xff\x18Gq\x94\xdbU\x9e&\x13_\x98\xc1w\xf8}\x8d\xf2\x13\xc0R\xa3\xf9\xf1 Cn\x03\xd4R\xf3}\x18\x8b\r\xcc\x14";
            NH[28] = r15;
            NH[29] = r16;
            NH[34] = "<\x93\xf0S\xfd|8z";
            NH[30] = NH[29](NH[31], NH[32]);
            NH[27] = NH[28][NH[30]];
            NH[29] = r15;
            NH[32] = "\x9a\x1e\xdb\xf6\x9f\xeeW";
            NH[30] = r16;
            NH[31] = NH[30](NH[32], NH[33]);
            NH[28] = NH[29][NH[31]];
            NH[15] = nil;
            NH[29] = false;
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[44] = 30070255351474;
            NH[31] = function(arg1_39, ...)
                z = r50;
                if z then
                    P = r50[r15[r16("\xc2h\xf4", 7115417783537)]];
                end;
                if z then
                    r50[r15[r16("\xa8\xaaY", 28261026542440)]](arg1_39);
                else
                    r76(r15[r16("\xa2\x98\xd2\xef\x96&\x82]\xd0\xc2+y", 23663607098123)], r15[r16("\xee\x1a\x186I#`\xbd4\x94\xacU\xafM\x03\xb2V\x16\x07\xa5\x0b36\x8d\xd1", 2509420037264)], 3);
                end; 
            end;
            NH[23] = {
                [NH[24]] = NH[25],
                [NH[26]] = NH[27],
                [NH[28]] = NH[29],
                [NH[30]] = NH[31]
            };
            NH[28] = "#E\x81UN,\xdf,\x0f\xd3\x05\x91C;\xb0\xf1\xcb";
            NH[25] = r15;
            NH[29] = 33866756275610;
            NH[26] = r16;
            NH[27] = NH[26](NH[28], NH[29]);
            NH[30], NH[28] = 13528708126875, 16718342545001;
            NH[24] = NH[25][NH[27]];
            NH[9] = nil;
            NH[20].Toggle(NH[20], NH[23], NH[24]);
            NH[31], NH[33] = 12604284360429, 28883753268362;
            NH[24] = r15;
            NH[27] = "\x7f5\xbf{\xb7";
            NH[25] = r16;
            NH[29], NH[32] = "\x8c\x03\x18\xd3", 30807589517321;
            NH[26] = NH[25](NH[27], NH[28]);
            NH[23] = NH[24][NH[26]];
            I = JY[NH[23]];
            NH[26] = r15;
            NH[27] = r16;
            NH[23] = "Section";
            NH[28] = NH[27](NH[29], NH[30]);
            NH[23] = I[NH[23]];
            NH[25] = NH[26][NH[28]];
            NH[27] = r15;
            NH[30] = "{\xed\xfa\xa6\xbd";
            NH[28] = r16;
            NH[29] = NH[28](NH[30], NH[31]);
            NH[26] = NH[27][NH[29]];
            NH[24], NH[29] = {
                [NH[25]] = NH[26]
            }, "(\xd12x";
            NH[23] = NH[23](I, NH[24]);
            NH[26] = r15;
            NH[27] = r16;
            NH[30] = 32751522855827;
            NH[28] = NH[27](NH[29], NH[30]);
            NH[31] = 32258823404205;
            NH[25] = NH[26][NH[28]];
            NH[30] = "(o\xa4c\xd6s!\xdb#\r)\x17h";
            NH[27] = r15;
            NH[28] = r16;
            NH[29] = NH[28](NH[30], NH[31]);
            oH, NH[30] = nil, "\xf2\xce0\x90";
            NH[26] = NH[27][NH[29]];
            NH[28], NH[24] = "0{\x92\xca/", {
                [NH[25]] = NH[26]
            };
            NH[23].Header(NH[23], NH[24]);
            NH[25] = r15;
            NH[31] = 31697472453032;
            NH[26] = r16;
            NH[29] = 3632560309915;
            NH[5] = nil;
            NH[27] = NH[26](NH[28], NH[29]);
            NH[24] = NH[25][NH[27]];
            NH[38] = 10032794800703;
            I = JY[NH[24]];
            NH[27] = r15;
            NH[28] = r16;
            NH[24] = "Section";
            NH[29] = NH[28](NH[30], NH[31]);
            NH[26] = NH[27][NH[29]];
            NH[28] = r15;
            NH[31], NH[24] = "\x14̒\xdb5", I[NH[24]];
            NH[29] = r16;
            NH[30] = NH[29](NH[31], NH[32]);
            NH[12] = nil;
            NH[27] = NH[28][NH[30]];
            NH[30], NH[25] = "\x93m\xf1\x00", {
                [NH[26]] = NH[27]
            };
            NH[24] = NH[24](I, NH[25]);
            NH[27] = r15;
            NH[28] = r16;
            NH[31] = 6747373063237;
            NH[29] = NH[28](NH[30], NH[31]);
            NH[26] = NH[27][NH[29]];
            NH[28] = r15;
            NH[29] = r16;
            NH[32], NH[31], NH[34] = 32419045964536, "\xdf\x1dg\xb2X\x923ے\x04\xb3\xb1\xe7\xc7y\xa1\x00\x7f", 10104580887137;
            NH[30] = NH[29](NH[31], NH[32]);
            NH[27] = NH[28][NH[30]];
            NH[25] = {
                [NH[26]] = NH[27]
            };
            NH[24].Header(NH[24], NH[25]);
            NH[26] = r15;
            NH[27] = r16;
            NH[30], NH[29] = 32674941385583, "'\x04\x8b\xef\x8d";
            NH[28] = NH[27](NH[29], NH[30]);
            NH[32] = 3154454463932;
            NH[25] = NH[26][NH[28]];
            I = JY[NH[25]];
            NH[28] = r15;
            NH[31] = "\x16:\x1e\x18";
            NH[29] = r16;
            NH[30] = NH[29](NH[31], NH[32]);
            NH[27] = NH[28][NH[30]];
            NH[25] = "Section";
            NH[25] = I[NH[25]];
            NH[29] = r15;
            NH[32] = "\xebioax";
            NH[30] = r16;
            NH[35] = 25396869164594;
            NH[31] = NH[30](NH[32], NH[33]);
            NH[28] = NH[29][NH[31]];
            NH[26], NH[31] = {
                [NH[27]] = NH[28]
            }, "*\x03\x876";
            NH[25] = NH[25](I, NH[26]);
            NH[32] = 34072359583226;
            NH[28] = r15;
            NH[29] = r16;
            NH[33], NH[36] = 17901769351312, 12332307469934;
            NH[30] = NH[29](NH[31], NH[32]);
            NH[27] = NH[28][NH[30]];
            NH[29] = r15;
            NH[30] = r16;
            NH[32] = "p\x8e\xd9qm\xd0`\r'\xc1\x90\x02V*\x86\"2\x02";
            NH[31] = NH[30](NH[32], NH[33]);
            NH[28] = NH[29][NH[31]];
            NH[30], NH[26], NH[33], NH[31] = "m\xb7Q\xcds", {
                [NH[27]] = NH[28]
            }, 6623389797388, 166299385933;
            NH[25].Header(NH[25], NH[26]);
            NH[27] = r15;
            NH[28] = r16;
            NH[29] = NH[28](NH[30], NH[31]);
            NH[32] = "}\xfb\x112";
            NH[26] = NH[27][NH[29]];
            I = JY[NH[26]];
            NH[29] = r15;
            NH[30] = r16;
            NH[31] = NH[30](NH[32], NH[33]);
            NH[28] = NH[29][NH[31]];
            NH[33], NH[26] = "\xb8T\x08\xf9", "Section";
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[33], NH[34] = 22078820591657, 9214291726530;
            NH[29] = NH[30][NH[32]];
            NH[27], NH[32], NH[26] = {
                [NH[28]] = NH[29]
            }, "\x180\x1fe", I[NH[26]];
            NH[26] = NH[26](I, NH[27]);
            NH[29] = r15;
            NH[30] = r16;
            NH[31] = NH[30](NH[32], NH[33]);
            NH[28] = NH[29][NH[31]];
            NH[30] = r15;
            NH[33] = "T!\x1cB\xfd\x88.\x1dڛ\xd28\nD";
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34], NH[27] = 1284084449877, {
                [NH[28]] = NH[29]
            };
            NH[30] = "";
            NH[26].Header(NH[26], NH[27]);
            NH[33] = "?r\xbdn";
            NH[27] = r15;
            NH[28] = r16;
            NH[31] = 26341778206698;
            NH[29] = NH[28](NH[30], NH[31]);
            NH[27] = 124;
            F[NH[27]] = NH[27][NH[29]];
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34] = "\xa5\x06\x06\xc4[\xd7(J";
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[35] = "U8\xc85\x0fV\xc7\xc89\xa0\xb3";
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[36] = "\x1d\tOɱR\x13\xfe\x1a\xa9\xe7\"a\x05\x84";
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[35] = r16;
            NH[37] = "\xc1\xdd\xc6b(6\xfa\xae";
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[34] = function(arg1_40, ...)
                F[NH[27]] = arg1_40; 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34]
            };
            NH[34] = 19447725253472;
            NH[30] = r15;
            NH[31] = r16;
            NH[33] = "t\xe0\x91\x90\x11\xe1\x16AgEpL\x9c\xc7";
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34], NH[33] = 23758427843383, "\xff#~\x94";
            NH[29] = NH[30][NH[32]];
            NH[23].Input(NH[23], NH[28], NH[29]);
            NH[30] = r15;
            NH[35] = 33696401915211;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34] = "b\x8b\x8b\xd6\x18p\xe7\xef\xd1\xfcW\x12\xbe>\xe0\xb2r\xb1";
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[36] = 21957145290736;
            NH[32] = r16;
            NH[37] = 32558868478777;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "0\xb7\xd9\xf7\x07\xeb\x97d";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[32] = function(...)
                if F[NH[27]] ~= r15[r16("", 22440812030161)] and (r51 and r51[r15[r16("\x1aĐ\x11\x9b\r%E\xd7~N\x17", 15230372354996)]]) then
                    r51[r15[r16("\xd1R\x96\x95\xa6\x88\x1e@/ޙ\xb5", 301481328780)]](F[NH[27]]);
                    r76(r15[r16("\x9fkq\x90Tj\x13", 35045096390591)], r15[r16("\xb2\xe6^´\xf3\x8cV\x181\x1e>\x1dm:\x9f\x1d\x8cM\x17H\xda-T", 12797523121991)] .. tostring(F[NH[27]]), 3);
                else
                    r76(r15[r16("\xfb\xbb\x91\x0e/", 32560304732986)], r15[r16("_\xafL\r 쮤\xa6\xbe\xa0\xcc\xcfY0\x9ba\x17-\xfc\xfa", 3493284595290)], 3);
                end; 
            end;
            NH[36], NH[28], NH[38], NH[35], NH[33] = 6545297329127, {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32]
            }, 5460680198638, 10240657658528, "\xc4\xeb\xac\xff\xee\x9cT\x8c \x82E\xe5C\x11<\x86";
            NH[30] = r15;
            NH[31] = r16;
            NH[34] = 9310623469807;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34], NH[33] = 28183522145091, "A\xe8r(";
            NH[29] = NH[30][NH[32]];
            NH[23].Button(NH[23], NH[28], NH[29]);
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34] = "\xe9\x13\x92\x93\xbf\x96b\xa4\xe3\x9e\xdfэuc\x89\x8c2e\x08";
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "3\x8dk\rS\x7f\x9ao";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[32] = function(...)
                if r51 and r51[r15[r16("\xf5\x0f\xf2\x98\xebJ\xbb\xd9g\x18.\x88\x9e.\x14\xeeH,\xec\x83", 25674091425459)]] then
                    r51[r15[r16("\xa1\"\x07\"l^\xb3o\xdf\xfc[\xa9b\x1dm\xa5=\xaf\xec\x98", 13395112122461)]](true);
                    r76(r15[r16("\xbc\xc8\xe6\xc7\xda\x0f\x05", 244678492273)], r15[r16("\x1b9\xe2\xe00\x108D\n<\xae\xe4\xe1.\xdf\xfaa", 24562078903469)], 3);
                else
                    r76(r15[r16("\x9d\xbd/\xdeZ", 31296881473773)], r15[r16("\xb94\xf2\x07\xa4H\xce\xc3\xeb\xd0j\x86\x11\x0b\xf6\xc2\xefc\xa7\xa1\x83\x15\xe4\xef\xf7", 410977894591)], 3);
                end; 
            end;
            NH[28], NH[33], NH[35] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32]
            }, "4^a\xc1\x7fe]\xa9\xd9\xfd\xe1g\x85,\xf4\xc9\xc5\xda", 22489798486248;
            NH[30] = r15;
            NH[31] = r16;
            NH[34] = 31185468700857;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34], NH[36] = 6217090255695, 5215388338556;
            NH[23].Button(NH[23], NH[28], NH[29]);
            NH[23].Divider(NH[23]);
            NH[30] = r15;
            NH[31] = r16;
            NH[33] = "\xa2\xd6o\x91\x15\xd3";
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34] = "\x8c\xaf)\xe3\x88\xe6Ϝ\xc1Zd\x14\xfc";
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "`\x92\xc9\xe7";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[36] = "";
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34], NH[33], NH[36], NH[28], NH[37] = 23773882936126, "\t\x9a\xaa\x0f", 9706803843496, {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32]
            }, 19271284237069;
            NH[23].Paragraph(NH[23], NH[28]);
            NH[30] = r15;
            NH[35] = 30612257503150;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34] = "&\xaaa\x03\x108\xe5B\xdf4p~X@\x19";
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "\x9aiE\x0cV\x0fc`\x9f";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[36] = "\xfd\x19_\xa6pc罶\x8e\xcaL\xf8\t\xe7\xeeB\xdc^\x95\xc0M\xc8ùi˼\xde[\xdae\x02\xbf\xb3:\x18J5m\r\"\xae\x05\x1d\n<\x0c";
            NH[33] = r15;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[37] = "\xf1\x0c\x18'\x89q)";
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[34] = true;
            NH[36] = r15;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_41, ...)
                if type(getgenv()[r15[r16("2\xdbӖv$W\x91\x1c\xb1\x0es", 7845339975237)]]) ~= r15[r16("\xfe\x90#\xec\xea", 3972710008633)] then
                    P = getgenv();
                    P[r15[r16("\xf2Y\x90\xbe\xfa\x94\x8b\xf8\xd3.^\xb0", 15927302282488)]] = {};
                end;
                I = getgenv()[r15[r16("\xce\xc4\xc4\xf3>\x7f\xcd\xc4\xc1\x1e\x8bz", 30286152005399)]];
                I[r15[r16("\x7f\xfa\x07\x02\xeb?\x89׬\xe5", 19203082380014)]] = arg1_41; 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[34] = 16228783611269;
            NH[30] = r15;
            NH[31] = r16;
            NH[33] = "\x03\x97\xe9\xfb*\x83U\x0b\x88\xfa\xc0\x05\x9d";
            NH[32] = NH[31](NH[33], NH[34]);
            NH[36] = 13604716239039;
            NH[29] = NH[30][NH[32]];
            NH[35] = 32000605502005;
            NH[23].Toggle(NH[23], NH[28], NH[29]);
            NH[34] = 30146876290774;
            NH[30] = r15;
            NH[33] = "\xfe\xc8M\xce";
            NH[31] = r16;
            NH[39] = "G\x04X\xe8j\x91\xb2\x85";
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34] = "~\xba\x01\n#\xe8\"T\xc2ˬ\\\x9eK*\x8d\xbd\x89~\x15a";
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[7] = nil;
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[35] = "\xc1JM\xbblc\xf2\t\x81";
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[36], NH[37], NH[40] = "\xbe\xd5\x7f6\xd2\x15TTn\x1b\xed\x1e\x97\x85\xdcy2\x9c\x8d\x1d\x914o7K\x08\xf4\nQ\x06~\xe5\x84{\xa5\x15`b\x87\xe4+\x13\xa6f\xe8\xdb\x13\x03|", 33640160886064, 6603866295299;
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[37], KY, NH[38] = "\xb2#\x04\xb6k\xfa\xeb", nil, 6126856866597;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[36] = r15;
            NH[34] = true;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[38] = 633236980006;
            NH[36] = function(arg1_42, ...)
                if type(getgenv()[r15[r16("\xf4O\xccLI\xbf\xe0_\xde\xd2\xf8\xbf", 8696446439377)]]) ~= r15[r16("<n\x7f\x17Y", 12672154212108)] then
                    P = getgenv();
                    P[r15[r16("\x8d\xa3CR\xa7\xe59Hp\xc4jp", 32277957720758)]] = {};
                end;
                I = getgenv()[r15[r16("׊o\x82K\xc9\x03)\x1dd\xa59", 22091558578223)]];
                I[r15[r16("%\x0b\r[\x19\x1b\x04@W<@\xf7c.t\xc1\xc6\xec\xf3", 12916832704382)]] = arg1_42; 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[34], NH[33] = 21655664535396, "w\x12\x84\x19\x86\x8fc\xa8Q\xbd\xd2\x1f7\xe1\x1d\xe3\xe6\xe7\xef";
            NH[30] = r15;
            NH[39] = 27733425091186;
            NH[14] = nil;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[33], NH[34] = "n)-,", 18204067946780;
            NH[23].Toggle(NH[23], NH[28], NH[29]);
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34] = "\xb4a\xfd:\x19\xfa\xbd\xe6\xb2GE\x11\x96\x1c\x89";
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[36], NH[35] = 17656761131038, 13327810598974;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[37] = 24421158218859;
            NH[32] = r15;
            NH[35] = "\xeaI\\\xf29\xb9\x90\xaa\xf3";
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[36] = "\x95\xf5\x01\x04\xeb?)\xa8\x02\xd9\x1aw\xc80n\x8d\x1a8\xfb\x025C\xa1\x983ΚQ\xcbӑ \xeeJ\x1e\xf8\x95\x81\xd3\nN\x04\x92\xa7'\xa5\x88\xeb!_\xd8\x01ğ\xb6\t\xd4A\n\x11\x06\xdc";
            NH[35] = NH[34](NH[36], NH[37]);
            NH[37] = "@\xe925\xe9\x8dE\xf1";
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[34] = function(...)
                pcall(function(...)
                    setclipboard(r15[r16("]m\x0b(\xf3=q\xc0\x92\x95~\xbbdX9\x8b\xcfH\xf3\xcb\x14\x00_\xf2\xcfB\xf4\xfd\xd0\xdaA", 22872149469594)]); 
                end);
                r76(r15[r16("A󑋐\x10\xe7", 21795654592421)], r15[r16("\xea9\x8c\xc1M\xb55\x037EiʜΔ\"\xaa 5", 24407119916133)], 5); 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34]
            };
            NH[30] = r15;
            NH[34] = 18300034867529;
            NH[31] = r16;
            NH[37], NH[33] = 25472615427669, "\xf8\x86@K\xf3Ǘ\xb7\x86\x06\x9dd\xa7\xe1";
            NH[32] = NH[31](NH[33], NH[34]);
            NH[35] = 8494032047987;
            NH[29] = NH[30][NH[32]];
            NH[33] = "R\x03\x0e\xa6";
            NH[25].Button(NH[25], NH[28], NH[29]);
            NH[36], NH[34] = 23760715082552, 31502458435917;
            NH[30] = r15;
            NH[31] = r16;
            NH[38] = 16339372039608;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[32] = r16;
            NH[34] = "\x01\x1fx\xd0w>]N";
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "i\x80\xb9\xee\xa5k\x0e\x8f\x01";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[36] = "9U\xa5N\xcb:\xa0\x18\x91w\n\x95\x883x\xa0#\xd8\xfd#[|Hc^\x9an\xac)\x10?O\xdd1\xb1\xbd\x04\x16\xbf\xf7\xbc\xf48R\xefw\xa4\x1e";
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[37] = "\xd7c\x84E\x0ce)\x00\xfdLE";
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[35] = r15;
            NH[40] = 6215545604942;
            NH[36] = r16;
            NH[38] = "]\x0cͬ\xb9cI\x1e\x19\xdf{/\xee\x1b";
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[39] = ".\x8f\x1d\xf9\xae\xee \xde";
            NH[36] = r15;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_43, ...)
                I = r57;
                I[r15[r16("\x9f\xb4g\xf5[k\xf1", 11441151939791)]] = arg1_43; 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[30] = r15;
            NH[35], NH[33] = 6403656141733, "\x13\xa7\xb4\xd4\xc8\x1b%\xb4\xd1\xf9\xe4";
            NH[31] = r16;
            NH[34], NH[39] = 11752135365984, 30238906021633;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34] = 22444329232595;
            NH[29] = NH[30][NH[32]];
            NH[25].Input(NH[25], NH[28], NH[29]);
            NH[33] = "\xb2\xa1\xefN";
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34] = "g\xb0\xbb\x8cA\x83&\t\x98\x04";
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[38] = 4859444922582;
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[33] = r16;
            NH[36], NH[35] = 8568368762773, "BT6 O*\xa0TL";
            NH[34] = NH[33](NH[35], NH[36]);
            NH[36] = "[\x85\xc6\xdf\xfe\x0cn\xf8\xee{\xdbDS\xaes\xb8_\x80]\xa3\xe2\x1cS7\x10r\x95ލ\xe3\xd6\xd6fv>\xde0:\x87\x9e\xa3T\xfek\"\x07\x91\xd1^{\x19\xfd7q\xedu\xdfz\x04F\xe6\x1d\xca}\x93\xeaҗ\x92\xec\xed\xe6\x17+e\xe2M\x97\x9e";
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[37] = 864673366418;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[37] = "\x14\xe6lo\xda\\q\xac";
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[37] = 8724398264286;
            NH[34] = function(...)
                I = tostring;
                P = I(r57[r15[r16("\xe80\x19\xcb,\xe9\xfd", 14695225645754)]] or r15[r16("", 7468539661717)]);
                r108 = P.match(P, r15[r16("\xb4\xf3\xd1of\xdd~\xca\xc2\xcfl+", 13555891378344)]);
                if r108 == r15[r16("", 27367379857863)] then
                    r76(r15[r16("\xb3k\xa2\xe7\x80", 4562125293644)], r15[r16("\"Xq\t;\x89j\xbc\xeb\xd5'\xfb\xa5\x87iנz\xc2\xe8\x7fɬ\xe5\xb1\xc29\xac\xe10", 463077851351)], 3);
                    return;
                end;
                r76(r15[r16("d\xd4a\xe1", 5099840457030)], r15[r16("Q\x06٬u\xb0\xc3\xf1\xfb\x9a\xbfj#Tyj`E\x9eR\x9eO\xf3u9\x89\xd3\x18", 26217789829040)], 2);
                task[r15[r16("ݑ\x8c\xa1\x0e", 18667145798132)]](function(...)
                    r109 = request or (http_request or syn);
                    r111 = false;
                    S = r16("2\x86e\x11\x93\xbeSt\x10y\xa4\xb3\xc5ѧ>Ca\x10\xaa\xf5", 8690178854862);
                    I = _G[r15[S]];
                    q, W = r109, r15[r16("", 9373819818253)];
                    if W then
                        S = r26;
                        T = S.UrlEncode(S, W);
                    end;
                    I = q;
                    r112 = W or r15[r16("", 7903931911776)];
                    if r109 then
                        pcall(function(...)
                            v1 = r109({
                                [r15[r16("s\xc9Q", 19060888052395)]] = r15[r16("\xc2Q\xcfJ~GEOn\xc4\xd2\x07\x10\xb0G\x99\x11fV\x8f\x04F\x03]\x9da\xf2g\xa8\xaeTx", 31562328340841)] .. r108 .. r15[r16("*T\x89\xb8\x88\xf2\x8d", 29699586504197)] .. r112,
                                [r15[r16("\xf6\xba=\xbb\xb8e", 8283635879697)]] = r15[r16("Ѷ\xd4", 14677991103154)]
                            });
                            if v1 then
                                P = v1[r15[r16("3\xa1\x016L@M\x11\xa5\x14", 26017672834899)]] == 200;
                            end;
                            if v1 then
                                I = r26;
                                r110 = I.JSONDecode(I, v1[r15[r16("*3\x0ca", 16777667927684)]]);
                                r111 = true;
                            else
                                if v1 then
                                    L = I({
                                        [z] = o,
                                        [W] = T
                                    })[r15[r16("\x02\xf5\xaeQ1\xd1Yt\x1a6", 16305916157353)]];
                                end;
                                if v1 then
                                    b = I({
                                        [z] = o,
                                        [W] = T
                                    })[r15[r16("M\x84c\xdd", 30987759188061)]];
                                end;
                                I = r109;
                                warn(r15[r16("\xd7\x10\xdf\xd2Yf\x83.R\x19\x9e", 3254334080491)] .. tostring(v1) .. r15[r16("V\x1a\\", 33117039967293)] .. tostring(v1));
                                return;
                            end; 
                        end);
                    end;
                    S = r15[r16("", 9373819818253)];
                    if r111 and r110 then
                        p = I;
                        I = I;
                        local function I(arg1_44, ...)
                            P = tostring(arg1_44);
                            I = P.reverse(P);
                            P = I.gsub(I, r15[r16("\xeä́\"\x92\xc0>\xb3", 7555522448830)], r15[r16("y]\x14", 9781418906058)]);
                            I = P.reverse(P);
                            return I.gsub(I, r15[r16("?\x1b", 15777475959986)], r15[r16("", 16123891227988)]); 
                        end;
                        M = r15[r16("\x84,\xe0g", 3505395893856)];
                        P = r110[r15[r16("\x16\xbd\x1e\x98\x06h\x17]\xf2,", 10646092272477)]] or (r110[r15[r16("\x82\x8b\xd8\xd4", 20636920882569)]] and r110[r15[r16("\xbe\xa6\xb4\x97", 30819116873743)]][r15[r16("]/\xb0\xb7\xab\xe7s\xc4\x18=", 18114631950579)]] or 0);
                        I = I;
                        P = r110[r15[r16("\x83'i+", 23002124626391)]] and r110[r15[r16("}(9\xe6", 22676757244223)]][r15[r16("\xdeQ\xf9b\xafY+ \x994?\x03\x01\xa8", 34655890112265)]] or 0;
                        L = type(v2) == r15[r16("\x8d5]t,", 33456301178075)] and #v2 > 0;
                        p = r110[r15[r16("}\x9d\xcd\xd5&\xebr\x9a\x1b5\xde\x11\xbf\x10", 34192812260914)]] or P;
                        v2 = r110[r15[r16("4\xd9Ѡ\xe7\xcfjp\xaf}", 28101965083421)]] or r110[r15[r16("\x1c\xbc]\x1c", 13710174968048)]];
                        b = r110[r15[r16("\xdf\xd4\xc9\xf2^\xb9", 22400353822910)]] or r110[r15[r16("i\x97l\xb5", 26042595733343)]];
                        e = r15[r16("`\xe0\x07\xdb", 20557810148708)];
                        i = r15[r16("\x84,\xe0g", 3505395893856)];
                        if type(v2) == r15[r16("\x8d5]t,", 33456301178075)] and #v2 > 0 then
                            e = table[r15[r16("\x8a\x92҄\xdc\xd1", 11391110878392)]](v2, r15[r16("\x8d5", 20283063821541)]);
                        else
                            if type(v2) == r15[r16("\x15\xc1C\xf64\xab", 1526263153350)] and v2 ~= r15[r16("", 27697027052129)] then
                                e = F[z][r15[r16("4\xd9Ѡ\xe7\xcfjp\xaf}", 28101965083421)]] or F[z][r15[r16("\x1c\xbc]\x1c", 13710174968048)]];
                            end;
                            I = r15[r16("\x84,\xe0g", 3505395893856)];
                            if type(b) == r15[r16("\x1aޗ\xa1I", 18215731700002)] and #b > 0 then
                                i = table[r15[r16("\x8f\xf0\x07\xdf\xf0\xb3", 32514022341412)]](F[z][r15[r16("\xdf\xd4\xc9\xf2^\xb9", 22400353822910)]] or F[z][r15[r16("i\x97l\xb5", 26042595733343)]], r15[r16("\x01d", 15034116725592)]);
                            else
                                I = l;
                                if type(b) == r15[r16("6\xfc\x82\x06\x92\x13", 27589551518255)] and b ~= r15[r16("", 4885172701410)] then
                                    i = F[z][r15[r16("\xdf\xd4\xc9\xf2^\xb9", 22400353822910)]] or F[z][r15[r16("i\x97l\xb5", 26042595733343)]];
                                end;
                                M, i, L, p, S, e, v2 = nil, nil, nil, nil, string[r15[r16("5~\x037\xf4:", 24815535631651)]](r15[r16("\xe0[(w\xae\xf3\xe9\t\x9bq\x9cِ\xafq\xc2mγ\x9c=\xc5\xcd\xe1(5R\xc5\xd5)\xb4\x18\xd6\x106\x8eu\x1a\xb4\x1d\x9f\x8d(\xc5\x7fy#d\xd2", 8182655373026)], I(P), I(F[z][r15[r16("}\x9d\xcd\xd5&\xebr\x9a\x1b5\xde\x11\xbf\x10", 34192812260914)]] or P), r15[r16("`\xe0\x07\xdb", 20557810148708)], I), nil, nil;
                            end;
                        end;
                    else
                        q = r15[r16("|j$0MGv^x\x83=\x91\xf6F\xa93\x15\x8b\xd4)Ü\xb2 \xf3S", 21009063929399)];
                        S = r15[r16("d\xdbh2\xb7\xf4;i\xdbf\xaa1E]([\x88\xabw\x15\xbe\x97\xf6x\xedQÆɋ\xe2D^\xd5\xeb\xc9\xed\xe3\x97\xfa\xed\x84\xe9\x19\xc0\x8dyr9\xe8\n\xfaJ\x8ap\xde\x06\x9e\\ML\x80ڏfl\xdbT\xfa\xeb\xf1]|\xf2S\xa4\xb6", 277255798913)];
                    end;
                    r81(r15[r16("p<G&\xa4\x97N\xb14\xfe=\x0b\xb6&\xcd!\xe5v", 22521461778679)], S, function(...)
                        r76(r15[r16("K\xed\xce\xe2\xb8a", 28819576255596)], r15[r16("\x11\xc2Z\xdeq g\x8b\xcf\x1c\x11\xcbm\x9d\xe8M\xae", 16643808697926)], 3);
                        task[r15[r16("\x88(^8\xc8", 18391887749492)]](function(...)
                            if r47 and r47[r15[r16("\x91\x0c\x02\xac\xbe\xf5;R\n\xcb", 27828016427678)]] then
                                r47[r15[r16("\xb8\xc8M9\xfcW6q\xf8\xa8", 4461561219101)]](r108, false);
                            else
                                warn(r15[r16("\xbek-8\xfc\xeføXj@%\x0c\xfa\xbb\xc26\x15R\xae\x93M", 5884272888500)]);
                            end; 
                        end); 
                    end); 
                end); 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34]
            };
            NH[30] = r15;
            NH[35] = 19594447856548;
            NH[31] = r16;
            NH[33], NH[34] = "\x9f\xfb\xe8\xa8\x03\xbe}\x8e<", 27299534434728;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34] = 32563526302523;
            NH[29] = NH[30][NH[32]];
            NH[25].Button(NH[25], NH[28], NH[29]);
            NH[33] = "\xab>\x917";
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34] = ",\x1bي/N\xe8\x8bJH\xb4\xf0\x85\x9a";
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[36] = 10253826151078;
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[33] = r16;
            NH[35] = "\xd0Ϛ\xf0\xe5ڼ|O";
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[36] = "\x00\x1e\xafQ\x83r\xaa\xd2`\x13\x1e\x0c\xa5\xa8\x9a\n3\x97\xf5+.\xa8z\x97\x0e9\xc8\x06\xfa\x99z\xac\xf4\x96f\xdaݺ\xd3\xdcIUx\x9e-&\x85\xd1w\x82\x87TH\xc7 \x87\xeeCJ\x11\xe3\xf8\x00\x00\x0eE\nD\x99\x9e7\xa5\xeeY\xf1\tn\x9e\xc8\xe3\xf4";
            NH[33] = r15;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[38] = 6810429590627;
            NH[34] = r15;
            NH[35] = r16;
            NH[37] = "3\x87W\xfa\xadX\xe9\x08";
            NH[36] = NH[35](NH[37], NH[38]);
            NH[37] = 10765977588629;
            NH[33] = NH[34][NH[36]];
            NH[34] = function(...)
                if r47 and r47[r15[r16("\xff\xed\xc2\x04\xaf\x82\xee\x92_U\x96W\xcbz", 1112049795589)]] then
                    r47[r15[r16("\x01\x03zVFʹ6\x06լ\xe3\x00\xfe", 3946158278445)]]();
                    r76(r15[r16("\xde\xd5\\U\x98ef\xc8\x07\xfc\x94\x92&", 25588739649163)], r15[r16("\xb7x:\x04\xcd\x15\x91\xc2f\x0c\x11G\x9b\xa4\xcc\xc0\xad\xa0x\x82\xf8\x0b?Q", 21669859944298)], 3);
                else
                    r76(r15[r16(".i\xf3\x01r", 7451554172301)], r15[r16("\xa7\x18\xach\xf9\xed\xfa\x0b\xa8k\xfa^k\xado\x05\x97$&\xfbd{\x178ذl!)\xf4Z\xdb\xd3\x17ISy\x12В\xa3\x84\xed\xfc\xd1\x185\xc3\xe6", 23860668722022)], 3);
                end; 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34]
            };
            NH[30] = r15;
            NH[33], NH[34] = "\x99řX\x0b\x19\xdbw\xd5;т\xdd", 33060970822691;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[33] = "\x92=\xf3\x84!\x1f";
            NH[25].Button(NH[25], NH[28], NH[29]);
            NH[30] = r15;
            NH[31] = r16;
            NH[34], NH[36], NH[35] = 27734617993842, 25573625769604, 25386931891757;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34] = ">\x97\x13`\xf6\x86E\xb8";
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[45] = 13723677481206;
            NH[30] = NH[31][NH[33]];
            NH[35] = "8\x12\x7f\xf0";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[36] = "\x8d{\x01\xba\xe5\x81\xf5>8O\xcd\xc7\xf9\xe8\x11%\x99\x95n\x90\x7f\xb3\x15\x82\x08\x80m-\xdd]\x90\x1bV\xfbA\xf8\xbb&\x88\x9d\xc5\x12\xfd\xbf\xacl\xab\x8a\xb5\xaauW\xea\xa9Y5\xaa\x94b\xf8\xbd=\xd9ut\xe4Jb\xc3\xc5\xea`\x07{\xa5g\xd9T?(\xea\x81k\xac7M\xa3\x8b\xbeyޟn\x1c\x8fh\x89\xa4\x08\xeej\x06_ג\xf2O\xf2X\x07\xc0\xee\x06\xd5\xcb]\xc9\xf6\xbb";
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[38] = 27601754829365;
            NH[32] = NH[33][NH[35]];
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32]
            };
            NH[24].Paragraph(NH[24], NH[28]);
            NH[30] = r15;
            NH[34] = 22716582127954;
            NH[31] = r16;
            NH[35], NH[33], NH[36] = 5423370389981, "0\x9bn\x90", 3171157001668;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34], NH[37] = "u\xabX\x038=fBlE\x12\x89\x18\x01", "\xceZ\xdd\xf8\x1a";
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[40] = 11353812374695;
            NH[33] = r16;
            NH[35] = "\xfdK\x85]\xa8J\t";
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[38] = "xi\x8e=oq";
            NH[35] = r15;
            NH[36] = r16;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[39] = "\xa6\xbe\xbe\xe0\x12";
            NH[36] = r15;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[40] = "o\x0028\r\xf7\xc1yT";
            NH[37] = r15;
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[41] = "\x131\xc03\xed";
            NH[36] = NH[37][NH[39]];
            NH[38] = r15;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[42] = "\xd8;\xa4V8N\xdc\x14";
            NH[37] = NH[38][NH[40]];
            NH[39] = r15;
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[43] = "Y\xc3Ϟ\xe4\xd6";
            NH[40] = r15;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[44] = "\x8ct\x13\xb5\x84";
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[42] = r15;
            NH[43] = r16;
            NH[45] = "\x1d\xa29~\x9b4\x01";
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            NH[32] = {
                NH[33],
                NH[34],
                NH[35],
                NH[36],
                NH[37],
                NH[38],
                NH[39],
                NH[40],
                NH[41]
            };
            NH[38] = 34531816570576;
            NH[34] = r15;
            NH[35] = r16;
            NH[37] = "\x00ͺ\xb6s";
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[36] = r15;
            NH[34], NH[39] = true, "\x9em\xd0\x0f\xbc\xec\x16\x03";
            NH[37] = r16;
            NH[40] = 19607950386090;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_45, ...)
                for W, S in pairs(arg1_45) do
                    if type(W) == r15[r16("\x08\r\xd5ň\x10", 22783559100785)] and type(S) == r15[r16("\x19\xe1\x00\x12_\x9a", 16848709394085)] then
                        if ({
                            [r15[r16("\x9dE\xbcI\xd1", 24932195298649)]] = false,
                            [o] = false,
                            [r15[r16("\xb3\x9f=\x87\x95", 4018026137423)]] = q,
                            [r15[r16("\xf4q\xba\xb6\x07\xab\x98\xf4\x99", 1649360896)]] = M,
                            [L] = p,
                            [v2] = b,
                            [e] = i,
                            [w] = l,
                            [J] = B
                        })[S] ~= nil then
                            z[S] = true;
                        end;
                    else
                        if type(W) == r15[r16("=>Q\x11A\xe5", 25093492010405)] and type(S) == r15[r16("i\x17\x94b\xf8Z\x0e", 20660157818260)] then
                            if ({
                                [r15[r16("\x9dE\xbcI\xd1", 24932195298649)]] = false,
                                [o] = false,
                                [r15[r16("\xb3\x9f=\x87\x95", 4018026137423)]] = q,
                                [r15[r16("\xf4q\xba\xb6\x07\xab\x98\xf4\x99", 1649360896)]] = M,
                                [L] = p,
                                [v2] = b,
                                [e] = i,
                                [w] = l,
                                [J] = B
                            })[W] ~= nil then
                                z[W] = S;
                            end;
                        end;
                    end; 
                end;
                if getgenv()[r15[r16("(\xf3\xc2^\xf6q\x97q\xc2is\xa5%\x82\xc89Uy\xa1ݽ", 9398955282712)]] then
                    for T, S in pairs({
                        [r15[r16("\x9dE\xbcI\xd1", 24932195298649)]] = false,
                        [r15[r16("\x8f\xba>5\x1c\xf4", 31910970784267)]] = false,
                        [r15[r16("\xb3\x9f=\x87\x95", 4018026137423)]] = false,
                        [r15[r16("\xf4q\xba\xb6\x07\xab\x98\xf4\x99", 1649360896)]] = false,
                        [r15[r16("4\xbaJl}", 5450996943338)]] = false,
                        [r15[r16("\x951\x97/\xa0\xc0\xaay", 10828455728050)]] = false,
                        [r15[r16("\x13\xc0\x0c\x9d\x16g", 1113699156486)]] = false,
                        [r15[r16(":ea\x18\x1c", 9397155221783)]] = false,
                        [r15[r16("\xbc1\x92\x1f>T\xcb", 1232823288382)]] = false
                    }) do
                        getgenv()[r15[r16("\xa7\xe1\x03\xfc`\xbf\xb4N1a~\x87L\xb5ɡ\x16\xfc\xf0\xa6\xde", 15296051796946)]](T, S); 
                    end;
                end; 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[34], NH[35] = 11049411499033, 2828261836069;
            NH[30] = r15;
            NH[31] = r16;
            NH[40], NH[33], NH[36], NH[38] = 11527315821815, "(\xec\x0bQT\x93\x88\xa7\x06\xb2\x1a\x04Y\x80a0", 16472781889014, 30430016665434;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[24].Dropdown(NH[24], NH[28], NH[29]);
            NH[30] = r15;
            dY, NH[46], NH[33], NH[34] = nil, "xṲ\xf7\xf9\xe9\x8c", "\xe5Ǌ+", 20164932887726;
            NH[31] = r16;
            NH[37] = 23336089889394;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34], NH[13], NH[39] = "j\xe1\xb7\x17G\xa31\xda蛲\xc7", nil, "\xc1\xb7\xe9y\x19\xdbM\x9d";
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "z\xeeW/\xb0\xa3S\x91W";
            NH[32] = r15;
            NH[33] = r16;
            NH[25] = nil;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[36] = "\xd8o\xf4*\xf8߰C\xa5c\xc2k\xbf咤\x92\x11\xd6֘\xab\xe0\xc0\x93\x0f\xd2\xf3\xf2\xa4r\x12 \x19H1\xe8\xe1S\x918'ڳ\xd2\x7f\x86\xf3>l\x87";
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[20], NH[37] = nil, "\xabs\xff\xcc\xfcL\xe9";
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[36] = r15;
            NH[34] = false;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_46, ...)
                if r47 and r47[r15[r16("\x12\xc1K\xfa\x15\x86\xe8\xc4Ƭ\xcc\xdd", 34689902280473)]] then
                    r47[r15[r16("\x10^\x7fS,rW!\x19Π\xae", 8672091230150)]]({
                        [r15[r16("o\xb6J鵅a\x80#\xef\xb1U", 6859105553530)]] = arg1_46
                    });
                end; 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[33] = "s \xf6\xfcfʾ\xbb\xfd<A\"~{~l";
            NH[30] = r15;
            NH[31] = r16;
            NH[34], NH[35] = 4494546716716, 20582783034736;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[26].Toggle(NH[26], NH[28], NH[29]);
            NH[33] = "\xdf\n\x01T";
            NH[30] = r15;
            NH[34] = 3557974476408;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34] = "YO\xbc\xc3\x06\x08.\xa4\xa6u\x04\xf2";
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[36], NH[40], NH[35] = 2127207580638, 27059402879288, "Z\x88\xe3P.\t\xec\x92S";
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[37] = 2905418958152;
            NH[34] = r16;
            NH[39], NH[36] = "\x92\x0c\xe7[\xae\xba\xe0\xb9", "\xba_\xbae7\xb3ȸ\x1dR\xce\xc5^\x1e\x1a\xed\x8fb\xeer\xe0\x9a\x0b\x98\x1e\xbd\xec\x8e\xf9\xe2\xb1\x11\xfd{PwK\\8\x94\x89\xb4J\xa0`\xa1\xaf!\x8bdr\x16\x05\x16\x12";
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[35] = r16;
            NH[37], NH[38] = "\xdb\x17(\xe5\xd6\xe5m", 5006361315611;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[34] = false;
            NH[36] = r15;
            NH[37] = r16;
            NH[2] = nil;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_47, ...)
                z = r47;
                if z then
                    P = r47[r15[r16("J\xb6\x00Ϗ\x99\x9a\xe2U\xe7\x9c\x0b", 34816389742420)]];
                end;
                if z then
                    r47[r15[r16("\x94\xfc}\xaf\xb4\x1b,\xef\x81\x1evh", 9024387469418)]]({
                        [r15[r16("\xe2\x1dƴ\xa2\xfa\xa5*\x84\x7f\xb5=", 27061052240185)]] = arg1_47
                    });
                end; 
            end;
            NH[28], NH[37] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            }, 21085666485850;
            NH[33] = "*\xe3\xdd\xf6'\xc4\xe1\xc6\xdc\x06\xe1e\xda\xec\xae\x0f";
            NH[30] = r15;
            NH[36], NH[34] = 14480169802326, 5083014580542;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34], NH[33] = 19852843197468, "\xc33\x82z";
            NH[29] = NH[30][NH[32]];
            NH[26].Toggle(NH[26], NH[28], NH[29]);
            NH[35] = 28174751396671;
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34] = "\xa5uz\xe4̇\x1c\xec\x1a\xee$\x11\xc4\x05\xc6yw\xe5\x14";
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[38], NH[41] = 15773938392241, 16162459770214;
            NH[32] = r15;
            NH[35] = "IF\x18y.6\n\xbe-\xd6I";
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[36] = "\xec\x98\x1cR\xc8u\xedk\xe2";
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[35] = r16;
            NH[37] = "\xe0\xb7ur嫻\xe2";
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[34] = function(arg1_48, ...)
                z = tonumber(arg1_48);
                if z then
                    if r47 and r47[r15[r16("\x0c-\xd0ګHТH<^\x9a", 31328879196412)]] then
                        r47[r15[r16("\xdd\xcfzmm\xe5\xbaK\t\x89'\xbe", 10994786407423)]]({
                            [r15[r16("inĩ\x88z\xc1i\xbaK\xd8\xfbC\xa5\xb3\x91]\x13\xc5", 1249724121669)]] = P
                        });
                    end;
                    r76(r15[r16("P\xb6G\tu\x112\xf7t\x92\xfd\xff", 5543462373909)], r15[r16("\xbb\x15>\x0ciٸ\xa2\xc7͝\t\xce0\xfb\xbf]\x9d\x95N\xdc\xf4{\xa8", 26290838204370)] .. z, 2);
                else
                    r76(r15[r16("\\@_̻\xc5\x08G\x8e9/\xc3\xc9", 12299135620703)], r15[r16("o\xe8F\x8b\xa7\x90\xe2\x842\x8e;\xe2\xf5&\x95\xcc\xe17\xbdo*\x12\xe6\xb1\xf8>\xac\xfc", 25708395261635)], 2);
                end; 
            end;
            NH[27] = nil;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34]
            };
            NH[33] = "\x91\x10{#;\x07\x89\xbaw\x9e\xe5n@K\xfaS|\x83\xec";
            NH[30] = r15;
            NH[34] = 29119100040439;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[26].Input(NH[26], NH[28], NH[29]);
            NH[35] = 13860113062198;
            NH[33] = "\x83xy\xc0-\x8a";
            NH[26].Divider(NH[26]);
            NH[30] = r15;
            NH[34], NH[36] = 28771917509717, 24364744617041;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[34], NH[37] = "\x9b\xa2\x04\x9dI\xf0\x88\x00\x11\x1e\xf4\xa1\xf4\xcb.\x80S", 5114861226317;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[35] = "o{\xd9\xc7";
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[39], NH[36] = 32556749830968, "\xa0\xfe@\xdf\xfb#\x94\x0e;3\x9c\x99\xee\x88x\xe4{d\x01\x1da*\xcfQ\x97\xe7[\x1cg\xbd^{֐@g\xc1.\xef7@\xa8bs.\xd2{'}\xf2Dw\x1eEQ\xc0Jm\xe4X\t";
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[38], NH[36] = 1410438218384, 11973966779847;
            NH[28], NH[37] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32]
            }, 17860189954172;
            NH[26].Paragraph(NH[26], NH[28]);
            NH[30] = r15;
            NH[33], NH[35] = "rs\xff/", 33036835847191;
            NH[31] = r16;
            NH[34] = 13365643237455;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[40] = 19987397534811;
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[32] = r16;
            NH[34] = "\xdb\xd0\xed\x14\x8a\x96Q\x04\x19\xd5)\\\xb0h\xe3";
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[35] = "\xb7f\xd2%\xd5C\x11\x12\x91";
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[36] = "\x94\x8dn\x18\x07bԛş|ö\x96\xe2\xdc\x0e\x81>\xd9\xef\xde)/1J\xac`b\xcc(\"6\x81\xb8L\x06[\xfa\xcb\xfc\xee\x0c\xcbơfɘ\xbc\xba\xd5d4vc\xf9";
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[37] = "\x10Ќ\x1d\xb2S\xafR@mf";
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[38] = "\xa3";
            NH[33] = NH[34][NH[36]];
            NH[35] = r15;
            NH[36] = r16;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[36] = r15;
            NH[37] = r16;
            NH[39] = "V\xb9\xd7\x0ee\x06\"\xbb";
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_49, ...)
                r47[r15[r16("u\xb8\x0c?J\xadnH\x7fX2\xde0", 4315857176537)]](arg1_49); 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[30] = r15;
            NH[37], NH[38], NH[33] = 3739108460237, 9030889394285, "\xa5\xb4\x11\x9b♺ۂ\xd2M\xdbZ";
            NH[31] = r16;
            NH[34] = 2378739041363;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[35], NH[34], NH[33] = 3947874813742, 11862428308883, "\xfd\xeboq";
            NH[26].Input(NH[26], NH[28], NH[29]);
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[32] = r16;
            NH[34] = "M\xf0\xe1\xf1$P\x92]:\x19\xf20\xfa8\xdcSu\xe07\x8c\x91\xad\x0c";
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "\xfa{;sm\x06L4=";
            NH[32] = r15;
            NH[33] = r16;
            NH[36] = 11403126510781;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[36] = "[\xa0\xc0\x05\x9d\x02\xccl\xe9\x06B.\x9c\xb3\x9c\xde{:V\xa9W\xeax\x9f\xbaδ\xb0\x8a\x01\x128\xfa\x0b\xa2L\x9e\xdby3\xb1\xf9\x02\xbe\x1d\xa1\xf5\xed\xd6\x1a\xe1݋x\xf5}\xc6\xc773٭JOy\x15WQ\xa6Р\xc3̽\xd6i.[\x8eT\xb7\"\x026\xf3L\x02\x061*\n0\x08\x84\x9b\x87\xbc\xad\xb0o5\x7f1f\x8d4\x9e\xa5\xc7";
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[35] = r16;
            NH[37], NH[40] = "-\xfa\x1d*jv\xa63\xad\x0e\x9e", 31913859856909;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[35] = r15;
            NH[36] = r16;
            NH[38], NH[39] = "g", 31255969724634;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[36] = r15;
            NH[39] = "\xdc%\x04\x11\x18U\x0c/";
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_50, ...)
                r47[r15[r16("6\x07\xb6\xac\xd2\xe1\x04-g\xfc:\x0f{'s\x9e", 23511059196612)]](arg1_50); 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[30] = r15;
            NH[34] = 17157264105269;
            NH[31] = r16;
            NH[33] = "\xeeO\xf6\xb8@\xb1 F\xa8\x10B8\xf9\xaa\x85\x04";
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[34], NH[36], NH[33] = 12503426160318, 28152050512693, "\x01\xc6˺";
            NH[26].Input(NH[26], NH[28], NH[29]);
            NH[30] = r15;
            NH[37], NH[35] = 13753150281988, 19655566287808;
            NH[31] = r16;
            NH[43] = 33181728619611;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[34] = "\x04\xa3 \xa0@\xcejc4$\xafP\xa9\xe9\xb0\xfd\xbd\x96\x0b";
            NH[29] = NH[30][NH[32]];
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[35] = "S\x82X\x94\xb2\xab\xd5Ӷ";
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[23], NH[36] = nil, "\x00\xe1m%`\xc9z\xd5v\xfb\xec\x81\xdeK#\x12\xfc~^\xb1\x828)\nE\xa4\xfd?e\x84\x00R\x05\xae\x91<\x9d1]K\xea\xc1oi\xab\x8fV*#0=\x97\x1b\xefSv\xc8+:f v%-ˌ9\xcb\xe6\x90+j\xc2K\x14\x84U\x1dm\"gɪ\xfeV\xf4\x06\xbc\xba\xfe\x8e\x98%!\xb1>\xed\xc7)4\xe0\x8f˕\x8d\x81\x9d\xaa";
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[37], NH[40], NH[38] = "+\xa1\x8e\xd8\x06~y5\xa4\xb8\xcc", 26052285902691, 25199028678102;
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[38] = "\x13";
            NH[35] = r15;
            NH[36] = r16;
            NH[39] = 19258516628231;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[36] = r15;
            NH[37] = r16;
            NH[39] = "\xf8=\xfdM\xa7\xf9\xc1\x11";
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[36] = function(arg1_51, ...)
                r47[r15[r16("\xcb\xf5!07\xd4!\xd14\\U\x10", 15723051834521)]](arg1_51); 
            end;
            NH[28] = {
                [NH[29]] = NH[30],
                [NH[31]] = NH[32],
                [NH[33]] = NH[34],
                [NH[35]] = NH[36]
            };
            NH[30] = r15;
            NH[31] = r16;
            NH[33], rH, NH[34] = "\xc6\xde-\x0cl\xa0\xe7H\xe3\x1fc\xaf", nil, 13193244563455;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            NH[35], NH[32], NH[34], NH[33] = 29583164896719, "\x02\x87-\x01", "\x98!4\xe4", 19639831307193;
            NH[26].Input(NH[26], NH[28], NH[29]);
            NH[29] = r15;
            NH[36] = 2373617075281;
            NH[30] = r16;
            NH[31] = NH[30](NH[32], NH[33]);
            NH[45] = 3046833407370;
            NH[28] = NH[29][NH[31]];
            I = JY[NH[28]];
            NH[31] = r15;
            NH[32] = r16;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "jЪ3\xd0";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[28], NH[29] = "Section", {
                [NH[30]] = NH[31]
            };
            NH[28] = I[NH[28]];
            NH[28] = NH[28](I, NH[29]);
            NH[35] = 24754692549895;
            NH[39] = 1636519052026;
            NH[31] = r15;
            NH[36] = 7764436028959;
            NH[32] = r16;
            NH[34] = "<\xaa*\xa8";
            NH[33] = NH[32](NH[34], NH[35]);
            NH[30] = NH[31][NH[33]];
            NH[35] = "\xf17\xa7\xee\xc3\x11\x02\xeb=\x8b\x9a\xe8";
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[29], NH[38] = {
                [NH[30]] = NH[31]
            }, "\x9b\xf15\x89\xf0\x08S\xc9";
            NH[28].Header(NH[28], NH[29]);
            NH[31] = r15;
            NH[32] = r16;
            NH[37], NH[34] = 25624625983132, "`\xa6x\xb4";
            NH[35] = 226080817257;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[35], NH[36] = "FM\x86\xe5\xf5Ԩ+X\r\xc4q\x05\x05\xf1\x1c", 1544287224527;
            NH[30] = NH[31][NH[33]];
            NH[32] = r15;
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[40] = 32651102272356;
            NH[33] = r15;
            NH[34] = r16;
            NH[26], NH[36] = nil, "\xfb\xb4K\x07\xae\xd3\xe2";
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[33] = true;
            NH[35] = r15;
            NH[36] = r16;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[35] = function(arg1_52, ...)
                r113 = arg1_52;
                task[r15[r16("\x1c\xd8\t\xa9\xe4", 34101037055495)]](function(...)
                    v1 = r113;
                    P = r24;
                    while not v1 do
                        if P then
                            v1 = r28[r15[r16("/\xec\x0b\xf3j\x04\xbf\xfd\xa6", 10427651412727)]];
                            if v1 then
                                z = v1.FindFirstChild(v1, r15[r16("\x1cTc\x80k\x88\x99\x94", 5952376228563)]);
                                if z then
                                    z[r15[r16("AE;\xf0\xb2\x140\xf3\xca", 1295404008027)]] = math[r15[r16("\x06\xeey\xd3", 22290079737995)]];
                                    z[r15[r16("\xa6\xceEX\xb6\xbc", 9900251058690)]] = math[r15[r16("NH\xd1p", 12698530518809)]];
                                end;
                            end;
                            task[r15[r16("-\"\xf30", 26029188198232)]](1);
                        end;
                        return; 
                    end;
                    P = r24; 
                end); 
            end;
            NH[29] = {
                [NH[30]] = NH[31],
                [NH[32]] = NH[33],
                [NH[34]] = NH[35]
            };
            NH[34] = "\x11\xed\x10S\x0f`J\xc5\x14\xde";
            NH[31] = r15;
            NH[32] = r16;
            NH[35] = 18931140452975;
            NH[33] = NH[32](NH[34], NH[35]);
            NH[34] = 8770128138227;
            NH[30] = NH[31][NH[33]];
            NH[28].Toggle(NH[28], NH[29], NH[30]);
            NH[33] = "\xeb\x9d\xcay";
            NH[30] = r15;
            NH[31] = r16;
            NH[32] = NH[31](NH[33], NH[34]);
            NH[29] = NH[30][NH[32]];
            I = JY[NH[29]];
            NH[32] = r15;
            NH[36] = 22758675949925;
            NH[33] = r16;
            NH[35] = "o/\xdd9";
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[33] = r15;
            NH[34] = r16;
            NH[29], NH[36], NH[37] = "Section", "\x7f\x1e|,", 7257827560755;
            NH[29] = I[NH[29]];
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[37], NH[30], NH[36] = 77730005028, {
                [NH[31]] = NH[32]
            }, 25927392259881;
            NH[29] = NH[29](I, NH[30]);
            NH[32] = r15;
            NH[33] = r16;
            NH[35] = "&\xb2\x9b\xc9";
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            NH[36] = "{\x97\x8d*T\xc0\x07\x82\x97\x16\xb9\x9f\x95\x91\x8ck\x9a\x0f\xf0*rl\xa8&\xf3\xa1";
            NH[33] = r15;
            NH[39], NH[42] = 4698794084492, "(\x1d^\xb5\x1e-Y";
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[30] = {
                [NH[31]] = NH[32]
            };
            NH[29].Header(NH[29], NH[30]);
            NH[30] = 125;
            F[NH[30]] = function(...)
                if r70 and r70 ~= r15[r16("", 26913393848564)] then
                    I = r74[r15[r16("R=#\xb5\x8fC[\xb2\xa9r\xd3\x00]\xc2\xef\xabS", 18895070667358)]];
                    I.InvokeServer(I, {
                        [r15[r16("\xbf\xf8\xbd\xed)\xbf", 13830880287016)]] = r70
                    });
                end; 
            end;
            NH[33] = r15;
            NH[37], NH[36] = 16928050421450, "bF\x9c\xaf";
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[38], NH[37] = 2969215190374, "\x1d\xfc\ry2\x12\xed\xcc\xcd\xfc\x17{\xed\xab\xf6'TF\xe5N[<\xaf\x0f\x8dr\xb5\x81\xe8J\xca\x7f\xfa\xc2";
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[38] = "\xe5\x18\x00ᤁ\x12%\xdd/.";
            NH[33] = NH[34][NH[36]];
            NH[35] = r15;
            NH[36] = r16;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[36] = r15;
            NH[37] = r16;
            NH[39] = "\\\x92\x1e";
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[37] = r15;
            NH[40] = "\xc1j\xea\xe0&\xc1z\xca";
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[38] = 18536076845495;
            NH[36] = NH[37][NH[39]];
            NH[37] = function(arg1_53, ...)
                r70 = arg1_53; 
            end;
            NH[31] = {
                [NH[32]] = NH[33],
                [NH[34]] = NH[35],
                [NH[36]] = NH[37]
            };
            NH[37] = 24338625408069;
            NH[33] = r15;
            NH[36] = "Rs\xc5\x11\x82\xb9\xc2)\x11V\x12T?h";
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[40] = "\xc8A(00\x977\x9c";
            NH[32] = NH[33][NH[35]];
            NH[36] = "\x95o\xe5\xa5";
            NH[29].Input(NH[29], NH[31], NH[32]);
            NH[37] = 27049895063860;
            NH[33] = r15;
            NH[41], NH[39] = 34814331109203, 13908945852748;
            NH[34] = r16;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[37], NH[1] = "v\x8f,\x80\x00X\xaf\xd4R\xa4\xdbw\x1f\xf6*p\x12k\nb\xf2\xd8", nil;
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[35] = r15;
            NH[36] = r16;
            NH[38] = "\xf1Y.\x13\x97\xa1\x8d";
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[35] = false;
            NH[37] = r15;
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[36] = NH[37][NH[39]];
            NH[37] = function(arg1_54, ...)
                if not arg1_54 then
                    return;
                end;
                F[NH[30]]();
                r76(r15[r16("\x17\xc0\x8c\xddl\xa3\xb6\xf8ЋN\xe2:\x06\x00\x80\x90\xa3\xcc", 18762157679136)], r15[r16("\\kw\x89\n\xfd\x05Ya\xa19\ra\x8cP\xe8v]\xb0\xb5?[\x15\t4\xa8\xc6<", 15453233077275)], 3); 
            end;
            NH[31] = {
                [NH[32]] = NH[33],
                [NH[34]] = NH[35],
                [NH[36]] = NH[37]
            };
            NH[36] = "\x84\xfbO\xa17\xa6GɴV\x8fˈ\x03'\xa7K\x01";
            NH[33] = r15;
            NH[41] = 26351052959726;
            NH[34] = r16;
            NH[44], NH[37], NH[39] = "Gѿwc\x85lr", 25254584987120, 497864311015;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[36] = "fN#\x13";
            NH[29].Toggle(NH[29], NH[31], NH[32]);
            NH[38], NH[40] = 14369898043939, "\x81\xdf9L\x01>\x19P";
            NH[33] = r15;
            NH[37] = 20398676731162;
            NH[34] = r16;
            NH[24] = nil;
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[34] = r15;
            NH[35] = r16;
            NH[37] = "\x01\xbd\xc7'K\x95\xd31Y\xfe\xa2S\xf7\x11\x8a\x1ek̶K*\xfbԝ";
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[38] = "T\x06\xd9\xc0\xb8\xa12";
            NH[35] = r15;
            NH[36] = r16;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[37] = r15;
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[35] = false;
            NH[36] = NH[37][NH[39]];
            NH[37] = function(arg1_55, ...)
                v1 = arg1_55;
                r71 = v1;
                if v1 then
                    r76(r15[r16("\xa5\xe1\xcaXv\xad\xf5\xe8\x87\xcd\x1d\xce\t\xe2\xca[*%s", 15665302051966)], r15[r16("\xfc\xb5\r)\x8a\x8a\xac\x9a\x07r\xa8\x04Pm\xb5\nD\x18\xe3", 22787944049011)], 3);
                    P = r25[r15[r16("\xa5\xe9\xb1\x0f\x1bO\xeb\xf5E6@", 1066931913200)]][r15[r16("\xa6\xa4ԍ\x89ey;\x8f\x7f", 28363832570775)]];
                    r72 = P.Connect(P, function(arg1_56, ...)
                        v1 = arg1_56;
                        if r71 then
                            z = r25;
                            I = #z.GetPlayers(z) <= 1;
                            if I then
                                I = r30;
                                I.Teleport(I, game[r15[r16("\x81L|Y\xe1ƹ", 13632760142028)]], r25[r15[r16("\xcd\x01\xdc\xc6ֽ\xa6@tnY", 19998072382560)]]);
                            else
                                I = r30;
                                I.TeleportToPlaceInstance(I, game[r15[r16("\xa0`\x01~j8[", 1949588620171)]], game[r15[r16("e#\x01i?", 1207063986738)]], r25[r15[r16("\x9e\xdd\xf1\n\x8d\x89@\xe4!{\x19", 27255899943316)]]);
                            end;
                        end; 
                    end);
                else
                    if r72 then
                        P = r72;
                        P.Disconnect(P);
                    end;
                    r76(r15[r16("\x9a\xa2\x989\x97\x7f\xfe\x04s\x8cf\xa4\xa3+HS\xd5Z\xae", 27876980880053)], r15[r16("7\xb9\xfau\xb0\xc8\x05\x8c\x04\xc9\xf1ے\xa0Ȯ\xc5\xf3;#\xdc", 1284794008150)], 3);
                    return;
                end; 
            end;
            NH[31] = {
                [NH[32]] = NH[33],
                [NH[34]] = NH[35],
                [NH[36]] = NH[37]
            };
            NH[33] = r15;
            NH[40] = 15443261463575;
            NH[34] = r16;
            NH[37], NH[36] = 18984921686664, "\xa6nI./f\x14\x8a\x96\xb1";
            NH[35] = NH[34](NH[36], NH[37]);
            NH[32] = NH[33][NH[35]];
            NH[29].Toggle(NH[29], NH[31], NH[32]);
            NH[36], NH[39] = 11587679442195, 728600019283;
            NH[32] = r15;
            NH[35] = "\xd8N:7";
            NH[33] = r16;
            NH[34] = NH[33](NH[35], NH[36]);
            NH[31] = NH[32][NH[34]];
            I = JY[NH[31]];
            NH[52], NH[38] = 6273863420777, 15115674295166;
            NH[37] = "\xd2B`\xd8";
            NH[34] = r15;
            NH[35] = r16;
            NH[36] = NH[35](NH[37], NH[38]);
            NH[38] = "\x99\xc1\x1e\xc6";
            NH[33] = NH[34][NH[36]];
            NH[35] = r15;
            NH[31] = "Section";
            NH[36] = r16;
            NH[31] = I[NH[31]];
            NH[37] = NH[36](NH[38], NH[39]);
            NH[38] = 14556894648954;
            NH[34] = NH[35][NH[37]];
            NH[32] = {
                [NH[33]] = NH[34]
            };
            NH[31] = NH[31](I, NH[32]);
            NH[39] = 19814468396042;
            NH[34] = r15;
            NH[35] = r16;
            NH[37] = "\xfe\x93\x05\xb9";
            NH[36] = NH[35](NH[37], NH[38]);
            NH[33] = NH[34][NH[36]];
            NH[35] = r15;
            NH[36] = r16;
            NH[38] = "?\xbd&\xe4f\xcb\xf4>\xe4\xdbZ\x9b";
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[32] = {
                [NH[33]] = NH[34]
            };
            NH[31].Header(NH[31], NH[32]);
            iY, NH[38], NH[32] = nil, "B\x9c.,", "getPlayerHouses";
            Env[NH[32]] = function(...)
                v1 = {};
                I = r27;
                z = I.FindFirstChild(I, r15[r16("KD\xdbqH", 33379702291639)]);
                o = z and z.FindFirstChild(z, r28[r15[r16("\xa1\xb6f\xda", 30719354419168)]]);
                W = o and o.FindFirstChild(o, r15[r16("\xd2\x1d\x05\xc1}s", 8968721698896)]);
                if not W then
                    warn(r15[r16("\xd6\xc1g;\x16\xbfW|!zv\x04\x93\xe8\x15#\xc1\x96E7h\xb5", 25245225250283)]);
                    return v1;
                end;
                S = {
                    W.GetChildren(W)
                };
                for q, L in ipairs(K("ipairs")) do
                    M = q;
                    table[r15[r16("\"%\xb4\x10\xc3G", 14071059159448)]](v1, L[r15[r16("NXb\xc1", 22877667551645)]]); 
                end;
                return v1; 
            end;
            NH[32] = 126;
            F[NH[32]] = function(...)
                I = workspace;
                v1 = I.FindFirstChild(I, r15[r16("\xf37\x84\x00g", 24875184254271)]);
                if not v1 then
                    return false;
                end;
                return v1.FindFirstChild(v1, r15[r16("\x90k@٪", 32833216838585)] .. game[r15[r16("R\x80@\xb6\xa9˴", 3146528523705)]][r15[r16("\xb8\xfbc\n\xc2\xe1e;6\xaf\xb6", 14945397152559)]][r15[r16(">\x83`6", 18047521464532)]]) ~= nil; 
            end;
            NH[35] = r15;
            NH[39] = 17516426567644;
            NH[36] = r16;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[39] = "\xaf雘\x92\x07m\xa5\xd08\xb0)\xcf=\xddM\xf2\xd0\xf3\x8b";
            NH[34] = NH[35][NH[37]];
            NH[41] = 9214202335426;
            NH[36] = r15;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[37] = r15;
            NH[40] = ";^j~Uo\xf1";
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[38] = "getPlayerHouses";
            NH[36] = NH[37][NH[39]];
            NH[37] = Env[NH[38]];
            NH[38] = NH[37]();
            NH[39] = r15;
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[37] = NH[39][NH[41]];
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[41] = function(arg1_57, ...)
                r69 = arg1_57; 
            end;
            NH[39] = 1;
            NH[33] = {
                [NH[34]] = NH[35],
                [NH[36]] = NH[38],
                [NH[37]] = NH[39],
                [NH[40]] = NH[41]
            };
            NH[35] = r15;
            NH[39] = 10281134248627;
            NH[36] = r16;
            NH[38] = "%\xa6\x89\x9d\xb2j\xc4\xfe\xa3VSۮ!";
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            NH[31].Dropdown(NH[31], NH[33], NH[34]);
            NH[44] = 28310777721727;
            NH[33] = 127;
            NH[39], NH[41] = "\x1b\xcd\x19\r", 16679593549399;
            F[NH[33]] = false;
            NH[47], NH[40] = 21576960665407, 26361189101555;
            NH[36] = r15;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[37] = r15;
            NH[43], NH[40] = "\x87\x00\xe0\x0b3\xf8\xadN", "E\xef\xfb\xf2~5#\xf6\xfb\xe3\t5\x13EQ";
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[36] = NH[37][NH[39]];
            NH[41], NH[42] = "\xd5\xdcm\xf2}>\x85", 30279206631187;
            NH[38] = r15;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[11] = nil;
            NH[37] = NH[38][NH[40]];
            NH[29], NH[38] = nil, false;
            NH[40] = r15;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[40] = function(arg1_58, ...)
                v1 = arg1_58;
                F[NH[33]] = v1;
                if not v1 then
                    return;
                end;
                task[r15[r16("L\xb9\xd9Ӧ", 17886657536137)]](function(...)
                    o = not r69;
                    P = tick() - tick() < 5;
                    while not o do
                        if o then
                            if not F[NH[33]] then
                                return;
                            else
                                task[r15[r16("\xddR\xac\\", 22350734469287)]](.2);
                            end;
                        end;
                        if not r69 then
                            r76(r15[r16("8u\ts`", 21003386496564)], r15[r16("#)\xee!X\xa9f\xc6%=C)m\xcfǭ.", 19171451544287)]);
                            return;
                        end;
                        while F[NH[33]] do
                            if F[NH[32]]() then
                                r76(r15[r16("ں#l\x8a\xdc\xc9\xf3\xedƧa", 6151284067120)], r15[r16("l\x8c\xa9-nLO\xbe\xb1-\x8bGM\x9b\xd2\xc6]\xc1\xb6XG&(\x8e\xe0x", 32591065938760)]);
                                F[NH[33]] = false;
                                break;
                            else
                                P = r74[r15[r16("\x07\x18\xd3\xf9!\xa4+\xb5\x81", 34287125855838)]];
                                P.InvokeServer(P, {
                                    [r15[r16("e\x83\xeb\x83\xcb", 6879884086403)]] = r69
                                });
                                task[r15[r16("\x92\x91\xfe\xa8", 11963588482498)]](1);
                                P = r74[r15[r16(">\xa4\xef\xf24\xd0", 18917222146665)]];
                                P.InvokeServer(P, {
                                    [r15[r16("T\xdf\x14\xbe2\xac", 5075214272827)]] = r28[r15[r16("O\x7f\xd0M", 7498570796451)]]
                                });
                                task[r15[r16("\x01ĕ\x00", 27885943845561)]](3);
                            end; 
                        end;
                        return; 
                    end;
                    P = tick() - tick() < 5; 
                end);
                r76(r15[r16("\x11%\xd3W\xe7\x02\xac\x9e\xef\xb4\xe6]", 30320439523111)], r15[r16("AX\x06\x8c\x17\xe1\xfa\x8e\xa9\x85f\x91O\x826\x0eU\x03i6\xbe", 21569629972284)], 3); 
            end;
            NH[34], NH[41], NH[43] = {
                [NH[35]] = NH[36],
                [NH[37]] = NH[38],
                [NH[39]] = NH[40]
            }, 19218474705653, 11295826416780;
            NH[36] = r15;
            NH[40], NH[39] = 15579239291990, "\xc2\x91\xff\x8a[\xd4A\x88M\x01'\x01\x86";
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            NH[39] = 20011251688550;
            NH[31].Toggle(NH[31], NH[34], NH[35]);
            NH[40], NH[38] = "\xf7\xd5B\xfc", "\xd03\x10A";
            NH[35] = r15;
            NH[36] = r16;
            NH[42] = 18725767815695;
            NH[37] = NH[36](NH[38], NH[39]);
            NH[34] = NH[35][NH[37]];
            I = JY[NH[34]];
            NH[37] = r15;
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[36] = NH[37][NH[39]];
            NH[41] = ")&\xd4ϩ";
            NH[38] = r15;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[42], NH[41] = 2081624081353, 34956648841109;
            NH[37] = NH[38][NH[40]];
            NH[35], NH[40], NH[34] = {
                [NH[36]] = NH[37]
            }, "\xea\xdc\x1c\xd9", "Section";
            NH[34] = I[NH[34]];
            NH[34] = NH[34](I, NH[35]);
            NH[37] = r15;
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[36] = NH[37][NH[39]];
            NH[41] = "Ȃ2ⓡV\xa3\xf7CQ\xa0H\xbf\xfd";
            NH[38] = r15;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[37] = NH[38][NH[40]];
            NH[41], NH[40], NH[35] = 1057822294508, "p\x95#1", {
                [NH[36]] = NH[37]
            };
            NH[34].Header(NH[34], NH[35]);
            NH[45] = 18262371606840;
            NH[37] = r15;
            NH[38] = r16;
            NH[42] = 15215538199469;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[41] = "\xef\xa30\xba%\x86\x16\xdc\x1f\xfe \xd9;\xdf\xe0|\xbd";
            NH[36] = NH[37][NH[39]];
            NH[44] = 34239550914120;
            NH[38] = r15;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[37] = NH[38][NH[40]];
            NH[39] = r15;
            NH[40] = r16;
            NH[42] = "\xd3\x06\\\x81ռ3z\xa8";
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[40] = r15;
            NH[43] = "{\x0f\xe4?\x01\x1a\x03{Ϸ\x96\xce\x07\xbc\xaa-\x90h\x00=\x98\x01\xe8\xe8\xa9\xc7\xe0ƿjw\x86\xe9X8\xec\x19\xf2\xd8\xd5/qr;`Z\x93K\xe5\x0f\xbeM\xf5";
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[44] = "\x95\x85/\xe5\xe0\xf4\x83";
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[41] = false;
            NH[43] = r15;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[43] = function(arg1_59, ...)
                if not arg1_59 then
                    return;
                end;
                I = r27;
                z = I.WaitForChild(I, r15[r16("\xe3\x05\x02\xd6Z", 25416367910459)]);
                o = z.WaitForChild(z, r28[r15[r16("|\xb5\\\xc3", 34941965156239)]]);
                W = o.WaitForChild(o, r15[r16("W\xbc\x1e\x1ct\xcfE\xa9_\xe2", 16671795207763)]);
                S = {
                    W.GetChildren(W)
                };
                for q, L in pairs(K(P)) do
                    M = q;
                    if L.IsA(L, r15[r16("ʩ\xc6\xf4Pz\t\x88\xe1", 18542773526970)]) then
                        L[r15[r16("-\xe8E\xbfA", 17644250587160)]] = true;
                    end; 
                end;
                r76(r15[r16("E\xfb\xcf\xf0{\x19", 3838157571835)], r15[r16("0\x86\xfb\x03;\xfb\xd1\\\x91\x83\xafyC\xb3S-\x9c}\xa8\x9d", 4361787918319)], 3); 
            end;
            NH[35] = {
                [NH[36]] = NH[37],
                [NH[38]] = NH[39],
                [NH[40]] = NH[41],
                [NH[42]] = NH[43]
            };
            NH[41], NH[40] = 1631330042615, "#d\xcc\xc8\x0bR\xe1a";
            NH[37] = r15;
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            XY, NH[42] = nil, 1768481768247;
            NH[36] = NH[37][NH[39]];
            NH[43] = 734083793237;
            NH[34].Toggle(NH[34], NH[35], NH[36]);
            NH[39], NH[40], NH[41] = "\x1b\xbdf\xd2", 9989441638955, "p-&|";
            NH[36] = r15;
            NH[37] = r16;
            NH[38] = NH[37](NH[39], NH[40]);
            NH[35] = NH[36][NH[38]];
            I = JY[NH[35]];
            NH[38] = r15;
            NH[39] = r16;
            NH[35] = "Section";
            NH[35] = I[NH[35]];
            NH[40] = NH[39](NH[41], NH[42]);
            NH[42] = "`F\xee\x9d";
            NH[37] = NH[38][NH[40]];
            NH[39] = r15;
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[41], NH[42], NH[36] = "\xd1qG\x84", 16869325725359, {
                [NH[37]] = NH[38]
            };
            NH[35] = NH[35](I, NH[36]);
            NH[45] = 12352877680248;
            NH[38] = r15;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[44], NH[49] = 21230641063582, 32001194900021;
            NH[37] = NH[38][NH[40]];
            NH[39] = r15;
            NH[42], NH[43] = "U\x83\x98\x16\xa8\x1c\xa1\xfd\xcc", 13732070250746;
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[42] = 19651305939902;
            NH[38] = NH[39][NH[41]];
            NH[36], NH[4] = {
                [NH[37]] = NH[38]
            }, nil;
            NH[35].Header(NH[35], NH[36]);
            NH[43], NH[41] = 21944539998186, "\xbdJB\xf3\x98\x17";
            NH[38] = r15;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[37] = NH[38][NH[40]];
            NH[42] = "sQ+\x7f\xd0eu ";
            NH[39] = r15;
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[40] = r15;
            NH[41] = r16;
            NH[43] = "\xd3\x0b\xcd\xce";
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[47], NH[44] = 26834373636303, ".\t\xa6\x82\xe3D\x19\xdf\xf7\x85y\xa2\rRk;O\xc0\t\xcct\xbb]\x1dg@\x8cV\xb6r\x1f\xbd\xf8c\xb5\xee\x1f\xe3>\xb9b\xfc\x89\xf8\xf7\x1a\xe9Db\x05\xe0\xabX\xae\xc8#4\xf8\x87y\x87qw\xa2\xa3\xd4\x06J\x0e~xRkJ\x08\xbaY\xea\xe5p\xef";
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[42], NH[36], NH[46] = 17080607432465, {
                [NH[37]] = NH[38],
                [NH[39]] = NH[40]
            }, 1907487015800;
            NH[35].Paragraph(NH[35], NH[36]);
            NH[38] = r15;
            NH[44], NH[41], NH[43] = 27932116972238, "\x8eҏ\xdb", 7615898930650;
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[30] = nil;
            NH[37] = NH[38][NH[40]];
            NH[39] = r15;
            NH[40] = r16;
            NH[42] = "\xa9\xe5fE2}l\x0cu";
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[40] = r15;
            NH[41] = r16;
            NH[43] = "\x80\xdc\xd4#\x9fI\xd2";
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[40] = false;
            NH[45] = "G;2\xde\xfa\xaeBt\xc5";
            NH[42] = r15;
            NH[43] = r16;
            NH[28] = nil;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            NH[43] = r15;
            NH[44] = r16;
            NH[46], S = "G\xdb4e?\x9bU\x90vj\x83\x85d\x9bKm\xbb\x90{7\xfd\xdd:S\xa3\xc3\xef\x991\xf9>N\x87\x95\xc9>\xd2\x11DU\xf0ɔz\xbd\xf7\x86\xfa\x92\xd3<'\x1c\xcc嚬\xb6\x17\x02\\\xbbC\xf3\xf5\xedS\xbcY\xbe", nil;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[44] = r15;
            NH[45] = r16;
            NH[47] = "4@\xee\xf6\xb1\xa49^";
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[44] = function(arg1_60, ...)
                r114 = arg1_60;
                pcall(function(...)
                    I = r28[r15[r16("\xbe\xb2\x97\x9d&-4Z\xd5", 1679763751694)]][r15[r16("\xac4\x1c8\xe3R\xe2z\xc6\xe6\xe6", 28915997717657)]];
                    I[r15[r16("ߞB\x9bh\x14`", 12531334977227)]] = not r114;
                    I = r28[r15[r16("g|rpB\xe0T`j", 16895301951163)]];
                    I[r15[r16("\x9c\xf0\x12'Q?Q\xd0J\x05\xd0H\x1b|鷼", 5027452029221)]] = not r114; 
                end); 
            end;
            NH[36] = {
                [NH[37]] = NH[38],
                [NH[39]] = NH[40],
                [NH[41]] = NH[42],
                [NH[43]] = NH[44]
            };
            NH[42] = 11586513802515;
            NH[38] = r15;
            NH[41], NH[43] = "\x8b_\xf1\xbd)\xb3\x85~", 26604412711012;
            NH[39] = r16;
            NH[18] = nil;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[37] = NH[38][NH[40]];
            NH[41], NH[40] = 35157673558003, "\x9f\xa6\xd9~";
            NH[35].Toggle(NH[35], NH[36], NH[37]);
            NH[37] = r15;
            NH[38] = r16;
            NH[39] = NH[38](NH[40], NH[41]);
            NH[36] = NH[37][NH[39]];
            I = JY[NH[36]];
            NH[39] = r15;
            NH[42] = "\"\xce&J";
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[43] = "\x99\x85<\x1au";
            NH[38] = NH[39][NH[41]];
            NH[40] = r15;
            NH[41] = r16;
            NH[44] = 1818509607758;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[47] = 19006475133586;
            NH[39] = NH[40][NH[42]];
            NH[37], NH[36] = {
                [NH[38]] = NH[39]
            }, "Section";
            NH[36], NH[44] = I[NH[36]], 8091835813560;
            NH[36] = NH[36](I, NH[37]);
            NH[42] = "J\x889%";
            NH[39] = r15;
            NH[40] = r16;
            NH[43] = 34915266609026;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[40] = r15;
            NH[41] = r16;
            NH[43] = "\n{\x12\t\xa0=\x95\xf4Z\xe6";
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[37], NH[42] = {
                [NH[38]] = NH[39]
            }, "\x96\x9a\x10\xd1";
            NH[36].Header(NH[36], NH[37]);
            NH[31] = nil;
            NH[39] = r15;
            NH[43], NH[44] = 20361283151113, 17375145090970;
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[43], NH[48], NH[45] = "\xc1+LyD\xe5\xc7,1M", 26076191600494, 11929993385395;
            NH[38] = NH[39][NH[41]];
            NH[40] = r15;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[44] = "o䀂\xa3\xfcA\x95-L|";
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[45] = "\x17\xearė\xeb\x07";
            NH[42] = r15;
            NH[46] = 24723071069432;
            NH[43] = r16;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[46] = "\x82\x95)\x90h\xe9:\xc0";
            NH[41] = NH[42][NH[44]];
            NH[43] = r15;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[43] = function(arg1_61, ...)
                I = r57;
                I[r15[r16(")6\x89~\x02m%\xbe\x8a", 21919435040735)]] = arg1_61; 
            end;
            NH[37], NH[44] = {
                [NH[38]] = NH[39],
                [NH[40]] = NH[41],
                [NH[42]] = NH[43]
            }, 3604388660878;
            NH[39] = r15;
            NH[43] = 26491552837680;
            NH[40] = r16;
            NH[42], NH[46], NH[45] = "a\x97iX˩.\xd7\xde", 4207492761511, 5039250999594;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[42] = "Cq3\xb9";
            NH[36].Input(NH[36], NH[37], NH[38]);
            NH[43] = 19740558926824;
            NH[39] = r15;
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[40] = r15;
            NH[41] = r16;
            NH[43] = "݂cP\x8b\x9a\xa8y9˶Z\xe7";
            NH[42] = NH[41](NH[43], NH[44]);
            NH[44] = ")\xe6\xe3\xbc\xf8\xec\x8fdg\xb8\xf6";
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[42] = r15;
            NH[43] = r16;
            NH[47], NH[45] = 25548928675449, "\xc5\x05\x16\xfc\x9e";
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            NH[46] = "\xa0\xe1\xb8j6\n;";
            NH[43] = r15;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[43] = function(arg1_62, ...)
                I = r57;
                I[r15[r16("\x7fЖ\xbb\xe2\xde\xc5\xc1\xe0\xfd\x82\xbc", 26269892063176)]] = arg1_62; 
            end;
            yH, NH[37] = nil, {
                [NH[38]] = NH[39],
                [NH[40]] = NH[41],
                [NH[42]] = NH[43]
            };
            NH[39] = r15;
            NH[43] = 16560370441759;
            NH[40] = r16;
            NH[42] = "a\xf7\x1a\xafȕ\x06J&*\x11\xa4";
            NH[41] = NH[40](NH[42], NH[43]);
            NH[45] = 9308115308782;
            NH[38] = NH[39][NH[41]];
            NH[42] = "%f\xbd\n";
            NH[19] = nil;
            NH[36].Input(NH[36], NH[37], NH[38]);
            NH[39] = r15;
            NH[40] = r16;
            NH[43] = 7445164002698;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[44] = 33885790993827;
            NH[40] = r15;
            NH[41] = r16;
            NH[43] = "\x9fmQ\xad\xd6\xddǂ\x10\xfc\xea\x1f\xb8舌";
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[44] = "x\xcaI\xd0{Mׁ";
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[41] = function(...)
                I = r27;
                v1 = I.WaitForChild(I, r15[r16("\xb5HO\x0c\xb2", 9352651018499)]);
                z = v1.FindFirstChild(v1, r28[r15[r16("\x04v\x84\x0f", 25535792524915)]]);
                if z then
                    I = z.FindFirstChild(z, r15[r16("\xe4\xf2\n\xfcT1\x08\xa4", 11032414770193)]);
                    if z.FindFirstChild(z, r15[r16("\rs\x0e\x81\xc9", 20781628007885)]) then
                        I = r15[r16("\x84\x1f@\xa1O", 19267418153740)];
                        T = I;
                        o[I] = tonumber(r57[r15[r16("\xffK;/\xd7\x03!.\x12", 33312962985112)]]) or 1000000;
                    end;
                    if I then
                        q = I;
                        W[r15[r16("{6\xea\x90>", 27927716721356)]] = tonumber(r57[r15[r16("\xb8\xac\x15=\xfd?[ҥ5\xe3\xac", 24294870182961)]]) or 10000;
                    end;
                    r76(r15[r16("X\x8fE\x12\xa4\x1c\xb2{\x18\xf8", 9715104682411)], r15[r16("\x04\xf3wP^E9\xa9\xf1h\xb0\x16\x1cՌ5\x14a\xa6\x9aʔF\xbc\xe5\xfb\x89H\xafPp", 27901018174144)], 3);
                else
                    r76(r15[r16("\x8c4\x9dk'", 15714910788757)], r15[r16("\xa6\xd9V\x8cV,\xe0XU\n\xa2\xa8\xd7\xd5.(H'\x03G!5::\xa4\xf9\xc0", 11533614306554)], 3);
                end; 
            end;
            NH[37], NH[43] = {
                [NH[38]] = NH[39],
                [NH[40]] = NH[41]
            }, 27631912677955;
            NH[39] = r15;
            NH[44] = 31894897457668;
            NH[42] = "\x03.\x06hC>\xa1\x82\x9c\xfe|\x9dEK";
            NH[40] = r16;
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[42] = 23806746602317;
            NH[36].Button(NH[36], NH[37], NH[38]);
            NH[43] = "\n\x0fi\x82";
            NH[38] = r15;
            NH[41] = "\xc9}\xccD";
            NH[39] = r16;
            NH[40] = NH[39](NH[41], NH[42]);
            NH[37] = NH[38][NH[40]];
            I = JY[NH[37]];
            NH[37], NH[45], NH[47] = "Section", 9822685663710, 13385347635289;
            NH[40] = r15;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[44], NH[37], NH[46] = "D\x9b\x13\xee", I[NH[37]], 12740777170732;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[45], NH[36], NH[43], NH[38], NH[44] = 21433596421884, nil, "0\xc7Q\xf4", {
                [NH[39]] = NH[40]
            }, 552367898881;
            NH[37] = NH[37](I, NH[38]);
            NH[40] = r15;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[44] = "\x99\x18O;[̂\x9fB胺\xe8IP}\x81";
            NH[43] = NH[42](NH[44], NH[45]);
            NH[44] = 28829160813680;
            NH[40] = NH[41][NH[43]];
            NH[43] = "[@\xcf\xd9";
            NH[38] = {
                [NH[39]] = NH[40]
            };
            NH[37].Header(NH[37], NH[38]);
            NH[40] = r15;
            NH[45] = 22471802939616;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[44] = "/\x17\xc6z\xabT\x94y\xe3";
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[45] = "\xb7@M\x93\xbd\xac\xa0\xd9Y\xfa\xd6";
            NH[42] = r15;
            NH[43] = r16;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            NH[43] = r15;
            NH[44] = r16;
            NH[46] = "\xa0";
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[44] = r15;
            NH[47] = "Z\x0b\xd1\xd4͑\x12\x04";
            NH[45] = r16;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[44] = function(arg1_63, ...)
                I = r57;
                I[r15[r16("&\xd2:K\xb9\x9fS\x01", 17780028170327)]] = arg1_63; 
            end;
            NH[38] = {
                [NH[39]] = NH[40],
                [NH[41]] = NH[42],
                [NH[43]] = NH[44]
            };
            NH[40] = r15;
            NH[41] = r16;
            NH[43], NH[45], NH[46], NH[44] = "\xab4\xa9J\x07MpJ", 8865548128288, 34153210854943, 17592840413184;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[43], NH[44] = "\x83\x15\xb1\xd4", 16440748170727;
            NH[37].Input(NH[37], NH[38], NH[39]);
            NH[40] = r15;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[41] = r15;
            NH[42] = r16;
            NH[44] = "M\xfb\x16\xe4\x14\xeb\xa3\xeb8";
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[42] = r15;
            NH[43] = r16;
            NH[45] = "A\x0b\x83\x8da@\x1f%";
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            NH[42] = function(...)
                r115 = tonumber(r57[r15[r16("\x1c\x85\x9b'\x13\xe4\x96\x01", 23885912173426)]]) or 1;
                task[r15[r16("b\x98~\xe5\xd3", 7566967016899)]](function(...)
                    while r24 do
                        v1 = r28[r15[r16("?\xa8r\xad?\xff\xe0\xfbj", 8276954074894)]];
                        if v1 then
                            z = v1.FindFirstChild(v1, r15[r16("\xec\xaeq\xc2\x0e\xc1\x1f;", 33238563191925)]);
                            if z then
                                z[r15[r16("\xfd$\xdc\xc85.\x91U\x0e", 33102759541814)]] = 16 * r115;
                            end;
                        end;
                        task[r15[r16("\xf7@nF", 29058582082779)]](1); 
                    end; 
                end);
                r76(r15[r16("\x9d\xec\xbb", 9086605856903)], r15[r16("]W:%JV\xdfwhBD8\x86", 17185805590338)] .. tostring(r57[r15[r16("\x05*i4B\xe5y\x99", 27187172962676)]]), 3); 
            end;
            NH[38], NH[43], NH[44] = {
                [NH[39]] = NH[40],
                [NH[41]] = NH[42]
            }, "\x003(\x94\xe7ush\xe1l\n", 1829950473044;
            NH[40] = r15;
            NH[41] = r16;
            NH[42] = NH[41](NH[43], NH[44]);
            NH[39] = NH[40][NH[42]];
            NH[43], NH[45] = 6296303684467, 1717905556255;
            NH[37].Button(NH[37], NH[38], NH[39]);
            NH[39] = r15;
            NH[40] = r16;
            NH[42] = "\xc5Qè";
            NH[41] = NH[40](NH[42], NH[43]);
            NH[38] = NH[39][NH[41]];
            NH[46] = 29730968647188;
            I = JY[NH[38]];
            NH[41] = r15;
            NH[42] = r16;
            NH[44] = "b\x91 \xe4";
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[42] = r15;
            NH[43] = r16;
            NH[45] = "8\xa3\x93\xc9K";
            NH[44] = NH[43](NH[45], NH[46]);
            NH[38] = "Section";
            NH[41] = NH[42][NH[44]];
            NH[38], NH[48], NH[39] = I[NH[38]], "\x8c\x14\xff\x99\x1a\x87\x80", {
                [NH[40]] = NH[41]
            };
            NH[38] = NH[38](I, NH[39]);
            NH[47], NH[45], NH[46], NH[44] = 9962045215262, 22011214473225, 13251519862810, "\x8bq1\xf4";
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[42] = r15;
            NH[17] = nil;
            NH[43] = r16;
            NH[45] = "\xa3\xb6\x80\xabB\x0fW\x1701\xc3\xfd6+p\x84m\xe8\x90";
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            NH[39], NH[46] = {
                [NH[40]] = NH[41]
            }, 10633588986711;
            NH[38].Header(NH[38], NH[39]);
            NH[45], NH[44] = 22178509219927, "1\t-\xe0";
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[45] = "\x05\x19$\x972\xfa\xd80$\xc4\xe6\x97\xf5";
            NH[40] = NH[41][NH[43]];
            NH[42] = r15;
            NH[43] = r16;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[46] = "&]\xd45\xb3j\xdf";
            NH[41] = NH[42][NH[44]];
            NH[43] = r15;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[43] = r90;
            NH[44] = NH[43]();
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[43] = NH[45][NH[47]];
            NH[45] = 1;
            NH[47] = r15;
            NH[48] = r16;
            NH[49] = NH[48](NH[50], NH[51]);
            NH[46] = NH[47][NH[49]];
            NH[47] = function(arg1_64, ...)
                I = r57;
                I[r15[r16("\xa6i\xd8\xcbX\xa5\x08\x98Z\xa7>I0\x9b)\x0b\xea", 31395641637147)]] = arg1_64; 
            end;
            NH[39] = {
                [NH[40]] = NH[41],
                [NH[42]] = NH[44],
                [NH[43]] = NH[45],
                [NH[46]] = NH[47]
            };
            NH[44] = "\xf4z H\x91\xc5\x0bP\x11o\x95:N\xe2\x1f\xeb_";
            NH[41] = r15;
            NH[45] = 25645983608486;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[45] = "\x8c\xe9ͬ";
            NH[39] = 128;
            F[NH[39]] = NH[38].Dropdown(NH[38], NH[39], NH[40]);
            NH[46] = 33657759825209;
            NH[42] = r15;
            NH[43] = r16;
            NH[49], NH[47] = 5273507318167, 8952046702664;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            NH[46] = "\xf8@\x18\xbdQq\x0f3\r\xf8Ͽ\xf0\x19V\xab\xa0";
            NH[43] = r15;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[47], NH[48], NH[51] = "[4ǳ\xc1\xfa\xc0\xd0", 3846959138559, 23931358210951;
            NH[42] = NH[43][NH[45]];
            NH[44] = r15;
            NH[45] = r16;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[46] = 25865697832716;
            NH[44] = function(...)
                v1 = r57[r15[r16("\x9f\xf1/R\xd3\xc4:\xd3\xe8!\xf3\x11\xec\xa5\x17\x85+", 24549579320487)]];
                I = r27;
                z = I.WaitForChild(I, r15[r16("\xb4[s\x84\x1d", 26732074872992)]);
                o = z.FindFirstChild(z, v1);
                if not o then
                    r76(r15[r16("\x9e\x0c\xb7\xb5\x12", 21439799551743)], r15[r16("\xbd\x15:\x81\xd9\xda\x07Wa\xade=\xf0b\x00=\xd0\rU\x81\xd91\xed\xbe((\x12\xb9戆\x17E", 5805955402383)], 3);
                    return;
                end;
                W = o.FindFirstChild(o, r15[r16("Y\x94C\xc1\xca", 413250896064)]);
                T = o.FindFirstChild(o, r15[r16("\x1c\x14A\x1f\xf8\x93\xb5\xcc", 20408638317855)]);
                I = o.FindFirstChild(o, r15[r16("l\x8b\xa9\x08\xcf3", 29691867575810)]);
                q, S = pairs, not W;
                if W then
                    if T then
                        M = I;
                    end;
                    I, P = o.FindFirstChild(o, r15[M]), T;
                end;
                I = S;
                if not W then
                    r76(r15[r16("\xae\x8b\x80<\xb2", 7980217912964)], r15[r16("nx\xdc\xde)z\x14|SO\xd3U\xf5\xba,\x80\xf2\xd3B\xcf4\x81\x9d\xde\x05\x8e\xf6\xa9", 28685592392749)], 3);
                    return;
                end;
                S = r15[r16("", 27746058678904)];
                v2 = q.GetChildren;
                P = v2[1];
                for L, b in pairs(v2(q)) do
                    v2 = L;
                    e = b.FindFirstChild(b, r15[r16("\xaf\xa0\x04\xe9^\xe0\x1d\x8b\x8e\x89", 5898605365946)]);
                    if e then
                        i = e.IsA(e, r15[r16("\xfbIMӦ\t\x0e\x1b", 22559802370313)]);
                    end;
                    if e then
                        S = r15[M] .. b[r15[r16("\xba[ݓ", 1648292430591)]] .. r15[r16("\\r\xd4", 23084410956285)] .. tostring(e[r15[r16("\xf6\xbd\xe8G\x97", 14562603227773)]]) .. r15[r16("\x87", 3478242920019)];
                    end; 
                end;
                M = {};
                table[r15[r16("\x18r\x82 HF", 29380714640753)]](M, r15[r16("\xd8C\x95Jp\x0f \x84", 16280508784029)] .. tostring(W[r15[r16("\xb1Wk/\x8a", 33209211567208)]]));
                table[r15[r16("\x80\x1fk4^4", 16207557025147)]](M, r15[r16("\xf6\x87\xf1\x10\xc3ձ<\x19\xe0'", 29532028646839)] .. tostring(T[r15[r16("\x00\x89\x18ݥ", 20203348698303)]]));
                if S ~= r15[r16("", 26841146011858)] then
                    table[r15[r16("ޘ\x0e\x0f\xdap", 4309701756886)]](M, r15[r16("\xb1\xec\x12\xa1\xacR\x98", 17020171493109)]);
                    table[r15[r16("z\t\xde\x1c\xf6u", 2842730792235)]](M, S);
                else
                    table[r15[r16("\xa6\xbd\xef\xfcjZ", 520971305202)]](M, r15[r16("Xsm!\x96\x97\x89\x92T\xad\xe0\xb0O\xb6\x9f\x9d", 7481782996379)]);
                end;
                r76(r15[r16("\xfc \x99\xb5\x03}Z\x99\xb4", 1316118512228)] .. tostring(v1), table[r15[r16("\xce\x06\xc5\x12\xf0\xcf", 9473018007867)]](M, r15[r16("\x9d", 11328742134939)]), 10); 
            end;
            NH[40], NH[45], NH[35] = {
                [NH[41]] = NH[42],
                [NH[43]] = NH[44]
            }, "\xe5rK\xdb\xc2a\x80\xf0Rja\xec\xa3. ", nil;
            NH[42] = r15;
            NH[43] = r16;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[45] = "\xbcm\xe2dj";
            NH[41] = NH[42][NH[44]];
            NH[46] = 1020720792027;
            NH[38].Button(NH[38], NH[40], NH[41]);
            NH[41] = "task";
            NH[40] = Env[NH[41]];
            NH[42] = r15;
            NH[43] = r16;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[46] = 15312794983386;
            NH[41] = NH[42][NH[44]];
            NH[45] = 18740835295766;
            NH[41] = function(...)
                pcall(function(...)
                    I = readfile;
                    v1 = I(r15[r16("\x9bG\xd5Sm߬i\x85\xa0앗\xee\xb9\xe0w\x97\x9e7\xb5;", 32768541703067)]);
                    if v1 then
                        I = r26;
                        z = I.JSONDecode(I, v1);
                        if z then
                            if z[r15[r16("9\xc7\xf9\xe5\n", 31671653235100)]] then
                                I = r57;
                                I[r15[r16("3\x18\x99\xfeO\xf0\x84Y\xf6CRK\xc7V=\xa4", 1433971688091)]] = tostring(z[r15[r16("\xfeH\x1bV\xf1", 17992807915706)]]);
                            end;
                            if z[r15[r16("\xb9\xd9\xf1I\xe4\xafO\n", 26179148722078)]] then
                                I = r57;
                                I[r15[r16("p\xf4\xeaC{N\xddL", 9414189617439)]] = tostring(z[r15[r16("\xa2T\x9a\x89\x95\x0b:\x19", 11494028203240)]]);
                            end;
                        end;
                    end; 
                end); 
            end;
            NH[47] = 13432061696110;
            NH[40] = NH[40][NH[41]](NH[41]);
            NH[41] = r15;
            NH[44] = "\x16t\xc5\xdeb\xe7";
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            I = JY[NH[40]];
            NH[42] = r15;
            NH[43] = r16;
            NH[45], NH[40] = "\x91j\xd5\x0b", "InsertThemeSection";
            NH[44] = NH[43](NH[45], NH[46]);
            NH[48], NH[40] = 23867370646378, I[NH[40]];
            NH[41] = NH[42][NH[44]];
            NH[40] = NH[40](I, NH[41]);
            NH[46], NH[45], NH[44] = 20389127726358, 34053830573553, "\xc8,\xcc\xe4\xf6?";
            NH[41] = r15;
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            NH[34] = nil;
            I = JY[NH[40]];
            NH[45] = "\x95\xdcpP\xa2";
            NH[42] = r15;
            NH[43] = r16;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[40], v2 = "InsertUISettingsSection", nil;
            NH[40], NH[45] = I[NH[40]], 3212833834456;
            NH[41] = NH[42][NH[44]];
            NH[40] = NH[40](I, NH[41]);
            NH[41] = r15;
            NH[44] = "I)\x0c#ԟG\xb3";
            NH[42] = r16;
            NH[43] = NH[42](NH[44], NH[45]);
            NH[40] = NH[41][NH[43]];
            I = JY[NH[40]];
            NH[46] = "\xe3J\x03\xa9";
            NH[43] = r15;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[47] = "\xc9N\xf3\xc3\xf9";
            NH[42] = NH[43][NH[45]];
            NH[44] = r15;
            NH[40] = "Section";
            NH[45] = r16;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[45] = "\x8b\x0c\xe6\xbc\xd6}\x0c\x1e";
            NH[43] = NH[44][NH[46]];
            NH[40], NH[41] = I[NH[40]], {
                [NH[42]] = NH[43]
            };
            NH[40] = NH[40](I, NH[41]);
            NH[42] = r15;
            NH[43] = r16;
            NH[46] = 32593548491593;
            NH[44] = NH[43](NH[45], NH[46]);
            NH[41] = NH[42][NH[44]];
            I = JY[NH[41]];
            NH[48] = 13616733411524;
            NH[50], NH[47] = 28369928811418, 29712570496523;
            NH[43] = r15;
            NH[44] = r16;
            NH[41], NH[46] = "InsertConfigSection", "\xebG\xe9\x13";
            NH[45] = NH[44](NH[46], NH[47]);
            NH[41] = I[NH[41]];
            NH[42] = NH[43][NH[45]];
            NH[41] = NH[41](I, NH[42]);
            NH[43] = r15;
            NH[46], NH[47] = "\x04\x96\x95\xca", 21892210124754;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[44] = r15;
            NH[45] = r16;
            NH[47] = "\xab\x16\xbe\x82zJb\xa0\x95\x93\x0c)MG\x11";
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[46], NH[48], NH[41] = "\xfe\x05\x0e\x02", 6911186717842, {
                [NH[42]] = NH[43]
            };
            NH[40].Header(NH[40], NH[41]);
            NH[43] = r15;
            NH[47] = 24060227038147;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[47] = "\x91\xc6\xce}\xaf\x14r\x89\xca\xc2W";
            NH[42] = NH[43][NH[45]];
            NH[44] = r15;
            NH[45] = r16;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[45] = r15;
            NH[48] = "\xddL\xe0ֽ\xa5x\x8c\xbf\x8d]";
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[46] = r15;
            NH[49] = "\xa7?_\xcah\x92K\xcf}?K";
            NH[47] = r16;
            NH[48] = NH[47](NH[49], NH[50]);
            NH[45] = NH[46][NH[48]];
            NH[50] = "\xad\x1a\x08\xb8}\xe9\xfa ";
            NH[47] = r15;
            NH[48] = r16;
            NH[49] = NH[48](NH[50], NH[51]);
            NH[46] = NH[47][NH[49]];
            NH[47] = function(arg1_65, ...)
                I = r57;
                I[r15[r16("\x1fq\x8a\x1d/\xc4 \x1c\xdb,", 8116238110403)]] = arg1_65; 
            end;
            NH[41], NH[51] = {
                [NH[42]] = NH[43],
                [NH[44]] = NH[45],
                [NH[46]] = NH[47]
            }, 113682350132;
            NH[43] = r15;
            NH[46], NH[47] = "\x942\x0e\\\xcc\x0f\xadC\xc2\x18", 28890900116621;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[47] = 31413141207331;
            NH[40].Input(NH[40], NH[41], NH[42]);
            NH[43] = r15;
            NH[44] = r16;
            NH[50], NH[49], NH[46] = 7557511237055, 3179546019272, "\x9c\xe9\xbb\x15";
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[48] = 9432356622632;
            NH[44] = r15;
            NH[45] = r16;
            NH[47] = "-\x82{\xcfr2m";
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[45] = r15;
            NH[46] = r16;
            NH[48] = "\x01\x18\xac\xe8S\xe4\xc4\xfe\x05M:";
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[49] = "0Vg\xddu";
            NH[46] = r15;
            NH[47] = r16;
            NH[48] = NH[47](NH[49], NH[50]);
            NH[45] = NH[46][NH[48]];
            NH[47] = r15;
            NH[48] = r16;
            NH[50] = "\xa6\xcf7\xa7+\xf4@\xfc";
            NH[49] = NH[48](NH[50], NH[51]);
            NH[46] = NH[47][NH[49]];
            NH[47] = function(arg1_66, ...)
                I = r57;
                I[r15[r16("\xadDo\x99\xdc!", 4200266811299)]] = arg1_66; 
            end;
            NH[41] = {
                [NH[42]] = NH[43],
                [NH[44]] = NH[45],
                [NH[46]] = NH[47]
            };
            NH[32] = nil;
            NH[46] = "\xf1K\x14ä\x8f";
            NH[43] = r15;
            NH[47] = 5141680834906;
            NH[44] = r16;
            NH[49] = 23134488750612;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[46] = "\xbc\x88\x8f\x84";
            NH[42] = NH[43][NH[45]];
            NH[40].Input(NH[40], NH[41], NH[42]);
            NH[50] = 30983233337435;
            NH[43] = r15;
            NH[48], NH[47] = 5634238515775, 31785335601617;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[47] = "\xc3\xc2\xdb\xf0\xc7\xfc\x925\x88\xe8\xee2";
            NH[42] = NH[43][NH[45]];
            NH[44] = r15;
            NH[45] = r16;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[45] = r15;
            NH[48] = "\xd6y:\xb3z\t\xc0s";
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[47], NH[46] = 33574056951058, "\xb7\\\x0f\xbap|6ߞ\xfe\x06";
            NH[45] = function(...)
                o = r26;
                writefile(r15[r16("\xedC\xa3\xce\x10\xe9Y\xd5\x13\x05\x81\x12\xf5\x8a\xf6\x0b\x88N\x0c\xbc", 30361223116602)], o.JSONEncode(o, {
                    [r15[r16("%\x18\x01", 22780112218479)]] = r57[r15[r16("\x1b\x81~󂥘\xcd\xc7\xcc", 15048428133215)]],
                    [r15[r16("z_\xee\xa1", 34628516953853)]] = r57[r15[r16("#\xf3\xe7\xd2\"e", 6336575409030)]]
                }));
                r76(r15[r16("\xcee\xf9l\x94", 33497975422190)], r15[r16("$\x17\x02\xf3\xf1\x03\xbaP\xe6\xa6\x07\xa0\x03\xf9", 26725703135389)]); 
            end;
            NH[41] = {
                [NH[42]] = NH[43],
                [NH[44]] = NH[45]
            };
            NH[43] = r15;
            NH[44] = r16;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            NH[48] = 11745665029469;
            NH[40].Button(NH[40], NH[41], NH[42]);
            NH[41] = 129;
            NH[47] = "\xf4r.\xd1";
            F[NH[41]] = false;
            NH[44] = r15;
            NH[45] = r16;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[49] = 15408701692935;
            NH[45] = r15;
            NH[48] = "\xb1s}\xea4\x82?|\x81Rv}\x1c\xdcm\xe9\x14^t";
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[46] = r15;
            NH[33] = nil;
            NH[49], NH[51] = "H\\\xf4a\xdd\xfd\x9a", "[\x85p\xe4\xa2\xffĪ";
            NH[47] = r16;
            NH[48] = NH[47](NH[49], NH[50]);
            NH[45] = NH[46][NH[48]];
            NH[46] = false;
            NH[48] = r15;
            NH[49] = r16;
            NH[50] = NH[49](NH[51], NH[52]);
            NH[47] = NH[48][NH[50]];
            NH[48] = function(arg1_67, ...)
                F[NH[41]] = arg1_67; 
            end;
            NH[42] = {
                [NH[43]] = NH[44],
                [NH[45]] = NH[46],
                [NH[47]] = NH[48]
            };
            NH[44] = r15;
            NH[47] = "c\x97\x97E\xbe5\xa50l\xf5\x97S";
            NH[45] = r16;
            NH[50], NH[48] = 9027726430315, 2116539712473;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[40].Toggle(NH[40], NH[42], NH[43]);
            NH[43] = r15;
            NH[46] = "pz\x86\xfa⼛8";
            NH[44] = r16;
            NH[47], NH[49] = 9415594643744, 30334090458925;
            NH[45] = NH[44](NH[46], NH[47]);
            NH[42] = NH[43][NH[45]];
            I = JY[NH[42]];
            NH[48] = "PR\x1f*";
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[49] = "x\xca\x10z\xb4";
            NH[44] = NH[45][NH[47]];
            NH[46] = r15;
            NH[47] = r16;
            NH[42] = "Section";
            NH[42] = I[NH[42]];
            NH[48] = NH[47](NH[49], NH[50]);
            NH[49] = 14689101961912;
            NH[45] = NH[46][NH[48]];
            NH[43] = {
                [NH[44]] = NH[45]
            };
            NH[42] = NH[42](I, NH[43]);
            NH[48] = "\xb0j_R";
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[50], NH[49] = 23519647165128, "\x1dC\x85\x87a/71M";
            NH[46] = r15;
            NH[47] = r16;
            NH[48] = NH[47](NH[49], NH[50]);
            NH[45] = NH[46][NH[48]];
            NH[49], NH[50], NH[48], NH[37], NH[43] = 32959084641267, 22805340072315, "\xbd\x08j^", nil, {
                [NH[44]] = NH[45]
            };
            NH[42].Header(NH[42], NH[43]);
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[51] = 17226175176533;
            NH[44] = NH[45][NH[47]];
            NH[46] = r15;
            NH[47] = r16;
            NH[49] = "\x056J\x9d\x9a\xc4w\xb3}W\n\x9d\x03O\xb1u\x8d\xb8A";
            NH[48] = NH[47](NH[49], NH[50]);
            NH[45] = NH[46][NH[48]];
            NH[47] = r15;
            NH[48] = r16;
            NH[50] = "(\xec\x96y\xf9o\xfcy";
            NH[49] = NH[48](NH[50], NH[51]);
            NH[46] = NH[47][NH[49]];
            NH[49] = 1560992875222;
            NH[47] = function(...)
                setclipboard(r15[r16("\x03\x0bE\x83\xd8#\x9d\xb5\x06Xc\x9d\x94&\xc1\xfc\xdb9\x0cu\x10RF\x81\xc2\xd6\x1d ", 29187853743383)]);
                r76(r15[r16("\xe7\xf2\t\x16\xaa-", 32237696694947)], r15[r16("f\x86#'\x0e\x1a\x90\xd3-<\xe1ޢ\x06.\xb6\xe2H\x17\xaf\x9c\xbf\xa8Q", 20405721212190)]); 
            end;
            ZY, NH[43] = nil, {
                [NH[44]] = NH[45],
                [NH[46]] = NH[47]
            };
            NH[45] = r15;
            NH[48], NH[51] = "\x9a\xd6N\x96M\xaf\xa0\x11\xe6I\xfe\xa6/\xb7\xe4\xb69", 6702673726513;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[50], NH[48] = 24605988023490, "\x90\x98!B";
            NH[44] = NH[45][NH[47]];
            NH[42].Button(NH[42], NH[43], NH[44]);
            NH[49] = 32351379061464;
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[46] = r15;
            NH[49] = "\xa6\xbe\x17\xae\x98\xf7W\x9b:\xd4\xd4\xdc\x04\"\x04\xb0\x0f\xda";
            NH[47] = r16;
            NH[48] = NH[47](NH[49], NH[50]);
            NH[50] = "\x9aFWޔ\xc1\xebL";
            NH[45] = NH[46][NH[48]];
            NH[47] = r15;
            NH[48] = r16;
            NH[49] = NH[48](NH[50], NH[51]);
            NH[51] = 8974706331731;
            NH[46] = NH[47][NH[49]];
            NH[47] = function(...)
                setclipboard(r15[r16("\x8a\x07\xf3\xdcz\xcc\xc2\x92\xf7A+\xfd\xf7\xe2|gX\x89'\x19wr\xd7H\xe3\x96\xe8\x01\xe6", 28952342557865)]); 
            end;
            NH[43], NH[48] = {
                [NH[44]] = NH[45],
                [NH[46]] = NH[47]
            }, "\x9e\x1a\t\xee\xcd%٢\x03\x90\x83\xa3wd\xa9w\x01\x14\xbdFGK\xa9\xe3";
            NH[45] = r15;
            NH[49] = 30240226539265;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[42].Button(NH[42], NH[43], NH[44]);
            NH[43] = "pcall";
            NH[44] = function(...)
                I = r26;
                I = r57;
                v1 = I.JSONDecode(I, readfile(r15[r16("\xe5%\x93\xf9\xfd,\x98\xbeI\xec!^\xf8\x8e\xf5\xc4\xcc\xca\x15r", 29837162477126)]));
                I[r15[r16("q\xfb\x11V\xe5\xe1\x84֙\xbb", 16548082671129)]] = v1[r15[r16(",~\xbc", 10104282567265)]];
                I = r57;
                I[r15[r16("\xff\x98>\xb4I\xe2", 29281307342147)]] = v1[r15[r16("Zo\x81p", 22884658080160)]]; 
            end;
            NH[48] = "&\x9fE\x0e\x8a";
            NH[43] = Env[NH[43]](NH[44]);
            NH[44] = "task";
            NH[43] = Env[NH[44]];
            NH[45] = r15;
            NH[46] = r16;
            NH[49], NH[50] = 5281133578651, 7034698517707;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[44] = function(...)
                r116 = 0;
                r117 = -1;
                while r24 do
                    task[r15[r16("t\x01i\xf6", 27594910659121)]](5);
                    if not F[NH[41]] then
                    else
                        pcall(function(...)
                            if tick() - r116 < 15 then
                                return;
                            end;
                            I = game;
                            P = I.GetService(I, r15[r16("Q\x12_qxq0\xc3m\xe5\x9a\x06$ˤ]\x99", 14425989110333)]);
                            v1 = P.FindFirstChild(P, r15[r16("\xc0h\xad\xe6\x1a", 3670818440877)]);
                            if v1 then
                                P = v1.FindFirstChild(v1, r28[r15[r16("hZn:", 4156203583375)]]);
                            end;
                            if v1 then
                                z = v1[r28[r15[r16("\xb7\x98\xf0D", 29834690803268)]]];
                                o = z.FindFirstChild(z, r15[r16("5\xa4_", 34654051778313)]);
                                if o then
                                    W = o[r15[r16("\xc5o\x906(", 10430067004152)]] or r15[r16("5g\xce,", 31951230515742)];
                                    I = z.FindFirstChild(z, P);
                                    T = o.FindFirstChild(o, r15[r16("\x9a\xe3R\xb4\xaa\xbb\x92\xdb\xde\xdf77\xe0", 8885274333225)]) and o[r15[r16("t\x90:\x03\x07\x1f\xbb\xfc\xcdX\xe7\xf3\xd4", 5579785374246)]][r15[r16("\xf6\xbcW=\xfb", 5794584840842)]] or 0;
                                    q = I;
                                    q = o.FindFirstChild(o, r15[r16("ӒHG\xbc\xc2+\xa6\xa9\xe8", 23574376295137)]) and o[r15[r16("'*\xbd?|\x7f\xbb'\x15N", 29099432539374)]][r15[r16(">ʅ2\xe4", 3569297376894)]] or 0;
                                    S = z.FindFirstChild(z, r15[r16("l\xe4\xb9E\t", 11195344278621)]);
                                    M = z.FindFirstChild(z, r15[r16(".5)\xcb1\x8d\xbc\x15", 11141235627076)]);
                                    if S then
                                        p = S[r15[r16("J\xf3\xe18\xcc", 32757151120277)]];
                                    end;
                                    p = I;
                                    if M then
                                        v2 = M[r15[r16(",\xdc\tA\xf2", 8248668868353)]];
                                    end;
                                    I = I;
                                    p = M or 0;
                                    l = {
                                        r91()
                                    };
                                    i, e, w, b = l[4], l[3], l[5], l[2];
                                    v2 = r91();
                                    l = 0;
                                    if S then
                                        P = r117;
                                    end;
                                    I = I;
                                    if S then
                                        l = (S or 0) - r117;
                                        if l < 0 then
                                            l = 0;
                                        end;
                                    end;
                                    B = T > 0 and T ~= r117;
                                    I = I;
                                    if B then
                                        r116 = tick();
                                        B, t = o.FindFirstChild(o, r15[r16("\x9a\xe3R\xb4\xaa\xbb\x92\xdb\xde\xdf77\xe0", 8885274333225)]) and o[r15[r16("t\x90:\x03\x07\x1f\xbb\xfc\xcdX\xe7\xf3\xd4", 5579785374246)]][r15[r16("\xf6\xbcW=\xfb", 5794584840842)]] or 0, I;
                                        r117 = B;
                                        R = request or (http_request or syn);
                                        if R then
                                            t = r57[r15[r16("\xa0m\xbd\xaa\x84\x875\x88\x87\x05", 34318144011884)]] ~= r15[r16("", 5415675824601)];
                                        end;
                                        I = t;
                                        if R then
                                            I = h;
                                            I = h;
                                            I = h;
                                            d = r26;
                                            R({
                                                [r15[r16("\x02\xbe\xeb", 25717227007687)]] = r57[r15[r16("h\xdb\xdc ,\x03\x03D\xe5\xc2", 22960904219076)]],
                                                [r15[r16("0\x95\xfc,<\xba", 21596422301512)]] = r15[r16("o\xc6\x07U", 34838317858654)],
                                                [r15[r16("\x19N\x018\xe5~g", 28034490430206)]] = {
                                                    [r15[r16("+\x96O\xcd\xf3\x1e%\xe2\xdd\xd7\xd4-", 24749258960132)]] = r15[r16("\x8df\x96\xa8y,\x1c\x9b>T\xef\xbb\x1c\xec\xe0\x94", 23844802636639)]
                                                },
                                                [r15[r16("\x87\xcb\x15i", 29749324576285)]] = d.JSONEncode(d, {
                                                    [r15[r16("\xdf|\xcd\xe4\x910\xc9", 20968572757540)]] = r57[r15[r16("\x19\xf5W\xf2[k", 5836445633181)]] and r57[r15[r16("6ޤRg\xd7", 34368018382467)]] ~= r15[r16("", 16024427207973)] and r57[r15[r16("-\xec\x95>\x14\x8f", 489236005091)]] or r15[r16("", 15731728948381)],
                                                    [r15[r16("\x9a@,\xb4\xcb\xf2\x98\xf5", 26128709775239)]] = r15[r16("\x8c\x7f\xfc+\xd9R\xcbЩ\xb4\xa6(\x1ca\xa8#\xdfL", 29770543347238)],
                                                    [r15[r16("\x83ɮ\xb9Rf\xf4=[\x82", 3432014923326)]] = r15[r16("s\xbe\n\xae\x9b\xd5Z'V\xec\x1a\x8b/\xbc)\x97aKP\xf5\x9e\xf7\xa1n\x07\xf3L\xb1\x06\x95\x8b-\xafw\x9d\x92\xee\xb3\x12\x95\xe9\x7f \x0b\xe9\xe9\xff\xf2\xeeُ\x18\x0c4", 31409843370274)],
                                                    [r15[r16("\x93\xf9\x1b7\x139", 22181081917528)]] = {
                                                        {
                                                            [r15[r16("b\nK\\\x10", 17858004050043)]] = r15[r16("\xb1\xca\x05\xfc\x9c2C\x13\x8fd)8'\xe3\xf5\xe4", 35080661811151)],
                                                            [r15[r16("\xef|\x8b \xd0", 26337285500904)]] = 1752220,
                                                            [r15[r16("\xb5\x9f\xfdl\x8a3", 12508322748096)]] = {
                                                                {
                                                                    [r15[r16("\xba\x050\x84", 34550341484248)]] = r15[r16("(\x81\x04\x9bs\n+L\x05r\x10>\xbd~\x84\xc1", 1582980416225)],
                                                                    [r15[r16("3I\xf4\xaa\x0e", 9275181175007)]] = tostring(o[r15[r16("\xc5o\x906(", 10430067004152)]] or r15[r16("5g\xce,", 31951230515742)]),
                                                                    [r15[r16("\x92\xd7<\x83\xadY", 8251243712258)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("\xed\x7f<d", 7162765790471)]] = r15[r16("0\xe2\xf5\xa9\xbe\xbd\xe8\xb7Kzz\xfc\x82dLإÈ", 15069766015849)],
                                                                    [r15[r16("7\xd0'<\xda", 31825620023779)]] = r15[r16("\x8d", 1077826224629)] .. tostring(o.FindFirstChild(o, r15[r16("\x9a\xe3R\xb4\xaa\xbb\x92\xdb\xde\xdf77\xe0", 8885274333225)]) and o[r15[r16("t\x90:\x03\x07\x1f\xbb\xfc\xcdX\xe7\xf3\xd4", 5579785374246)]][r15[r16("\xf6\xbcW=\xfb", 5794584840842)]] or 0),
                                                                    [r15[r16("jW\x90\xb2\xb0\x10", 18639063409127)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("\xffh`\x88", 7836592197185)]] = r15[r16("̮{.\x13́n\xcaUm5d\xc7", 12219061851705)],
                                                                    [r15[r16("\x17\xfc\xe7,\x8d", 16211842424189)]] = tostring(o.FindFirstChild(o, r15[r16("ӒHG\xbc\xc2+\xa6\xa9\xe8", 23574376295137)]) and o[r15[r16("'*\xbd?|\x7f\xbb'\x15N", 29099432539374)]][r15[r16(">ʅ2\xe4", 3569297376894)]] or 0) .. r15[r16("\x0e", 16085261065538)],
                                                                    [r15[r16("\x19欏-\x9b", 8581646585756)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("\xed8\xea\\", 15345614330857)]] = r15[r16("\x86\xf3\xae\x93\x1f\x07\xe7\x19.^?\xabA\xba\\\xbc˥(B\x9d\x91\x9e0", 21500936906524)],
                                                                    [r15[r16("\x93\x14]\xa5:", 29550219359680)]] = r15[r16("\xcf", 21182059964039)] .. tostring(l),
                                                                    [r15[r16("\xe2\xc5\xde\xd1J*", 20684583183776)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("\xf7\x94\xf2\xca", 10390274462438)]] = r15[r16("~`\"\x9a\xa2\x92\xd2\x19ވ", 21671295985515)],
                                                                    [r15[r16("\xbb\x81v!\x8b", 1231940043325)]] = r15[r16("g", 1334612132461)] .. tostring(S or 0),
                                                                    [r15[r16("\xa9\xbc\x8e\x8as\"", 16257467227538)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("y\x08̯", 4663954966651)]] = r15[r16("\x0eos3\x95*T'\x03\x04%\x07\xff", 32744455502735)],
                                                                    [r15[r16("\xec\xfdk\x81I", 3254177039851)]] = tostring(M or 0),
                                                                    [r15[r16("L!\xbd\xaebo", 22521959016695)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("\xdd\xd0\xf9\xa9", 32640745208671)]] = r15[r16("\xc4\xe6PZ\xee\x80\x14\xa65\xc9ZÉ\xa1\xf0Z\xf9\x95\xcd\xe3q\x7f!\x96f\x8eƘ\xe5PJ\xb8\xbf+\xb6\x86\xbf\xb8\xa8\x9c\x10\xb9\xfe\xf0P\x7f\xa4;\x90z\xf2v\xf7\n\\qe\xe2҅\x19G\xeaN\xfe\xc2", 29591462557139)],
                                                                    [r15[r16("N\xe7T\xd4\x1e", 35030281781176)]] = r15[r16("\x1e\xa3Aȟ\xb0\xf1\xaa\rդ\xebe<\xa1rm\xfb", 32006714604088)],
                                                                    [r15[r16("\xfd\x87\xf1f\x97\t", 31174442973364)]] = false
                                                                },
                                                                {
                                                                    [r15[r16("\x19w\xe8\xf9", 9121090850967)]] = r15[r16("7\x8c\x1d@\x01\xc58K\xf0\x1f\xcc\x1a", 5073586211130)],
                                                                    [r15[r16("\xff\xd3Ƣ\x11", 3152836658620)]] = tostring(l[1]) .. r15[r16("\x13", 24190856866816)],
                                                                    [r15[r16("?<֤ѷ", 1714834129694)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("H\x88x\xb5", 4230662883250)]] = r15[r16("b\xbej\xe7\xdal\x00\x7f$~\x18", 7645548170728)],
                                                                    [r15[r16("\xde\x1f\xc16l", 9551426326879)]] = tostring(l[2]) .. r15[r16("\xf3", 16449724751340)],
                                                                    [r15[r16("\xbdku\x07\xdbl", 23857390611301)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("\xe0\x94M>", 25636687408802)]] = r15[r16("\\2BȠ\x8dL\x19", 25031371337096)],
                                                                    [r15[r16("oC\xf2\xfb\xf9", 4018632836943)]] = tostring(l[3]) .. r15[r16("\x0f", 11953252210110)],
                                                                    [r15[r16("\x11\x90\x1f\x05Q0", 19397218591560)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("N\xbe\xbd\x04", 25200692817366)]] = r15[r16("\xe8\xbf?\xb0\x8d\x1b,F\xd8r\x84", 32637835393886)],
                                                                    [r15[r16("#[\xed=d", 29787493053998)]] = tostring(l[4]) .. r15[r16("\xe9", 11687616697666)],
                                                                    [r15[r16("\xcct/0\x0bW", 33869775437211)]] = true
                                                                },
                                                                {
                                                                    [r15[r16("\xe4\x8e\xff@", 31122105202844)]] = r15[r16("\x9a\xa8\x11\xcbA\x9a\xea\xb4K$o\xb1", 27945083925204)],
                                                                    [r15[r16("\xe98;2\x9c", 3349358315031)]] = tostring(l[5]) .. r15[r16("\xb0", 28682188600364)],
                                                                    [r15[r16("\xa0\xbd\x90f31", 31199260981440)]] = true
                                                                }
                                                            },
                                                            [r15[r16("]\xc0\xd4\xde`W\xb0\x0e\xe7", 25871317331727)]] = os[r15[r16("\xf5=\xbcz", 26138561720203)]](r15[r16("I\x9f\xf0nF٨sd\x9a\xcd$rs4\xda6m\xd7", 25606351433363)])
                                                        }
                                                    }
                                                })
                                            });
                                        end;
                                    end;
                                end;
                            end; 
                        end);
                    end; 
                end; 
            end;
            NH[43] = NH[43][NH[44]](NH[44]);
            NH[44] = "task";
            NH[43] = Env[NH[44]];
            NH[45] = r15;
            NH[49] = 28979921843382;
            NH[46] = r16;
            NH[48] = "\x1aߥA\x8d";
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[44] = function(...)
                while r24 do
                    task[r15[r16("\x8a5q\xee", 31490350807367)]](600);
                    if r56 == r15[r16("", 4116378797948)] then
                        break;
                    else
                        r55[r15[r16("7{\r\xe6\"\xc7\x05", 10245274489506)]](r56, r55[r15[r16("\xb7vj\x0b\x9aKs", 20163369313453)]](), function(arg1_68, arg2_68, ...)
                            z, v1 = arg2_68, arg1_68;
                            if v1 then
                                P = r55[r15[r16("\xa1\xaf\x8c\xc21\x17\n", 29753066206750)]](z[r15[r16("8Fi\x86\x9b\xb564 4\x1d(iڶ\x04", 92273737770)]]);
                            end;
                            if v1 then
                                I = _G;
                                I[r15[r16("\xbbd\x97>\x19e\x0b\xf5\xc9ò\\\x11\x8b\x12ݴl8\x1d5", 24182002166780)]] = z[r15[r16("\x06\xef\xf1\xea\xd0\\)\xf1Q\xc1t\xf8\x83", 6521946311645)]];
                            else
                                r55[r15[r16("2\xd2\xc8\xee^", 19489492329331)]]();
                                r76(r15[r16("\x8d)ʒ\xf8R\x1b\xd4\xfe", 14198322878931)], r15[r16("\xb1\xcd\xe2H\x02\x1dk8s%%r\xf6#H\xe1\x94Ը/yP\x15\xf4P\x1a\x03", 3975409616699)]);
                            end; 
                        end);
                    end; 
                end; 
            end;
            NH[43] = NH[43][NH[44]](NH[44]);
            NH[52], NH[49], NH[48], NH[44] = "\x84\xd3\xeb\x1b\xbd\xdeTc\xe6r", 14092613294498, "\r\xd5\tY\xd6", "task";
            NH[43] = Env[NH[44]];
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[38] = nil;
            NH[44] = function(...)
                while r24 do
                    task[r15[r16("\xb1C\xfc\x8f", 25885939576598)]](30);
                    pcall(function(...)
                        v1 = r90();
                        I = F[NH[21]];
                        if F[NH[3]] and F[NH[3]][r15[r16("HJ\xc5oC\x92l\x10\xc9I", 2660812948695)]] then
                            I = F[NH[3]];
                            I.SetOptions(I, v1);
                        end;
                        if F[NH[39]] and F[NH[39]][r15[r16("%2\xb1\xb2(Y\xcdى\x17", 10030346392126)]] then
                            I = F[NH[39]];
                            I.SetOptions(I, v1);
                        end;
                        if F[NH[22]] and F[NH[22]][r15[r16("'s\xe52\xd7RRS\xfc\x98", 18646651396587)]] then
                            I = F[NH[22]];
                            I.SetOptions(I, I());
                        end; 
                    end); 
                end; 
            end;
            NH[43] = NH[43][NH[44]](NH[44]);
            NH[44], NH[49] = "task", 6010171263726;
            NH[43] = Env[NH[44]];
            NH[45] = r15;
            NH[46] = r16;
            NH[48] = "|Y\xa6\xf5\x92";
            NH[47] = NH[46](NH[48], NH[49]);
            NH[16] = nil;
            NH[44] = NH[45][NH[47]];
            NH[48] = "ޏ(\x1c";
            NH[39] = nil;
            NH[44] = function(...)
                while r24 do
                    task[r15[r16("\xa7\xa5\x7f\x9c", 3528162887274)]](120);
                    pcall(function(...)
                        r76(r15[r16("\xc2\xf6\xf5ei", 14661540272811)], r15[r16("\xa61\xe5\xea\xceCƢP,ԛm\x06\xe7\x07\xa1Oԡ=<~Їk\x9e\xf8\xc5rDP\x88C9*", 31881488611837)], 10); 
                    end); 
                end; 
            end;
            NH[43] = NH[43][NH[44]](NH[44]);
            NH[43], NH[49] = "pcall", 16244828757388;
            NH[44] = function(...)
                I = r26;
                v1 = I.JSONDecode(I, readfile(r15[r16(")\x19\xb2r\x9b! \x10EV\xc13\x84\xa1Z,-\xaf\xf1\x00E=", 29666724607478)]));
                if v1 then
                    I = r57;
                    I[r15[r16("l\xf6?\x97 [\xa5}\xc1/w\x82\xcap~U", 5083519600959)]] = tostring(v1[r15[r16("3]\x08\xaa\xf2", 22414343514309)]] or r15[r16("\xce", 17443256721338)]);
                    I = r57;
                    I[r15[r16("{\x95\x9e\xf0g\xec\xf2\"", 26679941902471)]] = tostring(v1[r15[r16("O\xa5\x1ev@\x00\x06\xb8", 22068289284132)]] or r15[r16("\xe7\x15", 10293375062713)]);
                end; 
            end;
            NH[43] = Env[NH[43]](NH[44]);
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[49] = 10728719815555;
            NH[44] = NH[45][NH[47]];
            NH[48] = "\xceC\xf5\x05\x08\xf4";
            NH[43] = JY[NH[44]];
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[3] = nil;
            NH[47] = "['\xb9\xf0\xdeP\xa9\x0cs";
            NH[43] = NH[43][NH[44]]();
            NH[44] = r15;
            NH[48] = 4858327533782;
            NH[45] = r16;
            NH[46] = NH[45](NH[47], NH[48]);
            NH[43] = NH[44][NH[46]];
            NH[48], NH[49] = "\t\xb1@\xa0", 10040378511939;
            LY.SetFolder(LY, NH[43]);
            NH[44] = "task";
            NH[22] = nil;
            LY.LoadAutoLoadConfig(LY);
            NH[43] = Env[NH[44]];
            NH[45] = r15;
            NH[46] = r16;
            NH[47] = NH[46](NH[48], NH[49]);
            NH[44] = NH[45][NH[47]];
            NH[49] = "2L\xea\xa4\xfaɆ67";
            NH[44] = 0.5;
            NH[43] = NH[43][NH[44]](NH[44]);
            r73 = false;
            NH[43] = r76;
            NH[46] = r15;
            NH[47] = r16;
            NH[48] = NH[47](NH[49], NH[50]);
            NH[50], NH[42] = "K\xc9@\x85޺\xae\xaa\x17\x88j_I\xf7\xeab\x15\x87\xd0\x00\xd8\x1f\xa0K>Ƭ\x13", nil;
            NH[45] = NH[46][NH[48]];
            NH[47] = r15;
            NH[48] = r16;
            NH[49] = NH[48](NH[50], NH[51]);
            NH[46] = NH[47][NH[49]];
            NH[47] = 5;
            NH[48] = "game";
            NH[44] = NH[43](NH[45], NH[46], NH[47]);
            NH[43] = true;
            NH[44] = 130;
            F[NH[44]] = NH[43];
            NH[40], NH[43] = nil, nil;
            NH[46] = "hookmetamethod";
            NH[45] = 131;
            F[NH[45]] = NH[43];
            NH[43] = Env[NH[46]];
            NH[47] = Env[NH[48]];
            NH[49] = r15;
            NH[50] = r16;
            NH[41] = nil;
            NH[51] = NH[50](NH[52], NH[53]);
            NH[48] = NH[49][NH[51]];
            NH[49] = function(arg1_69, ...)
                z = {
                    y(2, K(n))
                };
                T = F[NH[44]];
                if T then
                    P, I = not checkcaller() and getnamecallmethod() == r15[r16("\xb3\xa5\x9a8*\xdbt\xbb\x03\x87", 27198067847545)], {
                        K(z)
                    };
                end;
                if T then
                    T = K(z);
                    if type(T) == r15[r16("\xe9.3\x8c\xae", 3543400449650)] then
                        if T[r15[r16("cd\x7f\x0f", 20377926739217)]] == r15[r16("\r\xb51\xb4\x9a\xc0\x02", 16195697909109)] then
                            return;
                        end;
                    end;
                end;
                return F[NH[45]](arg1_69, K(z)); 
            end;
            NH[44] = nil;
            NH[46] = NH[43](NH[47], NH[48], NH[49]);
            F[NH[45]] = NH[46];
            NH[45] = nil;
            NH[21] = nil;
            return;
        else
            P = r15[r16("\xb71\xc5Ȁ", 2219987452937)];
        end;
    else
        P = r15[r16("", 704498401608)];
    end; 
end);