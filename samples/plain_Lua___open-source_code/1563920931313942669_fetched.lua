-- Seeto.Solutionz / Bloxstrike Skinchanger / Standalone Engine
-- Repository: https://github.com/euphonee/Seeto.Solutionz-Bloxstrike-Skinchanger

-- Cleanup previous instance
if _G.__seetoSkinChangerJanitor then
    pcall(_G.__seetoSkinChangerJanitor)
    _G.__seetoSkinChangerJanitor = nil
end

-- Module loader
local modules = {}
local function import(moduleName)
    if modules[moduleName] then return modules[moduleName] end

    if type(readfile) == "function" then
        local paths = {
            "Seeto.Solutionz-Bloxstrike-Skinchanger/src/" .. moduleName .. ".lua",
            "Bloxstrike-Skinchanger/src/" .. moduleName .. ".lua",
            "src/" .. moduleName .. ".lua",
            moduleName .. ".lua"
        }
        for _, path in ipairs(paths) do
            local ok, content = pcall(readfile, path)
            if ok and content then
                local fn = loadstring(content)
                if fn then
                    local res = fn()
                    modules[moduleName] = res
                    return res
                end
            end
        end
    end

    -- Remote GitHub fallback with cache-busting timestamp
    local okHttp, remoteContent = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/euphonee/Seeto.Solutionz-Bloxstrike-Skinchanger/main/src/" .. moduleName .. ".lua?t=" .. tostring(os.time()))
    end)
    if okHttp and remoteContent and #remoteContent > 0 then
        local fn = loadstring(remoteContent)
        if fn then
            local res = fn()
            modules[moduleName] = res
            return res
        end
    end

    error("[Bloxstrike Skinchanger] Failed to import module: " .. tostring(moduleName))
end

-- Imports
local Config       = import("Config")
local Database     = import("Database")
local Engine       = import("Engine")
local API          = import("API")
local KnifeCatalog = import("KnifeCatalog")
local GunCatalog   = import("GunCatalog")
local LinoriaLib   = import("LinoriaLib")
local UIManager    = import("UIManager")

-- Bind subsystems
API.bind(Config, Database, Engine, KnifeCatalog, GunCatalog)
UIManager.bindCatalogs(KnifeCatalog, GunCatalog)

-- Initialize Engine
API.init()

-- Cleanup routine
local function cleanup()
    UIManager.cleanup()
    API.cleanup()
    _G.SkinChanger = nil
    _G.__seetoSkinChangerJanitor = nil
end

-- Initialize UI with Knife catalog and gun controls
UIManager.init(Config, LinoriaLib, API, Database, cleanup)

-- Global exports
_G.SkinChanger = API
_G.__seetoSkinChangerJanitor = cleanup

print("Seeto.Solutionz / Bloxstrike Skinchanger / Initialized with Visual 3D Catalog")
return API
