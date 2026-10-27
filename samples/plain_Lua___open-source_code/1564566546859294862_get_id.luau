local info = loadstring(game:HttpGet("https://sneekysscripts.uk/Scripts/FOV_LIBRARY/info.luau"))();

return function(asset: string)
    local a = asset == "logo" and "rbxassetid://135051411499830" or "rbxassetid://98007778578768";

    if getcustomasset and isfolder and makefolder and isfile and writefile and readfile and delfolder then
        local path = "sneekys_scripts_assets";
        local s, isfo = pcall(isfolder, path);
        if not s then return a; end;

        if not isfo then
            if not pcall(makefolder, path) then return a; end;
        end;

        local upToDate = true;

        do
            local vpath = path .. "/version.sneekysscripts";
            local s2, isver = pcall(isfile, vpath);
            if not s2 then return a; end;

            if not isver then
                upToDate = false;
                if not pcall(writefile, vpath, info.version) then return a; end;
            else
                local s3, r = pcall(readfile, vpath);
                if not s3 then return a; end;

                if info.version ~= r then
                    upToDate = false;
                    if not pcall(writefile, vpath, info.version) then return a; end;
                end;
            end;
        end;

        if not upToDate then
            pcall(delfolder, path);
            pcall(makefolder, path);
            pcall(writefile, path .. "/version.sneekysscripts", info.version);
        end;

        local fpath = path .. "/" .. info.names[asset] .. ".png";
        local s2, isfi = pcall(isfile, fpath);
        if not s2 then return a; end;

        if not (isfi and upToDate) then if not pcall(writefile, fpath, game:HttpGet("https://sneekysscripts.uk/Scripts/FOV_LIBRARY/" .. asset .. ".png")) then return a; end; end;

        return pcall(getcustomasset, fpath) and getcustomasset(fpath) or a;
    end;

    return a;
end;
