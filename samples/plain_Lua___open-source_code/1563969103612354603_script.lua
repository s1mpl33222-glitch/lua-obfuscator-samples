--!nocheck

if shared.vapedeveloper ~= nil then
    shared.VapeDeveloper = shared.vapedeveloper
end
local Directory: string = shared.VapeDeveloper and "catprivate" or "catsix"

local Licence = { }
Licence.Key = script_key or "quDjnm4liF63GoYOq2dVJafP1ERhuuEOfurM9UmpXUMDLDMy"

local cloneref:(<T>(T) -> T) | (<a>(a) -> a) = cloneref or function(Reference: any) return Reference end
local isfile: (string) -> boolean = isfile or function(File: string): boolean
    local Success: boolean, Result = pcall(function()
        return readfile(File)
    end)

    return Success and Result
end

local HttpService: HttpService = cloneref(game:GetService("HttpService"))
local EncodingService: EncodingService = cloneref(game:GetService("EncodingService"))

type ContentData = {
    sha: string,
    content: string,
    encoding: string,
    path: string
}

type Contents = {files: {ContentData}}
type GotContents = {Success: boolean, Data: Contents}

local function GetGithubContents(Path: string): GotContents
    local Success: boolean, Result: string = pcall(function()
        return game:HttpGet("https://api.catvape.dev/contents/src")
    end)

    if Success then
        local SuccessfulJSONDecode, JSON = pcall(HttpService.JSONDecode, HttpService, Result)
        return {
            Success = SuccessfulJSONDecode,
            Data = JSON
        }
    end

    return {
        Success = false,
        Data = Result
    }
end

local function DownloadAsset(FileData: ContentData): ()
    if FileData.encoding == "base64" then
        FileData.content = buffer.tostring(EncodingService:Base64Decode(buffer.fromstring(FileData.content)))
    end

    local FilePath: string = `{Directory}/{FileData.path:gsub("src/", "")}`
    if not isfile(FilePath) or readfile(FilePath) ~= FileData.content then
        writefile(FilePath, FileData.content)
    end
end

local function DownloadAssets(Contents: GotContents, NewUser: boolean): boolean
    if Contents.Success then
        for i: number, v: {content: string, path: string?, sha: string} in Contents.Data.files do
            if not NewUser and v.path:find("/profiles/") then
                continue
            end

            DownloadAsset(v)
        end
    end

    return Contents.Success
end

for _, Folder: string in {Directory, `{Directory}/games`, `{Directory}/profiles`, `{Directory}/assets`, `{Directory}/libraries`, `{Directory}/guis`} do
    if not isfolder(Folder) then
        makefolder(Folder)
    end
end

if not shared.VapeDeveloper then
    local Commit: string? = Licence.Commit
    if not Commit then
        local Success: boolean, Result: string = pcall(function() 
            return game:HttpGet('https://api.catvape.dev/commit') 
        end)

        if Success then
            local SuccessJSON, JSON = pcall(HttpService.JSONDecode, HttpService, Result)
            if SuccessJSON then
                Commit = JSON.sha
            end
        end
    end

    local NewUser: boolean = not isfile(`{Directory}/profiles/commit.txt`) or #listfiles(Directory) < 7
    if NewUser or readfile(`{Directory}/profiles/commit.txt`) ~= Commit then
        local Success: boolean = DownloadAssets(GetGithubContents(), NewUser)
        if Success and Commit then
            warn(`Successfully updated to {Commit}`)
            writefile(`{Directory}/profiles/commit.txt`, Commit)
        else
            warn(`Failed to update to {Commit}`)
        end
    end
end

return loadstring(readfile(`{Directory}/main.lua`), 'main')(Licence)