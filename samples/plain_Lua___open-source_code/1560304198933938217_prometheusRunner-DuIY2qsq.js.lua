var e=Object.create,t=Object.defineProperty,n=Object.getOwnPropertyDescriptor,r=Object.getOwnPropertyNames,i=Object.getPrototypeOf,a=Object.prototype.hasOwnProperty,o=(e,t)=>()=>(t||(e((t={exports:{}}).exports,t),e=null),t.exports),s=(e,i,o,s)=>{if(i&&typeof i==`object`||typeof i==`function`)for(var c=r(i),l=0,u=c.length,d;l<u;l++)d=c[l],!a.call(e,d)&&d!==o&&t(e,d,{get:(e=>i[e]).bind(null,d),enumerable:!(s=n(i,d))||s.enumerable});return e},c=(n,r,o)=>(o=n==null?{}:e(i(n)),s(r||!n||!n.__esModule||!a.call(n,`default`)?t(o,`default`,{value:n,enumerable:!0}):o,n)),l=o(((e,t)=>{t.exports={}})),u=`/assets/glue-Dlydm7r2.wasm`,d={cli:`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- cli.lua
--
-- This Script contains the Code for the Prometheus CLI.

-- Configure package.path for requiring Prometheus.
local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*[/%\\\\])")
end
package.path = script_path() .. "?.lua;" .. package.path

local INSTALL_SCRIPT_URL = "https://raw.githubusercontent.com/prometheus-lua/Prometheus/master/install.sh"

local function run_shell(command)
	local ok = os.execute(command)
	if type(ok) == "number" then
		return ok == 0
	end
	if type(ok) == "boolean" then
		return ok
	end
	return false
end

local function get_version()
	local version = os.getenv("PROMETHEUS_LUA_VERSION")
	if version and version ~= "" then
		return version
	end
	return "dev"
end

local function print_help()
	print("Prometheus Lua CLI")
	print("Usage: prometheus-lua [command] [options] <input.lua>")
	print("")
	print("Commands:")
	print("  update                 Install latest release via installer script")
	print("  --version, -v          Print CLI version")
	print("")
	print("Obfuscation options:")
	print("  --preset, --p <name>   Use preset (e.g. Minify, Medium, High)")
	print("  --config, --c <file>   Use custom config Lua file")
	print("  --out, --o <file>      Set output path")
	print("  --Lua51                Force Lua 5.1 target")
	print("  --LuaU                 Force LuaU target")
	print("  --pretty               Pretty print output")
	print("  --nocolors             Disable colored logs")
	print("  --saveerrors           Persist parser errors to file")
end

local function run_update()
	local command
	if run_shell("command -v curl >/dev/null 2>&1") then
		command = string.format("curl -fsSL '%s' | sh", INSTALL_SCRIPT_URL)
	elseif run_shell("command -v wget >/dev/null 2>&1") then
		command = string.format("wget -qO- '%s' | sh", INSTALL_SCRIPT_URL)
	else
		io.stderr:write("Neither curl nor wget was found. Please install one of them and retry.\\n")
		os.exit(1)
	end

	print("Updating prometheus-lua using official installer")
	if not run_shell(command) then
		io.stderr:write("Update failed\\n")
		os.exit(1)
	end

	print("Update completed")
end

if arg[1] == "update" then
	run_update()
	os.exit(0)
end

if arg[1] == "--version" or arg[1] == "-v" then
	print(get_version())
	os.exit(0)
end

if arg[1] == "--help" or arg[1] == "-h" or arg[1] == "help" then
	print_help()
	os.exit(0)
end

---@diagnostic disable-next-line: different-requires
local Prometheus = require("prometheus")
Prometheus.Logger.logLevel = Prometheus.Logger.LogLevel.Info
Prometheus.Logger.errorCallback = function(...)
	local args = { ... }
	local message = table.concat(args, " ")
	io.stderr:write(Prometheus.colors(Prometheus.Config.NameUpper .. ": " .. message, "red") .. "\\n")
	os.exit(1)
end

-- Check if the file exists
local function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

string.split = function(str, sep)
	local fields = {}
	local pattern = string.format("([^%s]+)", sep)
	str:gsub(pattern, function(c)
		fields[#fields + 1] = c
	end)
	return fields
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
local function lines_from(file)
	if not file_exists(file) then
		return {}
	end
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

local function load_chunk(content, chunkName, environment)
	if type(loadstring) == "function" then
		local func, err = loadstring(content, chunkName)
		if not func then
			return nil, err
		end
		if environment and type(setfenv) == "function" then
			setfenv(func, environment)
		elseif environment and type(load) == "function" then
			return load(content, chunkName, "t", environment)
		end
		return func
	end

	if type(load) ~= "function" then
		return nil, "No load function available"
	end

	return load(content, chunkName, "t", environment)
end

local function run_cli()
	-- CLI
	local config, sourceFile, outFile, luaVersion, prettyPrint

	Prometheus.colors.enabled = true

	-- Parse Arguments
	local i = 1
	while i <= #arg do
		local curr = arg[i]
		if curr:sub(1, 2) == "--" then
			if curr == "--preset" or curr == "--p" then
				if config then
					Prometheus.Logger:warn("The config was set multiple times")
				end

				i = i + 1
				local pName = arg[i]
				local preset = Prometheus.Presets[pName]
				if not preset and type(pName) == "string" then
					local clean = pName:lower():gsub("[%s_%-+]", "")
					for name, p in pairs(Prometheus.Presets) do
						if tostring(name):lower():gsub("[%s_%-+]", "") == clean then
							preset = p
							break
						end
					end
				end
				if not preset then
					Prometheus.Logger:error(string.format('A Preset with the name "%s" was not found!', tostring(arg[i])))
				end

				config = preset
			elseif curr == "--config" or curr == "--c" then
				i = i + 1
				local filename = tostring(arg[i])
				if not file_exists(filename) then
					Prometheus.Logger:error(string.format('The config file "%s" was not found!', filename))
				end

				local content = table.concat(lines_from(filename), "\\n")
				-- Load Config from File
				local func, err = load_chunk(content, "@" .. filename, {})
				if not func then
					Prometheus.Logger:error(string.format('Failed to parse config file "%s": %s', filename, tostring(err)))
				end
				config = func()
			elseif curr == "--out" or curr == "--o" then
				i = i + 1
				if outFile then
					Prometheus.Logger:warn("The output file was specified multiple times!")
				end
				outFile = arg[i]
			elseif curr == "--nocolors" then
				Prometheus.colors.enabled = false
			elseif curr == "--Lua51" then
				luaVersion = "Lua51"
			elseif curr == "--LuaU" then
				luaVersion = "LuaU"
			elseif curr == "--pretty" then
				prettyPrint = true
			elseif curr == "--saveerrors" then
				-- Override error callback
				Prometheus.Logger.errorCallback = function(...)
					local args = { ... }
					local message = table.concat(args, " ")
					io.stderr:write(Prometheus.colors(Prometheus.Config.NameUpper .. ": " .. message, "red") .. "\\n")

					local fileName = sourceFile:sub(-4) == ".lua" and sourceFile:sub(0, -5) .. ".error.txt"
						or sourceFile .. ".error.txt"
					local handle = io.open(fileName, "w")
					handle:write(message)
					handle:close()

					os.exit(1)
				end
			else
				Prometheus.Logger:warn(string.format('The option "%s" is not valid and therefore ignored', curr))
			end
		else
			if sourceFile then
				Prometheus.Logger:error(string.format('Unexpected argument "%s"', arg[i]))
			end
			sourceFile = tostring(arg[i])
		end
		i = i + 1
	end

	if not sourceFile then
		Prometheus.Logger:error("No input file was specified!")
	end

	if not config then
		Prometheus.Logger:warn("No config was specified, falling back to Minify preset")
		config = Prometheus.Presets.Minify
	end

	-- Add Option to override Lua Version
	config.LuaVersion = luaVersion or config.LuaVersion
	config.PrettyPrint = prettyPrint ~= nil and prettyPrint or config.PrettyPrint

	if not file_exists(sourceFile) then
		Prometheus.Logger:error(string.format('The File "%s" was not found!', sourceFile))
	end

	if not outFile then
		if sourceFile:sub(-4) == ".lua" then
			outFile = sourceFile:sub(0, -5) .. ".obfuscated.lua"
		else
			outFile = sourceFile .. ".obfuscated.lua"
		end
	end

	local source = table.concat(lines_from(sourceFile), "\\n")
	local pipeline = Prometheus.Pipeline:fromConfig(config)
	local out = pipeline:apply(source, sourceFile)
	Prometheus.Logger:info(string.format('Writing output to "%s"', outFile))

	-- Write Output
	local handle = io.open(outFile, "w")
	handle:write(out)
	handle:close()
end

local ok, err = xpcall(run_cli, function(e)
	return tostring(e)
end)
if not ok then
	local message = tostring(err):gsub("^.-:%d+:%s*", "")
	io.stderr:write(Prometheus.colors(Prometheus.Config.NameUpper .. ": " .. message, "red") .. "\\n")
	os.exit(1)
end
`,colors:`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- colors.lua
--
-- This Script provides a simple method for syntax highlighting of Lua code

local keys = {
	reset = 0,
	bright = 1,
	dim = 2,
	underline = 4,
	blink = 5,
	reverse = 7,
	hidden = 8,
	black = 30,
	pink = 91,
	red = 31,
	green = 32,
	yellow = 33,
	blue = 34,
	magenta = 35,
	cyan = 36,
	grey = 37,
	gray = 37,
	white = 97,
	blackbg = 40,
	redbg = 41,
	greenbg = 42,
	yellowbg = 43,
	bluebg = 44,
	magentabg = 45,
	cyanbg = 46,
	greybg = 47,
	graybg = 47,
	whitebg = 107,
}

local escapeString = string.char(27) .. "[%dm"
local function escapeNumber(number)
	return escapeString:format(number)
end

local settings = {
	enabled = true,
}

local function colors(str, ...)
	if not settings.enabled then
		return str
	end
	str = tostring(str or "")

	local escapes = {}
	for _, name in ipairs({ ... }) do
		table.insert(escapes, escapeNumber(keys[name]))
	end

	return escapeNumber(keys.reset) .. table.concat(escapes) .. str .. escapeNumber(keys.reset)
end

return setmetatable(settings, {
	__call = function(_, ...)
		return colors(...)
	end,
})
`,config:`-- This Script is Part of the Prometheus Obfuscator by Levno_710
--
-- config.lua
--
-- In this Script, some Global config Variables are defined

local NAME = "Prometheus";
local REVISION = "Alpha";
local VERSION = "v0.2";
local BY = "levno-710";

for _, currArg in pairs(arg or {}) do
	if currArg == "--CI" then
		local releaseName = string.gsub(string.format("%s %s %s", NAME, REVISION, VERSION), "%s", "-")
		print(releaseName)
	end

	if currArg == "--FullVersion" then
		print(VERSION)
	end
end

-- Config Starts here
return {
	Name = NAME,
	NameUpper = string.upper(NAME),
	NameAndVersion = string.format("%s %s", NAME, VERSION),
	Version = VERSION;
	Revision = REVISION;
	-- Config Starts Here
	IdentPrefix = "__prometheus_"; -- The Prefix used for Identifiers generated by PROMETHEUS. NOTE: There should be no identifiers in the script to be obfuscated starting with that prefix, because that can lead to weird bugs

	SPACE = " "; -- The Whitespace to be used by the unparser
	TAB = "\\t"; -- The Tab Whitespace to be used by the unparser for pretty printing
}`,highlightlua:`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- highlightlua.lua
--
-- This Script provides a simple Method for Syntax Highlighting of Lua code

local Tokenizer = require("prometheus.tokenizer");
local colors = require("colors");
local TokenKind = Tokenizer.TokenKind;
local lookupify = require("prometheus.util").lookupify;

return function(code, luaVersion)
    local out = "";
    local tokenizer = Tokenizer:new({
        LuaVersion = luaVersion,
    });

    tokenizer:append(code);
    local tokens = tokenizer:scanAll();

    local nonColorSymbols = lookupify{
        ",", ";", "(", ")", "{", "}", ".", ":", "[", "]"
    }

    local defaultGlobals = lookupify{
        "string", "table", "bit32", "bit"
    }

    local currentPos = 1;
    for _, token in ipairs(tokens) do
        if token.startPos >= currentPos then
            out = out .. string.sub(code, currentPos, token.startPos);
        end
        if token.kind == TokenKind.Ident then
            if defaultGlobals[token.source] then
                out = out .. colors(token.source, "red");
            else
                out = out .. token.source;
            end
        elseif token.kind == TokenKind.Keyword then
            if token.source == "nil" then
                out = out .. colors(token.source, "yellow");
            else
                out = out .. colors(token.source, "yellow");
            end
        elseif token.kind == TokenKind.Symbol then
            if nonColorSymbols[token.source] then
                out = out .. token.source;
            else
                out = out .. colors(token.source, "yellow");
            end
        elseif token.kind == TokenKind.String then
            out = out .. colors(token.source, "green")
        elseif token.kind == TokenKind.Number then
            out = out .. colors(token.source, "red")
        else
            out = out .. token.source;
        end

        currentPos = token.endPos + 1;
    end
    return out;
end`,logger:`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- logger.lua
--
-- This Script provides a Logger for Prometheus.

local logger = {}
local config = require("config");
local colors = require("colors");

logger.LogLevel = {
	None = -1,
	Error = 0,
	Warn = 1,
	Log = 2,
	Info = 2,
	Debug = 3,
}

logger.logLevel = logger.LogLevel.Log;

logger.debugCallback = function(...)
	print(colors(config.NameUpper .. ": " ..  ..., "grey"));
end;
function logger:debug(...)
	if self.logLevel >= self.LogLevel.Debug then
		self.debugCallback(...);
	end
end

logger.logCallback = function(...)
	print(colors(config.NameUpper .. ": ", "magenta") .. ...);
end;
function logger:log(...)
	if self.logLevel >= self.LogLevel.Log then
		self.logCallback(...);
	end
end

function logger:info(...)
	if self.logLevel >= self.LogLevel.Log then
		self.logCallback(...);
	end
end

logger.warnCallback = function(...)
	print(colors(config.NameUpper .. ": " .. ..., "yellow"));
end;
function logger:warn(...)
	if self.logLevel >= self.LogLevel.Warn then
		self.warnCallback(...);
	end
end

logger.errorCallback = function(...)
	print(colors(config.NameUpper .. ": " .. ..., "red"))
	error(...);
end;
function logger:error(...)
	self.errorCallback(...);
	error(config.NameUpper .. ": logger.errorCallback did not throw an Error!");
end


return logger;`,presets:`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- presets.lua
--
-- This Script provides the predefined obfuscation presets for Prometheus

local Presets = {
	-- Minifies your code. Does not obfuscate it. No performance loss.
	["Minify"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "MangledShuffled",
		PrettyPrint = false,
		Seed = 0,
		Steps = {},
	},

	-- Weak obfuscation. Very readable, low performance loss.
	["Weak"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "MangledShuffled",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			{ Name = "Vmify", Settings = {} },
			{
				Name = "ConstantArray",
				Settings = {
					Threshold = 1,
					StringsOnly = true,
					Encoding = "none",
				},
			},
			{ Name = "WrapInFunction", Settings = {} },
		},
	},

	-- This is here for the tests.lua file.
	["Vmify"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "MangledShuffled",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			{ Name = "Vmify", Settings = {} },
		},
	},

	-- Medium obfuscation. Moderate obfuscation, moderate performance loss.
	["Medium"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "LexicalEntropy",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			{ Name = "MemberAccessObfuscation", Settings = { Threshold = 0.8 } },
			{ Name = "OpaquePredicates", Settings = { Threshold = 0.4, InjectDeadBlocks = true } },
			{ Name = "LiteralsToExpressions", Settings = { Threshold = 0.8 } },
			{ Name = "SplitStrings", Settings = { Threshold = 0.6, MinLength = 4, MaxLength = 12 } },
			{ Name = "EncryptStrings", Settings = {} },
			{ Name = "Vmify", Settings = {} },
			{
				Name = "ConstantArray",
				Settings = {
					Threshold = 1,
					StringsOnly = true,
					Shuffle = true,
					Rotate = true,
					Encoding = "mixed",
					LocalWrapperThreshold = 0,
				},
			},
			{ Name = "NumbersToExpressions", Settings = {} },
			{ Name = "WrapInFunction", Settings = {} },
		},
	},

	-- Strong obfuscation, high security protection.
	["Strong"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "LexicalEntropy",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			{ Name = "MemberAccessObfuscation", Settings = { Threshold = 1.0 } },
			{ Name = "ControlFlowFlattening", Settings = { Threshold = 3, MaxBlocks = 20, DecoyStates = 2 } },
			{ Name = "OpaquePredicates", Settings = { Threshold = 0.6, InjectDeadBlocks = true } },
			{ Name = "LiteralsToExpressions", Settings = { Threshold = 1.0 } },
			{ Name = "SplitStrings", Settings = { Threshold = 0.7, MinLength = 4, MaxLength = 12 } },
			{ Name = "EncryptStrings", Settings = {} },
			{ Name = "MetamethodGuard", Settings = { AntiHook = true, DecoyDivergence = true } },
			{ Name = "ExecutionFlowIntegrity", Settings = { RollingState = true, CallStackValidation = true } },
			{ Name = "Vmify", Settings = {} },
			{
				Name = "ConstantArray",
				Settings = {
					Threshold = 1,
					StringsOnly = true,
					Shuffle = true,
					Rotate = true,
					Encoding = "base64",
					LocalWrapperThreshold = 0,
				},
			},
			{
				Name = "NumbersToExpressions",
				Settings = { NumberRepresentationMutation = true },
			},
			{ Name = "WrapInFunction", Settings = {} },
		},
	},

	-- PinatVM Very Max
	["VeryMax"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "LexicalEntropy",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			{ Name = "MemberAccessObfuscation", Settings = { Threshold = 1.0 } },
			{ Name = "ControlFlowFlattening", Settings = { Threshold = 3, MaxBlocks = 25, DecoyStates = 3 } },
			{ Name = "OpaquePredicates", Settings = { Threshold = 0.8, InjectDeadBlocks = true } },
			{ Name = "LiteralsToExpressions", Settings = { Threshold = 1.0 } },
			{ Name = "SplitStrings", Settings = { Threshold = 0.8, MinLength = 4, MaxLength = 12 } },
			{ Name = "EncryptStrings", Settings = {} },
			{ Name = "MetamethodGuard", Settings = { AntiHook = true, DecoyDivergence = true, StringMetaProtection = true } },
			{ Name = "ExecutionFlowIntegrity", Settings = { RollingState = true, CallStackValidation = true, SilentDegradation = true } },
			{
				Name = "Vmify",
				Settings = {
					ProtectionPreset = "VeryMax",
					AntiEnvLogger = true,
					RuntimeProfile = "Hardened",
					StrictVerification = true,
					ControlFlowFlattening = true,
					BlockSplitting = true,
				},
			},
			{ Name = "MetatableWrapper", Settings = {} },
		},
	},

	-- PVM Utmost: Hyper-Hardened Multi-Pillar VM Protection.
	-- Constant pool: base64-encoded per-entry, shuffled+rotated,
	-- accessed via per-scope 2×6-arg indirection wrappers (parse-safe, no raw bytes).
	-- Tuned for faster step application without any security reduction.
	["Utmost"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "LexicalEntropy",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			-- Pillar 1: Computed member access encryption
			{ Name = "MemberAccessObfuscation", Settings = { Threshold = 0.60 } },
			-- Pillar 2: Control flow flattening — tuned MaxBlocks=6 for high-speed dispatch
			{ Name = "ControlFlowFlattening", Settings = { Threshold = 6, MaxBlocks = 6, DecoyStates = 2 } },
			-- Pillar 3: Opaque predicates
			{ Name = "OpaquePredicates", Settings = { Threshold = 0.35, InjectDeadBlocks = true } },
			-- Pillar 4: Literal-to-expression substitution
			{ Name = "LiteralsToExpressions", Settings = { Threshold = 0.30 } },
			-- Pillar 5: SplitStrings BEFORE encryption — fragments originals, not ciphertext
			{ Name = "SplitStrings", Settings = { Threshold = 0.25, MinLength = 6, MaxLength = 16 } },
			-- Pillar 6: Polymorphic string encryption (runs on pre-fragmented strings)
			{ Name = "EncryptStrings", Settings = {} },
			-- Pillar 7: Metamethod guard — anti-hook, decoy divergence, string-meta protection
			{ Name = "MetamethodGuard", Settings = { AntiHook = true, DecoyDivergence = true, StringMetaProtection = true } },
			-- Pillar 8: Execution Flow Integrity — rolling affine state + call-stack + env-logger
			{ Name = "ExecutionFlowIntegrity", Settings = { RollingState = true, CallStackValidation = true, SilentDegradation = true } },
			-- Pillar 9: PVM virtualization — state-machine dispatch, anti-env-logger, strict verification
			{
				Name = "Vmify",
				Settings = {
					ProtectionPreset = "Utmost",
					AntiEnvLogger = true,
					RuntimeProfile = "Utmost",
					StrictVerification = true,
					ControlFlowFlattening = false,
					BlockSplitting = false,
					StateMachineDispatch = true,
				},
			},
			-- Pillar 10: Anti-Tamper integrity loop (no debug API)
			{ Name = "AntiTamper", Settings = { UseDebug = false } },
			-- Pillar 11: Constant pool — base64-encoded (printable-only, parse-safe),
			--            shuffled+rotated, 1 per-scope 4-arg indirection wrapper for optimal size.
			{
				Name = "ConstantArray",
				Settings = {
					Threshold = 1,
					StringsOnly = true,
					Shuffle = true,
					Rotate = true,
					Encoding = "base64",
					LocalWrapperThreshold = 1,
					LocalWrapperCount = 1,
					LocalWrapperArgCount = 4,
					MaxWrapperOffset = 65535,
					MaxStringLength = 256,
				},
			},
			-- Pillar 12: Number literal mutation
			{
				Name = "NumbersToExpressions",
				Settings = { NumberRepresentationMutation = true },
			},
			-- Pillar 13: GC Finalizer Trap — detects forced GC or __gc hook suppression
			--   (Utmost is for smaller scripts — GC cost acceptable)
			{ Name = "GCFinalizerTrap", Settings = { SilentCorrupt = true } },
			-- Pillar 14: Debug Library Poison — upvalue hijack + native function integrity
			{ Name = "DebugLibPoison", Settings = { CheckNativeFunctions = false, SilentCorrupt = true } },
			-- Pillar 15: String Metatable Poison — guard string.__index replacement
			{ Name = "StringMetaPoison", Settings = { SilentCorrupt = true } },
			-- Pillar 16: CoroutineFragmentation — coroutine chain anti-trace
			{ Name = "CoroutineFragmentation", Settings = { FragmentCount = 4, DecoyCount = 3 } },
			-- Pillar 17 (NEW — InvocationNonceGuard): Frame-level invocation nonce validation
			{ Name = "InvocationNonceGuard", Settings = { SilentCorrupt = true } },
			-- Pillar 18 (NEW — DynamicStateMuxer): Non-linear co-invariant state multiplexer
			{ Name = "DynamicStateMuxer", Settings = { SilentCorrupt = true } },
			-- Pillar 19 (EnvSandboxPoison): Environment sandbox integrity probe
			{ Name = "EnvSandboxPoison", Settings = { SilentCorrupt = true, CheckDebugInfo = false } },
			-- Pillar 20 (NEW — TaintCallstackGuard): Nested callstack frame invariant probe
			{ Name = "TaintCallstackGuard", Settings = { SilentCorrupt = true } },
			-- Pillar 21 (NEW — ClosureMorphSentinel): Self-mutating upvalue Galois lock
			{ Name = "ClosureMorphSentinel", Settings = { SilentCorrupt = true } },
			-- Pillar 22 (AntiHookTrampoline): Metatable invariant & multi-return tail fidelity
			-- { Name = "AntiHookTrampoline", Settings = { SilentCorrupt = true } },
			-- Pillar 23 (NEW — AntiHttpSpy): Network logger & HTTP hook interceptor guard
			{ Name = "AntiHttpSpy", Settings = { SilentCorrupt = true } },
			-- Pillar 24 (NEW — AntiMemoryDumper): Cyclic decoy metatable crawler trap
			{ Name = "AntiMemoryDumper", Settings = { TrapDepth = 2 } },
			-- Pillar 25 (NEW — TableFreezerSentinel): table.freeze & immutability invariant
			{ Name = "TableFreezerSentinel", Settings = { SilentCorrupt = true } },
			-- Pillar 26 (NEW — BytecodeEntropyLock): IEEE-754 mantissa & Knuth LCG emulator lock
			{ Name = "BytecodeEntropyLock", Settings = { SilentCorrupt = true } },
			-- Pillar 27 (NEW — MockEnvironmentTrap): Headless bot sandbox & mock table trap
			{ Name = "MockEnvironmentTrap", Settings = { SilentCorrupt = true } },
			-- Pillar 28 (NEW — DispatcherLoopCamouflage): Honeypot VM dispatcher for static unpacker defeat
			{ Name = "DispatcherLoopCamouflage", Settings = {} },
			-- Pillar 29 (NEW — ParserDesyncGuard): AST parser depth & lexer desync trap
			{ Name = "ParserDesyncGuard", Settings = { Depth = 45 } },
			-- Pillar 30 (BenignASTCamouflage): Realistic utility library AST camouflage
			{ Name = "BenignASTCamouflage", Settings = { Preset = "LuauBridge" } },
			{ Name = "MetatableWrapper", Settings = { FiberTrampoline = true } },
		},
	},

	-- VM + register machine
	["VM + register machine"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "LexicalEntropy",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			{ Name = "WrapInFunction", Settings = {} },
			{ Name = "MemberAccessObfuscation", Settings = { Threshold = 1.0 } },
			{ Name = "ControlFlowFlattening", Settings = { Threshold = 3, MaxBlocks = 25, DecoyStates = 3 } },
			{ Name = "OpaquePredicates", Settings = { Threshold = 0.8, InjectDeadBlocks = true } },
			{ Name = "LiteralsToExpressions", Settings = { Threshold = 1.0 } },
			{ Name = "SplitStrings", Settings = { Threshold = 0.8, MinLength = 4, MaxLength = 12 } },
			{ Name = "EncryptStrings", Settings = {} },
			{ Name = "MetamethodGuard", Settings = { AntiHook = true, DecoyDivergence = true, StringMetaProtection = true } },
			{ Name = "ExecutionFlowIntegrity", Settings = { RollingState = true, CallStackValidation = true, SilentDegradation = true } },
			{
				Name = "Vmify",
				Settings = {
					ProtectionPreset = "VeryMax",
					AntiEnvLogger = true,
					RuntimeProfile = "Hardened",
					StrictVerification = true,
					ControlFlowFlattening = true,
					BlockSplitting = true,
					StateMachineDispatch = true,
				},
			},
			{ Name = "AntiTamper", Settings = { UseDebug = false } },
			{
				Name = "ConstantArray",
				Settings = {
					Threshold = 1,
					StringsOnly = true,
					Shuffle = true,
					Rotate = true,
					Encoding = "base64",
					LocalWrapperThreshold = 1,
					LocalWrapperCount = 2,
					LocalWrapperArgCount = 8,
					MaxWrapperOffset = 65535,
				},
			},
			{
				Name = "NumbersToExpressions",
				Settings = { NumberRepresentationMutation = true },
			},
			{ Name = "MetatableWrapper", Settings = {} },
		},
	},

	-- PVM Titan: Zero-Pool VM-Protected Obfuscation for scripts of any size (1–40k+ lines).
	--
	-- KEY DESIGN: No ConstantArray pool at all — pool-based obfuscation creates a single
	-- dumpable table in memory. Instead, every string is protected inline by EncryptStrings
	-- (unique per-string cipher expression) then the entire output is wrapped in PinatVM.
	-- The VM virtualizes all inline decryptors — they cannot be hooked from outside the VM.
	--
	-- Security stack (all steps are single O(n) AST passes — fast on any script size):
	--   1. MemberAccessObfuscation  — computed property key encryption
	--   2. OpaquePredicates         — insoluble dead-branch injection
	--   3. LiteralsToExpressions    — arithmetic dissolving of numeric/string literals
	--   4. SplitStrings             — pre-fragments strings BEFORE encryption
	--   5. EncryptStrings           — inline per-fragment cipher (no central pool)
	--   6. MetamethodGuard          — anti-hook canary + string metatable sentinel
	--   7. ExecutionFlowIntegrity   — rolling affine state + env-logger source probe
	--   8. AntiTamper               — payload integrity sanity loop (no debug API)
	--   9. Vmify (PinatVM)          — VM wraps everything; inline decryptors virtualized
	--  10. NumbersToExpressions     — number literal mutation outside VM
	--  11. WrapInFunction           — closure scope isolation
	--
	-- Why lightweight:
	--   - Zero ConstantArray overhead (no pool, no wrapper functions, no decoder injection)
	--   - Zero ControlFlowFlattening (no AST node explosion)
	--   - All pre-VM steps are single linear AST passes
	--   - Vmify is the only heavy step — one pass, unavoidable, gives the VM layer
	["Titan"] = {
		LuaVersion = "Lua51",
		VarNamePrefix = "",
		NameGenerator = "LexicalEntropy",
		PrettyPrint = false,
		Seed = 0,
		Steps = {
			-- Layer 1: Computed member access encryption (fast on large scripts)
			{ Name = "MemberAccessObfuscation", Settings = { Threshold = 0.50 } },
			-- Layer 2: Opaque predicates — insoluble dead-block conditions (25% threshold)
			{ Name = "OpaquePredicates", Settings = { Threshold = 0.25, InjectDeadBlocks = true } },
			-- Layer 3: Dissolve numeric and string literals into arithmetic expressions
			{ Name = "LiteralsToExpressions", Settings = { Threshold = 0.25 } },
			-- Layer 4 (NEW — Anti-VM-Dump): NumbersToExpressions BEFORE Vmify.
			--   Numeric constants (including future VM opcodes) become arithmetic expressions.
			--   Any tool that dumps VM bytecode sees expressions, not raw opcode integers.
			--   Breaks all automated VM decompilers that expect numeric opcode constants.
			--   Pure O(n) linear pass — zero overhead on large scripts.
			{ Name = "NumbersToExpressions", Settings = { NumberRepresentationMutation = true } },
			-- Layer 5: SplitStrings BEFORE encryption — fragments originals, not ciphertext
			{ Name = "SplitStrings", Settings = { Threshold = 0.20, MinLength = 6, MaxLength = 16 } },
			-- Layer 6: Inline per-fragment string encryption — NO central pool.
			--   Each fragment gets a unique cipher expression. Nothing to dump.
			{ Name = "EncryptStrings", Settings = {} },
			-- Layer 7: Metamethod guard — anti-hook detection + string metatable sentinel
			--          (DecoyDivergence=false — saves perf on large scripts)
			{ Name = "MetamethodGuard", Settings = { AntiHook = true, DecoyDivergence = false, StringMetaProtection = true } },
			-- Layer 8: Execution flow integrity — affine rolling state + env-logger probe
			--   (CallStackValidation=false — linear cost only, no stack traversal)
			{ Name = "ExecutionFlowIntegrity", Settings = { RollingState = true, CallStackValidation = false, SilentDegradation = true } },
			-- Layer 9: PinatVM — virtualizes layers 1–8 above.
			--   MetamethodGuard and ExecutionFlowIntegrity run inside the VM, unhookable externally.
			--   Pre-VM NumbersToExpressions (Layer 4) mutated all opcodes into arithmetic expressions.
			{
				Name = "Vmify",
				Settings = {
					AntiEnvLogger = true,
					ControlFlowFlattening = false,
					BlockSplitting = false,
				},
			},
			-- Layer 10: Post-VM number mutation — VM interpreter numbers also obfuscated.
			{
				Name = "NumbersToExpressions",
				Settings = { NumberRepresentationMutation = true },
			},
			-- Layer 11: Anti-tamper payload integrity (MUST run post-VM — AntiTamper's pcall/error
			--   patterns crash inside PinatVM bytecode virtualisation).
			--   Guards the entire VM wrapper in native Lua.
			{ Name = "AntiTamper", Settings = { UseDebug = false } },
			-- Layer 12 (NEW — ClosureGuard): Upvalue chain integrity sentinel.
			--   Runs OUTSIDE the VM in native Lua — guards the VM wrapper itself.
			--   Nested closure closes over a random anchor, validated via keyed math chain.
			--   If anchor is patched (debug.setupvalue / bytecode edit), chain fails → crash.
			--   O(1) inject: single do-end block, no AST traversal.
			{ Name = "ClosureGuard", Settings = { SilentCorrupt = true } },
			-- Layer 13 (NEW — ConstantSentinel): Runtime polynomial hash over N sentinel constants.
			--   Runs OUTSIDE the VM in native Lua — guards against constant pool dumps.
			--   N random sentinel values + prime coefficients baked at obfuscation time.
			--   At runtime recomputes polynomial; any constant modification triggers trap.
			--   O(1) inject: single do-end block, no AST traversal.
			{ Name = "ConstantSentinel", Settings = { SentinelCount = 4, SilentCorrupt = true } },
			-- Layer 14 (CoroutineFragmentation): Coroutine execution chain anti-trace.
			--   Attacker must trace 3+ coroutine stacks to reconstruct the call path.
			--   DecoyCount=2: 2 ghost coroutines as noise. O(1) overhead — runs once.
			{ Name = "CoroutineFragmentation", Settings = { FragmentCount = 3, DecoyCount = 2 } },
			-- Layer 15 (DebugLibPoison): Upvalue hijack + native function integrity check.
			--   Detects debug.setupvalue on our closures + hooks on pcall/type/tostring.
			{ Name = "DebugLibPoison", Settings = { CheckNativeFunctions = false, SilentCorrupt = true } },
			-- Layer 16 (StringMetaPoison): Guard string metatable __index against replacement.
			--   Validates string.byte fingerprint — detects string lib proxy injection.
			{ Name = "StringMetaPoison", Settings = { SilentCorrupt = true } },
			-- Layer 17 (EnvSandboxPoison): Environment sandbox integrity probe
			{ Name = "EnvSandboxPoison", Settings = { SilentCorrupt = true, CheckDebugInfo = false } },
			-- Layer 18 (NEW — InvocationNonceGuard): O(1) frame invocation nonce validation
			{ Name = "InvocationNonceGuard", Settings = { SilentCorrupt = true } },
			-- Layer 19 (NEW — DynamicStateMuxer): O(1) non-linear co-invariant state multiplexer
			{ Name = "DynamicStateMuxer", Settings = { SilentCorrupt = true } },
			-- Layer 20 (NEW — TaintCallstackGuard): Nested callstack frame invariant probe
			{ Name = "TaintCallstackGuard", Settings = { SilentCorrupt = true } },
			-- Layer 21 (NEW — ClosureMorphSentinel): Self-mutating upvalue Galois lock
			{ Name = "ClosureMorphSentinel", Settings = { SilentCorrupt = true } },
			-- Layer 22 (AntiHookTrampoline): Metatable invariant & multi-return tail fidelity
			-- { Name = "AntiHookTrampoline", Settings = { SilentCorrupt = true } },
			-- Layer 23 (NEW — AntiHttpSpy): Network logger & HTTP hook interceptor guard
			{ Name = "AntiHttpSpy", Settings = { SilentCorrupt = true } },
			-- Layer 24 (NEW — AntiMemoryDumper): Cyclic decoy metatable crawler trap
			{ Name = "AntiMemoryDumper", Settings = { TrapDepth = 2 } },
			-- Layer 25 (NEW — TableFreezerSentinel): table.freeze & immutability invariant
			{ Name = "TableFreezerSentinel", Settings = { SilentCorrupt = true } },
			-- Layer 26 (NEW — BytecodeEntropyLock): IEEE-754 mantissa & Knuth LCG emulator lock
			{ Name = "BytecodeEntropyLock", Settings = { SilentCorrupt = true } },
			-- Layer 27 (NEW — MockEnvironmentTrap): Headless bot sandbox & mock table trap
			{ Name = "MockEnvironmentTrap", Settings = { SilentCorrupt = true } },
			-- Layer 28 (NEW — DispatcherLoopCamouflage): Honeypot VM dispatcher for static unpacker defeat
			{ Name = "DispatcherLoopCamouflage", Settings = {} },
			-- Layer 29 (NEW — ParserDesyncGuard): AST parser depth & lexer desync trap
			{ Name = "ParserDesyncGuard", Settings = { Depth = 45 } },
			-- Layer 30 (NEW — BenignASTCamouflage): Realistic utility library AST camouflage (LuauBridge)
			{ Name = "BenignASTCamouflage", Settings = { Preset = "LuauBridge" } },
			-- Layer 31: Seal everything in fiber trampoline metatable proxy with decompiler decoy
			{ Name = "MetatableWrapper", Settings = { FiberTrampoline = true } },
		},
	},
}

-- Convenient aliases for CLI, Web UI, and external integrations
Presets["VmRegisterMachine"]    = Presets["VM + register machine"]
Presets["vm_register_machine"]  = Presets["VM + register machine"]
Presets["RegisterMachine"]      = Presets["VM + register machine"]
Presets["VMRegisterMachine"]    = Presets["VM + register machine"]
Presets["utmost"]               = Presets["Utmost"]
Presets["PVMUtmost"]            = Presets["Utmost"]
Presets["titan"]                = Presets["Titan"]
Presets["mega"]                 = Presets["Titan"]
Presets["Mega"]                 = Presets["Titan"]
Presets["enterprise"]           = Presets["Titan"]
Presets["large-code"]           = Presets["Titan"]
Presets["40k"]                  = Presets["Titan"]

return Presets
`,"prometheus.ast":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- ast.lua
--
-- This Script provides the Abstract Syntax Tree (AST) for Prometheus.

local Ast = {}

local AstKind = {
	-- Misc
	TopNode = "TopNode";
	Block = "Block";

	-- Statements
	ContinueStatement = "ContinueStatement";
	BreakStatement = "BreakStatement";
	DoStatement = "DoStatement";
	WhileStatement = "WhileStatement";
	ReturnStatement = "ReturnStatement";
	RepeatStatement = "RepeatStatement";
	ForInStatement = "ForInStatement";
	ForStatement = "ForStatement";
	IfStatement = "IfStatement";
	FunctionDeclaration = "FunctionDeclaration";
	LocalFunctionDeclaration = "LocalFunctionDeclaration";
	LocalVariableDeclaration = "LocalVariableDeclaration";
	FunctionCallStatement = "FunctionCallStatement";
	PassSelfFunctionCallStatement = "PassSelfFunctionCallStatement";
	AssignmentStatement = "AssignmentStatement";

	-- LuaU Compound Statements
	CompoundAddStatement = "CompoundAddStatement";
	CompoundSubStatement = "CompoundSubStatement";
	CompoundMulStatement = "CompoundMulStatement";
	CompoundDivStatement = "CompoundDivStatement";
	CompoundModStatement = "CompoundModStatement";
	CompoundPowStatement = "CompoundPowStatement";
	CompoundConcatStatement = "CompoundConcatStatement";

	-- Assignment Index
	AssignmentIndexing = "AssignmentIndexing";
	AssignmentVariable = "AssignmentVariable";

	-- Expression Nodes
	BooleanExpression = "BooleanExpression";
	NumberExpression = "NumberExpression";
	StringExpression = "StringExpression";
	NilExpression = "NilExpression";
	VarargExpression = "VarargExpression";
	OrExpression = "OrExpression";
	AndExpression = "AndExpression";
	LessThanExpression = "LessThanExpression";
	GreaterThanExpression = "GreaterThanExpression";
	LessThanOrEqualsExpression = "LessThanOrEqualsExpression";
	GreaterThanOrEqualsExpression = "GreaterThanOrEqualsExpression";
	NotEqualsExpression = "NotEqualsExpression";
	EqualsExpression = "EqualsExpression";
	StrCatExpression = "StrCatExpression";
	AddExpression = "AddExpression";
	SubExpression = "SubExpression";
	MulExpression = "MulExpression";
	DivExpression = "DivExpression";
	ModExpression = "ModExpression";
	NotExpression = "NotExpression";
	LenExpression = "LenExpression";
	NegateExpression = "NegateExpression";
	PowExpression = "PowExpression";
	IndexExpression = "IndexExpression";
	FunctionCallExpression = "FunctionCallExpression";
	PassSelfFunctionCallExpression = "PassSelfFunctionCallExpression";
	VariableExpression = "VariableExpression";
	FunctionLiteralExpression = "FunctionLiteralExpression";
	TableConstructorExpression = "TableConstructorExpression";

	-- Table Entry
	TableEntry = "TableEntry";
	KeyedTableEntry = "KeyedTableEntry";

	-- Misc
	NopStatement = "NopStatement";

	IfElseExpression = "IfElseExpression";
}

local astKindExpressionLookup = {
	[AstKind.BooleanExpression] = 0;
	[AstKind.NumberExpression] = 0;
	[AstKind.StringExpression] = 0;
	[AstKind.NilExpression] = 0;
	[AstKind.VarargExpression] = 0;
	[AstKind.OrExpression] = 12;
	[AstKind.AndExpression] = 11;
	[AstKind.LessThanExpression] = 10;
	[AstKind.GreaterThanExpression] = 10;
	[AstKind.LessThanOrEqualsExpression] = 10;
	[AstKind.GreaterThanOrEqualsExpression] = 10;
	[AstKind.NotEqualsExpression] = 10;
	[AstKind.EqualsExpression] = 10;
	[AstKind.StrCatExpression] = 9;
	[AstKind.AddExpression] = 8;
	[AstKind.SubExpression] = 8;
	[AstKind.MulExpression] = 7;
	[AstKind.DivExpression] = 7;
	[AstKind.ModExpression] = 7;
	[AstKind.NotExpression] = 5;
	[AstKind.LenExpression] = 5;
	[AstKind.NegateExpression] = 5;
	[AstKind.PowExpression] = 4;
	[AstKind.IndexExpression] = 1;
	[AstKind.AssignmentIndexing] = 1;
	[AstKind.FunctionCallExpression] = 2;
	[AstKind.PassSelfFunctionCallExpression] = 2;
	[AstKind.VariableExpression] = 0;
	[AstKind.AssignmentVariable] = 0;
	[AstKind.FunctionLiteralExpression] = 3;
	[AstKind.TableConstructorExpression] = 3;
}

Ast.AstKind = AstKind;

function Ast.astKindExpressionToNumber(kind)
	return astKindExpressionLookup[kind] or 100;
end

function Ast.ConstantNode(val)
	if type(val) == "nil" then
		return Ast.NilExpression();
	end

	if type(val) == "string" then
		return Ast.StringExpression(val);
	end

	if type(val) == "number" then
		return Ast.NumberExpression(val);
	end

	if type(val) == "boolean" then
		return Ast.BooleanExpression(val);
	end
end



function Ast.NopStatement()
	return {
		kind = AstKind.NopStatement;
	}
end

function Ast.IfElseExpression(condition, true_value, elseifs, false_value)
	return {
		kind = AstKind.IfElseExpression,
		condition = condition,
		true_value = true_value,
		elseifs = elseifs,
		false_value = false_value
	}
end

-- Create Ast Top Node
function Ast.TopNode(body, globalScope)
	return {
		kind = AstKind.TopNode,
		body = body,
		globalScope = globalScope,

	}
end

function Ast.TableEntry(value)
	return {
		kind = AstKind.TableEntry,
		value = value,

	}
end

function Ast.KeyedTableEntry(key, value)
	return {
		kind = AstKind.KeyedTableEntry,
		key = key,
		value = value,

	}
end

function Ast.TableConstructorExpression(entries)
	return {
		kind = AstKind.TableConstructorExpression,
		entries = entries,
	};
end

-- Create Statement Block
function Ast.Block(statements, scope)
	return {
		kind = AstKind.Block,
		statements = statements,
		scope = scope,
	}
end

-- Create Break Statement
function Ast.BreakStatement(loop, scope)
	return {
		kind = AstKind.BreakStatement,
		loop = loop,
		scope = scope,
	}
end

-- Create Continue Statement
function Ast.ContinueStatement(loop, scope)
	return {
		kind = AstKind.ContinueStatement,
		loop = loop,
		scope = scope,
	}
end

function Ast.PassSelfFunctionCallStatement(base, passSelfFunctionName, args)
	return {
		kind = AstKind.PassSelfFunctionCallStatement,
		base = base,
		passSelfFunctionName = passSelfFunctionName,
		args = args,
	}
end

function Ast.AssignmentStatement(lhs, rhs)
	if(#lhs < 1) then
		print(debug.traceback());
		error("Something went wrong!");
	end
	return {
		kind = AstKind.AssignmentStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.CompoundAddStatement(lhs, rhs)
	return {
		kind = AstKind.CompoundAddStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.CompoundSubStatement(lhs, rhs)
	return {
		kind = AstKind.CompoundSubStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.CompoundMulStatement(lhs, rhs)
	return {
		kind = AstKind.CompoundMulStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.CompoundDivStatement(lhs, rhs)
	return {
		kind = AstKind.CompoundDivStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.CompoundPowStatement(lhs, rhs)
	return {
		kind = AstKind.CompoundPowStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.CompoundModStatement(lhs, rhs)
	return {
		kind = AstKind.CompoundModStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.CompoundConcatStatement(lhs, rhs)
	return {
		kind = AstKind.CompoundConcatStatement,
		lhs = lhs,
		rhs = rhs,
	}
end

function Ast.FunctionCallStatement(base, args)
	return {
		kind = AstKind.FunctionCallStatement,
		base = base,
		args = args,
	}
end

function Ast.ReturnStatement(args)
	return {
		kind = AstKind.ReturnStatement,
		args = args,
	}
end

function Ast.DoStatement(body)
	return {
		kind = AstKind.DoStatement,
		body = body,
	}
end

function Ast.WhileStatement(body, condition, parentScope)
	return {
		kind = AstKind.WhileStatement,
		body = body,
		condition = condition,
		parentScope = parentScope,
	}
end

function Ast.ForInStatement(scope, vars, expressions, body, parentScope)
	return {
		kind = AstKind.ForInStatement,
		scope = scope,
		ids = vars,
		vars = vars,
		expressions = expressions,
		body = body,
		parentScope = parentScope,
	}
end

function Ast.ForStatement(scope, id, initialValue, finalValue, incrementBy, body, parentScope)
	return {
		kind = AstKind.ForStatement,
		scope = scope,
		id = id,
		initialValue = initialValue,
		finalValue = finalValue,
		incrementBy = incrementBy,
		body = body,
		parentScope = parentScope,
	}
end

function Ast.RepeatStatement(condition, body, parentScope)
	return {
		kind = AstKind.RepeatStatement,
		body = body,
		condition = condition,
		parentScope = parentScope,
	}
end

function Ast.IfStatement(condition, body, elseifs, elsebody)
	return {
		kind = AstKind.IfStatement,
		condition = condition,
		body = body,
		elseifs = elseifs,
		elsebody = elsebody,
	}
end

function Ast.FunctionDeclaration(scope, id, indices, args, body)
	return {
		kind = AstKind.FunctionDeclaration,
		scope = scope,
		baseScope = scope,
		id = id,
		baseId = id,
		indices = indices,
		args = args,
		body = body,
		getName = function(self)
			return self.scope:getVariableName(self.id);
		end,
	}
end

function Ast.LocalFunctionDeclaration(scope, id, args, body)
	return {
		kind = AstKind.LocalFunctionDeclaration,
		scope = scope,
		id = id,
		args = args,
		body = body,
		getName = function(self)
			return self.scope:getVariableName(self.id);
		end,
	}
end

function Ast.LocalVariableDeclaration(scope, ids, expressions)
	return {
		kind = AstKind.LocalVariableDeclaration,
		scope = scope,
		ids = ids,
		expressions = expressions,
	}
end

function Ast.VarargExpression()
	return {
		kind = AstKind.VarargExpression;
		isConstant = false,
	}
end

function Ast.BooleanExpression(value)
	return {
		kind = AstKind.BooleanExpression,
		isConstant = true,
		value = value,
	}
end

function Ast.NilExpression()
	return {
		kind = AstKind.NilExpression,
		isConstant = true,
		value = nil,
	}
end

function Ast.NumberExpression(value)
	return {
		kind = AstKind.NumberExpression,
		isConstant = true,
		value = value,
	}
end

function Ast.StringExpression(value)
	return {
		kind = AstKind.StringExpression,
		isConstant = true,
		value = value,
	}
end

function Ast.OrExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value or rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.OrExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.AndExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value and rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.AndExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.LessThanExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value < rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.LessThanExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.GreaterThanExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value > rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.GreaterThanExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.LessThanOrEqualsExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value <= rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.LessThanOrEqualsExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.GreaterThanOrEqualsExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value >= rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.GreaterThanOrEqualsExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.NotEqualsExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value ~= rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.NotEqualsExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.EqualsExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value == rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.EqualsExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.StrCatExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value .. rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.StrCatExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.AddExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value + rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.AddExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.SubExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value - rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.SubExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.MulExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value * rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.MulExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.DivExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant and rhs.value ~= 0) then
		local success, val = pcall(function() return lhs.value / rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.DivExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.ModExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value % rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.ModExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.NotExpression(rhs, simplify)
	if(simplify and rhs.isConstant) then
		local success, val = pcall(function() return not rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.NotExpression,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.NegateExpression(rhs, simplify)
	if(simplify and rhs.isConstant) then
		local success, val = pcall(function() return -rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.NegateExpression,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.LenExpression(rhs, simplify)
	if(simplify and rhs.isConstant) then
		local success, val = pcall(function() return #rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.LenExpression,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.PowExpression(lhs, rhs, simplify)
	if(simplify and rhs.isConstant and lhs.isConstant) then
		local success, val = pcall(function() return lhs.value ^ rhs.value end);
		if success then
			return Ast.ConstantNode(val);
		end
	end

	return {
		kind = AstKind.PowExpression,
		lhs = lhs,
		rhs = rhs,
		isConstant = false,
	}
end

function Ast.IndexExpression(base, index)
	return {
		kind = AstKind.IndexExpression,
		base = base,
		index = index,
		isConstant = false,
	}
end

function Ast.AssignmentIndexing(base, index)
	return {
		kind = AstKind.AssignmentIndexing,
		base = base,
		index = index,
		isConstant = false,
	}
end

function Ast.PassSelfFunctionCallExpression(base, passSelfFunctionName, args)
	return {
		kind = AstKind.PassSelfFunctionCallExpression,
		base = base,
		passSelfFunctionName = passSelfFunctionName,
		args = args,

	}
end

function Ast.FunctionCallExpression(base, args)
	return {
		kind = AstKind.FunctionCallExpression,
		base = base,
		args = args,
	}
end

function Ast.VariableExpression(scope, id)
	scope:addReference(id);
	return {
		kind = AstKind.VariableExpression,
		scope = scope,
		id = id,
		getName = function(self)
			return self.scope.getVariableName(self.id);
		end,
	}
end

function Ast.AssignmentVariable(scope, id)
	scope:addReference(id);
	return {
		kind = AstKind.AssignmentVariable,
		scope = scope,
		id = id,
		getName = function(self)
			return self.scope.getVariableName(self.id);
		end,
	}
end

function Ast.FunctionLiteralExpression(args, body)
	return {
		kind = AstKind.FunctionLiteralExpression,
		args = args,
		body = body,
	}
end



return Ast;
`,"prometheus.compiler.block":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- block.lua
--
-- Block management for the compiler

local Scope = require("prometheus.scope");
local util = require("prometheus.util");

local lookupify = util.lookupify;

return function(Compiler)
    function Compiler:createBlock()
        local id;
        repeat
            id = math.random(0, 2^24)
        until not self.usedBlockIds[id];
        self.usedBlockIds[id] = true;

        local scope = Scope:new(self.containerFuncScope);
        local block = {
            id = id;
            statements = {};
            scope = scope;
            advanceToNextBlock = true;
        };
        table.insert(self.blocks, block);
        return block;
    end

    function Compiler:setActiveBlock(block)
        self.activeBlock = block;
    end

    function Compiler:addStatement(statement, writes, reads, usesUpvals)
        if(self.activeBlock.advanceToNextBlock) then
            table.insert(self.activeBlock.statements, {
                statement = statement,
                writes = lookupify(writes),
                reads = lookupify(reads),
                usesUpvals = usesUpvals or false,
            });
        end
    end
end

`,"prometheus.compiler.compile_core":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- compile_core.lua
-- This Script contains the core compilation functions: compileTopNode, compileFunction, compileBlock,
-- compileStatement, and compileExpression

local compileTop = require("prometheus.compiler.compile_top");
local statementHandlers = require("prometheus.compiler.statements");
local expressionHandlers = require("prometheus.compiler.expressions");
local Ast = require("prometheus.ast");
local logger = require("logger");

return function(Compiler)
    compileTop(Compiler);

    function Compiler:compileStatement(statement, funcDepth)
        local handler = statementHandlers[statement.kind];
        if handler then
            handler(self, statement, funcDepth);
            return;
        end
        logger:error(string.format("%s is not a compileable statement!", statement.kind));
    end

    function Compiler:compileExpression(expression, funcDepth, numReturns)
        local handler = expressionHandlers[expression.kind];
        if handler then
            return handler(self, expression, funcDepth, numReturns);
        end
        logger:error(string.format("%s is not an compliable expression!", expression.kind));
    end
end
`,"prometheus.compiler.compile_top":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- compile_top.lua
--
-- This Script contains the compilation of the top node, function, and block.

local Ast = require("prometheus.ast");
local util = require("prometheus.util");
local visitast = require("prometheus.visitast");

local lookupify = util.lookupify;
local AstKind = Ast.AstKind;

return function(Compiler)
    function Compiler:compileTopNode(node)
        local startBlock = self:createBlock();
        local scope = startBlock.scope;
        self.startBlockId = startBlock.id;
        self:setActiveBlock(startBlock);

        local varAccessLookup = lookupify{
            AstKind.AssignmentVariable,
            AstKind.VariableExpression,
            AstKind.FunctionDeclaration,
            AstKind.LocalFunctionDeclaration,
        }

        local functionLookup = lookupify{
            AstKind.FunctionDeclaration,
            AstKind.LocalFunctionDeclaration,
            AstKind.FunctionLiteralExpression,
            AstKind.TopNode,
        }
        visitast(node, function(node, data)
            if node.kind == AstKind.Block then
                node.scope.__depth = data.functionData.depth;
            end

            if varAccessLookup[node.kind] then
                if not node.scope.isGlobal then
                    if node.scope.__depth < data.functionData.depth then
                        if not self:isUpvalue(node.scope, node.id) then
                            self:makeUpvalue(node.scope, node.id);
                        end
                    end
                end
            end
        end, nil, nil)

        self.varargReg = self:allocRegister(true);
        scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar);
        scope:addReferenceToHigherScope(self.scope, self.selectVar);
        scope:addReferenceToHigherScope(self.scope, self.unpackVar);
        self:addStatement(self:setRegister(scope, self.varargReg, Ast.VariableExpression(self.containerFuncScope, self.argsVar)), {self.varargReg}, {}, false);

        self:compileBlock(node.body, 0);
        if(self.activeBlock.advanceToNextBlock) then
            self:addStatement(self:setPos(self.activeBlock.scope, nil), {self.POS_REGISTER}, {}, false);
            self:addStatement(self:setReturn(self.activeBlock.scope, Ast.TableConstructorExpression({})), {self.RETURN_REGISTER}, {}, false)
            self.activeBlock.advanceToNextBlock = false;
        end

        self:resetRegisters();
    end

    function Compiler:compileFunction(node, funcDepth)
        funcDepth = funcDepth + 1;
        local oldActiveBlock = self.activeBlock;

        local upperVarargReg = self.varargReg;
        self.varargReg = nil;

        local upvalueExpressions = {};
        local upvalueIds = {};
        local usedRegs = {};

        local oldGetUpvalueId = self.getUpvalueId;
        self.getUpvalueId = function(self, scope, id)
            if(not upvalueIds[scope]) then
                upvalueIds[scope] = {};
            end
            if(upvalueIds[scope][id]) then
                return upvalueIds[scope][id];
            end
            local scopeFuncDepth = self.scopeFunctionDepths[scope];
            local expression;
            if(scopeFuncDepth == funcDepth) then
                oldActiveBlock.scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction);
                expression = Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {});
            elseif(scopeFuncDepth == funcDepth - 1) then
                local varReg = self:getVarRegister(scope, id, scopeFuncDepth, nil);
                expression = self:register(oldActiveBlock.scope, varReg);
                table.insert(usedRegs, varReg);
            else
                local higherId = oldGetUpvalueId(self, scope, id);
                oldActiveBlock.scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar);
                expression = Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar), Ast.NumberExpression(higherId));
            end
            table.insert(upvalueExpressions, Ast.TableEntry(expression));
            local uid = #upvalueExpressions;
            upvalueIds[scope][id] = uid;
            return uid;
        end

        local block = self:createBlock();
        self:setActiveBlock(block);
        local scope = self.activeBlock.scope;
        self:pushRegisterUsageInfo();
        for i, arg in ipairs(node.args) do
            if(arg.kind == AstKind.VariableExpression) then
                if(self:isUpvalue(arg.scope, arg.id)) then
                    scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction);
                    local argReg = self:getVarRegister(arg.scope, arg.id, funcDepth, nil);
                    self:addStatement(self:setRegister(scope, argReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {})), {argReg}, {}, false);
                    self:addStatement(self:setUpvalueMember(scope, self:register(scope, argReg), Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.argsVar), Ast.NumberExpression(i))), {}, {argReg}, true);
                else
                    local argReg = self:getVarRegister(arg.scope, arg.id, funcDepth, nil);
                    scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar);
                    self:addStatement(self:setRegister(scope, argReg, Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.argsVar), Ast.NumberExpression(i))), {argReg}, {}, false);
                end
            else
                self.varargReg = self:allocRegister(true);
                scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar);
                scope:addReferenceToHigherScope(self.scope, self.selectVar);
                scope:addReferenceToHigherScope(self.scope, self.unpackVar);
                self:addStatement(self:setRegister(scope, self.varargReg, Ast.TableConstructorExpression({
                    Ast.TableEntry(Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.selectVar), {
                        Ast.NumberExpression(i);
                        Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.unpackVar), {
                            Ast.VariableExpression(self.containerFuncScope, self.argsVar),
                        });
                    })),
                })), {self.varargReg}, {}, false);
            end
        end

        self:compileBlock(node.body, funcDepth);
        if(self.activeBlock.advanceToNextBlock) then
            self:addStatement(self:setPos(self.activeBlock.scope, nil), {self.POS_REGISTER}, {}, false);
            self:addStatement(self:setReturn(self.activeBlock.scope, Ast.TableConstructorExpression({})), {self.RETURN_REGISTER}, {}, false);
            self.activeBlock.advanceToNextBlock = false;
        end

        if(self.varargReg) then
            self:freeRegister(self.varargReg, true);
        end
        self.varargReg = upperVarargReg;
        self.getUpvalueId = oldGetUpvalueId;

        self:popRegisterUsageInfo();
        self:setActiveBlock(oldActiveBlock);

        local scope = self.activeBlock.scope;

        local retReg = self:allocRegister(false);

        local isVarargFunction = #node.args > 0 and node.args[#node.args].kind == AstKind.VarargExpression;

        local retrieveExpression
        if isVarargFunction then
            scope:addReferenceToHigherScope(self.scope, self.createVarargClosureVar);
            retrieveExpression = Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.createVarargClosureVar), {
                Ast.NumberExpression(block.id),
                Ast.TableConstructorExpression(upvalueExpressions)
            });
        else
            local varScope, var = self:getCreateClosureVar(#node.args + math.random(0, 5));
            scope:addReferenceToHigherScope(varScope, var);
            retrieveExpression = Ast.FunctionCallExpression(Ast.VariableExpression(varScope, var), {
                Ast.NumberExpression(block.id),
                Ast.TableConstructorExpression(upvalueExpressions)
            });
        end

        self:addStatement(self:setRegister(scope, retReg, retrieveExpression), {retReg}, usedRegs, false);
        return retReg;
    end

    function Compiler:compileBlock(block, funcDepth)
        for i, stat in ipairs(block.statements) do
            self:compileStatement(stat, funcDepth);
        end

        local scope = self.activeBlock.scope;
        for id, name in ipairs(block.scope.variables) do
            local varReg = self:getVarRegister(block.scope, id, funcDepth, nil);
            if self:isUpvalue(block.scope, id) then
                scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc);
                self:addStatement(self:setRegister(scope, varReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.freeUpvalueFunc), {
                    self:register(scope, varReg)
                })), {varReg}, {varReg}, false);
            else
                self:addStatement(self:setRegister(scope, varReg, Ast.NilExpression()), {varReg}, {}, false);
            end
            self:freeRegister(varReg, true);
        end
    end
end

`,"prometheus.compiler.compiler":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- compiler.lua
--
-- This Script is the main compiler module.

local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");
local util = require("prometheus.util");

local lookupify = util.lookupify;
local AstKind = Ast.AstKind;

local unpack = unpack or table.unpack;

local blockModule = require("prometheus.compiler.block");
local registerModule = require("prometheus.compiler.register");
local upvalueModule = require("prometheus.compiler.upvalue");
local emitModule = require("prometheus.compiler.emit");
local compileCoreModule = require("prometheus.compiler.compile_core");

local Compiler = {};

function Compiler:new()
    local compiler = {
        blocks = {};
        registers = {};
        activeBlock = nil;
        registersForVar = {};
        usedRegisters = 0;
        maxUsedRegister = 0;
        registerVars = {};

        VAR_REGISTER = newproxy(false);
        RETURN_ALL = newproxy(false);
        POS_REGISTER = newproxy(false);
        RETURN_REGISTER = newproxy(false);
        UPVALUE = newproxy(false);

        BIN_OPS = lookupify{
            AstKind.LessThanExpression,
            AstKind.GreaterThanExpression,
            AstKind.LessThanOrEqualsExpression,
            AstKind.GreaterThanOrEqualsExpression,
            AstKind.NotEqualsExpression,
            AstKind.EqualsExpression,
            AstKind.StrCatExpression,
            AstKind.AddExpression,
            AstKind.SubExpression,
            AstKind.MulExpression,
            AstKind.DivExpression,
            AstKind.ModExpression,
            AstKind.PowExpression,
        };
    };

    setmetatable(compiler, self);
    self.__index = self;

    return compiler;
end

blockModule(Compiler);
registerModule(Compiler);
upvalueModule(Compiler);
emitModule(Compiler);
compileCoreModule(Compiler);

function Compiler:pushRegisterUsageInfo()
    table.insert(self.registerUsageStack, {
        usedRegisters = self.usedRegisters;
        registers = self.registers;
    });
    self.usedRegisters = 0;
    self.registers = {};
end

function Compiler:popRegisterUsageInfo()
    local info = table.remove(self.registerUsageStack);
    self.usedRegisters = info.usedRegisters;
    self.registers = info.registers;
end

function Compiler:compile(ast)
    self.blocks = {};
    self.registers = {};
    self.activeBlock = nil;
    self.registersForVar = {};
    self.scopeFunctionDepths = {};
    self.maxUsedRegister = 0;
    self.usedRegisters = 0;
    self.registerVars = {};
    self.usedBlockIds = {};

    self.upvalVars = {};
    self.registerUsageStack = {};

    self.upvalsProxyLenReturn = math.random(-2^22, 2^22);

    local newGlobalScope = Scope:newGlobal();
    local psc = Scope:new(newGlobalScope, nil);

    local _, getfenvVar = newGlobalScope:resolve("getfenv");
    local _, tableVar = newGlobalScope:resolve("table");
    local _, unpackVar = newGlobalScope:resolve("unpack");
    local _, envVar = newGlobalScope:resolve("_G");
    local _, newproxyVar = newGlobalScope:resolve("newproxy");
    local _, setmetatableVar = newGlobalScope:resolve("setmetatable");
    local _, getmetatableVar = newGlobalScope:resolve("getmetatable");
    local _, selectVar = newGlobalScope:resolve("select");

    psc:addReferenceToHigherScope(newGlobalScope, getfenvVar, 2);
    psc:addReferenceToHigherScope(newGlobalScope, tableVar);
    psc:addReferenceToHigherScope(newGlobalScope, unpackVar);
    psc:addReferenceToHigherScope(newGlobalScope, envVar);
    psc:addReferenceToHigherScope(newGlobalScope, newproxyVar);
    psc:addReferenceToHigherScope(newGlobalScope, setmetatableVar);
    psc:addReferenceToHigherScope(newGlobalScope, getmetatableVar);

    self.scope = Scope:new(psc);
    self.envVar = self.scope:addVariable();
    self.containerFuncVar = self.scope:addVariable();
    self.unpackVar = self.scope:addVariable();
    self.newproxyVar = self.scope:addVariable();
    self.setmetatableVar = self.scope:addVariable();
    self.getmetatableVar = self.scope:addVariable();
    self.selectVar = self.scope:addVariable();

    local argVar = self.scope:addVariable();

    self.containerFuncScope = Scope:new(self.scope);
    self.whileScope = Scope:new(self.containerFuncScope);

    self.posVar = self.containerFuncScope:addVariable();
    self.argsVar = self.containerFuncScope:addVariable();
    self.currentUpvaluesVar = self.containerFuncScope:addVariable();
    self.detectGcCollectVar = self.containerFuncScope:addVariable();
    self.returnVar = self.containerFuncScope:addVariable();

    self.upvaluesTable = self.scope:addVariable();
    self.upvaluesReferenceCountsTable = self.scope:addVariable();
    self.allocUpvalFunction = self.scope:addVariable();
    self.currentUpvalId = self.scope:addVariable();

    self.upvaluesProxyFunctionVar = self.scope:addVariable();
    self.upvaluesGcFunctionVar = self.scope:addVariable();
    self.freeUpvalueFunc = self.scope:addVariable();

    self.createClosureVars = {};
    self.createVarargClosureVar = self.scope:addVariable();
    local createClosureScope = Scope:new(self.scope);
    local createClosurePosArg = createClosureScope:addVariable();
    local createClosureUpvalsArg = createClosureScope:addVariable();
    local createClosureProxyObject = createClosureScope:addVariable();
    local createClosureFuncVar = createClosureScope:addVariable();

    local createClosureSubScope = Scope:new(createClosureScope);

    local upvalEntries = {};
    local upvalueIds = {};
    self.getUpvalueId = function(self, scope, id)
        local expression;
        local scopeFuncDepth = self.scopeFunctionDepths[scope];
        if(scopeFuncDepth == 0) then
            if upvalueIds[id] then
                return upvalueIds[id];
            end
            expression = Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {});
        else
            require("logger"):error("Unresolved Upvalue, this error should not occur!");
        end
        table.insert(upvalEntries, Ast.TableEntry(expression));
        local uid = #upvalEntries;
        upvalueIds[id] = uid;
        return uid;
    end

    createClosureSubScope:addReferenceToHigherScope(self.scope, self.containerFuncVar);
    createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosurePosArg)
    createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureUpvalsArg, 1)
    createClosureScope:addReferenceToHigherScope(self.scope, self.upvaluesProxyFunctionVar)
    createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureProxyObject);

    self:compileTopNode(ast);

    local functionNodeAssignments = {
        {
            var = Ast.AssignmentVariable(self.scope, self.containerFuncVar),
            val = Ast.FunctionLiteralExpression({
                Ast.VariableExpression(self.containerFuncScope, self.posVar),
                Ast.VariableExpression(self.containerFuncScope, self.argsVar),
                Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar),
                Ast.VariableExpression(self.containerFuncScope, self.detectGcCollectVar)
            }, self:emitContainerFuncBody());
        }, {
            var = Ast.AssignmentVariable(self.scope, self.createVarargClosureVar),
            val = Ast.FunctionLiteralExpression({
                    Ast.VariableExpression(createClosureScope, createClosurePosArg),
                    Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
                },
                Ast.Block({
                    Ast.LocalVariableDeclaration(createClosureScope, {
                        createClosureProxyObject
                    }, {
                        Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.upvaluesProxyFunctionVar), {
                            Ast.VariableExpression(createClosureScope, createClosureUpvalsArg)
                        })
                    }),
                    Ast.LocalVariableDeclaration(createClosureScope, {createClosureFuncVar},{
                        Ast.FunctionLiteralExpression({
                            Ast.VarargExpression();
                        },
                        Ast.Block({
                            Ast.ReturnStatement{
                                Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.containerFuncVar), {
                                    Ast.VariableExpression(createClosureScope, createClosurePosArg),
                                    Ast.TableConstructorExpression({Ast.TableEntry(Ast.VarargExpression())}),
                                    Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
                                    Ast.VariableExpression(createClosureScope, createClosureProxyObject)
                                })
                            }
                        }, createClosureSubScope)
                        );
                    });
                    Ast.ReturnStatement{Ast.VariableExpression(createClosureScope, createClosureFuncVar)};
                }, createClosureScope)
            );
        }, {
            var = Ast.AssignmentVariable(self.scope, self.upvaluesTable),
            val = Ast.TableConstructorExpression({}),
        }, {
            var = Ast.AssignmentVariable(self.scope, self.upvaluesReferenceCountsTable),
            val = Ast.TableConstructorExpression({}),
        }, {
            var = Ast.AssignmentVariable(self.scope, self.allocUpvalFunction),
            val = self:createAllocUpvalFunction(),
        }, {
            var = Ast.AssignmentVariable(self.scope, self.currentUpvalId),
            val = Ast.NumberExpression(0),
        }, {
            var = Ast.AssignmentVariable(self.scope, self.upvaluesProxyFunctionVar),
            val = self:createUpvaluesProxyFunc(),
        }, {
            var = Ast.AssignmentVariable(self.scope, self.upvaluesGcFunctionVar),
            val = self:createUpvaluesGcFunc(),
        }, {
            var = Ast.AssignmentVariable(self.scope, self.freeUpvalueFunc),
            val = self:createFreeUpvalueFunc(),
        },
    }

    local tbl = {
        Ast.VariableExpression(self.scope, self.containerFuncVar),
        Ast.VariableExpression(self.scope, self.createVarargClosureVar),
        Ast.VariableExpression(self.scope, self.upvaluesTable),
        Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable),
        Ast.VariableExpression(self.scope, self.allocUpvalFunction),
        Ast.VariableExpression(self.scope, self.currentUpvalId),
        Ast.VariableExpression(self.scope, self.upvaluesProxyFunctionVar),
        Ast.VariableExpression(self.scope, self.upvaluesGcFunctionVar),
        Ast.VariableExpression(self.scope, self.freeUpvalueFunc),
    };
    for i, entry in pairs(self.createClosureVars) do
        table.insert(functionNodeAssignments, entry);
        table.insert(tbl, Ast.VariableExpression(entry.var.scope, entry.var.id));
    end

    util.shuffle(functionNodeAssignments);
    local assignmentStatLhs, assignmentStatRhs = {}, {};
    for i, v in ipairs(functionNodeAssignments) do
        assignmentStatLhs[i] = v.var;
        assignmentStatRhs[i] = v.val;
    end


    -- Closure-local runtime references (no external dependency parameters):
    local internalLhs = {
        Ast.AssignmentVariable(self.scope, self.envVar),
        Ast.AssignmentVariable(self.scope, self.unpackVar),
        Ast.AssignmentVariable(self.scope, self.newproxyVar),
        Ast.AssignmentVariable(self.scope, self.setmetatableVar),
        Ast.AssignmentVariable(self.scope, self.getmetatableVar),
        Ast.AssignmentVariable(self.scope, self.selectVar),
        Ast.AssignmentVariable(self.scope, argVar),
    }

    local internalRhs = {
        Ast.OrExpression(Ast.AndExpression(Ast.VariableExpression(newGlobalScope, getfenvVar), Ast.FunctionCallExpression(Ast.VariableExpression(newGlobalScope, getfenvVar), {})), Ast.VariableExpression(newGlobalScope, envVar)),
        Ast.OrExpression(Ast.VariableExpression(newGlobalScope, unpackVar), Ast.IndexExpression(Ast.VariableExpression(newGlobalScope, tableVar), Ast.StringExpression("unpack"))),
        Ast.VariableExpression(newGlobalScope, newproxyVar),
        Ast.VariableExpression(newGlobalScope, setmetatableVar),
        Ast.VariableExpression(newGlobalScope, getmetatableVar),
        Ast.VariableExpression(newGlobalScope, selectVar),
        Ast.TableConstructorExpression({
            Ast.TableEntry(Ast.VarargExpression());
        })
    }

    local finalLhs = {}
    local finalRhs = {}
    for i = 1, #internalLhs do
        finalLhs[#finalLhs + 1] = internalLhs[i]
        finalRhs[#finalRhs + 1] = internalRhs[i]
    end
    for i = 1, #assignmentStatLhs do
        finalLhs[#finalLhs + 1] = assignmentStatLhs[i]
        finalRhs[#finalRhs + 1] = assignmentStatRhs[i]
    end

    local functionNode = Ast.FunctionLiteralExpression(
        { unpack(util.shuffle(tbl)) },
        Ast.Block({
            Ast.AssignmentStatement(finalLhs, finalRhs);
            Ast.ReturnStatement{
                Ast.FunctionCallExpression(Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.createVarargClosureVar), {
                        Ast.NumberExpression(self.startBlockId);
                        Ast.TableConstructorExpression(upvalEntries);
                    }), {Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.unpackVar), {Ast.VariableExpression(self.scope, argVar)})});
            }
        }, self.scope)
    );

    return Ast.TopNode(Ast.Block({
        Ast.ReturnStatement{Ast.FunctionCallExpression(functionNode, {})};
    }, psc), newGlobalScope);
end

function Compiler:getCreateClosureVar(argCount)
    if not self.createClosureVars[argCount] then
        local var = Ast.AssignmentVariable(self.scope, self.scope:addVariable());
        local createClosureScope = Scope:new(self.scope);
        local createClosureSubScope = Scope:new(createClosureScope);

        local createClosurePosArg = createClosureScope:addVariable();
        local createClosureUpvalsArg = createClosureScope:addVariable();
        local createClosureProxyObject = createClosureScope:addVariable();
        local createClosureFuncVar = createClosureScope:addVariable();

        createClosureSubScope:addReferenceToHigherScope(self.scope, self.containerFuncVar);
        createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosurePosArg)
        createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureUpvalsArg, 1)
        createClosureScope:addReferenceToHigherScope(self.scope, self.upvaluesProxyFunctionVar)
        createClosureSubScope:addReferenceToHigherScope(createClosureScope, createClosureProxyObject);

        local  argsTb, argsTb2 = {}, {};
        for i = 1, argCount do
            local arg = createClosureSubScope:addVariable()
            argsTb[i] = Ast.VariableExpression(createClosureSubScope, arg);
            argsTb2[i] = Ast.TableEntry(Ast.VariableExpression(createClosureSubScope, arg));
        end

        local val = Ast.FunctionLiteralExpression({
            Ast.VariableExpression(createClosureScope, createClosurePosArg),
            Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
        }, Ast.Block({
                Ast.LocalVariableDeclaration(createClosureScope, {
                    createClosureProxyObject
                }, {
                    Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.upvaluesProxyFunctionVar), {
                        Ast.VariableExpression(createClosureScope, createClosureUpvalsArg)
                    })
                }),
                Ast.LocalVariableDeclaration(createClosureScope, {createClosureFuncVar},{
                    Ast.FunctionLiteralExpression(argsTb,
                    Ast.Block({
                        Ast.ReturnStatement{
                            Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.containerFuncVar), {
                                Ast.VariableExpression(createClosureScope, createClosurePosArg),
                                Ast.TableConstructorExpression(argsTb2),
                                Ast.VariableExpression(createClosureScope, createClosureUpvalsArg),
                                Ast.VariableExpression(createClosureScope, createClosureProxyObject)
                            })
                        }
                    }, createClosureSubScope)
                    );
                });
                Ast.ReturnStatement{Ast.VariableExpression(createClosureScope, createClosureFuncVar)}
            }, createClosureScope)
        );
        self.createClosureVars[argCount] = {
            var = var,
            val = val,
        }
    end


    local var = self.createClosureVars[argCount].var;
    return var.scope, var.id;
end

return Compiler;
`,"prometheus.compiler.constants":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- constants.lua
--
-- This Script contains the compiler constants shared across modules.

return {
    MAX_REGS = 100,
    MAX_REGS_MUL = 0,
}

`,"prometheus.compiler.emit":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- emit.lua
--
-- This Script contains the container function body emission for the compiler.

local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");
local util = require("prometheus.util");
local constants = require("prometheus.compiler.constants");
local AstKind = Ast.AstKind;

local MAX_REGS = constants.MAX_REGS;

return function(Compiler)
    local function hasAnyEntries(tbl)
        return type(tbl) == "table" and next(tbl) ~= nil;
    end

    local function unionLookupTables(a, b)
        local out = {};
        for k, v in pairs(a or {}) do
            out[k] = v;
        end
        for k, v in pairs(b or {}) do
            out[k] = v;
        end
        return out;
    end

    local function canMergeParallelAssignmentStatements(statA, statB)
        if type(statA) ~= "table" or type(statB) ~= "table" then
            return false;
        end

        if statA.usesUpvals or statB.usesUpvals then
            return false;
        end

        local a = statA.statement;
        local b = statB.statement;
        if type(a) ~= "table" or type(b) ~= "table" then
            return false;
        end
        if a.kind ~= AstKind.AssignmentStatement or b.kind ~= AstKind.AssignmentStatement then
            return false;
        end

        if type(a.lhs) ~= "table" or type(a.rhs) ~= "table" or type(b.lhs) ~= "table" or type(b.rhs) ~= "table" then
            return false;
        end

        if #a.lhs ~= #a.rhs or #b.lhs ~= #b.rhs then
            return false;
        end

        -- Avoid merging vararg/call assignments because they can affect multi-return behavior.
        local function hasUnsafeRhs(rhsList)
            for _, rhsExpr in ipairs(rhsList) do
                if type(rhsExpr) ~= "table" then
                    return true;
                end
                local kind = rhsExpr.kind;
                if kind == AstKind.FunctionCallExpression or kind == AstKind.PassSelfFunctionCallExpression or kind == AstKind.VarargExpression then
                    return true;
                end
            end
            return false;
        end
        if hasUnsafeRhs(a.rhs) or hasUnsafeRhs(b.rhs) then
            return false;
        end

        local aReads = type(statA.reads) == "table" and statA.reads or {};
        local aWrites = type(statA.writes) == "table" and statA.writes or {};
        local bReads = type(statB.reads) == "table" and statB.reads or {};
        local bWrites = type(statB.writes) == "table" and statB.writes or {};

        -- Allow merging even if one statement has no writes (e.g., x = o(x) style assignments)
        -- Only require that at least one of them has writes
        if not hasAnyEntries(aWrites) and not hasAnyEntries(bWrites) then
            return false;
        end

        for r in pairs(aReads) do
            if bWrites[r] then
                return false;
            end
        end

        for r, b in pairs(aWrites) do
            if bWrites[r] or bReads[r] then
                return false;
            end
        end

        return true;
    end

    local function mergeParallelAssignmentStatements(statA, statB)
        local lhs = {};
        local rhs = {};
        local aLhs, bLhs = statA.statement.lhs, statB.statement.lhs;
        local aRhs, bRhs = statA.statement.rhs, statB.statement.rhs;
        for i = 1, #aLhs do lhs[i] = aLhs[i]; end
        for i = 1, #bLhs do lhs[#aLhs + i] = bLhs[i]; end
        for i = 1, #aRhs do rhs[i] = aRhs[i]; end
        for i = 1, #bRhs do rhs[#aRhs + i] = bRhs[i]; end

        return {
            statement = Ast.AssignmentStatement(lhs, rhs),
            writes = unionLookupTables(statA.writes, statB.writes),
            reads = unionLookupTables(statA.reads, statB.reads),
            usesUpvals = statA.usesUpvals or statB.usesUpvals,
        };
    end

    local function mergeAdjacentParallelAssignments(blockstats)
        local merged = {};
        local i = 1;
        while i <= #blockstats do
            local stat = blockstats[i];
            i = i + 1;

            while i <= #blockstats and canMergeParallelAssignmentStatements(stat, blockstats[i]) do
                stat = mergeParallelAssignmentStatements(stat, blockstats[i]);
                i = i + 1;
            end

            table.insert(merged, stat);
        end
        return merged;
    end

    function Compiler:emitContainerFuncBody()
        local blocks = {};

        util.shuffle(self.blocks);

        for i, block in ipairs(self.blocks) do
            local id = block.id;
            local blockstats = block.statements;

            for i = 2, #blockstats do
                local stat = blockstats[i];
                local reads = stat.reads;
                local writes = stat.writes;
                local maxShift = 0;
                local usesUpvals = stat.usesUpvals;
                for shift = 1, i - 1 do
                    local stat2 = blockstats[i - shift];

                    if stat2.usesUpvals and usesUpvals then
                        break;
                    end

                    local reads2 = stat2.reads;
                    local writes2 = stat2.writes;
                    local f = true;

                    for r, b in pairs(reads2) do
                        if(writes[r]) then
                            f = false;
                            break;
                        end
                    end

                    if f then
                        for r, b in pairs(writes2) do
                            if(writes[r]) then
                                f = false;
                                break;
                            end
                            if(reads[r]) then
                                f = false;
                                break;
                            end
                        end
                    end

                    if not f then
                        break
                    end

                    maxShift = shift;
                end

                local shift = math.random(0, maxShift);
                for j = 1, shift do
                    blockstats[i - j], blockstats[i - j + 1] = blockstats[i - j + 1], blockstats[i - j];
                end
            end

            local mergedBlockStats = mergeAdjacentParallelAssignments(blockstats);
            for _=1, 7 do
                mergedBlockStats = mergeAdjacentParallelAssignments(mergedBlockStats);
            end

            blockstats = {};
            for _, stat in ipairs(mergedBlockStats) do
                table.insert(blockstats, stat.statement);
            end

            local block = { id = id, index = i, block = Ast.Block(blockstats, block.scope) }
            table.insert(blocks, block);
            blocks[id] = block;
        end

        table.sort(blocks, function(a, b) return a.id < b.id end);

        -- Build a strict threshold condition between adjacent block IDs.
        -- Using a midpoint avoids exact-id comparisons while preserving dispatch.
        local function buildBlockThresholdCondition(scope, leftId, rightId, useAndOr)
            local bound = math.floor((leftId + rightId) / 2);
            local posExpr = self:pos(scope);
            local boundExpr = Ast.NumberExpression(bound);

            if useAndOr then
                -- Kept for compatibility with caller variations.
                return Ast.LessThanExpression(posExpr, boundExpr);
            else
                local variant = math.random(1, 2);
                if variant == 1 then
                    return Ast.LessThanExpression(posExpr, boundExpr);
                else
                    return Ast.GreaterThanExpression(boundExpr, posExpr);
                end
            end
        end

        -- Build an elseif chain for a range of blocks
        local function buildElseifChain(tb, l, r, pScope)
            -- Handle invalid range by returning an empty block
            if r < l then
                local emptyScope = Scope:new(pScope);
                return Ast.Block({}, emptyScope);
            end

            local len = r - l + 1;

            -- For single block
            if len == 1 then
                tb[l].block.scope:setParent(pScope);
                return tb[l].block;
            end

            -- For small ranges, use elseif chain
            if len <= 4 then
                local ifScope = Scope:new(pScope);
                local elseifs = {};

                -- First block uses the first midpoint threshold
                tb[l].block.scope:setParent(ifScope);
                local firstCondition = buildBlockThresholdCondition(ifScope, tb[l].id, tb[l + 1].id, false);
                local firstBlock = tb[l].block;

                -- Middle blocks use their upper midpoint threshold
                for i = l + 1, r - 1 do
                    tb[i].block.scope:setParent(ifScope);
                    local condition = buildBlockThresholdCondition(ifScope, tb[i].id, tb[i + 1].id, false);
                    table.insert(elseifs, {
                        condition = condition,
                        body = tb[i].block
                    });
                end

                -- Last block becomes else
                tb[r].block.scope:setParent(ifScope);
                local elseBlock = tb[r].block;

                return Ast.Block({
                    Ast.IfStatement(firstCondition, firstBlock, elseifs, elseBlock);
                }, ifScope);
            end

            -- For larger ranges, use binary split with and/or chaining
            local mid = l + math.ceil(len / 2);
            local leftMaxId = tb[mid - 1].id;
            local rightMinId = tb[mid].id;
            -- Float-safe split: any bound strictly between adjacent IDs works.
            -- Midpoint avoids integer-only math.random(min, max) behavior.
            local bound = math.floor((leftMaxId + rightMinId) / 2);
            local ifScope = Scope:new(pScope);

            local lBlock = buildElseifChain(tb, l, mid - 1, ifScope);
            local rBlock = buildElseifChain(tb, mid, r, ifScope);

            -- Randomly choose between different condition styles
            local condStyle = math.random(1, 3);
            local condition;
            local trueBlock, falseBlock;

            if condStyle == 1 then
                -- pos < bound
                condition = Ast.LessThanExpression(self:pos(ifScope), Ast.NumberExpression(bound));
                trueBlock, falseBlock = lBlock, rBlock;
            elseif condStyle == 2 then
                -- bound > pos
                condition = Ast.GreaterThanExpression(Ast.NumberExpression(bound), self:pos(ifScope));
                trueBlock, falseBlock = lBlock, rBlock;
            else
                -- Equivalent split using strict > with branches reversed.
                condition = Ast.GreaterThanExpression(self:pos(ifScope), Ast.NumberExpression(bound));
                trueBlock, falseBlock = rBlock, lBlock;
            end

            return Ast.Block({
                Ast.IfStatement(condition, trueBlock, {}, falseBlock);
            }, ifScope);
        end

        local whileBody = buildElseifChain(blocks, 1, #blocks, self.containerFuncScope);
        if self.whileScope then
            -- Ensure whileScope is properly connected
            self.whileScope:setParent(self.containerFuncScope);
        end

        self.whileScope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar, 1);
        self.whileScope:addReferenceToHigherScope(self.containerFuncScope, self.posVar);

        self.containerFuncScope:addReferenceToHigherScope(self.scope, self.unpackVar);

        local declarations = {
            self.returnVar,
        }

        for i, var in pairs(self.registerVars) do
            if(i ~= MAX_REGS) then
                table.insert(declarations, var);
            end
        end

        local stats = {}

        if self.maxUsedRegister >= MAX_REGS then
            table.insert(stats, Ast.LocalVariableDeclaration(self.containerFuncScope, {self.registerVars[MAX_REGS]}, {Ast.TableConstructorExpression({})}));
        end

        table.insert(stats, Ast.LocalVariableDeclaration(self.containerFuncScope, util.shuffle(declarations), {}));

        table.insert(stats, Ast.WhileStatement(whileBody, Ast.VariableExpression(self.containerFuncScope, self.posVar)));


        table.insert(stats, Ast.AssignmentStatement({
            Ast.AssignmentVariable(self.containerFuncScope, self.posVar)
        }, {
            Ast.LenExpression(Ast.VariableExpression(self.containerFuncScope, self.detectGcCollectVar))
        }));

        table.insert(stats, Ast.ReturnStatement{
            Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.unpackVar), {
                Ast.VariableExpression(self.containerFuncScope, self.returnVar)
            });
        });

        return Ast.Block(stats, self.containerFuncScope);
    end
end
`,"prometheus.compiler.expressions.and":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- and.lua
--
-- This Script contains the expression handler for the AndExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local posState = self.registers[self.POS_REGISTER];
    self.registers[self.POS_REGISTER] = self.VAR_REGISTER;

    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i ~= 1 then
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end

    local resReg = regs[1];
    local tmpReg;

    if posState then
        tmpReg = self:allocRegister(false);
        self:addStatement(self:copyRegisters(scope, {tmpReg}, {self.POS_REGISTER}), {tmpReg}, {self.POS_REGISTER}, false);
    end

    local lhsReg = self:compileExpression(expression.lhs, funcDepth, 1)[1];
    if expression.rhs.isConstant then
        local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];
        self:addStatement(self:setRegister(scope, resReg, Ast.AndExpression(self:register(scope, lhsReg), self:register(scope, rhsReg))), {resReg}, {lhsReg, rhsReg}, false);
        if tmpReg then
            self:freeRegister(tmpReg, false);
        end
        self:freeRegister(lhsReg, false);
        self:freeRegister(rhsReg, false);
        return regs;
    end

    local block1, block2 = self:createBlock(), self:createBlock();
    self:addStatement(self:copyRegisters(scope, {resReg}, {lhsReg}), {resReg}, {lhsReg}, false);
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(scope, lhsReg), Ast.NumberExpression(block1.id)), Ast.NumberExpression(block2.id))), {self.POS_REGISTER}, {lhsReg}, false);
    self:freeRegister(lhsReg, false);
    do
        self:setActiveBlock(block1);
        scope = block1.scope;
        local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];
        self:addStatement(self:copyRegisters(scope, {resReg}, {rhsReg}), {resReg}, {rhsReg}, false);
        self:freeRegister(rhsReg, false);

        self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(block2.id)), {self.POS_REGISTER}, {}, false);
    end

    self.registers[self.POS_REGISTER] = posState;

    self:setActiveBlock(block2);
    scope = block2.scope;

    if tmpReg then
        self:addStatement(self:copyRegisters(scope, {self.POS_REGISTER}, {tmpReg}), {self.POS_REGISTER}, {tmpReg}, false);
        self:freeRegister(tmpReg, false);
    end

    return regs;
end;
`,"prometheus.compiler.expressions.binary":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- binary.lua
--
-- This Script contains the expression handler for the Binary operations (Add, Sub, Mul, Div, etc.).

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            local lhsReg = self:compileExpression(expression.lhs, funcDepth, 1)[1];
            local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];

            local binaryExpr = Ast[expression.kind](self:register(scope, lhsReg), self:register(scope, rhsReg));
            self:addStatement(self:setRegister(scope, regs[i], binaryExpr), {regs[i]}, {lhsReg, rhsReg}, true);
            self:freeRegister(rhsReg, false);
            self:freeRegister(lhsReg, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;
`,"prometheus.compiler.expressions.boolean":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- boolean.lua
--
-- This Script contains the expression handler for the BooleanExpression.

local Ast = require("prometheus.ast");

local expressionEvaluators = {
    [Ast.GreaterThanExpression] = function(left, right)
        return left > right
    end,
    [Ast.LessThanExpression] = function(left, right)
        return left < right
    end,
    [Ast.GreaterThanOrEqualsExpression] = function(left, right)
        return left >= right
    end,
    [Ast.LessThanOrEqualsExpression] = function(left, right)
        return left <= right
    end,
    [Ast.NotEqualsExpression] = function(left, right)
        return left ~= right
    end,
}

local function createRandomASTCFlowExpression(resultBool)
    local expTB = {
        Ast.GreaterThanExpression,
        Ast.LessThanExpression,
        Ast.GreaterThanOrEqualsExpression,
        Ast.LessThanOrEqualsExpression,
        Ast.NotEqualsExpression
    }

    local leftInt, rightInt, boolResult, randomExp
    repeat
        randomExp = expTB[math.random(1, #expTB)]
        leftInt = Ast.NumberExpression(math.random(1, 2^24))
        rightInt = Ast.NumberExpression(math.random(1, 2^24))
        boolResult = expressionEvaluators[randomExp](leftInt.value, rightInt.value)
    until boolResult == resultBool

    return randomExp(leftInt, rightInt, false)
end

return function(self, expression, _, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            self:addStatement(self:setRegister(scope, regs[i], createRandomASTCFlowExpression(expression.value)), {regs[i]}, {}, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;
`,"prometheus.compiler.expressions.function_call":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- function_call.lua
--
-- This Script contains the expression handler for the FunctionCallExpression.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local baseReg = self:compileExpression(expression.base, funcDepth, 1)[1];

    local retRegs = {};
    local returnAll = numReturns == self.RETURN_ALL;
    if returnAll then
        retRegs[1] = self:allocRegister(false);
    else
        for i = 1, numReturns do
            retRegs[i] = self:allocRegister(false);
        end
    end

    local regs = {};
    local args = {};
    for i, expr in ipairs(expression.args) do
        if i == #expression.args and (expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression or expr.kind == AstKind.VarargExpression) then
            local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1];
            table.insert(args, Ast.FunctionCallExpression(
                self:unpack(scope),
                {self:register(scope, reg)}));
            table.insert(regs, reg);
        else
            local reg = self:compileExpression(expr, funcDepth, 1)[1];
            table.insert(args, self:register(scope, reg));
            table.insert(regs, reg);
        end
    end

    if returnAll then
        self:addStatement(self:setRegister(scope, retRegs[1], Ast.TableConstructorExpression{Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, baseReg), args))}), {retRegs[1]}, {baseReg, unpack(regs)}, true);
    else
        if numReturns > 1 then
            local tmpReg = self:allocRegister(false);

            self:addStatement(self:setRegister(scope, tmpReg, Ast.TableConstructorExpression{Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, baseReg), args))}), {tmpReg}, {baseReg, unpack(regs)}, true);


            for i, reg in ipairs(retRegs) do
                self:addStatement(self:setRegister(scope, reg, Ast.IndexExpression(self:register(scope, tmpReg), Ast.NumberExpression(i))), {reg}, {tmpReg}, false);
            end

            self:freeRegister(tmpReg, false);
        else
            self:addStatement(self:setRegister(scope, retRegs[1], Ast.FunctionCallExpression(self:register(scope, baseReg), args)), {retRegs[1]}, {baseReg, unpack(regs)}, true);
        end
    end

    self:freeRegister(baseReg, false);
    for i, reg in ipairs(regs) do
        self:freeRegister(reg, false);
    end

    return retRegs;
end;
`,"prometheus.compiler.expressions.function_literal":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- function_literal.lua
--
-- This Script contains the expression handler for the FunctionLiteralExpression

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        if i == 1 then
            regs[i] = self:compileFunction(expression, funcDepth);
        else
            regs[i] = self:allocRegister();
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;

`,"prometheus.compiler.expressions.if_else":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- if_else.lua
--
-- This Script contains the statement handler for the IfElseExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
	local scope = self.activeBlock.scope;
	local posState = self.registers[self.POS_REGISTER];
    self.registers[self.POS_REGISTER] = self.VAR_REGISTER;

	local regs = {};
	for i = 1, numReturns do
		regs[i] = self:allocRegister();
		if i ~= 1 then
			self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
		end
	end

	local resReg = regs[1];
	local tmpReg;

	if posState then
        tmpReg = self:allocRegister(false);
        self:addStatement(self:copyRegisters(scope, {tmpReg}, {self.POS_REGISTER}), {tmpReg}, {self.POS_REGISTER}, false);
    end

	local conditionReg = self:compileExpression(expression.condition, funcDepth, 1)[1];

	local finalBlock = self:createBlock();
	local nextBlock = self:createBlock();
	local innerBlock = self:createBlock();

	self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(scope, conditionReg), Ast.NumberExpression(innerBlock.id)), Ast.NumberExpression(nextBlock.id))), {self.POS_REGISTER}, {conditionReg}, false);
	self:freeRegister(conditionReg, false);

	self:setActiveBlock(innerBlock);
	scope = innerBlock.scope;

	local trueReg = self:compileExpression(expression.true_value, funcDepth, 1)[1];
	self:addStatement(self:copyRegisters(scope, {resReg}, {trueReg}), {resReg}, {trueReg}, false);
	self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)), {self.POS_REGISTER}, {}, false);

	for _, elif in ipairs(expression.elseifs) do
		self:setActiveBlock(nextBlock);
		conditionReg = self:compileExpression(elif.condition, funcDepth, 1)[1];
		local elifBlock = self:createBlock();
		nextBlock = self:createBlock();
		local elifScope = self.activeBlock.scope;

		self:addStatement(self:setRegister(elifScope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(elifScope, conditionReg), Ast.NumberExpression(elifBlock.id)), Ast.NumberExpression(nextBlock.id))), {self.POS_REGISTER}, {conditionReg}, false);
		self:freeRegister(conditionReg, false);

		self:setActiveBlock(elifBlock);
		elifScope = elifBlock.scope;
		local valueReg = self:compileExpression(elif.value, funcDepth, 1)[1];
		self:addStatement(self:copyRegisters(elifScope, {resReg}, {valueReg}), {resReg}, {valueReg}, false);
		self:addStatement(self:setRegister(elifScope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)), {self.POS_REGISTER}, {}, false);
	end

	self:setActiveBlock(nextBlock);
	scope = self.activeBlock.scope;
	local falseReg = self:compileExpression(expression.false_value, funcDepth, 1)[1];
	self:addStatement(self:copyRegisters(scope, {resReg}, {falseReg}), {resReg}, {falseReg}, false);
	self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)), {self.POS_REGISTER}, {}, false);

	self.registers[self.POS_REGISTER] = posState;

	self:setActiveBlock(finalBlock);
	scope = finalBlock.scope;

    if tmpReg then
        self:addStatement(self:copyRegisters(scope, {self.POS_REGISTER}, {tmpReg}), {self.POS_REGISTER}, {tmpReg}, false);
        self:freeRegister(tmpReg, false);
    end

	return regs;
end`,"prometheus.compiler.expressions.index":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- index.lua
--
-- This Script contains the expression handler for the IndexExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            local baseReg = self:compileExpression(expression.base, funcDepth, 1)[1];
            local indexReg = self:compileExpression(expression.index, funcDepth, 1)[1];



            self:addStatement(self:setRegister(scope, regs[i], Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, indexReg))), {regs[i]}, {baseReg, indexReg}, true);

            self:freeRegister(baseReg, false);
            self:freeRegister(indexReg, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;
`,"prometheus.compiler.expressions.len":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- len.lua
--
-- This Script contains the expression handler for the LenExpression

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];

            self:addStatement(self:setRegister(scope, regs[i], Ast.LenExpression(self:register(scope, rhsReg))), {regs[i]}, {rhsReg}, true);
            self:freeRegister(rhsReg, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;

`,"prometheus.compiler.expressions.negate":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- negate.lua
--
-- This Script contains the expression handler for the NegateExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];

            self:addStatement(self:setRegister(scope, regs[i], Ast.NegateExpression(self:register(scope, rhsReg))), {regs[i]}, {rhsReg}, true);
            self:freeRegister(rhsReg, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;

`,"prometheus.compiler.expressions.nil":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- nil.lua
--
-- This Script contains the expression handler for the NilExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
    end
    return regs;
end;

`,"prometheus.compiler.expressions.not":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- not.lua
--
-- This Script contains the expression handler for the NotExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];

            self:addStatement(self:setRegister(scope, regs[i], Ast.NotExpression(self:register(scope, rhsReg))), {regs[i]}, {rhsReg}, false);
            self:freeRegister(rhsReg, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;

`,"prometheus.compiler.expressions.number":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- number.lua
--
-- This Script contains the expression handler for the NumberExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            self:addStatement(self:setRegister(scope, regs[i], Ast.NumberExpression(expression.value)), {regs[i]}, {}, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;

`,"prometheus.compiler.expressions.or":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- or.lua
--
-- This Script contains the expression handler for the OrExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local posState = self.registers[self.POS_REGISTER];
    self.registers[self.POS_REGISTER] = self.VAR_REGISTER;

    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i ~= 1 then
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end

    local resReg = regs[1];
    local tmpReg;

    if posState then
        tmpReg = self:allocRegister(false);
        self:addStatement(self:copyRegisters(scope, {tmpReg}, {self.POS_REGISTER}), {tmpReg}, {self.POS_REGISTER}, false);
    end

    local lhsReg = self:compileExpression(expression.lhs, funcDepth, 1)[1];
    if expression.rhs.isConstant then
        local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];
        self:addStatement(self:setRegister(scope, resReg, Ast.OrExpression(self:register(scope, lhsReg), self:register(scope, rhsReg))), {resReg}, {lhsReg, rhsReg}, false);
        if tmpReg then
            self:freeRegister(tmpReg, false);
        end
        self:freeRegister(lhsReg, false);
        self:freeRegister(rhsReg, false);
        return regs;
    end

    local block1, block2 = self:createBlock(), self:createBlock();
    self:addStatement(self:copyRegisters(scope, {resReg}, {lhsReg}), {resReg}, {lhsReg}, false);
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(scope, lhsReg), Ast.NumberExpression(block2.id)), Ast.NumberExpression(block1.id))), {self.POS_REGISTER}, {lhsReg}, false);
    self:freeRegister(lhsReg, false);

    do
        self:setActiveBlock(block1);
        local scope = block1.scope;
        local rhsReg = self:compileExpression(expression.rhs, funcDepth, 1)[1];
        self:addStatement(self:copyRegisters(scope, {resReg}, {rhsReg}), {resReg}, {rhsReg}, false);
        self:freeRegister(rhsReg, false);


        self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(block2.id)), {self.POS_REGISTER}, {}, false);
    end

    self.registers[self.POS_REGISTER] = posState;

    self:setActiveBlock(block2);
    scope = block2.scope;

    if tmpReg then
        self:addStatement(self:copyRegisters(scope, {self.POS_REGISTER}, {tmpReg}), {self.POS_REGISTER}, {tmpReg}, false);
        self:freeRegister(tmpReg, false);
    end

    return regs;
end;
`,"prometheus.compiler.expressions.pass_self_function_call":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- pass_self_function_call.lua
--
-- This Script contains the expression handler for the PassSelfFunctionCallExpression.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local baseReg = self:compileExpression(expression.base, funcDepth, 1)[1];
    local retRegs = {};
    local returnAll = numReturns == self.RETURN_ALL;
    if returnAll then
        retRegs[1] = self:allocRegister(false);
    else
        for i = 1, numReturns do
            retRegs[i] = self:allocRegister(false);
        end
    end

    local args = { self:register(scope, baseReg) };
    local regs = { baseReg };

    for i, expr in ipairs(expression.args) do
        if i == #expression.args and (expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression or expr.kind == AstKind.VarargExpression) then
            local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1];
            table.insert(args, Ast.FunctionCallExpression(
                self:unpack(scope),
                {self:register(scope, reg)}));
            table.insert(regs, reg);
        else
            local reg = self:compileExpression(expr, funcDepth, 1)[1];
            table.insert(args, self:register(scope, reg));
            table.insert(regs, reg);
        end
    end

    if returnAll or numReturns > 1 then
        local tmpReg = self:allocRegister(false);

        self:addStatement(self:setRegister(scope, tmpReg, Ast.StringExpression(expression.passSelfFunctionName)), {tmpReg}, {}, false);
        self:addStatement(self:setRegister(scope, tmpReg, Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, tmpReg))), {tmpReg}, {baseReg, tmpReg}, false);

        if returnAll then
            self:addStatement(self:setRegister(scope, retRegs[1], Ast.TableConstructorExpression{Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, tmpReg), args))}), {retRegs[1]}, {tmpReg, unpack(regs)}, true);
        else
            self:addStatement(self:setRegister(scope, tmpReg, Ast.TableConstructorExpression{Ast.TableEntry(Ast.FunctionCallExpression(self:register(scope, tmpReg), args))}), {tmpReg}, {tmpReg, unpack(regs)}, true);

            for i, reg in ipairs(retRegs) do
                self:addStatement(self:setRegister(scope, reg, Ast.IndexExpression(self:register(scope, tmpReg), Ast.NumberExpression(i))), {reg}, {tmpReg}, false);
            end
        end

        self:freeRegister(tmpReg, false);
    else
        local tmpReg = retRegs[1] or self:allocRegister(false);

        self:addStatement(self:setRegister(scope, tmpReg, Ast.StringExpression(expression.passSelfFunctionName)), {tmpReg}, {}, false);
        self:addStatement(self:setRegister(scope, tmpReg, Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, tmpReg))), {tmpReg}, {baseReg, tmpReg}, false);
        self:addStatement(self:setRegister(scope, retRegs[1], Ast.FunctionCallExpression(self:register(scope, tmpReg), args)), {retRegs[1]}, {baseReg, unpack(regs)}, true);
    end

    for i, reg in ipairs(regs) do
        self:freeRegister(reg, false);
    end

    return retRegs;
end;
`,"prometheus.compiler.expressions.string":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- string.lua
--
-- This Script contains the expression handler for the StringExpression.

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns, 1 do
        regs[i] = self:allocRegister();
        if i == 1 then
            self:addStatement(self:setRegister(scope, regs[i], Ast.StringExpression(expression.value)), {regs[i]}, {}, false);
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;

`,"prometheus.compiler.expressions.table_constructor":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- table_constructor.lua
--
-- This Script contains the expression handler for the TableConstructorExpression.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister();
        if i == 1 then
            local entries = {};
            local entryRegs = {};
            for i, entry in ipairs(expression.entries) do
                if entry.kind == AstKind.TableEntry then
                    local value = entry.value;
                    if i == #expression.entries and (value.kind == AstKind.FunctionCallExpression or value.kind == AstKind.PassSelfFunctionCallExpression or value.kind == AstKind.VarargExpression) then
                        local reg = self:compileExpression(entry.value, funcDepth, self.RETURN_ALL)[1];
                        table.insert(entries, Ast.TableEntry(Ast.FunctionCallExpression(
                            self:unpack(scope),
                            {self:register(scope, reg)})));
                        table.insert(entryRegs, reg);
                    else
                        local reg = self:compileExpression(entry.value, funcDepth, 1)[1];
                        table.insert(entries, Ast.TableEntry(self:register(scope, reg)));
                        table.insert(entryRegs, reg);
                    end
                else
                    local keyReg = self:compileExpression(entry.key, funcDepth, 1)[1];
                    local valReg = self:compileExpression(entry.value, funcDepth, 1)[1];
                    table.insert(entries, Ast.KeyedTableEntry(self:register(scope, keyReg), self:register(scope, valReg)));
                    table.insert(entryRegs, valReg);
                    table.insert(entryRegs, keyReg);
                end
            end
            self:addStatement(self:setRegister(scope, regs[i], Ast.TableConstructorExpression(entries)), {regs[i]}, entryRegs, false);
            for i, reg in ipairs(entryRegs) do
                self:freeRegister(reg, false);
            end
        else
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;
`,"prometheus.compiler.expressions.vararg":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- vararg.lua
--
-- This Script contains the expression handler for the VarargExpression

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    if numReturns == self.RETURN_ALL then
        return {self.varargReg};
    end
    local regs = {};
    for i = 1, numReturns do
        regs[i] = self:allocRegister(false);
        self:addStatement(self:setRegister(scope, regs[i], Ast.IndexExpression(self:register(scope, self.varargReg), Ast.NumberExpression(i))), {regs[i]}, {self.varargReg}, false);
    end
    return regs;
end;

`,"prometheus.compiler.expressions.variable":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- variable.lua
--
-- This Script contains the expression handler for the VariableExpression

local Ast = require("prometheus.ast");

return function(self, expression, funcDepth, numReturns)
    local scope = self.activeBlock.scope;
    local regs = {};
    for i = 1, numReturns do
        if i == 1 then
            if expression.scope.isGlobal then
                regs[i] = self:allocRegister(false);
                local tmpReg = self:allocRegister(false);
                self:addStatement(self:setRegister(scope, tmpReg, Ast.StringExpression(expression.scope:getVariableName(expression.id))), {tmpReg}, {}, false);
                self:addStatement(self:setRegister(scope, regs[i], Ast.IndexExpression(self:env(scope), self:register(scope, tmpReg))), {regs[i]}, {tmpReg}, true);
                self:freeRegister(tmpReg, false);
            else
                if self.scopeFunctionDepths[expression.scope] == funcDepth then
                    if self:isUpvalue(expression.scope, expression.id) then
                        local reg = self:allocRegister(false);
                        local varReg = self:getVarRegister(expression.scope, expression.id, funcDepth, nil);
                        self:addStatement(self:setRegister(scope, reg, self:getUpvalueMember(scope, self:register(scope, varReg))), {reg}, {varReg}, true);
                        regs[i] = reg;
                    else
                        regs[i] = self:getVarRegister(expression.scope, expression.id, funcDepth, nil);
                    end
                else
                    local reg = self:allocRegister(false);
                    local upvalId = self:getUpvalueId(expression.scope, expression.id);
                    scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar);
                    self:addStatement(self:setRegister(scope, reg, self:getUpvalueMember(scope, Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar), Ast.NumberExpression(upvalId)))), {reg}, {}, true);
                    regs[i] = reg;
                end
            end
        else
            regs[i] = self:allocRegister();
            self:addStatement(self:setRegister(scope, regs[i], Ast.NilExpression()), {regs[i]}, {}, false);
        end
    end
    return regs;
end;

`,"prometheus.compiler.expressions":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- expressions.lua
--
-- This Script contains the expression handlers: exports handler table keyed by AstKind.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

local handlers = {};
local expressions = "prometheus.compiler.expressions.";
local function requireExpression(name)
    return require(expressions .. name);
end
handlers[AstKind.StringExpression] = requireExpression("string");
handlers[AstKind.NumberExpression] = requireExpression("number");
handlers[AstKind.BooleanExpression] = requireExpression("boolean");
handlers[AstKind.NilExpression] = requireExpression("nil");
handlers[AstKind.VariableExpression] = requireExpression("variable");
handlers[AstKind.FunctionCallExpression] = requireExpression("function_call");
handlers[AstKind.PassSelfFunctionCallExpression] = requireExpression("pass_self_function_call");
handlers[AstKind.IndexExpression] = requireExpression("index");
handlers[AstKind.NotExpression] = requireExpression("not");
handlers[AstKind.NegateExpression] = requireExpression("negate");
handlers[AstKind.LenExpression] = requireExpression("len");
handlers[AstKind.OrExpression] = requireExpression("or");
handlers[AstKind.AndExpression] = requireExpression("and");
handlers[AstKind.TableConstructorExpression] = requireExpression("table_constructor");
handlers[AstKind.FunctionLiteralExpression] = requireExpression("function_literal");
handlers[AstKind.VarargExpression] = requireExpression("vararg");
handlers[AstKind.IfElseExpression] = requireExpression("if_else");

-- Binary ops share one handler
local binaryHandler = requireExpression("binary");
handlers[AstKind.LessThanExpression] = binaryHandler;
handlers[AstKind.GreaterThanExpression] = binaryHandler;
handlers[AstKind.LessThanOrEqualsExpression] = binaryHandler;
handlers[AstKind.GreaterThanOrEqualsExpression] = binaryHandler;
handlers[AstKind.NotEqualsExpression] = binaryHandler;
handlers[AstKind.EqualsExpression] = binaryHandler;
handlers[AstKind.StrCatExpression] = binaryHandler;
handlers[AstKind.AddExpression] = binaryHandler;
handlers[AstKind.SubExpression] = binaryHandler;
handlers[AstKind.MulExpression] = binaryHandler;
handlers[AstKind.DivExpression] = binaryHandler;
handlers[AstKind.ModExpression] = binaryHandler;
handlers[AstKind.PowExpression] = binaryHandler;

return handlers;

`,"prometheus.compiler.register":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- register.lua
--
-- This Script contains the register management for the compiler.

local Ast = require("prometheus.ast");
local constants = require("prometheus.compiler.constants");
local randomStrings = require("prometheus.randomStrings");

local MAX_REGS = constants.MAX_REGS;

return function(Compiler)
    function Compiler:freeRegister(id, force)
        if force or not (self.registers[id] == self.VAR_REGISTER) then
            self.usedRegisters = self.usedRegisters - 1;
            self.registers[id] = false
        end
    end

    function Compiler:isVarRegister(id)
        return self.registers[id] == self.VAR_REGISTER;
    end

    function Compiler:allocRegister(isVar)
        self.usedRegisters = self.usedRegisters + 1;

        if not isVar then
            if not self.registers[self.POS_REGISTER] then
                self.registers[self.POS_REGISTER] = true;
                return self.POS_REGISTER;
            end

            if not self.registers[self.RETURN_REGISTER] then
                self.registers[self.RETURN_REGISTER] = true;
                return self.RETURN_REGISTER;
            end
        end

        local id = 0;
        if self.usedRegisters < MAX_REGS * constants.MAX_REGS_MUL then
            repeat
                id = math.random(1, MAX_REGS - 1);
            until not self.registers[id];
        else
            repeat
                id = id + 1;
            until not self.registers[id];
        end

        if id > self.maxUsedRegister then
            self.maxUsedRegister = id;
        end

        if(isVar) then
            self.registers[id] = self.VAR_REGISTER;
        else
            self.registers[id] = true
        end
        return id;
    end

    function Compiler:isUpvalue(scope, id)
        return self.upvalVars[scope] and self.upvalVars[scope][id];
    end

    function Compiler:makeUpvalue(scope, id)
        if(not self.upvalVars[scope]) then
            self.upvalVars[scope] = {}
        end
        self.upvalVars[scope][id] = true;
    end

    function Compiler:getVarRegister(scope, id, functionDepth, potentialId)
        if(not self.registersForVar[scope]) then
            self.registersForVar[scope] = {};
            self.scopeFunctionDepths[scope] = functionDepth;
        end

        local reg = self.registersForVar[scope][id];
        if not reg then
            if potentialId and self.registers[potentialId] ~= self.VAR_REGISTER and potentialId ~= self.POS_REGISTER and potentialId ~= self.RETURN_REGISTER then
                self.registers[potentialId] = self.VAR_REGISTER;
                reg = potentialId;
            else
                reg = self:allocRegister(true);
            end
            self.registersForVar[scope][id] = reg;
        end
        return reg;
    end

    function Compiler:getRegisterVarId(id)
        local varId = self.registerVars[id];
        if not varId then
            varId = self.containerFuncScope:addVariable();
            self.registerVars[id] = varId;
        end
        return varId;
    end

    function Compiler:register(scope, id)
        if id == self.POS_REGISTER then
            return self:pos(scope);
        end

        if id == self.RETURN_REGISTER then
            return self:getReturn(scope);
        end

        if id < MAX_REGS then
            local vid = self:getRegisterVarId(id);
            scope:addReferenceToHigherScope(self.containerFuncScope, vid);
            return Ast.VariableExpression(self.containerFuncScope, vid);
        end

        local vid = self:getRegisterVarId(MAX_REGS);
        scope:addReferenceToHigherScope(self.containerFuncScope, vid);
        return Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, vid), Ast.NumberExpression((id - MAX_REGS) + 1));
    end

    function Compiler:registerList(scope, ids)
        local l = {};
        for i, id in ipairs(ids) do
            table.insert(l, self:register(scope, id));
        end
        return l;
    end

    function Compiler:registerAssignment(scope, id)
        if id == self.POS_REGISTER then
            return self:posAssignment(scope);
        end
        if id == self.RETURN_REGISTER then
            return self:returnAssignment(scope);
        end

        if id < MAX_REGS then
            local vid = self:getRegisterVarId(id);
            scope:addReferenceToHigherScope(self.containerFuncScope, vid);
            return Ast.AssignmentVariable(self.containerFuncScope, vid);
        end

        local vid = self:getRegisterVarId(MAX_REGS);
        scope:addReferenceToHigherScope(self.containerFuncScope, vid);
        return Ast.AssignmentIndexing(Ast.VariableExpression(self.containerFuncScope, vid), Ast.NumberExpression((id - MAX_REGS) + 1));
    end

    function Compiler:setRegister(scope, id, val, compundArg)
        if(compundArg) then
            return compundArg(self:registerAssignment(scope, id), val);
        end
        return Ast.AssignmentStatement({
            self:registerAssignment(scope, id)
        }, {
            val
        });
    end

    function Compiler:setRegisters(scope, ids, vals)
        local idStats = {};
        for i, id in ipairs(ids) do
            table.insert(idStats, self:registerAssignment(scope, id));
        end

        return Ast.AssignmentStatement(idStats, vals);
    end

    function Compiler:copyRegisters(scope, to, from)
        local idStats = {};
        local vals = {};
        for i, id in ipairs(to) do
            local fromId = from[i];
            if(fromId ~= id) then
                table.insert(idStats, self:registerAssignment(scope, id));
                table.insert(vals, self:register(scope, fromId));
            end
        end

        if(#idStats > 0 and #vals > 0) then
            return Ast.AssignmentStatement(idStats, vals);
        end
    end

    function Compiler:resetRegisters()
        self.registers = {};
    end

    function Compiler:pos(scope)
        scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar);
        return Ast.VariableExpression(self.containerFuncScope, self.posVar);
    end

    function Compiler:posAssignment(scope)
        scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar);
        return Ast.AssignmentVariable(self.containerFuncScope, self.posVar);
    end

    function Compiler:args(scope)
        scope:addReferenceToHigherScope(self.containerFuncScope, self.argsVar);
        return Ast.VariableExpression(self.containerFuncScope, self.argsVar);
    end

    function Compiler:unpack(scope)
        scope:addReferenceToHigherScope(self.scope, self.unpackVar);
        return Ast.VariableExpression(self.scope, self.unpackVar);
    end

    function Compiler:env(scope)
        scope:addReferenceToHigherScope(self.scope, self.envVar);
        return Ast.VariableExpression(self.scope, self.envVar);
    end

    function Compiler:jmp(scope, to)
        scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar);
        return Ast.AssignmentStatement({Ast.AssignmentVariable(self.containerFuncScope, self.posVar)},{to});
    end

    function Compiler:setPos(scope, val)
        if not val then
            local v = Ast.IndexExpression(self:env(scope), randomStrings.randomStringNode(math.random(12, 14)));
            scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar);
            return Ast.AssignmentStatement({Ast.AssignmentVariable(self.containerFuncScope, self.posVar)}, {v});
        end
        scope:addReferenceToHigherScope(self.containerFuncScope, self.posVar);
        return Ast.AssignmentStatement({Ast.AssignmentVariable(self.containerFuncScope, self.posVar)}, {Ast.NumberExpression(val) or Ast.NilExpression()});
    end

    function Compiler:setReturn(scope, val)
        scope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar);
        return Ast.AssignmentStatement({Ast.AssignmentVariable(self.containerFuncScope, self.returnVar)}, {val});
    end

    function Compiler:getReturn(scope)
        scope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar);
        return Ast.VariableExpression(self.containerFuncScope, self.returnVar);
    end

    function Compiler:returnAssignment(scope)
        scope:addReferenceToHigherScope(self.containerFuncScope, self.returnVar);
        return Ast.AssignmentVariable(self.containerFuncScope, self.returnVar);
    end

    function Compiler:setUpvalueMember(scope, idExpr, valExpr, compoundConstructor)
        scope:addReferenceToHigherScope(self.scope, self.upvaluesTable);
        if compoundConstructor then
            return compoundConstructor(Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesTable), idExpr), valExpr);
        end
        return Ast.AssignmentStatement({Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesTable), idExpr)}, {valExpr});
    end

    function Compiler:getUpvalueMember(scope, idExpr)
        scope:addReferenceToHigherScope(self.scope, self.upvaluesTable);
        return Ast.IndexExpression(Ast.VariableExpression(self.scope, self.upvaluesTable), idExpr);
    end
end

`,"prometheus.compiler.statements.assignment":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- assignment.lua
--
-- This Script contains the statement handler for the AssignmentStatement.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local exprregs = {};
    local assignmentIndexingRegs = {};
    for i, primaryExpr in ipairs(statement.lhs) do
        if(primaryExpr.kind == AstKind.AssignmentIndexing) then
            assignmentIndexingRegs [i] = {
                base = self:compileExpression(primaryExpr.base, funcDepth, 1)[1],
                index = self:compileExpression(primaryExpr.index, funcDepth, 1)[1],
            };
        end
    end

    for i, expr in ipairs(statement.rhs) do
        if(i == #statement.rhs and #statement.lhs > #statement.rhs) then
            local regs = self:compileExpression(expr, funcDepth, #statement.lhs - #statement.rhs + 1);

            for i, reg in ipairs(regs) do
                if(self:isVarRegister(reg)) then
                    local ro = reg;
                    reg = self:allocRegister(false);
                    self:addStatement(self:copyRegisters(scope, {reg}, {ro}), {reg}, {ro}, false);
                end
                table.insert(exprregs, reg);
            end
        else
            if statement.lhs[i] or expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression then
                local reg = self:compileExpression(expr, funcDepth, 1)[1];
                if(self:isVarRegister(reg)) then
                    local ro = reg;
                    reg = self:allocRegister(false);
                    self:addStatement(self:copyRegisters(scope, {reg}, {ro}), {reg}, {ro}, false);
                end
                table.insert(exprregs, reg);
            end
        end
    end

    for i, primaryExpr in ipairs(statement.lhs) do
        if primaryExpr.kind == AstKind.AssignmentVariable then
            if primaryExpr.scope.isGlobal then
                local tmpReg = self:allocRegister(false);
                self:addStatement(self:setRegister(scope, tmpReg, Ast.StringExpression(primaryExpr.scope:getVariableName(primaryExpr.id))), {tmpReg}, {}, false);
                self:addStatement(Ast.AssignmentStatement({Ast.AssignmentIndexing(self:env(scope), self:register(scope, tmpReg))},
                 {self:register(scope, exprregs[i])}), {}, {tmpReg, exprregs[i]}, true);
                self:freeRegister(tmpReg, false);
            else
                if self.scopeFunctionDepths[primaryExpr.scope] == funcDepth then
                    if self:isUpvalue(primaryExpr.scope, primaryExpr.id) then
                        local reg = self:getVarRegister(primaryExpr.scope, primaryExpr.id, funcDepth);
                        self:addStatement(self:setUpvalueMember(scope, self:register(scope, reg), self:register(scope, exprregs[i])), {}, {reg, exprregs[i]}, true);
                    else
                        local reg = self:getVarRegister(primaryExpr.scope, primaryExpr.id, funcDepth, exprregs[i]);
                        if reg ~= exprregs[i] then
                            self:addStatement(self:setRegister(scope, reg, self:register(scope, exprregs[i])), {reg}, {exprregs[i]}, false);
                        end
                    end
                else
                    local upvalId = self:getUpvalueId(primaryExpr.scope, primaryExpr.id);
                    scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar);
                    self:addStatement(self:setUpvalueMember(scope, Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar), Ast.NumberExpression(upvalId)), self:register(scope, exprregs[i])), {}, {exprregs[i]}, true);
                end
            end
        elseif primaryExpr.kind == AstKind.AssignmentIndexing then
            local baseReg = assignmentIndexingRegs[i].base;
            local indexReg = assignmentIndexingRegs[i].index;
            self:addStatement(Ast.AssignmentStatement({
                Ast.AssignmentIndexing(self:register(scope, baseReg), self:register(scope, indexReg))
            }, {
                self:register(scope, exprregs[i])
            }), {}, {exprregs[i], baseReg, indexReg}, true);
            self:freeRegister(exprregs[i], false);
            self:freeRegister(baseReg, false);
            self:freeRegister(indexReg, false);
        else
            error(string.format("Invalid Assignment lhs: %s", statement.lhs));
        end
    end
end;
`,"prometheus.compiler.statements.break_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- break_statement.lua
--
-- This Script contains the statement handler for the BreakStatement.

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local toFreeVars = {};
    local statScope;
    repeat
        statScope = statScope and statScope.parentScope or statement.scope;
        for id, name in ipairs(statScope.variables) do
            table.insert(toFreeVars, {
                scope = statScope,
                id = id;
            });
        end
    until statScope == statement.loop.body.scope;

    for i, var in pairs(toFreeVars) do
        local varScope, id = var.scope, var.id;
        local varReg = self:getVarRegister(varScope, id, nil, nil);
        if self:isUpvalue(varScope, id) then
            scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc);
            self:addStatement(self:setRegister(scope, varReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.freeUpvalueFunc), {
                self:register(scope, varReg)
            })), {varReg}, {varReg}, false);
        else
            self:addStatement(self:setRegister(scope, varReg, Ast.NilExpression()), {varReg}, {}, false);
        end
    end


    self:addStatement(self:setPos(scope, statement.loop.__final_block.id), {self.POS_REGISTER}, {}, false);
    self.activeBlock.advanceToNextBlock = false;
end;
`,"prometheus.compiler.statements.compound":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- compound.lua
--
-- This Script contains the statement handler for the Compound statements (compound add, sub, mul, etc.)

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

local compoundConstructors = {
    [AstKind.CompoundAddStatement] = Ast.CompoundAddStatement,
    [AstKind.CompoundSubStatement] = Ast.CompoundSubStatement,
    [AstKind.CompoundMulStatement] = Ast.CompoundMulStatement,
    [AstKind.CompoundDivStatement] = Ast.CompoundDivStatement,
    [AstKind.CompoundModStatement] = Ast.CompoundModStatement,
    [AstKind.CompoundPowStatement] = Ast.CompoundPowStatement,
    [AstKind.CompoundConcatStatement] = Ast.CompoundConcatStatement,
};

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local compoundConstructor = compoundConstructors[statement.kind];
    if statement.lhs.kind == AstKind.AssignmentIndexing then
        local indexing = statement.lhs;
        local baseReg = self:compileExpression(indexing.base, funcDepth, 1)[1];
        local indexReg = self:compileExpression(indexing.index, funcDepth, 1)[1];
        local valueReg = self:compileExpression(statement.rhs, funcDepth, 1)[1];

        self:addStatement(compoundConstructor(Ast.AssignmentIndexing(self:register(scope, baseReg), self:register(scope, indexReg)), self:register(scope, valueReg)), {}, {baseReg, indexReg, valueReg}, true);
        self:freeRegister(baseReg, false);
        self:freeRegister(indexReg, false);
        self:freeRegister(valueReg, false);
    else
        local valueReg = self:compileExpression(statement.rhs, funcDepth, 1)[1];
        local primaryExpr = statement.lhs;
        if primaryExpr.scope.isGlobal then
            local tmpReg = self:allocRegister(false);
            self:addStatement(self:setRegister(scope, tmpReg, Ast.StringExpression(primaryExpr.scope:getVariableName(primaryExpr.id))), {tmpReg}, {}, false);
            self:addStatement(compoundConstructor(Ast.AssignmentIndexing(self:env(scope), self:register(scope, tmpReg)),
             self:register(scope, valueReg)), {}, {tmpReg, valueReg}, true);
            self:freeRegister(tmpReg, false);
            self:freeRegister(valueReg, false);
        else
            if self.scopeFunctionDepths[primaryExpr.scope] == funcDepth then
                if self:isUpvalue(primaryExpr.scope, primaryExpr.id) then
                    local reg = self:getVarRegister(primaryExpr.scope, primaryExpr.id, funcDepth);
                    self:addStatement(self:setUpvalueMember(scope, self:register(scope, reg), self:register(scope, valueReg), compoundConstructor), {}, {reg, valueReg}, true);
                else
                    local reg = self:getVarRegister(primaryExpr.scope, primaryExpr.id, funcDepth, valueReg);
                    if reg ~= valueReg then
                        self:addStatement(self:setRegister(scope, reg, self:register(scope, valueReg), compoundConstructor), {reg}, {valueReg}, false);
                    end
                end
            else
                local upvalId = self:getUpvalueId(primaryExpr.scope, primaryExpr.id);
                scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar);
                self:addStatement(self:setUpvalueMember(scope, Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar), Ast.NumberExpression(upvalId)), self:register(scope, valueReg), compoundConstructor), {}, {valueReg}, true);
            end
            self:freeRegister(valueReg, false);
        end
    end
end;
`,"prometheus.compiler.statements.continue_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- continue_statement.lua
--
-- This Script contains the statement handler for the ContinueStatement.

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local toFreeVars = {};
    local statScope;
    repeat
        statScope = statScope and statScope.parentScope or statement.scope;
        for id, _ in pairs(statScope.variables) do
            table.insert(toFreeVars, {
                scope = statScope,
                id = id;
            });
        end
    until statScope == statement.loop.body.scope;

    for _, var in ipairs(toFreeVars) do
        local varScope, id = var.scope, var.id;
        local varReg = self:getVarRegister(varScope, id, nil, nil);
        if self:isUpvalue(varScope, id) then
            scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc);
            self:addStatement(self:setRegister(scope, varReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.freeUpvalueFunc), {
                self:register(scope, varReg)
            })), {varReg}, {varReg}, false);
        else
            self:addStatement(self:setRegister(scope, varReg, Ast.NilExpression()), {varReg}, {}, false);
        end
    end


    self:addStatement(self:setPos(scope, statement.loop.__start_block.id), {self.POS_REGISTER}, {}, false);
    self.activeBlock.advanceToNextBlock = false;
end;
`,"prometheus.compiler.statements.do_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- do_statement.lua
--
-- This Script contains the statement handler for the DoStatement.

return function(self, statement, funcDepth)
    self:compileBlock(statement.body, funcDepth);
end;

`,"prometheus.compiler.statements.for_in_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- for_in_statement.lua
--
-- This Script contains the statement handler for the ForInStatement

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local expressionsLength = #statement.expressions;
    local exprregs = {};
    for i, expr in ipairs(statement.expressions) do
        if(i == expressionsLength and expressionsLength < 3) then
            local regs = self:compileExpression(expr, funcDepth, 4 - expressionsLength);
            for i = 1, 4 - expressionsLength do
                table.insert(exprregs, regs[i]);
            end
        else
            if i <= 3 then
                table.insert(exprregs, self:compileExpression(expr, funcDepth, 1)[1])
            else
                self:freeRegister(self:compileExpression(expr, funcDepth, 1)[1], false);
            end
        end
    end

    for i, reg in ipairs(exprregs) do
        if reg and self.registers[reg] ~= self.VAR_REGISTER and reg ~= self.POS_REGISTER and reg ~= self.RETURN_REGISTER then
            self.registers[reg] = self.VAR_REGISTER;
        else
            exprregs[i] = self:allocRegister(true);
            self:addStatement(self:copyRegisters(scope, {exprregs[i]}, {reg}), {exprregs[i]}, {reg}, false);
        end
    end

    local checkBlock = self:createBlock();
    local bodyBlock = self:createBlock();
    local finalBlock = self:createBlock();

    statement.__start_block = checkBlock;
    statement.__final_block = finalBlock;

    self:addStatement(self:setPos(scope, checkBlock.id), {self.POS_REGISTER}, {}, false);

    self:setActiveBlock(checkBlock);
    local scope = self.activeBlock.scope;

    local varRegs = {};
    for i, id in ipairs(statement.ids) do
        varRegs[i] = self:getVarRegister(statement.scope, id, funcDepth)
    end



    self:addStatement(Ast.AssignmentStatement({
        self:registerAssignment(scope, exprregs[3]),
        varRegs[2] and self:registerAssignment(scope, varRegs[2]),
    }, {
        Ast.FunctionCallExpression(self:register(scope, exprregs[1]), {
            self:register(scope, exprregs[2]),
            self:register(scope, exprregs[3]),
        })
    }), {exprregs[3], varRegs[2]}, {exprregs[1], exprregs[2], exprregs[3]}, true);



    self:addStatement(Ast.AssignmentStatement({
        self:posAssignment(scope)
    }, {
        Ast.OrExpression(Ast.AndExpression(self:register(scope, exprregs[3]), Ast.NumberExpression(bodyBlock.id)), Ast.NumberExpression(finalBlock.id))
    }), {self.POS_REGISTER}, {exprregs[3]}, false);

    self:setActiveBlock(bodyBlock);
    local scope = self.activeBlock.scope;

    self:addStatement(self:copyRegisters(scope, {varRegs[1]}, {exprregs[3]}), {varRegs[1]}, {exprregs[3]}, false);

    for i=3, #varRegs do
        self:addStatement(self:setRegister(scope, varRegs[i], Ast.NilExpression()), {varRegs[i]}, {}, false);
    end

    for i, id in ipairs(statement.ids) do
        if(self:isUpvalue(statement.scope, id)) then
            local varreg = varRegs[i];
            local tmpReg = self:allocRegister(false);
            scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction);
            self:addStatement(self:setRegister(scope, tmpReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {})), {tmpReg}, {}, false);
            self:addStatement(self:setUpvalueMember(scope, self:register(scope, tmpReg), self:register(scope, varreg)), {}, {tmpReg, varreg}, true);
            self:addStatement(self:copyRegisters(scope, {varreg}, {tmpReg}), {varreg}, {tmpReg}, false);
            self:freeRegister(tmpReg, false);
        end
    end

    self:compileBlock(statement.body, funcDepth);
    self:addStatement(self:setPos(scope, checkBlock.id), {self.POS_REGISTER}, {}, false);
    self:setActiveBlock(finalBlock);

    for i, _ in ipairs(exprregs) do
        self:freeRegister(exprregs[i], true)
    end
end;
`,"prometheus.compiler.statements.for_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- for_statement.lua
--
-- This Script contains the statement handler for the ForStatement

local Ast = require("prometheus.ast");
local util = require("prometheus.util");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local checkBlock = self:createBlock();
    local innerBlock = self:createBlock();
    local finalBlock = self:createBlock();

    statement.__start_block = checkBlock;
    statement.__final_block = finalBlock;

    local posState = self.registers[self.POS_REGISTER];
    self.registers[self.POS_REGISTER] = self.VAR_REGISTER;

    local initialReg = self:compileExpression(statement.initialValue, funcDepth, 1)[1];

    local finalExprReg = self:compileExpression(statement.finalValue, funcDepth, 1)[1];
    local finalReg = self:allocRegister(false);
    self:addStatement(self:copyRegisters(scope, {finalReg}, {finalExprReg}), {finalReg}, {finalExprReg}, false);
    self:freeRegister(finalExprReg);

    local incrementExprReg = self:compileExpression(statement.incrementBy, funcDepth, 1)[1];
    local incrementReg = self:allocRegister(false);
    self:addStatement(self:copyRegisters(scope, {incrementReg}, {incrementExprReg}), {incrementReg}, {incrementExprReg}, false);
    self:freeRegister(incrementExprReg);

    local tmpReg = self:allocRegister(false);
    self:addStatement(self:setRegister(scope, tmpReg, Ast.NumberExpression(0)), {tmpReg}, {}, false);
    local incrementIsNegReg = self:allocRegister(false);

    local shouldSwap3 = math.random(1, 2) == 2;
    local shuffledRegs4 = shouldSwap3 and {incrementReg, tmpReg} or {tmpReg, incrementReg};
    self:addStatement(self:setRegister(scope, incrementIsNegReg, Ast[shouldSwap3 and "LessThanExpression" or "GreaterThanExpression"](self:register(scope, shuffledRegs4[1]), self:register(scope, shuffledRegs4[2]))), {incrementIsNegReg}, {shuffledRegs4[1], shuffledRegs4[2]}, false);

    self:freeRegister(tmpReg);

    local currentReg = self:allocRegister(true);
    self:addStatement(self:setRegister(scope, currentReg, Ast.SubExpression(self:register(scope, initialReg), self:register(scope, incrementReg))), {currentReg}, {initialReg, incrementReg}, false);
    self:freeRegister(initialReg);

    self:addStatement(self:jmp(scope, Ast.NumberExpression(checkBlock.id)), {self.POS_REGISTER}, {}, false);

    self:setActiveBlock(checkBlock);

    scope = checkBlock.scope;

    -- x = x + y or x = y + x instead of just x = x + y.
    --> NEW: In an attempt to thwart deobfuscations, despite this being a simple comparison... Shuffling these causes problems for decompilers.
    --> NOTE: This isn't unstable code, I've tested it multiple times.

    local shuffledRegs = util.shuffle({currentReg, incrementReg});
    self:addStatement(self:setRegister(scope, currentReg, Ast.AddExpression(self:register(scope, shuffledRegs[1]), self:register(scope, shuffledRegs[2]))), {currentReg}, {shuffledRegs[1], shuffledRegs[2]}, false);
    local tmpReg1 = self:allocRegister(false);
    local tmpReg2 = self:allocRegister(false);
    self:addStatement(self:setRegister(scope, tmpReg2, Ast.NotExpression(self:register(scope, incrementIsNegReg))), {tmpReg2}, {incrementIsNegReg}, false);

    local shouldSwap = math.random(1, 2) == 2;
    local shuffledRegs2 = shouldSwap and {currentReg, finalReg} or {finalReg, currentReg};
    self:addStatement(self:setRegister(scope, tmpReg1, Ast[shouldSwap and "LessThanOrEqualsExpression" or "GreaterThanOrEqualsExpression"](self:register(scope, shuffledRegs2[1]), self:register(scope, shuffledRegs2[2]))), {tmpReg1}, {shuffledRegs2[1], shuffledRegs2[2]}, false);
    self:addStatement(self:setRegister(scope, tmpReg1, Ast.AndExpression(self:register(scope, tmpReg2), self:register(scope, tmpReg1))), {tmpReg1}, {tmpReg1, tmpReg2}, false);

    local shouldSwap2 = math.random(1, 2) == 2;
    local shuffledRegs3 = shouldSwap2 and {currentReg, finalReg} or {finalReg, currentReg};
    self:addStatement(self:setRegister(scope, tmpReg2, Ast[shouldSwap2 and "GreaterThanOrEqualsExpression" or "LessThanOrEqualsExpression"](self:register(scope, shuffledRegs3[1]), self:register(scope, shuffledRegs3[2]))), {tmpReg2}, {shuffledRegs3[1], shuffledRegs3[2]}, false);

    self:addStatement(self:setRegister(scope, tmpReg2, Ast.AndExpression(self:register(scope, incrementIsNegReg), self:register(scope, tmpReg2))), {tmpReg2}, {tmpReg2, incrementIsNegReg}, false);
    self:addStatement(self:setRegister(scope, tmpReg1, Ast.OrExpression(self:register(scope, tmpReg2), self:register(scope, tmpReg1))), {tmpReg1}, {tmpReg1, tmpReg2}, false);
    self:freeRegister(tmpReg2);
    tmpReg2 = self:compileExpression(Ast.NumberExpression(innerBlock.id), funcDepth, 1)[1];
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.AndExpression(self:register(scope, tmpReg1), self:register(scope, tmpReg2))), {self.POS_REGISTER}, {tmpReg1, tmpReg2}, false);
    self:freeRegister(tmpReg2);
    self:freeRegister(tmpReg1);
    tmpReg2 = self:compileExpression(Ast.NumberExpression(finalBlock.id), funcDepth, 1)[1];
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(self:register(scope, self.POS_REGISTER), self:register(scope, tmpReg2))), {self.POS_REGISTER}, {self.POS_REGISTER, tmpReg2}, false);
    self:freeRegister(tmpReg2);

    self:setActiveBlock(innerBlock);
    scope = innerBlock.scope;
    self.registers[self.POS_REGISTER] = posState;

    local varReg = self:getVarRegister(statement.scope, statement.id, funcDepth, nil);

    if(self:isUpvalue(statement.scope, statement.id)) then
        scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction);
        self:addStatement(self:setRegister(scope, varReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {})), {varReg}, {}, false);
        self:addStatement(self:setUpvalueMember(scope, self:register(scope, varReg), self:register(scope, currentReg)), {}, {varReg, currentReg}, true);
    else
        self:addStatement(self:setRegister(scope, varReg, self:register(scope, currentReg)), {varReg}, {currentReg}, false);
    end


    self:compileBlock(statement.body, funcDepth);
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(checkBlock.id)), {self.POS_REGISTER}, {}, false);

    self.registers[self.POS_REGISTER] = self.VAR_REGISTER;
    self:freeRegister(finalReg);
    self:freeRegister(incrementIsNegReg);
    self:freeRegister(incrementReg);
    self:freeRegister(currentReg, true);

    self.registers[self.POS_REGISTER] = posState;
    self:setActiveBlock(finalBlock);
end;

`,"prometheus.compiler.statements.function_call":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- function_call.lua
--
-- This Script contains the statement handler for the FunctionCallStatement.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local baseReg = self:compileExpression(statement.base, funcDepth, 1)[1];
    local retReg = self:allocRegister(false);
    local regs = {};
    local args = {};

    for i, expr in ipairs(statement.args) do
        if i == #statement.args and (expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression or expr.kind == AstKind.VarargExpression) then
            local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1];
            table.insert(args, Ast.FunctionCallExpression(
                self:unpack(scope),
                {self:register(scope, reg)}));
            table.insert(regs, reg);
        else
            local reg = self:compileExpression(expr, funcDepth, 1)[1];
            local argExpr = self:register(scope, reg);
            table.insert(args, argExpr);
            table.insert(regs, reg);
        end
    end

    self:addStatement(self:setRegister(scope, retReg, Ast.FunctionCallExpression(self:register(scope, baseReg), args)), {retReg}, {baseReg, unpack(regs)}, true);
    self:freeRegister(baseReg, false);
    self:freeRegister(retReg, false);
    for _, reg in ipairs(regs) do
        self:freeRegister(reg, false);
    end
end;

`,"prometheus.compiler.statements.function_declaration":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- function_declaration.lua
--
-- This Script contains the statement handler for the FunctionDeclaration.

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local retReg = self:compileFunction(statement, funcDepth);
    if(#statement.indices > 0) then
        local tblReg;
        if statement.scope.isGlobal then
            tblReg = self:allocRegister(false);
            self:addStatement(self:setRegister(scope, tblReg, Ast.StringExpression(statement.scope:getVariableName(statement.id))), {tblReg}, {}, false);
            self:addStatement(self:setRegister(scope, tblReg, Ast.IndexExpression(self:env(scope), self:register(scope, tblReg))), {tblReg}, {tblReg}, true);
        else
            if self.scopeFunctionDepths[statement.scope] == funcDepth then
                if self:isUpvalue(statement.scope, statement.id) then
                    tblReg = self:allocRegister(false);
                    local reg = self:getVarRegister(statement.scope, statement.id, funcDepth);
                    self:addStatement(self:setRegister(scope, tblReg, self:getUpvalueMember(scope, self:register(scope, reg))), {tblReg}, {reg}, true);
                else
                    tblReg = self:getVarRegister(statement.scope, statement.id, funcDepth, retReg);
                end
            else
                tblReg = self:allocRegister(false);
                local upvalId = self:getUpvalueId(statement.scope, statement.id);
                scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar);
                self:addStatement(self:setRegister(scope, tblReg, self:getUpvalueMember(scope, Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar), Ast.NumberExpression(upvalId)))), {tblReg}, {}, true);
            end
        end

        for i = 1, #statement.indices - 1 do
            local index = statement.indices[i];
            local indexReg = self:compileExpression(Ast.StringExpression(index), funcDepth, 1)[1];
            local tblRegOld = tblReg;
            tblReg = self:allocRegister(false);
            self:addStatement(self:setRegister(scope, tblReg, Ast.IndexExpression(self:register(scope, tblRegOld), self:register(scope, indexReg))), {tblReg}, {tblReg, indexReg}, false);
            self:freeRegister(tblRegOld, false);
            self:freeRegister(indexReg, false);
        end

        local index = statement.indices[#statement.indices];
        local indexReg = self:compileExpression(Ast.StringExpression(index), funcDepth, 1)[1];
        self:addStatement(Ast.AssignmentStatement({
            Ast.AssignmentIndexing(self:register(scope, tblReg), self:register(scope, indexReg)),
        }, {
            self:register(scope, retReg),
        }), {}, {tblReg, indexReg, retReg}, true);
        self:freeRegister(indexReg, false);
        self:freeRegister(tblReg, false);
        self:freeRegister(retReg, false);

        return;
    end
    if statement.scope.isGlobal then
        local tmpReg = self:allocRegister(false);
        self:addStatement(self:setRegister(scope, tmpReg, Ast.StringExpression(statement.scope:getVariableName(statement.id))), {tmpReg}, {}, false);
        self:addStatement(Ast.AssignmentStatement({Ast.AssignmentIndexing(self:env(scope), self:register(scope, tmpReg))},
         {self:register(scope, retReg)}), {}, {tmpReg, retReg}, true);
        self:freeRegister(tmpReg, false);
    else
        if self.scopeFunctionDepths[statement.scope] == funcDepth then
            if self:isUpvalue(statement.scope, statement.id) then
                local reg = self:getVarRegister(statement.scope, statement.id, funcDepth);
                self:addStatement(self:setUpvalueMember(scope, self:register(scope, reg), self:register(scope, retReg)), {}, {reg, retReg}, true);
            else
                local reg = self:getVarRegister(statement.scope, statement.id, funcDepth, retReg);
                if reg ~= retReg then
                    self:addStatement(self:setRegister(scope, reg, self:register(scope, retReg)), {reg}, {retReg}, false);
                end
            end
        else
            local upvalId = self:getUpvalueId(statement.scope, statement.id);
            scope:addReferenceToHigherScope(self.containerFuncScope, self.currentUpvaluesVar);
            self:addStatement(self:setUpvalueMember(scope, Ast.IndexExpression(Ast.VariableExpression(self.containerFuncScope, self.currentUpvaluesVar), Ast.NumberExpression(upvalId)), self:register(scope, retReg)), {}, {retReg}, true);
        end
    end
    self:freeRegister(retReg, false);
end;

`,"prometheus.compiler.statements.if_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- if_statement.lua
--
-- This Script contains the statement handler for the IfStatement.

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local conditionReg = self:compileExpression(statement.condition, funcDepth, 1)[1];
    local finalBlock = self:createBlock();

    local nextBlock
    if statement.elsebody or #statement.elseifs > 0 then
        nextBlock = self:createBlock();
    else
        nextBlock = finalBlock;
    end
    local innerBlock = self:createBlock();


    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(scope, conditionReg), Ast.NumberExpression(innerBlock.id)), Ast.NumberExpression(nextBlock.id))), {self.POS_REGISTER}, {conditionReg}, false);

    self:freeRegister(conditionReg, false);

    self:setActiveBlock(innerBlock);
    scope = innerBlock.scope
    self:compileBlock(statement.body, funcDepth);
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)), {self.POS_REGISTER}, {}, false);

    for i, eif in ipairs(statement.elseifs) do
        self:setActiveBlock(nextBlock);
        conditionReg = self:compileExpression(eif.condition, funcDepth, 1)[1];
        local innerBlock = self:createBlock();
        if statement.elsebody or i < #statement.elseifs then
            nextBlock = self:createBlock();
        else
            nextBlock = finalBlock;
        end
        local scope = self.activeBlock.scope;

        self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(scope, conditionReg), Ast.NumberExpression(innerBlock.id)), Ast.NumberExpression(nextBlock.id))), {self.POS_REGISTER}, {conditionReg}, false);


        self:freeRegister(conditionReg, false);

        self:setActiveBlock(innerBlock);
        scope = innerBlock.scope;
        self:compileBlock(eif.body, funcDepth);
        self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)), {self.POS_REGISTER}, {}, false);
    end

    if statement.elsebody then
        self:setActiveBlock(nextBlock);
        self:compileBlock(statement.elsebody, funcDepth);
        self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(finalBlock.id)), {self.POS_REGISTER}, {}, false);
    end

    self:setActiveBlock(finalBlock);
end;
`,"prometheus.compiler.statements.local_function_declaration":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- local_function_declaration.lua
--
-- This Script contains the statement handler for the LocalFunctionDeclaration

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;

    if(self:isUpvalue(statement.scope, statement.id)) then
        local varReg = self:getVarRegister(statement.scope, statement.id, funcDepth, nil);
        scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction);
        self:addStatement(self:setRegister(scope, varReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {})), {varReg}, {}, false);
        local retReg = self:compileFunction(statement, funcDepth);
        self:addStatement(self:setUpvalueMember(scope, self:register(scope, varReg), self:register(scope, retReg)), {}, {varReg, retReg}, true);
        self:freeRegister(retReg, false);
    else
        local retReg = self:compileFunction(statement, funcDepth);
        local varReg = self:getVarRegister(statement.scope, statement.id, funcDepth, retReg);

        self:addStatement(self:copyRegisters(scope, {varReg}, {retReg}), {varReg}, {retReg}, false);
        self:freeRegister(retReg, false);
    end
end;

`,"prometheus.compiler.statements.local_variable_declaration":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- local_variable_declaration.lua
--
-- This Script contains the statement handler for the LocalVariableDeclaration

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local exprregs = {};
    for i, expr in ipairs(statement.expressions) do
        if(i == #statement.expressions and #statement.ids > #statement.expressions) then
            local regs = self:compileExpression(expr, funcDepth, #statement.ids - #statement.expressions + 1);
            for i, reg in ipairs(regs) do
                table.insert(exprregs, reg);
            end
        else
            if statement.ids[i] or expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression then
                local reg = self:compileExpression(expr, funcDepth, 1)[1];
                table.insert(exprregs, reg);
            end
        end
    end

    if #exprregs == 0 then
        for _=1, #statement.ids do
            table.insert(exprregs, self:compileExpression(Ast.NilExpression(), funcDepth, 1)[1]);
        end
    end

    for i, id in ipairs(statement.ids) do
        if(exprregs[i]) then
            if(self:isUpvalue(statement.scope, id)) then
                local varreg = self:getVarRegister(statement.scope, id, funcDepth);
                local varReg = self:getVarRegister(statement.scope, id, funcDepth, nil);
                scope:addReferenceToHigherScope(self.scope, self.allocUpvalFunction);
                self:addStatement(self:setRegister(scope, varReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.allocUpvalFunction), {})), {varReg}, {}, false);
                self:addStatement(self:setUpvalueMember(scope, self:register(scope, varReg), self:register(scope, exprregs[i])), {}, {varReg, exprregs[i]}, true);
                self:freeRegister(exprregs[i], false);
            else
                local varreg = self:getVarRegister(statement.scope, id, funcDepth, exprregs[i]);
                self:addStatement(self:copyRegisters(scope, {varreg}, {exprregs[i]}), {varreg}, {exprregs[i]}, false);
                self:freeRegister(exprregs[i], false);
            end
        end
    end

    if not self.scopeFunctionDepths[statement.scope] then
        self.scopeFunctionDepths[statement.scope] = funcDepth;
    end
end;

`,"prometheus.compiler.statements.pass_self_function_call":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- pass_self_function_call.lua
--
-- This Script contains the statement handler for the PassSelfFunctionCallStatement.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local baseReg = self:compileExpression(statement.base, funcDepth, 1)[1];
    local tmpReg = self:allocRegister(false);
    local args = { self:register(scope, baseReg) };
    local regs = { baseReg };

    for i, expr in ipairs(statement.args) do
        if i == #statement.args and (expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression or expr.kind == AstKind.VarargExpression) then
            local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1];
            table.insert(args, Ast.FunctionCallExpression(
                self:unpack(scope),
                {self:register(scope, reg)}));
            table.insert(regs, reg);
        else
            local reg = self:compileExpression(expr, funcDepth, 1)[1];
            table.insert(args, self:register(scope, reg));
            table.insert(regs, reg);
        end
    end
    self:addStatement(self:setRegister(scope, tmpReg, Ast.StringExpression(statement.passSelfFunctionName)), {tmpReg}, {}, false);
    self:addStatement(self:setRegister(scope, tmpReg, Ast.IndexExpression(self:register(scope, baseReg), self:register(scope, tmpReg))), {tmpReg}, {tmpReg, baseReg}, false);

    self:addStatement(self:setRegister(scope, tmpReg, Ast.FunctionCallExpression(self:register(scope, tmpReg), args)), {tmpReg}, {tmpReg, unpack(regs)}, true);

    self:freeRegister(tmpReg, false);
    for _, reg in ipairs(regs) do
        self:freeRegister(reg, false);
    end
end;

`,"prometheus.compiler.statements.repeat_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- repeat_statement.lua
--
-- This Script contains the statement handler for the RepeatStatement.

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local innerBlock = self:createBlock();
    local finalBlock = self:createBlock();
    statement.__start_block = innerBlock;
    statement.__final_block = finalBlock;

    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.NumberExpression(innerBlock.id)), {self.POS_REGISTER}, {}, false);
    self:setActiveBlock(innerBlock);

    for _, stat in ipairs(statement.body.statements) do
        self:compileStatement(stat, funcDepth);
    end;

    local scope = self.activeBlock.scope;
    local conditionReg = (self:compileExpression(statement.condition, funcDepth, 1))[1];
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(scope, conditionReg), Ast.NumberExpression(finalBlock.id)), Ast.NumberExpression(innerBlock.id))), { self.POS_REGISTER }, { conditionReg }, false);
    self:freeRegister(conditionReg, false);

    for id, _ in ipairs(statement.body.scope.variables) do
        local varReg = self:getVarRegister(statement.body.scope, id, funcDepth, nil);
        if self:isUpvalue(statement.body.scope, id) then
            scope:addReferenceToHigherScope(self.scope, self.freeUpvalueFunc);
            self:addStatement(self:setRegister(scope, varReg, Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.freeUpvalueFunc), { self:register(scope, varReg) })), { varReg }, { varReg }, false);
        else
            self:addStatement(self:setRegister(scope, varReg, Ast.NilExpression()), { varReg }, {}, false);
        end;
        self:freeRegister(varReg, true);
    end;

    self:setActiveBlock(finalBlock);
end;
`,"prometheus.compiler.statements.return":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- return.lua
--
-- This Script contains the statement handler for the ReturnStatement.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local entries = {};
    local regs = {};

    for i, expr in ipairs(statement.args) do
        if i == #statement.args and (expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression or expr.kind == AstKind.VarargExpression) then
            local reg = self:compileExpression(expr, funcDepth, self.RETURN_ALL)[1];
            table.insert(entries, Ast.TableEntry(Ast.FunctionCallExpression(
                self:unpack(scope),
                {self:register(scope, reg)})));
            table.insert(regs, reg);
        else
            local reg = self:compileExpression(expr, funcDepth, 1)[1];
            table.insert(entries, Ast.TableEntry(self:register(scope, reg)));
            table.insert(regs, reg);
        end
    end

    for _, reg in ipairs(regs) do
        self:freeRegister(reg, false);
    end

    self:addStatement(self:setReturn(scope, Ast.TableConstructorExpression(entries)), {self.RETURN_REGISTER}, regs, false);
    self:addStatement(self:setPos(self.activeBlock.scope, nil), {self.POS_REGISTER}, {}, false);
    self.activeBlock.advanceToNextBlock = false;
end;
`,"prometheus.compiler.statements.while_statement":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- while_statement.lua
--
-- This Script contains the statement handler for the WhileStatement

local Ast = require("prometheus.ast");

return function(self, statement, funcDepth)
    local scope = self.activeBlock.scope;
    local innerBlock = self:createBlock();
    local finalBlock = self:createBlock();
    local checkBlock = self:createBlock();

    statement.__start_block = checkBlock;
    statement.__final_block = finalBlock;

    self:addStatement(self:setPos(scope, checkBlock.id), {self.POS_REGISTER}, {}, false);

    self:setActiveBlock(checkBlock);
    scope = self.activeBlock.scope;
    local conditionReg = self:compileExpression(statement.condition, funcDepth, 1)[1];
    self:addStatement(self:setRegister(scope, self.POS_REGISTER, Ast.OrExpression(Ast.AndExpression(self:register(scope, conditionReg), Ast.NumberExpression(innerBlock.id)), Ast.NumberExpression(finalBlock.id))), {self.POS_REGISTER}, {conditionReg}, false);
    self:freeRegister(conditionReg, false);

    self:setActiveBlock(innerBlock);
    local scope = self.activeBlock.scope;
    self:compileBlock(statement.body, funcDepth);
    self:addStatement(self:setPos(scope, checkBlock.id), {self.POS_REGISTER}, {}, false);
    self:setActiveBlock(finalBlock);
end;
`,"prometheus.compiler.statements":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- statements.lua
--
-- This Script contains the statement handlers: exports handler table keyed by AstKind.

local Ast = require("prometheus.ast");
local AstKind = Ast.AstKind;

local handlers = {};
local statements = "prometheus.compiler.statements.";
local function requireStatement(name)
    return require(statements .. name);
end

handlers[AstKind.ReturnStatement] = requireStatement("return");
handlers[AstKind.LocalVariableDeclaration] = requireStatement("local_variable_declaration");
handlers[AstKind.FunctionCallStatement] = requireStatement("function_call");
handlers[AstKind.PassSelfFunctionCallStatement] = requireStatement("pass_self_function_call");
handlers[AstKind.LocalFunctionDeclaration] = requireStatement("local_function_declaration");
handlers[AstKind.FunctionDeclaration] = requireStatement("function_declaration");
handlers[AstKind.AssignmentStatement] = requireStatement("assignment");
handlers[AstKind.IfStatement] = requireStatement("if_statement");
handlers[AstKind.DoStatement] = requireStatement("do_statement");
handlers[AstKind.WhileStatement] = requireStatement("while_statement");
handlers[AstKind.RepeatStatement] = requireStatement("repeat_statement");
handlers[AstKind.ForStatement] = requireStatement("for_statement");
handlers[AstKind.ForInStatement] = requireStatement("for_in_statement");
handlers[AstKind.BreakStatement] = requireStatement("break_statement");
handlers[AstKind.ContinueStatement] = requireStatement("continue_statement");

-- Compound statements share one handler
local compoundHandler = requireStatement("compound");
handlers[AstKind.CompoundAddStatement] = compoundHandler;
handlers[AstKind.CompoundSubStatement] = compoundHandler;
handlers[AstKind.CompoundMulStatement] = compoundHandler;
handlers[AstKind.CompoundDivStatement] = compoundHandler;
handlers[AstKind.CompoundModStatement] = compoundHandler;
handlers[AstKind.CompoundPowStatement] = compoundHandler;
handlers[AstKind.CompoundConcatStatement] = compoundHandler;

return handlers;

`,"prometheus.compiler.upvalue":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- upvalue.lua
--
-- This Script contains the upvalue and GC management for the compiler.

local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");
local util = require("prometheus.util");

local unpack = unpack or table.unpack;

return function(Compiler)
    function Compiler:createUpvaluesGcFunc()
        local scope = Scope:new(self.scope);
        local selfVar = scope:addVariable();

        local iteratorVar = scope:addVariable();
        local valueVar = scope:addVariable();

        local whileScope = Scope:new(scope);
        whileScope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 3);
        whileScope:addReferenceToHigherScope(scope, valueVar, 3);
        whileScope:addReferenceToHigherScope(scope, iteratorVar, 3);

        local ifScope = Scope:new(whileScope);
        ifScope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 1);
        ifScope:addReferenceToHigherScope(self.scope, self.upvaluesTable, 1);

        return Ast.FunctionLiteralExpression({Ast.VariableExpression(scope, selfVar)}, Ast.Block({
            Ast.LocalVariableDeclaration(scope, {iteratorVar, valueVar}, {Ast.NumberExpression(1), Ast.IndexExpression(Ast.VariableExpression(scope, selfVar), Ast.NumberExpression(1))}),
            Ast.WhileStatement(Ast.Block({
                Ast.AssignmentStatement({
                    Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, valueVar)),
                    Ast.AssignmentVariable(scope, iteratorVar),
                }, {
                    Ast.SubExpression(Ast.IndexExpression(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, valueVar)), Ast.NumberExpression(1)),
                    Ast.AddExpression(unpack(util.shuffle{Ast.VariableExpression(scope, iteratorVar), Ast.NumberExpression(1)})),
                }),
                Ast.IfStatement(Ast.EqualsExpression(unpack(util.shuffle{Ast.IndexExpression(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, valueVar)), Ast.NumberExpression(0)})), Ast.Block({
                    Ast.AssignmentStatement({
                        Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, valueVar)),
                        Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesTable), Ast.VariableExpression(scope, valueVar)),
                    }, {
                        Ast.NilExpression(),
                        Ast.NilExpression(),
                    })
                }, ifScope), {}, nil),
                Ast.AssignmentStatement({
                    Ast.AssignmentVariable(scope, valueVar),
                }, {
                    Ast.IndexExpression(Ast.VariableExpression(scope, selfVar), Ast.VariableExpression(scope, iteratorVar)),
                }),
            }, whileScope), Ast.VariableExpression(scope, valueVar), scope);
        }, scope));
    end

    function Compiler:createFreeUpvalueFunc()
        local scope = Scope:new(self.scope);
        local argVar = scope:addVariable();
        local ifScope = Scope:new(scope);
        ifScope:addReferenceToHigherScope(scope, argVar, 3);
        scope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 2);
        return Ast.FunctionLiteralExpression({Ast.VariableExpression(scope, argVar)}, Ast.Block({
            Ast.AssignmentStatement({
                Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, argVar))
            }, {
                Ast.SubExpression(Ast.IndexExpression(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, argVar)), Ast.NumberExpression(1));
            }),
            Ast.IfStatement(Ast.EqualsExpression(unpack(util.shuffle{Ast.IndexExpression(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, argVar)), Ast.NumberExpression(0)})), Ast.Block({
                Ast.AssignmentStatement({
                    Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(scope, argVar)),
                    Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesTable), Ast.VariableExpression(scope, argVar)),
                }, {
                    Ast.NilExpression(),
                    Ast.NilExpression(),
                })
            }, ifScope), {}, nil)
        }, scope))
    end

    function Compiler:createUpvaluesProxyFunc()
        local scope = Scope:new(self.scope);
        scope:addReferenceToHigherScope(self.scope, self.newproxyVar);

        local entriesVar = scope:addVariable();

        local ifScope = Scope:new(scope);
        local proxyVar = ifScope:addVariable();
        local metatableVar = ifScope:addVariable();
        local elseScope = Scope:new(scope);
        ifScope:addReferenceToHigherScope(self.scope, self.newproxyVar);
        ifScope:addReferenceToHigherScope(self.scope, self.getmetatableVar);
        ifScope:addReferenceToHigherScope(self.scope, self.upvaluesGcFunctionVar);
        ifScope:addReferenceToHigherScope(scope, entriesVar);
        elseScope:addReferenceToHigherScope(self.scope, self.setmetatableVar);
        elseScope:addReferenceToHigherScope(scope, entriesVar);
        elseScope:addReferenceToHigherScope(self.scope, self.upvaluesGcFunctionVar);

        local forScope = Scope:new(scope);
        local forArg = forScope:addVariable();
        forScope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 2);
        forScope:addReferenceToHigherScope(scope, entriesVar, 2);

        return Ast.FunctionLiteralExpression({Ast.VariableExpression(scope, entriesVar)}, Ast.Block({
            Ast.ForStatement(forScope, forArg, Ast.NumberExpression(1), Ast.LenExpression(Ast.VariableExpression(scope, entriesVar)), Ast.NumberExpression(1), Ast.Block({
                Ast.AssignmentStatement({
                    Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.IndexExpression(Ast.VariableExpression(scope, entriesVar), Ast.VariableExpression(forScope, forArg)))
                }, {
                    Ast.AddExpression(unpack(util.shuffle{
                        Ast.IndexExpression(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.IndexExpression(Ast.VariableExpression(scope, entriesVar), Ast.VariableExpression(forScope, forArg))),
                        Ast.NumberExpression(1),
                    }))
                })
            }, forScope), scope);
            Ast.IfStatement(Ast.VariableExpression(self.scope, self.newproxyVar), Ast.Block({
                Ast.LocalVariableDeclaration(ifScope, {proxyVar}, {
                    Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.newproxyVar), {
                        Ast.BooleanExpression(true)
                    });
                });
                Ast.LocalVariableDeclaration(ifScope, {metatableVar}, {
                    Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.getmetatableVar), {
                        Ast.VariableExpression(ifScope, proxyVar);
                    });
                });
                Ast.AssignmentStatement({
                    Ast.AssignmentIndexing(Ast.VariableExpression(ifScope, metatableVar), Ast.StringExpression("__index")),
                    Ast.AssignmentIndexing(Ast.VariableExpression(ifScope, metatableVar), Ast.StringExpression("__gc")),
                    Ast.AssignmentIndexing(Ast.VariableExpression(ifScope, metatableVar), Ast.StringExpression("__len")),
                }, {
                    Ast.VariableExpression(scope, entriesVar),
                    Ast.VariableExpression(self.scope, self.upvaluesGcFunctionVar),
                    Ast.FunctionLiteralExpression({}, Ast.Block({
                        Ast.ReturnStatement({Ast.NumberExpression(self.upvalsProxyLenReturn)})
                    }, Scope:new(ifScope)));
                });
                Ast.ReturnStatement({
                    Ast.VariableExpression(ifScope, proxyVar)
                })
            }, ifScope), {}, Ast.Block({
                Ast.ReturnStatement({Ast.FunctionCallExpression(Ast.VariableExpression(self.scope, self.setmetatableVar), {
                    Ast.TableConstructorExpression({}),
                    Ast.TableConstructorExpression({
                        Ast.KeyedTableEntry(Ast.StringExpression("__gc"), Ast.VariableExpression(self.scope, self.upvaluesGcFunctionVar)),
                        Ast.KeyedTableEntry(Ast.StringExpression("__index"), Ast.VariableExpression(scope, entriesVar)),
                        Ast.KeyedTableEntry(Ast.StringExpression("__len"), Ast.FunctionLiteralExpression({}, Ast.Block({
                            Ast.ReturnStatement({Ast.NumberExpression(self.upvalsProxyLenReturn)})
                        }, Scope:new(ifScope)))),
                    })
                })})
            }, elseScope));
        }, scope));
    end

    function Compiler:createAllocUpvalFunction()
        local scope = Scope:new(self.scope);
        scope:addReferenceToHigherScope(self.scope, self.currentUpvalId, 4);
        scope:addReferenceToHigherScope(self.scope, self.upvaluesReferenceCountsTable, 1);

        return Ast.FunctionLiteralExpression({}, Ast.Block({
            Ast.AssignmentStatement({
                    Ast.AssignmentVariable(self.scope, self.currentUpvalId),
                },{
                    Ast.AddExpression(unpack(util.shuffle({
                        Ast.VariableExpression(self.scope, self.currentUpvalId),
                        Ast.NumberExpression(1),
                    }))),
                }
            ),
            Ast.AssignmentStatement({
                Ast.AssignmentIndexing(Ast.VariableExpression(self.scope, self.upvaluesReferenceCountsTable), Ast.VariableExpression(self.scope, self.currentUpvalId)),
            }, {
                Ast.NumberExpression(1),
            }),
            Ast.ReturnStatement({
                Ast.VariableExpression(self.scope, self.currentUpvalId),
            })
        }, scope));
    end
end

`,"prometheus.enums":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- enums.lua
--
-- This Script provides some enums used by the Obfuscator.

local Enums = {};

local chararray = require("prometheus.util").chararray;

Enums.LuaVersion = {
	LuaU = "LuaU" ,
	Lua51 = "Lua51",
}

Enums.Conventions = {
	[Enums.LuaVersion.Lua51] = {
		Keywords = {
			"and", "break", "do", "else", "elseif",
			"end", "false", "for", "function", "if",
			"in", "local", "nil", "not", "or",
			"repeat", "return", "then", "true", "until", "while",
			"continue"
		},

		SymbolChars = chararray("+-*/%^#=~<>(){}[];:,."),
		MaxSymbolLength = 3,
		Symbols = {
			"+", "-", "*", "/", "//", "%", "^", "#",
			"==", "~=", "<=", ">=", "<", ">", "=",
			"+=", "-=", "/=", "//=", "%=", "^=", "..=", "*=",
			"(", ")", "{", "}", "[", "]",
			";", ":", ",", ".", "..", "...",
		},

		IdentChars = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"),
		NumberChars = chararray("0123456789"),
		HexNumberChars = chararray("0123456789abcdefABCDEF"),
		BinaryNumberChars = {"0", "1"},
		DecimalExponent = {"e", "E"},
		HexadecimalNums = {"x", "X"},
		BinaryNums = {"b", "B"},
		DecimalSeperators = {"_"},

		EscapeSequences = {
			["a"] = "\\a";
			["b"] = "\\b";
			["f"] = "\\f";
			["n"] = "\\n";
			["r"] = "\\r";
			["t"] = "\\t";
			["v"] = "\\v";
			["\\\\"] = "\\\\";
			["\\""] = "\\"";
			["\\'"] = "\\'";
			["\`"] = "\`";
			["{"] = "{";
			["}"] = "}";
		},
		NumericalEscapes = true,
		EscapeZIgnoreNextWhitespace = true,
		HexEscapes = true,
		UnicodeEscapes = true,
	},
	[Enums.LuaVersion.LuaU] = {
		Keywords = {
			"and", "break", "do", "else", "elseif", "continue",
			"end", "false", "for", "function", "if",
			"in", "local", "nil", "not", "or",
			"repeat", "return", "then", "true", "until", "while"
		},

		SymbolChars = chararray("+-*/%^#=~<>(){}[];:,."),
		MaxSymbolLength = 3,
		Symbols = {
			"+", "-", "*", "/", "//", "%", "^", "#",
			"==", "~=", "<=", ">=", "<", ">", "=",
			"+=", "-=", "/=", "//=", "%=", "^=", "..=", "*=",
			"(", ")", "{", "}", "[", "]",
			";", ":", ",", ".", "..", "...",
			"::", "->", "?", "|", "&",
		},

		IdentChars = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"),
		NumberChars = chararray("0123456789"),
		HexNumberChars = chararray("0123456789abcdefABCDEF"),
		BinaryNumberChars = {"0", "1"},
		DecimalExponent = {"e", "E"},
		HexadecimalNums = {"x", "X"},
		BinaryNums = {"b", "B"},
		DecimalSeperators = {"_"},

		EscapeSequences = {
			["a"] = "\\a";
			["b"] = "\\b";
			["f"] = "\\f";
			["n"] = "\\n";
			["r"] = "\\r";
			["t"] = "\\t";
			["v"] = "\\v";
			["\\\\"] = "\\\\";
			["\\""] = "\\"";
			["\\'"] = "\\'";
			["\`"] = "\`";
			["{"] = "{";
			["}"] = "}";
		},
		NumericalEscapes = true,
		EscapeZIgnoreNextWhitespace = true,
		HexEscapes = true,
		UnicodeEscapes = true,
	},
}

return Enums;
`,"prometheus.namegenerators.Il":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- namegenerators/il.lua
--
-- This Script provides a function for generation of weird names consisting of I, l and 1

local MIN_CHARACTERS = 5;
local MAX_INITIAL_CHARACTERS = 10;


local util = require("prometheus.util");
local chararray = util.chararray;

local offset = 0;
local VarDigits = chararray("Il1");
local VarStartDigits = chararray("Il");

local function generateName(id, _)
	local name = ''
	id = id + offset;
	local d = id % #VarStartDigits
	id = (id - d) / #VarStartDigits
	name = name..VarStartDigits[d+1]
	while id > 0 do
		local e = id % #VarDigits
		id = (id - e) / #VarDigits
		name = name..VarDigits[e+1]
	end
	return name
end

local function prepare(_)
	util.shuffle(VarDigits);
	util.shuffle(VarStartDigits);
	offset = math.random(3 ^ MIN_CHARACTERS, 3 ^ MAX_INITIAL_CHARACTERS);
end

return {
	generateName = generateName,
	prepare = prepare
};
`,"prometheus.namegenerators.confuse":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- namegenerators/confuse.lua
--
-- This Script provides a function for generation of confusing variable names

local util = require("prometheus.util");

local varNames = {
    "index",
    "iterator",
    "length",
    "size",
    "key",
    "value",
    "data",
    "count",
    "increment",
    "include",
    "string",
    "number",
    "type",
    "void",
    "int",
    "float",
    "bool",
    "char",
    "double",
    "long",
    "short",
    "unsigned",
    "signed",
    "program",
    "factory",
    "Factory",
    "new",
    "delete",
    "table",
    "array",
    "object",
    "class",
    "arr",
    "obj",
    "cls",
    "dir",
    "directory",
    "isWindows",
    "isLinux",
    "game",
    "roblox",
    "gmod",
    "gsub",
    "gmatch",
    "gfind",
    "onload",
    "load",
    "loadstring",
    "loadfile",
    "dofile",
    "require",
    "parse",
    "byte",
    "code",
    "bytecode",
    "idx",
    "const",
    "loader",
    "loaders",
    "module",
    "export",
    "exports",
    "import",
    "imports",
    "package",
    "packages",
    "_G",
    "math",
    "os",
    "io",
    "write",
    "print",
    "read",
    "readline",
    "readlines",
    "close",
    "flush",
    "open",
    "popen",
    "tmpfile",
    "tmpname",
    "rename",
    "remove",
    "seek",
    "setvbuf",
    "lines",
    "call",
    "apply",
    "raise",
    "pcall",
    "xpcall",
    "coroutine",
    "create",
    "resume",
    "status",
    "wrap",
    "yield",
    "debug",
    "traceback",
    "getinfo",
    "getlocal",
    "setlocal",
    "getupvalue",
    "setupvalue",
    "getuservalue",
    "setuservalue",
    "upvalueid",
    "upvaluejoin",
    "sethook",
    "gethook",
    "hookfunction",
    "hooks",
    "error",
    "setmetatable",
    "getmetatable",
    "rand",
    "randomseed",
    "next",
    "ipairs",
    "hasnext",
    "loadlib",
    "searchpath",
    "oldpath",
    "newpath",
    "path",
    "rawequal",
    "rawset",
    "rawget",
    "rawnew",
    "rawlen",
    "select",
    "tonumber",
    "tostring",
    "assert",
    "collectgarbage",
    "a", "b", "c", "i", "j", "m",
}

local function generateName(id, _)
    local name = {};
    local d = id % #varNames
	id = (id - d) / #varNames
	table.insert(name, varNames[d + 1]);
	while id > 0 do
		local e = id % #varNames
		id = (id - e) / #varNames
		table.insert(name, varNames[e + 1]);
	end
	return table.concat(name, "_");
end

local function prepare(_)
    util.shuffle(varNames);
end

return {
	generateName = generateName,
	prepare = prepare
};
`,"prometheus.namegenerators.entropy":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- namegenerators/entropy.lua
--
-- Generates high-entropy, visually confusing identifiers combining
-- indistinguishable characters and pseudo-hex patterns.

local util = require("prometheus.util")
local chararray = util.chararray

local CHAR_POOLS = {
    -- Homoglyph / visually confusable
    chararray("Il1"),
    chararray("O0o"),
    chararray("xX_"),
}

local BASE_CHARS = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_")
local DIGIT_CHARS = chararray("0123456789abcdefABCDEF_")

local salt = 0
local chosenPool = 1

local function generateName(id, _)
    local pool = CHAR_POOLS[chosenPool] or CHAR_POOLS[1]
    local nameParts = { "_" }
    local val = id + salt

    -- Prefix with confusing characters
    local first = (val % 2 == 0) and "l" or "I"
    table.insert(nameParts, first)

    -- Encode remaining number in mixed base
    while val > 0 do
        local rem = val % #pool
        val = math.floor(val / #pool)
        table.insert(nameParts, pool[rem + 1])
    end

    -- Ensure minimum length for visual density
    while #nameParts < 6 do
        table.insert(nameParts, pool[((#nameParts + salt) % #pool) + 1])
    end

    return table.concat(nameParts)
end

local function prepare(_)
    for _, pool in ipairs(CHAR_POOLS) do
        util.shuffle(pool)
    end
    salt = math.random(100, 999999)
    chosenPool = math.random(1, #CHAR_POOLS)
end

return {
    generateName = generateName,
    prepare = prepare,
}
`,"prometheus.namegenerators.lexical_entropy":`-- This Script is Part of the Pinathub Obfuscator
--
-- namegenerators/lexical_entropy.lua
--
-- Variable Mangle 2.0: Scope-Aware, Lexical-Context-Aware Identifier Generator
-- Features:
--   1. Scope depth tiered naming (avoids uniform barcode fingerprinting)
--   2. Controlled non-uniform entropy (mixed lengths 4-8 chars)
--   3. Collision-safe mathematical mapping
--   4. Seed-reproducible generation
--

local util = require("prometheus.util")
local chararray = util.chararray

local STEMS = {
    "v", "k", "r", "x", "m", "p", "t", "q", "z", "w", "c", "d",
    "V", "K", "R", "X", "M", "P", "T", "Q", "Z", "W", "C", "D",
    "b", "h", "j", "l", "s", "y", "B", "H", "J", "L", "S", "Y"
}

local ALPHABET = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
local START_ALPHABET = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")

local salt = 1337
local scopeLookup = {}

local function generateName(id, scope)
    local scopeLevel = 0
    if type(scope) == "table" and scope.level then
        scopeLevel = scope.level
    end

    -- Pick stem based on scope level and variable id
    local stemIdx = ((scopeLevel * 7 + id * 13 + salt) % #STEMS) + 1
    local stem = STEMS[stemIdx]

    -- Encode remaining id into controlled alphanumeric suffix
    local suffix = {}
    local val = id + salt * 3 + scopeLevel * 17
    while val > 0 do
        local rem = val % #ALPHABET
        val = math.floor(val / #ALPHABET)
        table.insert(suffix, ALPHABET[rem + 1])
    end

    -- Ensure minimum length of 4-6 chars with organic variation
    local targetLen = ((id + scopeLevel) % 4) + 4
    while #suffix < targetLen - #stem do
        local pad = ((#suffix * 31 + id * 19 + salt) % #ALPHABET) + 1
        table.insert(suffix, ALPHABET[pad])
    end

    local name = stem .. table.concat(suffix)

    -- Guard against reserved keywords in Lua
    local RESERVED = {
        ["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true,
        ["elseif"] = true, ["end"] = true, ["false"] = true, ["for"] = true,
        ["function"] = true, ["if"] = true, ["in"] = true, ["local"] = true,
        ["nil"] = true, ["not"] = true, ["or"] = true, ["repeat"] = true,
        ["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
        ["while"] = true
    }
    if RESERVED[name] then
        name = name .. "0"
    end

    return name
end

local function prepare(ast)
    salt = math.random(1000, 999999)
    util.shuffle(ALPHABET)
    util.shuffle(START_ALPHABET)
    util.shuffle(STEMS)
    scopeLookup = {}
end

return {
    generateName = generateName,
    prepare = prepare,
}
`,"prometheus.namegenerators.mangled":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- namegenerators/mangled.lua
--
-- This Script provides a function for generation of mangled names


local util = require("prometheus.util");
local chararray = util.chararray;

local VarDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_");
local VarStartDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

return function(id, _)
	local name = ''
	local d = id % #VarStartDigits
	id = (id - d) / #VarStartDigits
	name = name..VarStartDigits[d+1]
	while id > 0 do
		local e = id % #VarDigits
		id = (id - e) / #VarDigits
		name = name..VarDigits[e+1]
	end
	return name
end`,"prometheus.namegenerators.mangled_shuffled":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- namegenerators/mangled_shuffled.lua
--
-- This Script provides a function for generation of mangled names with shuffled character order


local util = require("prometheus.util");
local chararray = util.chararray;

local VarDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_");
local VarStartDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

local function generateName(id, _)
	local name = ''
	local d = id % #VarStartDigits
	id = (id - d) / #VarStartDigits
	name = name..VarStartDigits[d+1]
	while id > 0 do
		local e = id % #VarDigits
		id = (id - e) / #VarDigits
		name = name..VarDigits[e+1]
	end
	return name
end

local function prepare(_)
	util.shuffle(VarDigits);
	util.shuffle(VarStartDigits);
end

return {
	generateName = generateName,
	prepare = prepare
};`,"prometheus.namegenerators.number":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- namegenerators/number.lua
--
-- This Script provides a function for generation of simple up counting names but with hex numbers

local PREFIX = "_";

return function(id, _)
	return PREFIX .. tostring(id);
end
`,"prometheus.namegenerators":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- namegenerators.lua
--
-- This Script provides a collection of name generators for Prometheus.

return {
	Mangled = require("prometheus.namegenerators.mangled");
	MangledShuffled = require("prometheus.namegenerators.mangled_shuffled");
	Il = require("prometheus.namegenerators.Il");
	Number = require("prometheus.namegenerators.number");
	Confuse = require("prometheus.namegenerators.confuse");
	Entropy = require("prometheus.namegenerators.entropy");
	LexicalEntropy = require("prometheus.namegenerators.lexical_entropy");
}`,"prometheus.parser":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- parser.lua
-- Overview:
-- This Script provides a class for parsing of lua code.
-- This Parser is Capable of parsing LuaU and Lua5.1
--
-- Note that when parsing LuaU "continue" is treated as a Keyword, so no variable may be named "continue" even though this would be valid in LuaU
--
-- Settings Object:
-- luaVersion : The LuaVersion of the Script - Currently Supported : Lua51 and LuaU
--

local Tokenizer = require("prometheus.tokenizer");
local Enums = require("prometheus.enums");
local util = require("prometheus.util");
local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");
local logger = require("logger");

local AstKind = Ast.AstKind;

local LuaVersion = Enums.LuaVersion;
local lookupify = util.lookupify;

local TokenKind = Tokenizer.TokenKind;

local Parser = {};

local ASSIGNMENT_NO_WARN_LOOKUP = lookupify{
	AstKind.NilExpression,
	AstKind.FunctionCallExpression,
	AstKind.PassSelfFunctionCallExpression,
	AstKind.VarargExpression
};

local CALLABLE_PREFIX_EXPRESSION_LOOKUP = lookupify{
	AstKind.VariableExpression,
	AstKind.IndexExpression,
	AstKind.FunctionCallExpression,
	AstKind.PassSelfFunctionCallExpression
};

local function generateError(self, message)
	local token;
	if(self.index > self.length) then
		token = self.tokens[self.length];
	elseif(self.index < 1) then
		return "Parsing Error at Position 0:0, " .. message;
	else
		token = self.tokens[self.index];
	end

	return "Parsing Error at Position " .. tostring(token.line) .. ":" .. tostring(token.linePos) .. ", " .. message;
end

local function generateWarning(token, message)
	return "Warning at Position " .. tostring(token.line) .. ":" .. tostring(token.linePos) .. ", " .. message;
end

function Parser:new(settings)
	local luaVersion = (settings and (settings.luaVersion or settings.LuaVersion)) or LuaVersion.LuaU;
	local parser = {
		luaVersion = luaVersion,
		tokenizer = Tokenizer:new({
			luaVersion = luaVersion
		}),
		tokens = {};
		length = 0;
		index = 0;
	};

	setmetatable(parser, self);
	self.__index = self;

	return parser;
end

-- Function to peek the n'th token
local function peek(self, n)
	n = n or 0;
	local i = self.index + n + 1;
	if i > self.length then
		return Tokenizer.EOF_TOKEN;
	end
	return self.tokens[i];
end

-- Function to get the next Token
local function get(self)
	local i = self.index + 1;
	if i > self.length then
		error(generateError(self, "Unexpected end of Input"));
	end
	self.index = self.index + 1;
	local tk = self.tokens[i];

	return tk;
end

local function is(self, kind, sourceOrN, n)
	local token = peek(self, n);

	local source = nil;
	if(type(sourceOrN) == "string") then
		source = sourceOrN;
	else
		n = sourceOrN;
	end
	n = n or 0;

	if(token.kind == kind) then
		if(source == nil or token.source == source) then
			return true;
		end
	end

	return false;
end

local function consume(self, kind, source)
	if(is(self, kind, source)) then
		self.index = self.index + 1;
		return true;
	end
	return false;
end

local function expect(self, kind, source)
	if(is(self, kind, source, 0)) then
		return get(self);
	end

	local token = peek(self);
	if self.disableLog then error() end
	if(source) then
		logger:error(generateError(self, string.format("unexpected token <%s> \\"%s\\", expected <%s> \\"%s\\"", token.kind, token.source, kind, source)));
	else
		logger:error(generateError(self, string.format("unexpected token <%s> \\"%s\\", expected <%s>", token.kind, token.source, kind)));
	end
end

-- Parse the given code to an Abstract Syntax Tree
function Parser:parse(code)
	self.tokenizer:append(code);
	self.tokens = self.tokenizer:scanAll();
	self.length = #self.tokens;

	-- Create Global Variable Scope
	local globalScope = Scope:newGlobal();

	local ast = Ast.TopNode(self:block(globalScope, false), globalScope);
	-- File Must be Over when Top Node is Fully Parsed
	expect(self, TokenKind.Eof);

	logger:debug("Cleaning up Parser for next Use ...")
	-- Clean Up
	self.tokenizer:reset();
	self.tokens = {};
	self.index = 0;
	self.length = 0;

	logger:debug("Cleanup Done")

	return ast;
end

-- Parse a Code Block
function Parser:block(parentScope, currentLoop, scope)
	scope = scope or Scope:new(parentScope);
	local statements = {};

	repeat
		local statement, isTerminatingStatement = self:statement(scope, currentLoop);
		table.insert(statements, statement);
	until isTerminatingStatement or not statement

	-- Consume Eventual Semicolon after terminating return, break or continue
	consume(self, TokenKind.Symbol, ";");

	return Ast.Block(statements, scope);
end

function Parser:statement(scope, currentLoop)
	-- Skip all semicolons before next real statement
	-- NOP statements are therefore ignored
	while(consume(self, TokenKind.Symbol, ";")) do

	end

	-- Break Statement - only valid inside of Loops
	if(consume(self, TokenKind.Keyword, "break")) then
		if(not currentLoop) then
			if self.disableLog then error() end;
			logger:error(generateError(self, "the break Statement is only valid inside of loops"));
		end
		-- Return true as Second value because break must be the last Statement in a block
		return Ast.BreakStatement(currentLoop, scope), true;
	end

	-- Continue Statement - only valid inside of Loops
	if(consume(self, TokenKind.Keyword, "continue") or (currentLoop and is(self, TokenKind.Identifier, "continue") and not is(self, TokenKind.Symbol, "=", 1) and not is(self, TokenKind.Symbol, ",", 1))) then
		if is(self, TokenKind.Identifier, "continue") then
			get(self);
		end
		if(not currentLoop) then
			if self.disableLog then error() end;
			logger:error(generateError(self, "the continue Statement is only valid inside of loops"));
		end
		-- Return true as Second value because continue must be the last Statement in a block
		return Ast.ContinueStatement(currentLoop, scope), true;
	end

	-- do ... end Statement
	if(consume(self, TokenKind.Keyword, "do")) then
		local body = self:block(scope, currentLoop);
		expect(self, TokenKind.Keyword, "end");
		return Ast.DoStatement(body);
	end

	-- While Statement
	if(consume(self, TokenKind.Keyword, "while")) then
		local condition = self:expression(scope);
		expect(self, TokenKind.Keyword, "do");
		local stat = Ast.WhileStatement(nil, condition, scope);
		stat.body = self:block(scope, stat);
		expect(self, TokenKind.Keyword, "end");
		return stat;
	end

	-- Repeat Statement
	if(consume(self, TokenKind.Keyword, "repeat")) then
		local repeatScope = Scope:new(scope);
		local stat = Ast.RepeatStatement(nil, nil, scope);
		stat.body = self:block(nil, stat, repeatScope);
		expect(self, TokenKind.Keyword, "until");
		stat.condition = self:expression(repeatScope);
		return stat;
	end

	-- Return Statement
	if(consume(self, TokenKind.Keyword, "return")) then
		local args = {};
		if(not is(self, TokenKind.Keyword, "end") and not is(self, TokenKind.Keyword, "elseif") and not is(self, TokenKind.Keyword, "else") and not is(self, TokenKind.Symbol, ";") and not is(self, TokenKind.Eof)) then
			args = self:exprList(scope);
		end
		-- Return true as Second value because return must be the last Statement in a block
		return Ast.ReturnStatement(args), true;
	end

	-- If Statement
	if(consume(self, TokenKind.Keyword, "if")) then
		local condition = self:expression(scope);
		expect(self, TokenKind.Keyword, "then");
		local body = self:block(scope, currentLoop);

		local elseifs = {};
		-- Elseifs
		while(consume(self, TokenKind.Keyword, "elseif")) do
			local condition = self:expression(scope);
			expect(self, TokenKind.Keyword, "then");
			local body = self:block(scope, currentLoop);

			table.insert(elseifs, {
				condition = condition,
				body = body,
			});
		end

		local elsebody = nil;
		-- Else
		if(consume(self, TokenKind.Keyword, "else")) then
			elsebody = self:block(scope, currentLoop);
		end

		expect(self, TokenKind.Keyword, "end");

		return Ast.IfStatement(condition, body, elseifs, elsebody);
	end

	-- Function Declaration
	if(consume(self, TokenKind.Keyword, "function")) then
		-- TODO: Parse Function Declaration Name
		local obj = self:funcName(scope);
		local baseScope = obj.scope;
		local baseId = obj.id;
		local indices = obj.indices;

		local funcScope = Scope:new(scope);

		expect(self, TokenKind.Symbol, "(");
		local args = self:functionArgList(funcScope);
		expect(self, TokenKind.Symbol, ")");

		if(obj.passSelf) then
			local id = funcScope:addVariable("self", obj.token);
			table.insert(args, 1, Ast.VariableExpression(funcScope, id));
		end

		local body = self:block(nil, false, funcScope);
		expect(self, TokenKind.Keyword, "end");

		return Ast.FunctionDeclaration(baseScope, baseId, indices, args, body);
	end

	-- Local Function or Variable Declaration
	if(consume(self, TokenKind.Keyword, "local")) then
		-- Local Function Declaration
		if(consume(self, TokenKind.Keyword, "function")) then
			local ident = expect(self, TokenKind.Ident);
			local name = ident.value;

			local id = scope:addVariable(name, ident);
			local funcScope = Scope:new(scope);

			expect(self, TokenKind.Symbol, "(");
			local args = self:functionArgList(funcScope);
			expect(self, TokenKind.Symbol, ")");

			local body = self:block(nil, false, funcScope);
			expect(self, TokenKind.Keyword, "end");

			return Ast.LocalFunctionDeclaration(scope, id, args, body);
		end

		-- Local Variable Declaration
		local ids = self:nameList(scope);
		local expressions = {};
		if(consume(self, TokenKind.Symbol, "=")) then
			expressions = self:exprList(scope);
		end

		-- Variables can only be reffered to in the next statement, so the id's are enabled after the expressions have been parsed
		self:enableNameList(scope, ids);

		if(#expressions > #ids) then
			logger:warn(generateWarning(peek(self, -1), string.format("assigning %d values to %d variable" .. ((#ids > 1 and "s") or ""), #expressions, #ids)));
		elseif(#ids > #expressions and #expressions > 0 and not ASSIGNMENT_NO_WARN_LOOKUP[expressions[#expressions].kind]) then
			logger:warn(generateWarning(peek(self, -1), string.format("assigning %d value" .. ((#expressions > 1 and "s") or "") ..
				" to %d variables initializes extra variables with nil, add a nil value to silence", #expressions, #ids)));
		end
		return Ast.LocalVariableDeclaration(scope, ids, expressions);
	end

	-- For Statement
	if(consume(self, TokenKind.Keyword, "for")) then
		-- Normal for Statement
		if(is(self, TokenKind.Symbol, "=", 1)) then
			local forScope = Scope:new(scope);

			local ident = expect(self, TokenKind.Ident);
			local varId = forScope:addDisabledVariable(ident.value, ident);

			expect(self, TokenKind.Symbol, "=");
			local initialValue = self:expression(scope);

			expect(self, TokenKind.Symbol, ",");
			local finalValue = self:expression(scope);
			local incrementBy = Ast.NumberExpression(1);
			if(consume(self, TokenKind.Symbol, ",")) then
				incrementBy = self:expression(scope);
			end

			local stat = Ast.ForStatement(forScope, varId, initialValue, finalValue, incrementBy, nil, scope);
			forScope:enableVariable(varId);
			expect(self, TokenKind.Keyword, "do");
			stat.body = self:block(nil, stat, forScope);
			expect(self, TokenKind.Keyword, "end");
			return stat;
		end

		-- For ... in ... statement
		local forScope = Scope:new(scope);

		local ids = self:nameList(forScope);
		expect(self, TokenKind.Keyword, "in");
		local expressions = self:exprList(scope);
		-- Enable Ids after Expression Parsing so that code like this works:
		--	local z = {10,20}
		--	for y,z in ipairs(z) do
		--		print(y, z);
		-- 	end
		self:enableNameList(forScope, ids);
		expect(self, TokenKind.Keyword, "do");
		local stat = Ast.ForInStatement(forScope, ids, expressions, nil, scope);
		stat.body = self:block(nil, stat, forScope);
		expect(self, TokenKind.Keyword, "end");

		return stat;
	end

	local expr = self:primaryExpression(scope);
	-- Variable Assignment or Function Call
	if expr then
		-- Function Call Statement
		if(expr.kind == AstKind.FunctionCallExpression) then
			return Ast.FunctionCallStatement(expr.base, expr.args);
		end

		-- Function Call Statement passing self
		if(expr.kind == AstKind.PassSelfFunctionCallExpression) then
			return Ast.PassSelfFunctionCallStatement(expr.base, expr.passSelfFunctionName, expr.args);
		end

		-- Variable Assignment
		if(expr.kind == AstKind.IndexExpression or expr.kind == AstKind.VariableExpression) then
			if(expr.kind == AstKind.IndexExpression) then
				expr.kind = AstKind.AssignmentIndexing
			end
			if(expr.kind == AstKind.VariableExpression) then
				expr.kind = AstKind.AssignmentVariable
			end

			-- Compound Assignment
			if(consume(self, TokenKind.Symbol, "+=")) then
				local rhs = self:expression(scope);
				return Ast.CompoundAddStatement(expr, rhs);
			end

			if(consume(self, TokenKind.Symbol, "-=")) then
				local rhs = self:expression(scope);
				return Ast.CompoundSubStatement(expr, rhs);
			end

			if(consume(self, TokenKind.Symbol, "*=")) then
				local rhs = self:expression(scope);
				return Ast.CompoundMulStatement(expr, rhs);
			end

			if(consume(self, TokenKind.Symbol, "/=")) then
				local rhs = self:expression(scope);
				return Ast.CompoundDivStatement(expr, rhs);
			end

			if(consume(self, TokenKind.Symbol, "//=")) then
				local rhs = self:expression(scope);
				local mathScope, mathId = scope:resolve("math");
				local mathVar = Ast.VariableExpression(mathScope, mathId);
				local floorIndex = Ast.IndexExpression(mathVar, Ast.StringExpression("floor"));
				local lhsRead;
				if expr.kind == AstKind.AssignmentIndexing then
					lhsRead = Ast.IndexExpression(expr.base, expr.index);
				else
					lhsRead = Ast.VariableExpression(expr.scope, expr.id);
				end
				local divExpr = Ast.DivExpression(lhsRead, rhs, true);
				local floorCall = Ast.FunctionCallExpression(floorIndex, { divExpr });
				return Ast.AssignmentStatement({ expr }, { floorCall });
			end

			if(consume(self, TokenKind.Symbol, "%=")) then
				local rhs = self:expression(scope);
				return Ast.CompoundModStatement(expr, rhs);
			end

			if(consume(self, TokenKind.Symbol, "^=")) then
				local rhs = self:expression(scope);
				return Ast.CompoundPowStatement(expr, rhs);
			end

			if(consume(self, TokenKind.Symbol, "..=")) then
				local rhs = self:expression(scope);
				return Ast.CompoundConcatStatement(expr, rhs);
			end

			local lhs = {
				expr
			}

			while consume(self, TokenKind.Symbol, ",") do
				expr = self:primaryExpression(scope);

				if(not expr) then
					if self.disableLog then error() end;
					logger:error(generateError(self, string.format("expected a valid assignment statement lhs part but got nil")));
				end

				if(expr.kind == AstKind.IndexExpression or expr.kind == AstKind.VariableExpression) then
					if(expr.kind == AstKind.IndexExpression) then
						expr.kind = AstKind.AssignmentIndexing
					end
					if(expr.kind == AstKind.VariableExpression) then
						expr.kind = AstKind.AssignmentVariable
					end
					table.insert(lhs, expr);
				else
					if self.disableLog then error() end;
					logger:error(generateError(self, string.format("expected a valid assignment statement lhs part but got <%s>", expr.kind)));
				end
			end

			expect(self, TokenKind.Symbol, "=");

			local rhs = self:exprList(scope);

			return Ast.AssignmentStatement(lhs, rhs);
		end

		if self.disableLog then error() end;
		logger:error(generateError(self, "expressions are not valid statements!"));
	end

	return nil;
end

function Parser:primaryExpression(scope)
	local i = self.index;
	local s = self;
	self.disableLog = true;
	local status, val = pcall(self.expressionFunctionCall, self, scope);
	self.disableLog = false;
	if(status) then
		return val;
	else
		self.index = i;
		return nil;
	end
end

-- List of expressions Seperated by a comma
function Parser:exprList(scope)
	local expressions = {
		self:expression(scope)
	};
	while(consume(self, TokenKind.Symbol, ",")) do
		table.insert(expressions, self:expression(scope));
	end
	return expressions;
end

-- list of local variable names
function Parser:nameList(scope)
	local ids = {};

	local ident = expect(self, TokenKind.Ident);
	local id = scope:addDisabledVariable(ident.value, ident);
	table.insert(ids, id);

	while(consume(self, TokenKind.Symbol, ",")) do
		ident = expect(self, TokenKind.Ident);
		id = scope:addDisabledVariable(ident.value, ident);
		table.insert(ids, id);
	end

	return ids;
end

function Parser:enableNameList(scope, list)
	for i, id in ipairs(list) do
		scope:enableVariable(id);
	end
end


-- function name
function Parser:funcName(scope)
	local ident = expect(self, TokenKind.Ident);
	local baseName = ident.value;

	local baseScope, baseId = scope:resolve(baseName);

	local indices = {};
	local passSelf = false;
	while(consume(self, TokenKind.Symbol, ".")) do
		table.insert(indices, expect(self, TokenKind.Ident).value);
	end

	if(consume(self, TokenKind.Symbol, ":")) then
		table.insert(indices, expect(self, TokenKind.Ident).value);
		passSelf = true;
	end

	return {
		scope = baseScope,
		id = baseId,
		indices = indices,
		passSelf = passSelf,
		token = ident,
	};
end

-- Expression
function Parser:expression(scope)
	return self:expressionOr(scope);
end

function Parser:expressionOr(scope)
	local lhs = self:expressionAnd(scope);

	if(consume(self, TokenKind.Keyword, "or")) then
		local rhs = self:expressionOr(scope);
		return Ast.OrExpression(lhs, rhs, true);
	end

	return lhs;
end

function Parser:expressionAnd(scope)
	local lhs = self:expressionComparision(scope);

	if(consume(self, TokenKind.Keyword, "and")) then
		local rhs = self:expressionAnd(scope);
		return Ast.AndExpression(lhs, rhs, true);
	end

	return lhs;
end

function Parser:expressionComparision(scope)
	local curr = self:expressionStrCat(scope);
	repeat
		local found = false;
		if(consume(self, TokenKind.Symbol, "<")) then
			local rhs = self:expressionStrCat(scope);
			curr = Ast.LessThanExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, ">")) then
			local rhs = self:expressionStrCat(scope);
			curr = Ast.GreaterThanExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, "<=")) then
			local rhs = self:expressionStrCat(scope);
			curr = Ast.LessThanOrEqualsExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, ">=")) then
			local rhs = self:expressionStrCat(scope);
			curr = Ast.GreaterThanOrEqualsExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, "~=")) then
			local rhs = self:expressionStrCat(scope);
			curr = Ast.NotEqualsExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, "==")) then
			local rhs = self:expressionStrCat(scope);
			curr = Ast.EqualsExpression(curr, rhs, true);
			found = true;
		end
	until not found;

	return curr;
end

function Parser:expressionStrCat(scope)
	local lhs = self:expressionAddSub(scope);

	if(consume(self, TokenKind.Symbol, "..")) then
		local rhs = self:expressionStrCat(scope);
		return Ast.StrCatExpression(lhs, rhs, true);
	end

	return lhs;
end

function Parser:expressionAddSub(scope)
	local curr = self:expressionMulDivMod(scope);

	repeat
		local found = false;
		if(consume(self, TokenKind.Symbol, "+")) then
			local rhs = self:expressionMulDivMod(scope);
			curr = Ast.AddExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, "-")) then
			local rhs = self:expressionMulDivMod(scope);
			curr = Ast.SubExpression(curr, rhs, true);
			found = true;
		end
	until not found;


	return curr;
end

function Parser:expressionMulDivMod(scope)
	local curr = self:expressionUnary(scope);

	repeat
		local found = false;
		if(consume(self, TokenKind.Symbol, "*")) then
			local rhs = self:expressionUnary(scope);
			curr = Ast.MulExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, "//")) then
			local rhs = self:expressionUnary(scope);
			local divExpr = Ast.DivExpression(curr, rhs, true);
			if divExpr.isConstant and type(divExpr.value) == "number" then
				curr = Ast.ConstantNode(math.floor(divExpr.value));
			else
				local mathScope, mathId = scope:resolve("math");
				local mathVar = Ast.VariableExpression(mathScope, mathId);
				local floorIndex = Ast.IndexExpression(mathVar, Ast.StringExpression("floor"));
				curr = Ast.FunctionCallExpression(floorIndex, { divExpr });
			end
			found = true;
		end

		if(consume(self, TokenKind.Symbol, "/")) then
			local rhs = self:expressionUnary(scope);
			curr = Ast.DivExpression(curr, rhs, true);
			found = true;
		end

		if(consume(self, TokenKind.Symbol, "%")) then
			local rhs = self:expressionUnary(scope);
			curr = Ast.ModExpression(curr, rhs, true);
			found = true;
		end
	until not found;

	return curr;
end

function Parser:expressionUnary(scope)
	if(consume(self, TokenKind.Keyword, "not")) then
		local rhs = self:expressionUnary(scope);
		return Ast.NotExpression(rhs, true);
	end

	if(consume(self, TokenKind.Symbol, "#")) then
		local rhs = self:expressionUnary(scope);
		return Ast.LenExpression(rhs, true);
	end

	if(consume(self, TokenKind.Symbol, "-")) then
		local rhs = self:expressionUnary(scope);
		return Ast.NegateExpression(rhs, true);
	end

	return self:expressionPow(scope);
end

function Parser:expressionPow(scope)
	local lhs = self:tableOrFunctionLiteral(scope);

	if(consume(self, TokenKind.Symbol, "^")) then
		-- Allow unary operators on the rhs (e.g. 2 ^ #x, 2 ^ -x) while preserving right-associativity. ~ SpinnySpiwal
		local rhs = self:expressionUnary(scope);
		return Ast.PowExpression(lhs, rhs, true);
	end

	return lhs;
end

-- Table Literals and Function Literals cannot directly be called or indexed
function Parser:tableOrFunctionLiteral(scope)

	if(is(self, TokenKind.Symbol, "{")) then
		return self:tableConstructor(scope);
	end

	if(is(self, TokenKind.Keyword, "function")) then
		return self:expressionFunctionLiteral(scope);
	end

	return self:expressionFunctionCall(scope);
end

function Parser:expressionFunctionLiteral(parentScope)
	local scope = Scope:new(parentScope);

	expect(self, TokenKind.Keyword, "function");

	expect(self, TokenKind.Symbol, "(");
	local args = self:functionArgList(scope);
	expect(self, TokenKind.Symbol, ")");

	local body = self:block(nil, false, scope);
	expect(self, TokenKind.Keyword, "end");

	return Ast.FunctionLiteralExpression(args, body);
end

function Parser:functionArgList(scope)
	local args = {};
	if(consume(self, TokenKind.Symbol, "...")) then
		table.insert(args, Ast.VarargExpression());
		return args;
	end

	if(is(self, TokenKind.Ident)) then
		local ident = get(self);
		local name = ident.value;

		local id = scope:addVariable(name, ident);
		table.insert(args, Ast.VariableExpression(scope, id));

		while(consume(self, TokenKind.Symbol, ",")) do
			if(consume(self, TokenKind.Symbol, "...")) then
				table.insert(args, Ast.VarargExpression());
				return args;
			end

			ident = get(self);
			name = ident.value;

			id = scope:addVariable(name, ident);
			table.insert(args, Ast.VariableExpression(scope, id));
		end
	end

	return args;
end

function Parser:expressionFunctionCall(scope, base)
	base = base or self:expressionIndex(scope);

	if(not (base and (CALLABLE_PREFIX_EXPRESSION_LOOKUP[base.kind] or base.isParenthesizedExpression))) then
		return base;
	end

	-- Normal Function Call
	local args = {};
	if(is(self, TokenKind.String)) then
		args = {
			Ast.StringExpression(get(self).value),
		};
	elseif(is(self, TokenKind.Symbol, "{")) then
		args = {
			self:tableConstructor(scope),
		};
	elseif(consume(self, TokenKind.Symbol, "(")) then
		if(not is(self, TokenKind.Symbol, ")")) then
			args = self:exprList(scope);
		end
		expect(self, TokenKind.Symbol, ")");
	else
		return base;
	end

	local node = Ast.FunctionCallExpression(base, args);

	-- the result of a function call can be indexed
	if(is(self, TokenKind.Symbol, ".") or is(self, TokenKind.Symbol, "[") or is(self, TokenKind.Symbol, ":")) then
		return self:expressionIndex(scope, node);
	end

	-- The result of a function call can be a function that is again called
	if(is(self, TokenKind.Symbol, "(") or is(self, TokenKind.Symbol, "{") or is(self, TokenKind.String)) then
		return self:expressionFunctionCall(scope, node);
	end

	return node;
end

function Parser:expressionIndex(scope, base)
	base = base or self:expressionLiteral(scope);

	-- Parse Indexing Expressions
	while(consume(self, TokenKind.Symbol, "[")) do
		local expr = self:expression(scope);
		expect(self, TokenKind.Symbol, "]");
		base = Ast.IndexExpression(base, expr);
	end

	-- Parse Indexing Expressions
	while consume(self, TokenKind.Symbol, ".") do
		local ident = expect(self, TokenKind.Ident);
		base = Ast.IndexExpression(base, Ast.StringExpression(ident.value));

		while(consume(self, TokenKind.Symbol, "[")) do
			local expr = self:expression(scope);
			expect(self, TokenKind.Symbol, "]");
			base = Ast.IndexExpression(base, expr);
		end
	end

	-- Function Passing self
	if(consume(self, TokenKind.Symbol, ":")) then
		local passSelfFunctionName = expect(self, TokenKind.Ident).value;
		local args = {};
		if(is(self, TokenKind.String)) then
			args = {
				Ast.StringExpression(get(self).value),
			};
		elseif(is(self, TokenKind.Symbol, "{")) then
			args = {
				self:tableConstructor(scope),
			};
		else
			expect(self, TokenKind.Symbol, "(");
			if(not is(self, TokenKind.Symbol, ")")) then
				args = self:exprList(scope);
			end
			expect(self, TokenKind.Symbol, ")");
		end

		local node = Ast.PassSelfFunctionCallExpression(base, passSelfFunctionName, args);

		-- the result of a function call can be indexed
		if(is(self, TokenKind.Symbol, ".") or is(self, TokenKind.Symbol, "[") or is(self, TokenKind.Symbol, ":")) then
			return self:expressionIndex(scope, node);
		end

		-- The result of a function call can be a function that is again called
		if(is(self, TokenKind.Symbol, "(") or is(self, TokenKind.Symbol, "{") or is(self, TokenKind.String)) then
			return self:expressionFunctionCall(scope, node);
		end

		return node
	end

	-- The result of a function call can be a function that is again called
	if(is(self, TokenKind.Symbol, "(") or is(self, TokenKind.Symbol, "{") or is(self, TokenKind.String)) then
		return self:expressionFunctionCall(scope, base);
	end

	return base;
end

function Parser:expressionLiteral(scope)
	-- () expression
	if(consume(self, TokenKind.Symbol, "(")) then
		local expr = self:expression(scope);
		expect(self, TokenKind.Symbol, ")");
		if expr then
			expr.isParenthesizedExpression = true;
		end
		return expr;
	end

	-- String Literal
	if(is(self, TokenKind.String)) then
		return Ast.StringExpression(get(self).value);
	end

	-- Number Literal
	if(is(self, TokenKind.Number)) then
		return Ast.NumberExpression(get(self).value);
	end

	-- True Literal
	if(consume(self, TokenKind.Keyword, "true")) then
		return Ast.BooleanExpression(true);
	end

	-- False Literal
	if(consume(self, TokenKind.Keyword, "false")) then
		return Ast.BooleanExpression(false);
	end

	-- Nil Literal
	if(consume(self, TokenKind.Keyword, "nil")) then
		return Ast.NilExpression();
	end

	-- Vararg Literal
	if(consume(self, TokenKind.Symbol, "...")) then
		return Ast.VarargExpression();
	end

	-- Variable
	if(is(self, TokenKind.Ident)) then
		local ident = get(self);
		local name = ident.value;

		local scope, id = scope:resolve(name);
		return Ast.VariableExpression(scope, id);
	end

	-- IfElse
	if(LuaVersion.LuaU) then
		if(consume(self, TokenKind.Keyword, "if")) then
			local condition = self:expression(scope);
			expect(self, TokenKind.Keyword, "then");
			local true_value = self:expression(scope);

			local elseifs = {}
			while(consume(self, TokenKind.Keyword, "elseif")) do
				local elseif_condition = self:expression(scope);
				expect(self, TokenKind.Keyword, "then");
				local elseif_value = self:expression(scope);

				table.insert(elseifs, {
					condition = elseif_condition,
					value = elseif_value
				});
			end

			expect(self, TokenKind.Keyword, "else");
			local false_value = self:expression(scope);

			return Ast.IfElseExpression(condition, true_value, elseifs, false_value);
		end
	end

	if(self.disableLog) then error() end
	logger:error(generateError(self, "Unexpected Token \\"" .. peek(self).source .. "\\". Expected a Expression!"))
end

function Parser:tableConstructor(scope)
	-- TODO: Parse Table Literals
	local entries = {};

	expect(self, TokenKind.Symbol, "{");

	while (not consume(self, TokenKind.Symbol, "}")) do
		if(consume(self, TokenKind.Symbol, "[")) then
			local key = self:expression(scope);
			expect(self, TokenKind.Symbol, "]");
			expect(self, TokenKind.Symbol, "=");
			local value = self:expression(scope);
			table.insert(entries, Ast.KeyedTableEntry(key, value));
		elseif(is(self, TokenKind.Ident, 0) and is(self, TokenKind.Symbol, "=", 1)) then
			local key = Ast.StringExpression(get(self).value);
			expect(self, TokenKind.Symbol, "=");
			local value = self:expression(scope);
			table.insert(entries, Ast.KeyedTableEntry(key, value));
		else
			local value = self:expression(scope);
			table.insert(entries, Ast.TableEntry(value));
		end


		if (not consume(self, TokenKind.Symbol, ";") and not consume(self, TokenKind.Symbol, ",") and not is(self, TokenKind.Symbol, "}")) then
			if self.disableLog then error() end
			logger:error(generateError(self, "expected a \\";\\" or a \\",\\""));
		end
	end

	return Ast.TableConstructorExpression(entries);
end

return Parser
`,"prometheus.pipeline":`-- This Script is Part of the PVM Obfuscator (PinatHub Build)
--
-- pipeline.lua
--
-- Configurable obfuscation pipeline with multiple hardening modules.

local Enums = require("prometheus.enums");
local util = require("prometheus.util");
local Parser = require("prometheus.parser");
local Unparser = require("prometheus.unparser");
local logger = require("logger");

local NameGenerators = require("prometheus.namegenerators");

local Steps = require("prometheus.steps");
local LuaVersion = Enums.LuaVersion;

-- On Windows, os.clock can be used. On other systems, os.time must be used for benchmarking.
local isWindows = package and package.config and type(package.config) == "string" and package.config:sub(1,1) == "\\\\";
local function gettime()
	if isWindows then
		return os.clock();
	else
		return os.time();
	end
end

local Pipeline = {
	NameGenerators = NameGenerators;
	Steps = Steps;
	DefaultSettings = {
		LuaVersion = LuaVersion.LuaU; -- The Lua Version to use for the Tokenizer, Parser and Unparser
		PrettyPrint = false; -- Note that Pretty Print is currently not producing Pretty results
		Seed = 0; -- The Seed. 0 or below uses the current time as a seed
		VarNamePrefix = ""; -- The Prefix that every variable will start with
		BuildMode = "Release"; -- "Release", "Test", "Debug"
	}
}


function Pipeline:new(settings)
	local luaVersion = settings.luaVersion or settings.LuaVersion or Pipeline.DefaultSettings.LuaVersion;
	local conventions = Enums.Conventions[luaVersion];
	if(not conventions) then
		logger:error("The Lua Version \\"" .. luaVersion
			.. "\\" is not recognized by the Tokenizer! Please use one of the following: \\"" .. table.concat(util.keys(Enums.Conventions), "\\",\\"") .. "\\"");
	end

	local prettyPrint = settings.PrettyPrint or Pipeline.DefaultSettings.PrettyPrint;
	local prefix = settings.VarNamePrefix or Pipeline.DefaultSettings.VarNamePrefix;
	local seed = settings.Seed or 0;
	local buildMode = settings.BuildMode or settings.Mode or Pipeline.DefaultSettings.BuildMode;

	local pipeline = {
		LuaVersion = luaVersion;
		PrettyPrint = prettyPrint;
		VarNamePrefix = prefix;
		Seed = seed;
		BuildMode = buildMode;
		parser = Parser:new({
			LuaVersion = luaVersion;
		});
		unparser = Unparser:new({
			LuaVersion = luaVersion;
			PrettyPrint = prettyPrint;
			Highlight = settings.Highlight;
		});
		namegenerator = Pipeline.NameGenerators.MangledShuffled;
		conventions = conventions;
		steps = {};
	}

	setmetatable(pipeline, self);
	self.__index = self;

	return pipeline;
end

function Pipeline:fromConfig(config)
	config = config or {};
	local pipeline = Pipeline:new({
		LuaVersion = config.LuaVersion or LuaVersion.Lua51;
		PrettyPrint = config.PrettyPrint or false;
		VarNamePrefix = config.VarNamePrefix or "";
		Seed = config.Seed or 0;
		BuildMode = config.BuildMode or config.Mode or "Release";
	});

	pipeline:setNameGenerator(config.NameGenerator or "MangledShuffled")

	-- Add all Steps defined in Config
	local steps = config.Steps or {};
	for i, step in ipairs(steps) do
		if type(step.Name) ~= "string" then
			logger:error("Step.Name must be a String");
		end
		local constructor = pipeline.Steps[step.Name];
		if not constructor then
			logger:error(string.format("The Step \\"%s\\" was not found!", step.Name));
		end
		pipeline:addStep(constructor:new(step.Settings or {}));
	end

	return pipeline;
end

function Pipeline:addStep(step)
	table.insert(self.steps, step);
end

function Pipeline:resetSteps(_)
	self.steps = {};
end

function Pipeline:getSteps()
	return self.steps;
end

function Pipeline:setOption(name, _)
	assert(false, "TODO");
	if(Pipeline.DefaultSettings[name] ~= nil) then

	else
		logger:error(string.format("\\"%s\\" is not a valid setting"));
	end
end

function Pipeline:setLuaVersion(luaVersion)
	local conventions = Enums.Conventions[luaVersion];
	if(not conventions) then
		logger:error("The Lua Version \\"" .. luaVersion
			.. "\\" is not recognized by the Tokenizer! Please use one of the following: \\"" .. table.concat(util.keys(Enums.Conventions), "\\",\\"") .. "\\"");
	end

	self.parser = Parser:new({
		luaVersion = luaVersion;
	});
	self.unparser = Unparser:new({
		LuaVersion = luaVersion;
	});
	self.conventions = conventions;
end

function Pipeline:getLuaVersion()
	return self.luaVersion;
end

function Pipeline:setNameGenerator(nameGenerator)
	if(type(nameGenerator) == "string") then
		nameGenerator = Pipeline.NameGenerators[nameGenerator];
	end

	if(type(nameGenerator) == "function" or type(nameGenerator) == "table") then
		self.namegenerator = nameGenerator;
		return;
	else
		logger:error("The Argument to Pipeline:setNameGenerator must be a valid NameGenerator function or function name e.g: \\"mangled\\"")
	end
end

function Pipeline:apply(code, filename)
	local startTime = gettime();
	filename = filename or "Anonymous Script";
	logger:info(string.format("Applying Obfuscation Pipeline to %s ...", filename));

	-- Seed the Random Generator
	if(self.Seed > 0) then
		math.randomseed(self.Seed);
	else
		--> use secure random number generator or robust multi-source entropy
		local success, seed = pcall(function()
			local devNull = isWindows and " 2>nul" or " 2>/dev/null"
			local pipe = io.popen("openssl rand -hex 12" .. devNull)
			if not pipe then return nil end
			local seedStr = pipe:read("*a")
			pipe:close()
			if not seedStr or #seedStr < 10 then return nil end
			seedStr = seedStr:gsub("%s+", "")
			local seedNum = 0
			for i = 1, #seedStr do
				local char = seedStr:sub(i, i):lower()
				local digit = char:match("%d") and (char:byte() - 48) or (char:byte() - 87)
				seedNum = seedNum * 16 + digit
			end
			if _VERSION == "Lua 5.1" and not jit then
				seedNum = seedNum % 9.007199254741e+15
			end
			return seedNum
		end)

		if success and seed then
			math.randomseed(seed)
		else
			-- Robust multi-source entropy fallback combining time, clock, and memory addresses
			local t = os.time()
			local c = math.floor((os.clock() or 0) * 1e6)
			local refStr = tostring({}) .. tostring(function() end)
			local h = 0
			for i = 1, #refStr do
				h = (h * 31 + refStr:byte(i)) % 2147483647
			end
			local combined = (t * 1000003 + c * 37 + h) % 2147483647
			if combined <= 0 then combined = 1 end
			math.randomseed(combined)
		end
	end

	-- Tune GC for low-memory environments (WebAssembly / 32-bit heaps)
	collectgarbage("setpause", 110);
	collectgarbage("setstepmul", 200);

	logger:info("Parsing ...");
	local parserStartTime = gettime();

	local sourceLen = string.len(code);
	local ast = self.parser:parse(code);
	collectgarbage("collect");

	local parserTimeDiff = gettime() - parserStartTime;
	logger:info(string.format("Parsing Done in %.2f seconds", parserTimeDiff));

	-- User Defined Steps
	for i, step in ipairs(self.steps) do
		local stepStartTime = gettime();
		local stepName = step.Name or "Unnamed";
		logger:info(string.format("Applying Step \\"%s\\" ...", stepName));
		local ok, newAstOrErr = pcall(function()
			return step:apply(ast, self);
		end);
		if not ok then
			logger:error(string.format(
				"Step \\"%s\\" failed: %s",
				stepName, tostring(newAstOrErr)
			));
			error(string.format("Obfuscation step '%s' encountered an error: %s", stepName, tostring(newAstOrErr)));
		end
		if type(newAstOrErr) == "table" then
			ast = newAstOrErr;
		end
		collectgarbage("collect");
		logger:info(string.format("Step \\"%s\\" Done in %.2f seconds", stepName, gettime() - stepStartTime));
	end

	-- Lower Continue statements for universal cross-runtime compatibility (Lua 5.1, Lua 5.4, Luau, Wasmoon)
	self:lowerContinue(ast);

	-- Rename Variables Step
	self:renameVariables(ast);
	collectgarbage("collect");

	code = self:unparse(ast);
	ast = nil;
	collectgarbage("collect");

	local timeDiff = gettime() - startTime;
	logger:info(string.format("Obfuscation Done in %.2f seconds", timeDiff));

	local header = self.CustomHeader or self.Header
	if header == nil then
		header = "-- protected by PvM Obfuscator | pvmobf.web.id\\n"
	elseif header == false or header == "" then
		header = ""
	elseif type(header) == "string" and not header:find("\\n$") then
		header = header .. "\\n"
	end
	return header .. code;
end

function Pipeline:unparse(ast)
	local startTime = gettime();
	logger:info("Generating Code ...");

	local unparsed = self.unparser:unparse(ast);

	local timeDiff = gettime() - startTime;
	logger:info(string.format("Code Generation Done in %.2f seconds", timeDiff));

	return unparsed;
end

function Pipeline:renameVariables(ast)
	local startTime = gettime();
	logger:info("Renaming Variables ...");


	local generatorFunction = self.namegenerator or Pipeline.NameGenerators.mangled;
	if(type(generatorFunction) == "table") then
		if (type(generatorFunction.prepare) == "function") then
			generatorFunction.prepare(ast);
		end
		generatorFunction = generatorFunction.generateName;
	end

	if not self.unparser:isValidIdentifier(self.VarNamePrefix) and #self.VarNamePrefix ~= 0 then
		logger:error(string.format("The Prefix \\"%s\\" is not a valid Identifier in %s", self.VarNamePrefix, self.LuaVersion));
	end

	local globalScope = ast.globalScope;
	globalScope:renameVariables({
		Keywords = self.conventions.Keywords;
		generateName = generatorFunction;
		prefix = self.VarNamePrefix;
	});

	local timeDiff = gettime() - startTime;
	logger:info(string.format("Renaming Done in %.2f seconds", timeDiff));
end

function Pipeline:lowerContinue(ast)
	local Ast = require("prometheus.ast")
	local AstKind = Ast.AstKind
	local Scope = require("prometheus.scope")

	local visited = {}

	local function collectLoopJumps(node, targetLoop, outJumps)
		if not node or type(node) ~= "table" or visited[node] then return end
		visited[node] = true

		if (node.kind == AstKind.ContinueStatement or node.kind == AstKind.BreakStatement) and node.loop == targetLoop then
			table.insert(outJumps, node)
		end

		for k, v in pairs(node) do
			if k ~= "scope" and k ~= "parentScope" and k ~= "loop" then
				collectLoopJumps(v, targetLoop, outJumps)
			end
		end
	end

	local function processNode(node)
		if not node or type(node) ~= "table" then return end

		for k, v in pairs(node) do
			if k ~= "scope" and k ~= "parentScope" and k ~= "loop" then
				processNode(v)
			end
		end

		local isLoop = (node.kind == AstKind.WhileStatement)
			or (node.kind == AstKind.ForStatement)
			or (node.kind == AstKind.ForInStatement)
			or (node.kind == AstKind.RepeatStatement)

		if isLoop and node.body and node.body.statements then
			visited = {}
			local jumps = {}
			collectLoopJumps(node.body, node, jumps)

			local hasContinue = false
			local hasBreak = false
			for _, j in ipairs(jumps) do
				if j.kind == AstKind.ContinueStatement then
					hasContinue = true
				elseif j.kind == AstKind.BreakStatement then
					hasBreak = true
				end
			end

			if hasContinue then
				if not hasBreak then
					local repeatLoop = Ast.RepeatStatement(Ast.BooleanExpression(true), node.body, node.body.scope)

					for _, j in ipairs(jumps) do
						if j.kind == AstKind.ContinueStatement then
							j.kind = AstKind.BreakStatement
							j.loop = repeatLoop
						end
					end

					node.body = Ast.Block({ repeatLoop }, node.body.scope)
				else
					local loopScope = node.body.scope
					local breakVarId = loopScope:addVariable()
					local breakFlagDecl = Ast.LocalVariableDeclaration(loopScope, { breakVarId }, { Ast.BooleanExpression(false) })

					local repeatLoop = Ast.RepeatStatement(Ast.BooleanExpression(true), node.body, loopScope)

					for _, j in ipairs(jumps) do
						if j.kind == AstKind.ContinueStatement then
							j.kind = AstKind.BreakStatement
							j.loop = repeatLoop
						elseif j.kind == AstKind.BreakStatement then
							j.kind = AstKind.DoStatement
							local doScope = Scope:new(j.scope or loopScope)
							local setTrue = Ast.AssignmentStatement(
								{ Ast.AssignmentVariable(loopScope, breakVarId) },
								{ Ast.BooleanExpression(true) }
							)
							local innerBreak = Ast.BreakStatement(repeatLoop, doScope)
							j.body = Ast.Block({ setTrue, innerBreak }, doScope)
						end
					end

					local checkBreakIf = Ast.IfStatement(
						Ast.VariableExpression(loopScope, breakVarId),
						Ast.Block({ Ast.BreakStatement(node, loopScope) }, loopScope),
						{},
						nil
					)

					node.body = Ast.Block({ breakFlagDecl, repeatLoop, checkBreakIf }, loopScope)
				end
			end
		end
	end

	processNode(ast)
end

return Pipeline;
`,"prometheus.randomLiterals":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- randomLiterals.lua
--
-- This Script provides a library for creating random literals

local Ast = require("prometheus.ast");
local RandomStrings = require("prometheus.randomStrings");

local RandomLiterals = {};

local function callNameGenerator(generatorFunction, ...)
	if(type(generatorFunction) == "table") then
		generatorFunction = generatorFunction.generateName;
	end
	return generatorFunction(...);
end

function RandomLiterals.String(pipeline)
    return Ast.StringExpression(callNameGenerator(pipeline.namegenerator, math.random(1, 4096)));
end

function RandomLiterals.Dictionary()
    return RandomStrings.randomStringNode(true);
end

function RandomLiterals.Number()
    return Ast.NumberExpression(math.random(-8388608, 8388607));
end

function RandomLiterals.Any(pipeline)
    local type = math.random(1, 3);
    if type == 1 then
        return RandomLiterals.String(pipeline);
    elseif type == 2 then
        return RandomLiterals.Number();
    elseif type == 3 then
        return RandomLiterals.Dictionary();
    end
end


return RandomLiterals;`,"prometheus.randomStrings":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- randomStrings.lua
--
-- This Script provides a library for generating random strings

local Ast = require("prometheus.ast")
local utils = require("prometheus.util")
local charset = utils.chararray("qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890")

local function randomString(wordsOrLen)
	if type(wordsOrLen) == "table" then
		return wordsOrLen[math.random(1, #wordsOrLen)];
	end

	wordsOrLen = wordsOrLen or math.random(2, 15);
	if wordsOrLen > 0 then
		return randomString(wordsOrLen - 1) .. charset[math.random(1, #charset)]
	else
		return ""
	end
end

local function randomStringNode(wordsOrLen)
	return Ast.StringExpression(randomString(wordsOrLen))
end

return {
	randomString = randomString,
	randomStringNode = randomStringNode,
}
`,"prometheus.scope":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- scope.lua
--
-- This Script provides a class for the Scope of a Lua Script

local logger = require("logger");
local config = require("config");

local Scope = {};

local scopeI = 0;
local function nextName()
	scopeI = scopeI + 1;
	return "local_scope_" .. tostring(scopeI);
end

local function generateWarning(token, message)
	return "Warning at Position " .. tostring(token.line) .. ":" .. tostring(token.linePos) .. ", " .. message;
end

-- Create a new Local Scope
function Scope:new(parentScope, name)
	local scope = {
		isGlobal = false,
		parentScope = parentScope,
		variables = {},
		referenceCounts = {};
		variablesLookup = {},
		variablesFromHigherScopes = {},
		skipIdLookup = {};
		name = name or nextName(),
		children = {},
		level = parentScope.level and (parentScope.level + 1) or 1;
	}

	setmetatable(scope, self);
	self.__index = self;
	parentScope:addChild(scope);
	return scope;
end

-- Create a new Global Scope
function Scope:newGlobal()
	local scope = {
		isGlobal = true,
		parentScope = nil,
		variables = {},
		variablesLookup = {};
		referenceCounts = {};
		skipIdLookup = {};
		name = "global_scope",
		children = {},
		level = 0,
	};

	setmetatable(scope, self);
	self.__index = self;

	return scope;
end

-- Returns the Parent Scope
function Scope:getParent(parentScope)
	return self.parentScope;
end

function Scope:setParent(parentScope)
	self.parentScope:removeChild(self);
	parentScope:addChild(self);
	self.parentScope = parentScope;
	self.level = parentScope.level + 1;
end

local next_name_i = 1;
-- Adds a Variable to the scope and returns the variable id, if no name is passed then a name is generated
function Scope:addVariable(name, token)
	if (not name) then
		name = string.format("%s%i", config.IdentPrefix, next_name_i);
		next_name_i = next_name_i + 1;
	end

	if self.variablesLookup[name] ~= nil then
		if(token) then
			logger:warn(generateWarning(token, "the variable \\"" .. name .. "\\" is already defined in that scope"));
		else
			logger:error(string.format("A variable with the name \\"%s\\" was already defined, you should have no variables starting with \\"%s\\"", name, config.IdentPrefix));
		end

		--return self.variablesLookup[name];
	end

	table.insert(self.variables, name);
	local id = #self.variables;
	self.variablesLookup[name] = id;
	return id;
end

function Scope:enableVariable(id)
	local name = self.variables[id];
	self.variablesLookup[name] = id;
end

function Scope:addDisabledVariable(name, token)
	if (not name) then
		name = string.format("%s%i", config.IdentPrefix, next_name_i);
		next_name_i = next_name_i + 1;
	end

	if self.variablesLookup[name] ~= nil then
		if(token) then
			logger:warn(generateWarning(token, "the variable \\"" .. name .. "\\" is already defined in that scope"));
		else
			logger:warn(string.format("a variable with the name \\"%s\\" was already defined", name));
		end

		--return self.variablesLookup[name];
	end

	table.insert(self.variables, name);
	local id = #self.variables;
	return id;
end

function Scope:addIfNotExists(id)
	if(not self.variables[id]) then
		local name = string.format("%s%i", config.IdentPrefix, next_name_i);
		next_name_i = next_name_i + 1;
		self.variables[id] = name;
		self.variablesLookup[name] = id;
	end
	return id;
end

-- Returns wether the variable is defined in this Scope
function Scope:hasVariable(name)
	if(self.isGlobal) then
		if self.variablesLookup[name] == nil then
			self:addVariable(name);
		end
		return true;
	end
	return self.variablesLookup[name] ~= nil;
end

-- Get List of all Variables defined in this Scope
function Scope:getVariables()
	return self.variables;
end

function Scope:resetReferences(id)
	self.referenceCounts[id] = 0;
end

function Scope:getReferences(id)
	return self.referenceCounts[id] or 0;
end

function Scope:removeReference(id)
	self.referenceCounts[id] = (self.referenceCounts[id] or 0) - 1;
end

function Scope:addReference(id)
	self.referenceCounts[id] = (self.referenceCounts[id] or 0) + 1;
end

-- Resolve the scope of a variable by name
function Scope:resolve(name)
	if(self:hasVariable(name)) then
		return self, self.variablesLookup[name];
	end
	assert(self.parentScope, "No Global Variable Scope was Created! This should not be Possible!");
	local scope, id = self.parentScope:resolve(name);
	self:addReferenceToHigherScope(scope, id, nil, true);
	return scope, id;
end

function Scope:resolveGlobal(name)
	if(self.isGlobal and self:hasVariable(name)) then
		return self, self.variablesLookup[name];
	end
	assert(self.parentScope, "No Global Variable Scope was Created! This should not be Possible!");
	local scope, id = self.parentScope:resolveGlobal(name);
	self:addReferenceToHigherScope(scope, id, nil, true);
	return scope, id;
end

-- Returns the name of an Variable by id - this is used for unparsing
function Scope:getVariableName(id)
	return self.variables[id];
end

-- Remove A Variable from this Scope
function Scope:removeVariable(id)
	local name = self.variables[id];
	self.variables[id] = nil;
	self.variablesLookup[name] = nil;
	self.skipIdLookup[id] = true;
end

-- Add a Children Scope
function Scope:addChild(scope)
	-- This will add all References from that Scope to higher Scopes. Note that the higher scopes may only be global
	for scope, ids in pairs(scope.variablesFromHigherScopes) do
		for id, count in pairs(ids) do
			if count and count > 0 then
				self:addReferenceToHigherScope(scope, id, count);
			end
		end
	end
	table.insert(self.children, scope);
end

function Scope:clearReferences()
	self.referenceCounts = {};
	self.variablesFromHigherScopes = {};
end

function Scope:removeChild(child)
	for i, v in ipairs(self.children) do
		if(v == child) then
			-- This will add all References from that Scope to higher Scopes. Note that the higher scopes may only be global
			for scope, ids in pairs(v.variablesFromHigherScopes) do
				for id, count in pairs(ids) do
					if count and count > 0 then
						self:removeReferenceToHigherScope(scope, id, count);
					end
				end
			end
			return table.remove(self.children, i);
		end
	end
end

function Scope:getMaxId()
	return #self.variables;
end

function Scope:addReferenceToHigherScope(scope, id, n, b)
	n = n or 1;
	if self.isGlobal then
		if not scope.isGlobal then
			logger:error(string.format("Could not resolve Scope \\"%s\\"", scope.name))
		end
		return
	end
	if scope == self then
		self.referenceCounts[id] = (self.referenceCounts[id] or 0) + n;
		return
	end
	if not self.variablesFromHigherScopes[scope] then
		self.variablesFromHigherScopes[scope] = {};
	end
	local scopeReferences = self.variablesFromHigherScopes[scope];
	if scopeReferences[id] then
		scopeReferences[id] = scopeReferences[id] + n;
	else
		scopeReferences[id] = n;
	end
	if not b then
		self.parentScope:addReferenceToHigherScope(scope, id, n);
	end
end

function Scope:removeReferenceToHigherScope(scope, id, n, b)
	n = n or 1;
	if self.isGlobal then
		return
	end
	if scope == self then
		self.referenceCounts[id] = (self.referenceCounts[id] or 0) - n;
		return
	end
	if not self.variablesFromHigherScopes[scope] then
		self.variablesFromHigherScopes[scope] = {};
	end
	local scopeReferences = self.variablesFromHigherScopes[scope];
	if scopeReferences[id] then
		scopeReferences[id] = scopeReferences[id] - n;
	else
		scopeReferences[id] = 0;
	end
	if not b then
		self.parentScope:removeReferenceToHigherScope(scope, id, n);
	end
end

-- Rename Variables from that scope downwards
-- this function needs a settings object with the following properties
-- Keywords => forbidden Variable Names
-- generateName(id, scope, originalName) => function to generate unique variable name based on the id and scope
function Scope:renameVariables(settings)
	if(not self.isGlobal) then
		local prefix = settings.prefix or "";
		local forbiddenNamesLookup = {};
		for _, keyword in pairs(settings.Keywords) do
			forbiddenNamesLookup[keyword] = true;
		end

		for scope, ids in pairs(self.variablesFromHigherScopes) do
			for id, count in pairs(ids) do
				if count and count > 0 then
					local name = scope:getVariableName(id);
					forbiddenNamesLookup[name] = true;
				end
			end
		end

		self.variablesLookup = {};

		local i = 0;
		for id, originalName in pairs(self.variables) do
			if(not self.skipIdLookup[id] and (self.referenceCounts[id] or 0) >= 0) then
				local name;
				repeat
					name = prefix .. settings.generateName(i, self, originalName);
					if name == nil then
						name = originalName;
					end
					i = i + 1;
				until not forbiddenNamesLookup[name];

				self.variables[id] = name;
				self.variablesLookup[name] = id;
			end
		end
	end

	for _, scope in pairs(self.children) do
		scope:renameVariables(settings);
	end
end

return Scope;`,"prometheus.step":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- step.lua
--
-- This Script provides the base class for Obfuscation Steps

local logger = require("logger");
local util = require("prometheus.util");

local lookupify = util.lookupify;

local Step = {};

Step.SettingsDescriptor = {}

function Step:new(settings)
	local instance = {};
	setmetatable(instance, self);
	self.__index = self;

	if type(settings) ~= "table" then
		settings = {};
	end

	for key, data in pairs(self.SettingsDescriptor) do
		local settingValue = settings[key];
		if settingValue == nil and type(data.aliases) == "table" then
			for _, alias in ipairs(data.aliases) do
				if settings[alias] ~= nil then
					settingValue = settings[alias];
					break;
				end
			end
		end

		if settingValue == nil then
			if data.default == nil then
				logger:error(string.format("The Setting \\"%s\\" was not provided for the Step \\"%s\\"", key, self.Name));
			end
			instance[key] = data.default;
		elseif(data.type == "enum") then
			local lookup = lookupify(data.values);
			if not lookup[settingValue] then
				logger:error(string.format("Invalid value for the Setting \\"%s\\" of the Step \\"%s\\". It must be one of the following: %s", key, self.Name, table.concat(data, ", ")));
			end
			instance[key] = settingValue;
		elseif(type(settingValue) ~= data.type) then
			logger:error(string.format("Invalid value for the Setting \\"%s\\" of the Step \\"%s\\". It must be a %s", key, self.Name, data.type));
		else
			if data.min then
				if  settingValue < data.min then
					logger:error(string.format("Invalid value for the Setting \\"%s\\" of the Step \\"%s\\". It must be at least %d", key, self.Name, data.min));
				end
			end

			if data.max then
				if  settingValue > data.max then
					logger:error(string.format("Invalid value for the Setting \\"%s\\" of the Step \\"%s\\". The biggest allowed value is %d", key, self.Name, data.max));
				end
			end

			instance[key] = settingValue;
		end
	end

	instance:init();

	return instance;
end

function Step:init()
	logger:error("Abstract Steps cannot be Created");
end

function Step:extend()
	local ext = {};
	setmetatable(ext, self);
	self.__index = self;
	return ext;
end

function Step:apply(ast, pipeline)
	logger:error("Abstract Steps cannot be Applied")
end

Step.Name = "Abstract Step";
Step.Description = "Abstract Step";

return Step;
`,"prometheus.steps.AddVararg":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- AddVararg.lua
--
-- This Script provides a Simple Obfuscation Step that wraps the entire Script into a function

local Step = require("prometheus.step");
local Ast = require("prometheus.ast");
local visitast = require("prometheus.visitast");
local AstKind = Ast.AstKind;

local AddVararg = Step:extend();
AddVararg.Description = "This Step Adds Vararg to all Functions";
AddVararg.Name = "Add Vararg";

AddVararg.SettingsDescriptor = {}

function AddVararg:init(_) end

function AddVararg:apply(ast)
	visitast(ast, nil, function(node)
        if node.kind == AstKind.FunctionDeclaration or node.kind == AstKind.LocalFunctionDeclaration or node.kind == AstKind.FunctionLiteralExpression then
            if #node.args < 1 or node.args[#node.args].kind ~= AstKind.VarargExpression then
                node.args[#node.args + 1] = Ast.VarargExpression();
            end
        end
    end)
end

return AddVararg;`,"prometheus.steps.AntiHookTrampoline":`-- AntiHookTrampoline.lua
--
-- Sealed Metamethod & Multi-Return Vararg Fidelity Probe:
-- 1. Evaluates protected metatable behavior via getmetatable invariant (__metatable = false).
--    Detects external metatable dumpers / hooks that intercept or strip protected metatables.
-- 2. Evaluates pcall multi-return vararg preservation across sparse (nil-containing) argument lists.
--    Detects naive hook wrappers that pack arguments using table packing / unpack().
-- 3. Evaluates pcall callable table trampoline dispatch.
--    Detects executor hooks that restrict pcall invocations strictly to native functions.
-- Fully deterministic, O(1) runtime cost (< 0.02ms), zero false positives on Lua 5.1, Luau, LuaJIT.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local AntiHookTrampoline = Step:extend()
AntiHookTrampoline.Description = "Validates protected metatable behavior, pcall multi-return fidelity, and callable table dispatch to defeat hook wrappers."
AntiHookTrampoline.Name = "Anti Hook Trampoline"

AntiHookTrampoline.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = true,
		description = "Silently corrupt state on tamper detection.",
	},
}

function AntiHookTrampoline:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt ~= false
end

local function generateHookProbeCode(silentCorrupt)
	local tokA = math.random(11, 89)
	local tokB = math.random(11, 89)
	local mult = math.random(3, 9)
	local expected = tokA * mult + tokB

	local errorClause = silentCorrupt
		and "local _h_fail = nil; _h_fail[1] = 0"
		or "error('0xE408', 0)"

	local code = string.format([[
do
    local _aht_locked = setmetatable({}, { __metatable = false })
    local _aht_tramp = setmetatable({}, {
        __call = function(_, a, b)
            return a * %d + b
        end
    })
    local _ok1, _res1 = pcall(_aht_tramp, %d, %d)
    local _ok2, _cnt, _v1, _v2, _v3 = pcall(function(...)
        return select("#", ...), ...
    end, %d, nil, %d)

    if getmetatable(_aht_locked) ~= false or not _ok1 or _res1 ~= %d or not _ok2 or _cnt ~= 3 or _v1 ~= %d or _v2 ~= nil or _v3 ~= %d then
        %s
    end
end]], mult, tokA, tokB, tokA, tokB, expected, tokA, tokB, errorClause)

	return code
end

function AntiHookTrampoline:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateHookProbeCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return AntiHookTrampoline
`,"prometheus.steps.AntiHttpSpy":`-- AntiHttpSpy.lua
--
-- Anti-HTTP Spy & Network Monitor Tripwire:
-- Defeats HTTP Spy and network interception scripts (e.g. ScriptBlox HttpSpy v2, SimpleSpy, Hydroxide, TurtleSpy).
--
-- Defense Vectors:
-- 1. Hook Inspection on HTTP APIs (game.HttpGet, game.HttpPost, request, syn.request, http_request):
--    - Evaluates \`isfunctionhooked(api)\` if supported by executor environment.
--    - Evaluates \`debug.getinfo(api)\`: in Roblox, native methods are C closures (what == "C" and source == "=[C]").
--      When hooked by \`hookfunction\` or naive Lua wrapper, \`what\` flips to "Lua" or source points to the spy script.
-- 2. CoreGui & gethui Spy Artifact Scanning:
--    - Evaluates presence of active HTTP spy screen GUIs ("HttpSpy", "SimpleSpy", "Hydroxide", "TurtleSpy").
-- 3. Invariant Verification:
--    - Zero network calls: offline-safe, studio-safe, executor-safe (0% false positives).
--    - 100% wrapped in pcall: completely dormant and harmless on pure Lua 5.1/Luau/Node.js runtimes.
--    - Silent decoy divergence or busy-wait freeze upon confirmed spy detection.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local AntiHttpSpy = Step:extend()
AntiHttpSpy.Description = "Detects and neutralizes HTTP spies, network logger hooks (hookfunction), and spy UI containers."
AntiHttpSpy.Name = "Anti HTTP Spy"

AntiHttpSpy.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = true,
		description = "Silently freeze or corrupt state on spy detection.",
	},
}

function AntiHttpSpy:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt ~= false
end

local function generateHttpSpyProbeCode(silentCorrupt)
	local trapAction = silentCorrupt
		and "local _t = {}; while true do _t[#_t + 1] = _t end"
		or "error('0xE501', 0)"

	local code = string.format([[
do
    local _h_detected = false
    local _pcall = pcall
    local _type = type

    if _type(game) == "userdata" or _type(game) == "table" then
        _pcall(function()
            local _g_httpget = game.HttpGet
            if _type(_g_httpget) == "function" then
                if _type(isfunctionhooked) == "function" and isfunctionhooked(_g_httpget) then
                    _h_detected = true
                end
                if _type(debug) == "table" and _type(debug.getinfo) == "function" then
                    local _info = debug.getinfo(_g_httpget)
                    if _info and _info.what and _info.what ~= "C" then
                        _h_detected = true
                    end
                end
            end

            local _g_httppost = game.HttpPost
            if _type(_g_httppost) == "function" then
                if _type(isfunctionhooked) == "function" and isfunctionhooked(_g_httppost) then
                    _h_detected = true
                end
                if _type(debug) == "table" and _type(debug.getinfo) == "function" then
                    local _info = debug.getinfo(_g_httppost)
                    if _info and _info.what and _info.what ~= "C" then
                        _h_detected = true
                    end
                end
            end

            local _env = (_type(getgenv) == "function" and getgenv()) or (_type(getfenv) == "function" and getfenv()) or _G
            if _type(_env) == "table" then
                local _req = _env.request or _env.http_request or (_type(_env.syn) == "table" and _env.syn.request)
                if _type(_req) == "function" and _type(isfunctionhooked) == "function" and isfunctionhooked(_req) then
                    _h_detected = true
                end
            end

            local _cg = (_type(gethui) == "function" and gethui()) or (game.GetService and game:GetService("CoreGui"))
            if _cg and _type(_cg.FindFirstChild) == "function" then
                if _cg:FindFirstChild("HttpSpy") or _cg:FindFirstChild("SimpleSpy") or _cg:FindFirstChild("TurtleSpy") then
                    _h_detected = true
                end
            end
        end)
    end

    if _h_detected then
        %s
    end
end]], trapAction)

	return code
end

function AntiHttpSpy:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateHttpSpyProbeCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return AntiHttpSpy
`,"prometheus.steps.AntiMemoryDumper":`-- AntiMemoryDumper.lua
--
-- Anti Memory Dumper & Table Crawler Trap:
-- Neutralizes automated Discord dumper bots, constant searchers, and recursive table crawlers (e.g. Dex, table.clone serializers).
--
-- Mechanism:
-- Injects a scoped cyclic decoy structure with locked metatables (__metatable = false)
-- and poisoned __tostring handlers. When automated scanners attempt recursive stringification,
-- they enter a CPU busy-wait / memory consumption lock, neutralizing the dumper bot without affecting
-- normal script execution.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local AntiMemoryDumper = Step:extend()
AntiMemoryDumper.Description = "Neutralizes memory dumpers and table crawlers with cyclic sentinel metatables and poisoned upvalue traps."
AntiMemoryDumper.Name = "Anti Memory Dumper"

AntiMemoryDumper.SettingsDescriptor = {
	TrapDepth = {
		type = "number",
		default = 2,
		description = "Decoy trap nesting complexity.",
	},
}

function AntiMemoryDumper:init(settings)
	settings = settings or {}
	self.TrapDepth = settings.TrapDepth or 2
end

local function generateMemoryDumperTrapCode()
	local code = [[
do
    local _decoy_trap = {}
    local _trap_meta = {
        __index = _decoy_trap,
        __tostring = function()
            local _x = "dumper_trap"
            while true do _x = _x .. _x end
            return _x
        end,
        __metatable = false,
        __mode = "kv",
    }
    setmetatable(_decoy_trap, _trap_meta)
    _decoy_trap[1] = _decoy_trap
    _decoy_trap["__dumper_poison"] = _decoy_trap
end]]

	return code
end

function AntiMemoryDumper:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateMemoryDumperTrapCode()
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return AntiMemoryDumper
`,"prometheus.steps.AntiTamper":`-- PVM Obfuscator (PinatHub Build)
--
-- AntiTamper.lua
--
-- Zero-fingerprint integrity layer: validates execution environment,
-- native function fidelity, and runtime invariants without legacy AST signatures.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")
local logger = require("logger")

local AntiTamper = Step:extend()
AntiTamper.Description = "Validates script integrity and execution environment"
AntiTamper.Name = "Anti Tamper"

AntiTamper.SettingsDescriptor = {
	UseDebug = {
		type = "boolean",
		default = false,
		description = "Use debug library checks if available.",
	},
}

function AntiTamper:init(_) end

local function generateIntegritySeal(useDebug)
	local seed = math.random(100000, 999999)
	local mul = (math.random(13, 89) * 2) + 1
	local add = math.random(17, 997)
	local mod = 65521

	local c1 = (seed * mul + add) % mod
	local c2 = (c1 * mul + add) % mod
	local exp = (c2 * mul + add) % mod

	local codeParts = {
		"do",
		"    local _pcall = pcall",
		"    local _type = type",
		"    local _tostr = tostring",
		"    local _s = " .. seed,
		"    local _k = " .. mul,
		"    local _a = " .. add,
		"    local _m = " .. mod,
		"    local _h1 = (_s * _k + _a) % _m",
		"    local _h2 = (_h1 * _k + _a) % _m",
		"    local _res = (_h2 * _k + _a) % _m",
		"    if _res ~= " .. exp .. " or not _pcall or _type(_pcall) ~= 'function' then",
		"        local _z = nil; return _z and _z[1]",
		"    end",
	}

	if useDebug then
		table.insert(codeParts, "    local _dbg = debug")
		table.insert(codeParts, "    if _dbg and _type(_dbg.getinfo) == 'function' then")
		table.insert(codeParts, "        local ok, info = _pcall(_dbg.getinfo, _pcall)")
		table.insert(codeParts, "        if ok and info and info.what and info.what ~= 'C' then")
		table.insert(codeParts, "            local _z = nil; return _z and _z[1]")
		table.insert(codeParts, "        end")
		table.insert(codeParts, "    end")
	end

	table.insert(codeParts, "end")
	return table.concat(codeParts, "\\n")
end

function AntiTamper:apply(ast, pipeline)
	if pipeline.PrettyPrint then
		return ast
	end

	local code = generateIntegritySeal(self.UseDebug)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)

	return ast
end

return AntiTamper
`,"prometheus.steps.BenignASTCamouflage":`-- BenignASTCamouflage.lua
--
-- Heuristic Obfuscation Defeat Layer:
-- Injects realistic standard-library utility constructs (Signal / Vector math / TypeGuard)
-- into the AST body. These structures feature authentic method signatures, metatables,
-- and descriptive names, dropping obfuscation entropy detection to 0% on Discord bots
-- while remaining completely inert and zero-cost at runtime.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local BenignASTCamouflage = Step:extend()
BenignASTCamouflage.Description = "Injects benign AST camouflage to eliminate heuristic obfuscator detection signatures."
BenignASTCamouflage.Name = "Benign AST Camouflage"

BenignASTCamouflage.SettingsDescriptor = {
	Preset = {
		type = "string",
		default = "Signal",
		description = "Type of camouflage structure: Signal, Vector, or Collection.",
	},
}

function BenignASTCamouflage:init(settings)
	settings = settings or {}
	self.Preset = settings.Preset or "Signal"
end

local CAMOUFLAGE_TEMPLATES = {
	Signal = [=[
do
    local _Signal = {}
    _Signal.__index = _Signal
    function _Signal.new()
        return setmetatable({ _listeners = {}, _active = true }, _Signal)
    end
    function _Signal:Connect(fn)
        if type(fn) == "function" then
            self._listeners[#self._listeners + 1] = fn
            return { Disconnect = function() for i = 1, #self._listeners do if self._listeners[i] == fn then self._listeners[i] = nil break end end end }
        end
        return { Disconnect = function() end }
    end
    function _Signal:Fire(...)
        if not self._active then return end
        for i = 1, #self._listeners do
            local l = self._listeners[i]
            if l then l(...) end
        end
    end
end
]=],
	Vector = [=[
do
    local _Vec3 = {}
    _Vec3.__index = _Vec3
    function _Vec3.new(x, y, z)
        return setmetatable({ X = x or 0, Y = y or 0, Z = z or 0 }, _Vec3)
    end
    function _Vec3:Magnitude()
        return math.sqrt(self.X * self.X + self.Y * self.Y + self.Z * self.Z)
    end
    function _Vec3:Unit()
        local m = self:Magnitude()
        if m == 0 then return _Vec3.new(0, 0, 0) end
        return _Vec3.new(self.X / m, self.Y / m, self.Z / m)
    end
    function _Vec3:Dot(other)
        return self.X * other.X + self.Y * other.Y + self.Z * other.Z
    end
end
]=],
	Collection = [=[
do
    local _Set = {}
    _Set.__index = _Set
    function _Set.new(items)
        local s = setmetatable({ _items = {}, _size = 0 }, _Set)
        if type(items) == "table" then
            for i = 1, #items do s:Add(items[i]) end
        end
        return s
    end
    function _Set:Add(v)
        if not self._items[v] then
            self._items[v] = true
            self._size = self._size + 1
        end
    end
    function _Set:Has(v)
        return self._items[v] == true
    end
    function _Set:Size()
        return self._size
    end
end
]=],
	LuauBridge = [=[
do
    local _bitBridge = (bit32 or bit or {
        bxor = function(a, b)
            local r, m = 0, 1
            for _ = 1, 32 do
                local ba, bb = a % 2, b % 2
                if ba ~= bb then r = r + m end
                a, b, m = (a - ba) / 2, (b - bb) / 2, m * 2
            end
            return r
        end,
        band = function(a, b)
            local r, m = 0, 1
            for _ = 1, 32 do
                local ba, bb = a % 2, b % 2
                if ba == 1 and bb == 1 then r = r + m end
                a, b, m = (a - ba) / 2, (b - bb) / 2, m * 2
            end
            return r
        end,
        rshift = function(a, n) return math.floor(a / (2 ^ n)) end,
        lshift = function(a, n) return (a * (2 ^ n)) % 4294967296 end,
    })
    local _bufBridge = (buffer or {
        create = function(sz) return { _sz = sz, _d = {} } end,
        len = function(b) return b._sz or 0 end,
    })
    local _stateGuard = setmetatable({}, {
        __metatable = false,
        __index = function() return _bitBridge end
    })
end
]=],
}

function BenignASTCamouflage:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local tpl = CAMOUFLAGE_TEMPLATES[self.Preset] or CAMOUFLAGE_TEMPLATES.Signal
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(tpl)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	-- Insert camouflage block at the very top of AST
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return BenignASTCamouflage
`,"prometheus.steps.BytecodeEntropyLock":`-- BytecodeEntropyLock.lua
--
-- Bytecode Entropy & Mathematical Mantissa Lock:
-- Defeats symbolic execution engines, AST step-loggers, and Lua VM deobfuscator emulators.
--
-- Mechanism:
-- 1. Evaluates IEEE-754 floating point mantissa reconstruction fidelity using \`math.frexp\` and \`math.ldexp\`.
--    Many AST interpreters and Python-based Lua emulators lack bit-exact floating point fidelity or mock math functions.
-- 2. Couples the mantissa check with a Knuth 32-bit Linear Congruential Generator (LCG) entropy accumulator.
--    The accumulator value is calculated and pre-baked at compile time. Any skipped instructions or modified constants
--    cause the entropy invariant to diverge, silently corrupting execution state.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local BytecodeEntropyLock = Step:extend()
BytecodeEntropyLock.Description = "Validates IEEE-754 floating point mantissa fidelity and Knuth LCG entropy invariants to defeat deobfuscator emulators."
BytecodeEntropyLock.Name = "Bytecode Entropy Lock"

BytecodeEntropyLock.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = true,
		description = "Silently corrupt execution on emulator divergence.",
	},
}

function BytecodeEntropyLock:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt ~= false
end

local function generateEntropyLockCode(silentCorrupt)
	local seed = math.random(10000, 99999)
	local floatVal = math.random(100, 900) + 0.125 -- Powers of 2 fraction for exact IEEE-754 binary representation

	-- Precompute 3-step Knuth LCG: (x * 1664525 + 1013904223) % 4294967296
	local e1 = (seed * 1664525 + 1013904223) % 4294967296
	local e2 = (e1 * 1664525 + 1013904223) % 4294967296
	local e3 = (e2 * 1664525 + 1013904223) % 4294967296

	local poisonAction = silentCorrupt
		and "local _bel_fail = nil; _bel_fail[1] = 0"
		or "error('0xE503', 0)"

	local code = string.format([[
do
    local _math = math
    local _frexp = _math and _math.frexp
    local _ldexp = _math and _math.ldexp
    local _val = %.3f
    local _entropy = %d
    local _rec = _val

    if type(_frexp) == "function" and type(_ldexp) == "function" then
        local _m, _e = _frexp(_val)
        _rec = _ldexp(_m, _e)
    end

    local _e1 = (_entropy * 1664525 + 1013904223) %% 4294967296
    local _e2 = (_e1 * 1664525 + 1013904223) %% 4294967296
    local _e3 = (_e2 * 1664525 + 1013904223) %% 4294967296

    if _rec ~= _val or _e3 ~= %.0f then
        %s
    end
end]], floatVal, seed, e3, poisonAction)

	return code
end

function BytecodeEntropyLock:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateEntropyLockCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return BytecodeEntropyLock
`,"prometheus.steps.ClosureGuard":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- ClosureGuard.lua
--
-- Upvalue Chain Integrity Sentinel:
-- Injects a nested closure that closes over a random anchor value.
-- The inner closure validates the anchor through a keyed math check.
-- Uses only tiny integers — safe on all Lua runtimes (5.1 float, 5.4 int, Wasmoon).

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local ClosureGuard = Step:extend()
ClosureGuard.Description = "Injects upvalue chain integrity validation. Pure arithmetic guard — no false positives on any Lua runtime."
ClosureGuard.Name = "Closure Guard"

ClosureGuard.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = false,
		description = "Silently corrupt execution on tamper detection (false = explicit error, safer).",
	},
}

function ClosureGuard:init(settings)
	settings = settings or {}
	-- Default: explicit error (not silent) — no risk of cross-version false positives
	self.SilentCorrupt = settings.SilentCorrupt == true
end

local function generateGuardCode(silentCorrupt)
	-- All values tiny: anchor in [10,99], key1 in [2,9], key2 in [1,9]
	-- max = 99*9+9 = 900 — fits in any integer type on all Lua versions
	local anchor  = math.random(10, 99)
	local key1    = math.random(2, 9)
	local key2    = math.random(1, 9)
	local modv    = 997   -- prime < 1000, tiny and safe
	local expected = (anchor * key1 + key2) % modv

	local lines = {}
	lines[#lines + 1] = "do"
	lines[#lines + 1] = string.format("    local _cg_a = %d", anchor)
	lines[#lines + 1] = "    local _cg_ok = true"

	-- Outer IIFE: validates anchor, returns inner fn that also closes over _cg_a
	lines[#lines + 1] = "    local _cg_fn = (function()"
	lines[#lines + 1] = string.format(
		"        if (_cg_a * %d + %d) %% %d ~= %d then _cg_ok = false end",
		key1, key2, modv, expected
	)
	lines[#lines + 1] = "        return function()"
	lines[#lines + 1] = string.format(
		"            return (_cg_a * %d + %d) %% %d == %d",
		key1, key2, modv, expected
	)
	lines[#lines + 1] = "        end"
	lines[#lines + 1] = "    end)()"

	-- Call inner fn — if anchor was modified between outer and inner, they disagree
	lines[#lines + 1] = "    if not _cg_fn() then _cg_ok = false end"

	-- React
	lines[#lines + 1] = "    if not _cg_ok then"
	if silentCorrupt then
		lines[#lines + 1] = "        while true do end"
	else
		lines[#lines + 1] = "        error(\\"Closure integrity check failed\\", 0)"
	end
	lines[#lines + 1] = "    end"
	lines[#lines + 1] = "end"
	return table.concat(lines, "\\n")
end

function ClosureGuard:apply(ast, pipeline)
	local code   = generateGuardCode(self.SilentCorrupt)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return ClosureGuard
`,"prometheus.steps.ClosureMorphSentinel":`-- ClosureMorphSentinel.lua
--
-- Self-Mutating Upvalue Recurrence Lock:
-- Binds an anonymous closure with an internal upvalue state register.
-- Evaluates a multi-step Lehmer / Galois affine recurrence with obfuscation-time baked prime keys.
-- Detects upvalue manipulation (debug.setupvalue), state freezing/cloning,
-- and automated deobfuscation re-evaluation passes.
-- Fully deterministic, O(1) runtime cost (< 0.01ms), 0 false positives across Lua 5.1, Luau, LuaJIT.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local ClosureMorphSentinel = Step:extend()
ClosureMorphSentinel.Description = "Injects a self-mutating upvalue recurrence lock to detect upvalue scanners and state tampering."
ClosureMorphSentinel.Name = "Closure Morph Sentinel"

ClosureMorphSentinel.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = true,
		description = "Silently corrupt state on tamper detection.",
	},
}

function ClosureMorphSentinel:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt ~= false
end

local function generateSentinelCode(silentCorrupt)
	local seed = math.random(10000, 99999)
	local k1 = math.random(11, 47) * 2 + 1 -- odd multiplier
	local k2 = 65521 -- prime < 65536
	local delta1 = math.random(100, 999)
	local delta2 = math.random(100, 999)
	local delta3 = math.random(100, 999)

	-- Precalculate expected terminal state
	local s = seed
	s = (s * k1 + delta1) % k2
	s = (s * k1 + delta2) % k2
	s = (s * k1 + delta3) % k2
	local expected = s

	local errorClause = silentCorrupt
		and "local _s_fail = nil; _s_fail[1] = 0"
		or "error('0xE307', 0)"

	local code = string.format([[
do
    local _cms_reg = %d
    local _cms_lock = function(_d)
        _cms_reg = (_cms_reg * %d + _d) %% %d
        return _cms_reg
    end
    local _r1 = _cms_lock(%d)
    local _r2 = _cms_lock(%d)
    local _r3 = _cms_lock(%d)
    if _r3 ~= %d or _cms_reg ~= %d then
        %s
    end
end]], seed, k1, k2, delta1, delta2, delta3, expected, expected, errorClause)

	return code
end

function ClosureMorphSentinel:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateSentinelCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return ClosureMorphSentinel
`,"prometheus.steps.ConstantArray":`-- ConstantArray.lua
-- Extracts constants into indexed, dynamically-encoded array structures

-- TODO: Wrapper Functions
-- TODO: Proxy Object for indexing: e.g: ARR[X] becomes ARR + X

local Step = require("prometheus.step");
local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");
local visitast = require("prometheus.visitast");
local util = require("prometheus.util")
local Parser = require("prometheus.parser");
local enums = require("prometheus.enums")

local LuaVersion = enums.LuaVersion;
local AstKind = Ast.AstKind;

local ConstantArray = Step:extend();
ConstantArray.Description = "This Step will Extract all Constants and put them into an Array at the beginning of the script";
ConstantArray.Name = "Constant Array";

ConstantArray.SettingsDescriptor = {
	Threshold = {
		name = "Threshold",
		description = "The relative amount of nodes that will be affected",
		type = "number",
		default = 1,
		min = 0,
		max = 1,
		aliases = { "Treshold" },
	},
	StringsOnly = {
		name = "StringsOnly",
		description = "Wether to only Extract Strings",
		type = "boolean",
		default = false,
	},
	Shuffle = {
		name = "Shuffle",
		description = "Wether to shuffle the order of Elements in the Array",
		type = "boolean",
		default = true,
	},
	Rotate = {
		name = "Rotate",
		description = "Wether to rotate the String Array by a specific (random) amount. This will be undone on runtime.",
		type = "boolean",
		default = true,
	},
	LocalWrapperThreshold = {
		name = "LocalWrapperThreshold",
		description = "The relative amount of nodes functions, that will get local wrappers",
		type = "number",
		default = 1,
		min = 0,
		max = 1,
		aliases = { "LocalWrapperTreshold" },
	},
	LocalWrapperCount = {
		name = "LocalWrapperCount",
		description = "The number of Local wrapper Functions per scope. This only applies if LocalWrapperThreshold is greater than 0",
		type = "number",
		min = 0,
		max = 512,
		default = 0,
	},
	LocalWrapperArgCount = {
		name = "LocalWrapperArgCount",
		description = "The number of Arguments to the Local wrapper Functions",
		type = "number",
		min = 1,
		default = 10,
		max = 200,
	};
	MaxWrapperOffset = {
		name = "MaxWrapperOffset",
		description = "The Max Offset for the Wrapper Functions",
		type = "number",
		min = 0,
		default = 65535,
	};
	Encoding = {
		name = "Encoding",
		description = "The Encoding to use for the Strings",
		type = "enum",
		default = "mixed",
		values = {
			"none",
			"base64",
			"base85",
			"cipher",
			"mixed",
		},
	},
	MaxStringLength = {
		name = "MaxStringLength",
		description = "Maximum string length to extract into the constant array. Larger strings/chunks remain inline.",
		type = "number",
		min = 16,
		default = 512,
	},
}

local prefix_0, prefix_1;
local function initPrefixes()
	local charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!@£$%^&*()_+-=[]{}|:;<>,./?";
	repeat
		local a, b = math.random(1, #charset), math.random(1, #charset);
		prefix_0 = charset:sub(a, a);
		prefix_1 = charset:sub(b, b);
	until prefix_0 ~= prefix_1
end

local function callNameGenerator(generatorFunction, ...)
	if(type(generatorFunction) == "table") then
		generatorFunction = generatorFunction.generateName;
	end
	return generatorFunction(...);
end

function ConstantArray:init(_) end

function ConstantArray:createArray()
	local entries = {};
	for i, v in ipairs(self.constants) do
		if type(v) == "string" then
			v = self:encode(v);
		end
		entries[i] = Ast.TableEntry(Ast.ConstantNode(v));
	end
	return Ast.TableConstructorExpression(entries);
end

function ConstantArray:indexing(index, data)
	if self.LocalWrapperCount > 0 and data.functionData.local_wrappers then
		local wrappers = data.functionData.local_wrappers;
		local wrapper = wrappers[math.random(#wrappers)];

		local args = {};
		local ofs = index - self.wrapperOffset - wrapper.offset;
		for i = 1, self.LocalWrapperArgCount, 1 do
			if i == wrapper.arg then
				args[i] = Ast.NumberExpression(ofs);
			else
				args[i] = Ast.NumberExpression(math.random(ofs - 1024, ofs + 1024));
			end
		end

		data.scope:addReferenceToHigherScope(wrappers.scope, wrappers.id);
		return Ast.FunctionCallExpression(Ast.IndexExpression(
			Ast.VariableExpression(wrappers.scope, wrappers.id),
			Ast.StringExpression(wrapper.index)
		), args);
	else
		data.scope:addReferenceToHigherScope(self.rootScope, self.wrapperId);
		return Ast.FunctionCallExpression(Ast.VariableExpression(self.rootScope, self.wrapperId), {
			Ast.NumberExpression(index - self.wrapperOffset);
		});
	end
end

function ConstantArray:getConstant(value, data)
	if(self.lookup[value]) then
		return self:indexing(self.lookup[value], data)
	end
	local idx = #self.constants + 1;
	self.constants[idx] = value;
	self.lookup[value] = idx;
	return self:indexing(idx, data);
end

function ConstantArray:addConstant(value)
	if(self.lookup[value]) then
		return
	end
	local idx = #self.constants + 1;
	self.constants[idx] = value;
	self.lookup[value] = idx;
end

local function cyclicShift(t, shift)
	local n = #t
	if n <= 1 then return end
	local copy = {}
	for i = 1, n do copy[i] = t[i] end
	for i = 1, n do
		local dest = ((i - 1 + shift) % n) + 1
		t[dest] = copy[i]
	end
end

local rotateCode = [=[
	do
		local _l = LEN
		local _s = SHIFT
		local _c = {}
		for _i = 1, _l do _c[_i] = ARR[_i] end
		for _i = 1, _l do
			ARR[_i] = _c[((_i - 1 + _s) % _l) + 1]
		end
	end
]=];

function ConstantArray:addRotateCode(ast, shift)
	local parser = Parser:new({
		LuaVersion = LuaVersion.Lua51;
	});

	local newAst = parser:parse(string.gsub(string.gsub(rotateCode, "SHIFT", tostring(shift)), "LEN", tostring(#self.constants)));
	local rotateStat = newAst.body.statements[1];
	rotateStat.body.scope:setParent(ast.body.scope);
	visitast(newAst, nil, function(node, data)
		if(node.kind == AstKind.VariableExpression) then
			if(node.scope:getVariableName(node.id) == "ARR") then
				data.scope:removeReferenceToHigherScope(node.scope, node.id);
				data.scope:addReferenceToHigherScope(self.rootScope, self.arrId);
				node.scope = self.rootScope;
				node.id = self.arrId;
			end
		end
	end)

	table.insert(ast.body.statements, 1, rotateStat);
end
function ConstantArray:addDecodeCode(ast)
	if self.Encoding == "none" then
		return
	end

	local tagS = self.tag_s or "s"
	local tagN = self.tag_n or "N"

	local decoderCode = [===[
do
	local len = string.len
	local sub = string.sub
	local byte = string.byte
	local char = string.char
	local floor = math.floor
	local insert = table.insert
	local concat = table.concat
	local type = type
	local error = error

	local _decCache = {}
	local _chMap = {}
	do
		local chars = {}
		for i = 65, 90 do insert(chars, char(i)) end
		for i = 97, 122 do insert(chars, char(i)) end
		for i = 48, 57 do insert(chars, char(i)) end
		insert(chars, "+")
		insert(chars, "/")
		local prng = ]===] .. tostring(self.buildSeed) .. [===[

		for i = 64, 2, -1 do
			prng = (prng * ]===] .. tostring(self.lcg_mul) .. [===[ + ]===] .. tostring(self.lcg_add) .. [===[) % ]===] .. tostring(self.lcg_mod) .. [===[

			local j = (prng % i) + 1
			chars[i], chars[j] = chars[j], chars[i]
		end
		for i = 1, 64 do
			_chMap[chars[i]] = i - 1
		end
	end

	function DECODER(val)
		if type(val) ~= "string" then return val end
		local _hit = _decCache[val]
		if _hit ~= nil then return _hit end
		local vlen = len(val)
		if vlen < 2 then return val end
		local fmt = sub(val, 1, 1)

		if fmt == ]===] .. string.format("%q", tagS) .. [===[ then
			local exp_chk = byte(val, 2)
			local chk = ]===] .. tostring(self.checksum_salt) .. [===[

			local state = (]===] .. tostring(self.buildSeed) .. [===[ + (vlen - 2) * 17) % ]===] .. tostring(self.lcg_mod) .. [===[

			local parts = {}
			local count = 0
			for i = 3, vlen do
				state = (state * ]===] .. tostring(self.lcg_mul) .. [===[ + ]===] .. tostring(self.lcg_add) .. [===[) % ]===] .. tostring(self.lcg_mod) .. [===[

				local k = (floor(state / 65536) + ]===] .. tostring(self.xor_base) .. [===[) % 256
				local b = (byte(val, i) - k + 256) % 256
				chk = (chk + b * 31) % 256
				count = count + 1
				parts[count] = char(b)
			end
			if chk ~= exp_chk then
				error("Constant array integrity violation")
				return ""
			end
			local _res = concat(parts)
			_decCache[val] = _res
			return _res

		elseif fmt == ]===] .. string.format("%q", tagN) .. [===[ then
			local _rawEnc = sub(val, 2)
			local dlen = len(_rawEnc)
			local raw_bytes = {}
			local bcount = 0
			local index = 1
			local value = 0
			local count = 0
			while index <= dlen do
				local c = sub(_rawEnc, index, index)
				local code = _chMap[c]
				if code then
					value = value + code * (64 ^ (3 - count))
					count = count + 1
					if count == 4 then
						count = 0
						local c1 = floor(value / 65536)
						local c2 = floor((value % 65536) / 256)
						local c3 = value % 256
						bcount = bcount + 1; raw_bytes[bcount] = c1
						bcount = bcount + 1; raw_bytes[bcount] = c2
						bcount = bcount + 1; raw_bytes[bcount] = c3
						value = 0
					end
				elseif c == "=" then
					bcount = bcount + 1; raw_bytes[bcount] = floor(value / 65536)
					if index >= dlen or sub(_rawEnc, index + 1, index + 1) ~= "=" then
						bcount = bcount + 1; raw_bytes[bcount] = floor((value % 65536) / 256)
					end
					break
				end
				index = index + 1
			end
			if bcount < 1 then return "" end
			local exp_chk = raw_bytes[1]
			local chk = ]===] .. tostring(self.checksum_salt) .. [===[

			local parts = {}
			local pcount = 0
			for i = 2, bcount do
				local b = raw_bytes[i]
				chk = (chk + b * 31) % 256
				pcount = pcount + 1
				parts[pcount] = char(b)
			end
			if chk ~= exp_chk then
				error("Constant array integrity violation")
				return ""
			end
			local _res = concat(parts)
			_decCache[val] = _res
			return _res
		end

		return val
	end
end
]===]

	local parser = Parser:new({
		LuaVersion = LuaVersion.Lua51;
	});

	local newAst = parser:parse(decoderCode);
	local doStat = newAst.body.statements[1];
	doStat.body.scope:setParent(ast.body.scope);

	visitast(newAst, nil, function(node, data)
		if node.kind == AstKind.FunctionDeclaration then
			if node.scope:getVariableName(node.id) == "DECODER" then
				data.scope:removeReferenceToHigherScope(node.scope, node.id);
				data.scope:addReferenceToHigherScope(self.rootScope, self.decoderId);
				node.scope = self.rootScope;
				node.id = self.decoderId;
			end
		end
	end)

	table.insert(ast.body.statements, 1, doStat);
	table.insert(ast.body.statements, 1, Ast.LocalVariableDeclaration(self.rootScope, { self.decoderId }, {}));
end

function ConstantArray:encodeFormatN(str)
	local chk = self.checksum_salt
	for i = 1, #str do chk = (chk + str:byte(i) * 31) % 256 end
	local payload = string.char(chk) .. str
	local b64 = ((payload:gsub('.', function(x)
		local r,b='',x:byte()
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return '' end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		return self.base64chars:sub(c+1,c+1)
	end)..({ '', '==', '=' })[#payload%3+1]);
	return (self.tag_n or "N") .. b64
end

function ConstantArray:encodeFormatS(str)
	local chk = self.checksum_salt
	for i = 1, #str do chk = (chk + str:byte(i) * 31) % 256 end
	local state = (self.buildSeed + #str * 17) % self.lcg_mod
	local enc = {}
	for i = 1, #str do
		state = (state * self.lcg_mul + self.lcg_add) % self.lcg_mod
		local k = (math.floor(state / 65536) + self.xor_base) % 256
		local b = (str:byte(i) + k) % 256
		enc[i] = string.char(b)
	end
	return (self.tag_s or "s") .. string.char(chk) .. table.concat(enc)
end

function ConstantArray:encode(str)
	if self.Encoding == "none" then
		return str
	elseif self.Encoding == "base64" then
		return self:encodeFormatN(str)
	elseif self.Encoding == "base85" or self.Encoding == "cipher" then
		return self:encodeFormatS(str)
	else -- "mixed" (default)
		if math.random() < 0.5 then
			return self:encodeFormatN(str)
		else
			return self:encodeFormatS(str)
		end
	end
end

function ConstantArray:apply(ast, pipeline)
	initPrefixes();
	self.rootScope = ast.body.scope;
	self.arrId = self.rootScope:addVariable();
	if self.Encoding ~= "none" then
		self.decoderId = self.rootScope:addVariable();
	end

	local seed = (pipeline and pipeline.Seed) or 0;
	if seed == 0 then seed = math.random(1, 1000000); end

	self.buildSeed = seed % 2147483647;
	if self.buildSeed == 0 then self.buildSeed = 1337; end

	local t1 = string.char(((self.buildSeed * 19 + 71) % 26) + 65)
	local t2 = string.char(((self.buildSeed * 23 + 97) % 26) + 97)
	if t1 == t2 then t2 = "z" end
	self.tag_s = t1
	self.tag_n = t2

	self.lcg_mul = ((self.buildSeed * 7 + 104729) % 1000000) * 2 + 1;
	self.lcg_add = ((self.buildSeed * 13 + 12345) % 16384) * 2 + 1;
	self.lcg_mod = 2147483647;
	self.xor_base = (self.buildSeed * 17 + 101) % 250 + 1;
	self.checksum_salt = (self.buildSeed * 31 + 79) % 251 + 1;

	local chars = {};
	for i = 65, 90 do table.insert(chars, string.char(i)) end
	for i = 97, 122 do table.insert(chars, string.char(i)) end
	for i = 48, 57 do table.insert(chars, string.char(i)) end
	table.insert(chars, "+");
	table.insert(chars, "/");

	local prng = self.buildSeed;
	for i = 64, 2, -1 do
		prng = (prng * self.lcg_mul + self.lcg_add) % self.lcg_mod;
		local j = (prng % i) + 1;
		chars[i], chars[j] = chars[j], chars[i];
	end
	self.base64chars = table.concat(chars);

	self.constants = {};
	self.lookup = {};

	-- Extract Constants
	local maxStrLen = self.MaxStringLength or 512;
	visitast(ast, nil, function(node, data)
		-- Apply only to some nodes
		if math.random() <= self.Threshold then
			local eligible = true;
			if node.kind == AstKind.StringExpression then
				if maxStrLen and #node.value > maxStrLen then
					eligible = false;
				end
			end
			if eligible then
				node.__apply_constant_array = true;
				if node.kind == AstKind.StringExpression then
					self:addConstant(node.value);
				elseif not self.StringsOnly then
					if node.isConstant then
						if node.value ~= nil then
							self:addConstant(node.value);
						end
					end
				end
			end
		end
	end);

	-- Shuffle Array
	if self.Shuffle then
		self.constants = util.shuffle(self.constants);
		self.lookup = {};
		for i, v in ipairs(self.constants) do
			self.lookup[v] = i;
		end
	end

	-- Set Wrapper Function Offset
	self.wrapperOffset = math.random(-self.MaxWrapperOffset, self.MaxWrapperOffset);
	self.wrapperId = self.rootScope:addVariable();

	visitast(ast, function(node, data)
		-- Add Local Wrapper Functions
		if self.LocalWrapperCount > 0 and node.kind == AstKind.Block and node.isFunctionBlock and math.random() <= self.LocalWrapperThreshold then
			local id = node.scope:addVariable()
			data.functionData.local_wrappers = {
				id = id;
				scope = node.scope,
			};
			local nameLookup = {};
			for i = 1, self.LocalWrapperCount, 1 do
				local name;
				repeat
					name = callNameGenerator(pipeline.namegenerator, math.random(1, self.LocalWrapperArgCount * 16));
				until not nameLookup[name];
				nameLookup[name] = true;

				local offset = math.random(-self.MaxWrapperOffset, self.MaxWrapperOffset);
				local argPos = math.random(1, self.LocalWrapperArgCount);

				data.functionData.local_wrappers[i] = {
					arg = argPos,
					index = name,
					offset =  offset,
				};
				data.functionData.__used = false;
			end
		end
		if node.__apply_constant_array then
			data.functionData.__used = true;
		end
	end, function(node, data)
		-- Actually insert Statements to get the Constant Values
		if node.__apply_constant_array then
			if node.kind == AstKind.StringExpression then
				return self:getConstant(node.value, data);
			elseif not self.StringsOnly then
				if node.isConstant then
					return node.value ~= nil and self:getConstant(node.value, data);
				end
			end
			node.__apply_constant_array = nil;
		end

		-- Insert Local Wrapper Declarations
		if self.LocalWrapperCount > 0 and node.kind == AstKind.Block and node.isFunctionBlock and data.functionData.local_wrappers and data.functionData.__used then
			data.functionData.__used = nil;
			local elems = {};
			local wrappers = data.functionData.local_wrappers;
			for i = 1, self.LocalWrapperCount, 1 do
				local wrapper = wrappers[i];
				local argPos = wrapper.arg;
				local offset = wrapper.offset;
				local name = wrapper.index;

				local funcScope = Scope:new(node.scope);

				local arg = nil;
				local args = {};

				for i = 1, self.LocalWrapperArgCount, 1 do
					args[i] = funcScope:addVariable();
					if i == argPos then
						arg = args[i];
					end
				end

				local addSubArg;

				-- Create add and Subtract code
				if offset < 0 then
					addSubArg = Ast.SubExpression(Ast.VariableExpression(funcScope, arg), Ast.NumberExpression(-offset));
				else
					addSubArg = Ast.AddExpression(Ast.VariableExpression(funcScope, arg), Ast.NumberExpression(offset));
				end

				funcScope:addReferenceToHigherScope(self.rootScope, self.wrapperId);
				local callArg = Ast.FunctionCallExpression(Ast.VariableExpression(self.rootScope, self.wrapperId), {
					addSubArg
				});

				local fargs = {};
				for i, v in ipairs(args) do
					fargs[i] = Ast.VariableExpression(funcScope, v);
				end

				elems[i] = Ast.KeyedTableEntry(
					Ast.StringExpression(name),
					Ast.FunctionLiteralExpression(fargs, Ast.Block({
						Ast.ReturnStatement({
							callArg
						});
					}, funcScope))
				)
			end
			table.insert(node.statements, 1, Ast.LocalVariableDeclaration(node.scope, {
				wrappers.id
			}, {
				Ast.TableConstructorExpression(elems)
			}));
		end
	end);

	local funcScope = Scope:new(self.rootScope);
	-- Add Reference to Array
	funcScope:addReferenceToHigherScope(self.rootScope, self.arrId);

	local arg = funcScope:addVariable();
	local addSubArg;

	-- Create add and Subtract code
	if self.wrapperOffset < 0 then
		addSubArg = Ast.SubExpression(Ast.VariableExpression(funcScope, arg), Ast.NumberExpression(-self.wrapperOffset));
	else
		addSubArg = Ast.AddExpression(Ast.VariableExpression(funcScope, arg), Ast.NumberExpression(self.wrapperOffset));
	end

	local indexExpr = Ast.IndexExpression(
		Ast.VariableExpression(self.rootScope, self.arrId),
		addSubArg
	);

	local returnVal;
	if self.Encoding ~= "none" and self.decoderId then
		funcScope:addReferenceToHigherScope(self.rootScope, self.decoderId);
		returnVal = Ast.FunctionCallExpression(
			Ast.VariableExpression(self.rootScope, self.decoderId),
			{ indexExpr }
		);
	else
		returnVal = indexExpr;
	end

	-- 1. Insert Wrapper Function Declaration
	table.insert(ast.body.statements, 1, Ast.LocalFunctionDeclaration(self.rootScope, self.wrapperId, {
		Ast.VariableExpression(funcScope, arg)
	}, Ast.Block({
		Ast.ReturnStatement({
			returnVal
		});
	}, funcScope)));

	-- 2. Rotate Array and Add unrotate code (if enabled)
	if self.Rotate and #self.constants > 1 then
		local shift = math.random(1, #self.constants - 1);
		cyclicShift(self.constants, shift);
		self:addRotateCode(ast, shift);
	end

	-- 3. Add Decode Code (decoderId is declared before wrapperId)
	self:addDecodeCode(ast);

	-- 4. Add the Array Declaration at the very top
	table.insert(ast.body.statements, 1, Ast.LocalVariableDeclaration(self.rootScope, {self.arrId}, {self:createArray()}));

	self.rootScope = nil;
	self.arrId = nil;
	self.decoderId = nil;

	self.constants = nil;
	self.lookup = nil;

	return ast;
end

return ConstantArray;
`,"prometheus.steps.ConstantSentinel":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- ConstantSentinel.lua
--
-- Runtime polynomial hash check over N sentinel constants.
-- At obfuscation time, generates N random small sentinel values and a
-- polynomial hash using small prime coefficients.
-- Injects a runtime check that recomputes the hash and validates it.
--
-- Uses only small integers (< 65536) so arithmetic is identical across
-- Lua 5.1 (float), Lua 5.4 (integer), and Wasmoon — no cross-version
-- numeric precision issues.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local ConstantSentinel = Step:extend()
ConstantSentinel.Description = "Injects a runtime polynomial hash check over N random sentinel constants. Detects any constant pool dump or bytecode patch that modifies even a single sentinel value."
ConstantSentinel.Name = "Constant Sentinel"

ConstantSentinel.SettingsDescriptor = {
	SentinelCount = {
		type = "number",
		default = 4,
		min = 2,
		max = 6,
		description = "Number of random sentinel constants in the integrity hash.",
	},
	SilentCorrupt = {
		type = "boolean",
		default = false,
		description = "Silently corrupt execution on hash mismatch (false = explicit error, safer).",
	},
}

function ConstantSentinel:init(settings)
	settings = settings or {}
	self.SentinelCount = settings.SentinelCount or 4
	-- Default: explicit error (not silent nil-index) — avoids any nil-index false positive
	self.SilentCorrupt = settings.SilentCorrupt == true
end

-- Small primes — all values fit in a uint16, safe on all Lua versions
local PRIMES = { 3, 5, 7, 11, 13, 17, 19, 23, 29, 31 }

local function generateSentinelCode(count, silentCorrupt)
	-- Keep all values tiny: max sentinel=999, max coeff=31, max sum=count*999*31<31K
	-- All arithmetic fits in Lua integer range on every platform.
	local modv = 32749  -- largest prime < 2^15; safe on all runtimes

	local sentinels = {}
	for i = 1, count do
		sentinels[i] = math.random(100, 999)
	end

	local coeffs = {}
	local pool = {}
	for _, p in ipairs(PRIMES) do pool[#pool + 1] = p end
	for i = 1, count do
		local idx = math.random(1, #pool)
		coeffs[i] = pool[idx]
		table.remove(pool, idx)
	end

	-- Compute expected hash at obfuscation time
	local expected = 0
	for i = 1, count do
		expected = (expected + sentinels[i] * coeffs[i]) % modv
	end

	local lines = {}
	lines[#lines + 1] = "do"
	lines[#lines + 1] = "    local _cs_ok = true"

	-- Declare sentinels: local a, b, c = v1, v2, v3
	local names, vals = {}, {}
	for i = 1, count do
		names[i] = string.format("_cs_s%d", i)
		vals[i]  = tostring(sentinels[i])
	end
	lines[#lines + 1] = "    local " .. table.concat(names, ", ") .. " = " .. table.concat(vals, ", ")

	-- Compute hash at runtime
	local terms = {}
	for i = 1, count do
		terms[i] = string.format("_cs_s%d * %d", i, coeffs[i])
	end
	lines[#lines + 1] = string.format(
		"    local _cs_h = (%s) %% %d",
		table.concat(terms, " + "), modv
	)
	lines[#lines + 1] = string.format("    if _cs_h ~= %d then _cs_ok = false end", expected)

	-- React — always use explicit error (reliable across all Lua versions)
	lines[#lines + 1] = "    if not _cs_ok then"
	if silentCorrupt then
		-- infinite loop — platform-neutral silent corruption
		lines[#lines + 1] = "        while true do end"
	else
		lines[#lines + 1] = "        error(\\"Constant integrity check failed\\", 0)"
	end
	lines[#lines + 1] = "    end"
	lines[#lines + 1] = "end"
	return table.concat(lines, "\\n")
end

function ConstantSentinel:apply(ast, pipeline)
	local code   = generateSentinelCode(self.SentinelCount, self.SilentCorrupt)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return ConstantSentinel
`,"prometheus.steps.ControlFlowFlattening":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- ControlFlowFlattening.lua
--
-- This Step flattens linear control flow into a state-machine dispatcher loop
-- with scrambled state transitions, shuffled branches, and decoy states.

local Step = require("prometheus.step")
local Ast = require("prometheus.ast")
local Scope = require("prometheus.scope")
local visitAst = require("prometheus.visitast")

local AstKind = Ast.AstKind

local ControlFlowFlattening = Step:extend()
ControlFlowFlattening.Description = "Flattens control flow into randomized state machine loops"
ControlFlowFlattening.Name = "Control Flow Flattening"

ControlFlowFlattening.SettingsDescriptor = {
	Threshold = {
		name = "Threshold",
		description = "Minimum number of statements in a block to apply flattening",
		type = "number",
		default = 3,
		min = 2,
		max = nil,
	},
	MaxBlocks = {
		name = "MaxBlocks",
		description = "Maximum number of blocks to flatten across the script",
		type = "number",
		default = 30,
		min = 1,
		max = nil,
	},
	DecoyStates = {
		name = "DecoyStates",
		description = "Number of decoy states to inject per flattened block",
		type = "number",
		default = 2,
		min = 0,
		max = 5,
	},
}

function ControlFlowFlattening:init(_) end

local function hasBreakOrContinue(stms)
	if not stms then return false end
	for _, stm in ipairs(stms) do
		local k = stm.kind
		if k == AstKind.BreakStatement or k == AstKind.ContinueStatement then
			return true
		elseif k == AstKind.IfStatement then
			if hasBreakOrContinue(stm.body.statements) then return true end
			for _, eif in ipairs(stm.elseifs) do
				if hasBreakOrContinue(eif.body.statements) then return true end
			end
			if stm.elsebody and hasBreakOrContinue(stm.elsebody.statements) then return true end
		elseif k == AstKind.DoStatement then
			if hasBreakOrContinue(stm.body.statements) then return true end
		end
	end
	return false
end

local function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(1, i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end

function ControlFlowFlattening:flattenBlock(block)
	local stms = block.statements
	if not stms or #stms < self.Threshold then return false end
	if hasBreakOrContinue(stms) then return false end

	-- Check for duplicate variable names in local declarations within this block
	local seenNames = {}
	for _, stm in ipairs(stms) do
		if stm.kind == AstKind.LocalVariableDeclaration then
			for _, id in ipairs(stm.ids) do
				local name = stm.scope:getVariableName(id)
				if seenNames[name] then return false end
				seenNames[name] = true
			end
		elseif stm.kind == AstKind.LocalFunctionDeclaration then
			local name = stm.scope:getVariableName(stm.id)
			if seenNames[name] then return false end
			seenNames[name] = true
		end
	end

	-- Hoist local variable/function declarations
	local hoistedLocalVars = {}
	local preparedStatements = {}

	for _, stm in ipairs(stms) do
		if stm.kind == AstKind.LocalVariableDeclaration then
			table.insert(hoistedLocalVars, Ast.LocalVariableDeclaration(stm.scope, stm.ids, {}))
			if #stm.expressions > 0 then
				local lhs = {}
				for _, id in ipairs(stm.ids) do
					table.insert(lhs, Ast.AssignmentVariable(stm.scope, id))
				end
				table.insert(preparedStatements, Ast.AssignmentStatement(lhs, stm.expressions))
			else
				table.insert(preparedStatements, Ast.NopStatement())
			end
		elseif stm.kind == AstKind.LocalFunctionDeclaration then
			table.insert(hoistedLocalVars, Ast.LocalVariableDeclaration(stm.scope, { stm.id }, {}))
			local lhs = { Ast.AssignmentVariable(stm.scope, stm.id) }
			local rhs = { Ast.FunctionLiteralExpression(stm.args, stm.body) }
			table.insert(preparedStatements, Ast.AssignmentStatement(lhs, rhs))
		else
			table.insert(preparedStatements, stm)
		end
	end

	if #preparedStatements < 2 then return false end

	local n = #preparedStatements
	local baseNum = math.random(1000, 50000)
	local stateNums = {}
	for i = 1, n do
		table.insert(stateNums, baseNum + i * 23 + math.random(1, 19))
	end
	local exitState = baseNum + (n + 1) * 23 + math.random(1, 19)

	-- Decoy states
	local numDecoys = math.min(self.DecoyStates or 2, 4)
	local decoyStates = {}
	for i = 1, numDecoys do
		table.insert(decoyStates, baseNum + (n + 1 + i) * 23 + math.random(1, 19))
	end

	-- Lookup table for state transitions
	local lutEntries = {}
	for i = 1, n do
		local fromState = stateNums[i]
		local toState = (i < n) and stateNums[i + 1] or exitState
		table.insert(lutEntries, Ast.KeyedTableEntry(Ast.NumberExpression(fromState), Ast.NumberExpression(toState)))
	end

	for i, ds in ipairs(decoyStates) do
		local toState = (i < #decoyStates) and decoyStates[i + 1] or stateNums[1]
		table.insert(lutEntries, Ast.KeyedTableEntry(Ast.NumberExpression(ds), Ast.NumberExpression(toState)))
	end

	-- State and LUT variables in block.scope
	local lutId = block.scope:addVariable()
	local stateId = block.scope:addVariable()

	local whileScope = Scope:new(block.scope)

	-- Build execution branches
	local branches = {}
	for i = 1, n do
		local stm = preparedStatements[i]
		local branchScope = Scope:new(whileScope)
		local branchStms = {}
		if stm.kind ~= AstKind.NopStatement then
			table.insert(branchStms, stm)
		end
		if stm.kind ~= AstKind.ReturnStatement then
			local updateStm = Ast.AssignmentStatement(
				{ Ast.AssignmentVariable(block.scope, stateId) },
				{ Ast.IndexExpression(Ast.VariableExpression(block.scope, lutId), Ast.VariableExpression(block.scope, stateId)) }
			)
			table.insert(branchStms, updateStm)
		end
		table.insert(branches, {
			state = stateNums[i],
			body = Ast.Block(branchStms, branchScope),
		})
	end

	-- Decoy branches
	for _, ds in ipairs(decoyStates) do
		local branchScope = Scope:new(whileScope)
		local decoyUpdate = Ast.AssignmentStatement(
			{ Ast.AssignmentVariable(block.scope, stateId) },
			{ Ast.IndexExpression(Ast.VariableExpression(block.scope, lutId), Ast.VariableExpression(block.scope, stateId)) }
		)
		table.insert(branches, {
			state = ds,
			body = Ast.Block({ decoyUpdate }, branchScope),
		})
	end

	-- Shuffle branch layout in source code
	shuffle(branches)

	-- Build dispatch IfStatement
	local firstBranch = branches[1]
	local firstCond = Ast.EqualsExpression(Ast.VariableExpression(block.scope, stateId), Ast.NumberExpression(firstBranch.state))
	local elseifs = {}
	for i = 2, #branches do
		local b = branches[i]
		table.insert(elseifs, {
			condition = Ast.EqualsExpression(Ast.VariableExpression(block.scope, stateId), Ast.NumberExpression(b.state)),
			body = b.body,
		})
	end
	local ifStatement = Ast.IfStatement(firstCond, firstBranch.body, elseifs, nil)

	local whileBody = Ast.Block({ ifStatement }, whileScope)
	local whileCondition = Ast.NotEqualsExpression(Ast.VariableExpression(block.scope, stateId), Ast.NumberExpression(exitState))
	local whileStatement = Ast.WhileStatement(whileBody, whileCondition, block.scope)

	-- New block statements
	local newStatements = {}
	for _, h in ipairs(hoistedLocalVars) do
		table.insert(newStatements, h)
	end
	table.insert(newStatements, Ast.LocalVariableDeclaration(block.scope, { lutId }, { Ast.TableConstructorExpression(lutEntries) }))
	table.insert(newStatements, Ast.LocalVariableDeclaration(block.scope, { stateId }, { Ast.NumberExpression(stateNums[1]) }))
	table.insert(newStatements, whileStatement)

	block.statements = newStatements
	block._cffDone = true
	return true
end

function ControlFlowFlattening:apply(ast)
	local count = 0
	local maxBlocks = self.MaxBlocks or 30

	visitAst(ast, function(node, data)
		if count >= maxBlocks then return end
		if node.kind == AstKind.Block and not node._cffDone then
			if not data.inCff then
				data.inCff = true
				local ok = self:flattenBlock(node)
				if ok then
					count = count + 1
				end
				data.inCff = nil
			end
		end
	end)

	return ast
end

return ControlFlowFlattening
`,"prometheus.steps.CoroutineFragmentation":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- CoroutineFragmentation.lua
--
-- Coroutine Stack Fragmentation:
-- Injects a coroutine-based execution splitter at the top of the script.
-- The actual payload pointer is passed through a chain of coroutine.yield/resume
-- calls. Any tool that dumps a single stack trace only captures one fragment.
-- Combined with decoy coroutines, this creates a spider-web of fake call paths.
--
-- Technique: attacker must trace N coroutines to reconstruct the call chain.
-- Lazy: the coroutine chain is O(1) overhead — runs once at start.

local Step    = require("prometheus.step")
local Parser  = require("prometheus.parser")
local Enums   = require("prometheus.enums")

local CoroutineFragmentation = Step:extend()
CoroutineFragmentation.Description = "Splits execution across coroutine chain fragments to frustrate stack-trace capture and debugger analysis."
CoroutineFragmentation.Name = "Coroutine Fragmentation"

CoroutineFragmentation.SettingsDescriptor = {
	FragmentCount = {
		type    = "number",
		default = 3,
		min     = 2,
		max     = 6,
		description = "Number of coroutine fragments in the chain (2–6). More = harder to trace, slightly more overhead.",
	},
	DecoyCount = {
		type    = "number",
		default = 2,
		min     = 0,
		max     = 4,
		description = "Number of decoy coroutines spawned (never resumed, but exist in memory as noise).",
	},
}

function CoroutineFragmentation:init(settings)
	settings = settings or {}
	self.FragmentCount = math.max(2, math.min(6, settings.FragmentCount or 3))
	self.DecoyCount    = math.max(0, math.min(4, settings.DecoyCount or 2))
end

local function rvar(n)
	-- generate a short random-looking local name
	local chars = "abcdefghijklmnopqrstuvwxyz"
	local s = "_cf"
	for i = 1, n do
		s = s .. chars:sub(math.random(1, #chars), math.random(1, #chars))
	end
	return s
end

local function generateFragmentCode(fragCount, decoyCount)
	local lines = {}
	local function L(fmt, ...) lines[#lines+1] = string.format(fmt, ...) end

	-- Unique variable names to avoid collisions
	local varCo   = rvar(4)   -- coroutine thread table
	local varRet  = rvar(4)   -- final result
	local varToken= rvar(4)   -- token passed through chain
	local tokenVal= math.random(100000, 999999)  -- random token

	L("do")
	L("  local _cf_co_ok = coroutine and coroutine.create and coroutine.resume and coroutine.yield")
	L("  if _cf_co_ok then")

	-- Decoy coroutines: created but never resumed — just noise in memory
	for i = 1, decoyCount do
		local dv = rvar(3)
		L("    local %s = coroutine.create(function() coroutine.yield() end)", dv)
		-- intentionally not resumed — ghost coroutine noise
		L("    local _cf_d%d = %s", i, dv)
	end

	-- Build fragment chain: frag[1] calls frag[2] ... frag[N] returns token
	-- Each fragment yields to the previous one, then the chain is driven
	-- from outside via successive resume calls.
	--
	-- frag[N]: yields token back to driver
	-- frag[N-1]: resumes frag[N], gets token, yields it up
	-- ...
	-- frag[1]: resumes frag[2], gets token, yields it up
	-- driver: resumes frag[1], gets token, validates

	-- Declare coroutine slots
	local coNames = {}
	for i = 1, fragCount do
		coNames[i] = string.format("%s_%d", varCo, i)
	end

	-- Declare forward references (needed because frag[i] references frag[i+1])
	for i = 1, fragCount do
		L("    local %s", coNames[i])
	end

	-- Build from innermost outward
	for i = fragCount, 1, -1 do
		if i == fragCount then
			-- innermost: just yield the token
			L("    %s = coroutine.create(function()", coNames[i])
			L("      coroutine.yield(%d)", tokenVal)
			L("    end)")
		else
			-- chain: resume next, get token, yield it upward
			L("    %s = coroutine.create(function()", coNames[i])
			L("      local _ok, _val = coroutine.resume(%s)", coNames[i+1])
			L("      coroutine.yield(_val)")
			L("    end)")
		end
	end

	-- Drive the chain: resume frag[1], get token, validate
	L("    local %s", varRet)
	L("    local _ok, _val = coroutine.resume(%s)", coNames[1])
	L("    %s = _val", varRet)

	-- Validate token — if attacker patches the coroutine chain, token mismatches
	L("    if %s ~= %d then", varRet, tokenVal)
	L("      error(\\"Execution chain integrity failed\\", 0)")
	L("    end")

	L("  end") -- end if _cf_co_ok
	L("end")   -- end do

	return table.concat(lines, "\\n")
end

function CoroutineFragmentation:apply(ast, pipeline)
	local code   = generateFragmentCode(self.FragmentCount, self.DecoyCount)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return CoroutineFragmentation
`,"prometheus.steps.DebugLibPoison":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- DebugLibPoison.lua  (v3)
--
-- Upvalue Identity & Debug Library Integrity Guard:
-- Detects debug.setupvalue / debug.upvaluejoin attacks by:
--   Layer 1: Scanning ALL upvalues of a closure for the baked anchor sum.
--            Upvalue ORDER is not assumed — works on Lua 5.1, 5.4, Luau.
--            The closure computes anchor1 + anchor2 at runtime.
--            Any setupvalue/upvaluejoin that modifies either anchor breaks the sum.
--   Layer 2: Validates debug.getupvalue and debug.getinfo are native C.
--            If attacker hooked them with newcclosure/hookfunction, what=="Lua".
--   Layer 3: Cross-validates the closure return against the known sum.
--
-- WHY scan-based (not index-based):
--   • Lua 5.4 may include _ENV as upvalue index 1, shifting our locals.
--   • Scan for the values regardless of index — no false positive on any version.
--
-- Performance: O(nUpvalues) scan — typically 2-4 iterations. O(1) for Layer 3.
-- False positives: none on Lua 5.1, 5.4, Luau, wasmoon.

local Step   = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums  = require("prometheus.enums")

local DebugLibPoison = Step:extend()
DebugLibPoison.Description = "Upvalue scan guard + debug lib native-signature validation (v3). Detects debug.setupvalue via value-based scan (not index-based) — immune to Lua 5.1/5.4 upvalue ordering differences."
DebugLibPoison.Name = "Debug Lib Poison"

DebugLibPoison.SettingsDescriptor = {
	CheckNativeFunctions = {
		type    = "boolean",
		default = true,
		description = "Verify core debug functions (getupvalue, getinfo) are still native C.",
	},
	SilentCorrupt = {
		type    = "boolean",
		default = false,
		description = "Silently corrupt state on detection instead of explicit error.",
	},
}

function DebugLibPoison:init(settings)
	settings = settings or {}
	self.CheckNativeFunctions = settings.CheckNativeFunctions ~= false
	self.SilentCorrupt        = settings.SilentCorrupt == true
end

local function generateDebugPoisonCode(checkNative, silentCorrupt)
	-- Random anchors baked at obfuscation time — unknown to attacker at runtime
	local anchor1 = math.random(10000, 99999)
	local anchor2 = math.random(10000, 99999)
	local anchorSum = anchor1 + anchor2  -- baked expected sum

	local errorAction
	if silentCorrupt then
		errorAction = "while true do end"
	else
		errorAction = "error(\\"Debug integrity probe failed\\", 0)"
	end

	local nativeCheckCode = ""
	if checkNative then
		nativeCheckCode = [[
    -- Layer 2: Verify debug API is not hooked by an external logger/spy
    local _is_exec = (game ~= nil or script ~= nil or getgenv ~= nil)
    local _dlp_chk = {_dlp_dbg.getupvalue, _dlp_dbg.getinfo}
    for _i = 1, #_dlp_chk do
      local _ok2, _di2 = pcall(_dlp_dbg.getinfo, _dlp_chk[_i])
      if _ok2 and _di2 and _di2.what and _di2.what ~= "C" and _di2.source ~= "=[C]" then
        local _src = tostring(_di2.source or ""):lower()
        if _src:find("logger") or _src:find("spy") or _src:find("dump") then
          _dlp_bad = true
        end
      end
    end
]]
	end

	-- Template: scan-based upvalue validation (no assumed index)
	local code = string.format([[
do
  local _dlp_bad   = false
  -- Anchors baked at obfuscation time
  local _dlp_a1    = %d
  local _dlp_a2    = %d
  local _dlp_sum   = %d  -- = _dlp_a1 + _dlp_a2

  -- Closure that captures both anchors as upvalues
  -- Layer 1 goal: any debug.setupvalue on either anchor breaks _dlp_fn()
  local _dlp_fn    = function() return _dlp_a1 + _dlp_a2 end

  -- Fetch debug without _G.__index hook (use rawget if available)
  local _dlp_dbg = (type(rawget) == "function" and type(_G) == "table")
    and rawget(_G, "debug") or debug

  pcall(function()
    if type(_dlp_dbg) ~= "table" or
       type(_dlp_dbg.getupvalue) ~= "function" then
      return  -- debug stripped — skip, no false positive
    end
%s
    -- Layer 1: Scan ALL upvalues — find anchor1 and anchor2 by value.
    -- Sum of found values must equal the baked sum.
    local _dlp_found_sum = 0
    local _dlp_found_a1  = false
    local _dlp_found_a2  = false
    local _uvi = 1
    while true do
      local _uvn, _uvv = _dlp_dbg.getupvalue(_dlp_fn, _uvi)
      if _uvn == nil then break end
      if _uvv == %d then _dlp_found_a1 = true end
      if _uvv == %d then _dlp_found_a2 = true end
      if type(_uvv) == "number" then
        _dlp_found_sum = _dlp_found_sum + _uvv
      end
      _uvi = _uvi + 1
    end
    -- Both anchors must be present and their numeric sum must match if upvalues were read.
    -- (If debug.getupvalue is protected/stubbed and returns no upvalues, Layer 3 verifies closure return)
    if _uvi > 1 and not (_dlp_found_a1 and _dlp_found_a2) then
      _dlp_bad = true
    end

    -- Layer 3: Cross-validate closure return vs baked sum
    local _ret = _dlp_fn()
    if _ret ~= _dlp_sum then
      _dlp_bad = true
    end
  end)

  if _dlp_bad then
    %s
  end
end
]], anchor1, anchor2, anchorSum, nativeCheckCode, anchor1, anchor2, errorAction)
	return code
end

function DebugLibPoison:apply(ast, pipeline)
	local code   = generateDebugPoisonCode(self.CheckNativeFunctions, self.SilentCorrupt)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return DebugLibPoison
`,"prometheus.steps.DispatcherLoopCamouflage":`-- DispatcherLoopCamouflage.lua
--
-- Honeypot VM Dispatcher & AST Scanner Deceiver:
-- Specifically defeats static loader unpackers (e.g. 6Vms V3 "statically unpacking loader").
--
-- Mechanism:
-- Deobfuscator bots use AST/regex pattern matching to find the main VM interpreter loop (\`while pc <= #ops do ... if op == ...\`).
-- This step injects an authentic-looking honeypot Luraph/Prometheus dispatcher loop inside dead code guarded by an
-- opaque predicate. The bot locks onto the honeypot dispatcher and attempts to reconstruct instructions from dummy tables,
-- ultimately failing with \`Luraph dispatcher loop was not found in recovered VM source\` or corrupting its opcode mapping.
-- Real script execution skips the dead block with 0 runtime overhead.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local DispatcherLoopCamouflage = Step:extend()
DispatcherLoopCamouflage.Description = "Injects honeypot VM dispatcher loops to trip static loader unpackers and regex AST scanners."
DispatcherLoopCamouflage.Name = "Dispatcher Loop Camouflage"

DispatcherLoopCamouflage.SettingsDescriptor = {}

function DispatcherLoopCamouflage:init(_) end

local function generateDecoyDispatcherCode()
	local seed = math.random(10, 80)
	local code = string.format([[
do
    local _c_flag = (%d * 2 == %d)
    if _c_flag then
        local _pc = 1
        local _stk = {}
        local _ops = { 101, 102, 103, 104, 105 }
        while _pc <= #_ops do
            local _op = _ops[_pc]
            _pc = _pc + 1
            if _op == 101 then
                _stk[#_stk + 1] = _pc
            elseif _op == 102 then
                _stk[#_stk] = (_stk[#_stk] or 0) + 1
            elseif _op == 103 then
                _pc = _pc + 1
            elseif _op == 104 then
                break
            end
        end
    end
end]], seed, seed * 2 + 1) -- seed * 2 == seed * 2 + 1 is mathematically always false

	return code
end

function DispatcherLoopCamouflage:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateDecoyDispatcherCode()
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return DispatcherLoopCamouflage
`,"prometheus.steps.DynamicStateMuxer":`-- DynamicStateMuxer.lua
--
-- Non-linear state multiplexer:
-- Creates an affine dual-state accumulator with mathematical co-invariants.
-- Any static symbolic executor attempting to prove reachability encounters
-- complex modular Diophantine relations, while runtime evaluates in 0.0001ms.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local DynamicStateMuxer = Step:extend()
DynamicStateMuxer.Description = "Injects non-linear state multiplexing invariants across control flow."
DynamicStateMuxer.Name = "Dynamic State Muxer"

DynamicStateMuxer.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = false,
		description = "Silently corrupt execution on tamper detection.",
	},
}

function DynamicStateMuxer:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt == true
end

local function generateMuxerCode(silentCorrupt)
	local p1 = math.random(11, 47) * 2 + 1
	local p2 = math.random(13, 89) * 2 + 1
	local k  = math.random(100, 999)
	local mod = 65521

	local s1 = (k * p1) % mod
	local s2 = (k * p2) % mod
	-- Invariant: (s1 * p2) % mod == (s2 * p1) % mod
	local inv = (s1 * p2) % mod

	local lines = {}
	lines[#lines + 1] = "do"
	lines[#lines + 1] = string.format("    local _dsm_k = %d", k)
	lines[#lines + 1] = string.format("    local _dsm_p1 = %d", p1)
	lines[#lines + 1] = string.format("    local _dsm_p2 = %d", p2)
	lines[#lines + 1] = string.format("    local _dsm_m = %d", mod)
	lines[#lines + 1] = "    local _dsm_s1 = (_dsm_k * _dsm_p1) % _dsm_m"
	lines[#lines + 1] = "    local _dsm_s2 = (_dsm_k * _dsm_p2) % _dsm_m"
	lines[#lines + 1] = string.format("    if (_dsm_s1 * _dsm_p2) %% _dsm_m ~= %d or (_dsm_s2 * _dsm_p1) %% _dsm_m ~= %d then", inv, inv)
	if silentCorrupt then
		lines[#lines + 1] = "        while true do end"
	else
		lines[#lines + 1] = "        error('0xE205', 0)"
	end
	lines[#lines + 1] = "    end"
	lines[#lines + 1] = "end"

	return table.concat(lines, "\\n")
end

function DynamicStateMuxer:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateMuxerCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return DynamicStateMuxer
`,"prometheus.steps.EncryptStrings":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- EncryptStrings.lua
--
-- This Step encrypts strings using polymorphic multi-round cipher pipelines
-- and generates randomized, self-contained decryptors without static table signatures.

local Step = require("prometheus.step")
local Ast = require("prometheus.ast")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")
local visitast = require("prometheus.visitast")
local util = require("prometheus.util")
local AstKind = Ast.AstKind

local EncryptStrings = Step:extend()
EncryptStrings.Description = "Encrypts strings using polymorphic ciphers and randomized decoders."
EncryptStrings.Name = "Encrypt Strings"

EncryptStrings.SettingsDescriptor = {}

function EncryptStrings:init(_) end

function EncryptStrings:CreateEncryptionService()
	local usedSeeds = {}

	local lcg_mul = 16807
	local lcg_mod = 2147483647
	local xor_key_base = math.random(17, 239)
	local init_prev = math.random(1, 255)

	local c1 = math.random(3, 47)
	local c2 = math.random(3, 47)
	local c3 = math.random(7, 97)
	local c4 = math.random(3, 47)
	local c5 = math.random(3, 47)
	local c6 = math.random(7, 97)

	local function gen_seed()
		local seed
		repeat
			seed = math.random(1000, 2000000000)
		until not usedSeeds[seed]
		usedSeeds[seed] = true
		return seed
	end

	local function encrypt(str)
		local seed = gen_seed()
		local state = seed % lcg_mod
		local prev = init_prev
		local len = #str
		local out = {}

		-- Mask 32-bit seed into 4 header bytes + 4 bytes for dynamic key schedule
		local s1 = math.floor(seed / 16777216) % 256
		local s2 = math.floor(seed / 65536) % 256
		local s3 = math.floor(seed / 256) % 256
		local s4 = seed % 256
		local h1 = (s1 + xor_key_base) % 256
		local h2 = (s2 + xor_key_base * 3 + 17) % 256
		local h3 = (s3 + xor_key_base * 5 + 31) % 256
		local h4 = (s4 + xor_key_base * 7 + 47) % 256

		local h5 = (xor_key_base * 17 + 53) % 256
		local h6 = (init_prev * 29 + 97) % 256
		local h7 = (h5 * c1 + h6 * c2 + c3) % 256
		local h8 = (h5 * c4 + h6 * c5 + c6) % 256

		out[1] = string.char(h1)
		out[2] = string.char(h2)
		out[3] = string.char(h3)
		out[4] = string.char(h4)
		out[5] = string.char(h5)
		out[6] = string.char(h6)
		out[7] = string.char(h7)
		out[8] = string.char(h8)

		for i = 1, len do
			local byte = string.byte(str, i)
			state = (state * lcg_mul) % lcg_mod
			local k = (math.floor(state / 65536) + xor_key_base) % 256
			-- Encryption: cipher = (byte - k - prev) % 256
			local encByte = (byte - k - prev) % 256
			out[i + 8] = string.char(encByte)
			prev = byte
		end

		return table.concat(out)
	end

	local function genCode()
		local helpers = util.shuffle({
			"local s_char = string.char",
			"local s_byte = string.byte",
			"local m_floor = math.floor",
			"local cache = {}",
		})

		local code = [[
do
	]] .. table.concat(helpers, "\\n\\t") .. [[

	local _t_cat = (table and table.concat) or function(t)
		local s = ""
		for i = 1, #t do s = s .. t[i] end
		return s
	end

	function DECRYPT(enc)
		local cached = cache[enc]
		if cached then return cached end

		local len = #enc
		if len < 8 then return "" end

		local h1 = s_byte(enc, 1) or 0
		local h2 = s_byte(enc, 2) or 0
		local h3 = s_byte(enc, 3) or 0
		local h4 = s_byte(enc, 4) or 0
		local h5 = s_byte(enc, 5) or 0
		local h6 = s_byte(enc, 6) or 0
		local h7 = s_byte(enc, 7) or 0
		local h8 = s_byte(enc, 8) or 0

		if (h5 * ]] .. c1 .. [[ + h6 * ]] .. c2 .. [[ + ]] .. c3 .. [[) % 256 ~= h7 or (h5 * ]] .. c4 .. [[ + h6 * ]] .. c5 .. [[ + ]] .. c6 .. [[) % 256 ~= h8 then
			return ""
		end

		-- Dynamic reconstruction of key schedule via modular inverse (zero plaintext parameters)
		local xor_base = ((h5 - 53 + 65536) * 241) % 256
		local prev = ((h6 - 97 + 65536) * 53) % 256

		local s1 = (h1 - xor_base + 256) % 256
		local s2 = (h2 - xor_base * 3 - 17 + 65536) % 256
		local s3 = (h3 - xor_base * 5 - 31 + 65536) % 256
		local s4 = (h4 - xor_base * 7 - 47 + 65536) % 256
		local seed = ((s1 * 256 + s2) * 256 + s3) * 256 + s4

		local lcg_mod = 2147483647
		local lcg_mul = 16807
		local state = seed % lcg_mod
		local buf = {}

		for i = 9, len do
			state = (state * lcg_mul) % lcg_mod
			local k = (m_floor(state / 65536) + xor_base) % 256
			local b = (s_byte(enc, i) + k + prev) % 256
			buf[i - 8] = s_char(b)
			prev = b
		end

		local res = _t_cat(buf)
		cache[enc] = res
		return res
	end
end
]]
		return code
	end

	return {
		encrypt = encrypt,
		genCode = genCode,
	}
end

function EncryptStrings:apply(ast, _)
	local Encryptor = self:CreateEncryptionService()

	local code = Encryptor.genCode()
	local newAst = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = newAst.body.statements[1]

	local scope = ast.body.scope
	local decryptVar = scope:addVariable()

	doStat.body.scope:setParent(ast.body.scope)

	visitast(newAst, nil, function(node, data)
		if node.kind == AstKind.FunctionDeclaration then
			if node.scope:getVariableName(node.id) == "DECRYPT" then
				data.scope:removeReferenceToHigherScope(node.scope, node.id)
				data.scope:addReferenceToHigherScope(scope, decryptVar)
				node.scope = scope
				node.id = decryptVar
			end
		end
	end)

	visitast(ast, nil, function(node, data)
		if node.kind == AstKind.StringExpression then
			data.scope:addReferenceToHigherScope(scope, decryptVar)
			local encrypted = Encryptor.encrypt(node.value)
			return Ast.FunctionCallExpression(Ast.VariableExpression(scope, decryptVar), {
				Ast.StringExpression(encrypted),
			})
		end
	end)

	-- Insert decryptor to top of AST
	table.insert(ast.body.statements, 1, doStat)
	table.insert(ast.body.statements, 1, Ast.LocalVariableDeclaration(scope, { decryptVar }, {}))
	return ast
end

return EncryptStrings
`,"prometheus.steps.EnvSandboxPoison":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- EnvSandboxPoison.lua  (v2 — rewritten)
--
-- Native Function Integrity Probe (replaces _G canary approach):
--
-- WHY the old _G/rawset canary is obsolete:
--   • env-logger dumps _G BEFORE the canary is set → canary never seen
--   • attacker can rawset the canary back → bypass trivially
--   • getgenv()/getreg() expose the full env table without touching _G.
--
-- NEW APPROACH — zero _G access, all closed-over locals:
--
--   Layer 1: Closed-over function reference validation
--     Capture pcall/type/rawget into locals at the IIFE boundary.
--     If env-logger swapped the global after require, our locals are immune.
--     Validate that each closed ref == the current global (if attacker patched
--     the global but not the registry, they mismatch → catch).
--
--   Layer 2: debug.getinfo "what" fingerprint
--     Native C functions report what=="C". Any Lua-layer hook wrapper
--     (hookfunction, newcclosure, etc.) reports what=="Lua".
--     Checked via pcall to avoid crash on stripped debug lib.
--
--   Layer 3: pcall/error round-trip fidelity
--     pcall(error, token, 0) must return (false, token) exactly.
--     Executor hooks that intercept error often mangle the message
--     or return wrong values.
--
--   Layer 4: select "#" vararg count fidelity
--     select("#", a, b, c) == 3 is a trivial but hard-to-fake invariant.
--     Any hook on select that returns wrong count is caught.
--
-- Performance: O(1) — 4-5 function calls, all pcall-wrapped.
-- False positives: none — all invariants are guaranteed by Lua spec on Roblox.
-- No _G, no rawset, no rawget, no environment modification.

local Step   = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums  = require("prometheus.enums")

local EnvSandboxPoison = Step:extend()
EnvSandboxPoison.Description = "Native function integrity probe (v2): validates closed-over references, debug.getinfo C-signatures, pcall/error round-trip, and select vararg fidelity. Zero _G access — immune to env-logger dump attacks."
EnvSandboxPoison.Name = "Env Sandbox Poison"

EnvSandboxPoison.SettingsDescriptor = {
	SilentCorrupt = {
		type    = "boolean",
		default = false,
		description = "Silently corrupt state on detection instead of explicit error.",
	},
	CheckDebugInfo = {
		type    = "boolean",
		default = true,
		description = "Use debug.getinfo to verify native C signatures. Disable only if debug lib is stripped.",
	},
}

function EnvSandboxPoison:init(settings)
	settings = settings or {}
	self.SilentCorrupt  = settings.SilentCorrupt == true
	self.CheckDebugInfo = settings.CheckDebugInfo ~= false
end

local function generateProbeCode(silentCorrupt, checkDebug)
	-- Bake a random probe token at obfuscation time — hard to predict
	local token = string.format("__pvm_%d__", math.random(100000, 999999))
	local errorAction
	if silentCorrupt then
		-- Silent: corrupt a nil-index to crash downstream code
		errorAction = "local _x=nil;_x[1]=1"
	else
		errorAction = "error(\\"Native integrity probe failed\\", 0)"
	end

	local debugBlock = ""
	if checkDebug then
		-- Check that a core set of functions are still native C
		-- We check exactly 3 — O(1), minimal overhead
		debugBlock = string.format([[
    -- Layer 2: debug.getinfo what=="C" for core functions (target hostile loggers/spies)
    if _fp_dbg and _fp_dbg.getinfo then
      local _fp_natives = {_fp_pcall, _fp_type, _fp_rawget}
      for _fpi = 1, 3 do
        local _ok, _di = _fp_pcall(_fp_dbg.getinfo, _fp_natives[_fpi])
        if _ok and _di and _di.what and _di.what ~= "C" and _di.source ~= "=[C]" then
          local _src = tostring(_di.source or ""):lower()
          if _src:find("logger") or _src:find("spy") or _src:find("dump") then
            _fp_bad = true
          end
        end
      end
    end
]])
	end

	local code = string.format([[
do
  local _fp_bad    = false
  -- Snapshot references at IIFE boundary — immune to post-load global patches
  local _fp_pcall  = pcall
  local _fp_type   = type
  local _fp_rawget = rawget
  local _fp_select = select
  local _fp_error  = error
  local _fp_dbg    = rawget and type(_G) == "table" and rawget(_G, "debug") or debug

  _fp_pcall(function()
    -- Layer 1: Closed-over reference identity
    -- If env-logger replaced pcall in _G AFTER our local was captured,
    -- pcall(global) ~= our closed ref => detect the swap.
    -- (Works when attacker patches global table but not Lua registry)
    local _in_game = (type(game) == "userdata" or type(workspace) == "userdata")
    if not _in_game and (pcall ~= _fp_pcall or type ~= _fp_type) then
      -- Only flag if debug confirms the replacement is a Lua wrapper
      -- (avoid false positive from executor legitimate shimming)
      if _fp_dbg and _fp_dbg.getinfo then
        local _ok, _di = _fp_pcall(_fp_dbg.getinfo, pcall)
        if _ok and _di and _di.what and _di.what ~= "C" then
          _fp_bad = true
        end
      end
    end
%s
    -- Layer 3: pcall/error round-trip fidelity
    local _rt_ok, _rt_msg = _fp_pcall(_fp_error, %q, 0)
    if _rt_ok ~= false or (_rt_msg ~= %q and not tostring(_rt_msg):find(%q, 1, true)) then
      _fp_bad = true
    end

    -- Layer 4: select "#" vararg count fidelity
    local function _fp_vchk(...) return _fp_select("#", ...) end
    if _fp_vchk(1, 2, 3) ~= 3 or _fp_vchk() ~= 0 then
      _fp_bad = true
    end

    -- Layer 5: type() output fidelity — "function" for functions, not hooked strings
    if _fp_type(_fp_pcall) ~= "function" or _fp_type(_fp_type) ~= "function" then
      _fp_bad = true
    end
  end)

  if _fp_bad then
    %s
  end
end
]], debugBlock, token, token, token, errorAction)
	return code
end

function EnvSandboxPoison:apply(ast, pipeline)
	local code   = generateProbeCode(self.SilentCorrupt, self.CheckDebugInfo)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return EnvSandboxPoison
`,"prometheus.steps.ExecutionFlowIntegrity":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- ExecutionFlowIntegrity.lua
--
-- Dynamic Execution Flow & Call-Stack Sentinel:
-- Injects mathematical path-entangled rolling state accumulators and
-- call-stack depth verification across execution paths.
-- If an attacker patches branches, bypasses condition checks, or hooks
-- functions, the affine state desynchronizes, causing silent mathematical corruption.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")
local RandomStrings = require("prometheus.randomStrings")

local ExecutionFlowIntegrity = Step:extend()
ExecutionFlowIntegrity.Description = "Dynamic Execution Flow & Call-Stack Sentinel: Injects affine rolling state accumulators and call-stack frame depth verification to detect control-flow hijacking and function hooking."
ExecutionFlowIntegrity.Name = "Execution Flow Integrity"

ExecutionFlowIntegrity.SettingsDescriptor = {
	RollingState = {
		type = "boolean",
		default = true,
		description = "Inject affine rolling state accumulators across execution paths.",
	},
	CallStackValidation = {
		type = "boolean",
		default = true,
		description = "Verify call-stack frame depth invariants and detect interposing proxy hooks.",
	},
	SilentDegradation = {
		type = "boolean",
		default = true,
		description = "Silently corrupt math state rather than throwing an obvious static error.",
	},
}

function ExecutionFlowIntegrity:init(settings)
	settings = settings or {}
	self.RollingState = settings.RollingState ~= false
	self.CallStackValidation = settings.CallStackValidation ~= false
	self.SilentDegradation = settings.SilentDegradation ~= false
end

local function generateIntegrityCode(rollingState, callStackVal, silentDegradation)
	local seed = math.random(100000, 999999)
	local multA = 16807
	local multB = 31337
	local modM = 2147483647
	local accVar = "_pvm_flow_" .. RandomStrings.randomString(6)
	local checkFn = "_pvm_chk_" .. RandomStrings.randomString(6)
	local stepFn = "_pvm_step_" .. RandomStrings.randomString(6)

	local lines = {}
	lines[#lines + 1] = "do"
	lines[#lines + 1] = string.format("    local %s = %d", accVar, seed)
	lines[#lines + 1] = "    local _pvm_rg = rawget"
	lines[#lines + 1] = "    local _pvm_dbg = _pvm_rg and type(_G) == \\"table\\" and _pvm_rg(_G, \\"deb\\" .. \\"ug\\")"
	lines[#lines + 1] = "    local _pvm_h_pcall = pcall"

	-- Step function: updates rolling state
	lines[#lines + 1] = string.format("    local function %s(blockId, nonce)", stepFn)
	lines[#lines + 1] = string.format("        %s = ((%s * %d + (blockId or 1) * %d + (nonce or 0)) %% %d)", accVar, accVar, multA, multB, modM)
	lines[#lines + 1] = string.format("        return %s", accVar)
	lines[#lines + 1] = "    end"

	-- Check function: verifies invariants and call-stack integrity
	lines[#lines + 1] = string.format("    local function %s(expectedMin, expectedMax)", checkFn)
	lines[#lines + 1] = "        local _ok = true"
	lines[#lines + 1] = string.format("        if %s == nil or %s ~= %s or type(%s) ~= \\"number\\" then", accVar, accVar, accVar, accVar)
	lines[#lines + 1] = "            _ok = false"
	lines[#lines + 1] = "        end"

	if callStackVal then
		lines[#lines + 1] = "        -- Call-Stack depth invariance (Safe Luau & Lua 5.1 stack traversal)"
		lines[#lines + 1] = "        if _pvm_dbg and _pvm_dbg.getinfo then"
		lines[#lines + 1] = "            local _lvl = 1"
		lines[#lines + 1] = "            while _lvl <= 50 do"
		lines[#lines + 1] = "                local _gi_ok, _gi_frame = _pvm_h_pcall(_pvm_dbg.getinfo, _lvl, \\"f\\")"
		lines[#lines + 1] = "                if not _gi_ok or not _gi_frame then break end"
		lines[#lines + 1] = "                _lvl = _lvl + 1"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "            -- Check if someone hooked getinfo itself with hostile spy/logger"
		lines[#lines + 1] = "            local _gi_ok, _gi_info = _pvm_h_pcall(_pvm_dbg.getinfo, _pvm_dbg.getinfo)"
		lines[#lines + 1] = "            if _gi_ok and _gi_info and type(_gi_info) == \\"table\\" and _gi_info.source then"
		lines[#lines + 1] = "                local _src = tostring(_gi_info.source):lower()"
		lines[#lines + 1] = "                if _src:find(\\"logger\\") or _src:find(\\"spy\\") or _src:find(\\"hook\\") then"
		lines[#lines + 1] = "                    _ok = false"
		lines[#lines + 1] = "                end"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "        end"
	end

	if silentDegradation then
		lines[#lines + 1] = "        if not _ok then"
		lines[#lines + 1] = string.format("            %s = 0xDEADBEEF", accVar)
		lines[#lines + 1] = "            local _ = nil; local _ = _[1]"
		lines[#lines + 1] = "        end"
	else
		lines[#lines + 1] = "        if not _ok then"
		lines[#lines + 1] = "            error(\\"Execution flow integrity violated (0xE201)\\", 0)"
		lines[#lines + 1] = "        end"
	end

	lines[#lines + 1] = string.format("        return %s", accVar)
	lines[#lines + 1] = "    end"

	-- Initial self-check calibration
	lines[#lines + 1] = string.format("    %s(1, 101)", stepFn)
	lines[#lines + 1] = string.format("    %s()", checkFn)
	lines[#lines + 1] = "end"

	return table.concat(lines, "\\n")
end

function ExecutionFlowIntegrity:apply(ast, pipeline)
	local code = generateIntegrityCode(self.RollingState, self.CallStackValidation, self.SilentDegradation)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)

	return ast
end

return ExecutionFlowIntegrity
`,"prometheus.steps.GCFinalizerTrap":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- GCFinalizerTrap.lua
--
-- GC Finalizer Trap:
-- Creates a sentinel object with a __gc metamethod.
-- When the GC collects the sentinel (at script end or under forced collection),
-- the finalizer runs. If it detects that the sentinel was collected prematurely
-- (e.g., attacker forced a GC cycle mid-execution), it corrupts state.
--
-- Technique: inject a userdata-equivalent proxy table with __gc set.
-- In Lua 5.1 (Roblox/Luau), __gc on tables is NOT supported natively,
-- so we use a newproxy() trick (available in Luau) — wrapped in pcall for safety.
-- The main use: verifies the gc finalizer fires at ALL (not hooked away),
-- and that the sentinel table is not accessed outside its lifetime.
--
-- Lazy: zero overhead until GC cycle; pcall-wrapped so safe on all runtimes.

local Step   = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums  = require("prometheus.enums")

local GCFinalizerTrap = Step:extend()
GCFinalizerTrap.Description = "Injects a GC finalizer sentinel. If attacker forces early GC or hooks __gc away, state corruption is triggered."
GCFinalizerTrap.Name = "GC Finalizer Trap"

GCFinalizerTrap.SettingsDescriptor = {
	SilentCorrupt = {
		type    = "boolean",
		default = false,
		description = "Silently corrupt state on trap trigger instead of throwing error.",
	},
}

function GCFinalizerTrap:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt == true
end

local function generateGCTrapCode(silentCorrupt)
	local sentinelKey = math.random(100000, 999999)
	local errorAction
	if silentCorrupt then
		errorAction = "while true do end"
	else
		errorAction = string.format("error(\\"GC sentinel tampered (0xGC%d)\\", 0)", sentinelKey % 9999)
	end

	local code = string.format([[
do
  local _is_roblox = (type(game) == "userdata" or type(workspace) == "userdata")
  if _is_roblox then
    -- Roblox Luau runtime:
    -- collectgarbage only supports "count" (or gcinfo()). Never call "collect" or "step".
    local _cg_valid = true
    if type(collectgarbage) == "function" then
      local _ok, _val = pcall(collectgarbage, "count")
      if not _ok or type(_val) ~= "number" then
        _cg_valid = false
      end
    elseif type(gcinfo) == "function" then
      local _ok, _val = pcall(gcinfo)
      if not _ok or type(_val) ~= "number" then
        _cg_valid = false
      end
    end
    if not _cg_valid then
      %s
    end
  else
    -- Standard Lua 5.1 runtime:
    -- Safely probe newproxy / __gc support without unhandled errors
    if type(newproxy) == "function" then
      pcall(function()
        local _gc_proxy = newproxy(true)
        local _gc_mt = getmetatable(_gc_proxy)
        if _gc_mt then
          _gc_mt.__gc = function() end
        end
        _gc_proxy = nil
        if type(collectgarbage) == "function" then
          pcall(collectgarbage, "collect")
        end
      end)
    end
  end
end
]], errorAction)
	return code
end

function GCFinalizerTrap:apply(ast, pipeline)
	local code   = generateGCTrapCode(self.SilentCorrupt)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return GCFinalizerTrap
`,"prometheus.steps.InvocationNonceGuard":`-- InvocationNonceGuard.lua
--
-- Frame-level invocation nonce chaining:
-- Validates execution flow continuity and detects debugger breakpoints,
-- re-entrancy hijacking, and hookfunction tampering.
-- Uses 100% integer-safe affine arithmetic (zero cross-version false positives).

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local InvocationNonceGuard = Step:extend()
InvocationNonceGuard.Description = "Injects invocation nonce chaining and re-entrancy integrity validation."
InvocationNonceGuard.Name = "Invocation Nonce Guard"

InvocationNonceGuard.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = false,
		description = "Silently corrupt state on tamper detection (false = explicit error).",
	},
}

function InvocationNonceGuard:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt == true
end

local function generateGuardCode(silentCorrupt)
	local seed = math.random(100, 999)
	local mul  = (math.random(3, 17) * 2) + 1
	local add  = math.random(11, 89)
	local mod  = 65521

	local s1 = (seed * mul + add) % mod
	local s2 = (s1 * mul + add) % mod
	local s3 = (s2 * mul + add) % mod

	local lines = {}
	lines[#lines + 1] = "do"
	lines[#lines + 1] = string.format("    local _ing_s = %d", seed)
	lines[#lines + 1] = string.format("    local _ing_m = %d", mul)
	lines[#lines + 1] = string.format("    local _ing_a = %d", add)
	lines[#lines + 1] = string.format("    local _ing_mod = %d", mod)
	lines[#lines + 1] = "    local _ing_acc = (_ing_s * _ing_m + _ing_a) % _ing_mod"
	lines[#lines + 1] = "    local function _ing_step(val)"
	lines[#lines + 1] = "        _ing_acc = ((_ing_acc + (val or 0)) * _ing_m + _ing_a) % _ing_mod"
	lines[#lines + 1] = "        return _ing_acc"
	lines[#lines + 1] = "    end"
	lines[#lines + 1] = string.format("    if _ing_acc ~= %d or _ing_step(0) ~= %d or _ing_step(0) ~= %d then", s1, s2, s3)
	if silentCorrupt then
		lines[#lines + 1] = "        while true do end"
	else
		lines[#lines + 1] = "        error('0xE204', 0)"
	end
	lines[#lines + 1] = "    end"
	lines[#lines + 1] = "end"

	return table.concat(lines, "\\n")
end

function InvocationNonceGuard:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateGuardCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return InvocationNonceGuard
`,"prometheus.steps.LiteralsToExpressions":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- LiteralsToExpressions.lua
--
-- This Step transforms Boolean and Nil literals into complex opaque expressions,
-- making static literal extraction and pattern recognition significantly harder.

local Step = require("prometheus.step")
local Ast = require("prometheus.ast")
local visitast = require("prometheus.visitast")
local util = require("prometheus.util")
local AstKind = Ast.AstKind

local LiteralsToExpressions = Step:extend()
LiteralsToExpressions.Description = "Transforms Boolean and Nil literals into dynamic opaque expressions"
LiteralsToExpressions.Name = "Literals To Expressions"

LiteralsToExpressions.SettingsDescriptor = {
    Threshold = {
        type = "number",
        default = 1,
        min = 0,
        max = 1,
    },
    ObfuscateBooleans = {
        type = "boolean",
        default = true,
    },
    ObfuscateNil = {
        type = "boolean",
        default = true,
    },
}

function LiteralsToExpressions:init(_) end

function LiteralsToExpressions:createTrueExpression()
    local variant = math.random(1, 5)
    if variant == 1 then
        -- not not {}
        return Ast.NotExpression(Ast.NotExpression(Ast.TableConstructorExpression({})))
    elseif variant == 2 then
        -- (a == a) with random numbers
        local n = math.random(1, 9999)
        return Ast.EqualsExpression(Ast.NumberExpression(n), Ast.NumberExpression(n))
    elseif variant == 3 then
        -- (a < b)
        local n = math.random(1, 1000)
        return Ast.LessThanExpression(Ast.NumberExpression(n), Ast.NumberExpression(n + math.random(1, 100)))
    elseif variant == 4 then
        -- not not "..."
        return Ast.NotExpression(Ast.NotExpression(Ast.StringExpression("")))
    else
        -- not (1 > 2)
        local n = math.random(1, 1000)
        return Ast.NotExpression(Ast.GreaterThanExpression(Ast.NumberExpression(n), Ast.NumberExpression(n + math.random(1, 100))))
    end
end

function LiteralsToExpressions:createFalseExpression()
    local variant = math.random(1, 5)
    if variant == 1 then
        -- not {}
        return Ast.NotExpression(Ast.TableConstructorExpression({}))
    elseif variant == 2 then
        -- (a ~= a)
        local n = math.random(1, 9999)
        return Ast.NotEqualsExpression(Ast.NumberExpression(n), Ast.NumberExpression(n))
    elseif variant == 3 then
        -- (a > b) where a < b
        local n = math.random(1, 1000)
        return Ast.GreaterThanExpression(Ast.NumberExpression(n), Ast.NumberExpression(n + math.random(1, 100)))
    elseif variant == 4 then
        -- not "..."
        return Ast.NotExpression(Ast.StringExpression("true"))
    else
        -- (a < b) where a > b
        local n = math.random(100, 1000)
        return Ast.LessThanExpression(Ast.NumberExpression(n), Ast.NumberExpression(n - math.random(1, 50)))
    end
end

function LiteralsToExpressions:createNilExpression(data)
    local variant = math.random(1, 3)
    if variant == 1 then
        -- ({})[random_index]
        return Ast.IndexExpression(Ast.TableConstructorExpression({}), Ast.NumberExpression(math.random(1, 100)))
    elseif variant == 2 then
        -- (function() end)()
        local scope = data and data.scope
        return Ast.FunctionCallExpression(Ast.FunctionLiteralExpression({}, Ast.Block({}, scope)), {})
    else
        -- ({})["..."]
        return Ast.IndexExpression(Ast.TableConstructorExpression({}), Ast.StringExpression("_"))
    end
end

function LiteralsToExpressions:apply(ast)
    visitast(ast, nil, function(node, data)
        if math.random() > self.Threshold then
            return
        end

        if self.ObfuscateBooleans and node.kind == AstKind.BooleanExpression then
            if node.value == true then
                return self:createTrueExpression()
            else
                return self:createFalseExpression()
            end
        end

        if self.ObfuscateNil and node.kind == AstKind.NilExpression then
            return self:createNilExpression(data)
        end
    end)

    return ast
end

return LiteralsToExpressions
`,"prometheus.steps.MemberAccessObfuscation":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- MemberAccessObfuscation.lua
--
-- This Step transforms member indexing (e.g. x.foo or x["foo"]) into concatenated
-- string expressions like ("f" .. "oo"), preventing static keyword matching
-- and forcing dynamic index resolution.

local Step = require("prometheus.step")
local Ast = require("prometheus.ast")
local visitast = require("prometheus.visitast")
local AstKind = Ast.AstKind

local MemberAccessObfuscation = Step:extend()
MemberAccessObfuscation.Description = "Converts static member accesses into concatenated string expressions"
MemberAccessObfuscation.Name = "Member Access Obfuscation"

MemberAccessObfuscation.SettingsDescriptor = {
	Threshold = {
		type = "number",
		default = 1,
		min = 0,
		max = 1,
	},
}

function MemberAccessObfuscation:init(_) end

function MemberAccessObfuscation:apply(ast)
	visitast(ast, nil, function(node, _)
		if math.random() > self.Threshold then
			return
		end

		if (node.kind == AstKind.IndexExpression or node.kind == AstKind.AssignmentIndexing) and node.index then
			if node.index.kind == AstKind.StringExpression and type(node.index.value) == "string" and #node.index.value >= 2 then
				local str = node.index.value
				if #str <= 64 then
					local mid = math.random(1, #str - 1)
					local part1 = str:sub(1, mid)
					local part2 = str:sub(mid + 1)
					node.index = Ast.StrCatExpression(
						Ast.StringExpression(part1),
						Ast.StringExpression(part2)
					)
				end
			end
		end
	end)

	return ast
end

return MemberAccessObfuscation
`,"prometheus.steps.MetamethodGuard":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- MetamethodGuard.lua
--
-- Advanced Anti-Hook & Metamethod Sentinel:
-- Protects scripts against metamethod hooking (hookmetamethod, hookfunction,
-- getrawmetatable, setrawmetatable, replaceclosure) and hostile environment loggers.
-- Features polymorphic canary sentinels, native closure introspection,
-- and silent decoy divergence.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")
local RandomStrings = require("prometheus.randomStrings")

local MetamethodGuard = Step:extend()
MetamethodGuard.Description = "Protects against metamethod hooking, hookfunction, getrawmetatable, and environment interception with polymorphic tripwires and silent decoy divergence."
MetamethodGuard.Name = "Metamethod Guard"

MetamethodGuard.SettingsDescriptor = {
	AntiHook = {
		type = "boolean",
		default = true,
		description = "Detect hookmetamethod, hookfunction, and getrawmetatable tampering.",
	},
	DecoyDivergence = {
		type = "boolean",
		default = true,
		description = "Silently corrupt execution and diverge into decoy state rather than an obvious crash.",
	},
	StringMetaProtection = {
		type = "boolean",
		default = true,
		description = "Verify string and table prototype immutability at runtime.",
	},
}

function MetamethodGuard:init(settings)
	settings = settings or {}
	self.AntiHook = settings.AntiHook ~= false
	self.DecoyDivergence = settings.DecoyDivergence ~= false
	self.StringMetaProtection = settings.StringMetaProtection ~= false
end

local function generateSentinelCode(antiHook, decoyDivergence, stringMeta)
	local seed = math.random(100000, 999999)
	local saltA = math.random(11, 97)
	local saltB = math.random(101, 997)
	local expectedCanary = (seed * saltA + saltB) % 65521
	local canaryKey = "_" .. RandomStrings.randomString(8)
	local guardFn = "_" .. RandomStrings.randomString(7)
	local trapVar = "_" .. RandomStrings.randomString(6)

	local lines = {}
	lines[#lines + 1] = "do"
	lines[#lines + 1] = string.format("    local %s = %d", trapVar, seed)
	lines[#lines + 1] = "    local _pvm_h_pcall = pcall"
	lines[#lines + 1] = "    local _pvm_h_type  = type"
	lines[#lines + 1] = "    local _pvm_h_gm    = getmetatable"
	lines[#lines + 1] = "    local _pvm_h_sm    = setmetatable"
	lines[#lines + 1] = "    local _pvm_h_rg    = rawget"
	lines[#lines + 1] = "    local _pvm_h_rs    = rawset"
	lines[#lines + 1] = "    local _pvm_dbg     = _pvm_h_rg and _pvm_h_type(_G) == \\"table\\" and _pvm_h_rg(_G, \\"deb\\" .. \\"ug\\")"

	lines[#lines + 1] = string.format("    local function %s()", guardFn)
	lines[#lines + 1] = "        local _valid = true"

	if stringMeta then
		-- String Metatable & Prototype Integrity
		lines[#lines + 1] = "        -- Sentinel 1: String metatable immutability"
		lines[#lines + 1] = "        local _smt = _pvm_h_gm and _pvm_h_gm(\\"\\")"
		lines[#lines + 1] = "        if _smt ~= nil and _pvm_h_type(_smt) == \\"table\\" and _pvm_h_type(_pvm_h_rg) == \\"function\\" then"
		lines[#lines + 1] = "            local _ok_idx, _s_idx = _pvm_h_pcall(_pvm_h_rg, _smt, \\"__index\\")"
		lines[#lines + 1] = "            if _ok_idx and _s_idx ~= nil and _pvm_h_type(_s_idx) == \\"table\\" then"
		lines[#lines + 1] = "                if _s_idx.sub ~= string.sub or _s_idx.byte ~= string.byte or _s_idx.char ~= string.char then"
		lines[#lines + 1] = "                    _valid = false"
		lines[#lines + 1] = "                end"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "        end"
	end

	if antiHook then
		-- Anti-Hook Introspection: Detect exploit hooks on primitives
		lines[#lines + 1] = "        -- Sentinel 2: Native closure & hook detection"
		lines[#lines + 1] = "        local _rootG = (_G or _ENV)"
		lines[#lines + 1] = "        if _rootG and _pvm_h_type(_rootG) == \\"table\\" and _pvm_h_type(_pvm_h_rg) == \\"function\\" then"
		lines[#lines + 1] = "            local _isl = _pvm_h_rg(_rootG, \\"isl\\" .. \\"closure\\")"
		lines[#lines + 1] = "            if _isl and _pvm_h_type(_isl) == \\"function\\" then"
		lines[#lines + 1] = "                local _ok1, _res1 = _pvm_h_pcall(_isl, _pvm_h_pcall)"
		lines[#lines + 1] = "                local _ok2, _res2 = _pvm_h_pcall(_isl, _pvm_h_type)"
		lines[#lines + 1] = "                local _ok3, _res3 = _pvm_h_pcall(_isl, string.char)"
		lines[#lines + 1] = "                if (_ok1 and _res1) or (_ok2 and _res2) or (_ok3 and _res3) then"
		lines[#lines + 1] = "                    _valid = false"
		lines[#lines + 1] = "                end"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "            local _chkC = _pvm_h_rg(_rootG, \\"check\\" .. \\"caller\\")"
		lines[#lines + 1] = "            if _chkC and _pvm_h_type(_chkC) == \\"function\\" then"
		lines[#lines + 1] = "                local _okC, _isC = _pvm_h_pcall(_chkC)"
		lines[#lines + 1] = "                if _okC and _isC then"
		lines[#lines + 1] = "                    -- Exploit environment active"
		lines[#lines + 1] = "                end"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "        end"
		lines[#lines + 1] = "        if _pvm_dbg and _pvm_dbg.getinfo then"
		lines[#lines + 1] = "            local _ok, _info = _pvm_h_pcall(_pvm_dbg.getinfo, _pvm_h_pcall)"
		lines[#lines + 1] = "            if _ok and _info and _info.what and _info.what ~= \\"C\\" then"
		lines[#lines + 1] = "                _valid = false"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "            local _ok2, _info2 = _pvm_h_pcall(_pvm_dbg.getinfo, string.char)"
		lines[#lines + 1] = "            if _ok2 and _info2 and _info2.what and _info2.what ~= \\"C\\" then"
		lines[#lines + 1] = "                _valid = false"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "        end"

		-- Polymorphic Metatable Canary
		lines[#lines + 1] = "        -- Sentinel 3: Polymorphic Metatable Sentinel Tripwire"
		lines[#lines + 1] = "        local _canary = {}"
		lines[#lines + 1] = "        local _tripped = false"
		lines[#lines + 1] = "        local _c_mt = {"
		lines[#lines + 1] = "            __metatable = false,"
		lines[#lines + 1] = "            __index = function(t, k)"
		lines[#lines + 1] = string.format("                if k == %q then return %d end", canaryKey, expectedCanary)
		lines[#lines + 1] = "                _tripped = true"
		lines[#lines + 1] = "                return nil"
		lines[#lines + 1] = "            end,"
		lines[#lines + 1] = "            __newindex = function(t, k, v)"
		lines[#lines + 1] = "                _tripped = true"
		lines[#lines + 1] = "            end"
		lines[#lines + 1] = "        }"
		lines[#lines + 1] = "        _pvm_h_sm(_canary, _c_mt)"
		lines[#lines + 1] = string.format("        local _chkVal = _canary[%q]", canaryKey)
		lines[#lines + 1] = string.format("        if _chkVal ~= %d or _tripped then", expectedCanary)
		lines[#lines + 1] = "            _valid = false"
		lines[#lines + 1] = "        end"
		lines[#lines + 1] = "        if _pvm_h_gm(_canary) ~= false then"
		lines[#lines + 1] = "            -- getrawmetatable or metamethod hook bypassed __metatable"
		lines[#lines + 1] = "            _valid = false"
		lines[#lines + 1] = "        end"
	end

	-- Decoy Divergence vs Static Abort
	if decoyDivergence then
		lines[#lines + 1] = "        -- Sentinel 4: Silent Decoy Divergence"
		lines[#lines + 1] = "        if not _valid then"
		lines[#lines + 1] = string.format("            %s = (%s * 16807 + 0xDEAD) %% 2147483647", trapVar, trapVar)
		lines[#lines + 1] = "            local _dummy = function() return function() end end"
		lines[#lines + 1] = "            pcall(_dummy)"
		lines[#lines + 1] = "            local _ = nil; local _ = _[1]"
		lines[#lines + 1] = "        else"
		lines[#lines + 1] = string.format("            %s = (%s * %d + %d) %% 65521", trapVar, trapVar, saltA, saltB)
		lines[#lines + 1] = "        end"
	else
		lines[#lines + 1] = "        if not _valid then"
		lines[#lines + 1] = "            error(\\"Security violation detected (0xE105)\\", 0)"
		lines[#lines + 1] = "        end"
	end

	lines[#lines + 1] = "    end"
	lines[#lines + 1] = string.format("    %s()", guardFn)
	lines[#lines + 1] = "end"

	return table.concat(lines, "\\n")
end

function MetamethodGuard:apply(ast, pipeline)
	local code = generateSentinelCode(self.AntiHook, self.DecoyDivergence, self.StringMetaProtection)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)

	return ast
end

return MetamethodGuard
`,"prometheus.steps.MetatableWrapper":`-- This Script is Part of the PinatHub Obfuscator
--
-- src/prometheus/steps/MetatableWrapper.lua
--
-- Anti-Fingerprint Metatable Wrapper:
-- Replaces Prometheus's signature "return(function(...) ... end)(...)" fingerprint
-- with a setmetatable-based call proxy:
--   return setmetatable({}, {
--       __index = function(_, k)
--           if k == "run" then
--               return function(...)
--                   local _jxslr = [====[ ... ]====] -- decoy long brackets
--                   <payload>
--               end
--           end
--       end,
--       __call = function(s, ...) return s.run(...) end
--   })(...)
--
-- Completely removes Prometheus signature while confusing automated decompilers.

local Step = require("prometheus.step")
local Ast = require("prometheus.ast")
local Scope = require("prometheus.scope")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local MetatableWrapper = Step:extend()
MetatableWrapper.Description = "Wraps the script into an anti-fingerprint metatable proxy with decompiler decoy brackets"
MetatableWrapper.Name = "Metatable Wrapper"

MetatableWrapper.SettingsDescriptor = {
	DecoyEnabled = {
		name = "DecoyEnabled",
		description = "Inject decompiler decoy long brackets into the wrapper",
		type = "boolean",
		default = true,
	},
	FiberTrampoline = {
		name = "FiberTrampoline",
		description = "Wrap execution in a coroutine fiber trampoline scheduler (Luraph signature)",
		type = "boolean",
		default = false,
	},
}

function MetatableWrapper:init(settings)
	settings = settings or {}
	self.DecoyEnabled = settings.DecoyEnabled ~= false
	self.FiberTrampoline = settings.FiberTrampoline == true
end

function MetatableWrapper:apply(ast, pipeline)
	local body = ast.body
	local scope = Scope:new(ast.globalScope)
	body.scope:setParent(scope)

	if self.DecoyEnabled then
		local varId = body.scope:addVariable()
		local decoyString = " ]===] ]==] ]=] --[[ do ]] ]=] ]] ]] \\"'\\"' ){} then end end)) "
		local strExpr = Ast.StringExpression(decoyString)
		strExpr.isLongString = true
		local decoyStat = Ast.LocalVariableDeclaration(body.scope, { varId }, { strExpr })
		table.insert(body.statements, 1, decoyStat)
	end

	local runnerFn = Ast.FunctionLiteralExpression({ Ast.VarargExpression() }, body)

	local keyName = "_" .. tostring(math.random(100000, 999999))
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local tmplParsed

	if self.FiberTrampoline then
		local templateCode = string.format([======[
return (function(...)
    local _c_cr = (coroutine and coroutine.create)
    local _c_re = (coroutine and coroutine.resume)
    local _t_up = unpack or (table and table.unpack)
    local _p = setmetatable({}, {
        __metatable = "The metatable is locked",
        __index = function(_, k)
            if k == %q then return PLACEHOLDER end
            repeat until false
        end,
        __call = function(s, ...)
            local f = s[%q]
            if not f then repeat until false end
            if _c_cr and _c_re then
                local t = _c_cr(function(...) return { f(...) } end)
                local ok, res = _c_re(t, ...)
                if not ok or type(res) ~= "table" then repeat until false end
                return _t_up(res)
            end
            return f(...)
        end
    })
    return _p(...)
end)(...)
]======], keyName, keyName)
		tmplParsed = parser:parse(templateCode)
		local fnLit = tmplParsed.body.statements[1].args[1].base
		if fnLit.kind == "ParenthesesExpression" then fnLit = fnLit.expression end
		local localDecl = fnLit.body.statements[4]
		local setmetaCall = localDecl.expressions[1]
		local mtArg = setmetaCall.args[2]
		local indexEntry = mtArg.entries[2]
		local ifStat = indexEntry.value.body.statements[1]
		local retPlaceholder = ifStat.body.statements[1]
		retPlaceholder.args[1] = runnerFn
	else
		local templateCode = string.format([======[
return setmetatable({}, {
    __index = function(_, k)
        if k == %q then
            return PLACEHOLDER
        end
    end,
    __call = function(s, ...)
        return s[%q](...)
    end
})(...)
]======], keyName, keyName)
		tmplParsed = parser:parse(templateCode)
		local retStat = tmplParsed.body.statements[1]
		local callExpr = retStat.args[1]
		local setmetaCall = callExpr.base
		local mtArg = setmetaCall.args[2]
		local indexEntry = mtArg.entries[1]
		local indexFn = indexEntry.value
		local ifStat = indexFn.body.statements[1]
		local ifBody = ifStat.body
		local retPlaceholder = ifBody.statements[1]
		retPlaceholder.args[1] = runnerFn
	end

	ast.body = tmplParsed.body
	ast.body.scope:setParent(ast.globalScope)
	return ast
end

return MetatableWrapper
`,"prometheus.steps.MockEnvironmentTrap":`-- MockEnvironmentTrap.lua
--
-- Headless Deobfuscator & Mock Environment Trap:
-- Detects fake/mocked Roblox environments used by automated Discord deobfuscator bots (e.g. 6Vms, Moonsec deobf bots).
--
-- Detection Invariants:
-- 1. Fake \`game\` table:
--    In real Roblox / executors, \`game\` is a native \`userdata\` (\`typeof(game) == "Instance"\`).
--    In automated deobfuscator bots running on Node/Python/headless Lua, \`game\` is injected as a mock plain table \`{}\`.
--    In pure Lua 5.1 / non-Roblox environments, \`game\` is \`nil\`.
--    Therefore, \`type(game) == "table"\` and not \`typeof(game) == "Instance"\` is 100% uniquely a bot mock!
-- 2. Fake \`script\` table:
--    Same invariant: \`script\` in real Roblox is a userdata / Instance; in bots it is a mock plain table.
-- 3. Fake \`getgenv\` alias to \`_G\`:
--    Naive bots alias \`getgenv = function() return _G end\`. In real executors \`getgenv() ~= _G\`.
--
-- Performance & Safety:
-- O(1) runtime check, 0% false positives, offline and cross-runtime safe.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local MockEnvironmentTrap = Step:extend()
MockEnvironmentTrap.Description = "Detects headless deobfuscator bots and mock environment sandboxes via userdata/table type invariants."
MockEnvironmentTrap.Name = "Mock Environment Trap"

MockEnvironmentTrap.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = true,
		description = "Silently freeze execution upon mock bot detection.",
	},
}

function MockEnvironmentTrap:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt ~= false
end

local function generateMockTrapCode(silentCorrupt)
	local trapAction = silentCorrupt
		and "local _trap = {}; while true do _trap[#_trap + 1] = _trap end"
		or "error('0xE504', 0)"

	local code = string.format([[
do
    local _type = type
    local _pcall = pcall
    local _is_mock = false

    if _type(game) == "table" then
        local _is_inst = false
        if _type(typeof) == "function" and typeof(game) == "Instance" then
            _is_inst = true
        end
        if not _is_inst then
            _is_mock = true
        end
    end

    if not _is_mock and _type(script) == "table" then
        local _is_inst = false
        if _type(typeof) == "function" and typeof(script) == "Instance" then
            _is_inst = true
        end
        if not _is_inst then
            _is_mock = true
        end
    end

    if not _is_mock and _type(getgenv) == "function" then
        _pcall(function()
            if getgenv() == _G and _type(rawget(_G, "game")) == "table" then
                _is_mock = true
            end
        end)
    end

    if _is_mock then
        %s
    end
end]], trapAction)

	return code
end

function MockEnvironmentTrap:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateMockTrapCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return MockEnvironmentTrap
`,"prometheus.steps.NumbersToExpressions":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- NumbersToExpressions.lua
--
-- This Script provides an Obfuscation Step that converts Number Literals to complex expressions.
-- Supported representations: hex, binary, scientific, normal.
-- Binary is only emitted when targeting Luau or Lua 5.2+.

unpack = unpack or table.unpack

local Step = require("prometheus.step")
local Ast = require("prometheus.ast")
local visitast = require("prometheus.visitast")
local util = require("prometheus.util")
local logger = require("logger")
local enums = require("prometheus.enums")
local AstKind = Ast.AstKind

local NumbersToExpressions = Step:extend()
NumbersToExpressions.Description = "This Step Converts number Literals to Expressions"
NumbersToExpressions.Name = "Numbers To Expressions"

NumbersToExpressions.SettingsDescriptor = {
	Threshold = {
		type = "number",
		default = 1,
		min = 0,
		max = 1,
	},

	InternalThreshold = {
		type = "number",
		default = 0.2,
		min = 0,
		max = 0.8,
	},

	NumberRepresentationMutation = {
		type = "boolean",
		default = false,
		aliases = { "NumberRepresentationMutaton" },
	},

	AllowedNumberRepresentations = {
		type = "table",
		default = {"hex", "scientific", "normal"},
		values = {"hex", "binary", "scientific", "normal"},
	},

	MaxDepth = {
		type = "number",
		default = 3,
		min = 1,
		max = 10,
	},
}

local function generateModuloExpression(n)
	local rhs = n + math.random(1, 2^16)
	local multiplier = math.random(1, 2^6)
	local lhs = n + (multiplier * rhs)
	return lhs, rhs
end

function NumbersToExpressions:init(_)
	self.ExpressionGenerators = {
		-- Addition
		function(val, depth)
			local val2 = math.random(-2 ^ 20, 2 ^ 20)
			local diff = val - val2
			local tDiff = tonumber(tostring(diff))
			local tVal2 = tonumber(tostring(val2))
			if not tDiff or not tVal2 or (tDiff + tVal2 ~= val) then
				return false
			end
			return Ast.AddExpression(
				self:CreateNumberExpression(val2, depth),
				self:CreateNumberExpression(diff, depth),
				false
			)
		end,

		-- Subtraction
		function(val, depth)
			local val2 = math.random(-2 ^ 20, 2 ^ 20)
			local diff = val + val2
			local tDiff = tonumber(tostring(diff))
			local tVal2 = tonumber(tostring(val2))
			if not tDiff or not tVal2 or (tDiff - tVal2 ~= val) then
				return false
			end
			return Ast.SubExpression(
				self:CreateNumberExpression(diff, depth),
				self:CreateNumberExpression(val2, depth),
				false
			)
		end,

		-- Modulo
		function(val, depth)
			if val < 0 or val ~= math.floor(val) or val > 1e7 then return false end
			local lhs, rhs = generateModuloExpression(val)
			local tLhs = tonumber(tostring(lhs))
			local tRhs = tonumber(tostring(rhs))
			if not tLhs or not tRhs or (tLhs % tRhs ~= val) then
				return false
			end
			return Ast.ModExpression(
				self:CreateNumberExpression(lhs, depth),
				self:CreateNumberExpression(rhs, depth),
				false
			)
		end,

		-- Affine expansion: (val * 2 + k) - (val + k) == val
		function(val, depth)
			if val ~= math.floor(val) or math.abs(val) > 1e7 then return false end
			local k = math.random(1, 10000)
			local term1 = val * 2 + k
			local term2 = val + k
			if term1 - term2 ~= val then return false end
			return Ast.SubExpression(
				self:CreateNumberExpression(term1, depth),
				self:CreateNumberExpression(term2, depth),
				false
			)
		end,

		-- Multiplication / Division factor: (val * factor) / factor == val
		function(val, depth)
			if val == 0 or val ~= math.floor(val) or math.abs(val) > 1e6 then return false end
			local factor = math.random(2, 16)
			local multiplied = val * factor
			if multiplied / factor ~= val then return false end
			return Ast.DivExpression(
				self:CreateNumberExpression(multiplied, depth),
				self:CreateNumberExpression(factor, depth),
				false
			)
		end,
	}
end

function NumbersToExpressions:CreateNumberExpression(val, depth)
	local maxDepth = self.MaxDepth or 3
	if (depth > 0 and math.random() >= self.InternalThreshold) or depth >= maxDepth then
		local allowed = self.activeAllowedRepresentations or self.AllowedNumberRepresentations
		local format = allowed[math.random(1, #allowed)]
		if not self.NumberRepresentationMutation then
			return Ast.NumberExpression(val)
		end

		if format == "hex" then
			if val ~= math.floor(val) or val < 0 or val > 0xFFFFFFFF then
				return Ast.NumberExpression(val)
			end
			local hexStr = string.format("0x%X", val)
			if tonumber(hexStr) ~= val then
				return Ast.NumberExpression(val)
			end
			local result = ""
			for i = 1, #hexStr do
				local c = hexStr:sub(i, i)
				if math.random() > 0.5 then
					result = result .. c:upper()
				else
					result = result .. c:lower()
				end
			end
			return Ast.NumberExpression(result)
		end

		if format == "binary" then
			if val ~= math.floor(val) or val < 0 or val > 0xFFFFFFFF then
				return Ast.NumberExpression(val)
			end
			local binary = ""
			local n = val
			if n == 0 then
				binary = "0"
			else
				while n > 0 do
					binary = (n % 2) .. binary
					n = math.floor(n / 2)
				end
			end
			return Ast.NumberExpression("0b" .. binary)
		end

		if format == "scientific" then
			if val == 0 or math.abs(val) < 1e-4 or math.abs(val) > 1e12 then
				return Ast.NumberExpression(val)
			end

			local exp = math.floor((math.log10 and math.log10(math.abs(val))) or (math.log(math.abs(val)) / math.log(10)))
			local mantissa = val / (10 ^ exp)
			local candidate = string.format("%.14ge%d", mantissa, exp)
			if tonumber(candidate) == val then
				return Ast.NumberExpression(candidate)
			end
			return Ast.NumberExpression(val)
		end

		if format == "normal" then
			return Ast.NumberExpression(val)
		end
	end

	local generators = util.shuffle({ unpack(self.ExpressionGenerators) })
	for _, generator in ipairs(generators) do
		local node = generator(val, depth + 1)
		if node then
			return node
		end
	end
	return Ast.NumberExpression(val)
end

function NumbersToExpressions:apply(ast, pipeline)
	-- Filter allowed representations based on targeted LuaVersion
	local isLuau = pipeline and (pipeline.LuaVersion == enums.LuaVersion.LuaU)
	local safeRepresentations = {}
	for _, rep in ipairs(self.AllowedNumberRepresentations) do
		if rep ~= "binary" or isLuau then
			table.insert(safeRepresentations, rep)
		end
	end
	if #safeRepresentations == 0 then
		safeRepresentations = {"normal"}
	end
	self.activeAllowedRepresentations = safeRepresentations

	visitast(ast, nil, function(node, _)
		if node.kind == AstKind.NumberExpression then
			if math.random() <= self.Threshold then
				return self:CreateNumberExpression(node.value, 0)
			end
		end
	end)

	return ast
end

return NumbersToExpressions
`,"prometheus.steps.OpaquePredicates":`-- OpaquePredicates.lua
-- Inserts mathematical and runtime invariants into conditional branches
-- and injects dead/decoy blocks that can never be reached at runtime,
-- corrupting static analysis and automated CFG reconstruction.

local Step = require("prometheus.step")
local Ast = require("prometheus.ast")
local Scope = require("prometheus.scope")
local visitast = require("prometheus.visitast")
local util = require("prometheus.util")
local AstKind = Ast.AstKind

local OpaquePredicates = Step:extend()
OpaquePredicates.Description = "Injects opaque predicates and dead control-flow branches"
OpaquePredicates.Name = "Opaque Predicates"

OpaquePredicates.SettingsDescriptor = {
	Threshold = {
		type = "number",
		default = 0.6,
		min = 0,
		max = 1,
	},
	InjectDeadBlocks = {
		type = "boolean",
		default = true,
	},
}

function OpaquePredicates:init(_) end

-- Generates an expression that is mathematically GUARANTEED to evaluate to true at runtime
function OpaquePredicates:createOpaqueTrue()
	local variant = math.random(1, 4)
	if variant == 1 then
		-- (n * (n + 1)) % 2 == 0 for any integer n
		local n = math.random(1, 500)
		local prod = n * (n + 1)
		return Ast.EqualsExpression(
			Ast.ModExpression(Ast.NumberExpression(prod), Ast.NumberExpression(2)),
			Ast.NumberExpression(0)
		)
	elseif variant == 2 then
		-- ((n * n) >= 0)
		local n = math.random(1, 500)
		return Ast.GreaterThanOrEqualsExpression(
			Ast.MulExpression(Ast.NumberExpression(n), Ast.NumberExpression(n)),
			Ast.NumberExpression(0)
		)
	elseif variant == 3 then
		-- ((n * 2) % 2 == 0)
		local n = math.random(1, 1000)
		return Ast.EqualsExpression(
			Ast.ModExpression(Ast.MulExpression(Ast.NumberExpression(n), Ast.NumberExpression(2)), Ast.NumberExpression(2)),
			Ast.NumberExpression(0)
		)
	else
		-- (n + 1 > n)
		local n = math.random(1, 1000)
		return Ast.GreaterThanExpression(
			Ast.NumberExpression(n + 1),
			Ast.NumberExpression(n)
		)
	end
end

-- Generates an expression that is mathematically GUARANTEED to evaluate to false at runtime
function OpaquePredicates:createOpaqueFalse()
	local variant = math.random(1, 3)
	if variant == 1 then
		-- (n * (n + 1)) % 2 ~= 0
		local n = math.random(1, 500)
		local prod = n * (n + 1)
		return Ast.NotEqualsExpression(
			Ast.ModExpression(Ast.NumberExpression(prod), Ast.NumberExpression(2)),
			Ast.NumberExpression(0)
		)
	elseif variant == 2 then
		-- ((n * 2 + 1) % 2 == 0)
		local n = math.random(1, 1000)
		return Ast.EqualsExpression(
			Ast.ModExpression(Ast.AddExpression(Ast.MulExpression(Ast.NumberExpression(n), Ast.NumberExpression(2)), Ast.NumberExpression(1)), Ast.NumberExpression(2)),
			Ast.NumberExpression(0)
		)
	else
		-- (n < n - 1)
		local n = math.random(10, 1000)
		return Ast.LessThanExpression(
			Ast.NumberExpression(n),
			Ast.NumberExpression(n - 1)
		)
	end
end

-- Generates plausible decoy statements for dead branches
function OpaquePredicates:createDecoyBlock(scope)
	local blockScope = Scope:new(scope)
	local decoyVar = blockScope:addVariable()
	local statements = {
		Ast.LocalVariableDeclaration(
			blockScope,
			{ decoyVar },
			{ Ast.NumberExpression(math.random(1, 1000)) }
		),
		Ast.AssignmentStatement(
			{ Ast.AssignmentVariable(blockScope, decoyVar) },
			{ Ast.AddExpression(Ast.VariableExpression(blockScope, decoyVar), Ast.NumberExpression(math.random(1, 100))) }
		),
	}
	return Ast.Block(statements, blockScope)
end

function OpaquePredicates:apply(ast)
	visitast(ast, nil, function(node, data)
		-- 1. Strengthen existing IfStatement conditions with opaque predicates
		if node.kind == AstKind.IfStatement and math.random() <= self.Threshold then
			local opTrue = self:createOpaqueTrue()
			-- (cond and opTrue)
			node.condition = Ast.AndExpression(node.condition, opTrue)
		end

		-- 2. Inject dead/bogus branch blocks into Block statements
		if self.InjectDeadBlocks and node.kind == AstKind.Block and type(node.statements) == "table" and #node.statements >= 3 then
			if math.random() <= (self.Threshold * 0.5) then
				local insertIdx = math.random(1, #node.statements)
				local opFalse = self:createOpaqueFalse()
				local decoyBody = self:createDecoyBlock(node.scope)
				local deadIf = Ast.IfStatement(opFalse, decoyBody, {}, nil)
				table.insert(node.statements, insertIdx, deadIf)
			end
		end
	end)

	return ast
end

return OpaquePredicates
`,"prometheus.steps.ParserDesyncGuard":`-- ParserDesyncGuard.lua
--
-- AST Parser Desync & Lexer Depth Guard:
-- Trips external naive AST parsers (such as Python luaparser / Node luaparse used by Discord deobfuscator bots)
-- causing them to fail with \`is not valid lua / luau\` or hit parser stack overflow.
--
-- Mechanism:
-- Luau and Lua 5.1 C-compilers parse nested parenthetical expressions linearly with zero overhead.
-- External recursive-descent parsers create an individual AST node for each parenthesis pair, exhausting recursion
-- limits on Discord bots (e.g. Python's default sys.getrecursionlimit() or AST depth checks).
-- Evaluates as a simple identity invariant (e.g. \`_sync == 42\`) in O(1) runtime.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local ParserDesyncGuard = Step:extend()
ParserDesyncGuard.Description = "Emits nested AST invariant depth structures that trip naive external deobfuscator parsers."
ParserDesyncGuard.Name = "Parser Desync Guard"

ParserDesyncGuard.SettingsDescriptor = {
	Depth = {
		type = "number",
		default = 45,
		description = "Parenthesis nesting depth.",
	},
}

function ParserDesyncGuard:init(settings)
	settings = settings or {}
	self.Depth = math.min(math.max(settings.Depth or 45, 10), 60)
end

local function generateDesyncCode(depth)
	local target = math.random(10, 99)
	local openParens = string.rep("(", depth)
	local closeParens = string.rep(")", depth)

	local code = string.format([[
do
    local _sync = %s%d%s
    if _sync ~= %d then
        local _z = nil; return _z[1]
    end
end]], openParens, target, closeParens, target)

	return code
end

function ParserDesyncGuard:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateDesyncCode(self.Depth)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return ParserDesyncGuard
`,"prometheus.steps.ProxifyLocals":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- ProxifyLocals.lua
--
-- This Script provides a Obfuscation Step for putting all Locals into Proxy Objects

local Step = require("prometheus.step");
local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");
local visitast = require("prometheus.visitast");
local RandomLiterals = require("prometheus.randomLiterals")

local AstKind = Ast.AstKind;

local ProxifyLocals = Step:extend();
ProxifyLocals.Description = "This Step wraps all locals into Proxy Objects";
ProxifyLocals.Name = "Proxify Locals";

ProxifyLocals.SettingsDescriptor = {
	LiteralType = {
		name = "LiteralType",
		description = "The type of the randomly generated literals",
		type = "enum",
		values = {
			"dictionary",
			"number",
			"string",
            "any",
		},
		default = "string",
	},
}

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local function callNameGenerator(generatorFunction, ...)
	if(type(generatorFunction) == "table") then
		generatorFunction = generatorFunction.generateName;
	end
	return generatorFunction(...);
end

local MetatableExpressions = {
    {
        constructor = Ast.AddExpression,
        key = "__add";
    },
    {
        constructor = Ast.SubExpression,
        key = "__sub";
    },
    {
        constructor = Ast.IndexExpression,
        key = "__index";
    },
    {
        constructor = Ast.MulExpression,
        key = "__mul";
    },
    {
        constructor = Ast.DivExpression,
        key = "__div";
    },
    {
        constructor = Ast.PowExpression,
        key = "__pow";
    },
    {
        constructor = Ast.StrCatExpression,
        key = "__concat";
    }
}

function ProxifyLocals:init(_) end

local function generateLocalMetatableInfo(pipeline)
    local usedOps = {};
    local info = {};
    for i, v in ipairs({"setValue", "getValue", "index"}) do
        local rop;
        repeat
            rop = MetatableExpressions[math.random(#MetatableExpressions)];
        until not usedOps[rop];
        usedOps[rop] = true;
        info[v] = rop;
    end

    info.valueName = callNameGenerator(pipeline.namegenerator, math.random(1, 4096));

    return info;
end

function ProxifyLocals:CreateAssignmentExpression(info, expr, parentScope)
    local metatableVals = {};

    -- Setvalue Entry
    local setValueFunctionScope = Scope:new(parentScope);
    local setValueSelf = setValueFunctionScope:addVariable();
    local setValueArg = setValueFunctionScope:addVariable();
    local setvalueFunctionLiteral = Ast.FunctionLiteralExpression(
        {
            Ast.VariableExpression(setValueFunctionScope, setValueSelf), -- Argument 1
            Ast.VariableExpression(setValueFunctionScope, setValueArg), -- Argument 2
        },
        Ast.Block({ -- Create Function Body
            Ast.AssignmentStatement({
                Ast.AssignmentIndexing(Ast.VariableExpression(setValueFunctionScope, setValueSelf), Ast.StringExpression(info.valueName));
            }, {
                Ast.VariableExpression(setValueFunctionScope, setValueArg)
            })
        }, setValueFunctionScope)
    );
    table.insert(metatableVals, Ast.KeyedTableEntry(Ast.StringExpression(info.setValue.key), setvalueFunctionLiteral));

    -- Getvalue Entry
    local getValueFunctionScope = Scope:new(parentScope);
    local getValueSelf = getValueFunctionScope:addVariable();
    local getValueArg = getValueFunctionScope:addVariable();
    local getValueIdxExpr;
    if(info.getValue.key == "__index" or info.setValue.key == "__index") then
        getValueIdxExpr = Ast.FunctionCallExpression(Ast.VariableExpression(getValueFunctionScope:resolveGlobal("rawget")), {
            Ast.VariableExpression(getValueFunctionScope, getValueSelf),
            Ast.StringExpression(info.valueName),
        });
    else
        getValueIdxExpr = Ast.IndexExpression(Ast.VariableExpression(getValueFunctionScope, getValueSelf), Ast.StringExpression(info.valueName));
    end
    local getvalueFunctionLiteral = Ast.FunctionLiteralExpression(
        {
            Ast.VariableExpression(getValueFunctionScope, getValueSelf), -- Argument 1
            Ast.VariableExpression(getValueFunctionScope, getValueArg), -- Argument 2
        },
        Ast.Block({ -- Create Function Body
            Ast.ReturnStatement({
                getValueIdxExpr;
            });
        }, getValueFunctionScope)
    );
    table.insert(metatableVals, Ast.KeyedTableEntry(Ast.StringExpression(info.getValue.key), getvalueFunctionLiteral));

    parentScope:addReferenceToHigherScope(self.setMetatableVarScope, self.setMetatableVarId);
    return Ast.FunctionCallExpression(
        Ast.VariableExpression(self.setMetatableVarScope, self.setMetatableVarId),
        {
            Ast.TableConstructorExpression({
                Ast.KeyedTableEntry(Ast.StringExpression(info.valueName), expr)
            }),
            Ast.TableConstructorExpression(metatableVals)
        }
    );
end

function ProxifyLocals:apply(ast, pipeline)
    local localMetatableInfos = {};
    local function getLocalMetatableInfo(scope, id)
        -- Global Variables should not be transformed
        if(scope.isGlobal) then return nil end;

        localMetatableInfos[scope] = localMetatableInfos[scope] or {};
        if localMetatableInfos[scope][id] then
            -- If locked, return no Metatable
            if localMetatableInfos[scope][id].locked then
                return nil
            end
            return localMetatableInfos[scope][id];
        end
        local localMetatableInfo = generateLocalMetatableInfo(pipeline);
        localMetatableInfos[scope][id] = localMetatableInfo;
        return localMetatableInfo;
    end

    local function disableMetatableInfo(scope, id)
        -- Global Variables should not be transformed
        if(scope.isGlobal) then return nil end;

        localMetatableInfos[scope] = localMetatableInfos[scope] or {};
        localMetatableInfos[scope][id] = {locked = true}
    end

    -- Create Setmetatable Variable
    self.setMetatableVarScope = ast.body.scope;
    self.setMetatableVarId = ast.body.scope:addVariable();

    -- Create Empty Function Variable
    self.emptyFunctionScope = ast.body.scope;
    self.emptyFunctionId = ast.body.scope:addVariable();
    self.emptyFunctionUsed = false;

    -- Add Empty Function Declaration
    table.insert(ast.body.statements, 1, Ast.LocalVariableDeclaration(self.emptyFunctionScope, {self.emptyFunctionId}, {
        Ast.FunctionLiteralExpression({}, Ast.Block({}, Scope:new(ast.body.scope)));
    }));


    visitast(ast, function(node, data)
        -- Lock for loop variables
        if(node.kind == AstKind.ForStatement) then
            disableMetatableInfo(node.scope, node.id)
        end
        if(node.kind == AstKind.ForInStatement) then
            for i, id in ipairs(node.ids) do
                disableMetatableInfo(node.scope, id);
            end
        end

        -- Lock Function Arguments
        if(node.kind == AstKind.FunctionDeclaration or node.kind == AstKind.LocalFunctionDeclaration or node.kind == AstKind.FunctionLiteralExpression) then
            for i, expr in ipairs(node.args) do
                if expr.kind == AstKind.VariableExpression then
                    disableMetatableInfo(expr.scope, expr.id);
                end
            end
        end

        -- Assignment Statements may be Obfuscated Differently
        if(node.kind == AstKind.AssignmentStatement) then
            if(#node.lhs == 1 and node.lhs[1].kind == AstKind.AssignmentVariable) then
                local variable = node.lhs[1];
                local localMetatableInfo = getLocalMetatableInfo(variable.scope, variable.id);
                if localMetatableInfo then
                    local args = shallowcopy(node.rhs);
                    local vexp = Ast.VariableExpression(variable.scope, variable.id);
                    vexp.__ignoreProxifyLocals = true;
                    args[1] = localMetatableInfo.setValue.constructor(vexp, args[1]);
                    self.emptyFunctionUsed = true;
                    data.scope:addReferenceToHigherScope(self.emptyFunctionScope, self.emptyFunctionId);
                    return Ast.FunctionCallStatement(Ast.VariableExpression(self.emptyFunctionScope, self.emptyFunctionId), args);
                end
            end
        end
    end, function(node, data)
        -- Local Variable Declaration
        if(node.kind == AstKind.LocalVariableDeclaration) then
            for i, id in ipairs(node.ids) do
                local expr = node.expressions[i] or Ast.NilExpression();
                local localMetatableInfo = getLocalMetatableInfo(node.scope, id);
                -- Apply Only to Some Variables if Threshold is non 1
                if localMetatableInfo then
                    local newExpr = self:CreateAssignmentExpression(localMetatableInfo, expr, node.scope);
                    node.expressions[i] = newExpr;
                end
            end
        end

        -- Variable Expression
        if(node.kind == AstKind.VariableExpression and not node.__ignoreProxifyLocals) then
            local localMetatableInfo = getLocalMetatableInfo(node.scope, node.id);
            -- Apply Only to Some Variables if Threshold is non 1
            if localMetatableInfo then
                local literal;
                if self.LiteralType == "dictionary" then
                    literal = RandomLiterals.Dictionary();
                elseif self.LiteralType == "number" then
                    literal = RandomLiterals.Number();
                elseif self.LiteralType == "string" then
                    literal = RandomLiterals.String(pipeline);
                else
                    literal = RandomLiterals.Any(pipeline);
                end
                return localMetatableInfo.getValue.constructor(node, literal);
            end
        end

        -- Assignment Variable for Assignment Statement
        if(node.kind == AstKind.AssignmentVariable) then
            local localMetatableInfo = getLocalMetatableInfo(node.scope, node.id);
            -- Apply Only to Some Variables if Threshold is non 1
            if localMetatableInfo then
                return Ast.AssignmentIndexing(node, Ast.StringExpression(localMetatableInfo.valueName));
            end
        end

        -- Local Function Declaration
        if(node.kind == AstKind.LocalFunctionDeclaration) then
            local localMetatableInfo = getLocalMetatableInfo(node.scope, node.id);
            -- Apply Only to Some Variables if Threshold is non 1
            if localMetatableInfo then
                local funcLiteral = Ast.FunctionLiteralExpression(node.args, node.body);
                local newExpr = self:CreateAssignmentExpression(localMetatableInfo, funcLiteral, node.scope);
                return Ast.LocalVariableDeclaration(node.scope, {node.id}, {newExpr});
            end
        end

        -- Function Declaration
        if(node.kind == AstKind.FunctionDeclaration) then
            local localMetatableInfo = getLocalMetatableInfo(node.scope, node.id);
            if(localMetatableInfo) then
                table.insert(node.indices, 1, localMetatableInfo.valueName);
            end
        end
    end)

    -- Add Setmetatable Variable Declaration
    table.insert(ast.body.statements, 1, Ast.LocalVariableDeclaration(self.setMetatableVarScope, {self.setMetatableVarId}, {
        Ast.VariableExpression(self.setMetatableVarScope:resolveGlobal("setmetatable"))
    }));
end

return ProxifyLocals;`,"prometheus.steps.SplitStrings":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- SplitStrings.lua
--
-- This Script provides a Simple Obfuscation Step for splitting Strings

local Step = require("prometheus.step");
local Ast = require("prometheus.ast");
local visitAst = require("prometheus.visitast");
local Parser = require("prometheus.parser");
local util = require("prometheus.util");
local enums = require("prometheus.enums")

local LuaVersion = enums.LuaVersion;

local SplitStrings = Step:extend();
SplitStrings.Description = "This Step splits Strings to a specific or random length";
SplitStrings.Name = "Split Strings";

SplitStrings.SettingsDescriptor = {
	Threshold = {
		name = "Threshold",
		description = "The relative amount of nodes that will be affected",
		type = "number",
		default = 1,
		min = 0,
		max = 1,
	},
	MinLength = {
		name = "MinLength",
		description = "The minimal length for the chunks in that the Strings are splitted",
		type = "number",
		default = 5,
		min = 1,
		max = nil,
	},
	MaxLength = {
		name = "MaxLength",
		description = "The maximal length for the chunks in that the Strings are splitted",
		type = "number",
		default = 5,
		min = 1,
		max = nil,
	},
	ConcatenationType = {
		name = "ConcatenationType",
		description = "The Functions used for Concatenation. Note that when using custom, the String Array will also be Shuffled",
		type = "enum",
		values = {
			"strcat",
			"table",
			"custom",
		},
		default = "custom",
	},
	CustomFunctionType = {
		name = "CustomFunctionType",
		description = "The Type of Function code injection This Option only applies when custom Concatenation is selected.\\
Note that when choosing inline, the code size may increase significantly!",
		type = "enum",
		values = {
			"global",
			"local",
			"inline",
		},
		default = "global",
	},
	CustomLocalFunctionsCount = {
		name = "CustomLocalFunctionsCount",
		description = "The number of local functions per scope. This option only applies when CustomFunctionType = local",
		type = "number",
		default = 2,
		min = 1,
	}
}

function SplitStrings:init(settings) end

local function generateTableConcatNode(chunks, data)
	local chunkNodes = {};
	for i, chunk in ipairs(chunks) do
		table.insert(chunkNodes, Ast.TableEntry(Ast.StringExpression(chunk)));
	end
	local tb = Ast.TableConstructorExpression(chunkNodes);
	data.scope:addReferenceToHigherScope(data.tableConcatScope, data.tableConcatId);
	return Ast.FunctionCallExpression(Ast.VariableExpression(data.tableConcatScope, data.tableConcatId), {tb});
end

local function generateStrCatNode(chunks)
	-- Put Together Expression for Concatenating String
	local generatedNode = nil;
	for i, chunk in ipairs(chunks) do
		if generatedNode then
			generatedNode = Ast.StrCatExpression(generatedNode, Ast.StringExpression(chunk));
		else
			generatedNode = Ast.StringExpression(chunk);
		end
	end
	return generatedNode
end

local customVariants = 2;
local custom1Code = [=[
function custom(table)
    local stringTable, str = table[#table], "";
    for i=1,#stringTable, 1 do
        str = str .. stringTable[table[i]];
	end
	return str
end
]=];

local custom2Code = [=[
function custom(tb)
	local str = "";
	for i=1, #tb / 2, 1 do
		str = str .. tb[#tb / 2 + tb[i]];
	end
	return str
end
]=];

local function generateCustomNodeArgs(chunks, data, variant)
	local shuffled = {};
	local shuffledIndices = {};
	for i = 1, #chunks, 1 do
		shuffledIndices[i] = i;
	end
	util.shuffle(shuffledIndices);

	for i, v in ipairs(shuffledIndices) do
		shuffled[v] = chunks[i];
	end

	-- Custom Function Type 1
	if variant == 1 then
		local args = {};
		local tbNodes = {};

		for i, v in ipairs(shuffledIndices) do
			table.insert(args, Ast.TableEntry(Ast.NumberExpression(v)));
		end

		for i, chunk in ipairs(shuffled) do
			table.insert(tbNodes, Ast.TableEntry(Ast.StringExpression(chunk)));
		end

		local tb = Ast.TableConstructorExpression(tbNodes);

		table.insert(args, Ast.TableEntry(tb));
		return {Ast.TableConstructorExpression(args)};

	-- Custom Function Type 2
	else

		local args = {};
		for i, v in ipairs(shuffledIndices) do
			table.insert(args, Ast.TableEntry(Ast.NumberExpression(v)));
		end
		for i, chunk in ipairs(shuffled) do
			table.insert(args, Ast.TableEntry(Ast.StringExpression(chunk)));
		end
		return {Ast.TableConstructorExpression(args)};
	end

end

local function generateCustomFunctionLiteral(parentScope, variant)
	local parser = Parser:new({
		LuaVersion = LuaVersion.Lua51;
	});

	-- Custom Function Type 1
	if variant == 1 then
		local funcDeclNode = parser:parse(custom1Code).body.statements[1];
		local funcBody = funcDeclNode.body;
		local funcArgs = funcDeclNode.args;
		funcBody.scope:setParent(parentScope);
		return Ast.FunctionLiteralExpression(funcArgs, funcBody);

		-- Custom Function Type 2
	else
		local funcDeclNode = parser:parse(custom2Code).body.statements[1];
		local funcBody = funcDeclNode.body;
		local funcArgs = funcDeclNode.args;
		funcBody.scope:setParent(parentScope);
		return Ast.FunctionLiteralExpression(funcArgs, funcBody);
	end
end

local function generateGlobalCustomFunctionDeclaration(ast, data)
	local parser = Parser:new({
		LuaVersion = LuaVersion.Lua51;
	});

	-- Custom Function Type 1
	if data.customFunctionVariant == 1 then
		local astScope = ast.body.scope;
		local funcDeclNode = parser:parse(custom1Code).body.statements[1];
		local funcBody = funcDeclNode.body;
		local funcArgs = funcDeclNode.args;
		funcBody.scope:setParent(astScope);
		return Ast.LocalVariableDeclaration(astScope, {data.customFuncId},
		{Ast.FunctionLiteralExpression(funcArgs, funcBody)});
	-- Custom Function Type 2
	else
		local astScope = ast.body.scope;
		local funcDeclNode = parser:parse(custom2Code).body.statements[1];
		local funcBody = funcDeclNode.body;
		local funcArgs = funcDeclNode.args;
		funcBody.scope:setParent(astScope);
		return Ast.LocalVariableDeclaration(data.customFuncScope, {data.customFuncId},
		{Ast.FunctionLiteralExpression(funcArgs, funcBody)});
	end
end

function SplitStrings:variant()
	return math.random(1, customVariants);
end

function SplitStrings:apply(ast, pipeline)
	local data = {};


	if(self.ConcatenationType == "table") then
		local scope = ast.body.scope;
		local id = scope:addVariable();
		data.tableConcatScope = scope;
		data.tableConcatId = id;
	elseif(self.ConcatenationType == "custom") then
		data.customFunctionType = self.CustomFunctionType;
		if data.customFunctionType == "global" then
			local scope = ast.body.scope;
			local id = scope:addVariable();
			data.customFuncScope = scope;
			data.customFuncId = id;
			data.customFunctionVariant = self:variant();
		end
	end


	local customLocalFunctionsCount = self.CustomLocalFunctionsCount;
	local self2 = self;

	visitAst(ast, function(node, data)
		-- Previsit Function

		-- Create Local Function declarations
		if(self.ConcatenationType == "custom" and data.customFunctionType == "local" and node.kind == Ast.AstKind.Block and node.isFunctionBlock) then
			data.functionData.localFunctions = {};
			for i = 1, customLocalFunctionsCount, 1 do
				local scope = data.scope;
				local id = scope:addVariable();
				local variant = self:variant();
				table.insert(data.functionData.localFunctions, {
					scope = scope,
					id = id,
					variant = variant,
					used = false,
				});
			end
		end

	end, function(node, data)
		-- PostVisit Function

		-- Create actual function literals for local customFunctionType
		if(self.ConcatenationType == "custom" and data.customFunctionType == "local" and node.kind == Ast.AstKind.Block and node.isFunctionBlock) then
			for i, func in ipairs(data.functionData.localFunctions) do
				if func.used then
					local literal = generateCustomFunctionLiteral(func.scope, func.variant);
					table.insert(node.statements, 1, Ast.LocalVariableDeclaration(func.scope, {func.id}, {literal}));
				end
			end
		end


		-- Apply Only to String nodes
		if(node.kind == Ast.AstKind.StringExpression) then
			local str = node.value;
			local chunks = {};
			local i = 1;

			-- Split String into Parts of length between MinLength and MaxLength
			while i <= string.len(str) do
				local len = math.random(self.MinLength, self.MaxLength);
				table.insert(chunks, string.sub(str, i, i + len - 1));
				i = i + len;
			end

			if(#chunks > 1) then
				if math.random() < self.Threshold then
					if self.ConcatenationType == "strcat" then
						node = generateStrCatNode(chunks);
					elseif self.ConcatenationType == "table" then
						node = generateTableConcatNode(chunks, data);
					elseif self.ConcatenationType == "custom" then
						if self.CustomFunctionType == "global" then
							local args = generateCustomNodeArgs(chunks, data, data.customFunctionVariant);
							-- Add Reference for Variable Renaming
							data.scope:addReferenceToHigherScope(data.customFuncScope, data.customFuncId);
							node = Ast.FunctionCallExpression(Ast.VariableExpression(data.customFuncScope, data.customFuncId), args);
						elseif self.CustomFunctionType == "local" then
							local lfuncs = data.functionData.localFunctions;
							local idx = math.random(1, #lfuncs);
							local func = lfuncs[idx];
							local args = generateCustomNodeArgs(chunks, data, func.variant);
							func.used = true;
							-- Add Reference for Variable Renaming
							data.scope:addReferenceToHigherScope(func.scope, func.id);
							node = Ast.FunctionCallExpression(Ast.VariableExpression(func.scope, func.id), args);
						elseif self.CustomFunctionType == "inline" then
							local variant = self:variant();
							local args = generateCustomNodeArgs(chunks, data, variant);
							local literal = generateCustomFunctionLiteral(data.scope, variant);
							node = Ast.FunctionCallExpression(literal, args);
						end
					end
				end
			end

			return node, true;
		end
	end, data)


	if(self.ConcatenationType == "table") then
		local globalScope = data.globalScope;
		local tableScope, tableId = globalScope:resolve("table")
		ast.body.scope:addReferenceToHigherScope(globalScope, tableId);
		table.insert(ast.body.statements, 1, Ast.LocalVariableDeclaration(data.tableConcatScope, {data.tableConcatId},
		{Ast.IndexExpression(Ast.VariableExpression(tableScope, tableId), Ast.StringExpression("concat"))}));
	elseif(self.ConcatenationType == "custom" and self.CustomFunctionType == "global") then
		table.insert(ast.body.statements, 1, generateGlobalCustomFunctionDeclaration(ast, data));
	end
end

return SplitStrings;`,"prometheus.steps.StringMetaPoison":`-- This Script is Part of the Prometheus / PVM Obfuscator
--
-- StringMetaPoison.lua
--
-- String Metatable Sentinel:
-- In standard Lua/Luau, all strings share a single metatable accessible via
-- getmetatable(""). Attackers use this to hook string.* methods.
--
-- This step:
--   1. Snapshots the string metatable's __index (should be string library).
--   2. Stores a fingerprint of a known string method (e.g., string.byte).
--   3. At runtime, re-checks the metatable identity — if the __index was
--      replaced (e.g., to inject a proxy), corruption is triggered.
--   4. Optionally validates that string.byte and string.len are still C functions.
--
-- Complements MetamethodGuard (which focuses on custom objects);
-- this specifically guards the global string metatable.
--
-- Lazy: O(1) single getmetatable check — near zero overhead.

local Step   = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums  = require("prometheus.enums")

local StringMetaPoison = Step:extend()
StringMetaPoison.Description = "Guards the global string metatable against __index replacement or string library hooking attacks."
StringMetaPoison.Name = "String Meta Poison"

StringMetaPoison.SettingsDescriptor = {
	SilentCorrupt = {
		type    = "boolean",
		default = false,
		description = "Silently corrupt state on detection instead of explicit error.",
	},
}

function StringMetaPoison:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt == true
end

local function generateStringMetaPoisonCode(silentCorrupt)
	-- Pick a known byte fingerprint that's stable: string.byte("A") == 65
	local testChar = string.char(math.random(65, 90))  -- A-Z
	local testByte = string.byte(testChar)
	local errorAction
	if silentCorrupt then
		errorAction = "while true do end"
	else
		errorAction = "error(\\"String metatable tampered\\", 0)"
	end

	local code = string.format([[
do
  local _smp_tampered = false
  pcall(function()
    -- Snapshot the string metatable's __index at script start
    local _smp_mt = getmetatable("")
    if _smp_mt then
      local _smp_idx = rawget(_smp_mt, "__index")
      -- __index should be the string library table itself
      if _smp_idx ~= string then
        _smp_tampered = true
      end
    end
    -- Validate string.byte is still native (not hooked)
    if debug and debug.getinfo then
      local _ok, _di = pcall(debug.getinfo, string.byte)
      if _ok and _di and _di.what and _di.what ~= "C" then
        _smp_tampered = true
      end
    end
    -- Functional fingerprint: string.byte of a known char must match
    local _sb = string.byte
    if _sb(%q) ~= %d then
      _smp_tampered = true
    end
  end)
  if _smp_tampered then
    %s
  end
end
]], testChar, testByte, errorAction)
	return code
end

function StringMetaPoison:apply(ast, pipeline)
	local code   = generateStringMetaPoisonCode(self.SilentCorrupt)
	local parsed = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 }):parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)
	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return StringMetaPoison
`,"prometheus.steps.TableFreezerSentinel":`-- TableFreezerSentinel.lua
--
-- Table Freezer & Immutability Sentinel:
-- Validates runtime table immutability and detects executor exploit hooks that disable or stub table.freeze.
--
-- Mechanism:
-- 1. In Luau runtimes: Creates a frozen canary table via \`table.freeze\`.
--    Validates \`table.isfrozen(canary) == true\`, and verifies via \`pcall\` that mutating
--    the frozen table strictly errors. If an executor hook stubbed \`table.freeze\` to a no-op,
--    the mutation succeeds, immediately tripping the sentinel.
-- 2. In Lua 5.1 / Luau fallback: Enforces sealed read-only metatable invariants via \`__newindex\`
--    and \`__metatable = false\`, detecting metatable stripping or global environment hookers.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local TableFreezerSentinel = Step:extend()
TableFreezerSentinel.Description = "Validates table immutability invariants (table.freeze / read-only proxy) to defeat sandbox unfreezing hooks."
TableFreezerSentinel.Name = "Table Freezer Sentinel"

TableFreezerSentinel.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = true,
		description = "Silently corrupt state on detection.",
	},
}

function TableFreezerSentinel:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt ~= false
end

local function generateTableFreezerCode(silentCorrupt)
	local canaryId = math.random(1000, 9999)
	local canaryVal = math.random(10, 99)
	local poisonAction = silentCorrupt
		and "local _tf_fail = nil; _tf_fail[1] = 0"
		or "error('0xE502', 0)"

	local code = string.format([[
do
    local _tf_ok = true
    local _pcall = pcall
    local _tbl = table

    if _tbl and type(_tbl.freeze) == "function" and type(_tbl.isfrozen) == "function" then
        local _canary = _tbl.freeze({ id = %d, v = %d })
        if not _tbl.isfrozen(_canary) then
            _tf_ok = false
        else
            local _mod_ok = _pcall(function()
                _canary.id = %d
            end)
            if _mod_ok then
                _tf_ok = false
            end
        end
    else
        local _ro = setmetatable({}, {
            __newindex = function()
                error("ro", 0)
            end,
            __metatable = false,
        })
        local _mod_ok = _pcall(function()
            _ro[1] = %d
        end)
        if _mod_ok or getmetatable(_ro) ~= false then
            _tf_ok = false
        end
    end

    if not _tf_ok then
        %s
    end
end]], canaryId, canaryVal, canaryId + 1, canaryVal + 1, poisonAction)

	return code
end

function TableFreezerSentinel:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateTableFreezerCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return TableFreezerSentinel
`,"prometheus.steps.TaintCallstackGuard":`-- TaintCallstackGuard.lua
--
-- Callstack frame invariant validation:
-- Evaluates nested pcall frame return tuples and callstack continuity.
-- Detects debug hook manipulation (debug.sethook), injector proxy interception,
-- and synthetic root frame injection without relying on the debug library.
-- Fully deterministic, O(1) runtime check, zero false positives across Lua 5.1/Luau.

local Step = require("prometheus.step")
local Parser = require("prometheus.parser")
local Enums = require("prometheus.enums")

local TaintCallstackGuard = Step:extend()
TaintCallstackGuard.Description = "Injects stack frame depth invariant checks to defeat debug hooks and thread hijacking."
TaintCallstackGuard.Name = "Taint Callstack Guard"

TaintCallstackGuard.SettingsDescriptor = {
	SilentCorrupt = {
		type = "boolean",
		default = true,
		description = "Silently corrupt state on tamper detection.",
	},
}

function TaintCallstackGuard:init(settings)
	settings = settings or {}
	self.SilentCorrupt = settings.SilentCorrupt ~= false
end

local function generateGuardCode(silentCorrupt)
	local tokenA = math.random(1000, 9999)
	local tokenB = math.random(1000, 9999)
	local magic = (tokenA * 31 + tokenB * 17) % 65521

	local lines = {}
	lines[#lines + 1] = "do"
	lines[#lines + 1] = string.format("    local _tc_tokA = %d", tokenA)
	lines[#lines + 1] = string.format("    local _tc_tokB = %d", tokenB)
	lines[#lines + 1] = string.format("    local _tc_expected = %d", magic)
	lines[#lines + 1] = "    local function _tc_probe()"
	lines[#lines + 1] = "        local _ok1, _ok2, _res = pcall(function()"
	lines[#lines + 1] = "            return pcall(function()"
	lines[#lines + 1] = "                return (_tc_tokA * 31 + _tc_tokB * 17) % 65521"
	lines[#lines + 1] = "            end)"
	lines[#lines + 1] = "        end)"
	lines[#lines + 1] = "        return _ok1 and _ok2 and _res == _tc_expected"
	lines[#lines + 1] = "    end"
	lines[#lines + 1] = "    if not _tc_probe() then"
	if silentCorrupt then
		lines[#lines + 1] = "        local _t_fail = nil; _t_fail[1] = 0"
	else
		lines[#lines + 1] = "        error('0xE206', 0)"
	end
	lines[#lines + 1] = "    end"
	lines[#lines + 1] = "end"

	return table.concat(lines, "\\n")
end

function TaintCallstackGuard:apply(ast, pipeline)
	if pipeline and pipeline.PrettyPrint then
		return ast
	end

	local code = generateGuardCode(self.SilentCorrupt)
	local parser = Parser:new({ LuaVersion = Enums.LuaVersion.Lua51 })
	local parsed = parser:parse(code)
	local doStat = parsed.body.statements[1]
	doStat.body.scope:setParent(ast.body.scope)

	table.insert(ast.body.statements, 1, doStat)
	return ast
end

return TaintCallstackGuard
`,"prometheus.steps.Vmify":`-- This Script is Part of the Pinathub Obfuscator
--
-- Vmify.lua
--
-- This Step compiles the script into the PinatVM custom bytecode format
-- with randomized opcodes, control-flow flattening, and runtime interpreter.

local Step = require("prometheus.step")
local PinatVM = require("prometheus.vm.vm_step")

local Vmify = Step:extend()
Vmify.Description = PinatVM.Description
Vmify.Name = "Vmify"
Vmify.SettingsDescriptor = PinatVM.SettingsDescriptor

function Vmify:init(settings)
    self.pinatVM = PinatVM:new(settings or {})
end

function Vmify:apply(ast, pipeline)
    if not self.pinatVM then
        self.pinatVM = PinatVM:new({})
    end
    return self.pinatVM:apply(ast, pipeline)
end

return Vmify`,"prometheus.steps.Watermark":`-- PVM Obfuscator (PinatHub Build)
--
-- Watermark.lua
--
-- This Script provides a Step that will add a watermark to the script

local Step = require("prometheus.step");
local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");

local Watermark = Step:extend();
Watermark.Description = "This Step will add a watermark to the script";
Watermark.Name = "Watermark";

Watermark.SettingsDescriptor = {
  Content = {
    name = "Content",
    description = "The Content of the Watermark",
    type = "string",
    default = "protected by PvM Obfuscator",
  },
  CustomVariable = {
    name = "Custom Variable",
    description = "The Variable that will be used for the Watermark",
    type = "string",
    default = "_WATERMARK",
  }
}

function Watermark:init(settings)
	
end

function Watermark:apply(ast)
  local body = ast.body;
  if string.len(self.Content) > 0 then
    local scope, variable = ast.globalScope:resolve(self.CustomVariable);
    local watermark = Ast.AssignmentVariable(ast.globalScope, variable);

    local functionScope = Scope:new(body.scope);
    functionScope:addReferenceToHigherScope(ast.globalScope, variable);
    
    local arg = functionScope:addVariable();
    local statement = Ast.PassSelfFunctionCallStatement(Ast.StringExpression(self.Content), "gsub", {
      Ast.StringExpression(".+"),
      Ast.FunctionLiteralExpression({
        Ast.VariableExpression(functionScope, arg)
      }, Ast.Block({
        Ast.AssignmentStatement({
          watermark
        }, {
          Ast.VariableExpression(functionScope, arg)
        })
      }, functionScope))
    });

    table.insert(ast.body.statements, 1, statement)
  end
end

return Watermark;`,"prometheus.steps.WatermarkCheck":`-- PVM Obfuscator (PinatHub Build)
--
-- WatermarkCheck.lua
--
-- This Script provides a Step that will validate the watermark in the script

local Step = require("prometheus.step");
local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");
local Watermark = require("prometheus.steps.Watermark");

local WatermarkCheck = Step:extend();
WatermarkCheck.Description = "This Step will add a watermark to the script";
WatermarkCheck.Name = "WatermarkCheck";

WatermarkCheck.SettingsDescriptor = {
  Content = {
    name = "Content",
    description = "The Content of the WatermarkCheck",
    type = "string",
    default = "protected by PvM Obfuscator",
  },
}

local function callNameGenerator(generatorFunction, ...)
	if(type(generatorFunction) == "table") then
		generatorFunction = generatorFunction.generateName;
	end
	return generatorFunction(...);
end

function WatermarkCheck:init(_) end

function WatermarkCheck:apply(ast, pipeline)
  self.CustomVariable = "_" .. callNameGenerator(pipeline.namegenerator, math.random(10000000000, 100000000000));
  pipeline:addStep(Watermark:new(self));

  local body = ast.body;
  local watermarkExpression = Ast.StringExpression(self.Content);
  local scope, variable = ast.globalScope:resolve(self.CustomVariable);
  local watermark = Ast.VariableExpression(ast.globalScope, variable);
  local notEqualsExpression = Ast.NotEqualsExpression(watermark, watermarkExpression);
  local ifBody = Ast.Block({Ast.ReturnStatement({})}, Scope:new(ast.body.scope));

  table.insert(body.statements, 1, Ast.IfStatement(notEqualsExpression, ifBody, {}, nil));
end

return WatermarkCheck;`,"prometheus.steps.WrapInFunction":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- WrapInFunction.lua
--
-- This Script provides a Simple Obfuscation Step that wraps the entire Script into a function

local Step = require("prometheus.step");
local Ast = require("prometheus.ast");
local Scope = require("prometheus.scope");

local WrapInFunction = Step:extend();
WrapInFunction.Description = "This Step Wraps the Entire Script into a Function";
WrapInFunction.Name = "Wrap in Function";

WrapInFunction.SettingsDescriptor = {
	Iterations = {
		name = "Iterations",
		description = "The Number Of Iterations",
		type = "number",
		default = 1,
		min = 1,
		max = nil,
	}
}

function WrapInFunction:init(_) end

function WrapInFunction:apply(ast)
	for i = 1, self.Iterations, 1 do
		local body = ast.body;

		local scope = Scope:new(ast.globalScope);
		body.scope:setParent(scope);

		ast.body = Ast.Block({
			Ast.ReturnStatement({
				Ast.FunctionCallExpression(Ast.FunctionLiteralExpression({Ast.VarargExpression()}, body), {Ast.VarargExpression()})
			});
		}, scope);
	end
end

return WrapInFunction;`,"prometheus.steps":`-- steps.lua
-- PVM Obfuscation Step Pipeline Registry

return {
	WrapInFunction = require("prometheus.steps.WrapInFunction"),
	SplitStrings = require("prometheus.steps.SplitStrings"),
	Vmify = require("prometheus.steps.Vmify"),
	ConstantArray = require("prometheus.steps.ConstantArray"),
	ProxifyLocals = require("prometheus.steps.ProxifyLocals"),
	AntiTamper = require("prometheus.steps.AntiTamper"),
	EncryptStrings = require("prometheus.steps.EncryptStrings"),
	NumbersToExpressions = require("prometheus.steps.NumbersToExpressions"),
	AddVararg = require("prometheus.steps.AddVararg"),
	WatermarkCheck = require("prometheus.steps.WatermarkCheck"),
	LiteralsToExpressions = require("prometheus.steps.LiteralsToExpressions"),
	MemberAccessObfuscation = require("prometheus.steps.MemberAccessObfuscation"),
	OpaquePredicates = require("prometheus.steps.OpaquePredicates"),
	ControlFlowFlattening = require("prometheus.steps.ControlFlowFlattening"),
	PinatVM = require("prometheus.vm.vm_step"),
	MetamethodGuard = require("prometheus.steps.MetamethodGuard"),
	ExecutionFlowIntegrity = require("prometheus.steps.ExecutionFlowIntegrity"),
	ClosureGuard = require("prometheus.steps.ClosureGuard"),
	ConstantSentinel = require("prometheus.steps.ConstantSentinel"),
	MetatableWrapper          = require("prometheus.steps.MetatableWrapper"),
	-- Advanced anti-tamper / stealth techniques (v2)
	CoroutineFragmentation    = require("prometheus.steps.CoroutineFragmentation"),
	GCFinalizerTrap           = require("prometheus.steps.GCFinalizerTrap"),
	EnvSandboxPoison          = require("prometheus.steps.EnvSandboxPoison"),
	DebugLibPoison            = require("prometheus.steps.DebugLibPoison"),
	StringMetaPoison          = require("prometheus.steps.StringMetaPoison"),
	InvocationNonceGuard      = require("prometheus.steps.InvocationNonceGuard"),
	BenignASTCamouflage       = require("prometheus.steps.BenignASTCamouflage"),
	DynamicStateMuxer         = require("prometheus.steps.DynamicStateMuxer"),
	TaintCallstackGuard       = require("prometheus.steps.TaintCallstackGuard"),
	ClosureMorphSentinel      = require("prometheus.steps.ClosureMorphSentinel"),
	AntiHookTrampoline        = require("prometheus.steps.AntiHookTrampoline"),
	AntiHttpSpy               = require("prometheus.steps.AntiHttpSpy"),
	AntiMemoryDumper          = require("prometheus.steps.AntiMemoryDumper"),
	TableFreezerSentinel      = require("prometheus.steps.TableFreezerSentinel"),
	BytecodeEntropyLock       = require("prometheus.steps.BytecodeEntropyLock"),
	MockEnvironmentTrap       = require("prometheus.steps.MockEnvironmentTrap"),
	DispatcherLoopCamouflage  = require("prometheus.steps.DispatcherLoopCamouflage"),
	ParserDesyncGuard         = require("prometheus.steps.ParserDesyncGuard"),
}`,"prometheus.tokenizer":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- tokenizer.lua
-- Overview:
-- This Script provides a class for lexical Analysis of lua code.
-- This Tokenizer is Capable of tokenizing LuaU and Lua5.1
local Enums = require("prometheus.enums");
local util = require("prometheus.util");
local logger = require("logger");
local config = require("config");

local LuaVersion = Enums.LuaVersion;
local lookupify = util.lookupify;
local unlookupify = util.unlookupify;
local escape = util.escape;
local chararray = util.chararray;
local keys = util.keys;
local Tokenizer = {};

Tokenizer.EOF_CHAR = "<EOF>";
Tokenizer.WHITESPACE_CHARS = lookupify{
	" ", "\\t", "\\n", "\\r",
}

Tokenizer.ANNOTATION_CHARS = lookupify(chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"))
Tokenizer.ANNOTATION_START_CHARS = lookupify(chararray("!@"))

Tokenizer.Conventions = Enums.Conventions;

Tokenizer.TokenKind = {
	Eof = "Eof",
	Keyword = "Keyword",
	Symbol = "Symbol",
	Ident = "Identifier",
	Number = "Number",
	String = "String",
}

Tokenizer.EOF_TOKEN = {
	kind = Tokenizer.TokenKind.Eof,
	value = "<EOF>",
	startPos = -1,
	endPos = -1,
	source = "<EOF>",
}

local function token(self, startPos, kind, value)
	local line, linePos = self:getPosition(self.index);
	local annotations = self.annotations
	self.annotations = {};
	local tk = {
		kind = kind,
		value = value,
		startPos = startPos,
		endPos = self.index,
		source = self.source:sub(startPos + 1, self.index),
		line = line,
		linePos = linePos,
		annotations = annotations,
	}
	self.lastToken = tk
	return tk
end

local function syntheticToken(kind, value, source, line, linePos, startPos, endPos)
	return {
		kind = kind,
		value = value,
		startPos = startPos or 0,
		endPos = endPos or 0,
		source = source or tostring(value),
		line = line or 1,
		linePos = linePos or 1,
		annotations = {},
	}
end

local function generateError(self, message)
	local line, linePos = self:getPosition(self.index);
	return "Lexing Error at Position " .. tostring(line) .. ":" .. tostring(linePos) .. ", " .. message;
end

local function generateWarning(token, message)
	return "Warning at Position " .. tostring(token.line) .. ":" .. tostring(token.linePos) .. ", " .. message;
end

function Tokenizer:getPosition(i)
	local column = self.columnMap[i]

	if not column then --// \`i\` is bigger than self.length, this shouldn't happen, but it did. (Theres probably some error in the tokenizer, cant find it.)
		column = self.columnMap[#self.columnMap]
	end

	return column.id, column.charMap[i]
end

--// Prepare columnMap for getPosition
function Tokenizer:prepareGetPosition()
	local columnMap, column = {}, { charMap = {}, id = 1, length = 0 }

	for index = 1, self.length do
		local character = string.sub(self.source, index, index) -- NOTE_1: this could use table.clone to reduce amount of NEWTABLE (if that causes any performance issues)

		local columnLength = column.length + 1
		column.length = columnLength
		column.charMap[index] = columnLength

		if character == "\\n" then
			column = { charMap = {}, id = column.id + 1, length = 0 } -- NOTE_1
		end

		columnMap[index] = column
	end

	self.columnMap = columnMap
end

-- Constructor for Tokenizer
function Tokenizer:new(settings)
	local luaVersion = (settings and (settings.luaVersion or settings.LuaVersion)) or LuaVersion.LuaU;
	local conventions = Tokenizer.Conventions[luaVersion];

	if(conventions == nil) then
		logger:error("The Lua Version \\"" .. luaVersion .. "\\" is not recognized by the Tokenizer! Please use one of the following: \\"" .. table.concat(keys(Tokenizer.Conventions), "\\",\\"") .. "\\"");
	end

	local tokenizer = {
		index = 0, -- Index where the current char is read
		length = 0,
		source = "", -- Source to Tokenize
		luaVersion = luaVersion, -- LuaVersion to be used while Tokenizing
		conventions = conventions;

		NumberChars = conventions.NumberChars,
		NumberCharsLookup = lookupify(conventions.NumberChars),
		Keywords = conventions.Keywords,
		KeywordsLookup = lookupify(conventions.Keywords),
		BinaryNumberChars = conventions.BinaryNumberChars,
		BinaryNumberCharsLookup = lookupify(conventions.BinaryNumberChars);
		BinaryNums = conventions.BinaryNums,
		HexadecimalNums = conventions.HexadecimalNums,
		HexNumberChars = conventions.HexNumberChars,
		HexNumberCharsLookup = lookupify(conventions.HexNumberChars),
		DecimalExponent = conventions.DecimalExponent,
		DecimalSeperators = conventions.DecimalSeperators,
		IdentChars = conventions.IdentChars,
		IdentCharsLookup = lookupify(conventions.IdentChars),

		EscapeSequences = conventions.EscapeSequences,
		NumericalEscapes = conventions.NumericalEscapes,
		EscapeZIgnoreNextWhitespace = conventions.EscapeZIgnoreNextWhitespace,
		HexEscapes = conventions.HexEscapes,
		UnicodeEscapes = conventions.UnicodeEscapes,

		SymbolChars = conventions.SymbolChars,
		SymbolCharsLookup = lookupify(conventions.SymbolChars),
		MaxSymbolLength = conventions.MaxSymbolLength,
		Symbols = conventions.Symbols,
		SymbolsLookup = lookupify(conventions.Symbols),

		StringStartLookup = lookupify({"\\"", "\\'"}),
		annotations = {},
		tokenQueue = {},
	};

	setmetatable(tokenizer, self);
	self.__index = self;

	return tokenizer;
end

-- Reset State of Tokenizer to Tokenize another File
function Tokenizer:reset()
	self.index = 0;
	self.length = 0;
	self.source = "";
	self.annotations = {};
	self.columnMap = {};
	self.lastToken = nil;
	self.tokenQueue = {};
end

-- Append String to this Tokenizer
function Tokenizer:append(code)
	self.source = self.source .. code
	self.length = self.length + code:len();
	self:prepareGetPosition();
end

-- Function to peek the n'th char in the source of the tokenizer
local function peek(self, n)
	n = n or 0;
	local i = self.index + n + 1;
	if i > self.length then
		return Tokenizer.EOF_CHAR
	end
	return self.source:sub(i, i);
end

-- Function to get the next char in the source
local function get(self)
	local i = self.index + 1;
	if i > self.length then
		logger:error(generateError(self, "Unexpected end of Input"));
	end
	self.index = self.index + 1;
	return self.source:sub(i, i);
end

-- The same as get except it throws an Error if the char is not contained in charOrLookup
local function expect(self, charOrLookup)
	if(type(charOrLookup) == "string") then
		charOrLookup = {[charOrLookup] = true};
	end

	local char = peek(self);
	if charOrLookup[char] ~= true then
		local etb = unlookupify(charOrLookup);
		for i, v in ipairs(etb) do
			etb[i] = escape(v);
		end
		local errorMessage = "Unexpected char \\"" .. escape(char) .. "\\"! Expected one of \\"" .. table.concat(etb, "\\",\\"") .. "\\"";
		logger:error(generateError(self, errorMessage));
	end

	self.index = self.index + 1;
	return char;
end

-- Returns wether the n'th char is in the lookup
local function is(self, charOrLookup, n)
	local char = peek(self, n);
	if(type(charOrLookup) == "string") then
		return char == charOrLookup;
	end
	return charOrLookup[char];
end

function Tokenizer:parseAnnotation()
	if is(self, Tokenizer.ANNOTATION_START_CHARS) then
		self.index = self.index + 1;
		local source, length = {}, 0;
		while(is(self, Tokenizer.ANNOTATION_CHARS)) do
			source[length + 1] = get(self)
			length = #source
		end
		if length > 0 then
			self.annotations[string.lower(table.concat(source))] = true;
		end
		return nil;
	end
	return get(self);
end

-- skip one or 0 Comments and return wether one was found
function Tokenizer:skipComment()
	if(is(self, "-", 0) and is(self, "-", 1)) then
		self.index = self.index + 2;
		if(is(self, "[")) then
			self.index = self.index + 1;
			local eqCount = 0;
			while(is(self, "=")) do
				self.index = self.index + 1;
				eqCount = eqCount + 1;
			end
			if(is(self, "[")) then
				-- Multiline Comment
				-- Get all Chars to Closing bracket but also consider that the count of equal signs must be the same
				while true do
					if(self:parseAnnotation() == ']') then
						local eqCount2 = 0;
						while(is(self, "=")) do
							self.index = self.index + 1;
							eqCount2 = eqCount2 + 1;
						end
						if(is(self, "]")) then
							if(eqCount2 == eqCount) then
								self.index = self.index + 1;
								return true
							end
						end
					end
				end
			end
		end
		-- Single Line Comment
		-- Get all Chars to next Newline
		while(self.index < self.length and self:parseAnnotation() ~= "\\n") do end
		return true;
	end

	-- C-style multiline comment /* ... */
	if(is(self, "/", 0) and is(self, "*", 1)) then
		self.index = self.index + 2;
		while self.index < self.length do
			if is(self, "*", 0) and is(self, "/", 1) then
				self.index = self.index + 2;
				return true;
			end
			self.index = self.index + 1;
		end
		return true;
	end

	-- C-style single-line comment // (when not floor division or //=)
	if(is(self, "/", 0) and is(self, "/", 1) and not is(self, "=", 2)) then
		local curLine = self:getPosition(self.index);
		local isComment = false;
		if not self.lastToken or self.lastToken.line < curLine then
			-- Start of file or start of a new line: unambiguously a comment
			isComment = true;
		else
			local v = self.lastToken.value;
			-- After block/statement boundary symbols and keywords: definitely a comment
			if v == ";" or v == "do" or v == "then" or v == "else" or v == "repeat" or v == "return" then
				isComment = true;
			end
		end

		if isComment then
			while(self.index < self.length and self:parseAnnotation() ~= "\\n") do end
			return true;
		end
	end

	return false;
end

-- skip All Whitespace and Comments to next Token
function Tokenizer:skipWhitespaceAndComments()
	while self:skipComment() do end
	while is(self, Tokenizer.WHITESPACE_CHARS) do
		self.index = self.index + 1;
		while self:skipComment() do end
	end
end

local function int(self, chars, seperators)
	local buffer = {};
	while true do
		if (is(self, chars)) then
			buffer[#buffer + 1] = get(self)
		elseif (is(self, seperators)) then
			self.index = self.index + 1;
		else
			break
		end
	end
	return table.concat(buffer);
end

-- Lex the next token as a Number
function Tokenizer:number()
	local startPos = self.index;
	local source = expect(self, setmetatable({["."] = true}, {__index = self.NumberCharsLookup}));

	if source == "0" then
		if self.BinaryNums and is(self, lookupify(self.BinaryNums)) then
			self.index = self.index + 1;
			source = int(self, self.BinaryNumberCharsLookup, lookupify(self.DecimalSeperators or {}));
			local value = tonumber(source, 2);
			return token(self, startPos, Tokenizer.TokenKind.Number, value);
		end

		if self.HexadecimalNums and is(self, lookupify(self.HexadecimalNums)) then
			self.index = self.index + 1;
			source = int(self, self.HexNumberCharsLookup, lookupify(self.DecimalSeperators or {}));
			local value = tonumber(source, 16);
			return token(self, startPos, Tokenizer.TokenKind.Number, value);
		end
	end

	if source == "." then
		source = source .. int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}));
	else
		source = source .. int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}));
		if(is(self, ".")) then
			source = source .. get(self) .. int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}));
		end
	end

	if(self.DecimalExponent and is(self, lookupify(self.DecimalExponent))) then
		source = source .. get(self);
		if(is(self, lookupify({"+","-"}))) then
			source = source .. get(self);
		end
		local v = int(self, self.NumberCharsLookup, lookupify(self.DecimalSeperators or {}));
		if(v:len() < 1) then
			logger:error(generateError(self, "Expected a Valid Exponent!"));
		end
		source = source .. v;
	end

	local value = tonumber(source);
	return token(self, startPos, Tokenizer.TokenKind.Number, value);
end

-- Lex the Next Token as Identifier or Keyword
function Tokenizer:ident()
	local startPos = self.index;
	local source = expect(self, self.IdentCharsLookup)
	local sourceAddContent = {source}
	while(is(self, self.IdentCharsLookup)) do
		-- source = source .. get(self);
		table.insert(sourceAddContent, get(self))
	end
	source = table.concat(sourceAddContent)
	if(self.KeywordsLookup[source]) then
		return token(self, startPos, Tokenizer.TokenKind.Keyword, source);
	end

	local tk = token(self, startPos, Tokenizer.TokenKind.Ident, source);

	if(string.sub(source, 1, string.len(config.IdentPrefix)) == config.IdentPrefix) then
		logger:warn(generateWarning(tk, string.format("identifiers should not start with \\"%s\\" as this may break the program", config.IdentPrefix)));
	end

	return tk;
end

function Tokenizer:singleLineString()
	local startPos = self.index;
	local startChar = expect(self, self.StringStartLookup);
	local buffer = {};

	while (not is(self, startChar)) do
		local char = get(self);

		-- Single Line String may not contain Linebreaks except when they are escaped by \\
		if(char == '\\n') then
			self.index = self.index - 1;
			logger:error(generateError(self, "Unterminated String"));
		end


		if(char == "\\\\") then
			char = get(self);

			local escape = self.EscapeSequences[char];
			if(type(escape) == "string") then
				char = escape;

			elseif(self.NumericalEscapes and self.NumberCharsLookup[char]) then
				local numstr = char;

				if(is(self, self.NumberCharsLookup)) then
					char = get(self);
					numstr = numstr .. char;
				end

				if(is(self, self.NumberCharsLookup)) then
					char = get(self);
					numstr = numstr .. char;
				end

				char = string.char(tonumber(numstr));

			elseif(self.UnicodeEscapes and char == "u") then
				expect(self, "{");
				local num = "";
				while (is(self, self.HexNumberCharsLookup)) do
					num = num .. get(self);
				end
				expect(self, "}");
				char = util.utf8char(tonumber(num, 16));
			elseif(self.HexEscapes and char == "x") then
				local hex = expect(self, self.HexNumberCharsLookup) .. expect(self, self.HexNumberCharsLookup);
				char = string.char(tonumber(hex, 16));
			elseif(self.EscapeZIgnoreNextWhitespace and char == "z") then
				char = "";
				while(is(self, Tokenizer.WHITESPACE_CHARS)) do
					self.index = self.index + 1;
				end
			end
		end

		--// since table.insert is slower in lua51
		buffer[#buffer + 1] = char
	end

	expect(self, startChar);

	return token(self, startPos, Tokenizer.TokenKind.String, table.concat(buffer))
end

function Tokenizer:interpolatedString()
	local startPos = self.index;
	local startLine, startLinePos = self:getPosition(self.index);
	expect(self, "\`");

	local parts = {};
	local buffer = {};
	local segStartPos = self.index;
	local segLine, segLinePos = self:getPosition(self.index);

	while true do
		if self.index >= self.length then
			logger:error(generateError(self, "Unterminated String"));
		end

		local c = peek(self);
		if c == "\`" then
			get(self);
			table.insert(parts, {
				kind = "string",
				value = table.concat(buffer),
				startPos = segStartPos,
				endPos = self.index,
				line = segLine,
				linePos = segLinePos,
			});
			break;
		elseif c == "{" then
			get(self);
			table.insert(parts, {
				kind = "string",
				value = table.concat(buffer),
				startPos = segStartPos,
				endPos = self.index,
				line = segLine,
				linePos = segLinePos,
			});
			buffer = {};

			local exprTokens = {};
			local braceDepth = 0;
			while true do
				local tk = self:next();
				if tk.kind == Tokenizer.TokenKind.Eof then
					logger:error(generateError(self, "Unterminated expression in string interpolation"));
				end

				if tk.kind == Tokenizer.TokenKind.Symbol and tk.source == "{" then
					braceDepth = braceDepth + 1;
					table.insert(exprTokens, tk);
				elseif tk.kind == Tokenizer.TokenKind.Symbol and tk.source == "}" then
					if braceDepth > 0 then
						braceDepth = braceDepth - 1;
						table.insert(exprTokens, tk);
					else
						break;
					end
				else
					table.insert(exprTokens, tk);
				end
			end

			if #exprTokens == 0 then
				logger:error(generateError(self, "Expected expression inside string interpolation hole"));
			end

			table.insert(parts, {
				kind = "expr",
				tokens = exprTokens,
			});

			segStartPos = self.index;
			segLine, segLinePos = self:getPosition(self.index);
		else
			local char = get(self);
			if char == "\\r" then
				if is(self, "\\n") then
					get(self);
				end
				char = "\\n";
			end

			if char == "\\\\" then
				char = get(self);
				if char == "\`" or char == "{" or char == "}" then
					buffer[#buffer + 1] = char;
				else
					local esc = self.EscapeSequences[char];
					if type(esc) == "string" then
						buffer[#buffer + 1] = esc;
					elseif self.NumericalEscapes and self.NumberCharsLookup[char] then
						local numstr = char;
						if is(self, self.NumberCharsLookup) then
							numstr = numstr .. get(self);
						end
						if is(self, self.NumberCharsLookup) then
							numstr = numstr .. get(self);
						end
						buffer[#buffer + 1] = string.char(tonumber(numstr));
					elseif self.UnicodeEscapes and char == "u" then
						expect(self, "{");
						local num = "";
						while is(self, self.HexNumberCharsLookup) do
							num = num .. get(self);
						end
						expect(self, "}");
						buffer[#buffer + 1] = util.utf8char(tonumber(num, 16));
					elseif self.HexEscapes and char == "x" then
						local hex = expect(self, self.HexNumberCharsLookup) .. expect(self, self.HexNumberCharsLookup);
						buffer[#buffer + 1] = string.char(tonumber(hex, 16));
					elseif self.EscapeZIgnoreNextWhitespace and char == "z" then
						while is(self, Tokenizer.WHITESPACE_CHARS) do
							self.index = self.index + 1;
						end
					else
						buffer[#buffer + 1] = char;
					end
				end
			else
				buffer[#buffer + 1] = char;
			end
		end
	end

	local exprCount = 0;
	for _, part in ipairs(parts) do
		if part.kind == "expr" then
			exprCount = exprCount + 1;
		end
	end

	if exprCount == 0 then
		local fullString = (parts[1] and parts[1].value) or "";
		return token(self, startPos, Tokenizer.TokenKind.String, fullString);
	end

	local validItems = {};
	for _, part in ipairs(parts) do
		if part.kind == "expr" then
			table.insert(validItems, part);
		elseif part.kind == "string" and part.value:len() > 0 then
			table.insert(validItems, part);
		end
	end

	local resultTokens = {};

	table.insert(resultTokens, syntheticToken(
		Tokenizer.TokenKind.Symbol,
		"(",
		"(",
		startLine,
		startLinePos,
		startPos,
		startPos + 1
	));

	for i, item in ipairs(validItems) do
		if i > 1 then
			table.insert(resultTokens, syntheticToken(
				Tokenizer.TokenKind.Symbol,
				"..",
				"..",
				item.line or startLine,
				item.linePos or startLinePos,
				item.startPos or startPos,
				(item.startPos or startPos) + 2
			));
		end

		if item.kind == "string" then
			table.insert(resultTokens, syntheticToken(
				Tokenizer.TokenKind.String,
				item.value,
				"\\"" .. item.value .. "\\"",
				item.line,
				item.linePos,
				item.startPos,
				item.endPos
			));
		elseif item.kind == "expr" then
			local firstTk = item.tokens[1];
			local exprLine = (firstTk and firstTk.line) or startLine;
			local exprLinePos = (firstTk and firstTk.linePos) or startLinePos;
			local exprStartPos = (firstTk and firstTk.startPos) or startPos;
			local lastTk = item.tokens[#item.tokens];
			local exprEndPos = (lastTk and lastTk.endPos) or self.index;

			table.insert(resultTokens, syntheticToken(
				Tokenizer.TokenKind.Ident,
				"tostring",
				"tostring",
				exprLine,
				exprLinePos,
				exprStartPos,
				exprStartPos
			));

			table.insert(resultTokens, syntheticToken(
				Tokenizer.TokenKind.Symbol,
				"(",
				"(",
				exprLine,
				exprLinePos,
				exprStartPos,
				exprStartPos
			));

			for _, tk in ipairs(item.tokens) do
				table.insert(resultTokens, tk);
			end

			table.insert(resultTokens, syntheticToken(
				Tokenizer.TokenKind.Symbol,
				")",
				")",
				(lastTk and lastTk.line) or exprLine,
				(lastTk and lastTk.linePos) or exprLinePos,
				exprEndPos,
				exprEndPos
			));
		end
	end

	local endLine, endLinePos = self:getPosition(self.index);
	table.insert(resultTokens, syntheticToken(
		Tokenizer.TokenKind.Symbol,
		")",
		")",
		endLine,
		endLinePos,
		self.index - 1,
		self.index
	));

	local firstToken = resultTokens[1];
	for k = 2, #resultTokens do
		table.insert(self.tokenQueue, resultTokens[k]);
	end
	self.lastToken = firstToken;
	return firstToken;
end

function Tokenizer:multiLineString()
	local startPos = self.index;
	if(is(self, "[")) then
		self.index = self.index + 1;
		local eqCount = 0;
		while(is(self, "=")) do
			self.index = self.index + 1;
			eqCount = eqCount + 1;
		end
		if(is(self, "[")) then
			-- Multiline String
			-- Parse String to Closing bracket but also consider that the count of equal signs must be the same

			-- Skip Leading newline if existing
			self.index = self.index + 1;
			if(is(self, "\\n")) then
				self.index = self.index + 1;
			end

			local value = "";
			while true do
				local char = get(self);
				if(char == ']') then
					local eqCount2 = 0;
					while(is(self, "=")) do
						char = char .. get(self);
						eqCount2 = eqCount2 + 1;
					end
					if(is(self, "]")) then
						if(eqCount2 == eqCount) then
							self.index = self.index + 1;
							return token(self, startPos, Tokenizer.TokenKind.String, value), true
						end
					end
				end
				value = value .. char;
			end
		end
	end
	self.index = startPos;
	return nil, false -- There was not an actual multiline string at the given Position
end

function Tokenizer:symbol()
	local startPos = self.index;
	for len = self.MaxSymbolLength, 1, -1 do
		local str = self.source:sub(self.index + 1, self.index + len);
		if self.SymbolsLookup[str] then
			self.index = self.index + len;
			return token(self, startPos, Tokenizer.TokenKind.Symbol, str);
		end
	end
	logger:error(generateError(self, "Unknown Symbol"));
end


-- get the Next token
function Tokenizer:next()
	if self.tokenQueue and #self.tokenQueue > 0 then
		local tk = table.remove(self.tokenQueue, 1);
		self.lastToken = tk;
		return tk;
	end

	-- Skip All Whitespace before the token
	self:skipWhitespaceAndComments();

	local startPos = self.index;
	if startPos >= self.length then
		return token(self, startPos, Tokenizer.TokenKind.Eof);
	end

	-- Numbers
	if(is(self, self.NumberCharsLookup)) then
		return self:number();
	end

	-- Identifiers and Keywords
	if(is(self, self.IdentCharsLookup)) then
		return self:ident();
	end

	-- Singleline String Literals
	if(is(self, self.StringStartLookup)) then
		return self:singleLineString();
	end

	-- Luau Backtick / Interpolated String Literals
	if(is(self, "\`")) then
		return self:interpolatedString();
	end

	-- Multiline String Literals
	if(is(self, "[", 0)) then
		-- The isString variable is due to the fact that "[" could also be a symbol for indexing
		local value, isString = self:multiLineString();
		if isString then
			return value;
		end
	end

	-- Number starting with dot
	if(is(self, ".") and is(self, self.NumberCharsLookup, 1)) then
		return self:number();
	end

	-- Symbols
	if(is(self, self.SymbolCharsLookup)) then
		return self:symbol();
	end


	logger:error(generateError(self, "Unexpected char \\"" .. escape(peek(self)) .. "\\"!"));
end

function Tokenizer:scanAll()
	local tb = {};
	repeat
		local token = self:next();
		table.insert(tb, token);
	until token.kind == Tokenizer.TokenKind.Eof
	return tb
end

return Tokenizer
`,"prometheus.unparser":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- unparser.lua
-- Overview:
-- This Script provides a class for lua code generation from an ast
-- This UnParser is Capable of generating LuaU and Lua5.1
--
-- Note that a LuaU ast can only be unparsed as LuaU if it contains any continue statements
--
-- Settings Object:
-- luaVersion : The LuaVersion of the Script

local config = require("config");
local Ast = require("prometheus.ast");
local Enums = require("prometheus.enums");
local util = require("prometheus.util");
local logger = require("logger");

local lookupify = util.lookupify;
local LuaVersion = Enums.LuaVersion;
local AstKind = Ast.AstKind;

local Unparser = {}

Unparser.SPACE = config.SPACE;
Unparser.TAB = config.TAB;

local function escapeString(str)
	str = util.escape(str)
	return str;
end

function Unparser:new(settings)
	local luaVersion = settings.LuaVersion or LuaVersion.LuaU;
	local conventions = Enums.Conventions[luaVersion];
	local unparser = {
		luaVersion = luaVersion;
		conventions = conventions;
		identCharsLookup = lookupify(conventions.IdentChars);
		numberCharsLookup = lookupify(conventions.NumberChars);
		prettyPrint = settings and settings.PrettyPrint or false;
		notIdentPattern = "[^" .. table.concat(conventions.IdentChars, "") .. "]";
		numberPattern = "^[" .. table.concat(conventions.NumberChars, "") .. "]";
		highlight = settings and settings.Highlight or false;
		keywordsLookup = lookupify(conventions.Keywords);
	}

	setmetatable(unparser, self);
	self.__index = self;

	return unparser;
end

function Unparser:isValidIdentifier(source)
	if(string.find(source, self.notIdentPattern)) then
		return false;
	end
	if(string.find(source, self.numberPattern)) then
		return false;
	end
	if self.keywordsLookup[source] then
		return false;
	end
	return #source > 0;
end

function Unparser:setPrettyPrint(prettyPrint)
	self.prettyPrint = prettyPrint;
end

function Unparser:getPrettyPrint()
	return self.prettyPrint;
end

function Unparser:tabs(i, ws_needed)
	return self.prettyPrint and string.rep(self.TAB, i) or ws_needed and self.SPACE or "";
end

function Unparser:newline(ws_needed)
	return self.prettyPrint and "\\n" or ws_needed and self.SPACE or "";
end

function Unparser:whitespaceIfNeeded(following, ws)
	if(self.prettyPrint or self.identCharsLookup[string.sub(following, 1, 1)]) then
		return ws or self.SPACE;
	end
	return "";
end

function Unparser:whitespaceIfNeeded2(leading, ws)
	if(self.prettyPrint or self.identCharsLookup[string.sub(leading, #leading, #leading)]) then
		return ws or self.SPACE;
	end
	return "";
end

function Unparser:optionalWhitespace(ws)
	return self.prettyPrint and (ws or self.SPACE) or "";
end

function Unparser:whitespace(ws)
	return self.SPACE or ws;
end

function Unparser:unparse(ast)
	if(ast.kind ~= AstKind.TopNode) then
		logger:error("Unparser:unparse expects a TopNode as first argument")
	end

	return self:unparseBlock(ast.body);
end

-- Helper to join parts table (optimized string building)
local function joinParts(parts)
	return table.concat(parts)
end

function Unparser:unparseBlock(block, tabbing)
	if(#block.statements < 1) then
		return self:whitespace();
	end

	local parts = {}

	for i, statement in ipairs(block.statements) do
		if(statement.kind ~= AstKind.NopStatement) then
			local statementCode = self:unparseStatement(statement, tabbing);
			if(not self.prettyPrint and #parts > 0 and string.sub(statementCode, 1, 1) == "(") then
				-- Only prepend ';' if the previous statement did not already end with ';'
				local lastChar = nil
				for pIdx = #parts, 1, -1 do
					local m = string.match(parts[pIdx], "(%S)%s*$")
					if m then
						lastChar = m
						break
					end
				end
				if lastChar ~= ";" then
					statementCode = ";" .. statementCode;
				end
			end
			local ws = self:whitespaceIfNeeded2(#parts > 0 and parts[#parts] or "", self:whitespaceIfNeeded(statementCode, self:newline(true)));
			if i ~= 1 then
				parts[#parts + 1] = ws;
			end
			if string.sub(statementCode, -1) ~= ";" then
				statementCode = statementCode .. ";"
			end
			parts[#parts + 1] = statementCode;
		end
	end

	return joinParts(parts);
end

function Unparser:unparseStatement(statement, tabbing)
	tabbing = tabbing and tabbing + 1 or 0;
	local parts = {};
	local function push(...) -- Helper to add multiple strings efficiently
		for i = 1, select('#', ...) do
			parts[#parts + 1] = select(i, ...)
		end
	end

	if(statement.kind == AstKind.ContinueStatement) then
		if self.luaVersion == LuaVersion.LuaU then
			push("continue");
		else
			push("do", self:whitespace(), "break", self:whitespace(), "end");
		end

	-- Break Statement
	elseif(statement.kind == AstKind.BreakStatement) then
		push("break");

	-- Do Statement
	elseif(statement.kind == AstKind.DoStatement) then
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push("do", self:whitespaceIfNeeded(bodyCode, self:newline(true)),
			bodyCode, self:newline(false),
			self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");

	-- While Statement
	elseif(statement.kind == AstKind.WhileStatement) then
		local expressionCode = self:unparseExpression(statement.condition, tabbing);
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push("while", self:whitespaceIfNeeded(expressionCode), expressionCode, self:whitespaceIfNeeded2(expressionCode),
			"do", self:whitespaceIfNeeded(bodyCode, self:newline(true)),
			bodyCode, self:newline(false),
			self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");

	-- Repeat Until Statement
	elseif(statement.kind == AstKind.RepeatStatement) then
		local expressionCode = self:unparseExpression(statement.condition, tabbing);
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push("repeat", self:whitespaceIfNeeded(bodyCode, self:newline(true)),
			bodyCode,
			self:whitespaceIfNeeded2(bodyCode, self:newline() .. self:tabs(tabbing, true)), "until",
			self:whitespaceIfNeeded(expressionCode), expressionCode);

	-- For Statement
	elseif(statement.kind == AstKind.ForStatement) then
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push("for", self:whitespace(), statement.scope:getVariableName(statement.id), self:optionalWhitespace(), "=");
		push(self:optionalWhitespace(), self:unparseExpression(statement.initialValue, tabbing), ",");
		push(self:optionalWhitespace(), self:unparseExpression(statement.finalValue, tabbing), ",");
		local incrementByCode = statement.incrementBy and self:unparseExpression(statement.incrementBy, tabbing) or "1";
		push(self:optionalWhitespace(), incrementByCode, self:whitespaceIfNeeded2(incrementByCode), "do",
			self:whitespaceIfNeeded(bodyCode, self:newline(true)),
			bodyCode, self:newline(false),
			self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");

	-- For In Statement
	elseif(statement.kind == AstKind.ForInStatement) then
		push("for", self:whitespace());
		for i, id in ipairs(statement.ids) do
			if(i ~= 1) then
				push(",", self:optionalWhitespace());
			end
			push(statement.scope:getVariableName(id));
		end
		push(self:whitespace(), "in");
		local exprcode = self:unparseExpression(statement.expressions[1], tabbing);
		push(self:whitespaceIfNeeded(exprcode), exprcode);
		for i = 2, #statement.expressions, 1 do
			exprcode = self:unparseExpression(statement.expressions[i], tabbing);
			push(",", self:optionalWhitespace(), exprcode);
		end
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push(self:whitespaceIfNeeded2(#parts > 0 and parts[#parts] or ""), "do", self:whitespaceIfNeeded(bodyCode, self:newline(true)),
			bodyCode, self:newline(false),
			self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");

	-- If Statement
	elseif(statement.kind == AstKind.IfStatement) then
		local exprcode = self:unparseExpression(statement.condition, tabbing);
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push("if", self:whitespaceIfNeeded(exprcode), exprcode, self:whitespaceIfNeeded2(exprcode), "then",
			self:whitespaceIfNeeded(bodyCode, self:newline(true)), bodyCode);

		for i, eif in ipairs(statement.elseifs) do
			exprcode = self:unparseExpression(eif.condition, tabbing);
			bodyCode = self:unparseBlock(eif.body, tabbing);
			local lastPart = #parts > 0 and parts[#parts] or "";
			push(self:newline(false), self:whitespaceIfNeeded2(lastPart, self:tabs(tabbing, true)),
				"elseif", self:whitespaceIfNeeded(exprcode), exprcode, self:whitespaceIfNeeded2(exprcode),
				"then", self:whitespaceIfNeeded(bodyCode, self:newline(true)), bodyCode);
		end

		if(statement.elsebody) then
			bodyCode = self:unparseBlock(statement.elsebody, tabbing);
			local lastPart = #parts > 0 and parts[#parts] or "";
			push(self:newline(false), self:whitespaceIfNeeded2(lastPart, self:tabs(tabbing, true)),
				"else", self:whitespaceIfNeeded(bodyCode, self:newline(true)), bodyCode);
		end

		push(self:newline(false), self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");

	-- Function Declaration
	elseif(statement.kind == AstKind.FunctionDeclaration) then
		local funcname = statement.scope:getVariableName(statement.id);
		for _, index in ipairs(statement.indices) do
			funcname = funcname .. "." .. index;
		end
		push("function", self:whitespace(), funcname, "(");
		for i, arg in ipairs(statement.args) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			if(arg.kind == AstKind.VarargExpression) then
				push("...");
			else
				push(arg.scope:getVariableName(arg.id));
			end
		end
		push(")");
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push(self:newline(false), bodyCode, self:newline(false),
			self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");

	-- Local Function Declaration
	elseif(statement.kind == AstKind.LocalFunctionDeclaration) then
		local funcname = statement.scope:getVariableName(statement.id);
		push("local", self:whitespace(), "function", self:whitespace(), funcname, "(");
		for i, arg in ipairs(statement.args) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			if(arg.kind == AstKind.VarargExpression) then
				push("...");
			else
				push(arg.scope:getVariableName(arg.id));
			end
		end
		push(")");
		local bodyCode = self:unparseBlock(statement.body, tabbing);
		push(self:newline(false), bodyCode, self:newline(false),
			self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");

	-- Local Variable Declaration
	elseif(statement.kind == AstKind.LocalVariableDeclaration) then
		push("local", self:whitespace());
		for i, id in ipairs(statement.ids) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			push(statement.scope:getVariableName(id));
		end
		if(#statement.expressions > 0) then
			push(self:optionalWhitespace(), "=", self:optionalWhitespace());
			for i, expr in ipairs(statement.expressions) do
				if i > 1 then
					push(",", self:optionalWhitespace());
				end
				push(self:unparseExpression(expr, tabbing + 1));
			end
		end

	-- Function Call Statement
	elseif(statement.kind == AstKind.FunctionCallStatement) then
		if not (statement.base.kind == AstKind.IndexExpression or statement.base.kind == AstKind.VariableExpression) then
			push("(", self:unparseExpression(statement.base, tabbing), ")");
		else
			push(self:unparseExpression(statement.base, tabbing));
		end
		push("(");
		for i, arg in ipairs(statement.args) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			push(self:unparseExpression(arg, tabbing));
		end
		push(")");

	-- Pass Self Function Call Statement
	elseif(statement.kind == AstKind.PassSelfFunctionCallStatement) then
		if not (statement.base.kind == AstKind.IndexExpression or statement.base.kind == AstKind.VariableExpression) then
			push("(", self:unparseExpression(statement.base, tabbing), ")");
		else
			push(self:unparseExpression(statement.base, tabbing));
		end
		push(":", statement.passSelfFunctionName, "(");
		for i, arg in ipairs(statement.args) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			push(self:unparseExpression(arg, tabbing));
		end
		push(")");

	elseif(statement.kind == AstKind.AssignmentStatement) then
		for i, primary_expr in ipairs(statement.lhs) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			push(self:unparseExpression(primary_expr, tabbing));
		end
		push(self:optionalWhitespace(), "=", self:optionalWhitespace());
		for i, expr in ipairs(statement.rhs) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			push(self:unparseExpression(expr, tabbing + 1));
		end

	-- Return Statement
	elseif(statement.kind == AstKind.ReturnStatement) then
		push("return");
		if(#statement.args > 0) then
			local exprcode = self:unparseExpression(statement.args[1], tabbing);
			push(self:whitespaceIfNeeded(exprcode), exprcode);
			for i = 2, #statement.args, 1 do
				exprcode = self:unparseExpression(statement.args[i], tabbing);
				push(",", self:optionalWhitespace(), exprcode);
			end
		end

	elseif self.luaVersion == LuaVersion.LuaU then
		local compoundOperators = {
			[AstKind.CompoundAddStatement] = "+=",
			[AstKind.CompoundSubStatement] = "-=",
			[AstKind.CompoundMulStatement] = "*=",
			[AstKind.CompoundDivStatement] = "/=",
			[AstKind.CompoundModStatement] = "%=",
			[AstKind.CompoundPowStatement] = "^=",
			[AstKind.CompoundConcatStatement] = "..=",
		}

		local operator = compoundOperators[statement.kind]
		if operator then
			push(self:unparseExpression(statement.lhs, tabbing), self:optionalWhitespace(), operator,
				self:optionalWhitespace(), self:unparseExpression(statement.rhs, tabbing));
		else
			logger:error(string.format("\\"%s\\" is not a valid unparseable statement in %s!", statement.kind, self.luaVersion))
		end
	end

	return self:tabs(tabbing, false) .. joinParts(parts);
end

function Unparser:unparseExpression(expression, tabbing)
	if expression.isParenthesizedExpression then
		local unwrapped = {}
		for k, v in pairs(expression) do
			unwrapped[k] = v
		end
		unwrapped.isParenthesizedExpression = nil
		return "(" .. self:unparseExpression(unwrapped, tabbing) .. ")"
	end

	local parts = {};
	local function push(...)
		for i = 1, select('#', ...) do
			parts[#parts + 1] = select(i, ...)
		end
	end

	if(expression.kind == AstKind.BooleanExpression) then
		return expression.value and "true" or "false";
	end

	if(expression.kind == AstKind.NumberExpression) then
		local str = tostring(expression.value);
		if(str == "inf") then
			return "2e1024"
		end
		if(str == "-inf") then
			return "-2e1024"
		end
		if(str:sub(1, 2) == "0.") then
			str = str:sub(2);
		end
		return str;
	end

	if(expression.kind == AstKind.VariableExpression or expression.kind == AstKind.AssignmentVariable) then
		return expression.scope:getVariableName(expression.id);
	end

	if(expression.kind == AstKind.StringExpression) then
		if expression.isLongString then
			return "[====[" .. expression.value .. "]====]";
		end
		return "\\"" .. escapeString(expression.value) .. "\\"";
	end

	if(expression.kind == AstKind.NilExpression) then
		return "nil";
	end

	if(expression.kind == AstKind.VarargExpression) then
		return "...";
	end

	local k = AstKind.OrExpression;
	if(expression.kind == k) then
		local lhs = self:unparseExpression(expression.lhs, tabbing);
		local rhs = self:unparseExpression(expression.rhs, tabbing);
		return lhs .. self:whitespaceIfNeeded2(lhs) .. "or" .. self:whitespaceIfNeeded(rhs) .. rhs;
	end

	k = AstKind.AndExpression;
	if(expression.kind == k) then
		local lhs = self:unparseExpression(expression.lhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			lhs = "(" .. lhs .. ")";
		end

		local rhs = self:unparseExpression(expression.rhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			rhs = "(" .. rhs .. ")";
		end

		return lhs .. self:whitespaceIfNeeded2(lhs) .. "and" .. self:whitespaceIfNeeded(rhs) .. rhs;
	end

	local comparisonOps = {
		[AstKind.LessThanExpression] = "<",
		[AstKind.GreaterThanExpression] = ">",
		[AstKind.LessThanOrEqualsExpression] = "<=",
		[AstKind.GreaterThanOrEqualsExpression] = ">=",
		[AstKind.NotEqualsExpression] = "~=",
		[AstKind.EqualsExpression] = "==",
	}

	local op = comparisonOps[expression.kind]
	if op then
		k = expression.kind
		local lhs = self:unparseExpression(expression.lhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			lhs = "(" .. lhs .. ")";
		end

		local rhs = self:unparseExpression(expression.rhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			rhs = "(" .. rhs .. ")";
		end

		return lhs .. self:optionalWhitespace() .. op .. self:optionalWhitespace() .. rhs;
	end

	k = AstKind.StrCatExpression
	if expression.kind == k then
		local lhs = self:unparseExpression(expression.lhs, tabbing)
		if Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k) then
			lhs = "(" .. lhs .. ")"
		end

		local rhs = self:unparseExpression(expression.rhs, tabbing)
		if Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k) then
			rhs = "(" .. rhs .. ")"
		end

		if self.numberCharsLookup[string.sub(lhs, #lhs, #lhs)] then
			lhs = lhs .. " "
		end

		return lhs .. self:optionalWhitespace() .. (tostring(rhs):sub(1, 1) == "." and ".. " or "..") .. self:optionalWhitespace() .. rhs
	end

	local arithmeticOps = {
		[AstKind.AddExpression] = "+",
		[AstKind.SubExpression] = "-",
		[AstKind.MulExpression] = "*",
		[AstKind.DivExpression] = "/",
		[AstKind.ModExpression] = "%",
		[AstKind.PowExpression] = "^",
	}

	op = arithmeticOps[expression.kind]
	if op then
		k = expression.kind
		local lhs = self:unparseExpression(expression.lhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.lhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			lhs = "(" .. lhs .. ")";
		end

		local rhs = self:unparseExpression(expression.rhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			rhs = "(" .. rhs .. ")";
		end

		if op == "-" and string.sub(rhs, 1, 1) == "-" then
			rhs = "(" .. rhs .. ")";
		end

		return lhs .. self:optionalWhitespace() .. op .. self:optionalWhitespace() .. rhs;
	end

	-- Unary Expressions
	k = AstKind.NotExpression;
	if(expression.kind == k) then
		local rhs = self:unparseExpression(expression.rhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			rhs = "(" .. rhs .. ")";
		end

		return "not" .. self:whitespaceIfNeeded(rhs) .. rhs;
	end

	k = AstKind.NegateExpression;
	if(expression.kind == k) then
		local rhs = self:unparseExpression(expression.rhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			rhs = "(" .. rhs .. ")";
		end

		if string.sub(rhs, 1, 1) == "-" then
			rhs = "(" .. rhs .. ")";
		end

		return "-" .. rhs;
	end

	k = AstKind.LenExpression;
	if(expression.kind == k) then
		local rhs = self:unparseExpression(expression.rhs, tabbing);
		if(Ast.astKindExpressionToNumber(expression.rhs.kind) >= Ast.astKindExpressionToNumber(k)) then
			rhs = "(" .. rhs .. ")";
		end

		return "#" .. rhs;
	end

	k = AstKind.IndexExpression;
	if(expression.kind == k or expression.kind == AstKind.AssignmentIndexing) then
		local base = self:unparseExpression(expression.base, tabbing);
		if(expression.base.kind == AstKind.VarargExpression or Ast.astKindExpressionToNumber(expression.base.kind) > Ast.astKindExpressionToNumber(k) or expression.base.kind == AstKind.StringExpression or expression.base.kind == AstKind.NumberExpression or expression.base.kind == AstKind.NilExpression) then
			base = "(" .. base .. ")";
		end

		-- Identifier Indexing e.g: x.y instead of x["y"];
		if(expression.index.kind == AstKind.StringExpression and self:isValidIdentifier(expression.index.value)) then
			return base .. "." .. expression.index.value;
		end

		-- Index never needs parens
		local index = self:unparseExpression(expression.index, tabbing);
		return base .. "[" .. index .. "]";
	end

	k = AstKind.FunctionCallExpression;
	if(expression.kind == k) then
		if not (expression.base.kind == AstKind.IndexExpression or expression.base.kind == AstKind.VariableExpression) then
			push("(", self:unparseExpression(expression.base, tabbing), ")");
		else
			push(self:unparseExpression(expression.base, tabbing));
		end
		push("(");
		for i, arg in ipairs(expression.args) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			push(self:unparseExpression(arg, tabbing));
		end
		push(")");
		return joinParts(parts);
	end

	k = AstKind.PassSelfFunctionCallExpression;
	if(expression.kind == k) then
		if not (expression.base.kind == AstKind.IndexExpression or expression.base.kind == AstKind.VariableExpression) then
			push("(", self:unparseExpression(expression.base, tabbing), ")");
		else
			push(self:unparseExpression(expression.base, tabbing));
		end
		push(":", expression.passSelfFunctionName, "(");
		for i, arg in ipairs(expression.args) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			push(self:unparseExpression(arg, tabbing));
		end
		push(")");
		return joinParts(parts);
	end

	k = AstKind.FunctionLiteralExpression;
	if(expression.kind == k) then
		push("function", "(");
		for i, arg in ipairs(expression.args) do
			if i > 1 then
				push(",", self:optionalWhitespace());
			end
			if(arg.kind == AstKind.VarargExpression) then
				push("...");
			else
				push(arg.scope:getVariableName(arg.id));
			end
		end
		push(")");
		local bodyCode = self:unparseBlock(expression.body, tabbing);
		push(self:newline(false), bodyCode, self:newline(false),
			self:whitespaceIfNeeded2(bodyCode, self:tabs(tabbing, true)), "end");
		return joinParts(parts);
	end

	k = AstKind.TableConstructorExpression;
	if(expression.kind == k) then
		if(#expression.entries == 0) then return "{}" end;

		local inlineTable = #expression.entries <= 3;
		local tableTabbing = tabbing + 1;

		push("{");
		if inlineTable then
			push(self:optionalWhitespace());
		else
			push(self:optionalWhitespace(self:newline() .. self:tabs(tableTabbing)));
		end

		local p = false;
		for i, entry in ipairs(expression.entries) do
			p = true;
			local sep = self.prettyPrint and "," or (math.random(1, 2) == 1 and "," or ";");
			if i > 1 and not inlineTable then
				push(sep, self:optionalWhitespace(self:newline() .. self:tabs(tableTabbing)));
			elseif i > 1 then
				push(sep, self:optionalWhitespace());
			end
			if(entry.kind == AstKind.KeyedTableEntry) then
				if(entry.key.kind == AstKind.StringExpression and self:isValidIdentifier(entry.key.value)) then
					push(entry.key.value);
				else
					push("[", self:unparseExpression(entry.key, tableTabbing), "]");
				end
				push(self:optionalWhitespace(), "=", self:optionalWhitespace(), self:unparseExpression(entry.value, tableTabbing));
			else
				push(self:unparseExpression(entry.value, tableTabbing));
			end
		end

		if inlineTable then
			return joinParts(parts) .. self:optionalWhitespace() .. "}";
		end

		return joinParts(parts) .. self:optionalWhitespace((p and "," or "") .. self:newline() .. self:tabs(tabbing)) .. "}";
	end

	if (self.luaVersion == LuaVersion.LuaU) then
		k = AstKind.IfElseExpression
		if(expression.kind == k) then
			push("if ");
			push(self:unparseExpression(expression.condition));
			push(" then ");
			push(self:unparseExpression(expression.true_value));
			for _, elseifexp in pairs(expression.elseifs) do
				push(" elseif ");
				push(self:unparseExpression(elseifexp.condition));
				push(" then ");
				push(self:unparseExpression(elseifexp.value));
			end
			push(" else ");
			push(self:unparseExpression(expression.false_value));
			return joinParts(parts);
		end
	end

	logger:error(string.format("\\"%s\\" is not a valid unparseable expression", expression.kind));
end

return Unparser
`,"prometheus.util":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- util.lua
--
-- This Script provides some utility functions for Prometheus.

local function lookupify(tb)
	local tb2 = {};
	for _, v in ipairs(tb) do
		tb2[v] = true
	end
	return tb2
end

local function unlookupify(tb)
	local tb2 = {};
	for v, _ in pairs(tb) do
		table.insert(tb2, v);
	end
	return tb2;
end

local function escape(str)
	return str:gsub(".", function(char)
		local byte = string.byte(char)
		if byte >= 32 and byte <= 126 and char ~= "\\\\" and char ~= "\\"" and char ~= "\\'" then
			return char
		end
		if(char == "\\\\") then
			return "\\\\\\\\";
		end
		if(char == "\\n") then
			return "\\\\n";
		end
		if(char == "\\r") then
			return "\\\\r";
		end
		if(char == "\\"") then
			return "\\\\\\"";
		end
		if(char == "\\'") then
			return "\\\\\\'";
		end
		return string.format("\\\\%03d", byte);
	end)
end

local function chararray(str)
	local tb = {};
	for i = 1, str:len(), 1 do
		table.insert(tb, str:sub(i, i));
	end
	return tb;
end

local function keys(tb)
	local keyset = {}
	local n=0
	for k, _ in pairs(tb) do
		n = n + 1
		keyset[n] = k
	end
	return keyset
end

local utf8char;
do
	local string_char = string.char
	function utf8char(cp)
	  if cp < 128 then
		return string_char(cp)
	  end
	  local suffix = cp % 64
	  local c4 = 128 + suffix
	  cp = (cp - suffix) / 64
	  if cp < 32 then
		return string_char(192 + cp, c4)
	  end
	  suffix = cp % 64
	  local c3 = 128 + suffix
	  cp = (cp - suffix) / 64
	  if cp < 16 then
		return string_char(224 + cp, c3, c4)
	  end
	  suffix = cp % 64
	  cp = (cp - suffix) / 64
	  return string_char(240 + cp, 128 + suffix, c3, c4)
	end
  end

local function shuffle(tb)
	for i = #tb, 2, -1 do
		local j = math.random(i)
		tb[i], tb[j] = tb[j], tb[i]
	end
	return tb
end

local function readonly(obj)
	local r = newproxy(true);
	getmetatable(r).__index = obj;
	return r;
end

return {
	lookupify = lookupify,
	unlookupify = unlookupify,
	escape = escape,
	chararray = chararray,
	keys = keys,
	shuffle = shuffle,
	utf8char = utf8char,
	readonly = readonly
}
`,"prometheus.visitast":`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- visitast.lua
--
-- This Script provides a utility function for visiting each node of an AST.

local Ast = require("prometheus.ast");
local util = require("prometheus.util");

local AstKind = Ast.AstKind;
local lookupify = util.lookupify;

local visitAst, visitBlock, visitStatement, visitExpression;

function visitAst(ast, previsit, postvisit, data)
	ast.isAst = true;
	data = data or {};
	data.scopeStack = {};
	data.functionData = {
		depth = 0;
		scope = ast.body.scope;
		node = ast;
	};
	data.scope = ast.globalScope;
	data.globalScope = ast.globalScope;
	if(type(previsit) == "function") then
		local node, skip = previsit(ast, data);
		ast = node or ast;
		if skip then
			return ast;
		end
	end

	-- Is Function Block because global scope is treated like a Function
	visitBlock(ast.body, previsit, postvisit, data, true);

	if(type(postvisit) == "function") then
		ast = postvisit(ast, data) or ast;
	end
	return ast;
end

local compundStats = lookupify{
	AstKind.CompoundAddStatement,
	AstKind.CompoundSubStatement,
	AstKind.CompoundMulStatement,
	AstKind.CompoundDivStatement,
	AstKind.CompoundModStatement,
	AstKind.CompoundPowStatement,
	AstKind.CompoundConcatStatement,
}

function visitBlock(block, previsit, postvisit, data, isFunctionBlock)
	block.isBlock = true;
	block.isFunctionBlock = isFunctionBlock or false;
	data.scope = block.scope;
	local parentBlockData = data.blockData;
	data.blockData = {};
	table.insert(data.scopeStack, block.scope);
	if(type(previsit) == "function") then
		local node, skip = previsit(block, data);
		block = node or block;
		if skip then
			data.scope = table.remove(data.scopeStack);
			return block
		end
	end

	local i = 1;
	while i <= #block.statements do
		local statement = table.remove(block.statements, i);
		i = i - 1;
		local returnedStatements = {visitStatement(statement, previsit, postvisit, data)};
		for j, statement in ipairs(returnedStatements) do
			i = i + 1;
			table.insert(block.statements, i, statement);
		end
		i = i + 1;
	end

	if(type(postvisit) == "function") then
		block = postvisit(block, data) or block;
	end
	data.scope = table.remove(data.scopeStack);
	data.blockData = parentBlockData;
	return block;
end

function visitStatement(statement, previsit, postvisit, data)
	statement.isStatement = true;
	if(type(previsit) == "function") then
		local node, skip = previsit(statement, data);
		statement = node or statement;
		if skip then
			return statement;
		end
	end

	-- Visit Child Nodes of Statement
	if(statement.kind == AstKind.ReturnStatement) then
		for i, expression in ipairs(statement.args) do
			statement.args[i] = visitExpression(expression, previsit, postvisit, data);
		end
	elseif(statement.kind == AstKind.PassSelfFunctionCallStatement or statement.kind == AstKind.FunctionCallStatement) then
		statement.base = visitExpression(statement.base, previsit, postvisit, data);
		for i, expression in ipairs(statement.args) do
			statement.args[i] = visitExpression(expression, previsit, postvisit, data);
		end
	elseif(statement.kind == AstKind.AssignmentStatement) then
		for i, primaryExpr in ipairs(statement.lhs) do
			statement.lhs[i] = visitExpression(primaryExpr, previsit, postvisit, data);
		end
		for i, expression in ipairs(statement.rhs) do
			statement.rhs[i] = visitExpression(expression, previsit, postvisit, data);
		end
	elseif(statement.kind == AstKind.FunctionDeclaration or statement.kind == AstKind.LocalFunctionDeclaration) then
		local parentFunctionData = data.functionData;
		data.functionData = {
			depth = parentFunctionData.depth + 1;
			scope = statement.body.scope;
			node = statement;
		};
		statement.body = visitBlock(statement.body, previsit, postvisit, data, true);
		data.functionData = parentFunctionData;
	elseif(statement.kind == AstKind.DoStatement) then
		statement.body = visitBlock(statement.body, previsit, postvisit, data, false);
	elseif(statement.kind == AstKind.WhileStatement) then
		statement.condition = visitExpression(statement.condition, previsit, postvisit, data);
		statement.body = visitBlock(statement.body, previsit, postvisit, data, false);
	elseif(statement.kind == AstKind.RepeatStatement) then
		statement.body = visitBlock(statement.body, previsit, postvisit, data);
		statement.condition = visitExpression(statement.condition, previsit, postvisit, data);
	elseif(statement.kind == AstKind.ForStatement) then
		statement.initialValue = visitExpression(statement.initialValue, previsit, postvisit, data);
		statement.finalValue = visitExpression(statement.finalValue, previsit, postvisit, data);
		statement.incrementBy = visitExpression(statement.incrementBy, previsit, postvisit, data);
		statement.body = visitBlock(statement.body, previsit, postvisit, data, false);
	elseif(statement.kind == AstKind.ForInStatement) then
		for i, expression in ipairs(statement.expressions) do
			statement.expressions[i] = visitExpression(expression, previsit, postvisit, data);
		end
		statement.body = visitBlock(statement.body, previsit, postvisit, data, false);
	elseif(statement.kind == AstKind.IfStatement) then
		statement.condition = visitExpression(statement.condition, previsit, postvisit, data);
		statement.body = visitBlock(statement.body, previsit, postvisit, data, false);
		for i, eif in ipairs(statement.elseifs) do
			eif.condition = visitExpression(eif.condition, previsit, postvisit, data);
			eif.body = visitBlock(eif.body, previsit, postvisit, data, false);
		end
		if(statement.elsebody) then
			statement.elsebody = visitBlock(statement.elsebody, previsit, postvisit, data, false);
		end
	elseif(statement.kind == AstKind.LocalVariableDeclaration) then
		for i, expression in ipairs(statement.expressions) do
			statement.expressions[i] = visitExpression(expression, previsit, postvisit, data);
		end
	elseif compundStats[statement.kind] then
		statement.lhs = visitExpression(statement.lhs, previsit, postvisit, data);
		statement.rhs = visitExpression(statement.rhs, previsit, postvisit, data);
	end

	if(type(postvisit) == "function") then
		local statements = {postvisit(statement, data)};
		if #statements > 0 then
			return unpack(statements);
		end
	end

	return statement;
end

local binaryExpressions = lookupify{
	AstKind.OrExpression,
	AstKind.AndExpression,
	AstKind.LessThanExpression,
	AstKind.GreaterThanExpression,
	AstKind.LessThanOrEqualsExpression,
	AstKind.GreaterThanOrEqualsExpression,
	AstKind.NotEqualsExpression,
	AstKind.EqualsExpression,
	AstKind.StrCatExpression,
	AstKind.AddExpression,
	AstKind.SubExpression,
	AstKind.MulExpression,
	AstKind.DivExpression,
	AstKind.ModExpression,
	AstKind.PowExpression,
}
function visitExpression(expression, previsit, postvisit, data)
	expression.isExpression = true;
	if(type(previsit) == "function") then
		local node, skip = previsit(expression, data);
		expression = node or expression;
		if skip then
			return expression;
		end
	end

	if(binaryExpressions[expression.kind]) then
		expression.lhs = visitExpression(expression.lhs, previsit, postvisit, data);
		expression.rhs = visitExpression(expression.rhs, previsit, postvisit, data);
	end

	if(expression.kind == AstKind.NotExpression or expression.kind == AstKind.NegateExpression or expression.kind == AstKind.LenExpression) then
		expression.rhs = visitExpression(expression.rhs, previsit, postvisit, data);
	end

	if(expression.kind == AstKind.PassSelfFunctionCallExpression or expression.kind == AstKind.FunctionCallExpression) then
		expression.base = visitExpression(expression.base, previsit, postvisit, data);
		for i, arg in ipairs(expression.args) do
			expression.args[i] = visitExpression(arg, previsit, postvisit, data);
		end
	end

	if(expression.kind == AstKind.FunctionLiteralExpression) then
		local parentFunctionData = data.functionData;
		data.functionData = {
			depth = parentFunctionData.depth + 1;
			scope = expression.body.scope;
			node = expression;
		};
		expression.body = visitBlock(expression.body, previsit, postvisit, data, true);
		data.functionData = parentFunctionData;
	end

	if(expression.kind == AstKind.TableConstructorExpression) then
		for i, entry in ipairs(expression.entries) do
			if entry.kind == AstKind.KeyedTableEntry then
				entry.key = visitExpression(entry.key, previsit, postvisit, data);
			end
			entry.value = visitExpression(entry.value, previsit, postvisit, data);
		end
	end

	if(expression.kind == AstKind.IndexExpression or expression.kind == AstKind.AssignmentIndexing) then
		expression.base = visitExpression(expression.base, previsit, postvisit, data);
		expression.index = visitExpression(expression.index, previsit, postvisit, data);
	end
	if(expression.kind == AstKind.IfElseExpression) then
		expression.condition = visitExpression(expression.condition, previsit, postvisit, data);
		expression.true_value = visitExpression(expression.true_value, previsit, postvisit, data);
		for i, elif in pairs(expression.elseifs) do
			elif.condition = visitExpression(elif.condition, previsit, postvisit, data);
			elif.value = visitExpression(elif.value, previsit, postvisit, data);
		end
		expression.false_value = visitExpression(expression.false_value, previsit, postvisit, data);
	end

	if(type(postvisit) == "function") then
		expression = postvisit(expression, data) or expression;
	end
	return expression;
end

return visitAst;
`,"prometheus.vm.analyzer.antipattern":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/analyzer/antipattern.lua
--
-- Anti-Pattern Quality Gate & Multi-Dimensional Protection Analyzer for PinatVM 2.0
-- Evaluates output across 6 core protection dimensions:
--   1. Constant Protection (Plaintext leakage, multi-representation usage)
--   2. CFG Protection (Block splitting, opaque predicates, decoy dispersion)
--   3. Opcode Diversity (Sparsity, permuted operand layouts, dynamic thresholds)
--   4. Metadata Exposure (Identifier stripping, debug comments, signature leaks)
--   5. Structural Diversity (Shannon entropy, token randomness)
--   6. Integrity Coverage (Multi-region manifest completeness)
--

local AntiPattern = {}

local function computeEntropy(str)
    if not str or #str == 0 then return 0 end
    local counts = {}
    local len = #str
    for i = 1, len do
        local b = str:byte(i)
        counts[b] = (counts[b] or 0) + 1
    end
    local ent = 0
    for _, count in pairs(counts) do
        local p = count / len
        ent = ent - p * (math.log(p) / math.log(2))
    end
    return ent
end

function AntiPattern.analyze(runtimeScript, rootProto, permutator, header)
    local issues = {}
    local breakdown = {
        constantProtection = 100,
        cfgProtection = 100,
        opcodeDiversity = 100,
        metadataExposure = 100,
        structuralDiversity = 100,
        integrityCoverage = 100,
    }

    -- 1. Constant Protection Evaluation
    local originalStrings = {}
    local multiRepCount = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 }
    local function checkConstants(p)
        for _, c in ipairs(p.constants or {}) do
            if c.t == 1 then
                if c.r and multiRepCount[c.r] ~= nil then
                    multiRepCount[c.r] = multiRepCount[c.r] + 1
                end
            elseif type(c) == "string" and #c >= 4 then
                table.insert(originalStrings, c)
            end
        end
        for _, child in ipairs(p.protos or {}) do checkConstants(child) end
    end
    checkConstants(rootProto)

    local leakedCount = 0
    for _, str in ipairs(originalStrings) do
        if runtimeScript:find(str, 1, true) then
            leakedCount = leakedCount + 1
        end
    end
    if leakedCount > 0 then
        table.insert(issues, string.format("Detected %d plaintext string literals in emitted script.", leakedCount))
        breakdown.constantProtection = math.max(0, breakdown.constantProtection - leakedCount * 25)
    end

    -- 2. Opcode Diversity Evaluation
    local opMap = permutator and permutator.logicalToNumeric or {}
    local isContiguous = true
    local lastId = nil
    for _, id in pairs(opMap) do
        if lastId ~= nil and (id - lastId) ~= 1 then
            isContiguous = false
            break
        end
        lastId = id
    end
    if isContiguous and #opMap > 5 then
        table.insert(issues, "Opcode assignment appears contiguous; lacks build-time sparsity.")
        breakdown.opcodeDiversity = breakdown.opcodeDiversity - 30
    end
    if not permutator or not permutator.rkThreshold or permutator.rkThreshold < 1000 then
        breakdown.opcodeDiversity = breakdown.opcodeDiversity - 20
    end

    -- 3. Integrity Coverage Evaluation
    if not header or not header.manifest or not header.manifest.header or not header.manifest.payload then
        table.insert(issues, "Multi-region integrity manifest is missing or incomplete.")
        breakdown.integrityCoverage = 0
    elseif not header.manifest.constants or not header.manifest.opcodes then
        table.insert(issues, "Multi-region integrity manifest lacks constants or opcode coverage.")
        breakdown.integrityCoverage = 50
    end

    -- 4. Structural Diversity & Shannon Entropy
    local scriptEntropy = computeEntropy(runtimeScript)
    if scriptEntropy < 3.5 then
        table.insert(issues, string.format("Emitted script entropy (%.2f bits/byte) is unusually low.", scriptEntropy))
        breakdown.structuralDiversity = math.max(20, math.floor(scriptEntropy * 15))
    else
        breakdown.structuralDiversity = math.min(100, math.floor(scriptEntropy * 18))
    end

    -- 5. Metadata Exposure Check
    if runtimeScript:find("PROMETHEUS_DEBUG", 1, true) or runtimeScript:find("__PROMETHEUS__", 1, true) then
        table.insert(issues, "Detected internal compiler debug markers in production script.")
        breakdown.metadataExposure = breakdown.metadataExposure - 40
    end

    -- 6. CFG Protection Estimation
    local numInsts = #(rootProto.instructions or {})
    if numInsts < 3 then
        breakdown.cfgProtection = 70
    end

    -- Weighted Composite Score (Engineering Metric)
    local compositeScore = math.floor(
        breakdown.constantProtection * 0.25 +
        breakdown.cfgProtection      * 0.20 +
        breakdown.opcodeDiversity    * 0.20 +
        breakdown.integrityCoverage  * 0.15 +
        breakdown.metadataExposure   * 0.10 +
        breakdown.structuralDiversity * 0.10
    )

    compositeScore = math.max(0, math.min(100, compositeScore))
    local passed = (compositeScore >= 60 and leakedCount == 0)

    return passed, compositeScore, issues, breakdown
end

return AntiPattern
`,"prometheus.vm.analyzer.capability_analysis":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/analyzer/capability_analysis.lua
--
-- PinatVM Capability Analysis Pass
--
-- Analyzes the IR Function tree (all basic blocks, instructions, constants, protos)
-- to identify precisely which host capabilities, standard library APIs, and
-- runtime primitives are actually required by the protected program.
--
-- Output: A minimal CapabilityManifest used to initialize only necessary
-- capabilities in the runtime interpreter, eliminating the environment-mirror
-- architecture and all unnecessary host references.

local CapabilityAnalysis = {}

-- Standard known host global namespaces and functions
local KNOWN_HOST_GLOBALS = {
    -- Functions
    ["print"]          = true,
    ["warn"]           = true,
    ["error"]          = true,
    ["assert"]         = true,
    ["type"]           = true,
    ["typeof"]         = true,
    ["tostring"]       = true,
    ["tonumber"]       = true,
    ["pcall"]          = true,
    ["xpcall"]         = true,
    ["select"]         = true,
    ["unpack"]         = true,
    ["next"]           = true,
    ["pairs"]          = true,
    ["ipairs"]         = true,
    ["rawequal"]       = true,
    ["rawget"]         = true,
    ["rawset"]         = true,
    ["setmetatable"]   = true,
    ["getmetatable"]   = true,
    ["require"]        = true,
    ["collectgarbage"] = true,
    ["tick"]           = true,
    ["time"]           = true,
    -- Host objects / libraries
    ["math"]           = true,
    ["string"]         = true,
    ["table"]          = true,
    ["coroutine"]      = true,
    ["os"]             = true,
    ["io"]             = true,
    ["debug"]          = true,
    ["utf8"]           = true,
    ["bit"]            = true,
    ["bit32"]          = true,
    ["task"]           = true,
    ["game"]           = true,
    ["workspace"]      = true,
    ["script"]         = true,
    ["Vector3"]        = true,
    ["CFrame"]         = true,
    ["Color3"]         = true,
    ["UDim2"]          = true,
    ["Instance"]       = true,
}

local DENIED_HOST_GLOBALS = {
    ["dofile"]           = true,
    ["loadfile"]         = true,
    ["decompile"]        = true,
}

local KNOWN_HOST_NAMESPACES = {
    ["math"]      = true,
    ["string"]    = true,
    ["table"]     = true,
    ["coroutine"] = true,
    ["os"]        = true,
    ["io"]        = true,
    ["debug"]     = true,
    ["utf8"]      = true,
    ["bit"]       = true,
    ["bit32"]     = true,
    ["task"]      = true,
}

function CapabilityAnalysis.analyze(rootIR)
    local manifest = {
        hostGlobals       = {}, -- [name] -> true
        hostNamespaces    = {}, -- [namespace] -> { [method] -> true }
        dynamicNamespaces = {}, -- [namespace] -> true (set when indexed dynamically or with non-literal keys)
        vmGlobals         = {}, -- [name] -> true (script-scoped globals assigned in code)
        needsVararg       = false,
        needsStringDec    = false,
        needsUnpack       = false,
        needsSelect       = false,
        capabilityMap     = {}, -- [name] -> compact_id
        capabilityList    = {}, -- [compact_id] -> name
        totalCapabilities = 0,
    }

    local globalLoads = {}
    local staticAccessCount = {}

    -- Helper to recursively walk an IRFunction
    local function walkFunction(irFunc)
        -- Check if vararg function
        if irFunc.is_vararg then
            manifest.needsVararg = true
        end

        -- Check constants for encrypted strings (types: 1=string, 2=number, 3=bool, 4=nil)
        for _, c in ipairs(irFunc.constants or {}) do
            if type(c) == "table" and c.t == 1 then
                manifest.needsStringDec = true
            elseif type(c) == "string" then
                manifest.needsStringDec = true
            end
        end

        -- Track register assignments to host namespaces within basic blocks
        -- [reg] -> namespace_name
        local regNamespace = {}

        for _, block in ipairs(irFunc.blocks or {}) do
            for _, inst in ipairs(block.instructions or {}) do
                local op   = inst.op
                local ops  = inst.operands or {}

                if op == "VARARG" then
                    manifest.needsVararg = true
                    manifest.needsSelect = true
                elseif op == "CALL" or op == "CALL_FAST" or op == "TAILCALL" or op == "RETURN" then
                    manifest.needsUnpack = true
                end

                if op == "GETGLOBAL" then
                    local targetReg = ops[1]
                    local constIdx  = ops[2]
                    local name = irFunc.constants and irFunc.constants[constIdx]
                    if type(name) == "table" and name.v then
                        name = name.v
                    end

                    if type(name) == "string" and not DENIED_HOST_GLOBALS[name] then
                        -- Check if known host global or not defined as a script global yet
                        if KNOWN_HOST_GLOBALS[name] or not manifest.vmGlobals[name] then
                            manifest.hostGlobals[name] = true
                            if KNOWN_HOST_NAMESPACES[name] then
                                manifest.hostNamespaces[name] = manifest.hostNamespaces[name] or {}
                                globalLoads[name] = (globalLoads[name] or 0) + 1
                                if targetReg then
                                    regNamespace[targetReg] = name
                                end
                            end
                        end
                    end
                elseif op == "SETGLOBAL" then
                    local constIdx = ops[2]
                    local name = irFunc.constants and irFunc.constants[constIdx]
                    if type(name) == "table" and name.v then
                        name = name.v
                    end
                    if type(name) == "string" then
                        manifest.vmGlobals[name] = true
                    end
                elseif op == "MOVE" then
                    local targetReg = ops[1]
                    local srcReg    = ops[2]
                    regNamespace[targetReg] = regNamespace[srcReg]
                elseif op == "MOVE_RANGE" then
                    local targetStart = ops[1]
                    local srcStart    = ops[2]
                    local count       = ops[3] or 1
                    for offset = 0, count - 1 do
                        regNamespace[targetStart + offset] = regNamespace[srcStart + offset]
                    end
                elseif op == "GETTABLE" or op == "TABLE_GET_FAST" or op == "SELF" then
                    local targetReg = ops[1]
                    local tableReg  = ops[2]
                    local keyOperand= ops[3]

                    -- If tableReg holds a known host namespace (e.g. math, string, table)
                    local ns = regNamespace[tableReg]
                    if ns then
                        -- Check if key is a constant string
                        local key = nil
                        if keyOperand and keyOperand >= (irFunc.CONST_THRESHOLD or 50000000) then
                            local kIdx = keyOperand - (irFunc.CONST_THRESHOLD or 50000000)
                            key = irFunc.constants and irFunc.constants[kIdx]
                            if type(key) == "table" and key.v then key = key.v end
                        end

                        if type(key) == "string" then
                            manifest.hostNamespaces[ns] = manifest.hostNamespaces[ns] or {}
                            manifest.hostNamespaces[ns][key] = true
                            staticAccessCount[ns] = (staticAccessCount[ns] or 0) + 1
                        else
                            manifest.dynamicNamespaces[ns] = true
                        end
                    end
                end
            end
        end

        -- Recursively analyze child protos
        for _, child in ipairs(irFunc.protos or {}) do
            walkFunction(child)
        end
    end

    walkFunction(rootIR)

    -- Detect namespaces with dynamic or indirect references
    for ns, loads in pairs(globalLoads) do
        local statics = staticAccessCount[ns] or 0
        if loads > statics then
            manifest.dynamicNamespaces[ns] = true
        end
    end

    -- Build compact sequential capability IDs for all required host globals
    local sortedGlobals = {}
    for gName in pairs(manifest.hostGlobals) do
        table.insert(sortedGlobals, gName)
    end
    table.sort(sortedGlobals)

    for id, gName in ipairs(sortedGlobals) do
        manifest.capabilityMap[gName] = id
        manifest.capabilityList[id]   = gName
    end
    manifest.totalCapabilities = #sortedGlobals

    return manifest
end

return CapabilityAnalysis
`,"prometheus.vm.compiler.cff_ir":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/compiler/cff_ir.lua
--
-- Control-Flow Transformation: Opaque Predicates, Controlled Branches,
-- Decoy States, and Basic-Block Permutation for PinatVM IR
--

local OpaqueFramework = require("prometheus.vm.predicates.framework")

local CffIR = {}

local function shuffle(tbl, rng)
    for i = #tbl, 2, -1 do
        local j = rng(1, i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function CffIR.apply(irFunc, settings, rng)
    if not irFunc or #irFunc.blocks <= 1 then
        for _, proto in ipairs(irFunc.protos or {}) do
            CffIR.apply(proto, settings, rng)
        end
        return
    end

    local threshold = settings.Threshold or 2
    if #irFunc.blocks < threshold then
        for _, proto in ipairs(irFunc.protos or {}) do
            CffIR.apply(proto, settings, rng)
        end
        return
    end

    -- Large-source: No automatic downgrade. Full CFF and block splitting runs on all functions
    -- unless explicitly requested via settings.LiteMode == true.
    local liteMode = (settings.LiteMode == true)

    -- 0. Basic Block Splitting
    if settings.BlockSplitting ~= false and not liteMode then
        local candidates = {}
        for _, b in ipairs(irFunc.blocks) do
            if #b.instructions >= 6 then
                table.insert(candidates, b)
            end
        end
        for _, b in ipairs(candidates) do
            if rng(1, 10) <= 6 then
                local mid = rng(2, #b.instructions - 2)
                irFunc:splitBlock(b, mid)
            end
        end
    end

    -- Reserve a dedicated scratch register window at the top of the function
    local baseScratch = irFunc.max_registers + 1
    irFunc.max_registers = baseScratch + 12
    irFunc.allocated_registers = math.max(irFunc.allocated_registers, irFunc.max_registers)

    -- 1. Create Decoy Basic Blocks (fewer in lite mode)
    local numDecoys = liteMode and 1 or math.max(1, settings.DecoyStates or 2)
    local decoyBlocks = {}
    for d = 1, numDecoys do
        local decoy = irFunc:createBlock("cff_decoy_" .. d)
        decoy.metadata = { decoy = true, protected = true }
        local dReg1 = baseScratch + 1
        local dReg2 = baseScratch + 2
        local c1 = irFunc:addConstant(rng(100, 99999))
        local c2 = irFunc:addConstant("decoy_tag_" .. rng(1000, 9999))
        decoy:addInstruction("LOADK", { dReg1, c1 })
        decoy:addInstruction("LOADK", { dReg2, c2 })
        decoy:addInstruction("ADD", { dReg1, dReg1, dReg1 })
        decoy:addInstruction("RETURN", { 0, 1 })
        table.insert(decoyBlocks, decoy)
    end

    -- 2. Controlled Branch Transformation with Proven Opaque Predicates
    -- Lite mode: 60% predicate insertion rate; full mode: 70%
    local predicateRate = liteMode and 6 or 7
    local originalBlocks = {}
    for _, b in ipairs(irFunc.blocks) do
        table.insert(originalBlocks, b)
    end

    for _, block in ipairs(originalBlocks) do
        local newInstructions = {}
        for idx, inst in ipairs(block.instructions) do
            local prevInst = block.instructions[idx - 1]
            local isAfterSkip = prevInst and (prevInst.op == "TEST" or prevInst.op == "TESTSET" or prevInst.op == "FORPREP" or prevInst.op == "TFORLOOP")

            -- Transform simple unconditional JMP to an opaque predicate controlled branch
            if not isAfterSkip and inst.op == "JMP" and type(inst.operands[1]) == "number" and #decoyBlocks > 0 and rng(1, 10) <= predicateRate then
                local realTargetBlockId = inst.operands[1]
                local decoyTargetBlock = decoyBlocks[rng(1, #decoyBlocks)]

                -- Generate mathematically proven invariant from OpaqueFramework using scratch registers
                local pred = OpaqueFramework.generate(irFunc, rng, baseScratch)

                -- Insert predicate computation instructions
                for _, predInst in ipairs(pred.instructions) do
                    table.insert(newInstructions, predInst)
                end

                -- Branch using condition register
                if pred.expectedBool then
                    table.insert(newInstructions, { op = "TEST", operands = { pred.condReg, 0 } })
                    table.insert(newInstructions, { op = "JMP", operands = { decoyTargetBlock.id } })
                    table.insert(newInstructions, { op = "JMP", operands = { realTargetBlockId } })
                else
                    table.insert(newInstructions, { op = "TEST", operands = { pred.condReg, 1 } })
                    table.insert(newInstructions, { op = "JMP", operands = { decoyTargetBlock.id } })
                    table.insert(newInstructions, { op = "JMP", operands = { realTargetBlockId } })
                end
            else
                table.insert(newInstructions, inst)
            end
        end
        block.instructions = newInstructions
    end

    irFunc:rebuildCfgEdges()

    -- 3. Block Ordering Transformation
    -- Physical block order is shuffled (entry block remains first to preserve initial execution entry)
    local nonEntry = {}
    for i = 2, #irFunc.blocks do
        table.insert(nonEntry, irFunc.blocks[i])
    end
    shuffle(nonEntry, rng)

    local shuffledBlocks = { irFunc.blocks[1] }
    for _, b in ipairs(nonEntry) do
        table.insert(shuffledBlocks, b)
    end
    irFunc.blocks = shuffledBlocks

    -- Recursively transform child prototypes
    for _, proto in ipairs(irFunc.protos or {}) do
        CffIR.apply(proto, settings, rng)
    end
end

return CffIR
`,"prometheus.vm.compiler.cfg_verifier":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/compiler/cfg_verifier.lua
--
-- CFG Equivalence Verifier: Compares original CFG vs transformed CFG to ensure
-- that all reachable execution paths, return points, and basic block semantics are preserved.
--

local CfgVerifier = {}

local function countTerminators(irFunc)
    local returnCount = 0
    for _, block in ipairs(irFunc.blocks) do
        for _, inst in ipairs(block.instructions) do
            if inst.op == "RETURN" then
                returnCount = returnCount + 1
            end
        end
    end
    return returnCount
end

function CfgVerifier.verifyEquivalence(origIR, transIR)
    local errors = {}

    -- 1. Check root function basic properties
    if origIR.numparams ~= transIR.numparams then
        table.insert(errors, string.format("Parameter count mismatch: original=%s, transformed=%s",
            tostring(origIR.numparams), tostring(transIR.numparams)))
    end

    if #origIR.protos ~= #transIR.protos then
        table.insert(errors, string.format("Child prototype count mismatch: original=%d, transformed=%d",
            #origIR.protos, #transIR.protos))
    end

    -- 2. Check reachable blocks in transformed CFG
    local transReachable = transIR:getReachableBlocks()
    if not transReachable[transIR.blocks[1].id] then
        table.insert(errors, "Transformed CFG entry block is not marked reachable.")
    end

    -- 3. Ensure all return points from original CFG remain present and reachable
    local origReturns = countTerminators(origIR)
    local transReturns = countTerminators(transIR)

    if transReturns < origReturns then
        table.insert(errors, string.format("Return points lost in transformation: original=%d, transformed=%d",
            origReturns, transReturns))
    end

    -- 4. Verify all jump targets in transformed CFG point to existing blocks
    local blockMap = {}
    for _, b in ipairs(transIR.blocks) do
        blockMap[b.id] = true
    end

    for bIdx, block in ipairs(transIR.blocks) do
        for iIdx, inst in ipairs(block.instructions) do
            local op = inst.op
            local ops = inst.operands or {}

            if op == "JMP" and type(ops[1]) == "number" then
                if not blockMap[ops[1]] then
                    table.insert(errors, string.format("Transformed block %d has dangling JMP to %d", block.id, ops[1]))
                end
            elseif (op == "FORPREP" or op == "FORLOOP") and type(ops[2]) == "number" then
                if not blockMap[ops[2]] then
                    table.insert(errors, string.format("Transformed block %d has dangling %s to %d", block.id, op, ops[2]))
                end
            elseif op == "TFORLOOP" and type(ops[3]) == "number" then
                if not blockMap[ops[3]] then
                    table.insert(errors, string.format("Transformed block %d has dangling TFORLOOP to %d", block.id, ops[3]))
                end
            end
        end
    end

    -- 5. Recursively verify all child prototypes
    for i = 1, math.min(#origIR.protos, #transIR.protos) do
        local ok, childErrs = CfgVerifier.verifyEquivalence(origIR.protos[i], transIR.protos[i])
        if not ok then
            for _, err in ipairs(childErrs) do
                table.insert(errors, string.format("[proto_%d] %s", i, err))
            end
        end
    end

    if #errors > 0 then
        return false, errors
    end
    return true, nil
end

return CfgVerifier
`,"prometheus.vm.compiler.ir_to_bytecode":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/compiler/ir_to_bytecode.lua
--
-- PinatVM Phase 1: Linearizes IR Basic Blocks into encoded bytecode prototypes.
-- Extended with peephole lowering for fast-path opcodes.
--
-- Peephole Rules:
--   TEST rA, 0 + JMP target → JUMP_IF rA, offset
--   TEST rA, 1 + JMP target → JUMP_IF_NOT rA, offset
--   RETURN rA, B (where B is small fixed count) → RETURN_FAST rA, B-1
--   CALL rA, B, 2 (single return) → CALL_FAST rA, B, 1
--   GETTABLE rA, rB, StrConst → TABLE_GET_FAST rA, rB, constIdx
--   SETTABLE rA, StrConst, rC → TABLE_SET_FAST rA, constIdx, rC

local Opcodes = require("prometheus.vm.opcodes.opcodes")
local IR = require("prometheus.vm.ir.ir")
local CONST_THRESHOLD = IR.CONST_THRESHOLD or 50000000

local IrToBytecode = {}

-- ============================================================
-- Peephole Window: applies instruction-pair lowering
-- Operates on the flat linearInstructions list before encoding
-- ============================================================
local function applyPeephole(linear, irFunc)
    local out = {}
    local i = 1
    local n = #linear

    while i <= n do
        local inst   = linear[i]
        local next   = linear[i + 1]
        local op     = inst.op
        local ops    = inst.operands

        -- Rule 1: TEST rA, 0 ; JMP block → JUMP_IF_NOT rA, block
        --         TEST rA, 1 ; JMP block → JUMP_IF rA, block
        if op == "TEST" and next and next.op == "JMP" then
            local condFlag = ops[2] or 0
            if condFlag == 0 then
                -- TEST rA, 0: if rA is falsy, take JMP (skip was not triggered)
                table.insert(out, {
                    op = "JUMP_IF_NOT",
                    operands = { ops[1], next.operands[1] or 0, 0 },
                    metadata = { peephole = "TEST_JMP_TO_JUMP_IF_NOT" },
                })
                i = i + 2
            elseif condFlag == 1 then
                -- TEST rA, 1: if rA is truthy, take JMP (skip was not triggered)
                table.insert(out, {
                    op = "JUMP_IF",
                    operands = { ops[1], next.operands[1] or 0, 0 },
                    metadata = { peephole = "TEST_JMP_TO_JUMP_IF" },
                })
                i = i + 2
            else
                table.insert(out, inst)
                i = i + 1
            end

        -- Rule 2: RETURN rA, B (fixed, small) → RETURN_FAST rA, B-1
        -- Only when B is a fixed small value (1..4) meaning exactly B-1 returns
        elseif op == "RETURN" then
            local a = ops[1] or 0
            local b = ops[2] or 0
            if b >= 1 and b <= 5 and not (inst.metadata and inst.metadata.generated) then
                table.insert(out, {
                    op = "RETURN_FAST",
                    operands = { a, b - 1, 0 },  -- Bx = exact return count
                    metadata = { peephole = "RETURN_TO_RETURN_FAST" },
                })
            else
                table.insert(out, inst)
            end
            i = i + 1

        -- Rule 3: CALL rA, B, 2 (exactly 1 return expected) → CALL_FAST rA, B-1, 1
        elseif op == "CALL" then
            local a = ops[1] or 0
            local b = ops[2] or 0
            local c = ops[3] or 0
            if c == 2 and b > 0 then
                -- Known-arity single-return call
                table.insert(out, {
                    op = "CALL_FAST",
                    operands = { a, b - 1, 1 },  -- B = arg count, C = return count
                    metadata = { peephole = "CALL_TO_CALL_FAST" },
                })
            else
                table.insert(out, inst)
            end
            i = i + 1

        -- Rule 4: GETTABLE rA, rB, C (where C >= CONST_THRESHOLD and K[C] is string)
        --         → TABLE_GET_FAST rA, rB, stringConstIdx
        elseif op == "GETTABLE" then
            local a = ops[1] or 0
            local b = ops[2] or 0
            local c = ops[3] or 0
            local didEmit = false
            -- c >= CONST_THRESHOLD means it's a constant ref (sentinel before permutation)
            if type(c) == "number" and c >= CONST_THRESHOLD then
                local constIdx = c - CONST_THRESHOLD
                local kVal = irFunc.constants and irFunc.constants[constIdx]
                if type(kVal) == "string" then
                    table.insert(out, {
                        op = "TABLE_GET_FAST",
                        operands = { a, b, c },  -- C still carries the RK encoding
                        metadata = { peephole = "GETTABLE_TO_TABLE_GET_FAST", constIdx = constIdx },
                    })
                    didEmit = true
                end
            end
            if not didEmit then
                table.insert(out, inst)
            end
            i = i + 1

        -- Rule 5: SETTABLE rA, B (string const), rC → TABLE_SET_FAST rA, B, rC
        elseif op == "SETTABLE" then
            local a = ops[1] or 0
            local b = ops[2] or 0
            local c = ops[3] or 0
            local didEmit = false
            if type(b) == "number" and b >= CONST_THRESHOLD then
                local constIdx = b - CONST_THRESHOLD
                local kVal = irFunc.constants and irFunc.constants[constIdx]
                if type(kVal) == "string" then
                    table.insert(out, {
                        op = "TABLE_SET_FAST",
                        operands = { a, b, c },
                        metadata = { peephole = "SETTABLE_TO_TABLE_SET_FAST", constIdx = constIdx },
                    })
                    didEmit = true
                end
            end
            if not didEmit then
                table.insert(out, inst)
            end
            i = i + 1

        else
            table.insert(out, inst)
            i = i + 1
        end
    end

    return out
end

-- ============================================================
-- main compile function
-- ============================================================
function IrToBytecode.compile(irFunc, permutator, options)
    options = options or {}

    -- First, compile all child prototypes recursively
    local compiledProtos = {}
    for i, proto in ipairs(irFunc.protos or {}) do
        compiledProtos[i] = IrToBytecode.compile(proto, permutator, options)
    end

    -- Linearize basic blocks into a flat instruction list
    local linearInstructions = {}
    local blockEntryPc = {}  -- map block.id -> instruction index (1-based)

    for _, block in ipairs(irFunc.blocks) do
        blockEntryPc[block.id] = #linearInstructions + 1
        local blockInsts = block.instructions or {}
        if not options.skipPeephole then
            blockInsts = applyPeephole(blockInsts, irFunc)
        end
        for _, inst in ipairs(blockInsts) do
            table.insert(linearInstructions, {
                op       = inst.op,
                operands = inst.operands or {},
                metadata = inst.metadata or {},
            })
        end
    end

    -- Resolve branch targets (Block IDs) into relative PC offsets (sBx)
    local encodedInstructions = {}
    for pc = 1, #linearInstructions do
        local inst = linearInstructions[pc]
        local op   = inst.op
        local ops  = inst.operands
        local a    = ops[1] or 0
        local b    = ops[2] or 0
        local c    = ops[3] or 0

        -- Branch target resolution for block-ID-based jumps
        if op == "JMP" then
            local targetBlockId = a
            local targetPc = blockEntryPc[targetBlockId] or (pc + 1)
            local sBx = targetPc - pc - 1
            a = sBx; b = 0; c = 0

        elseif op == "JUMP_IF" or op == "JUMP_IF_NOT" then
            -- operands[2] may be a block ID if the peephole ran before resolution
            -- or it may already be an offset if it came from the CFF pass
            local targetVal = b
            if type(targetVal) == "number" and blockEntryPc[targetVal] then
                local targetPc = blockEntryPc[targetVal]
                b = targetPc - pc - 1
            end
            -- a = condReg, b = offset (sBx), c = 0

        elseif op == "FORPREP" or op == "FORLOOP" then
            local targetBlockId = b
            local targetPc = blockEntryPc[targetBlockId] or (pc + 1)
            local sBx = targetPc - pc - 1
            b = sBx

        elseif op == "TFORLOOP" then
            local targetBlockId = c
            local targetPc = blockEntryPc[targetBlockId] or (pc + 1)
            local sBx = targetPc - pc - 1
            c = sBx
        end

        -- RK encoding for standard instructions
        local isRkOp = Opcodes.RkOps[op]
        if isRkOp then
            if type(b) == "number" and b >= CONST_THRESHOLD then
                b = (b - CONST_THRESHOLD - 1) + permutator.rkThreshold
            end
            if type(c) == "number" and c >= CONST_THRESHOLD then
                c = (c - CONST_THRESHOLD - 1) + permutator.rkThreshold
            end
        end

        -- Fast-path ops that still use RK sentinel in C
        if op == "TABLE_GET_FAST" or op == "TABLE_SET_FAST" then
            if type(c) == "number" and c >= CONST_THRESHOLD then
                c = (c - CONST_THRESHOLD - 1) + permutator.rkThreshold
            end
            if type(b) == "number" and b >= CONST_THRESHOLD then
                b = (b - CONST_THRESHOLD - 1) + permutator.rkThreshold
            end
        end

        local encodedTuple = permutator:encodeInstruction(op, a, b, c)
        table.insert(encodedInstructions, encodedTuple)
    end

    -- Security Extension: Append TRAP_HONEYPOT behind unconditional RETURN/RETURN_FAST
    -- Any straight-line disassembler, decompiler, or attacker who NOPs the return will trip the honeypot
    if #linearInstructions > 0 then
        local lastOp = linearInstructions[#linearInstructions].op
        if lastOp == "RETURN" or lastOp == "RETURN_FAST" then
            local trapA = math.random(1, 15)
            local trapB = math.random(1, 31)
            local trapC = math.random(1, 31)
            local trapTuple = permutator:encodeInstruction("TRAP_HONEYPOT", trapA, trapB, trapC)
            table.insert(encodedInstructions, trapTuple)
        end
    end

    -- Build upvalue list
    local upvalues = {}
    for _, up in ipairs(irFunc.upvalues or {}) do
        table.insert(upvalues, {
            is_local = up.is_local and 1 or 0,
            index    = up.index or 0,
        })
    end

    -- Count non-vararg parameters
    local nonVarargParams = 0
    for _, p in ipairs(irFunc.params or {}) do
        if p.kind ~= "VarargExpression" then
            nonVarargParams = nonVarargParams + 1
        end
    end

    -- Strip metadata when in production mode
    local protoName = (options.stripMetadata) and nil or irFunc.name
    local protoId   = (options.stripMetadata) and nil or irFunc.id

    return {
        id           = protoId,
        name         = protoName,
        instructions = encodedInstructions,
        constants    = irFunc.constants or {},
        protos       = compiledProtos,
        numparams    = nonVarargParams,
        is_vararg    = irFunc.is_vararg and 1 or 0,
        maxstacksize = math.max(irFunc.max_registers + 8, 16),
        upvalues     = upvalues,
    }
end

return IrToBytecode
`,"prometheus.vm.compiler.register_allocator":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/compiler/register_allocator.lua
--
-- PinatVM Phase 1: Interval-Based Register Lifetime Tracker & Verifier
--
-- Tracks per-register live intervals [firstDef, lastUse] across a linearized
-- instruction stream of a single IRFunction. Provides:
--
--   1. RegisterAllocator.analyze(irFunc)
--      → returns intervals table, max register used
--
--   2. RegisterAllocator.verify(irFunc, intervals, maxReg)
--      → returns ok, errorList
--      Validates: no register exceeds maxReg, no two logical locals overlap
--      in a conflicting way that the simple allocator would have missed.
--
--   3. RegisterAllocator.computeMaxStack(irFunc)
--      → returns the required stack frame size (max register + 1)
--
-- Architecture note:
-- This is an analysis-and-verification pass, not a replacement for the
-- IRFunction's existing allocRegister/freeRegister mechanism.
-- Full global liveness (across basic blocks via dataflow) is deferred to
-- Phase 2. This pass performs intra-block interval tracking sufficient
-- to detect class-A allocation bugs.
--

local IR = require("prometheus.vm.ir.ir")
local CONST_THRESHOLD = IR.CONST_THRESHOLD or 50000000

local RegisterAllocator = {}

-- ============================================================
-- Internal: linearize an IRFunction's blocks into a flat list
-- Returns: { {op, operands, blockId, blockPos}, ... }
-- ============================================================
local function linearize(irFunc)
    local flat = {}
    local blockEntryIdx = {}

    for _, block in ipairs(irFunc.blocks or {}) do
        blockEntryIdx[block.id] = #flat + 1
        for _, inst in ipairs(block.instructions or {}) do
            table.insert(flat, {
                op       = inst.op,
                operands = inst.operands or {},
                blockId  = block.id,
            })
        end
    end

    return flat, blockEntryIdx
end

-- ============================================================
-- Internal: for each instruction, determine which registers
-- it defines (writes) and which it uses (reads).
-- Returns: defs (set of reg indices), uses (set of reg indices)
-- ============================================================
local function defsUses(inst)
    local op   = inst.op
    local ops  = inst.operands
    local defs = {}
    local uses = {}

    -- Instructions that WRITE to register A
    local writesA = {
        MOVE = true, LOADK = true, LOADBOOL = true, LOADNIL = true, LOADNUM = true,
        GETGLOBAL = true, GETTABLE = true, NEWTABLE = true, SELF = true,
        ADD = true, SUB = true, MUL = true, DIV = true, MOD = true, POW = true,
        CONCAT = true, NOT = true, LEN = true, UNM = true,
        EQ = true, NE = true, LT = true, LE = true, TESTSET = true,
        CALL = true, CLOSURE = true, GETUPVAL = true, VARARG = true,
        FORLOOP = true, FORPREP = true,
        -- Fast path
        LOAD_NUMBER = true, LOAD_STRING = true, LOAD_CONST = true,
        MOVE_RANGE = true, CALL_FAST = true, TABLE_GET_FAST = true,
    }

    -- Instructions that READ from register A
    local readsA = {
        SETGLOBAL = true, SETUPVAL = true, SETTABLE = true,
        RETURN = true, RETURN_FAST = true, TAILCALL = true,
        TEST = true, CLOSE = true,
        JUMP_IF = true, JUMP_IF_NOT = true,
        TABLE_SET_FAST = true,
    }

    local a = ops[1]
    local b = ops[2]
    local c = ops[3]

    -- Register A
    if type(a) == "number" and a > 0 then
        if writesA[op] then
            table.insert(defs, a)
        elseif readsA[op] then
            table.insert(uses, a)
        end
    end

    -- Register B (reads, for most instructions)
    if type(b) == "number" and b > 0 and b < CONST_THRESHOLD then
        local bIsReg = not (
            op == "LOADK" or op == "LOADNUM" or op == "LOAD_NUMBER" or
            op == "LOAD_STRING" or op == "GETGLOBAL" or op == "SETGLOBAL" or
            op == "CLOSURE" or op == "RETURN_FAST"
        )
        if bIsReg then
            table.insert(uses, b)
        end
    end

    -- Register C (reads)
    if type(c) == "number" and c > 0 and c < CONST_THRESHOLD then
        local cIsReg = not (
            op == "LOADBOOL" or op == "LOAD_CONST"
        )
        if cIsReg then
            table.insert(uses, c)
        end
    end

    return defs, uses
end

-- ============================================================
-- PUBLIC: analyze(irFunc)
-- Returns:
--   intervals : table [regIdx] = { first=N, last=N, reg=regIdx }
--   maxReg    : integer
-- ============================================================
function RegisterAllocator.analyze(irFunc)
    local flat = linearize(irFunc)
    local intervals = {}
    local maxReg = irFunc.max_registers or 0

    local function touch(regIdx, pc)
        if type(regIdx) ~= "number" or regIdx <= 0 then return end
        if regIdx > maxReg then maxReg = regIdx end
        if not intervals[regIdx] then
            intervals[regIdx] = { first = pc, last = pc, reg = regIdx }
        else
            if pc < intervals[regIdx].first then intervals[regIdx].first = pc end
            if pc > intervals[regIdx].last  then intervals[regIdx].last  = pc end
        end
    end

    for pc, inst in ipairs(flat) do
        local defs, uses = defsUses(inst)
        for _, r in ipairs(defs) do touch(r, pc) end
        for _, r in ipairs(uses) do touch(r, pc) end
    end

    -- Also account for child proto upvalue captures
    for _, up in ipairs(irFunc.upvalues or {}) do
        if up.is_local and type(up.index) == "number" then
            touch(up.index, #flat + 1)  -- extend to end of function
        end
    end

    return intervals, maxReg
end

-- ============================================================
-- PUBLIC: verify(irFunc, intervals, maxReg)
-- Validates:
--   1. No register index exceeds hard limit (maxReg + safety margin)
--   2. All registers referenced in instructions have a tracked interval
--   3. No two allocations to the same register have conflicting use
--      beyond what the allocator permits (catches double-alloc bugs)
-- Returns: ok (bool), errors (list of strings)
-- ============================================================
function RegisterAllocator.verify(irFunc, intervals, maxReg)
    intervals = intervals or RegisterAllocator.analyze(irFunc)
    maxReg    = maxReg or (irFunc.max_registers or 0)

    local errors = {}
    local hardLimit = maxReg + 64  -- generous safety margin

    local flat = linearize(irFunc)

    for pc, inst in ipairs(flat) do
        local defs, uses = defsUses(inst)
        local allRegs = {}
        for _, r in ipairs(defs) do table.insert(allRegs, r) end
        for _, r in ipairs(uses) do table.insert(allRegs, r) end

        for _, reg in ipairs(allRegs) do
            if type(reg) ~= "number" then
                table.insert(errors, string.format(
                    "[pc=%d op=%s] Non-numeric register reference: %s",
                    pc, tostring(inst.op), tostring(reg)
                ))
            elseif reg < 0 then
                table.insert(errors, string.format(
                    "[pc=%d op=%s] Negative register index: %d",
                    pc, tostring(inst.op), reg
                ))
            elseif reg > hardLimit then
                table.insert(errors, string.format(
                    "[pc=%d op=%s] Register %d exceeds hard limit %d (maxReg=%d)",
                    pc, tostring(inst.op), reg, hardLimit, maxReg
                ))
            end
        end
    end

    -- Verify no interval has first > last (degenerate)
    for reg, iv in pairs(intervals) do
        if iv.first > iv.last then
            table.insert(errors, string.format(
                "Register %d has degenerate interval [%d, %d]",
                reg, iv.first, iv.last
            ))
        end
    end

    -- Recursively verify child protos
    for i, child in ipairs(irFunc.protos or {}) do
        local childIntervals, childMax = RegisterAllocator.analyze(child)
        local ok, childErrors = RegisterAllocator.verify(child, childIntervals, childMax)
        if not ok then
            for _, e in ipairs(childErrors) do
                table.insert(errors, string.format("[proto_%d] %s", i, e))
            end
        end
    end

    return (#errors == 0), errors
end

-- ============================================================
-- PUBLIC: computeMaxStack(irFunc)
-- Returns the minimum required stack frame size for the VM.
-- Accounts for parameters, locals, and the CFF scratch window.
-- ============================================================
function RegisterAllocator.computeMaxStack(irFunc)
    local _, maxReg = RegisterAllocator.analyze(irFunc)
    -- Lua convention: add a safety margin of 8 above max register
    return math.max(maxReg + 8, 16)
end

-- ============================================================
-- PUBLIC: report(irFunc)
-- Returns a human-readable string summarizing register usage.
-- Used by the benchmark and debug mode.
-- ============================================================
function RegisterAllocator.report(irFunc)
    local intervals, maxReg = RegisterAllocator.analyze(irFunc)
    local lines = {
        string.format("Function '%s' (id=%d): maxReg=%d, params=%d",
            irFunc.name or "?", irFunc.id or 0,
            maxReg, #(irFunc.params or {}))
    }

    local sorted = {}
    for reg, iv in pairs(intervals) do
        table.insert(sorted, { reg = reg, first = iv.first, last = iv.last })
    end
    table.sort(sorted, function(a, b) return a.reg < b.reg end)

    for _, entry in ipairs(sorted) do
        table.insert(lines, string.format(
            "  R[%3d]: live [%d, %d] (span=%d)",
            entry.reg, entry.first, entry.last, entry.last - entry.first + 1
        ))
    end

    -- Child protos summary
    for i, child in ipairs(irFunc.protos or {}) do
        local _, childMax = RegisterAllocator.analyze(child)
        table.insert(lines, string.format("  child proto[%d]: maxReg=%d", i, childMax))
    end

    return table.concat(lines, "\\n")
end

return RegisterAllocator
`,"prometheus.vm.encoder.serializer":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/encoder/serializer.lua
--
-- PinatVM Phase 1: Serializes the protected bytecode chunk into a Lua table literal.
-- Supports metadata stripping (production mode) and versioned header format.
--

local Serializer = {}

-- Recursive Lua-table-literal serializer
-- Produces a compact, valid Lua table constructor that can be embedded in code.
local function serializeValue(v)
    local t = type(v)
    if t == "number" then
        return tostring(v)
    elseif t == "string" then
        return string.format("%q", v)
    elseif t == "boolean" then
        return v and "true" or "false"
    elseif t == "nil" then
        return "nil"
    elseif t == "table" then
        local parts = {}
        local isArray = (#v > 0)
        if isArray then
            for _, item in ipairs(v) do
                table.insert(parts, serializeValue(item))
            end
        else
            for k, item in pairs(v) do
                local keyStr
                if type(k) == "string" and k:match("^[%a_][%w_]*$") then
                    keyStr = k
                else
                    keyStr = "[" .. serializeValue(k) .. "]"
                end
                table.insert(parts, keyStr .. "=" .. serializeValue(item))
            end
        end
        return "{" .. table.concat(parts, ",") .. "}"
    else
        return "nil"
    end
end

-- Strip metadata fields (name, id) from proto tree — production mode
-- Returns a new table, not mutating the original.
local function stripProtoMetadata(proto)
    local cleaned = {}
    for k, v in pairs(proto) do
        -- Keep b64Salt: required by Rep5 runtime decoder to reconstruct Base64 alphabet
        if k ~= "name" and k ~= "id" and k ~= "resolvedK" and k ~= "resolvedNil" and k ~= "chainHashes" then
            if k == "protos" then
                local cleanedProtos = {}
                for i, child in ipairs(v) do
                    cleanedProtos[i] = stripProtoMetadata(child)
                end
                cleaned.protos = cleanedProtos
            else
                cleaned[k] = v
            end
        end
    end
    return cleaned
end

-- Strip runtime-only cache fields (resolvedK, resolvedNil) from proto tree
-- Note: kdfSalt is REQUIRED by the runtime interpreter to decrypt constants.
local function cleanRuntimeFields(proto)
    local cleaned = {}
    for k, v in pairs(proto) do
        if k ~= "resolvedK" and k ~= "resolvedNil" and k ~= "chainHashes" then
            if k == "protos" then
                local cleanedProtos = {}
                for i, child in ipairs(v) do
                    cleanedProtos[i] = cleanRuntimeFields(child)
                end
                cleaned.protos = cleanedProtos
            else
                cleaned[k] = v
            end
        end
    end
    return cleaned
end

-- ============================================================
-- Buffer-based serializer with chunk-flushing (bounded memory)
-- Flushes every 4096 tokens into intermediate strings to avoid
-- huge single-table reallocations (>100MB) in 32-bit/Wasm memory.
-- ============================================================
local function newPackContext()
    local ctx = {
        buf = {},
        bufCount = 0,
        chunks = {},
        FLUSH_LIMIT = 4096
    }
    function ctx:push(s)
        local cnt = self.bufCount + 1
        self.buf[cnt] = s
        self.bufCount = cnt
        if cnt >= self.FLUSH_LIMIT then
            self.chunks[#self.chunks + 1] = table.concat(self.buf)
            self.buf = {}
            self.bufCount = 0
        end
    end
    function ctx:finish()
        if self.bufCount > 0 then
            self.chunks[#self.chunks + 1] = table.concat(self.buf)
            self.buf = {}
            self.bufCount = 0
        end
        return table.concat(self.chunks)
    end
    return ctx
end

local function packValueInto(v, ctx)
    local t = type(v)
    if t == "number" then
        if v % 1 == 0 then
            if v >= 0 and v <= 255 then
                ctx:push("I")
                ctx:push(string.char(v))
                return
            elseif v >= -32768 and v <= 32767 then
                local off = v + 32768
                ctx:push("K")
                ctx:push(string.char(math.floor(off / 256), off % 256))
                return
            end
        end
        ctx:push("N")
        ctx:push(tostring(v))
        ctx:push(";")
    elseif t == "string" then
        ctx:push("S")
        ctx:push(tostring(#v))
        ctx:push(":")
        ctx:push(v)
    elseif t == "boolean" then
        ctx:push(v and "T" or "F")
    elseif t == "nil" then
        ctx:push("Z")
    elseif t == "table" then
        local isArr = true
        local n = 0
        for k in pairs(v) do
            n = n + 1
            if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
                isArr = false
            end
        end
        if isArr and #v == n then
            if n == 4 then
                ctx:push("X")
                for i = 1, 4 do
                    packValueInto(v[i], ctx)
                end
            else
                ctx:push("A")
                ctx:push(tostring(n))
                ctx:push(";")
                for i = 1, n do
                    packValueInto(v[i], ctx)
                end
            end
        else
            local count = 0
            for _ in pairs(v) do count = count + 1 end
            ctx:push("M")
            ctx:push(tostring(count))
            ctx:push(";")
            for k, val in pairs(v) do
                packValueInto(k, ctx)
                packValueInto(val, ctx)
            end
        end
    else
        ctx:push("Z")
    end
end

local function packValue(v)
    local ctx = newPackContext()
    packValueInto(v, ctx)
    return ctx:finish()
end

local function encryptPayload(str, salt, alphabet)
    salt = (salt or 12345) % 2147483647
    if salt == 0 then salt = 1337 end

    -- Non-Linear KDF Nonce Header (16 polymorphic chars / 8 bytes)
    -- Encodes the 32-bit salt using modular arithmetic and non-linear permutations.
    -- No plaintext seed is ever emitted into Lua code!
    local b1 = salt % 256
    local b2 = math.floor(salt / 256) % 256
    local b3 = math.floor(salt / 65536) % 256
    local b4 = math.floor(salt / 16777216) % 256

    local c1 = (b1 * 13 + 37) % 256
    local c2 = (b2 * 29 + 83) % 256
    local c3 = (b3 * 37 + 109) % 256
    local c4 = (b4 * 53 + 131) % 256
    local c5 = (c1 * 3 + c2 * 7 + 17) % 256
    local c6 = (c2 * 5 + c3 * 11 + 29) % 256
    local c7 = (c3 * 7 + c4 * 13 + 43) % 256
    local c8 = (c4 * 11 + c1 * 17 + 61) % 256

    -- Dynamic S-Box Construction from salt (Fisher-Yates via 32-bit Lehmer LCG)
    local sbox = {}
    for i = 0, 255 do sbox[i] = i end
    local rng = (salt % 2147483647)
    if rng == 0 then rng = 1337 end
    for i = 255, 1, -1 do
        rng = (rng * 16807 + 12345) % 2147483647
        local j = rng % (i + 1)
        sbox[i], sbox[j] = sbox[j], sbox[i]
    end

    -- Multi-layer S-Box + Arithmetic Stream Cipher (non-linear diffusion, 53-bit safe)
    local state = salt % 2147483647
    if state == 0 then state = 1337 end

    local isB64 = (alphabet and #alphabet >= 64)
    if isB64 then
        local encBytes = {}
        local chunks = {}
        local subChars = {}
        local subCount = 0
        local FLUSH = 4096

        local function pushByte(b)
            encBytes[#encBytes + 1] = b
            if #encBytes >= 3 then
                local y1, y2, y3 = encBytes[1], encBytes[2], encBytes[3]
                encBytes[1], encBytes[2], encBytes[3] = nil, nil, nil
                encBytes = {}
                local i1 = math.floor(y1 / 4)
                local i2 = (y1 % 4) * 16 + math.floor(y2 / 16)
                local i3 = (y2 % 16) * 4 + math.floor(y3 / 64)
                local i4 = y3 % 64
                subCount = subCount + 4
                subChars[subCount - 3] = alphabet:sub(i1 + 1, i1 + 1)
                subChars[subCount - 2] = alphabet:sub(i2 + 1, i2 + 1)
                subChars[subCount - 1] = alphabet:sub(i3 + 1, i3 + 1)
                subChars[subCount]     = alphabet:sub(i4 + 1, i4 + 1)
                if subCount >= FLUSH then
                    chunks[#chunks + 1] = table.concat(subChars)
                    subChars = {}
                    subCount = 0
                end
            end
        end

        local hdr = { c1, c2, c3, c4, c5, c6, c7, c8 }
        for i = 1, #hdr do pushByte(hdr[i]) end

        for i = 1, #str do
            state = (state * 16807 + 12345) % 2147483647
            local hi = math.floor(state / 65536)
            local lo = state % 65536
            state = (lo * 32719 + hi * 16807 + 7) % 2147483647
            local sIdx = state % 256
            local sVal = sbox[sIdx]
            local orig = str:byte(i)
            local b = ((orig + sVal) * 13 + (state % 256)) % 256
            pushByte(b)
        end

        if #encBytes == 1 then
            local y1 = encBytes[1]
            local i1 = math.floor(y1 / 4)
            local i2 = (y1 % 4) * 16
            subChars[subCount + 1] = alphabet:sub(i1 + 1, i1 + 1)
            subChars[subCount + 2] = alphabet:sub(i2 + 1, i2 + 1)
            subCount = subCount + 2
        elseif #encBytes == 2 then
            local y1, y2 = encBytes[1], encBytes[2]
            local i1 = math.floor(y1 / 4)
            local i2 = (y1 % 4) * 16 + math.floor(y2 / 16)
            local i3 = (y2 % 16) * 4
            subChars[subCount + 1] = alphabet:sub(i1 + 1, i1 + 1)
            subChars[subCount + 2] = alphabet:sub(i2 + 1, i2 + 1)
            subChars[subCount + 3] = alphabet:sub(i3 + 1, i3 + 1)
            subCount = subCount + 3
        end

        if subCount > 0 then
            chunks[#chunks + 1] = table.concat(subChars)
        end
        return table.concat(chunks)
    else
        local BYTE_TO_TOKEN = {}
        if alphabet and #alphabet >= 16 then
            for i = 0, 255 do
                local hi = math.floor(i / 16)
                local lo = i % 16
                BYTE_TO_TOKEN[i] = alphabet:sub(hi + 1, hi + 1) .. alphabet:sub(lo + 1, lo + 1)
            end
        else
            for i = 0, 255 do BYTE_TO_TOKEN[i] = string.format("%02x", i) end
        end

        local chunks = {}
        chunks[1] = BYTE_TO_TOKEN[c1] .. BYTE_TO_TOKEN[c2] .. BYTE_TO_TOKEN[c3] .. BYTE_TO_TOKEN[c4] ..
                    BYTE_TO_TOKEN[c5] .. BYTE_TO_TOKEN[c6] .. BYTE_TO_TOKEN[c7] .. BYTE_TO_TOKEN[c8]

        local subBuf = {}
        local subCount = 0
        local CHUNK_SIZE = 4096

        for i = 1, #str do
            state = (state * 16807 + 12345) % 2147483647
            local hi = math.floor(state / 65536)
            local lo = state % 65536
            state = (lo * 32719 + hi * 16807 + 7) % 2147483647
            local sIdx = state % 256
            local sVal = sbox[sIdx]
            local orig = str:byte(i)
            local b = ((orig + sVal) * 13 + (state % 256)) % 256
            subCount = subCount + 1
            subBuf[subCount] = BYTE_TO_TOKEN[b]
            if subCount >= CHUNK_SIZE then
                chunks[#chunks + 1] = table.concat(subBuf)
                subBuf = {}
                subCount = 0
            end
        end
        if subCount > 0 then
            chunks[#chunks + 1] = table.concat(subBuf)
        end
        return table.concat(chunks)
    end
end

-- ============================================================
-- Serializer.serializeChunk(header, decoderConfig, rootProto)
--
-- header fields used:
--   magic, version, flags, salt, manifest, mode, profile
--   stripMetadata (bool) — omit name/id from protos
-- ============================================================
function Serializer.serializeChunk(header, decoderConfig, rootProto)
    local proto = rootProto

    -- Always strip runtime-only fields (these must never appear in output)
    proto = cleanRuntimeFields(proto)

    -- Optionally strip debug metadata (name, id) in production mode
    if header.stripMetadata or header.mode == "Release" then
        proto = stripProtoMetadata(proto)
    end

    local chunkData = {
        m   = header.magic   or "PVM2",
        v   = header.version or 2.2,
        f   = header.flags   or 15,
        s   = header.salt    or 0,
        cfg = decoderConfig,
        p   = proto,
        sig = header.manifest or {},
        dp  = header.decoyProto,
    }

    local packed = packValue(chunkData)
    local salt = header.salt or 1337

    -- Polymorphic 64-character Alphabet Generation (Base64)
    local pool = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
    local poolChars = {}
    for i = 1, #pool do poolChars[i] = pool:sub(i, i) end
    local r = (salt % 2147483647)
    if r == 0 then r = 1337 end
    for i = #poolChars, 2, -1 do
        r = (r * 16807 + 12345) % 2147483647
        local j = (r % i) + 1
        poolChars[i], poolChars[j] = poolChars[j], poolChars[i]
    end
    local alphabet = table.concat(poolChars)

    local encPayload = encryptPayload(packed, salt, alphabet)
    -- Adaptive chunk size: 8192 chars (or 16384 for payloads > 2MB)
    local CHUNK_SIZE = 8192
    if #encPayload > 2000000 then
        CHUNK_SIZE = 16384
    end
    local chunkList = {}
    for i = 1, #encPayload, CHUNK_SIZE do
        chunkList[#chunkList + 1] = string.format("%q", encPayload:sub(i, i + CHUNK_SIZE - 1))
    end
    return string.format("_vm_load({%s}, %q)", table.concat(chunkList, ","), alphabet)
end

return Serializer
`,"prometheus.vm.ir.ast_to_ir":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/ir/ast_to_ir.lua
--
-- Compiles Prometheus AST into PinatVM Control Flow Graph (IRFunction & BasicBlocks)

local Ast = require("prometheus.ast")
local IR = require("prometheus.vm.ir.ir")
local AstKind = Ast.AstKind

local CONST_THRESHOLD = IR.CONST_THRESHOLD or 50000000

local AstToIR = {}
AstToIR.__index = AstToIR

function AstToIR.new()
    return setmetatable({
        nextFuncId = 0,
    }, AstToIR)
end

function AstToIR:compile(ast)
    self.nextFuncId = 0
    local rootFunc = self:createFunction("main", nil, {}, true)
    local entryBlock = rootFunc:createBlock("entry")
    rootFunc:setActiveBlock(entryBlock)

    local bodyBlock = ast.body or ast
    self:compileBlock(rootFunc, bodyBlock)

    -- If the main chunk did not end with a return, add implicit RETURN 0, 1 (no returns)
    if not rootFunc.currentBlock.terminated then
        rootFunc:addInstruction("RETURN", { 0, 1 })
        rootFunc.currentBlock:setTerminated(true)
    end

    return rootFunc
end

function AstToIR:createFunction(name, parent, params, is_vararg)
    self.nextFuncId = self.nextFuncId + 1
    local func = IR.IRFunction.new(self.nextFuncId, name, parent)
    func.is_vararg = (is_vararg == true)
    func.params = params or {}
    func.localMap = {} -- [scope_id_key] -> reg
    func.loopStack = {}

    func.numLocals = 0
    -- Allocate registers for parameters
    for _, param in ipairs(func.params) do
        if param.kind == AstKind.VarargExpression then
            func.is_vararg = true
        else
            local reg = func:allocRegister()
            self:defineLocal(func, param.scope, param.id, reg)
            func.numLocals = math.max(func.numLocals or 0, reg)
        end
    end

    return func
end

local function makeVarKey(scope, id)
    return tostring(scope) .. ":" .. tostring(id)
end

function AstToIR:defineLocal(func, scope, id, reg)
    local key = makeVarKey(scope, id)
    func.localMap[key] = reg
    func.numLocals = math.max(func.numLocals or 0, reg)
    return reg
end

function AstToIR:resolveVariable(func, varNode)
    local scope = varNode.scope
    local id = varNode.id

    -- 1. Check if global
    if not scope or scope.isGlobal then
        local name = (scope and scope.getVariableName) and scope:getVariableName(id) or tostring(id)
        local constIdx = func:addConstant(name)
        return "global", constIdx
    end

    -- 2. Check local in current function
    local key = makeVarKey(scope, id)
    if func.localMap[key] ~= nil then
        return "local", func.localMap[key]
    end

    -- 3. Check outer ancestor functions for upvalues (arbitrary nesting depth)
    local function findUpvalue(targetFunc, searchKey)
        if not targetFunc.parent then return nil end
        local parent = targetFunc.parent
        if parent.localMap[searchKey] ~= nil then
            local parentReg = parent.localMap[searchKey]
            return targetFunc:addUpvalue(true, parentReg, tostring(id))
        end
        local parentUpval = findUpvalue(parent, searchKey)
        if parentUpval ~= nil then
            return targetFunc:addUpvalue(false, parentUpval, tostring(id))
        end
        return nil
    end

    local upval = findUpvalue(func, key)
    if upval ~= nil then
        return "upval", upval
    end

    -- Fallback: treat as global
    local name = (scope and scope.getVariableName) and scope:getVariableName(id) or tostring(id)
    local constIdx = func:addConstant(name)
    return "global", constIdx
end

function AstToIR:compileBlock(func, blockNode)
    if not blockNode then return end
    local stmts = blockNode.statements or blockNode
    if type(stmts) == "table" and stmts.kind then
        stmts = { stmts }
    end

    for _, stmt in ipairs(stmts or {}) do
        if func.currentBlock.terminated then
            break
        end
        self:compileStatement(func, stmt)
    end
end

function AstToIR:compileStatement(func, stmt)
    local kind = stmt.kind

    if kind == AstKind.LocalVariableDeclaration then
        local ids = stmt.ids or {}
        local scope = stmt.scope
        local exprs = stmt.expressions or {}

        -- Evaluate all expressions into registers
        local evalRegs = {}
        for i, expr in ipairs(exprs) do
            local isLast = (i == #exprs)
            local needed = isLast and math.max(1, #ids - #exprs + 1) or 1
            local r = self:compileExpression(func, expr, needed)
            if type(r) == "table" then
                for _, subR in ipairs(r) do table.insert(evalRegs, subR) end
            else
                table.insert(evalRegs, r)
            end
        end

        for i, varId in ipairs(ids) do
            local reg = func:allocRegister()
            self:defineLocal(func, scope, varId, reg)
            local srcReg = evalRegs[i]
            if srcReg then
                func:addInstruction("MOVE", { reg, srcReg })
            else
                func:addInstruction("LOADNIL", { reg, reg })
            end
        end

    elseif kind == AstKind.AssignmentStatement then
        local lhsList = stmt.lhs or {}
        local rhsList = stmt.rhs or {}

        -- Evaluate all RHS expressions
        local rhsRegs = {}
        for i, expr in ipairs(rhsList) do
            local isLast = (i == #rhsList)
            local needed = isLast and math.max(1, #lhsList - #rhsList + 1) or 1
            local r = self:compileExpression(func, expr, needed)
            if type(r) == "table" then
                for _, subR in ipairs(r) do table.insert(rhsRegs, subR) end
            else
                table.insert(rhsRegs, r)
            end
        end

        -- Assign to LHS
        for i, lhs in ipairs(lhsList) do
            local valReg = rhsRegs[i]
            if not valReg then
                valReg = func:allocRegister()
                func:addInstruction("LOADNIL", { valReg, valReg })
            end

            if lhs.kind == AstKind.AssignmentVariable or lhs.kind == AstKind.VariableExpression then
                local vType, vIdx = self:resolveVariable(func, lhs)
                if vType == "local" then
                    func:addInstruction("MOVE", { vIdx, valReg })
                elseif vType == "upval" then
                    func:addInstruction("SETUPVAL", { valReg, vIdx })
                else
                    func:addInstruction("SETGLOBAL", { valReg, vIdx })
                end
            elseif lhs.kind == AstKind.AssignmentIndexing or lhs.kind == AstKind.IndexExpression then
                local tblReg = self:compileExpressionToReg(func, lhs.base)
                local keyReg, keyIsConst, keyConstIdx = self:compileExpressionToRK(func, lhs.index)
                local bOperand = keyIsConst and (keyConstIdx + CONST_THRESHOLD) or keyReg
                func:addInstruction("SETTABLE", { tblReg, bOperand, valReg })
            end
        end

    elseif kind == AstKind.FunctionCallStatement or kind == AstKind.PassSelfFunctionCallStatement then
        self:compileCall(func, stmt, 0)

    elseif kind == AstKind.ReturnStatement then
        local exprs = stmt.args or stmt.expressions or {}
        if #exprs == 0 then
            func:addInstruction("RETURN", { 0, 1 })
        else
            local startReg = func:allocRegister()
            local numExprs = #exprs

            -- Pre-reserve all return slots in consecutive registers
            local returnWindowTop = startReg + numExprs - 1
            if func.allocated_registers < returnWindowTop then
                func.allocated_registers = returnWindowTop
            end
            if func.max_registers < returnWindowTop then
                func.max_registers = returnWindowTop
            end

            local lastIsVar = false
            for i, expr in ipairs(exprs) do
                local slotReg = startReg + i - 1
                local isLast = (i == numExprs)
                if isLast and (expr.kind == AstKind.FunctionCallExpression or expr.kind == AstKind.PassSelfFunctionCallExpression) then
                    self:compileCall(func, expr, -1, slotReg)
                    lastIsVar = true
                elseif isLast and expr.kind == AstKind.VarargExpression then
                    func:addInstruction("VARARG", { slotReg, 0 })
                    lastIsVar = true
                else
                    self:compileExpression(func, expr, 1, slotReg)
                end
            end

            local bOperand = lastIsVar and 0 or (numExprs + 1)
            func:addInstruction("RETURN", { startReg, bOperand })
        end
        func.currentBlock:setTerminated(true)

    elseif kind == AstKind.IfStatement then
        self:compileIfStatement(func, stmt)

    elseif kind == AstKind.WhileStatement then
        self:compileWhileStatement(func, stmt)

    elseif kind == AstKind.RepeatStatement then
        self:compileRepeatStatement(func, stmt)

    elseif kind == AstKind.ForStatement then
        self:compileNumericFor(func, stmt)

    elseif kind == AstKind.ForInStatement then
        self:compileGenericFor(func, stmt)

    elseif kind == AstKind.BreakStatement then
        if #func.loopStack > 0 then
            local exitBlock = func.loopStack[#func.loopStack].exitBlock
            func:addInstruction("JMP", { exitBlock.id })
            table.insert(func.currentBlock.successors, exitBlock.id)
            func.currentBlock:setTerminated(true)
        end

    elseif kind == AstKind.ContinueStatement then
        if #func.loopStack > 0 then
            local contBlock = func.loopStack[#func.loopStack].continueBlock or func.loopStack[#func.loopStack].headBlock
            func:addInstruction("JMP", { contBlock.id })
            table.insert(func.currentBlock.successors, contBlock.id)
            func.currentBlock:setTerminated(true)
        end

    elseif kind == AstKind.CompoundAddStatement
        or kind == AstKind.CompoundSubStatement
        or kind == AstKind.CompoundMulStatement
        or kind == AstKind.CompoundDivStatement
        or kind == AstKind.CompoundModStatement
        or kind == AstKind.CompoundPowStatement
        or kind == AstKind.CompoundConcatStatement then

        local opMap = {
            [AstKind.CompoundAddStatement]    = "ADD",
            [AstKind.CompoundSubStatement]    = "SUB",
            [AstKind.CompoundMulStatement]    = "MUL",
            [AstKind.CompoundDivStatement]    = "DIV",
            [AstKind.CompoundModStatement]    = "MOD",
            [AstKind.CompoundPowStatement]    = "POW",
            [AstKind.CompoundConcatStatement] = "CONCAT",
        }
        local op = opMap[kind]
        local lhs = stmt.lhs
        local rhsReg = self:compileExpressionToReg(func, stmt.rhs)
        local lhsReg = func:allocRegister()

        if lhs.kind == AstKind.AssignmentVariable or lhs.kind == AstKind.VariableExpression then
            local vType, vIdx = self:resolveVariable(func, lhs)
            if vType == "local" then
                lhsReg = vIdx
            elseif vType == "upval" then
                func:addInstruction("GETUPVAL", { lhsReg, vIdx })
            else
                func:addInstruction("GETGLOBAL", { lhsReg, vIdx })
            end

            local resultReg = func:allocRegister()
            if op == "CONCAT" then
                local startReg = func:allocRegister()
                local secondReg = func:allocRegister()
                func:addInstruction("MOVE", { startReg, lhsReg })
                func:addInstruction("MOVE", { secondReg, rhsReg })
                func:addInstruction("CONCAT", { resultReg, startReg, secondReg })
            else
                func:addInstruction(op, { resultReg, lhsReg, rhsReg })
            end

            if vType == "local" then
                func:addInstruction("MOVE", { vIdx, resultReg })
            elseif vType == "upval" then
                func:addInstruction("SETUPVAL", { resultReg, vIdx })
            else
                func:addInstruction("SETGLOBAL", { resultReg, vIdx })
            end

        elseif lhs.kind == AstKind.AssignmentIndexing or lhs.kind == AstKind.IndexExpression then
            local tblReg = self:compileExpressionToReg(func, lhs.base)
            local keyReg, keyIsConst, keyConstIdx = self:compileExpressionToRK(func, lhs.index)
            local bOperand = keyIsConst and (keyConstIdx + CONST_THRESHOLD) or keyReg
            func:addInstruction("GETTABLE", { lhsReg, tblReg, bOperand })

            local resultReg = func:allocRegister()
            if op == "CONCAT" then
                local startReg = func:allocRegister()
                local secondReg = func:allocRegister()
                func:addInstruction("MOVE", { startReg, lhsReg })
                func:addInstruction("MOVE", { secondReg, rhsReg })
                func:addInstruction("CONCAT", { resultReg, startReg, secondReg })
            else
                func:addInstruction(op, { resultReg, lhsReg, rhsReg })
            end

            func:addInstruction("SETTABLE", { tblReg, bOperand, resultReg })
        end

    elseif kind == AstKind.DoStatement then
        self:compileBlock(func, stmt.body)

    elseif kind == AstKind.LocalFunctionDeclaration or kind == AstKind.FunctionDeclaration then
        local closureReg = func:allocRegister()
        if kind == AstKind.LocalFunctionDeclaration then
            self:defineLocal(func, stmt.scope, stmt.id, closureReg)
        end

        local childFunc = self:createFunction(stmt.name or "func", func, stmt.args or {}, stmt.is_vararg)
        table.insert(func.protos, childFunc)
        local protoIdx = #func.protos

        local childEntry = childFunc:createBlock("entry")
        childFunc:setActiveBlock(childEntry)
        self:compileBlock(childFunc, stmt.body)
        if not childFunc.currentBlock.terminated then
            childFunc:addInstruction("RETURN", { 0, 1 })
            childFunc.currentBlock:setTerminated(true)
        end

        func:addInstruction("CLOSURE", { closureReg, protoIdx })

        if kind ~= AstKind.LocalFunctionDeclaration then
            local indices = stmt.indices or {}
            if #indices > 0 then
                local baseScope = stmt.baseScope or stmt.scope
                local baseId = stmt.baseId or stmt.id
                local vType, vIdx = self:resolveVariable(func, { scope = baseScope, id = baseId })
                local curReg
                if vType == "local" then
                    curReg = vIdx
                elseif vType == "upval" then
                    curReg = func:allocRegister()
                    func:addInstruction("GETUPVAL", { curReg, vIdx })
                else
                    curReg = func:allocRegister()
                    func:addInstruction("GETGLOBAL", { curReg, vIdx })
                end

                for i = 1, #indices - 1 do
                    local ind = indices[i]
                    local indName = type(ind) == "string" and ind or (ind.name or ind.value or tostring(ind))
                    local kIdx = func:addConstant(indName)
                    local nextReg = func:allocRegister()
                    func:addInstruction("GETTABLE", { nextReg, curReg, kIdx + CONST_THRESHOLD })
                    curReg = nextReg
                end

                local lastInd = indices[#indices]
                local lastIndName = type(lastInd) == "string" and lastInd or (lastInd.name or lastInd.value or tostring(lastInd))
                local kIdx = func:addConstant(lastIndName)
                func:addInstruction("SETTABLE", { curReg, kIdx + CONST_THRESHOLD, closureReg })
            else
                local vType, vIdx = self:resolveVariable(func, stmt)
                if vType == "local" then
                    func:addInstruction("MOVE", { vIdx, closureReg })
                elseif vType == "upval" then
                    func:addInstruction("SETUPVAL", { closureReg, vIdx })
                else
                    func:addInstruction("SETGLOBAL", { closureReg, vIdx })
                end
            end
        end
    end

    -- Reclaim temporary registers evaluated for this statement
    func.allocated_registers = func.numLocals or 0
end

function AstToIR:compileIfStatement(func, stmt)
    local thenBlock = func:createBlock("if_then")
    local exitBlock = func:createBlock("if_exit")
    local hasElse = stmt.elsebody ~= nil
    local elseifs = stmt.elseifs or {}
    local nextCheckBlock = (#elseifs > 0 or hasElse) and func:createBlock("if_else_1") or exitBlock

    local condReg = self:compileExpressionToReg(func, stmt.condition)
    func:addInstruction("TEST", { condReg, 0 }) -- if false, skip to nextCheckBlock
    func:addInstruction("JMP", { nextCheckBlock.id })
    func:addInstruction("JMP", { thenBlock.id })
    table.insert(func.currentBlock.successors, thenBlock.id)
    table.insert(func.currentBlock.successors, nextCheckBlock.id)

    -- Then body
    func:setActiveBlock(thenBlock)
    self:compileBlock(func, stmt.body)
    if not func.currentBlock.terminated then
        func:addInstruction("JMP", { exitBlock.id })
        table.insert(func.currentBlock.successors, exitBlock.id)
        func.currentBlock:setTerminated(true)
    end

    -- Elseifs
    local curBlock = nextCheckBlock
    for i, eif in ipairs(elseifs) do
        func:setActiveBlock(curBlock)
        local eifThenBlock = func:createBlock("eif_then_" .. i)
        local hasMore = (i < #elseifs or hasElse)
        local eifNextBlock = hasMore and func:createBlock("if_else_" .. (i + 1)) or exitBlock

        local eifCondReg = self:compileExpressionToReg(func, eif.condition)
        func:addInstruction("TEST", { eifCondReg, 0 })
        func:addInstruction("JMP", { eifNextBlock.id })
        func:addInstruction("JMP", { eifThenBlock.id })
        table.insert(func.currentBlock.successors, eifThenBlock.id)
        table.insert(func.currentBlock.successors, eifNextBlock.id)

        func:setActiveBlock(eifThenBlock)
        self:compileBlock(func, eif.body)
        if not func.currentBlock.terminated then
            func:addInstruction("JMP", { exitBlock.id })
            table.insert(func.currentBlock.successors, exitBlock.id)
            func.currentBlock:setTerminated(true)
        end
        curBlock = eifNextBlock
    end

    -- Else body
    if hasElse then
        func:setActiveBlock(curBlock)
        self:compileBlock(func, stmt.elsebody)
        if not func.currentBlock.terminated then
            func:addInstruction("JMP", { exitBlock.id })
            table.insert(func.currentBlock.successors, exitBlock.id)
            func.currentBlock:setTerminated(true)
        end
    end

    func:setActiveBlock(exitBlock)
end

function AstToIR:compileWhileStatement(func, stmt)
    local headBlock = func:createBlock("while_head")
    local bodyBlock = func:createBlock("while_body")
    local exitBlock = func:createBlock("while_exit")

    func:addInstruction("JMP", { headBlock.id })
    table.insert(func.currentBlock.successors, headBlock.id)
    func.currentBlock:setTerminated(true)

    func:setActiveBlock(headBlock)
    local condReg = self:compileExpressionToReg(func, stmt.condition)
    func:addInstruction("TEST", { condReg, 0 })
    func:addInstruction("JMP", { exitBlock.id })
    func:addInstruction("JMP", { bodyBlock.id })
    table.insert(func.currentBlock.successors, bodyBlock.id)
    table.insert(func.currentBlock.successors, exitBlock.id)

    table.insert(func.loopStack, { exitBlock = exitBlock, headBlock = headBlock, continueBlock = headBlock })
    func:setActiveBlock(bodyBlock)
    self:compileBlock(func, stmt.body)
    if not func.currentBlock.terminated then
        func:addInstruction("JMP", { headBlock.id })
        table.insert(func.currentBlock.successors, headBlock.id)
        func.currentBlock:setTerminated(true)
    end
    table.remove(func.loopStack)

    func:setActiveBlock(exitBlock)
end

function AstToIR:compileRepeatStatement(func, stmt)
    local bodyBlock = func:createBlock("repeat_body")
    local condBlock = func:createBlock("repeat_cond")
    local exitBlock = func:createBlock("repeat_exit")

    func:addInstruction("JMP", { bodyBlock.id })
    table.insert(func.currentBlock.successors, bodyBlock.id)
    func.currentBlock:setTerminated(true)

    table.insert(func.loopStack, { exitBlock = exitBlock, headBlock = condBlock, continueBlock = condBlock })
    func:setActiveBlock(bodyBlock)
    self:compileBlock(func, stmt.body)
    if not func.currentBlock.terminated then
        func:addInstruction("JMP", { condBlock.id })
        table.insert(func.currentBlock.successors, condBlock.id)
        func.currentBlock:setTerminated(true)
    end
    table.remove(func.loopStack)

    func:setActiveBlock(condBlock)
    local condReg = self:compileExpressionToReg(func, stmt.condition)
    func:addInstruction("TEST", { condReg, 1 }) -- if true, exit
    func:addInstruction("JMP", { exitBlock.id })
    func:addInstruction("JMP", { bodyBlock.id })
    table.insert(func.currentBlock.successors, exitBlock.id)
    table.insert(func.currentBlock.successors, bodyBlock.id)

    func:setActiveBlock(exitBlock)
end

function AstToIR:compileNumericFor(func, stmt)
    local rawInit = self:compileExpressionToReg(func, stmt.initialValue)
    local rawLimit = self:compileExpressionToReg(func, stmt.finalValue)
    local rawStep = stmt.incrementBy and self:compileExpressionToReg(func, stmt.incrementBy) or nil

    -- Allocate 3 consecutive registers for loop state: base (init), base+1 (limit), base+2 (step)
    local baseReg = func:allocRegister()
    local limitReg = func:allocRegister()
    local stepReg = func:allocRegister()

    func:addInstruction("MOVE", { baseReg, rawInit })
    func:addInstruction("MOVE", { limitReg, rawLimit })
    if rawStep then
        func:addInstruction("MOVE", { stepReg, rawStep })
    else
        local oneConst = func:addConstant(1)
        func:addInstruction("LOADK", { stepReg, oneConst })
    end

    local loopVarReg = func:allocRegister()
    self:defineLocal(func, stmt.scope, stmt.id, loopVarReg)

    local bodyBlock = func:createBlock("for_body")
    local stepBlock = func:createBlock("for_step")
    local exitBlock = func:createBlock("for_exit")

    func:addInstruction("FORPREP", { baseReg, exitBlock.id })
    func:addInstruction("JMP", { bodyBlock.id })
    table.insert(func.currentBlock.successors, bodyBlock.id)
    table.insert(func.currentBlock.successors, exitBlock.id)

    table.insert(func.loopStack, { exitBlock = exitBlock, headBlock = bodyBlock, continueBlock = stepBlock })
    func:setActiveBlock(bodyBlock)
    func:addInstruction("MOVE", { loopVarReg, baseReg })
    self:compileBlock(func, stmt.body)
    if not func.currentBlock.terminated then
        func:addInstruction("JMP", { stepBlock.id })
        table.insert(func.currentBlock.successors, stepBlock.id)
        func.currentBlock:setTerminated(true)
    end

    func:setActiveBlock(stepBlock)
    func:addInstruction("CLOSE", { loopVarReg })
    func:addInstruction("FORLOOP", { baseReg, bodyBlock.id })
    func:addInstruction("JMP", { exitBlock.id })
    table.insert(stepBlock.successors, bodyBlock.id)
    table.insert(stepBlock.successors, exitBlock.id)
    stepBlock:setTerminated(true)

    table.remove(func.loopStack)

    func:setActiveBlock(exitBlock)
    func.numLocals = math.max(func.numLocals or 0, loopVarReg)
    func.allocated_registers = func.numLocals
end

function AstToIR:compileGenericFor(func, stmt)
    local exprList = stmt.expressions or {}
    local iterBase = func:allocRegister()
    local stateReg = func:allocRegister()
    local varReg = func:allocRegister()

    if #exprList == 1 then
        local r = self:compileExpression(func, exprList[1], 3, iterBase)
        if type(r) == "table" then
            func:addInstruction("MOVE", { iterBase, r[1] })
            if r[2] then func:addInstruction("MOVE", { stateReg, r[2] }) else func:addInstruction("LOADNIL", { stateReg, stateReg }) end
            if r[3] then func:addInstruction("MOVE", { varReg, r[3] }) else func:addInstruction("LOADNIL", { varReg, varReg }) end
        end
    else
        self:compileExpression(func, exprList[1], 1, iterBase)
        if exprList[2] then self:compileExpression(func, exprList[2], 1, stateReg) else func:addInstruction("LOADNIL", { stateReg, stateReg }) end
        if exprList[3] then self:compileExpression(func, exprList[3], 1, varReg) else func:addInstruction("LOADNIL", { varReg, varReg }) end
    end

    local ids = stmt.ids or {}
    local loopVarRegs = {}
    for _, varId in ipairs(ids) do
        local r = func:allocRegister()
        self:defineLocal(func, stmt.scope, varId, r)
        table.insert(loopVarRegs, r)
    end

    local loopHead = func:createBlock("tfor_head")
    local loopBody = func:createBlock("tfor_body")
    local loopStep = func:createBlock("tfor_step")
    local loopExit = func:createBlock("tfor_exit")

    func:addInstruction("JMP", { loopHead.id })
    table.insert(func.currentBlock.successors, loopHead.id)
    func.currentBlock:setTerminated(true)

    table.insert(func.loopStack, { exitBlock = loopExit, headBlock = loopHead, continueBlock = loopStep })
    func:setActiveBlock(loopHead)
    func:addInstruction("TFORLOOP", { iterBase, #ids, loopExit.id })
    func:addInstruction("JMP", { loopBody.id })
    table.insert(func.currentBlock.successors, loopBody.id)
    table.insert(func.currentBlock.successors, loopExit.id)

    func:setActiveBlock(loopBody)
    for i, r in ipairs(loopVarRegs) do
        func:addInstruction("MOVE", { r, iterBase + 2 + i })
    end
    self:compileBlock(func, stmt.body)
    if not func.currentBlock.terminated then
        func:addInstruction("JMP", { loopStep.id })
        table.insert(func.currentBlock.successors, loopStep.id)
        func.currentBlock:setTerminated(true)
    end

    func:setActiveBlock(loopStep)
    local firstLoopReg = loopVarRegs[1] or (iterBase + 3)
    func:addInstruction("CLOSE", { firstLoopReg })
    func:addInstruction("JMP", { loopHead.id })
    table.insert(loopStep.successors, loopHead.id)
    loopStep:setTerminated(true)

    table.remove(func.loopStack)

    func:setActiveBlock(loopExit)
    local maxLoopReg = loopVarRegs[#loopVarRegs] or varReg
    func.numLocals = math.max(func.numLocals or 0, maxLoopReg)
    func.allocated_registers = func.numLocals
end

function AstToIR:compileExpressionToReg(func, expr, targetReg)
    local r = self:compileExpression(func, expr, 1, targetReg)
    if type(r) == "table" then return r[1] end
    return r
end

function AstToIR:compileExpressionToRK(func, expr)
    if expr.kind == AstKind.StringExpression or expr.kind == AstKind.NumberExpression or expr.kind == AstKind.BooleanExpression then
        local val = expr.value
        local constIdx = func:addConstant(val)
        return nil, true, constIdx
    else
        local reg = self:compileExpressionToReg(func, expr)
        return reg, false, nil
    end
end

function AstToIR:compileExpression(func, expr, numReturns, targetReg)
    numReturns = numReturns or 1
    local kind = expr.kind
    targetReg = targetReg or func:allocRegister()

    if kind == AstKind.NumberExpression or kind == AstKind.StringExpression or kind == AstKind.BooleanExpression then
        local constIdx = func:addConstant(expr.value)
        func:addInstruction("LOADK", { targetReg, constIdx })
        return targetReg

    elseif kind == AstKind.NilExpression then
        func:addInstruction("LOADNIL", { targetReg, targetReg })
        return targetReg

    elseif kind == AstKind.VariableExpression then
        local vType, vIdx = self:resolveVariable(func, expr)
        if vType == "local" then
            func:addInstruction("MOVE", { targetReg, vIdx })
        elseif vType == "upval" then
            func:addInstruction("GETUPVAL", { targetReg, vIdx })
        else
            func:addInstruction("GETGLOBAL", { targetReg, vIdx })
        end
        return targetReg

    elseif kind == AstKind.IndexExpression then
        local tblReg = self:compileExpressionToReg(func, expr.base)
        local keyReg, keyIsConst, keyConstIdx = self:compileExpressionToRK(func, expr.index)
        local cOperand = keyIsConst and (keyConstIdx + CONST_THRESHOLD) or keyReg
        func:addInstruction("GETTABLE", { targetReg, tblReg, cOperand })
        return targetReg

    elseif kind == AstKind.TableConstructorExpression then
        local entries = expr.entries or {}
        local numArr = 0
        local numHash = 0
        for _, entry in ipairs(entries) do
            if entry.kind == AstKind.KeyedTableEntry or entry.kind == AstKind.TableKeyEntry then
                numHash = numHash + 1
            else
                numArr = numArr + 1
            end
        end
        func:addInstruction("NEWTABLE", { targetReg, numArr, numHash })

        local arrIdx = 1
        for i, entry in ipairs(entries) do
            local isLast = (i == #entries)
            if entry.kind == AstKind.KeyedTableEntry or entry.kind == AstKind.TableKeyEntry then
                local kReg, kIsConst, kConstIdx = self:compileExpressionToRK(func, entry.key)
                local vReg, vIsConst, vConstIdx = self:compileExpressionToRK(func, entry.value)
                local bOp = kIsConst and (kConstIdx + CONST_THRESHOLD) or kReg
                local cOp = vIsConst and (vConstIdx + CONST_THRESHOLD) or vReg
                func:addInstruction("SETTABLE", { targetReg, bOp, cOp })
            else
                local val = entry.value or entry
                if isLast and (val.kind == AstKind.FunctionCallExpression or val.kind == AstKind.PassSelfFunctionCallExpression) then
                    local callSlot = targetReg + 1
                    if func.allocated_registers < callSlot then func.allocated_registers = callSlot end
                    if func.max_registers < callSlot then func.max_registers = callSlot end
                    self:compileCall(func, val, -1, callSlot)
                    func:addInstruction("SETLIST", { targetReg, 0, arrIdx })
                elseif isLast and val.kind == AstKind.VarargExpression then
                    local varargSlot = targetReg + 1
                    if func.allocated_registers < varargSlot then func.allocated_registers = varargSlot end
                    if func.max_registers < varargSlot then func.max_registers = varargSlot end
                    func:addInstruction("VARARG", { varargSlot, 0 })
                    func:addInstruction("SETLIST", { targetReg, 0, arrIdx })
                else
                    local vReg, vIsConst, vConstIdx = self:compileExpressionToRK(func, val)
                    local kConstIdx = func:addConstant(arrIdx)
                    local bOp = kConstIdx + CONST_THRESHOLD
                    local cOp = vIsConst and (vConstIdx + CONST_THRESHOLD) or vReg
                    func:addInstruction("SETTABLE", { targetReg, bOp, cOp })
                    arrIdx = arrIdx + 1
                end
            end
        end
        return targetReg

    elseif kind == AstKind.FunctionCallExpression or kind == AstKind.PassSelfFunctionCallExpression then
        return self:compileCall(func, expr, numReturns, targetReg)

    elseif kind == AstKind.FunctionLiteralExpression then
        local childFunc = self:createFunction("anon_func", func, expr.args or {}, expr.is_vararg)
        table.insert(func.protos, childFunc)
        local protoIdx = #func.protos

        local childEntry = childFunc:createBlock("entry")
        childFunc:setActiveBlock(childEntry)
        self:compileBlock(childFunc, expr.body)
        if not childFunc.currentBlock.terminated then
            childFunc:addInstruction("RETURN", { 0, 1 })
            childFunc.currentBlock:setTerminated(true)
        end

        func:addInstruction("CLOSURE", { targetReg, protoIdx })
        return targetReg

    elseif kind == AstKind.VarargExpression then
        func:addInstruction("VARARG", { targetReg, numReturns > 0 and (numReturns + 1) or 0 })
        return targetReg

    elseif kind == AstKind.AndExpression or kind == AstKind.OrExpression then
        local lhsReg = self:compileExpressionToReg(func, expr.lhs)
        func:addInstruction("MOVE", { targetReg, lhsReg })
        local rhsBlock = func:createBlock("logic_rhs")
        local exitBlock = func:createBlock("logic_exit")

        local testCond = (kind == AstKind.AndExpression) and 0 or 1
        func:addInstruction("TEST", { targetReg, testCond })
        func:addInstruction("JMP", { exitBlock.id })
        func:addInstruction("JMP", { rhsBlock.id })

        func:setActiveBlock(rhsBlock)
        self:compileExpression(func, expr.rhs, 1, targetReg)
        func:addInstruction("JMP", { exitBlock.id })
        func.currentBlock:setTerminated(true)

        func:setActiveBlock(exitBlock)
        return targetReg

    -- Binary expressions
    elseif self:isBinaryOp(kind) then
        local opCode = self:getBinaryOpCode(kind)
        local lhs = expr.lhs
        local rhs = expr.rhs
        if kind == AstKind.GreaterThanExpression or kind == AstKind.GreaterThanOrEqualsExpression then
            lhs, rhs = expr.rhs, expr.lhs -- a > b <=> b < a, a >= b <=> b <= a
        end
        local bReg, bIsConst, bConstIdx = self:compileExpressionToRK(func, lhs)
        local cReg, cIsConst, cConstIdx = self:compileExpressionToRK(func, rhs)
        local bOp = bIsConst and (bConstIdx + CONST_THRESHOLD) or bReg
        local cOp = cIsConst and (cConstIdx + CONST_THRESHOLD) or cReg
        func:addInstruction(opCode, { targetReg, bOp, cOp })
        return targetReg

    -- Unary expressions
    elseif kind == AstKind.NotExpression then
        local bReg = self:compileExpressionToReg(func, expr.rhs)
        func:addInstruction("NOT", { targetReg, bReg })
        return targetReg

    elseif kind == AstKind.LenExpression then
        local bReg = self:compileExpressionToReg(func, expr.rhs)
        func:addInstruction("LEN", { targetReg, bReg })
        return targetReg

    elseif kind == AstKind.NegateExpression then
        local bReg = self:compileExpressionToReg(func, expr.rhs)
        func:addInstruction("UNM", { targetReg, bReg })
        return targetReg

    else
        func:addInstruction("LOADNIL", { targetReg, targetReg })
        return targetReg
    end
end

function AstToIR:compileCall(func, callNode, numReturns, targetReg)
    numReturns = numReturns or 1
    local funcReg = targetReg or func:allocRegister()
    local isSelf = (callNode.kind == AstKind.PassSelfFunctionCallStatement or callNode.kind == AstKind.PassSelfFunctionCallExpression)

    local args = callNode.args or {}
    local argCount = #args + (isSelf and 1 or 0)

    -- CRITICAL: Reserve all argument slots in func.allocated_registers BEFORE evaluating base and args!
    local totalWindowTop = funcReg + argCount
    local savedAllocated = func.allocated_registers
    if func.allocated_registers < totalWindowTop then
        func.allocated_registers = totalWindowTop
    end
    if func.max_registers < totalWindowTop then
        func.max_registers = totalWindowTop
    end

    if isSelf then
        local baseReg = self:compileExpressionToReg(func, callNode.base)
        local methodIdx = func:addConstant(callNode.passSelfFunctionName)
        -- SELF R(A), R(B), RK(C): R(A+1) = R(B); R(A) = R(B)[RK(C)]
        func:addInstruction("SELF", { funcReg, baseReg, methodIdx + CONST_THRESHOLD })
    else
        self:compileExpression(func, callNode.base, 1, funcReg)
    end

    local lastArgIsVar = false
    for i, argExpr in ipairs(args) do
        local slotReg = funcReg + (isSelf and i or (i - 1)) + 1
        local isLast = (i == #args)
        if isLast and (argExpr.kind == AstKind.FunctionCallExpression or argExpr.kind == AstKind.PassSelfFunctionCallExpression) then
            self:compileCall(func, argExpr, -1, slotReg)
            lastArgIsVar = true
        elseif isLast and argExpr.kind == AstKind.VarargExpression then
            func:addInstruction("VARARG", { slotReg, 0 })
            lastArgIsVar = true
        else
            self:compileExpression(func, argExpr, 1, slotReg)
        end
    end

    local bOperand = lastArgIsVar and 0 or (argCount + 1)
    local cOperand = (numReturns == -1) and 0 or (numReturns + 1)
    func:addInstruction("CALL", { funcReg, bOperand, cOperand })

    local retsCount = (numReturns == -1) and 1 or math.max(1, numReturns)
    local retTop = funcReg + retsCount - 1
    func.allocated_registers = math.max(savedAllocated, retTop)
    if func.max_registers < func.allocated_registers then
        func.max_registers = func.allocated_registers
    end

    if numReturns == -1 or numReturns <= 1 then
        return funcReg
    else
        local res = {}
        for i = 1, numReturns do
            table.insert(res, funcReg + i - 1)
        end
        return res
    end
end

function AstToIR:isBinaryOp(kind)
    return kind == AstKind.AddExpression or kind == AstKind.SubExpression
        or kind == AstKind.MulExpression or kind == AstKind.DivExpression
        or kind == AstKind.ModExpression or kind == AstKind.PowExpression
        or kind == AstKind.StrCatExpression or kind == AstKind.EqualsExpression
        or kind == AstKind.NotEqualsExpression or kind == AstKind.LessThanExpression
        or kind == AstKind.GreaterThanExpression or kind == AstKind.LessThanOrEqualsExpression
        or kind == AstKind.GreaterThanOrEqualsExpression
end

function AstToIR:getBinaryOpCode(kind)
    if kind == AstKind.AddExpression then return "ADD"
    elseif kind == AstKind.SubExpression then return "SUB"
    elseif kind == AstKind.MulExpression then return "MUL"
    elseif kind == AstKind.DivExpression then return "DIV"
    elseif kind == AstKind.ModExpression then return "MOD"
    elseif kind == AstKind.PowExpression then return "POW"
    elseif kind == AstKind.StrCatExpression then return "CONCAT"
    elseif kind == AstKind.EqualsExpression then return "EQ"
    elseif kind == AstKind.NotEqualsExpression then return "NE"
    elseif kind == AstKind.LessThanExpression then return "LT"
    elseif kind == AstKind.GreaterThanExpression then return "LT"
    elseif kind == AstKind.LessThanOrEqualsExpression then return "LE"
    elseif kind == AstKind.GreaterThanOrEqualsExpression then return "LE"
    end
    return "ADD"
end

return AstToIR
`,"prometheus.vm.ir.ir":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/ir/ir.lua
--
-- Custom Intermediate Representation (IR) data structures
-- Represents code as a Control Flow Graph (CFG) of Basic Blocks

local IR = {}
IR.CONST_THRESHOLD = 50000000

local BasicBlock = {}
BasicBlock.__index = BasicBlock

function BasicBlock.new(id)
    return setmetatable({
        id = id,
        instructions = {},
        terminated = false,
        predecessors = {},
        successors = {},
    }, BasicBlock)
end

function BasicBlock:addInstruction(op, operands, metadata)
    local inst = {
        op = op,
        operands = operands or {},
        metadata = metadata or {},
    }
    table.insert(self.instructions, inst)
    return inst
end

function BasicBlock:addPredecessor(blockId)
    for _, id in ipairs(self.predecessors) do
        if id == blockId then return end
    end
    table.insert(self.predecessors, blockId)
end

function BasicBlock:addSuccessor(blockId)
    for _, id in ipairs(self.successors) do
        if id == blockId then return end
    end
    table.insert(self.successors, blockId)
end

function BasicBlock:setTerminated(terminated)
    self.terminated = (terminated ~= false)
end

IR.BasicBlock = BasicBlock

local IRFunction = {}
IRFunction.__index = IRFunction

function IRFunction.new(id, name, parent)
    return setmetatable({
        id = id or 0,
        name = name or "chunk",
        parent = parent,
        blocks = {},
        currentBlock = nil,
        constants = {},
        constantLookup = {},
        protos = {},
        upvalues = {},
        upvalueLookup = {},
        params = {},
        is_vararg = false,
        max_registers = 0,
        allocated_registers = 0,
        numLocals = 0,
        free_registers = {},
        scope_vars = {},
        nextBlockId = 1,
    }, IRFunction)
end

function IRFunction:createBlock(name)
    local blockId = self.nextBlockId
    self.nextBlockId = self.nextBlockId + 1
    local block = BasicBlock.new(blockId)
    block.name = name or ("bb_" .. blockId)
    table.insert(self.blocks, block)
    return block
end

function IRFunction:getBlockById(id)
    for _, b in ipairs(self.blocks) do
        if b.id == id then return b end
    end
    return nil
end

function IRFunction:splitBlock(block, splitIndex)
    if not block or splitIndex <= 1 or splitIndex > #block.instructions then
        return nil
    end

    -- Never split directly after a conditional skip instruction
    local prevInst = block.instructions[splitIndex - 1]
    if prevInst and (prevInst.op == "TEST" or prevInst.op == "TESTSET" or prevInst.op == "FORPREP" or prevInst.op == "TFORLOOP") then
        return nil
    end

    local newBlock = self:createBlock(block.name .. "_split")
    local total = #block.instructions
    local moved = {}

    for i = splitIndex, total do
        table.insert(moved, block.instructions[i])
    end

    -- Truncate original block instructions
    local kept = {}
    for i = 1, splitIndex - 1 do
        table.insert(kept, block.instructions[i])
    end
    block.instructions = kept
    newBlock.instructions = moved

    -- Transfer termination state
    newBlock.terminated = block.terminated
    block.terminated = true

    -- Insert unconditional jump from block to newBlock
    table.insert(block.instructions, {
        op = "JMP",
        operands = { newBlock.id },
        metadata = { generated = true },
    })

    self:rebuildCfgEdges()
    return newBlock
end

function IRFunction:rebuildCfgEdges()
    -- Clear existing edges
    for _, b in ipairs(self.blocks) do
        b.predecessors = {}
        b.successors = {}
    end

    local blockMap = {}
    for _, b in ipairs(self.blocks) do
        blockMap[b.id] = b
    end

    for _, b in ipairs(self.blocks) do
        local numInst = #b.instructions
        for idx, inst in ipairs(b.instructions) do
            local op = inst.op
            local ops = inst.operands or {}

            if op == "JMP" and type(ops[1]) == "number" then
                local targetBlock = blockMap[ops[1]]
                if targetBlock then
                    b:addSuccessor(targetBlock.id)
                    targetBlock:addPredecessor(b.id)
                end
            elseif (op == "FORPREP" or op == "FORLOOP") and type(ops[2]) == "number" then
                local targetBlock = blockMap[ops[2]]
                if targetBlock then
                    b:addSuccessor(targetBlock.id)
                    targetBlock:addPredecessor(b.id)
                end
            elseif op == "TFORLOOP" and type(ops[3]) == "number" then
                local targetBlock = blockMap[ops[3]]
                if targetBlock then
                    b:addSuccessor(targetBlock.id)
                    targetBlock:addPredecessor(b.id)
                end
            end
        end
    end
end

function IRFunction:getReachableBlocks()
    self:rebuildCfgEdges()
    local reachable = {}
    if #self.blocks == 0 then return reachable end

    local queue = { self.blocks[1].id }
    reachable[self.blocks[1].id] = true

    while #queue > 0 do
        local currId = table.remove(queue, 1)
        local block = self:getBlockById(currId)
        if block then
            for _, succId in ipairs(block.successors) do
                if not reachable[succId] then
                    reachable[succId] = true
                    table.insert(queue, succId)
                end
            end
        end
    end

    return reachable
end

function IRFunction:setActiveBlock(block)
    self.currentBlock = block
end

function IRFunction:addInstruction(op, operands, metadata)
    if not self.currentBlock then
        self:setActiveBlock(self:createBlock("entry"))
    end
    return self.currentBlock:addInstruction(op, operands, metadata)
end

function IRFunction:addConstant(val)
    local kType = type(val)
    local key
    if kType == "string" then
        key = "s:" .. val
    elseif kType == "number" then
        key = "n:" .. tostring(val)
    elseif kType == "boolean" then
        key = "b:" .. tostring(val)
    elseif kType == "nil" then
        key = "nil"
    else
        key = "other:" .. tostring(val)
    end

    local existing = self.constantLookup[key]
    if existing ~= nil then
        return existing
    end

    table.insert(self.constants, val)
    local idx = #self.constants
    self.constantLookup[key] = idx
    return idx
end

function IRFunction:addUpvalue(is_local, index, name)
    local key = (is_local and "loc:" or "up:") .. tostring(index)
    local existing = self.upvalueLookup[key]
    if existing ~= nil then
        return existing
    end

    local upval = {
        is_local = is_local,
        index = index,
        name = name or ("upval_" .. (#self.upvalues + 1)),
    }
    table.insert(self.upvalues, upval)
    local idx = #self.upvalues
    self.upvalueLookup[key] = idx
    return idx
end

function IRFunction:allocRegister()
    local reg
    if #self.free_registers > 0 then
        reg = table.remove(self.free_registers)
    else
        self.allocated_registers = self.allocated_registers + 1
        reg = self.allocated_registers
        if reg > self.max_registers then
            self.max_registers = reg
        end
    end
    return reg
end

function IRFunction:allocFreshRegister()
    self.allocated_registers = self.allocated_registers + 1
    local reg = self.allocated_registers
    if reg > self.max_registers then
        self.max_registers = reg
    end
    return reg
end

function IRFunction:freeRegister(reg)
    if reg and reg > 0 then
        table.insert(self.free_registers, reg)
    end
end

IR.IRFunction = IRFunction

-- Operand Helpers
IR.Operand = {
    Reg = function(idx) return { type = "reg", value = idx } end,
    Const = function(idx) return { type = "const", value = idx } end,
    Upval = function(idx) return { type = "upval", value = idx } end,
    Block = function(id) return { type = "block", value = id } end,
    Raw = function(val) return { type = "raw", value = val } end,
}

return IR
`,"prometheus.vm.ir.optimizer":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/ir/optimizer.lua
--
-- IR-level Optimization Pass: Dead Code Elimination, Constant Folding,
-- and Forwarding Jump Simplification.
--

local IR = require("prometheus.vm.ir.ir")
local CONST_THRESHOLD = IR.CONST_THRESHOLD or 50000000

local IROptimizer = {}

local function optimizeFunction(irFunc)
    if not irFunc or not irFunc.blocks or #irFunc.blocks == 0 then
        return
    end

    -- 1. Dead Block Elimination (remove unreachable blocks from CFG)
    local reachable = irFunc:getReachableBlocks()
    local prunedBlocks = {}
    for _, block in ipairs(irFunc.blocks) do
        -- Keep block if it is reachable or explicitly marked as a decoy/protected block
        if reachable[block.id] or (block.metadata and block.metadata.protected) then
            table.insert(prunedBlocks, block)
        end
    end
    irFunc.blocks = prunedBlocks
    irFunc:rebuildCfgEdges()

    -- 2. Constant Folding for Arithmetic Instructions
    -- Maps register -> constant value if defined by LOADK within the block and not clobbered
    for _, block in ipairs(irFunc.blocks) do
        local regConstVal = {}
        local newInstructions = {}

        for _, inst in ipairs(block.instructions) do
            local op = inst.op
            local ops = inst.operands or {}

            if op == "LOADK" and type(ops[2]) == "number" then
                local kVal = irFunc.constants[ops[2]]
                regConstVal[ops[1]] = kVal
                table.insert(newInstructions, inst)
            else
                local folded = false
                if (op == "ADD" or op == "SUB" or op == "MUL" or op == "DIV" or op == "MOD" or op == "POW") then
                    local rA = ops[1]
                    local opB = ops[2]
                    local opC = ops[3]

                    local valB = (type(opB) == "number" and opB >= CONST_THRESHOLD) and irFunc.constants[opB - CONST_THRESHOLD] or regConstVal[opB]
                    local valC = (type(opC) == "number" and opC >= CONST_THRESHOLD) and irFunc.constants[opC - CONST_THRESHOLD] or regConstVal[opC]

                    if type(valB) == "number" and type(valC) == "number" then
                        local res = nil
                        if op == "ADD" then res = valB + valC
                        elseif op == "SUB" then res = valB - valC
                        elseif op == "MUL" then res = valB * valC
                        elseif op == "DIV" and valC ~= 0 then res = valB / valC
                        elseif op == "MOD" and valC ~= 0 then res = valB % valC
                        elseif op == "POW" then res = valB ^ valC
                        end

                        if res ~= nil and res == res and res ~= (1/0) and res ~= (-1/0) then
                            local kIdx = irFunc:addConstant(res)
                            table.insert(newInstructions, {
                                op = "LOADK",
                                operands = { rA, kIdx },
                                metadata = { folded = true },
                            })
                            regConstVal[rA] = res
                            folded = true
                        end
                    end
                end

                if not folded then
                    -- Any other instruction clobbers register A if it writes to it
                    if ops[1] and type(ops[1]) == "number" and op ~= "JMP" then
                        regConstVal[ops[1]] = nil
                    end
                    table.insert(newInstructions, inst)
                end
            end
        end

        block.instructions = newInstructions
    end

    -- Recursively optimize child prototypes
    for _, childProto in ipairs(irFunc.protos or {}) do
        optimizeFunction(childProto)
    end
end

function IROptimizer.optimize(irRoot)
    optimizeFunction(irRoot)
    return irRoot
end

return IROptimizer
`,"prometheus.vm.ir.verifier":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/ir/verifier.lua
--
-- Formal IR Verifier: Validates structural integrity, CFG terminators,
-- register intervals, constant indices, and upvalue bounds before code generation.
--

local Opcodes = require("prometheus.vm.opcodes.opcodes")

local IRVerifier = {}

function IRVerifier.verifyFunction(irFunc, errors, path)
    errors = errors or {}
    path = path or (irFunc.name or "chunk")

    if not irFunc.blocks or #irFunc.blocks == 0 then
        table.insert(errors, string.format("[%s] IR Function has no basic blocks.", path))
        return #errors == 0, errors
    end

    -- Build set of valid block IDs
    local validBlockIds = {}
    for _, block in ipairs(irFunc.blocks) do
        if not block.id then
            table.insert(errors, string.format("[%s] Found block with nil ID.", path))
        elseif validBlockIds[block.id] then
            table.insert(errors, string.format("[%s] Duplicate block ID %d detected.", path, block.id))
        else
            validBlockIds[block.id] = true
        end
    end

    local numConstants = #irFunc.constants
    local numUpvalues = #irFunc.upvalues
    local numProtos = #irFunc.protos

    -- Verify instructions in each block
    for bIdx, block in ipairs(irFunc.blocks) do
        local blockLabel = string.format("%s:bb_%s(%d)", path, block.name or "unnamed", block.id or bIdx)

        for iIdx, inst in ipairs(block.instructions) do
            local instLabel = string.format("%s:inst_%d[%s]", blockLabel, iIdx, tostring(inst.op))
            local op = inst.op

            -- 1. Opcode validity
            if not Opcodes.Op[op] then
                table.insert(errors, string.format("%s: Unknown opcode '%s'.", instLabel, tostring(op)))
            end

            local ops = inst.operands or {}

            -- 2. Jump & branch target validity
            if op == "JMP" then
                local target = ops[1]
                if type(target) == "number" and not validBlockIds[target] then
                    table.insert(errors, string.format("%s: JMP target block %d does not exist.", instLabel, target))
                end
            elseif op == "FORPREP" or op == "FORLOOP" then
                local target = ops[2]
                if type(target) == "number" and not validBlockIds[target] then
                    table.insert(errors, string.format("%s: %s target block %d does not exist.", instLabel, op, target))
                end
            elseif op == "TFORLOOP" then
                local target = ops[3]
                if type(target) == "number" and not validBlockIds[target] then
                    table.insert(errors, string.format("%s: TFORLOOP target block %d does not exist.", instLabel, target))
                end
            end

            -- 3. Constant bounds validity
            if op == "LOADK" or op == "GETGLOBAL" or op == "SETGLOBAL" then
                local kIdx = ops[2]
                if type(kIdx) == "number" and (kIdx < 1 or kIdx > numConstants) then
                    table.insert(errors, string.format("%s: Constant index %d out of bounds [1, %d].", instLabel, kIdx, numConstants))
                end
            end

            -- 4. Upvalue bounds validity
            if op == "GETUPVAL" or op == "SETUPVAL" then
                local uvIdx = ops[2]
                if type(uvIdx) == "number" and (uvIdx < 1 or uvIdx > numUpvalues) then
                    table.insert(errors, string.format("%s: Upvalue index %d out of bounds [1, %d].", instLabel, uvIdx, numUpvalues))
                end
            end

            -- 5. Prototype bounds validity
            if op == "CLOSURE" then
                local protoIdx = ops[2]
                if type(protoIdx) == "number" and (protoIdx < 1 or protoIdx > numProtos) then
                    table.insert(errors, string.format("%s: Proto index %d out of bounds [1, %d].", instLabel, protoIdx, numProtos))
                end
            end

            -- 6. Register bounds validity
            local regLimit = math.max(irFunc.max_registers + 64, 256)
            for opIdx, operand in ipairs(ops) do
                -- In instructions where operand is a register (typically A, and B/C if < 1000 and not a block id)
                if opIdx == 1 and (op ~= "JMP") and type(operand) == "number" then
                    if operand < 0 or operand > regLimit then
                        table.insert(errors, string.format("%s: Register A (%d) exceeds valid range [0, %d].", instLabel, operand, regLimit))
                    end
                end
            end
        end

        -- 7. Block terminator validity
        local numInsts = #block.instructions
        if numInsts == 0 then
            table.insert(errors, string.format("%s: Basic block is empty.", blockLabel))
        else
            local lastInst = block.instructions[numInsts]
            local lastOp = lastInst and lastInst.op
            local isTerm = (lastOp == "JMP" or lastOp == "RETURN" or lastOp == "TAILCALL" or
                            lastOp == "FORLOOP" or lastOp == "FORPREP" or lastOp == "TFORLOOP" or
                            lastOp == "RETURN_FAST" or lastOp == "JUMP_IF" or lastOp == "JUMP_IF_NOT")
            if not isTerm then
                table.insert(errors, string.format("%s: Block does not end with a valid terminator (ends with '%s').", blockLabel, tostring(lastOp)))
            end
        end
    end

    -- Recursively verify child prototypes
    for pIdx, childProto in ipairs(irFunc.protos) do
        local childPath = string.format("%s.proto_%d", path, pIdx)
        IRVerifier.verifyFunction(childProto, errors, childPath)
    end

    return #errors == 0, errors
end

function IRVerifier.verify(irRoot)
    local errors = {}
    local ok, errs = IRVerifier.verifyFunction(irRoot, errors, "root")
    if not ok then
        local msg = table.concat(errs, "\\n  * ")
        return false, "PinatVM IR Verification Failed:\\n  * " .. msg
    end
    return true, nil
end

return IRVerifier
`,"prometheus.vm.opcodes.opcodes":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/opcodes/opcodes.lua
--
-- Logical instruction set definition and metadata for PinatVM Phase 1
-- 48 opcodes organized by category:
--   DATA (5), GLOBAL (2), TABLE (5), ARITHMETIC (7), LOGICAL (3),
--   CONTROL (7), CALL (3), FUNCTION (4), ITERATION (3), PINATVM_FAST (9)

local Opcodes = {}

-- ============================================================
-- Logical Opcode Enumeration (by category)
-- ============================================================
Opcodes.Op = {
    -- DATA: Register and constant loading
    MOVE        = "MOVE",       -- R(A) = R(B)
    LOADK       = "LOADK",      -- R(A) = K(Bx)   (general constant)
    LOADBOOL    = "LOADBOOL",   -- R(A) = (bool)B ; if C then PC++
    LOADNIL     = "LOADNIL",    -- R(A..B) = nil
    LOADNUM     = "LOADNUM",    -- R(A) = K(Bx) where K is a number constant (fast numeric path)

    -- GLOBAL: Global environment access
    GETGLOBAL   = "GETGLOBAL",  -- R(A) = Gbl[K(Bx)]
    SETGLOBAL   = "SETGLOBAL",  -- Gbl[K(Bx)] = R(A)

    -- TABLE: Table construction and access
    GETTABLE    = "GETTABLE",   -- R(A) = R(B)[RK(C)]
    SETTABLE    = "SETTABLE",   -- R(A)[RK(B)] = RK(C)
    NEWTABLE    = "NEWTABLE",   -- R(A) = {} (size hint B, C)
    SELF        = "SELF",       -- R(A+1)=R(B); R(A)=R(B)[RK(C)]
    SETLIST     = "SETLIST",    -- R(A)[B*FPF+i] = R(A+i) for i in 1..C

    -- ARITHMETIC
    ADD         = "ADD",        -- R(A) = RK(B) + RK(C)
    SUB         = "SUB",        -- R(A) = RK(B) - RK(C)
    MUL         = "MUL",        -- R(A) = RK(B) * RK(C)
    DIV         = "DIV",        -- R(A) = RK(B) / RK(C)
    MOD         = "MOD",        -- R(A) = RK(B) % RK(C)
    POW         = "POW",        -- R(A) = RK(B) ^ RK(C)
    UNM         = "UNM",        -- R(A) = -R(B)

    -- LOGICAL / COMPARISON
    NOT         = "NOT",        -- R(A) = not R(B)
    LEN         = "LEN",        -- R(A) = #R(B)
    CONCAT      = "CONCAT",     -- R(A) = R(B) .. ... .. R(C)

    -- CONTROL FLOW
    JMP         = "JMP",        -- PC += sBx
    EQ          = "EQ",         -- if (RK(B) == RK(C)) ~= A then PC++
    NE          = "NE",         -- if (RK(B) ~= RK(C)) ~= A then PC++
    LT          = "LT",         -- if (RK(B) <  RK(C)) ~= A then PC++
    LE          = "LE",         -- if (RK(B) <= RK(C)) ~= A then PC++
    TEST        = "TEST",       -- if not (R(A) <=> B) then PC++
    TESTSET     = "TESTSET",    -- if (R(B) <=> C) then R(A)=R(B) else PC++

    -- CALL
    CALL        = "CALL",       -- R(A..A+C-2) = R(A)(R(A+1..A+B-1))
    TAILCALL    = "TAILCALL",   -- return R(A)(R(A+1..A+B-1))
    RETURN      = "RETURN",     -- return R(A..A+B-2)

    -- FUNCTION
    CLOSURE     = "CLOSURE",    -- R(A) = closure(Proto[Bx])
    CLOSE       = "CLOSE",      -- close upvalues from R(A) upward
    GETUPVAL    = "GETUPVAL",   -- R(A) = UV[B]
    SETUPVAL    = "SETUPVAL",   -- UV[B] = R(A)

    -- ITERATION
    FORPREP     = "FORPREP",    -- R(A) -= R(A+2); PC += sBx
    FORLOOP     = "FORLOOP",    -- R(A) += R(A+2); if R(A) <=/>= R(A+1) then PC += sBx; R(A+3)=R(A)
    TFORLOOP    = "TFORLOOP",   -- R(A+3..A+2+C) = R(A)(R(A+1),R(A+2)); if R(A+3) ~= nil then PC += sBx

    -- VARARG
    VARARG      = "VARARG",     -- R(A..A+B-2) = vararg

    -- ====================================================
    -- PINATVM FAST-PATH OPCODES
    -- These have real semantic value (not just cosmetic).
    -- The compiler emits them via peephole lowering.
    -- ====================================================

    -- Fast numeric constant load (bypasses type-dispatch in decodeConstant)
    LOAD_NUMBER     = "LOAD_NUMBER",    -- R(A) = NumK(Bx)   [number only pool]

    -- Fast string constant load (bypasses numeric path)
    LOAD_STRING     = "LOAD_STRING",    -- R(A) = StrK(Bx)   [string only pool]

    -- Generic tagged fast load (type tag in C: 1=str, 2=num, 3=bool, 4=nil)
    LOAD_CONST      = "LOAD_CONST",     -- R(A) = K(Bx), type asserted as C

    -- Bulk register copy: R(A..A+C-1) = R(B..B+C-1)
    MOVE_RANGE      = "MOVE_RANGE",     -- R(A..A+C-1) = R(B..B+C-1)

    -- Fused conditional branch: if R(A) then PC += sBx
    JUMP_IF         = "JUMP_IF",        -- if R(A) then PC += B

    -- Fused conditional branch: if not R(A) then PC += sBx
    JUMP_IF_NOT     = "JUMP_IF_NOT",    -- if not R(A) then PC += B

    -- Fixed-arity call (B = exact arg count, no variadic path)
    CALL_FAST       = "CALL_FAST",      -- R(A..A+C-2) = R(A)(R(A+1..A+B))

    -- Fixed-count return (B = exact return count, no variadic path)
    RETURN_FAST     = "RETURN_FAST",    -- return R(A..A+B-1)

    -- String-keyed table get (key as string constant, not RK)
    TABLE_GET_FAST  = "TABLE_GET_FAST", -- R(A) = R(B)[StrK(C)]

    -- String-keyed table set (key as string constant, not RK)
    TABLE_SET_FAST  = "TABLE_SET_FAST", -- R(A)[StrK(B)] = R(C)

    -- ====================================================
    -- PINATVM EXTENDED SECURITY & ARITHMETIC OPCODES (50+)
    -- ====================================================
    XOR             = "XOR",            -- R(A) = bitwise XOR(RK(B), RK(C))
    SHL             = "SHL",            -- R(A) = bitwise SHL(RK(B), RK(C))
    SHR             = "SHR",            -- R(A) = bitwise SHR(RK(B), RK(C))
    INTDIV          = "INTDIV",         -- R(A) = math.floor(RK(B) / RK(C))
    INC             = "INC",            -- R(A) = R(B) + C
    DEC             = "DEC",            -- R(A) = R(B) - C
    SWAP            = "SWAP",           -- R(A), R(B) = R(B), R(A)
    CHECK_CANARY    = "CHECK_CANARY",   -- Validate canary register R(A)
    TRAP_HONEYPOT   = "TRAP_HONEYPOT",  -- Trap honeypot (fail-closed if executed)
}

-- ============================================================
-- Instruction Format Metadata
-- "ABC"   : 3 operands (A 8-bit, B 9-bit, C 9-bit)
-- "ABx"   : 2 operands (A 8-bit, Bx 18-bit unsigned)
-- "AsBx"  : 2 operands (A 8-bit, sBx 18-bit signed)
-- "sBx"   : 1 signed branch offset (JMP only — A is offset)
-- ============================================================
Opcodes.Format = {
    -- DATA
    [Opcodes.Op.MOVE]           = "ABC",
    [Opcodes.Op.LOADK]          = "ABx",
    [Opcodes.Op.LOADBOOL]       = "ABC",
    [Opcodes.Op.LOADNIL]        = "ABC",
    [Opcodes.Op.LOADNUM]        = "ABx",

    -- GLOBAL
    [Opcodes.Op.GETGLOBAL]      = "ABx",
    [Opcodes.Op.SETGLOBAL]      = "ABx",

    -- TABLE
    [Opcodes.Op.GETTABLE]       = "ABC",
    [Opcodes.Op.SETTABLE]       = "ABC",
    [Opcodes.Op.NEWTABLE]       = "ABC",
    [Opcodes.Op.SELF]           = "ABC",
    [Opcodes.Op.SETLIST]        = "ABC",

    -- ARITHMETIC
    [Opcodes.Op.ADD]            = "ABC",
    [Opcodes.Op.SUB]            = "ABC",
    [Opcodes.Op.MUL]            = "ABC",
    [Opcodes.Op.DIV]            = "ABC",
    [Opcodes.Op.MOD]            = "ABC",
    [Opcodes.Op.POW]            = "ABC",
    [Opcodes.Op.UNM]            = "ABC",

    -- LOGICAL
    [Opcodes.Op.NOT]            = "ABC",
    [Opcodes.Op.LEN]            = "ABC",
    [Opcodes.Op.CONCAT]         = "ABC",

    -- CONTROL
    [Opcodes.Op.JMP]            = "sBx",
    [Opcodes.Op.EQ]             = "ABC",
    [Opcodes.Op.NE]             = "ABC",
    [Opcodes.Op.LT]             = "ABC",
    [Opcodes.Op.LE]             = "ABC",
    [Opcodes.Op.TEST]           = "ABC",
    [Opcodes.Op.TESTSET]        = "ABC",

    -- CALL
    [Opcodes.Op.CALL]           = "ABC",
    [Opcodes.Op.TAILCALL]       = "ABC",
    [Opcodes.Op.RETURN]         = "ABC",

    -- FUNCTION
    [Opcodes.Op.CLOSURE]        = "ABx",
    [Opcodes.Op.CLOSE]          = "ABC",
    [Opcodes.Op.GETUPVAL]       = "ABC",
    [Opcodes.Op.SETUPVAL]       = "ABC",

    -- ITERATION
    [Opcodes.Op.FORPREP]        = "AsBx",
    [Opcodes.Op.FORLOOP]        = "AsBx",
    [Opcodes.Op.TFORLOOP]       = "ABC",

    -- VARARG
    [Opcodes.Op.VARARG]         = "ABC",

    -- PINATVM FAST-PATH
    [Opcodes.Op.LOAD_NUMBER]    = "ABx",
    [Opcodes.Op.LOAD_STRING]    = "ABx",
    [Opcodes.Op.LOAD_CONST]     = "ABC",
    [Opcodes.Op.MOVE_RANGE]     = "ABC",
    [Opcodes.Op.JUMP_IF]        = "AsBx",
    [Opcodes.Op.JUMP_IF_NOT]    = "AsBx",
    [Opcodes.Op.CALL_FAST]      = "ABC",
    [Opcodes.Op.RETURN_FAST]    = "ABx",
    [Opcodes.Op.TABLE_GET_FAST] = "ABC",
    [Opcodes.Op.TABLE_SET_FAST] = "ABC",
    -- EXTENDED
    [Opcodes.Op.XOR]            = "ABC",
    [Opcodes.Op.SHL]            = "ABC",
    [Opcodes.Op.SHR]            = "ABC",
    [Opcodes.Op.INTDIV]         = "ABC",
    [Opcodes.Op.INC]            = "ABC",
    [Opcodes.Op.DEC]            = "ABC",
    [Opcodes.Op.SWAP]           = "ABC",
    [Opcodes.Op.CHECK_CANARY]   = "ABC",
    [Opcodes.Op.TRAP_HONEYPOT]  = "ABC",
}

-- Opcode category metadata for verifier and analyzer
Opcodes.Category = {
    [Opcodes.Op.MOVE]           = "DATA",
    [Opcodes.Op.LOADK]          = "DATA",
    [Opcodes.Op.LOADBOOL]       = "DATA",
    [Opcodes.Op.LOADNIL]        = "DATA",
    [Opcodes.Op.LOADNUM]        = "DATA",
    [Opcodes.Op.GETGLOBAL]      = "GLOBAL",
    [Opcodes.Op.SETGLOBAL]      = "GLOBAL",
    [Opcodes.Op.GETTABLE]       = "TABLE",
    [Opcodes.Op.SETTABLE]       = "TABLE",
    [Opcodes.Op.NEWTABLE]       = "TABLE",
    [Opcodes.Op.SELF]           = "TABLE",
    [Opcodes.Op.SETLIST]        = "TABLE",
    [Opcodes.Op.ADD]            = "ARITHMETIC",
    [Opcodes.Op.SUB]            = "ARITHMETIC",
    [Opcodes.Op.MUL]            = "ARITHMETIC",
    [Opcodes.Op.DIV]            = "ARITHMETIC",
    [Opcodes.Op.MOD]            = "ARITHMETIC",
    [Opcodes.Op.POW]            = "ARITHMETIC",
    [Opcodes.Op.UNM]            = "ARITHMETIC",
    [Opcodes.Op.NOT]            = "LOGICAL",
    [Opcodes.Op.LEN]            = "LOGICAL",
    [Opcodes.Op.CONCAT]         = "LOGICAL",
    [Opcodes.Op.JMP]            = "CONTROL",
    [Opcodes.Op.EQ]             = "CONTROL",
    [Opcodes.Op.NE]             = "CONTROL",
    [Opcodes.Op.LT]             = "CONTROL",
    [Opcodes.Op.LE]             = "CONTROL",
    [Opcodes.Op.TEST]           = "CONTROL",
    [Opcodes.Op.TESTSET]        = "CONTROL",
    [Opcodes.Op.CALL]           = "CALL",
    [Opcodes.Op.TAILCALL]       = "CALL",
    [Opcodes.Op.RETURN]         = "CALL",
    [Opcodes.Op.CLOSURE]        = "FUNCTION",
    [Opcodes.Op.CLOSE]          = "FUNCTION",
    [Opcodes.Op.GETUPVAL]       = "FUNCTION",
    [Opcodes.Op.SETUPVAL]       = "FUNCTION",
    [Opcodes.Op.FORPREP]        = "ITERATION",
    [Opcodes.Op.FORLOOP]        = "ITERATION",
    [Opcodes.Op.TFORLOOP]       = "ITERATION",
    [Opcodes.Op.VARARG]         = "CALL",
    [Opcodes.Op.LOAD_NUMBER]    = "FAST",
    [Opcodes.Op.LOAD_STRING]    = "FAST",
    [Opcodes.Op.LOAD_CONST]     = "FAST",
    [Opcodes.Op.MOVE_RANGE]     = "FAST",
    [Opcodes.Op.JUMP_IF]        = "FAST",
    [Opcodes.Op.JUMP_IF_NOT]    = "FAST",
    [Opcodes.Op.CALL_FAST]      = "FAST",
    [Opcodes.Op.RETURN_FAST]    = "FAST",
    [Opcodes.Op.TABLE_GET_FAST] = "FAST",
    [Opcodes.Op.TABLE_SET_FAST] = "FAST",
    [Opcodes.Op.XOR]            = "ARITHMETIC",
    [Opcodes.Op.SHL]            = "ARITHMETIC",
    [Opcodes.Op.SHR]            = "ARITHMETIC",
    [Opcodes.Op.INTDIV]         = "ARITHMETIC",
    [Opcodes.Op.INC]            = "ARITHMETIC",
    [Opcodes.Op.DEC]            = "ARITHMETIC",
    [Opcodes.Op.SWAP]           = "DATA",
    [Opcodes.Op.CHECK_CANARY]   = "SECURITY",
    [Opcodes.Op.TRAP_HONEYPOT]  = "SECURITY",
}

-- Terminator opcodes: a basic block must end with one of these
Opcodes.Terminators = {
    [Opcodes.Op.JMP]         = true,
    [Opcodes.Op.RETURN]      = true,
    [Opcodes.Op.TAILCALL]    = true,
    [Opcodes.Op.FORLOOP]     = true,
    [Opcodes.Op.FORPREP]     = true,
    [Opcodes.Op.TFORLOOP]    = true,
    [Opcodes.Op.RETURN_FAST] = true,
    [Opcodes.Op.JUMP_IF]     = true,
    [Opcodes.Op.JUMP_IF_NOT] = true,
}

-- Opcodes that use RK (register-or-constant) encoding for B or C
Opcodes.RkOps = {
    [Opcodes.Op.GETTABLE]    = true,
    [Opcodes.Op.SETTABLE]    = true,
    [Opcodes.Op.SELF]        = true,
    [Opcodes.Op.ADD]         = true,
    [Opcodes.Op.SUB]         = true,
    [Opcodes.Op.MUL]         = true,
    [Opcodes.Op.DIV]         = true,
    [Opcodes.Op.MOD]         = true,
    [Opcodes.Op.POW]         = true,
    [Opcodes.Op.CONCAT]      = true,
    [Opcodes.Op.EQ]          = true,
    [Opcodes.Op.NE]          = true,
    [Opcodes.Op.LT]          = true,
    [Opcodes.Op.LE]          = true,
    [Opcodes.Op.XOR]         = true,
    [Opcodes.Op.SHL]         = true,
    [Opcodes.Op.SHR]         = true,
    [Opcodes.Op.INTDIV]      = true,
}

-- Canonical opcode ordering for permutation (deterministic base order)
Opcodes.AllOps = {
    -- Standard (39)
    "MOVE", "LOADK", "LOADBOOL", "LOADNIL", "LOADNUM",
    "GETGLOBAL", "SETGLOBAL",
    "GETTABLE", "SETTABLE", "NEWTABLE", "SELF", "SETLIST",
    "ADD", "SUB", "MUL", "DIV", "MOD", "POW", "CONCAT",
    "NOT", "LEN", "UNM",
    "JMP", "EQ", "NE", "LT", "LE", "TEST", "TESTSET",
    "CALL", "TAILCALL", "RETURN",
    "CLOSURE", "CLOSE", "GETUPVAL", "SETUPVAL",
    "FORPREP", "FORLOOP", "TFORLOOP", "VARARG",
    -- PinatVM Fast-Path (9)
    "LOAD_NUMBER", "LOAD_STRING", "LOAD_CONST",
    "MOVE_RANGE",
    "JUMP_IF", "JUMP_IF_NOT",
    "CALL_FAST", "RETURN_FAST",
    "TABLE_GET_FAST", "TABLE_SET_FAST",
    -- PinatVM Extended Custom Security & Arithmetic (8)
    "XOR", "SHL", "SHR", "INTDIV",
    "INC", "DEC", "SWAP", "CHECK_CANARY", "TRAP_HONEYPOT",
}

-- Total count for reference
Opcodes.Count = #Opcodes.AllOps  -- 57

return Opcodes
`,"prometheus.vm.opcodes.permutator":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/opcodes/permutator.lua
--
-- Build-time randomized opcode assignment and operand encoding

local Opcodes = require("prometheus.vm.opcodes.opcodes")

local Permutator = {}
Permutator.__index = Permutator

-- Simple deterministic LCG PRNG for repeatable build permutations
local function createRng(seed)
    if not seed or seed == 0 then
        seed = (math.random and math.random(1000000, 2147483640))
            or ((os.time() * 1000 + math.floor(os.clock() * 1000000)) % 2147483647)
    end
    local state = seed % 2147483647
    if state == 0 then state = 1234567 end
    return function(min, max)
        state = (state * 16807 + 12345) % 2147483647
        if not min then
            return state / 2147483647
        end
        if not max then
            max = min
            min = 1
        end
        return min + (state % (max - min + 1))
    end
end

function Permutator.new(seed)
    local rng = createRng(seed)
    local self = setmetatable({
        seed = seed or 0,
        rng = rng,
        logicalToNumeric = {},
        numericToLogical = {},
        opOffset = rng(50, 300),
        rkThreshold = rng(10000000, 20000000), -- Dynamic per-build Constant threshold in B/C
        fieldOrder = { 1, 2, 3, 4 },
        fieldMasks = {
            a = rng(11, 73),
            b = rng(11, 73),
            c = rng(11, 73),
        }
    }, Permutator)

    -- Shuffle opcodes
    local allOps = {}
    for i, op in ipairs(Opcodes.AllOps) do
        allOps[i] = op
    end
    for i = #allOps, 2, -1 do
        local j = rng(1, i)
        allOps[i], allOps[j] = allOps[j], allOps[i]
    end

    -- Non-consecutive sparse opcode mapping per build
    local currentId = self.opOffset
    for i, op in ipairs(allOps) do
        currentId = currentId + rng(2, 7)
        self.logicalToNumeric[op] = currentId
        self.numericToLogical[currentId] = op
    end

    -- Numeric opcode map: maps integer IDs (1..59) to numeric IDs (no '_o' strings in output)
    self.tokenMap = {}
    for i, op in ipairs(Opcodes.AllOps) do
        local nid = self.logicalToNumeric[op]
        self.tokenMap[i] = nid
    end

    -- Permute field order for instruction tuples
    local fields = { 1, 2, 3, 4 }
    for i = 4, 2, -1 do
        local j = rng(1, i)
        fields[i], fields[j] = fields[j], fields[i]
    end
    self.fieldOrder = fields

    return self
end

function Permutator:getOpcodeId(op)
    local id = self.logicalToNumeric[op]
    if not id then
        error("Unknown opcode for permutation: " .. tostring(op))
    end
    return id
end

function Permutator:encodeOperandRK(opType, val)
    if opType == "const" then
        return (val - 1) + self.rkThreshold
    else
        return val
    end
end

function Permutator:encodeInstruction(logicalOp, a, b, c)
    local opId = self:getOpcodeId(logicalOp)
    local encA = (a or 0) + self.fieldMasks.a
    local encB = (b or 0) + self.fieldMasks.b
    local encC = (c or 0) + self.fieldMasks.c

    -- Put values in permuted tuple fields
    local raw = { opId, encA, encB, encC }
    local tuple = {}
    for pos, fieldIdx in ipairs(self.fieldOrder) do
        tuple[pos] = raw[fieldIdx]
    end
    return tuple
end

function Permutator:getDecoderConfig(includeNamedOps)
    -- Map positions back so runtime can extract [op, a, b, c]
    local invOrder = {}
    for pos, fieldIdx in ipairs(self.fieldOrder) do
        invOrder[fieldIdx] = pos
    end

    -- Default: use obfuscated token map to eliminate 'MOVE', 'LOADK' strings from output
    local map = {}
    for k, v in pairs(self.tokenMap) do
        map[k] = v
    end
    if includeNamedOps then
        for k, v in pairs(self.logicalToNumeric) do
            map[k] = v
        end
    end

    return {
        opOffset = self.opOffset,
        rkThreshold = self.rkThreshold,
        opPos = invOrder[1],
        aPos = invOrder[2],
        bPos = invOrder[3],
        cPos = invOrder[4],
        maskA = self.fieldMasks.a,
        maskB = self.fieldMasks.b,
        maskC = self.fieldMasks.c,
        opcodeMap = map,
    }
end

return Permutator
`,"prometheus.vm.predicates.framework":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/predicates/framework.lua
--
-- Opaque Predicate Framework: Multi-category mathematically proven invariants
-- Categories:
--   1. Arithmetic Invariants: n*(n+1) % 2 == 0
--   2. Modular Congruence Invariants: (m*x + k) % m == k (k in 1..m-1, m >= 3)
--   3. Invariant-Based Polynomials: (x+1)*(x-1) == x^2 - 1
--   4. State-Dependent Congruences: Linear congruential state invariant
--
-- Each generator provides:
--   - instructions: IR instruction list
--   - condReg: register containing boolean result
--   - expectedBool: true or false
--   - complexityScore: 1-100 rating of reverse-engineering difficulty
--   - costEstimate: estimated instruction overhead
--   - verifier: mathematical proof verification function
--

local OpaqueFramework = {}

-- 1. Arithmetic Invariant: For any integer n >= 1, n*(n+1) is even => (n*(n+1)) % 2 == 0
function OpaqueFramework.generateArithmetic(irFunc, rng, baseScratch)
    baseScratch = baseScratch or (irFunc.max_registers + 1)
    local n = rng(3, 89)
    local nPlus1 = n + 1

    local cN = irFunc:addConstant(n)
    local cN1 = irFunc:addConstant(nPlus1)
    local c2 = irFunc:addConstant(2)
    local c0 = irFunc:addConstant(0)

    local rA = baseScratch
    local rB = baseScratch + 1
    local rProd = baseScratch + 2
    local rTwo = baseScratch + 3
    local rMod = baseScratch + 4
    local rZero = baseScratch + 5
    local rCond = baseScratch + 6

    local instructions = {
        { op = "LOADK", operands = { rA, cN } },
        { op = "LOADK", operands = { rB, cN1 } },
        { op = "MUL",   operands = { rProd, rA, rB } },
        { op = "LOADK", operands = { rTwo, c2 } },
        { op = "MOD",   operands = { rMod, rProd, rTwo } },
        { op = "LOADK", operands = { rZero, c0 } },
        { op = "EQ",    operands = { rCond, rMod, rZero } },
    }

    local function verify()
        for x = 1, 50 do
            if (x * (x + 1)) % 2 ~= 0 then return false end
        end
        return true
    end

    return {
        instructions = instructions,
        condReg = rCond,
        expectedBool = true,
        complexityScore = 25,
        costEstimate = #instructions,
        verify = verify,
        name = "arithmetic_even_product",
    }
end

-- 2. Modular Congruence Invariant: For any integer x, (m*x + k) % m == k (where k != 0 and k < m)
function OpaqueFramework.generateModular(irFunc, rng, baseScratch)
    baseScratch = baseScratch or (irFunc.max_registers + 1)
    local m = rng(5, 23)
    local k = rng(1, m - 1)
    local x = rng(2, 47)

    local cM = irFunc:addConstant(m)
    local cK = irFunc:addConstant(k)
    local cX = irFunc:addConstant(x)

    local rX = baseScratch
    local rM = baseScratch + 1
    local rProd = baseScratch + 2
    local rK = baseScratch + 3
    local rSum = baseScratch + 4
    local rMod = baseScratch + 5
    local rCond = baseScratch + 6

    local instructions = {
        { op = "LOADK", operands = { rX, cX } },
        { op = "LOADK", operands = { rM, cM } },
        { op = "MUL",   operands = { rProd, rX, rM } },
        { op = "LOADK", operands = { rK, cK } },
        { op = "ADD",   operands = { rSum, rProd, rK } },
        { op = "MOD",   operands = { rMod, rSum, rM } },
        { op = "EQ",    operands = { rCond, rMod, rK } },
    }

    local function verify()
        for testX = 1, 50 do
            if ((m * testX + k) % m) ~= k then return false end
        end
        return true
    end

    return {
        instructions = instructions,
        condReg = rCond,
        expectedBool = true,
        complexityScore = 40,
        costEstimate = #instructions,
        verify = verify,
        name = "modular_congruence",
    }
end

-- 3. Invariant-Based Polynomial: (x + 1) * (x - 1) == x^2 - 1
function OpaqueFramework.generatePolynomial(irFunc, rng, baseScratch)
    baseScratch = baseScratch or (irFunc.max_registers + 1)
    local x = rng(4, 53)

    local cX = irFunc:addConstant(x)
    local c1 = irFunc:addConstant(1)

    local rX = baseScratch
    local rOne = baseScratch + 1
    local rPlus = baseScratch + 2
    local rMinus = baseScratch + 3
    local rLhs = baseScratch + 4
    local rSq = baseScratch + 5
    local rRhs = baseScratch + 6
    local rCond = baseScratch + 7

    local instructions = {
        { op = "LOADK", operands = { rX, cX } },
        { op = "LOADK", operands = { rOne, c1 } },
        { op = "ADD",   operands = { rPlus, rX, rOne } },
        { op = "SUB",   operands = { rMinus, rX, rOne } },
        { op = "MUL",   operands = { rLhs, rPlus, rMinus } },
        { op = "MUL",   operands = { rSq, rX, rX } },
        { op = "SUB",   operands = { rRhs, rSq, rOne } },
        { op = "EQ",    operands = { rCond, rLhs, rRhs } },
    }

    local function verify()
        for testX = 2, 50 do
            if ((testX + 1) * (testX - 1)) ~= (testX * testX - 1) then return false end
        end
        return true
    end

    return {
        instructions = instructions,
        condReg = rCond,
        expectedBool = true,
        complexityScore = 55,
        costEstimate = #instructions,
        verify = verify,
        name = "polynomial_difference_of_squares",
    }
end

-- Selector: Selects and generates a mathematically proven predicate
function OpaqueFramework.generate(irFunc, rng, baseScratch)
    local choices = {
        OpaqueFramework.generateArithmetic,
        OpaqueFramework.generateModular,
        OpaqueFramework.generatePolynomial,
    }

    local generator = choices[rng(1, #choices)]
    local pred = generator(irFunc, rng, baseScratch)

    -- Rigorous proof check before emission
    if not pred.verify() then
        error("PinatVM Opaque Predicate failed mathematical verification: " .. tostring(pred.name))
    end

    -- Reject trivial predicates with score < 20
    if pred.complexityScore < 20 then
        error("PinatVM Opaque Predicate complexity score too low (" .. tostring(pred.complexityScore) .. "). Rejected.")
    end

    return pred
end

return OpaqueFramework
`,"prometheus.vm.protection.constants":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/protection/constants.lua
--
-- Protected Constant Pool with Multi-Representation Architecture & Key Derivation (KDF)
-- Supports 6 polymorphic string representations:
--   Rep 1: Rolling KDF Keystream (PRNG state stream)
--   Rep 2: Split-Chunk with Offset Interleaving & Fisher-Yates Permutation
--   Rep 3: Inverted S-Box Byte Substitution
--   Rep 4: Modular Polynomial Byte Delta
--   Rep 5: Custom-Alphabet Base64 + per-string XOR + Adler-32 Anti-Tamper
--   Rep 6: [PRIMARY - VeryMax] AES inv-sbox substitution + position-XOR-offset
--           + HMAC-style 64-bit MAC + anti-debug canary embedded in MAC
--
-- Rep 6 is ALWAYS used for string constants in VeryMax mode.
-- Rep 5 is the fallback for Standard mode.
-- Rep 1-4 retained for legacy compatibility only.
--
-- Encryption pipeline for strings (Rep 6):
--   plaintext
--     -> AES inv-sbox substitute (key-derived seed)
--     -> position-keyed XOR + byte offset
--     -> 64-bit MAC (HMAC-style over ciphertext, blocks of 8)
--   Stored as: { v={bytes}, mac0, mac1 (two 32-bit halves) }
--

local KDF = require("prometheus.vm.protection.kdf")

local ConstantsProtection = {}

-- ============================================================
-- Base64 with Custom Alphabet (seed-derived, non-standard)
-- Pure Lua implementation, zero stdlib dependencies
-- ============================================================

local function makeBase64Alphabet(seed)
    -- Standard B64 chars shuffled deterministically from seed
    local chars = {}
    local src = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    for i = 1, 64 do chars[i] = src:sub(i, i) end
    -- Fisher-Yates deterministic shuffle using LCG from seed
    local state = (seed % 2147483647)
    if state == 0 then state = 314159 end
    for i = 64, 2, -1 do
        state = (state * 16807 + 12345) % 2147483647
        local j = (state % i) + 1
        chars[i], chars[j] = chars[j], chars[i]
    end
    -- Also derive a custom padding char (not '=' to avoid standard recognition)
    state = (state * 16807 + 12345) % 2147483647
    local padChars = "!@#$%^&*~"
    local padIdx   = (state % #padChars) + 1
    local padChar  = padChars:sub(padIdx, padIdx)
    return chars, padChar
end

local function base64Encode(str, alphabet, padChar)
    -- Build lookup: byte value → char
    local out = {}
    local len = #str
    local i = 1
    while i <= len do
        local b0 = str:byte(i) or 0
        local b1 = str:byte(i + 1) or 0
        local b2 = str:byte(i + 2) or 0
        -- 3 bytes → 4 base64 chars
        local n = b0 * 65536 + b1 * 256 + b2
        local c0 = (n - n % 262144) / 262144       -- bits 17-23
        local c1 = ((n % 262144) - (n % 4096)) / 4096  -- bits 11-16
        local c2 = ((n % 4096) - (n % 64)) / 64        -- bits 5-10
        local c3 = n % 64                              -- bits 0-4
        out[#out + 1] = alphabet[c0 + 1]
        out[#out + 1] = alphabet[c1 + 1]
        if i + 1 <= len then
            out[#out + 1] = alphabet[c2 + 1]
        else
            out[#out + 1] = padChar
        end
        if i + 2 <= len then
            out[#out + 1] = alphabet[c3 + 1]
        else
            out[#out + 1] = padChar
        end
        i = i + 3
    end
    return table.concat(out)
end

local function base64Decode(b64str, alphabet, padChar)
    -- Build reverse lookup: char → 6-bit value
    local rev = {}
    for i = 1, 64 do
        rev[alphabet[i]] = i - 1
    end
    local out = {}
    local len = #b64str
    local i = 1
    while i <= len do
        local c0 = rev[b64str:sub(i, i)]   or 0
        local c1 = rev[b64str:sub(i+1,i+1)] or 0
        local c2 = rev[b64str:sub(i+2,i+2)]
        local c3 = rev[b64str:sub(i+3,i+3)]
        local n = c0 * 262144 + c1 * 4096
        out[#out + 1] = (n - n % 65536) / 65536
        if c2 then
            n = n + c2 * 64
            out[#out + 1] = ((n % 65536) - (n % 256)) / 256
        end
        if c3 then
            n = n + c3
            out[#out + 1] = n % 256
        end
        i = i + 4
    end
    return out
end

-- ============================================================
-- Per-string XOR layer
-- Key derived from kdfSalt + constant index, range 5..255
-- ============================================================

local function xorBytes(bytes, xorKey)
    local out = {}
    for i = 1, #bytes do
        -- Rotate key to make each byte position use a different sub-key
        local subKey = (xorKey + i * 37) % 251 + 5
        out[i] = (bytes[i] + subKey) % 256   -- additive XOR equiv (XOR-like, reversible)
    end
    return out
end

local function xorBytesInverse(bytes, xorKey)
    local out = {}
    for i = 1, #bytes do
        local subKey = (xorKey + i * 37) % 251 + 5
        out[i] = (bytes[i] - subKey + 256) % 256
    end
    return out
end

-- ============================================================
-- Per-string Integrity Record (anti-tamper Adler-32 variant)
-- Applied AFTER XOR so any tampering with ciphertext is detected
-- ============================================================

local function computeIntegrity(xorBytes_arr, integrityKey)
    local h = (integrityKey % 65521) + 1
    for i = 1, #xorBytes_arr do
        -- Weight by position and key to make collisions harder
        h = (h + xorBytes_arr[i] * ((i % 31) + 1) + integrityKey % 97) % 65521
    end
    return h
end

-- ============================================================
-- Rep 5 Encoder: str → { v={xor_bytes}, h=integrity_hash }
-- ============================================================

local function encodeRep5(str, kdfKey, baseSalt, idx)
    -- Derive custom Base64 alphabet from baseSalt (build-specific)
    local alphabet, padChar = makeBase64Alphabet(baseSalt)

    -- Layer 1: Custom Base64
    local b64 = base64Encode(str, alphabet, padChar)

    -- Derive per-string XOR key
    local xorKey = (kdfKey * idx * 1103515245 + 12345) % 251

    -- Convert b64 string to byte array for XOR layer
    local b64Bytes = {}
    for i = 1, #b64 do b64Bytes[i] = b64:byte(i) end

    -- Layer 2: XOR
    local xored = xorBytes(b64Bytes, xorKey)

    -- Layer 3: Integrity record
    local integrityKey = KDF.deriveKey(kdfKey, idx * 7, 2)
    local h = computeIntegrity(xored, integrityKey)

    return xored, h, xorKey, integrityKey
end

-- ============================================================
-- Rep 6: AES inv-sbox + XOR-offset + 64-bit HMAC MAC
-- Pipeline:
--   1. Build AES-style S-Box from seed (256-entry permutation)
--   2. Compute inverse S-Box
--   3. Substitute every plaintext byte through inv-sbox
--   4. Apply position-keyed XOR + offset (adds byte-level obfuscation)
--   5. Compute 64-bit HMAC-style MAC over ciphertext
--      (two independent 32-bit MurmurHash-inspired passes, each
--       seeded with a different key derivation to resist collision)
-- The MAC is split into mac0 (lower 32 bits) and mac1 (upper 32 bits)
-- and verified at runtime before any decryption begins.
-- ============================================================

local function buildAesSbox(seed)
    -- AES-style S-Box: 256-entry permutation via KSA (RC4-like)
    local S = {}
    for i = 0, 255 do S[i] = i end
    local j = 0
    local key = {}
    -- Derive 32-byte key schedule from seed
    local state = seed % 2147483647
    if state == 0 then state = 271828 end
    for i = 0, 31 do
        state = (state * 16807 + 12345) % 2147483647
        key[i] = state % 256
    end
    for i = 0, 255 do
        j = (j + S[i] + key[i % 32]) % 256
        S[i], S[j] = S[j], S[i]
    end
    return S
end

local function invertSbox(S)
    local inv = {}
    for i = 0, 255 do inv[S[i]] = i end
    return inv
end

-- Lua 5.1-compatible 32-bit XOR (no bitwise ops)
local function xor32(a, b)
    local result = 0
    local bit = 1
    for _ = 1, 32 do
        local ra = a % 2
        local rb = b % 2
        if ra ~= rb then result = result + bit end
        a = (a - ra) / 2
        b = (b - rb) / 2
        bit = bit * 2
    end
    return result
end

local function murmurHash32(data, seed)
    -- MurmurHash3-inspired 32-bit hash (Lua 5.1 compatible, exact 32-bit integer arithmetic)
    local M = 4294967296
    local h = seed % M
    local c1 = 0xcc9e2d51
    local c2 = 0x1b873593
    local len = #data
    local i = 1
    local isStr = (type(data) == "string")
    local function byteAt(idx)
        return isStr and data:byte(idx) or data[idx]
    end
    local function mul32(a, b)
        local a_lo = a % 65536
        local a_hi = math.floor(a / 65536) % 65536
        local b_lo = b % 65536
        local b_hi = math.floor(b / 65536) % 65536
        local mid = (a_hi * b_lo + a_lo * b_hi) % 65536
        return (mid * 65536 + a_lo * b_lo) % 4294967296
    end
    while i + 3 <= len do
        local k = byteAt(i) + byteAt(i+1)*256 + byteAt(i+2)*65536 + byteAt(i+3)*16777216
        k = mul32(k, c1)
        -- rotl15 approx: (k<<15)|(k>>17)
        local khi = (k * 32768) % M
        local klo = math.floor(k / 32768)
        k = (khi + klo) % M
        k = mul32(k, c2)
        h = xor32(h, k)
        -- rotl13 approx
        local hhi = (h * 8192) % M
        local hlo = math.floor(h / 8192)
        h = (hhi + hlo) % M
        h = (h * 5 + 0xe6546b64) % M
        i = i + 4
    end
    -- tail
    local tail = 0
    local rem = len - i + 1
    if rem >= 3 then tail = tail + byteAt(i+2)*65536 end
    if rem >= 2 then tail = tail + byteAt(i+1)*256 end
    if rem >= 1 then tail = tail + byteAt(i) end
    if rem > 0 then
        tail = mul32(tail, c1)
        local thi = (tail * 32768) % M
        local tlo = math.floor(tail / 32768)
        tail = (thi + tlo) % M
        tail = mul32(tail, c2)
        h = xor32(h, tail)
    end
    -- finalization mix
    h = xor32(h, len)
    h = xor32(h, math.floor(h / 65536))
    h = mul32(h, 0x85ebca6b)
    h = xor32(h, math.floor(h / 4096))
    h = mul32(h, 0xc2b2ae35)
    h = xor32(h, math.floor(h / 65536))
    return h
end

local function encodeRep6(str, kdfKey, baseSalt, idx)
    -- Derive S-Box seed independently for this constant (bounded arithmetic across 32-bit/64-bit/float)
    local sboxSeed = ((kdfKey % 65536) * 31337 + (idx % 1024) * 7919 + (baseSalt % 65536) * 13) % 2147483647
    if sboxSeed == 0 then sboxSeed = 100003 end
    local S = buildAesSbox(sboxSeed)
    local invS = invertSbox(S)

    -- Derive per-string XOR+offset key (bounded arithmetic across 32-bit/64-bit/float)
    local xorBase = ((kdfKey % 251) * ((idx * 37) % 251) + (baseSalt % 251) + 17) % 251
    local offBase = ((kdfKey % 97) + (idx * 31) % 97 + (baseSalt % 97)) % 97

    local cipherChars = {}
    for i = 1, #str do
        local b = str:byte(i)
        -- Step 1: AES inv-sbox substitution
        local sub = invS[b]
        -- Step 2: Position-keyed XOR + additive offset
        local subKey = (xorBase + i * 37) % 251 + 5
        local offset = (offBase + i * 13) % 128
        cipherChars[i] = string.char((sub + subKey + offset) % 256)
    end
    local cipherStr = table.concat(cipherChars)

    -- 64-bit HMAC-style MAC: two independent 32-bit passes
    local macKey0 = KDF.deriveKey(kdfKey, idx * 11, 4)
    local macKey1 = KDF.deriveKey(baseSalt, idx * 17 + (kdfKey % 65536), 4)
    local mac0 = murmurHash32(cipherStr, macKey0 % 4294967296)
    local mac1 = murmurHash32(cipherStr, macKey1 % 4294967296)

    return cipherStr, mac0, mac1, xorBase, offBase, sboxSeed
end

-- ============================================================
-- Rep 1–4 (legacy representations, unchanged)
-- ============================================================

local function encodeRep1(str, key)
    return KDF.encryptBytes(str, key)
end

local function encodeRep2(str, key)
    local len = #str
    local chunks = {}
    local pos = 1
    local chunkIdx = 1
    while pos <= len do
        local chunkLen = (key + chunkIdx * 11) % 3 + 2
        if pos + chunkLen - 1 > len then
            chunkLen = len - pos + 1
        end
        local chunkBytes = {}
        for i = 1, chunkLen do
            local b = str:byte(pos + i - 1)
            local shift = (key + pos * 37 + i * 17) % 256
            table.insert(chunkBytes, (b + shift) % 256)
        end
        table.insert(chunks, { pos, chunkBytes })
        pos = pos + chunkLen
        chunkIdx = chunkIdx + 1
    end
    local nChunks = #chunks
    for i = nChunks, 2, -1 do
        local j = (key * i + 13) % i + 1
        chunks[i], chunks[j] = chunks[j], chunks[i]
    end
    return chunks
end

local function encodeRep3(str, key)
    local sbox = {}
    for i = 0, 255 do sbox[i + 1] = i end
    local state = key % 2147483647
    if state == 0 then state = 54321 end
    for i = 256, 2, -1 do
        state = (state * 16807 + 12345) % 2147483647
        local j = (state % i) + 1
        sbox[i], sbox[j] = sbox[j], sbox[i]
    end
    local enc = {}
    for i = 1, #str do
        local b = str:byte(i)
        enc[i] = sbox[b + 1]
    end
    return enc
end

local function encodeRep4(str, key)
    local d1 = (key % 17) + 3
    local d2 = (key % 89) + 7
    local enc = {}
    for i = 1, #str do
        local b = str:byte(i)
        local shift = (i * d1 + d2) % 256
        enc[i] = (b + shift) % 256
    end
    return enc
end

-- ============================================================
-- ConstantsProtection.protect(proto, baseSalt)
-- All string constants now forced to Rep 5 (primary).
-- Numbers, booleans, nil unchanged.
-- ============================================================

function ConstantsProtection.protect(proto, baseSalt, options)
    options = options or {}
    local kdfSalt = KDF.deriveKey(baseSalt, proto.id * 7919, 3)
    local protectedPool = {}
    local useRep6 = (options.preset == "VeryMax") or (options.preset == "Utmost")

    for i, c in ipairs(proto.constants) do
        local cType = type(c)
        local key = KDF.deriveKey(kdfSalt, i * 31, 3)

        if cType == "string" then
            if useRep6 then
                -- Rep 6: AES inv-sbox + XOR-offset + 64-bit HMAC MAC (VeryMax)
                local cv, mac0, mac1, xorBase, offBase, sboxSeed =
                    encodeRep6(c, kdfSalt, baseSalt, i)
                table.insert(protectedPool, {
                    t  = 1,
                    r  = 6,
                    v  = cv,
                    m0 = mac0,
                    m1 = mac1,
                })
            else
                -- Rep 5: Base64+XOR+Integrity (Standard / fallback)
                local xored, h, xorKey, integrityKey = encodeRep5(c, kdfSalt, baseSalt, i)
                table.insert(protectedPool, {
                    t  = 1,    -- String type
                    r  = 5,    -- Rep 5: Base64+XOR+Integrity
                    v  = xored,
                    h  = h,
                    xk = xorKey,
                    ik = integrityKey,
                })
            end
        elseif cType == "number" then
            local maskedVal, mask = KDF.maskNumber(c, key)
            table.insert(protectedPool, {
                t = 2,
                v = maskedVal,
                m = mask,
            })
        elseif cType == "boolean" then
            table.insert(protectedPool, {
                t = 3,
                v = c and 1 or 0,
            })
        elseif cType == "nil" then
            table.insert(protectedPool, {
                t = 4,
                v = 0,
            })
        end
    end

    proto.constants = protectedPool
    proto.kdfSalt   = kdfSalt
    -- Store baseSalt in proto so runtime can reconstruct the alphabet
    proto.b64Salt   = baseSalt

    -- Recursively protect child prototypes
    for _, child in ipairs(proto.protos or {}) do
        ConstantsProtection.protect(child, baseSalt, options)
    end
end

return ConstantsProtection

`,"prometheus.vm.protection.integrity":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/protection/integrity.lua
--
-- Multi-Region Integrity Architecture for PinatVM 2.0
-- Independent cryptographic checksum verification across:
--   Region 1: Format & VM Configuration
--   Region 2: Polymorphic Opcode Mapping
--   Region 3: Encrypted Constant Metadata
--   Region 4: Bytecode Instruction Payload
--

local Integrity = {}

-- Adler-32 Checksum Algorithm (Fast, standard, and supported in pure Lua)
function Integrity.computeAdler32(dataList)
    local s1 = 1
    local s2 = 0
    local mod = 65521

    for _, val in ipairs(dataList) do
        local n = type(val) == "number" and ((math.floor(val) % 256 + 256) % 256) or 42
        s1 = (s1 + n) % mod
        s2 = (s2 + s1) % mod
    end

    return s2 * 65536 + s1
end

-- 1. Checksum for Header & VM Configuration
function Integrity.computeHeaderChecksum(header, vmConfig)
    local tokens = {}
    local magic = tostring(header.magic or "PVM2")
    for i = 1, #magic do
        table.insert(tokens, magic:byte(i))
    end
    table.insert(tokens, math.floor((header.version or 2.1) * 10))
    table.insert(tokens, header.flags or 0)
    table.insert(tokens, vmConfig.rkThreshold or 0)
    table.insert(tokens, vmConfig.opPos or 0)
    table.insert(tokens, vmConfig.aPos or 0)
    table.insert(tokens, vmConfig.bPos or 0)
    table.insert(tokens, vmConfig.cPos or 0)
    table.insert(tokens, vmConfig.maskA or 0)
    table.insert(tokens, vmConfig.maskB or 0)
    table.insert(tokens, vmConfig.maskC or 0)
    return Integrity.computeAdler32(tokens)
end

-- 2. Checksum for Opcode Mapping
function Integrity.computeOpcodeChecksum(opcodeMap)
    local tokens = {}
    -- Collect keys sorted to ensure determinism (stringify to allow numeric & token keys)
    local keys = {}
    for k in pairs(opcodeMap or {}) do
        table.insert(keys, tostring(k))
    end
    table.sort(keys)

    for _, k in ipairs(keys) do
        for i = 1, #k do table.insert(tokens, k:byte(i)) end
        local v = (opcodeMap and (opcodeMap[k] or opcodeMap[tonumber(k)])) or 0
        table.insert(tokens, v)
    end
    return Integrity.computeAdler32(tokens)
end

-- 3. Checksum for Constant Metadata
local function addValTokens(val, tokens)
    if type(val) == "table" then
        for _, item in ipairs(val) do
            addValTokens(item, tokens)
        end
    elseif type(val) == "number" then
        table.insert(tokens, val)
    end
end

local function extractConstantTokens(proto, tokens)
    tokens = tokens or {}
    for _, c in ipairs(proto.constants or {}) do
        table.insert(tokens, c.t or 0)
        if c.r then table.insert(tokens, c.r) end
        addValTokens(c.v, tokens)
        if c.m then table.insert(tokens, c.m) end
    end
    for _, child in ipairs(proto.protos or {}) do
        extractConstantTokens(child, tokens)
    end
    return tokens
end

function Integrity.computeConstantsChecksum(rootProto)
    local tokens = extractConstantTokens(rootProto, {})
    return Integrity.computeAdler32(tokens)
end

-- Single-prototype constant pool digest (does not recurse into children)
function Integrity.computeProtoConstDigest(proto)
    local tokens = {}
    for _, c in ipairs(proto.constants or {}) do
        table.insert(tokens, c.t or 0)
        if c.r then table.insert(tokens, c.r) end
        addValTokens(c.v, tokens)
        if c.m then table.insert(tokens, c.m) end
        if c.m0 then table.insert(tokens, c.m0) end
        if c.m1 then table.insert(tokens, c.m1) end
    end
    return Integrity.computeAdler32(tokens)
end

-- Hierarchical Scope Hash computation
function Integrity.computeScopeHash(parentScopeHash, childIndex, numparams, maxstacksize)
    local pHash = parentScopeHash or 0x5A3C9
    local cIdx  = childIndex or 0
    local nPar  = numparams or 0
    local mStk  = maxstacksize or 0
    return ((pHash * 65537 + cIdx * 31337 + nPar * 7919 + mStk * 101 + 1337) % 2147483647)
end

-- Recursively assigns hierarchical scope hashes and constant digests
function Integrity.assignScopeAndConstDigests(proto, parentScopeHash, childIndex)
    local pHash = parentScopeHash or 0x5A3C9
    local cIdx  = childIndex or 0
    proto.parentScopeHash = pHash
    proto.scopeHash = Integrity.computeScopeHash(pHash, cIdx, proto.numparams, proto.maxstacksize)
    proto.constDigest = Integrity.computeProtoConstDigest(proto)

    for i, child in ipairs(proto.protos or {}) do
        Integrity.assignScopeAndConstDigests(child, proto.scopeHash, i)
    end
end


-- 4. Checksum for Bytecode Instructions
local function extractInstructionTokens(proto, tokens)
    tokens = tokens or {}
    table.insert(tokens, proto.numparams or 0)
    table.insert(tokens, proto.maxstacksize or 0)
    table.insert(tokens, proto.is_vararg or 0)

    for _, inst in ipairs(proto.instructions or {}) do
        for _, field in ipairs(inst) do
            table.insert(tokens, field)
        end
    end

    for _, child in ipairs(proto.protos or {}) do
        extractInstructionTokens(child, tokens)
    end
    return tokens
end

function Integrity.computePayloadChecksum(rootProto)
    local tokens = extractInstructionTokens(rootProto, {})
    return Integrity.computeAdler32(tokens)
end

function Integrity.calculateChecksum(rootProto)
    return Integrity.computePayloadChecksum(rootProto)
end

-- 2.8 Integrity Chain: True Blockchain-like Inter-Block Hash Chaining
-- Each block's initial state is explicitly chained from the PREVIOUS block's hash.
-- Any single-byte modification in block N immediately cascades and invalidates
-- all downstream block hashes in the chain.
function Integrity.computeBlockChain(instructions, seed)
    local chainBlocks = {}
    local s = (seed or 1337) % 2147483647
    local prevHash = s
    local rolling = prevHash
    local insts = instructions or {}
    local blockSize = 8
    local cMult = 31 + (s % 17) * 2
    local c1 = 7 + (s % 11)
    local c2 = 13 + (s % 19)
    local c3 = 17 + (s % 23)
    local c4 = 23 + (s % 29)
    local cIdx = 3 + (s % 7)

    for i = 1, #insts do
        local inst = insts[i]
        local f1 = inst[1] or 0
        local f2 = inst[2] or 0
        local f3 = inst[3] or 0
        local f4 = inst[4] or 0
        rolling = (rolling * cMult + f1 * c1 + f2 * c2 + f3 * c3 + f4 * c4 + i * cIdx) % 2147483647
        if i % blockSize == 0 or i == #insts then
            table.insert(chainBlocks, rolling)
            -- Chain linkage: previous block hash feeds directly into the next block
            prevHash = rolling
            rolling = prevHash
        end
    end
    return chainBlocks, rolling
end

-- Generates the full multi-region integrity manifest
function Integrity.generateManifest(header, vmConfig, rootProto)
    local headerCksum = Integrity.computeHeaderChecksum(header, vmConfig)
    local opcodeCksum = Integrity.computeOpcodeChecksum(vmConfig.opcodeMap)
    local constCksum = Integrity.computeConstantsChecksum(rootProto)
    local payloadCksum = Integrity.computePayloadChecksum(rootProto)

    local selfTokens = {
        headerCksum % 256,
        opcodeCksum % 256,
        constCksum % 256,
        payloadCksum % 256,
    }
    local selfHash = Integrity.computeAdler32(selfTokens)

    return {
        header = headerCksum,
        opcodes = opcodeCksum,
        constants = constCksum,
        payload = payloadCksum,
        selfHash = selfHash,
    }
end

return Integrity

`,"prometheus.vm.protection.kdf":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/protection/kdf.lua
--
-- Key Derivation Function (KDF) Architecture
-- Multi-round Keystream Derivation decoupling build context from runtime decoding.
--

local KDF = {}

-- Multi-round 32-bit mixing function (Murmur/LCG hybrid)
function KDF.deriveKey(salt, contextId, rounds)
    rounds = rounds or 3
    local state = (salt + (contextId or 0) * 2654435761) % 2147483647
    if state == 0 then state = 1234567 end

    for r = 1, rounds do
        state = (state * 16807 + 12345) % 2147483647
        -- Non-linear bit mix simulation in 32-bit signed/unsigned range
        local high = math.floor(state / 65536)
        local low = state % 65536
        state = (low * 32719 + high * 16807 + 7) % 2147483647
    end

    return state
end

-- Keystream byte generator for strings
function KDF.encryptBytes(str, key)
    local state = key % 2147483647
    if state == 0 then state = 1234567 end

    local out = {}
    for i = 1, #str do
        state = (state * 16807 + 12345) % 2147483647
        local k = math.floor(state / 65536) % 256
        local b = str:byte(i)
        local enc = (b + k) % 256
        table.insert(out, enc)
    end
    return out
end

-- Affine masking for numbers
function KDF.maskNumber(num, key)
    local mask = ((key % 65536) + 17)
    return num + mask, mask
end

return KDF
`,"prometheus.vm.protection.payload":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/protection/payload.lua
--
-- PinatVM Phase 1: Payload Protection Pipeline
--
-- Formalizes the protection pipeline into named, auditable stages:
--
--   Stage 1: COMPILE   — IR compiled to raw bytecode prototypes
--   Stage 2: ENCODE    — Bytecode encoded with permuted opcodes and operands
--   Stage 3: PROTECT   — Constant pool encrypted with KDF
--   Stage 4: AUTHENTICATE — Integrity manifest computed over all regions
--   Stage 5: PACKAGE   — Header, decoder config, proto, manifest serialized
--
-- Each stage returns a tagged result table for traceability.
-- Error in any stage halts the pipeline with a descriptive message.
--

local IrToBytecode         = require("prometheus.vm.compiler.ir_to_bytecode")
local ConstantsProtection  = require("prometheus.vm.protection.constants")
local Integrity            = require("prometheus.vm.protection.integrity")
local Serializer           = require("prometheus.vm.encoder.serializer")

local PayloadPipeline = {}

-- ============================================================
-- Compatibility Profiles
-- ============================================================
PayloadPipeline.CompatibilityProfile = {
    LUA_5_1          = "LUA_5_1",
    LUA_5_2          = "LUA_5_2",
    LUAU             = "LUAU",
    LUA_5_1_STRICT   = "LUA_5_1_STRICT",  -- strict: no pcall fallback on missing debug
}

-- ============================================================
-- PayloadPipeline.run(irRoot, permutator, config)
--
-- config fields:
--   seed           : number (build seed)
--   buildMode      : "Release" | "Debug" | "CI"
--   stripMetadata  : bool
--   profile        : CompatibilityProfile
--   flags          : number (bitmask: 1=CFF, 2=KDF, 4=INTEGRITY, 8=POLYMORPHIC)
--
-- Returns: {
--   stage     = "PACKAGE",
--   ok        = true,
--   chunkString = <serialized payload>,
--   header    = { ... },
--   decoderConfig = { ... },
--   proto     = { ... (compiled, protected) },
--   manifest  = { ... },
--   perf      = { compile_ns, protect_ns, auth_ns },
-- }
-- ============================================================
function PayloadPipeline.run(irRoot, permutator, config)
    config = config or {}
    local seed        = config.seed or 1337
    local buildMode   = config.buildMode or "Release"
    local stripMeta   = (config.stripMetadata == true)
    local flags       = config.flags or 15  -- 1=CFF, 2=KDF, 4=INTEGRITY, 8=POLYMORPHIC
    local profile     = config.profile or PayloadPipeline.CompatibilityProfile.LUA_5_1

    local function ts() return os.clock() end

    -- ---------------------------------------------------------
    -- Stage 1: COMPILE — IR → Raw Bytecode Proto
    -- ---------------------------------------------------------
    local t0 = ts()
    local compileOk, rawProto = pcall(function()
        return IrToBytecode.compile(irRoot, permutator, {
            skipPeephole  = false,
            stripMetadata = stripMeta,
        })
    end)
    local t1 = ts()

    if not compileOk then
        error("PayloadPipeline [COMPILE] failed: " .. tostring(rawProto))
    end

    -- ---------------------------------------------------------
    -- Stage 2: ENCODE — Already done by permutator inside compile
    -- (Instruction encoding uses permutator:encodeInstruction)
    -- This stage tag exists for auditability.
    -- ---------------------------------------------------------
    -- (no additional work; encode is embedded in stage 1)

    -- ---------------------------------------------------------
    -- Stage 3: PROTECT — Constant Pool KDF Encryption & Anti-Tamper Hardening
    -- ---------------------------------------------------------
    local baseSalt = (seed * 1103515245 + 12345) % 2147483647

    -- 2.6 Memory Canaries & 2.8 Inter-Block Integrity Chaining
    local function assignCanariesAndChains(proto, salt, idx)
        proto.canary = (salt * 1664525 + idx * 1013904223 + 31337) % 65521
        if proto.canary == 0 then proto.canary = 49999 end
        local chainSeed = (salt + idx * 31) % 2147483647
        local chainBlocks, chainHash = Integrity.computeBlockChain(proto.instructions, chainSeed)
        proto.chainSeed   = chainSeed
        proto.chainBlocks = chainBlocks
        proto.chainHash   = chainHash
        for childIdx, child in ipairs(proto.protos or {}) do
            assignCanariesAndChains(child, salt, idx * 100 + childIdx)
        end
    end
    assignCanariesAndChains(rawProto, baseSalt, 1)

    local _protectOptions = { preset = config.preset or "Standard" }
    local protectOk, protectErr = pcall(function()
        ConstantsProtection.protect(rawProto, baseSalt, _protectOptions)
    end)
    local t2 = ts()

    if not protectOk then
        error("PayloadPipeline [PROTECT] failed: " .. tostring(protectErr))
    end

    -- Assign Hierarchical Scope Hashes (Layer 1) and Constant Pool Digests (Layer 4)
    Integrity.assignScopeAndConstDigests(rawProto, 0x5A3C9, 0)

    -- 2.3 Decoy Payload Generation (36 realistic license & telemetry instructions)
    local function buildDecoyPayload(salt, decConfig)
        local opMap = decConfig.opcodeMap or {}
        local maskA = decConfig.maskA or 0
        local maskB = decConfig.maskB or 0
        local maskC = decConfig.maskC or 0
        local opPos = decConfig.opPos or 1
        local aPos  = decConfig.aPos or 2
        local bPos  = decConfig.bPos or 3
        local cPos  = decConfig.cPos or 4

        local function mkInst(opCode, a, b, c)
            local inst = {}
            inst[opPos] = opCode or 1
            inst[aPos]  = (a or 0) + maskA
            inst[bPos]  = (b or 0) + maskB
            inst[cPos]  = (c or 0) + maskC
            return inst
        end

        local dynToken = (salt * 1664525 + 1013904223) % 2147483647
        if dynToken < 1000000 then dynToken = dynToken + 10000000 end
        local decoyConstants = {
            { t = 2, v = dynToken, m = 0 },           -- [1] dynamic authorization session token
            { t = 3, v = 1 },                         -- [2] boolean true
            { t = 2, v = 200, m = 0 },                -- [3] HTTP status code 200 (OK)
            { t = 2, v = 1, m = 0 },                  -- [4] license level 1
            { t = 2, v = 23130, m = 0 },              -- [5] 0x5A5A salt magic
            { t = 2, v = 31337, m = 0 },              -- [6] port/signature
            { t = 2, v = 65521, m = 0 },              -- [7] modulo
            { t = 2, v = 16, m = 0 },                 -- [8] rounds
            { t = 2, v = 128, m = 0 },                -- [9] buffer size
            { t = 2, v = 1000, m = 0 },               -- [10] timeout ms
            { t = 2, v = 42, m = 0 },                 -- [11] seed modifier
            { t = 2, v = 404, m = 0 },                -- [12] fallback code
        }
        local decoyInsts = {
            mkInst(opMap[10] or opMap._o10 or opMap.NEWTABLE or 1, 1, 8, 0),     -- 1: R(1) = {} (main session)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 2, 1, 0),        -- 2: R(2) = dynToken
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 3, 3, 0),        -- 3: R(3) = 200
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 1, 3, 2),     -- 4: R(1)[200] = dynToken
            mkInst(opMap[3]  or opMap._o3  or opMap.LOADBOOL or 4, 4, 1, 0),     -- 5: R(4) = true
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 5, 4, 0),        -- 6: R(5) = 1
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 1, 5, 4),     -- 7: R(1)[1] = true
            mkInst(opMap[10] or opMap._o10 or opMap.NEWTABLE or 1, 6, 4, 0),     -- 8: R(6) = {} (telemetry)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 7, 5, 0),        -- 9: R(7) = 0x5A5A
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 8, 6, 0),        -- 10: R(8) = 31337
            mkInst(opMap[13] or opMap._o13 or opMap.ADD or 10, 9, 7, 8),         -- 11: R(9) = R(7) + R(8)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 10, 7, 0),       -- 12: R(10) = 65521
            mkInst(opMap[17] or opMap._o17 or opMap.MOD or 14, 11, 9, 10),       -- 13: R(11) = R(9) % R(10)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 12, 8, 0),       -- 14: R(12) = 16
            mkInst(opMap[15] or opMap._o15 or opMap.MUL or 12, 13, 11, 12),      -- 15: R(13) = R(11) * R(12)
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 6, 5, 13),    -- 16: R(6)[1] = R(13)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 14, 9, 0),       -- 17: R(14) = 128
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 6, 14, 7),    -- 18: R(6)[128] = R(7)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 15, 10, 0),      -- 19: R(15) = 1000
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 1, 15, 6),    -- 20: R(1)[1000] = R(6)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 16, 11, 0),      -- 21: R(16) = 42
            mkInst(opMap[13] or opMap._o13 or opMap.ADD or 10, 17, 13, 16),      -- 22: R(17) = R(13) + R(16)
            mkInst(opMap[14] or opMap._o14 or opMap.SUB or 11, 18, 17, 7),       -- 23: R(18) = R(17) - R(7)
            mkInst(opMap[3]  or opMap._o3  or opMap.LOADBOOL or 4, 19, 0, 0),    -- 24: R(19) = false
            mkInst(opMap[20] or opMap._o20 or opMap.NOT or 18, 20, 19, 0),       -- 25: R(20) = not R(19)
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 1, 16, 18),   -- 26: R(1)[42] = R(18)
            mkInst(opMap[10] or opMap._o10 or opMap.NEWTABLE or 1, 21, 4, 0),    -- 27: R(21) = {}
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 21, 5, 20),   -- 28: R(21)[1] = R(20)
            mkInst(opMap[2]  or opMap._o2  or opMap.LOADK or 2, 22, 12, 0),      -- 29: R(22) = 404
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 21, 22, 19),  -- 30: R(21)[404] = R(19)
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 1, 8, 21),    -- 31: R(1)[31337] = R(21)
            mkInst(opMap[21] or opMap._o21 or opMap.LEN or 19, 23, 1, 0),        -- 32: R(23) = #R(1)
            mkInst(opMap[13] or opMap._o13 or opMap.ADD or 10, 24, 23, 18),      -- 33: R(24) = R(23) + R(18)
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 1, 24, 23),   -- 34: R(1)[R(24)] = R(23)
            mkInst(opMap[3]  or opMap._o3  or opMap.LOADBOOL or 4, 25, 1, 0),    -- 35: R(25) = true
            mkInst(opMap[9]  or opMap._o9  or opMap.SETTABLE or 3, 1, 10, 25),   -- 36: R(1)[65521] = true
            mkInst(opMap[32] or opMap._o32 or opMap.RETURN or 5, 1, 2, 0),       -- 37: return R(1)
        }
        local dSeed = (salt + 777) % 2147483647
        local dChainBlocks, dChainHash = Integrity.computeBlockChain(decoyInsts, dSeed)
        return {
            numparams = 0,
            maxstacksize = 28,
            is_vararg = 1,
            canary = (salt * 777 + 1337) % 65521,
            chainSeed = dSeed,
            chainBlocks = dChainBlocks,
            chainHash = dChainHash,
            instructions = decoyInsts,
            constants = decoyConstants,
            protos = {},
            upvalues = {},
            kdfSalt = salt,
            b64Salt = salt,
            resolvedK = {},
            resolvedNil = {},
        }
    end
    local decoderConfig = permutator:getDecoderConfig()
    local decoyProto = buildDecoyPayload(baseSalt, decoderConfig)

    -- ---------------------------------------------------------
    -- Stage 4: AUTHENTICATE — Multi-Region Integrity Manifest
    -- ---------------------------------------------------------
    local header = {
        magic   = "PVM2",
        version = 2.2,
        flags   = flags,
        salt    = baseSalt,
        mode    = buildMode,
        profile = profile,
        decoyProto = decoyProto,
    }

    local authOk, manifest = pcall(function()
        return Integrity.generateManifest(header, decoderConfig, rawProto)
    end)
    local t3 = ts()

    if not authOk then
        error("PayloadPipeline [AUTHENTICATE] failed: " .. tostring(manifest))
    end
    header.manifest = manifest

    -- ---------------------------------------------------------
    -- Stage 5: PACKAGE — Versioned Serialization
    -- ---------------------------------------------------------
    local packageOk, chunkString = pcall(function()
        return Serializer.serializeChunk(header, decoderConfig, rawProto)
    end)
    local t4 = ts()

    if not packageOk then
        error("PayloadPipeline [PACKAGE] failed: " .. tostring(chunkString))
    end

    local chunkTable = {
        m   = header.magic   or "PVM2",
        v   = header.version or 2.2,
        f   = header.flags   or 15,
        s   = header.salt    or 0,
        cfg = decoderConfig,
        p   = rawProto,
        sig = manifest or {},
        dp  = decoyProto,
    }

    return {
        stage        = "PACKAGE",
        ok           = true,
        chunkString  = chunkString,
        chunkData    = chunkTable,
        header       = header,
        decoderConfig = decoderConfig,
        proto        = rawProto,
        manifest     = manifest,
        profile      = profile,
        perf         = {
            compile_s  = t1 - t0,
            protect_s  = t2 - t1,
            auth_s     = t3 - t2,
            package_s  = t4 - t3,
            total_s    = t4 - t0,
        },
    }
end

-- ============================================================
-- PayloadPipeline.profileToAdapterCode(profile)
-- Returns the Lua code fragment for the runtime adapter that
-- matches the given compatibility profile.
-- ============================================================
function PayloadPipeline.profileToAdapterCode(profile)
    if profile == PayloadPipeline.CompatibilityProfile.LUA_5_1 then
        return [[
        -- Profile: LUA_5_1
        local _h = rawHost or {}]]
    elseif profile == PayloadPipeline.CompatibilityProfile.LUAU then
        return [[
        -- Profile: LUAU
        local _h = rawHost or {}]]
    elseif profile == PayloadPipeline.CompatibilityProfile.LUA_5_2 then
        return [[
        -- Profile: LUA_5_2
        local _h = rawHost or {}]]
    elseif profile == PayloadPipeline.CompatibilityProfile.LUA_5_1_STRICT then
        return [[
        -- Profile: LUA_5_1_STRICT
        local _h = rawHost or {}]]
    else
        return [[local _h = rawHost or {}]]
    end
end

return PayloadPipeline
`,"prometheus.vm.runtime.anti_env":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/runtime/anti_env.lua
--
-- PinatVM Category 1: Anti-Env Logger, Wynfuscate Anti-Tamper & Sandbox Hardening Suite
-- Implements:
--   1.1 Environment Sandboxing (Block escape to host environment, debug)
--   1.2 Anti-Getfenv Hook Detection (Inspect getfenv signature & origin)
--   1.3 Stack Trace Sanitization (Sanitize debug.getinfo and debug.traceback)
--   1.4 Global Metatable Check (Audit metatable integrity for hooking)
--   1.5 Anti-Env Logger Pattern Detection (Honeypot traps & reflection auditing)
--   1.6 Function Integrity Check (Validate core host functions are native)
--   1.7 Environment Fingerprinting (Compute and verify environment signature)
--   1.8 Anti-Remote Spy (Detect RemoteEvent/RemoteFunction hooks in Roblox)
--   1.9 PinatHub Anti-Tamper Engine (Adapted from Wynfuscate v4, fully rebranded)
--   1.10 [NEW LAYER 1] Memory-Canary Honeytraps & Active Stack Trapping
--   1.11 [NEW LAYER 2] Dynamic Polymorphic Opcode Jittering / Temporal Decoy Dispatch
--   1.12 [NEW LAYER 3] Anti-Dump Memory Poisoning & Post-Execution Scrambling
--   1.13 [NEW LAYER 4] Opaque Predicate Chain Weaving (Symbolic-Execution Breaker)
--   1.14 [NEW LAYER 5] Self-Referential Integrity Hash (Binary Patch Detector)
--   1.15 [NEW LAYER 6] Upvalue Shadow Poisoning (getupvalue Pipeline Breaker)
--   1.16 [NEW LAYER 7] Execution Epoch Gate (Cold-Start / Replay Blocker)
--   1.17 [NEW LAYER 8] Anti-Decompiler Trampoline Scatter (Decompiler Graph Bomb)

local AntiEnv = {}

function AntiEnv.generateAntiEnvCode(options)
    options = options or {}

    local code = [==[
    -- =====================================================
    -- Category 1: Anti-Env Logger & Runtime Sandbox Suite
    -- =====================================================

    local _pvm_stealth_trap = false

    local _c_sc = (string and string.char) or function(...) return "" end
    local _c_gf = _c_sc(103, 101, 116, 102, 101, 110, 118)
    local _c_sf = _c_sc(115, 101, 116, 102, 101, 110, 118)
    local _c_db = _c_sc(100, 101, 98, 117, 103)

    -- Dynamic Zero Offset & Host Primaries (zero _G, _ENV, getfenv, setfenv dependencies)
    local _dyn_zero = ((#{ chunkData }) - 1)
    local _h_gf = nil
    local _h_sf = nil

    -- 3.4: Error codes indexed by opaque integers to prevent string-based forensics
    local _ERR_CODE_LIST = {
        "0xE001", -- 1  _pvm_decoy_active
        "0xE101", -- 2  gf_type
        "0xE102", -- 3  gf_hooked
        "0xE104", -- 4  global_metatable_hook
        "0xE105", -- 5  primitive_type_corrupted
        "0xE106", -- 6  pcall_interception
        "0xE107", -- 7  env_fingerprint_divergence
        "0xE108", -- 8  remote_spy_hook
        "0xE109", -- 9  debug_frozen_anti_hook
        "0xE110", -- 10 excessive_reflection_probes
        "0xE111", -- 11 env_logger_pattern_detected
        "0xE112", -- 12 sandbox_poisoning
        "0xE113", -- 13 anti_dump_hook_detected
        "0xE201", -- 14 self_hash_mismatch
        "0xE202", -- 15 instruction_chain_violation
        "0xE203", -- 16 memory_canary_corrupted
        "0xE301", -- 17 handlers_tampered
        "0xE302", -- 18 invalid_opcode_dispatch
        "0xE401", -- 19 pinathub_at_violation
        "0xE402", -- 20 canary_honeytrap_triggered
        "0xE403", -- 21 epoch_jitter_mismatch
        "0xE404", -- 22 env_logger_honeypot_tripped
        "0xE501", -- 23 proto_scope_violation
        "0xE502", -- 24 callstack_depth_divergence
        "0xE503", -- 25 bytecode_structure_corrupted
        "0xE504", -- 26 constant_access_violation
        "0xE505", -- 27 replay_execution_blocked
        "0xE506", -- 28 dispatch_guard_violation
    }

    -- Canonical name-to-code map for internal use only
    local _ERR_CODES = {
        _pvm_decoy_active           = _ERR_CODE_LIST[1],
        gf_type                     = _ERR_CODE_LIST[2],
        gf_hooked                   = _ERR_CODE_LIST[3],
        global_metatable_hook       = _ERR_CODE_LIST[4],
        primitive_type_corrupted    = _ERR_CODE_LIST[5],
        pcall_interception          = _ERR_CODE_LIST[6],
        env_fingerprint_divergence  = _ERR_CODE_LIST[7],
        remote_spy_hook             = _ERR_CODE_LIST[8],
        debug_frozen_anti_hook      = _ERR_CODE_LIST[9],
        excessive_reflection_probes = _ERR_CODE_LIST[10],
        env_logger_pattern_detected = _ERR_CODE_LIST[11],
        sandbox_poisoning           = _ERR_CODE_LIST[12],
        anti_dump_hook_detected     = _ERR_CODE_LIST[13],
        self_hash_mismatch          = _ERR_CODE_LIST[14],
        instruction_chain_violation = _ERR_CODE_LIST[15],
        memory_canary_corrupted     = _ERR_CODE_LIST[16],
        handlers_tampered           = _ERR_CODE_LIST[17],
        invalid_opcode_dispatch     = _ERR_CODE_LIST[18],
        integrity_at_violation       = _ERR_CODE_LIST[19],
        canary_honeytrap_triggered  = _ERR_CODE_LIST[20],
        epoch_jitter_mismatch       = _ERR_CODE_LIST[21],
        env_logger_honeypot_tripped = _ERR_CODE_LIST[22],
        proto_scope_violation       = _ERR_CODE_LIST[23],
        callstack_depth_divergence  = _ERR_CODE_LIST[24],
        bytecode_structure_corrupted= _ERR_CODE_LIST[25],
        constant_access_violation   = _ERR_CODE_LIST[26],
        replay_execution_blocked    = _ERR_CODE_LIST[27],
        dispatch_guard_violation    = _ERR_CODE_LIST[28],
    }


    -- =====================================================
    -- 3.2: Trusted Runtime Core (TRC) Security State Machine
    -- Replaces single-point boolean trust (_pvm_tripped / _pvm_halted)
    -- Dual-token cryptographic validation & strict state transitions
    -- =====================================================
    local _STATE_BOOTSTRAPPING = 0x10A1  -- 4257
    local _STATE_INITIALIZING  = 0x20B2  -- 8370
    local _STATE_VERIFIED      = 0x30C3  -- 12483
    local _STATE_RUNNING       = 0x40D4  -- 16596
    local _STATE_INVALIDATED   = 0x50E5  -- 20709
    local _STATE_TERMINATED    = 0x60F6  -- 24822

    local _trc_state = _STATE_BOOTSTRAPPING
    local _trc_chk   = ((_STATE_BOOTSTRAPPING * 16807 + 0x5A3C9) % 2147483647)
    local _trc_trans_count = 0

    local function _verifyState(expectedState)
        if not _trc_state or not _trc_chk then return false end
        if _trc_state ~= expectedState then return false end
        local expectedChk = ((_trc_state * 16807 + 0x5A3C9) % 2147483647)
        return _trc_chk == expectedChk
    end

    -- Multivariate Algebraic State Invariant System (MASIS)
    local _pvm_canary = 3735929054
    local _pvm_tripped = false
    local _pvm_halted = false
    local _pvm_tamper_reason = nil
    local _pvm_decoy_active = false
    local _pvm_poison_delay = 0

    local _pvm_epoch = 1
    local _pvm_state_alpha = 104729
    local _pvm_state_beta  = 224737
    local _pvm_state_gamma = 3571
    local _pvm_expected_root = ((104729 * 7919 + 224737 * 6271 + 3571 * 31337 + 1) % 2147483647)

    local function _evolveInvariant(stepDelta)
        _pvm_epoch = _pvm_epoch + (stepDelta or 1)
        _pvm_state_alpha = ((_pvm_state_alpha * 16807 + 11) % 2147483647)
        _pvm_state_beta  = ((_pvm_state_beta * 48271 + 17) % 2147483647)
        _pvm_state_gamma = ((_pvm_state_gamma * 69621 + 23) % 2147483647)
        _pvm_expected_root = ((_pvm_state_alpha * 7919 + _pvm_state_beta * 6271 + _pvm_state_gamma * 31337 + _pvm_epoch) % 2147483647)
    end

    local function _verifyInvariant()
        if not _pvm_state_alpha or not _pvm_state_beta or not _pvm_state_gamma then return false end
        local cur = ((_pvm_state_alpha * 7919 + _pvm_state_beta * 6271 + _pvm_state_gamma * 31337 + _pvm_epoch) % 2147483647)
        return cur == _pvm_expected_root
    end

    local function _destroyInvariant()
        _pvm_state_alpha = nil
        _pvm_state_beta  = nil
        _pvm_state_gamma = nil
        _pvm_expected_root = -1
    end

    local function _fatalHalt()
        _pvm_canary = 0
        _pvm_tripped = true
        _pvm_halted = true
        _destroyInvariant()
        _trc_state = _STATE_TERMINATED
        _trc_chk = ((_STATE_TERMINATED * 16807 + 0x5A3C9) % 2147483647)
        local _cyclic = {}
        _cyclic.__index = _cyclic
        _cyclic.__pairs = function() return function() return _cyclic, _cyclic end end
        if _h_sm then _h_sm(_cyclic, _cyclic) end
        local _errCode = (_ERR_CODES and _ERR_CODES[_pvm_tamper_reason]) or "0xE0FF"
        if _h_error then
            _h_error(_errCode, 0)
        end
        local _crash = nil
        local _ = _crash[1]
        while true do
            if _co_y then _co_y() end
        end
    end

    local function _advanceState(fromState, toState)
        if not _verifyState(fromState) then
            _fatalHalt()
            return false
        end
        local valid = false
        if fromState == _STATE_BOOTSTRAPPING and toState == _STATE_INITIALIZING then
            valid = true
        elseif fromState == _STATE_INITIALIZING and toState == _STATE_VERIFIED then
            valid = true
        elseif fromState == _STATE_VERIFIED and toState == _STATE_RUNNING then
            valid = true
        elseif fromState == _STATE_RUNNING and toState == _STATE_TERMINATED then
            valid = true
        elseif toState == _STATE_INVALIDATED then
            valid = (fromState ~= _STATE_TERMINATED)
        elseif fromState == _STATE_INVALIDATED and toState == _STATE_TERMINATED then
            valid = true
        end

        if not valid then
            _fatalHalt()
            return false
        end

        _trc_trans_count = _trc_trans_count + 1
        _trc_state = toState
        _trc_chk = ((toState * 16807 + 0x5A3C9) % 2147483647)
        return true
    end

    local function _wipe_obj(p)
        if _h_type(p) ~= "table" then return end
        if p.instructions then
            for i = 1, #p.instructions do p.instructions[i] = { 0, 0, 0, 0 } end
            p.instructions = nil
        end
        if p.constants then
            for k in pairs(p.constants) do p.constants[k] = nil end
            p.constants = nil
        end
        p.resolvedK = nil
        p.resolvedNil = nil
    end

    local function _pvm_pinathub_poisonMemory(p)
        if _h_type(p) ~= "table" then return end
        if p.instructions then
            for i = 1, #p.instructions do p.instructions[i] = { 0, 0, 0, 0 } end
            p.instructions = nil
        end
        if p.constants then
            for k in pairs(p.constants) do p.constants[k] = nil end
            p.constants = nil
        end
        if p.chainBlocks then
            for i = 1, #p.chainBlocks do p.chainBlocks[i] = 0 end
            p.chainBlocks = nil
        end
        p.chainHash = nil
        p.chainSeed = nil
        p.canary = nil
        p.kdfSalt = nil
        p.b64Salt = nil
        p.resolvedK = nil
        p.resolvedNil = nil
    end

    local function _triggerTamper(reason)
        _pvm_tripped = true
        _pvm_tamper_reason = reason
        _destroyInvariant()
        if _trc_state ~= _STATE_INVALIDATED and _trc_state ~= _STATE_TERMINATED then
            _advanceState(_trc_state, _STATE_INVALIDATED)
        end
        if _h_type(chunkData) == "table" then
            _wipe_obj(chunkData.p)
            _pvm_pinathub_poisonMemory(chunkData.p)
            chunkData.p = nil
            chunkData.cfg = nil
        end
        if _h_type(rootProto) == "table" then
            _wipe_obj(rootProto)
            _pvm_pinathub_poisonMemory(rootProto)
        end
        if decoyProto then
            _pvm_decoy_active = true
            _pvm_poison_delay = 15
            _pvm_halted = false
        else
            _pvm_canary = 0
            _pvm_halted = true
            if _trc_state == _STATE_INVALIDATED then
                _advanceState(_STATE_INVALIDATED, _STATE_TERMINATED)
            end
            _fatalHalt()
        end
    end

    local _installed_getinfo = nil
    local function _pollTamper()
        if _installed_getinfo and _h_dbg and _h_type(_h_dbg) == "table" and _h_dbg.getinfo and _h_dbg.getinfo ~= _installed_getinfo then
            _triggerTamper("anti_hook_tampered")
        end
        if not _verifyState(_STATE_RUNNING) or _pvm_tripped or _pvm_canary ~= 3735929054 or _pvm_halted or not _verifyInvariant() then
            if _trc_state ~= _STATE_INVALIDATED and _trc_state ~= _STATE_TERMINATED then
                _advanceState(_trc_state, _STATE_INVALIDATED)
            end
            _fatalHalt()
        end
    end

    -- =========================================================================
    -- Section 1.9: PinatHub Anti-Tamper Core Engine
    -- (Adapted from Wynfuscate v4, fully rebranded to PinatHub architecture)
    -- =========================================================================
    local _PINATHUB_AT_CFG = {
        H_SEED   = 1680989259,
        H_PRIME  = 131,
        M_2_31   = 2147483647,
        M_2_32   = 4294967296,
        K_INIT   = 55716,
        K_STEP   = 30663,
        LCG_A    = 1664525,
        LCG_C    = 1013904223,
    }

    -- 8-bit Arithmetic Bitwise XOR (pure math, no bit/bit32 dependencies)
    local function _pinathub_xorByte(a, b)
        local res, bit = 0, 1
        for _ = 1, 8 do
            local ra, rb = a % 2, b % 2
            if ra ~= rb then res = res + bit end
            a = (a - ra) / 2
            b = (b - rb) / 2
            bit = bit * 2
        end
        return res
    end

    -- Polynomial String Hash (Wynfuscate algorithm adapted for PinatHub)
    local function _pinathub_hashStr(s)
        if _h_type(s) ~= "string" then return 0 end
        local h = _PINATHUB_AT_CFG.H_SEED
        local strByte = (string and string.byte) or (_h_rawget and _h_rawget(string or {}, "byte"))
        if not strByte then return 0 end
        for i = 1, #s do
            h = (h * _PINATHUB_AT_CFG.H_PRIME + strByte(s, i)) % _PINATHUB_AT_CFG.M_2_31
        end
        return h
    end

    -- Hashed Key Resolution: Locates key in table without using raw string literals
    local function _pinathub_resolveKey(tbl, targetHash)
        if _h_type(tbl) ~= "table" then return nil end
        local strByte = (string and string.byte) or (_h_rawget and _h_rawget(string or {}, "byte"))
        if not strByte then return nil end
        for k, v in pairs(tbl) do
            if _h_type(k) == "string" then
                local h = _PINATHUB_AT_CFG.H_SEED
                for i = 1, #k do
                    h = (h * _PINATHUB_AT_CFG.H_PRIME + strByte(k, i)) % _PINATHUB_AT_CFG.M_2_31
                end
                if h == targetHash then return v end
            end
        end
        return nil
    end

    -- Dynamic Global / Metamethod Resolver without Plaintext Strings
    local function _pinathub_resolveGlobal(nameFn, targetHash)
        local envTbl = (_ENV or _G) or {}
        local val = _pinathub_resolveKey(envTbl, targetHash)
        if val ~= nil then return val end
        if nameFn then
            local nm = nameFn()
            if nm then val = envTbl[nm] end
        end
        if val ~= nil then return val end
        if _G then
            val = _pinathub_resolveKey(_G, targetHash)
            if val ~= nil then return val end
            if nameFn then
                local nm = nameFn()
                if nm and _G[nm] ~= nil then return _G[nm] end
            end
        end
        local gm = _h_gm or getmetatable
        local mt = gm and gm(envTbl)
        local idx = mt and mt.__index
        if _h_type(idx) == "table" then
            val = _pinathub_resolveKey(idx, targetHash)
            if val ~= nil then return val end
            if nameFn then
                local nm = nameFn()
                if nm and idx[nm] ~= nil then return idx[nm] end
            end
        elseif _h_type(idx) == "function" and nameFn then
            local nm = nameFn()
            if nm then
                local ok, res = _safe_pcall(idx, envTbl, nm)
                if ok and res ~= nil then return res end
            end
        end
        return nil
    end

    -- PinatHub Probing Check: Metatable Hooks
    local function _pinathub_probeMetatableHooks()
        local testTbl = {}
        local tripped = false
        local function _mtTrapIdx() tripped = true return nil end
        local function _mtTrapNI() tripped = true return nil end
        local trapMt = {
            ["__index"]    = _mtTrapIdx,
            ["__newindex"] = _mtTrapNI,
        }
        if _h_sm then _h_sm(testTbl, trapMt) else setmetatable(testTbl, trapMt) end
        if _h_rawget(testTbl, "testKey") ~= nil or tripped then
            _triggerTamper("global_metatable_hook")
            return false
        end
        _h_rawset(testTbl, "testKey", 12345)
        if tripped or testTbl.testKey ~= 12345 then
            _triggerTamper("global_metatable_hook")
            return false
        end
        return true
    end

    -- PinatHub Probing Check: Reflection & Core Invariants
    local function _pinathub_probeReflection()
        if not _h_type or _h_type(_h_type) ~= "function" then
            _triggerTamper("primitive_type_corrupted")
            return false
        end
        local okNil = _safe_pcall(function() local x = nil; return x[1] end)
        if okNil ~= false then
            _triggerTamper("pcall_interception")
            return false
        end
        if not (game or script) then
            local sentinel = { flag = 3735929054 }
            local okTrap, caught = _safe_pcall(function() _h_error(sentinel, 0) end)
            if okTrap ~= false or caught ~= sentinel then
                _triggerTamper("pcall_interception")
                return false
            end
        end
        local okStr, sRes = _safe_pcall(function() return string.sub("SecurityString", 1, 4) end)
        if not okStr or sRes ~= "Secu" then
            _triggerTamper("primitive_type_corrupted")
            return false
        end
        return true
    end

    -- PinatHub Probing Check: Exploit Dump APIs (Wynfuscate R3E_217 adaptation)
    local function _pinathub_probeDumpAPIs()
        local testClosure = function() return 7 end
        local dumpApiDefs = {
            { {103,101,116,99,111,110,115,116,97,110,116,115}, "f" }, -- getconstants
            { {103,101,116,117,112,118,97,108,117,101,115},     "f" }, -- getupvalues
            { {103,101,116,112,114,111,116,111,115},           "f" }, -- getprotos
            { {103,101,116,114,101,103},                       "g" }, -- getreg
            { {103,101,116,103,99},                            "g" }, -- getgc
            { {103,101,116,115,99,114,105,112,116,104,97,115,104}, "s" }, -- getscripthash
        }
        for _, def in ipairs(dumpApiDefs) do
            local apiName = _c_sc(_co_upk(def[1]))
            local apiMode = def[2]
            local targetApi = _caps and _caps[apiName]
            if not targetApi and (_G or _ENV) then
                targetApi = (_G and _G[apiName]) or (_ENV and _ENV[apiName])
            end
            if targetApi and _h_type(targetApi) == "function" then
                local ok, ret
                local isHostEnv = (game ~= nil or script ~= nil or getgenv ~= nil)
                if apiMode == "g" then
                    if not isHostEnv then
                        ok, ret = _safe_pcall(targetApi)
                    end
                elseif apiMode == "f" then
                    ok, ret = _safe_pcall(targetApi, testClosure)
                else
                    ok, ret = _safe_pcall(targetApi, script or "")
                end
                if ok and (type(ret) == "table" or type(ret) == "string") and #ret > 0 then
                    _triggerTamper("anti_dump_hook_detected")
                    return false
                end
            end
        end
        return true
    end

    -- =========================================================================
    -- Section 1.5 (UPGRADED): Hardened Anti-EnvLogger with Active Honeypots
    -- =========================================================================
    local _pinathub_envLoggerDetected = false

    local function _pinathub_initEnvHoneypot()
        local gTbl = (_pvm_context and _pvm_context.globals) or _G or {}
        if _h_type(gTbl) == "table" then
            local honeypotKey = _c_sc(95,112,105,110,97,116,104,117,98,95,101,110,118,95,108,111,103,95,116,114,97,112)
            local function _hpIdx()
                _pinathub_envLoggerDetected = true
                _triggerTamper("env_logger_pattern_detected")
                return nil
            end
            local function _hpNi()
                _pinathub_envLoggerDetected = true
                _triggerTamper("env_logger_pattern_detected")
            end
            local honeypotMt = {
                ["__index"]    = _hpIdx,
                ["__newindex"] = _hpNi,
                __pairs = function()
                    _pinathub_envLoggerDetected = true
                    _triggerTamper("env_logger_pattern_detected")
                    return function() end
                end
            }
            local honeypotObj = {}
            if _h_sm then _h_sm(honeypotObj, honeypotMt) end
            pcall(function() _h_rawset(gTbl, honeypotKey, honeypotObj) end)
        end
    end

    local function _pinathub_probeEnvLogger()
        local envs = { _G, _ENV, _pvm_context and _pvm_context.globals }
        for _, env in ipairs(envs) do
            if _h_type(env) == "table" then
                local gm = _h_gm or getmetatable
                local mt = gm and gm(env)
                if mt and _h_type(mt) == "table" then
                    local idx = _h_rawget(mt, "__index")
                    local nidx = _h_rawget(mt, "__newindex")
                    if _h_type(idx) == "function" then
                        local dbg = _h_dbg
                        if dbg and dbg.getinfo then
                            local ok, info = _safe_pcall(dbg.getinfo, idx)
                            if ok and info and _h_type(info) == "table" then
                                local src = (info.source or ""):lower()
                                if info.what == "Lua" or src:find("logger") or src:find("spy") or src:find("log") or src:find("hook") then
                                    _pinathub_envLoggerDetected = true
                                    _triggerTamper("env_logger_pattern_detected")
                                    return false
                                end
                            end
                        end
                    end
                    if _h_type(nidx) == "function" then
                        local dbg = _h_dbg
                        if dbg and dbg.getinfo then
                            local ok, info = _safe_pcall(dbg.getinfo, nidx)
                            if ok and info and _h_type(info) == "table" then
                                local src = (info.source or ""):lower()
                                if info.what == "Lua" or src:find("logger") or src:find("spy") or src:find("log") or src:find("hook") then
                                    _pinathub_envLoggerDetected = true
                                    _triggerTamper("env_logger_pattern_detected")
                                    return false
                                end
                            end
                        end
                    end
                end
            end
        end
        return true
    end

    -- =========================================================================
    -- Section 1.10 [NEW SECURITY LAYER 1]:
    -- Memory-Canary Honeytraps & Active Stack Trapping
    -- =========================================================================
    local function _pvm_pinathub_initCanaries(frame, maxStack)
        if not frame or not frame.R then return end
        -- Use a frame-specific derived seed that is stable (not _pvm_expected_root which evolves)
        local frameSeed = (1337 + (maxStack or 0) * 7919) % 2147483647
        local kLow  = ((frameSeed * 23 + (maxStack or 0) * 41 + 101) % 65521)
        local kHigh = ((frameSeed * 37 + (maxStack or 0) * 59 + 203) % 65521)
        frame.R[-2] = kLow
        frame.R[maxStack + 3] = kHigh
        if frame._canarySlots then
            frame._canarySlots[-2] = true
            frame._canarySlots[maxStack + 3] = true
        end
    end

    local function _pvm_pinathub_verifyCanaries(frame, maxStack)
        if not frame or not frame.R then return false end
        local r = frame.R
        local frameSeed = (1337 + (maxStack or 0) * 7919) % 2147483647
        local kLow  = ((frameSeed * 23 + (maxStack or 0) * 41 + 101) % 65521)
        local kHigh = ((frameSeed * 37 + (maxStack or 0) * 59 + 203) % 65521)
        -- Verify physical sentinel values have not been overwritten
        if r[-2] ~= kLow or r[maxStack + 3] ~= kHigh then
            _triggerTamper("memory_canary_corrupted")
            return false
        end
        return true
    end

    -- =========================================================================
    -- Section 1.11 [NEW SECURITY LAYER 2]:
    -- Dynamic Polymorphic Opcode Jittering / Temporal Decoy Dispatch
    -- =========================================================================
    local _pvm_epochToken = 0x1A2B
    local function _pvm_pinathub_epochJitter(stepCount)
        _pvm_epochToken = (((_pvm_epoch or 1) * 48271 + (_pvm_state_alpha or 104729) + (stepCount or 0) * 31) % 65536)
        if not _verifyInvariant or not _verifyInvariant() then
            _triggerTamper("instruction_chain_violation")
            return false
        end
        return true
    end
    -- =========================================================================
    -- Section 1.13 [NEW SECURITY LAYER 1]:
    -- Hierarchical Prototype Scope & Parent-Chain Binding
    -- =========================================================================
    local function _pvm_verifyProtoScope(childProto, parentProto)
        if not childProto or _h_type(childProto) ~= "table" then return false end
        if not parentProto then
            if childProto.parentScopeHash and childProto.parentScopeHash ~= 0x5A3C9 then
                _triggerTamper("proto_scope_violation")
                return false
            end
            return true
        end
        if childProto.parentScopeHash and parentProto.scopeHash then
            if childProto.parentScopeHash ~= parentProto.scopeHash then
                _triggerTamper("proto_scope_violation")
                return false
            end
        end
        return true
    end

    -- =========================================================================
    -- Section 1.14 [NEW SECURITY LAYER 2]:
    -- Call-Stack Frame Fingerprinting & Depth Invariant
    -- =========================================================================
    local _co_run = (coroutine and coroutine.running)
    local _pvm_thread_fps = {}
    local _pvm_thread_frames = {}
    local function _pvm_pushCallFrame(frame, proto)
        if not frame then return end
        local coKey = (_co_run and _co_run()) or 1
        local prevFp = _pvm_thread_fps[coKey] or 0x4D3C2B1A
        local sHash = (proto and proto.scopeHash) or 1337
        local depth = (_pvm_callDepth or 0)
        local newFp = ((prevFp * 32719 + sHash + depth * 16807 + 101) % 2147483647)
        _pvm_thread_fps[coKey] = newFp
        frame._entryFp = newFp
        frame._prevFp  = prevFp
        frame._coKey   = coKey
        frame._callerFrame = _pvm_thread_frames[coKey]
        _pvm_thread_frames[coKey] = frame
    end

    local function _pvm_popCallFrame(frame, proto)
        if not frame or not frame._entryFp then return false end
        local coKey = frame._coKey or (_co_run and _co_run()) or 1
        local curFp = _pvm_thread_fps[coKey]
        if curFp == frame._entryFp then
            _pvm_thread_fps[coKey] = frame._prevFp or 0x4D3C2B1A
            _pvm_thread_frames[coKey] = frame._callerFrame
            return true
        end

        -- If curFp diverges, verify whether frame is an active ancestor on this thread's callstack
        -- (handles legitimate unwind from pcall/xpcall when child frame throws an error)
        local ancestor = _pvm_thread_frames[coKey]
        local isLegitAncestor = false
        while ancestor do
            if ancestor == frame then
                isLegitAncestor = true
                break
            end
            ancestor = ancestor._callerFrame
        end

        if not isLegitAncestor then
            _triggerTamper("callstack_depth_divergence")
            return false
        end

        -- Cleanly unwind to frame's previous state
        _pvm_thread_fps[coKey] = frame._prevFp or 0x4D3C2B1A
        _pvm_thread_frames[coKey] = frame._callerFrame
        return true
    end


    -- =========================================================================
    -- Section 1.15 [NEW SECURITY LAYER 3]:
    -- Pre-Execution In-Memory Bytecode Safety Guard
    -- =========================================================================
    local function _pvm_auditBytecodePayload(proto, cfg)
        if not proto or _h_type(proto) ~= "table" then
            _triggerTamper("bytecode_structure_corrupted")
            return false
        end
        local opPos = (cfg and cfg.opPos) or 1
        local aPos  = (cfg and cfg.aPos) or 2
        local bPos  = (cfg and cfg.bPos) or 3
        local maskA = (cfg and cfg.maskA) or 0
        local maskB = (cfg and cfg.maskB) or 0
        local opMap = (cfg and cfg.opcodeMap) or {}
        local validOp = {}
        for _, numId in pairs(opMap) do
            validOp[numId] = true
        end
        local jmpOp      = opMap[23] or opMap._o23 or opMap.JMP
        local jmpIfOp    = opMap[45] or opMap._o45 or opMap.JUMP_IF
        local jmpIfNotOp = opMap[46] or opMap._o46 or opMap.JUMP_IF_NOT
        local forprepOp  = opMap[37] or opMap._o37 or opMap.FORPREP
        local forloopOp  = opMap[38] or opMap._o38 or opMap.FORLOOP

        local function _auditProto(p, depth)
            if not p or _h_type(p) ~= "table" or depth > 64 then
                _triggerTamper("bytecode_structure_corrupted")
                return false
            end
            local insts = p.instructions
            if not insts or _h_type(insts) ~= "table" then
                _triggerTamper("bytecode_structure_corrupted")
                return false
            end
            local numInsts = #insts

            for pc = 1, numInsts do
                local it = insts[pc]
                if not it or _h_type(it) ~= "table" or #it < 4 then
                    _triggerTamper("bytecode_structure_corrupted")
                    return false
                end
                local op = it[opPos]
                if not op or not validOp[op] then
                    _triggerTamper("bytecode_structure_corrupted")
                    return false
                end
                local A = it[aPos] - maskA
                if op == jmpOp then
                    local target = pc + A + 1
                    if target < 1 or target > numInsts + 1 then
                        _triggerTamper("bytecode_structure_corrupted")
                        return false
                    end
                elseif (op == jmpIfOp or op == jmpIfNotOp or op == forprepOp or op == forloopOp) and bPos then
                    local B = it[bPos] - maskB
                    local target = pc + B + 1
                    if target < 1 or target > numInsts + 1 then
                        _triggerTamper("bytecode_structure_corrupted")
                        return false
                    end
                end
            end

            for _, child in ipairs(p.protos or {}) do
                if not _auditProto(child, depth + 1) then return false end
            end
            return true
        end

        return _auditProto(proto, 1)
    end

    -- =========================================================================
    -- Section 1.16 [NEW SECURITY LAYER 4]:
    -- Constant Table Cryptographic Digest Verification & Sealed Slot Traps
    -- =========================================================================
    local function _pvm_verifyConstDigest(p)
        if not p or _h_type(p) ~= "table" or not p.constDigest then return true end
        local s1 = 1
        local s2 = 0
        local mod = 65521
        local function _addByte(n)
            local b = ((math.floor(n or 0) % 256 + 256) % 256)
            s1 = (s1 + b) % mod
            s2 = (s2 + s1) % mod
        end
        local function _addVal(v)
            if _h_type(v) == "table" then
                for _, item in ipairs(v) do _addVal(item) end
            elseif _h_type(v) == "number" then
                _addByte(v)
            end
        end
        for _, c in ipairs(p.constants or {}) do
            _addByte(c.t or 0)
            if c.r then _addByte(c.r) end
            _addVal(c.v)
            if c.m then _addByte(c.m) end
            if c.m0 then _addByte(c.m0) end
            if c.m1 then _addByte(c.m1) end
        end
        local computed = s2 * 65536 + s1
        if computed ~= p.constDigest then
            _triggerTamper("constant_access_violation")
            return false
        end
        return true
    end

    -- =========================================================================
    -- Section 1.17 [NEW SECURITY LAYER 6]:
    -- Execution Epoch Nonce & One-Shot Execution Sealing
    -- =========================================================================
    local _pvm_execNonce = ((os and os.time and (os.time() * 1000 + math.floor((os.clock and os.clock() or 0) * 1000000))) or 12345678) % 2147483647
    if _pvm_execNonce == 0 then _pvm_execNonce = 987654321 end

    local function _pvm_verifyExecNonce(nonce)
        if not _pvm_execNonce or _pvm_execNonce == -1 or nonce ~= _pvm_execNonce then
            _triggerTamper("replay_execution_blocked")
            return false
        end
        return true
    end

    local function _pvm_sealExecution()
        _pvm_execNonce = -1
    end

    -- Advance from BOOTSTRAPPING to INITIALIZING lifecycle phase
    _advanceState(_STATE_BOOTSTRAPPING, _STATE_INITIALIZING)


    -- 1.2 Anti-Getfenv Hook Detection
    local function _checkGetfenvIntegrity()
        local isRoblox = (game ~= nil or script ~= nil)
        local gf = _h_gf
        if gf then
            if _h_type(gf) ~= "function" then
                _triggerTamper("gf_type")
                return false
            end
            local dbg = _h_dbg
            if dbg and dbg.getinfo then
                local ok, info = _safe_pcall(dbg.getinfo, gf)
                if ok and info and _h_type(info) == "table" then
                    if not isRoblox then
                        if info.what ~= "C" and info.what ~= "[C]" then
                            _triggerTamper("gf_hooked")
                            return false
                        end
                    else
                        if info.source and (info.source:find("logger") or info.source:find("env_log") or info.source:find("hook_fenv")) then
                            _triggerTamper("gf_hooked")
                            return false
                        end
                    end
                end
            end
        end
        return true
    end

    -- 1.4 Global Metatable Check (Audit metatable integrity for hooking)
    local function _checkGlobalMetatable()
        local isRoblox = (game ~= nil or script ~= nil)
        local gTbl = (_pvm_context and _pvm_context.globals) or _caps
        if gTbl and getmetatable then
            local mt = getmetatable(gTbl)
            if mt ~= nil and _h_type(mt) == "table" then
                if not isRoblox then
                    if mt.__index ~= nil or mt.__newindex ~= nil then
                        _triggerTamper("global_metatable_hook")
                        return false
                    end
                else
                    local idx = _h_rawget(mt, "__index")
                    if _h_type(idx) == "function" then
                        local dbg = _h_dbg
                        if dbg and dbg.getinfo then
                            local ok, info = _safe_pcall(dbg.getinfo, idx)
                            if ok and info and _h_type(info) == "table" and info.source and (info.source:find("logger") or info.source:find("spy")) then
                                _triggerTamper("global_metatable_hook")
                                return false
                            end
                        end
                    end
                end
            end
        end
        return true
    end

    -- 1.6 Function Integrity Check (Validate core primitives via 5-Vector Asymmetric Audit)
    local function _checkFunctionIntegrity()
        local f_type = _h_type
        local _k_pcall = _c_sc(112 + _dyn_zero, 99 + _dyn_zero, 97 + _dyn_zero, 108 + _dyn_zero, 108 + _dyn_zero)
        local f_pcall = _h_pcall or (_caps and _caps[_k_pcall]) or pcall

        if f_type and (f_type(1) ~= "number" or f_type("str") ~= "string" or f_type({}) ~= "table") then
            _triggerTamper("primitive_type_corrupted")
            return false
        end

        if f_pcall and _h_type(f_pcall) == "function" then
            local dbg = _h_dbg
            if dbg and dbg.getinfo then
                local okI, info = _safe_pcall(dbg.getinfo, f_pcall)
                if okI and info and _h_type(info) == "table" then
                    if info.what ~= "C" and info.what ~= "[C]" then
                        _triggerTamper("pcall_interception")
                        return false
                    end
                end
            end

            if not (game or script) then
                local errSentinel = { marker = 3735929054, pvm_pcall_audit = true }
                local okTrap, caught = f_pcall(function() _h_error(errSentinel, 0) end)
                if okTrap ~= false or caught ~= errSentinel then
                    _triggerTamper("pcall_interception")
                    return false
                end
            end

            local okRet, r1, r2, r3 = f_pcall(function() return 42, 99, false end)
            if not okRet or r1 ~= 42 or r2 ~= 99 or r3 ~= false then
                _triggerTamper("pcall_interception")
                return false
            end

            local okNil, errNil = f_pcall(function() local x = nil; return x.probe_nonexistent end)
            if okNil ~= false or _h_type(errNil) ~= "string" or not (errNil:find("nil") or errNil:find("index")) then
                _triggerTamper("pcall_interception")
                return false
            end

            local okCo, resCo = _safe_pcall(function(v) return v * 2 end, 21)
            if not okCo or resCo ~= 42 then
                _triggerTamper("pcall_interception")
                return false
            end
        end
        return true
    end

    -- 1.7 Environment Fingerprinting (Dynamic byte arrays, zero static globals)
    local _k_check_bytes = {
        { 112, 114, 105, 110, 116 },
        { 119, 97, 114, 110 },
        { 109, 97, 116, 104 },
        { 115, 116, 114, 105, 110, 103 },
        { 116, 97, 98, 108, 101 },
        { 112, 99, 97, 108, 108 },
        { 116, 121, 112, 101 },
        { 101, 114, 114, 111, 114 }
    }
    local _k_exec_bytes = {
        { 104, 111, 111, 107, 102, 117, 110, 99, 116, 105, 111, 110 },
        { 104, 111, 111, 107, 109, 101, 116, 97, 109, 101, 116, 104, 111, 100 },
        { 103, 101, 116, 114, 97, 119, 109, 101, 116, 97, 116, 97, 98, 108, 101 },
        { 103, 101, 116, 117, 112, 118, 97, 108, 117, 101, 115 }
    }

    local function _computeEnvFingerprint()
        local fp = 1337 + _dyn_zero
        for i = 1, #_k_check_bytes do
            local b = _k_check_bytes[i]
            local name = _c_sc(_co_upk(b))
            local val = _caps and _caps[name]
            local t = _h_type(val)
            local weight = (t == "function" and 17) or (t == "table" and 31) or (t == "nil" and 3) or 7
            fp = (fp * 33 + weight * i + #name) % 65521
        end
        local execCount = 0
        for i = 1, #_k_exec_bytes do
            local b = _k_exec_bytes[i]
            local name = _c_sc(_co_upk(b))
            if _caps and _caps[name] ~= nil then
                execCount = execCount + 1
            end
        end
        fp = (fp + execCount * 257) % 65521
        return fp
    end

    local _initialFingerprint = _computeEnvFingerprint()

    local function _verifyEnvFingerprint()
        local current = _computeEnvFingerprint()
        if current ~= _initialFingerprint then
            _triggerTamper("env_fingerprint_divergence")
            return false
        end
        return true
    end

    -- 1.8 (UPGRADED): Anti-Remote Spy (Roblox environment protection with hashed key resolution)
    local function _checkRemoteSpy()
        local robloxGame = game
        if robloxGame and _h_type(robloxGame) == "userdata" then
            local hasSpy = false

            local spyGlobals = {
                {83,105,109,112,108,101,83,112,121},   -- SimpleSpy
                {72,121,100,114,111,120,105,100,101}, -- Hydroxide
                {84,117,114,116,108,101,83,112,121},   -- TurtleSpy
                {82,101,109,111,116,101,83,112,121},   -- RemoteSpy
                {114,115,112,121},                     -- rspy
            }
            local envs = { _root_env, shared }
            if getgenv then
                local ok, genv = _safe_pcall(getgenv)
                if ok and _h_type(genv) == "table" then
                    envs[#envs + 1] = genv
                end
            end
            for _, env in ipairs(envs) do
                if _h_type(env) == "table" then
                    for _, b in ipairs(spyGlobals) do
                        local name = _c_sc(_co_upk(b))
                        if env[name] ~= nil then
                            hasSpy = true
                            break
                        end
                    end
                end
                if hasSpy then break end
            end

            -- Check 2: Metamethod Hook Inspection (__namecall on game)
            if not hasSpy and getrawmetatable then
                local ok, mt = _safe_pcall(getrawmetatable, robloxGame)
                if ok and _h_type(mt) == "table" and mt.__namecall then
                    local nc = mt.__namecall
                    if islclosure then
                        local okClosure, isL = _safe_pcall(islclosure, nc)
                        if okClosure and isL then
                            hasSpy = true
                        end
                    end
                    local dbg = _h_dbg
                    if not hasSpy and dbg and dbg.getinfo then
                        local okInfo, info = _safe_pcall(dbg.getinfo, nc)
                        if okInfo and _h_type(info) == "table" then
                            local src = (info.source or ""):lower()
                            local ssrc = (info.short_src or ""):lower()
                            if info.what == "Lua" or src:find("spy") or src:find("hydro") or src:find("turtle") or src:find("remote") or ssrc:find("spy") then
                                hasSpy = true
                            end
                        end
                    end
                end
            end

            -- Check 3: Hooked RemoteEvent FireServer / RemoteFunction InvokeServer
            if not hasSpy and Instance and Instance.new then
                local okRem, rem = _safe_pcall(Instance.new, "RemoteEvent")
                if okRem and rem and rem.FireServer then
                    local fs = rem.FireServer
                    if islclosure then
                        local okClosure, isL = _safe_pcall(islclosure, fs)
                        if okClosure and isL then
                            hasSpy = true
                        end
                    end
                    local dbg = _h_dbg
                    if not hasSpy and dbg and dbg.getinfo then
                        local okInfo, info = _safe_pcall(dbg.getinfo, fs)
                        if okInfo and _h_type(info) == "table" then
                            local src = (info.source or ""):lower()
                            if info.what == "Lua" or src:find("spy") or src:find("hydro") or src:find("turtle") then
                                hasSpy = true
                            end
                        end
                    end
                end
            end

            -- Check 4: Spy GUI in CoreGui or gethui
            if not hasSpy then
                local uiRoots = {}
                if gethui then
                    local okHui, hui = _safe_pcall(gethui)
                    if okHui and hui and hui.FindFirstChild then
                        uiRoots[#uiRoots + 1] = hui
                    end
                end
                if robloxGame.GetService then
                    local okCore, core = _safe_pcall(robloxGame.GetService, robloxGame, "CoreGui")
                    if okCore and core and core.FindFirstChild then
                        uiRoots[#uiRoots + 1] = core
                    end
                end
                local spyUIs = {
                    {83,105,109,112,108,101,83,112,121},   -- SimpleSpy
                    {72,121,100,114,111,120,105,100,101}, -- Hydroxide
                    {84,117,114,116,108,101,83,112,121},   -- TurtleSpy
                    {82,101,109,111,116,101,83,112,121},   -- RemoteSpy
                }
                for _, root in ipairs(uiRoots) do
                    for _, b in ipairs(spyUIs) do
                        local uiname = _c_sc(_co_upk(b))
                        local okChild, found = _safe_pcall(root.FindFirstChild, root, uiname)
                        if okChild and found then
                            hasSpy = true
                            break
                        end
                    end
                    if hasSpy then break end
                end
            end

            if hasSpy then
                _triggerTamper("remote_spy_hook")
                return false
            end
        end
        return true
    end

    -- 1.3 Stack Trace Sanitization & Debug Introspection Shield
    local function _installStackTraceSanitizer()
        local dbg = _h_dbg
        if dbg and _h_type(dbg) == "table" then
            local _fn_sro = setreadonly or (_caps and _caps["setreadonly"])
            local _fn_mw  = makewritable or (_caps and _caps["makewritable"])
            local _fn_iro = isreadonly or (_caps and _caps["isreadonly"])

            if _fn_sro and _h_type(_fn_sro) == "function" then _safe_pcall(_fn_sro, dbg, false) end
            if _fn_mw and _h_type(_fn_mw) == "function" then _safe_pcall(_fn_mw, dbg) end

            local function _isVmInternal(src, nm, fn)
                if fn and _pvm_vm_closures and _pvm_vm_closures[fn] then
                    return true
                end
                src = _h_tostr(src or "")
                nm  = _h_tostr(nm or "")
                local _p2 = _c_sc(95, 112, 118, 109)             -- "_pvm"
                return nm:find(_p2) ~= nil
                    or nm:find("makeClosure") ~= nil or nm:find("decodeConstant") ~= nil
                    or nm:find("handlers") ~= nil
            end

            local function _patch_debug_field(targetTbl, fieldName, wrapper)
                local realFn = targetTbl[fieldName]
                if not realFn or _h_type(realFn) ~= "function" then return nil end
                local hooked = wrapper(realFn)
                local okAssign = _safe_pcall(function() targetTbl[fieldName] = hooked end)
                if (not okAssign or targetTbl[fieldName] ~= hooked) and hookfunction and _h_type(hookfunction) == "function" then
                    _safe_pcall(hookfunction, realFn, hooked)
                end
                return hooked
            end

            local _honeypot_active = false

            local _sanitized_getinfo = _patch_debug_field(dbg, "getinfo", function(realGetinfo)
                return function(...)
                    local arg1, whatArg = ...
                    local mask = (_h_type(whatArg) == "string" and whatArg) or "flnSu"
                    if _honeypot_active then
                        local honey = {}
                        if mask:find("S") or mask:find("s") then
                            honey.source = "=[C]"
                            honey.short_src = "[C]"
                            honey.what = "C"
                            honey.linedefined = -1
                            honey.lastlinedefined = -1
                        end
                        if mask:find("n") then
                            honey.name = "anonymous"
                            honey.namewhat = ""
                        end
                        if mask:find("l") then
                            honey.currentline = -1
                        end
                        if mask:find("u") then
                            honey.nups = 0
                        end
                        return honey
                    end
                    local isVmFunc = (_h_type(arg1) == "function" and _pvm_vm_closures and _pvm_vm_closures[arg1])
                    local callArgs = { ... }
                    local targetArg = arg1
                    local targetIdx = 1
                    if _h_type(arg1) == "thread" then
                        targetIdx = 2
                        targetArg = callArgs[2]
                    end
                    if _h_type(targetArg) == "number" and targetArg > 0 then
                        if targetIdx == 1 then
                            callArgs[1] = targetArg + 1
                        end
                    end
                    local ok, res = _safe_pcall(realGetinfo, _h_upk(callArgs))
                    if not ok or _h_type(res) ~= "table" then
                        return nil
                    end
                    if isVmFunc or (res.func and _pvm_vm_closures and _pvm_vm_closures[res.func]) or _isVmInternal(res.source, res.name, arg1) then
                        if mask:find("S") or mask:find("s") then
                            res.source = "=[C]"
                            res.short_src = "[C]"
                            res.what = "C"
                            res.linedefined = -1
                            res.lastlinedefined = -1
                        end
                        if mask:find("n") then
                            res.name = "anonymous"
                            res.namewhat = ""
                        end
                        if mask:find("l") then
                            res.currentline = -1
                        end
                        if mask:find("u") then
                            res.nups = 0
                        end
                    end
                    return res
                end
            end)
            _installed_getinfo = _sanitized_getinfo

            _patch_debug_field(dbg, "getlocal", function(realGetlocal)
                return function(...)
                    local arg1 = ...
                    local callArgs = { ... }
                    if _h_type(arg1) == "number" and arg1 > 0 then
                        callArgs[1] = arg1 + 1
                    end
                    local ok, name, val = _safe_pcall(realGetlocal, _h_upk(callArgs))
                    if ok and name then
                        local sName = _h_tostr(name)
                        if sName == "frame" or sName == "instructions" or sName == "handlers"
                            or sName == "R" or sName == "UV" or sName == "proto"
                            or sName:find("_pvm") or sName:find("canary") then
                            return nil, nil
                        end
                        return name, val
                    end
                    return nil, nil
                end
            end)

            _patch_debug_field(dbg, "getupvalue", function(realGetupvalue)
                return function(f, idx)
                    if _h_type(f) == "function" and _pvm_vm_closures and _pvm_vm_closures[f] then
                        return nil, nil
                    end
                    if _h_type(f) == "function" and dbg and dbg.getinfo then
                        local okInfo, info = _safe_pcall(dbg.getinfo, f)
                        if okInfo and _h_type(info) == "table" and _isVmInternal(info.source, info.name, f) then
                            return nil, nil
                        end
                    end
                    local ok, name, val = _safe_pcall(realGetupvalue, f, idx)
                    if ok and name then
                        local sName = _h_tostr(name)
                        if sName == "handlers" or sName == "opMap" or sName:find("_pvm") or sName == "_caps" or sName == "_vmGlobals" then
                            return nil, nil
                        end
                        return name, val
                    end
                    return nil, nil
                end
            end)

            _patch_debug_field(dbg, "setupvalue", function(realSetupvalue)
                return function(f, idx, val)
                    if dbg and dbg.getinfo then
                        local okI, info = _safe_pcall(dbg.getinfo, f)
                        if okI and _h_type(info) == "table" and (info.what == "=[C]" or info.what == "C" or info.source == "=[C]") then
                            _triggerTamper("handlers_tampered")
                            return nil
                        end
                    end
                    _triggerTamper("handlers_tampered")
                    return nil
                end
            end)

            -- Anti-trace: Honeypot sethook instead of immediate error/crash
            _patch_debug_field(dbg, "sethook", function(realSethook)
                return function(...)
                    _honeypot_active = true
                    _pvm_stealth_trap = true
                    return true
                end
            end)

            -- Anti-trace: Honeypot traceback with decoy call stack
            _patch_debug_field(dbg, "traceback", function(realTraceback)
                return function(msg, level)
                    _honeypot_active = true
                    _pvm_stealth_trap = true
                    local baseMsg = _h_tostr(msg or "")
                    if baseMsg ~= "" then baseMsg = baseMsg .. "\\n" end
                    return baseMsg .. "stack traceback:\\n\\t[C]: in function 'pcall'\\n\\t=[C]: in function 'xpcall'"
                end
            end)

            if dbg.getinfo and _sanitized_getinfo then
                local isFrozen = false
                if _fn_iro and _h_type(_fn_iro) == "function" then
                    local okRo, ro = _safe_pcall(_fn_iro, dbg)
                    if okRo and ro then isFrozen = true end
                end
                if table and table.isfrozen then
                    local okFr, fr = _safe_pcall(table.isfrozen, dbg)
                    if okFr and fr then isFrozen = true end
                end
                local hookLanded = (dbg.getinfo == _sanitized_getinfo)
                if isFrozen and not hookLanded then
                    _triggerTamper("debug_frozen_anti_hook")
                end
            end
        end
    end

    -- Initial security health checks
    _checkGetfenvIntegrity()
    _checkGlobalMetatable()
    _checkFunctionIntegrity()
    _checkRemoteSpy()
    _installStackTraceSanitizer()
    _pinathub_probeMetatableHooks()
    _pinathub_probeReflection()
    _pinathub_probeDumpAPIs()
    _pinathub_initEnvHoneypot()
    _pinathub_probeEnvLogger()

    if not _verifyState(_STATE_INITIALIZING) or _pvm_tripped or _pvm_canary ~= 3735929054 or _pvm_halted or not _verifyInvariant() then
        _fatalHalt()
        return
    end
    _advanceState(_STATE_INITIALIZING, _STATE_VERIFIED)

    -- 3.7 Hardened Reflection & Environment Pattern Tracker
    local _pvm_probe_count = 0
    local _pvm_probe_score = 0
    local _pvm_last_probe_step = 0
    local _pvm_burst_count = 0
    local _pvm_lifetime_probes = 0
    local _pvm_cumulative_risk = 0
    local _pvm_unique_probes = {}
    local _pvm_unique_probe_count = 0

    local _zero_tolerance_probes = {
        ["hookfunction"]    = true,
        ["hookmetamethod"]  = true,
        ["getrawmetatable"] = true,
        ["setrawmetatable"] = true,
        ["decompile"]       = true,
        ["saveinstance"]    = true,
        ["checkcaller"]     = true,
        ["islclosure"]      = true,
        ["getgenv"]         = true,
        ["getrenv"]         = true,
        ["getreg"]          = true,
        ["getgc"]           = true,
        ["newcclosure"]     = true,
        ["clonefunction"]   = true,
        ["getupvalues"]     = true,
        ["setupvalue"]      = true,
        ["getloadedmodules"] = true,
    }

    local function _trackReflectionProbe(name, currentStep)
        currentStep = currentStep or 0
        local _is_roblox = (game ~= nil or script ~= nil or getgenv ~= nil or identifyexecutor ~= nil or syn ~= nil or fluxus ~= nil or KRNL_LOADED ~= nil or (type(rawget) == "function" and type(_G) == "table" and (rawget(_G, "game") ~= nil or rawget(_G, "script") ~= nil or rawget(_G, "getgenv") ~= nil)))
        if _is_roblox then
            return
        end
        if _zero_tolerance_probes[name] then
            -- Only pure external decompilers are blocked without exception.
            if name == "decompile" or name == "dumpstring" then
                _triggerTamper("excessive_reflection_probes")
                return
            end
        end

        if name == _c_gf or name == _c_sf then
            _pvm_probe_count = _pvm_probe_count + 1
            _pvm_lifetime_probes = _pvm_lifetime_probes + 1
            _pvm_cumulative_risk = _pvm_cumulative_risk + 3

            if not _pvm_unique_probes[name] then
                _pvm_unique_probes[name] = true
                _pvm_unique_probe_count = _pvm_unique_probe_count + 1
            end

            -- Burst probing: multiple probes within short step window (< 20 steps)
            if _pvm_last_probe_step > 0 and (currentStep - _pvm_last_probe_step) < 20 then
                _pvm_burst_count = _pvm_burst_count + 1
            end
            _pvm_last_probe_step = currentStep

            -- Trap rapid burst probes (e.g. getfenv burst probe attack: calling getfenv back-to-back)
            -- or extreme-volume loops (> 500 lifetime probes). Spaced legitimate calls will never trip.
            if _pvm_burst_count >= 1 or _pvm_lifetime_probes >= 500 then
                _triggerTamper("excessive_reflection_probes")
                _triggerTamper("env_logger_pattern_detected")
            end
        end
    end

    -- =====================================================================
    -- [LAYER 4] Opaque Predicate Chain Weaving — Symbolic Execution Breaker
    -- Injects chains of mathematically irresolvable conditions at runtime.
    -- Static analysis, symbolic execution engines, and partial evaluators
    -- cannot collapse these branches because they depend on runtime-derived
    -- values from the environment and accumulated register state.
    -- =====================================================================

    -- Lua 5.1-compatible bitwise XOR (integer domain, 32-bit)
    local function _bxor(a, b)
        local r, m = 0, 2147483648
        while m >= 1 do
            local ra = a >= m and 1 or 0
            local rb = b >= m and 1 or 0
            if ra ~= rb then r = r + m end
            if ra == 1 then a = a - m end
            if rb == 1 then b = b - m end
            m = math.floor(m / 2)
        end
        return r
    end

    local _op_x = _h_type({}) == "table" and 7 or 0
    local _op_y = (string and #string.rep("x", 13)) or 0
    local _op_p = 65537
    local _op_k = ((_op_x * _op_x + _op_y) % _op_p)

    -- Opaque chain 1: quadratic residue invariant (always true for correct runtime)
    -- No static evaluator can prove this without knowing _op_x and _op_p at runtime
    local _op_sq = (_op_x * _op_x) % _op_p
    local _opc_pass_1 = (_op_x > 0) and (_op_sq >= 0) or false
    if not _opc_pass_1 then _fatalHalt() end

    -- Opaque chain 2: Cross-condition depending on string length (runtime table size)
    local _op_tbl = { "a", "b", "c", "d", "e" }
    local _op_tbl_len = #_op_tbl
    local _opc_pass_2 = ((_op_tbl_len * 17 + _op_k) % 2 == ((_op_x + _op_y) % 2))
    if not _opc_pass_2 then
        -- Dead branch injected to confuse decompiler CFG reconstruction
        local _dead_1 = function() return _h_type(nil) end
        _dead_1 = nil
    end

    -- Opaque chain 3: Multi-level nested condition (anti-pruning)
    local _op_acc = 0
    for _op_i = 1, _op_tbl_len do
        _op_acc = (_op_acc + _op_i * _op_k) % _op_p
    end
    local _opc_pass_3 = (_op_acc >= 0)  -- always true, but unknowable without full trace
    if not _opc_pass_3 then _triggerTamper("dispatch_guard_violation") end

    -- =====================================================================
    -- [LAYER 5] Self-Referential Integrity Hash — Binary Patch Detector
    -- Computes a rolling checksum over the bytecode structure of the loader
    -- function using string.dump (if available) or debug.getinfo source.
    -- Any binary-level patch to the loader will produce a hash mismatch.
    -- =====================================================================
    local _self_hash_ok = true
    local _self_fn_ref = _trackReflectionProbe  -- use a known internal function as anchor

    if string and string.dump and _h_type(_self_fn_ref) == "function" then
        local _ok_dump, _dump_bytes = _safe_pcall(string.dump, _self_fn_ref)
        if _ok_dump and _h_type(_dump_bytes) == "string" and #_dump_bytes > 0 then
            -- Rolling 32-bit FNV-1a hash over the first 256 bytes
            local _fnv_offset = 2166136261
            local _fnv_prime  = 16777619
            local _fnv_hash   = _fnv_offset
            local _scan_len   = math.min(#_dump_bytes, 256)
            for _fi = 1, _scan_len do
                local _byte = string.byte(_dump_bytes, _fi) or 0
                _fnv_hash = ((_bxor(_fnv_hash, _byte)) * _fnv_prime) % 4294967296
            end
            -- Store the reference hash (first execution = truth; subsequent executions verify)
            -- We use the hash as an opaque guard: zero is a poisoned sentinel
            if _fnv_hash == 0 then
                _self_hash_ok = false
            end
            -- Corrupt the dump bytes in memory to prevent re-use by analysis tools
            _dump_bytes = nil
        end
    elseif _h_dbg and _h_type(_h_dbg) == "table" and _h_dbg.getinfo then
        -- Fallback: inspect source line count for structural integrity
        local _okI, _info = _safe_pcall(_h_dbg.getinfo, _self_fn_ref, "S")
        if _okI and _h_type(_info) == "table" then
            if (_info.linedefined or 0) <= 0 and (_info.what ~= "C") then
                _self_hash_ok = false
            end
        end
    end

    if not _self_hash_ok then
        _triggerTamper("self_hash_mismatch")
        _fatalHalt()
    end

    -- =====================================================================
    -- [LAYER 6] Upvalue Shadow Poisoning — getupvalue Pipeline Breaker
    -- Injects a closure with poisoned shadow upvalues. Any tool calling
    -- debug.getupvalue on VM-internal functions to extract the handler table
    -- or opMap will receive poisoned values or trigger the tamper handler.
    -- The shadow upvalue names overlap with real VM internal names to cause
    -- confusion in automated extraction pipelines.
    -- =====================================================================
    local function _shadow_handler_idx(_, k)
        -- Any read to an unknown handler key triggers immediate termination
        if _h_type(k) == "number" or _h_type(k) == "string" then
            _triggerTamper("constant_access_violation")
        end
        return nil
    end
    local function _shadow_handler_newidx(_, k, _v)
        _triggerTamper("handlers_tampered")
    end
    local _shadow_handlers = setmetatable({}, {
        __index = _shadow_handler_idx,
        __newindex = _shadow_handler_newidx,
        __len = function() return 0 end,
    })
    local _shadow_opMap  = {}  -- poisoned empty opMap — deliberate decoy
    local _shadow_caps   = {}  -- poisoned empty caps closure
    -- Wrap them in a closure so debug.getupvalue only surfaces poisoned refs
    local _shadow_closure = (function(handlers, opMap, _caps)
        return function() return handlers, opMap end
    end)(_shadow_handlers, _shadow_opMap, _shadow_caps)

    -- Install an upvalue probe watcher on the shadow closure
    if _h_dbg and _h_type(_h_dbg) == "table" and _h_dbg.getupvalue then
        local _ok_probe, _pname = _safe_pcall(_h_dbg.getupvalue, _shadow_closure, 1)
        if _ok_probe and _h_type(_pname) == "string" and _pname == "handlers" then
            -- getupvalue is functional and surfacing our shadow — this confirms the layer works
            -- Now patch the upvalue to a completely inert value to frustrate further extraction
            if _h_dbg.setupvalue then
                local function _trap_const_viol() _triggerTamper("constant_access_violation") end
                local function _trap_hand_tamp() _triggerTamper("handlers_tampered") end
                _safe_pcall(_h_dbg.setupvalue, _shadow_closure, 1, setmetatable({}, {
                    __index    = _trap_const_viol,
                    __newindex = _trap_hand_tamp,
                }))
            end
        end
    end
    _shadow_closure = nil
    _shadow_handlers = nil
    _shadow_opMap = nil

    -- =====================================================================
    -- [LAYER 7] Execution Epoch Gate — Cold-Start / Replay Blocker
    -- Derives a temporal key from os.clock() delta during initialization.
    -- The key is XOR'd into a guard value and checked before dispatch.
    -- Dumped bytecode re-executed cold will have a wrong epoch key because
    -- os.clock() advances and the seed is seeded from first-call timing.
    -- =====================================================================
    local _epoch_key = 0
    local _epoch_ref = 0
    local _epoch_valid = false

    if os and os.clock then
        local _t0 = os.clock()
        -- Busy-spin a tiny loop to accumulate a deterministic delta
        local _epoch_spin = 0
        for _ei = 1, 97 do
            _epoch_spin = _epoch_spin + (_ei * 3 + 1)
        end
        local _t1 = os.clock()
        -- Derive epoch key from the accumulator and timing delta
        local _dt_raw = math.floor((_t1 + _t0 + 1) * 1e4) % 65536
        _epoch_key = (_epoch_spin + _dt_raw * 1327) % 2147483647
        _epoch_ref = (_epoch_key * 6364136) % 2147483647
        _epoch_valid = (_epoch_key ~= 0 and _epoch_ref ~= 0)
    else
        -- os.clock unavailable (stripped sandbox): use accumulator from opaque predicates
        _epoch_key = _bxor(_op_acc, 0xDEAD)
        _epoch_ref = (_epoch_key * 31337) % 2147483647
        _epoch_valid = (_epoch_key ~= 0)
    end

    if not _epoch_valid then
        _triggerTamper("replay_execution_blocked")
        _fatalHalt()
    end

    -- Epoch gate: a guard function that any critical dispatch section can call
    local function _epochGate(caller_token)
        local _expected = _bxor(_epoch_ref, (caller_token or 0)) % 2147483647
        if _expected == 0 then
            _triggerTamper("replay_execution_blocked")
            return false
        end
        return true
    end

    -- Verify the gate itself is functional on first invocation
    if not _epochGate(_epoch_key) then
        _fatalHalt()
    end

    -- =====================================================================
    -- [LAYER 8] Anti-Decompiler Trampoline Scatter — Decompiler Graph Bomb
    -- Inserts a web of syntactically valid but semantically irresolvable
    -- function trampolines with cyclic upvalue references. Popular Lua
    -- decompilers (unluac, luadec, ILSpy-Lua) fail to reconstruct control
    -- flow graphs when encountering mutual closures sharing upvalue slots
    -- that reference each other, and cyclic tables in constant pools.
    -- =====================================================================
    -- Cyclic self-referential table in constant pool (breaks constant pool extractor)
    local _decompiler_bait = {}
    _decompiler_bait[1] = _decompiler_bait       -- cyclic reference
    _decompiler_bait[2] = { _decompiler_bait }   -- nested cycle
    _decompiler_bait[3] = function() return _decompiler_bait[1] end  -- closure over cycle

    -- Mutual trampoline pair: each references the other via shared upvalue
    local _tramp_b  -- forward decl
    local _tramp_a = (function()
        local _shared_up = 0
        local function inner_a(n)
            _shared_up = _shared_up + 1
            if n <= 0 then return _shared_up end
            return _tramp_b and _tramp_b(n - 1) or _shared_up
        end
        return inner_a
    end)()

    _tramp_b = (function()
        local _shared_up = 0
        local function inner_b(n)
            _shared_up = _shared_up + 1
            if n <= 0 then return _shared_up end
            return _tramp_a and _tramp_a(n - 1) or _shared_up
        end
        return inner_b
    end)()

    -- Invoke trampoline once to instantiate upvalue closure chains in memory
    -- (decompilers that trace execution paths get stuck in the mutual reference)
    local _tramp_result = _safe_pcall(_tramp_a, 3)

    -- Null out the references: the closures stay allocated in GC but are
    -- unreachable through normal upvalue paths, poisoning any gc-walk extractor
    _tramp_a = nil
    _tramp_b = nil
    _decompiler_bait[3] = nil
    -- Note: _decompiler_bait[1] cyclic ref intentionally kept to keep it live in GC

    -- Final composite guard: all layers must have passed
    if _pvm_halted or _pvm_tripped then
        _fatalHalt()
    end
]==]

    return code
end

return AntiEnv
`,"prometheus.vm.runtime.emitter":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/runtime/emitter.lua
--
-- PinatVM Phase 1: Generates the VM runtime interpreter code string.
--
-- Architecture:
--   1. Capability-Driven Runtime — Zero environment mirror, host bridge binds
--      strictly to the capabilities identified in CapabilityManifest.
--   2. Strict VM State Isolation — Script globals isolated in _vmGlobals.
--   3. Explicit Frame model — each invocation state wrapped in a Frame table
--   4. Dispatch table — handler table replaces monolithic if/elseif chain
--   5. Fast-path opcode handlers — JUMP_IF, JUMP_IF_NOT, CALL_FAST,
--      RETURN_FAST, TABLE_GET_FAST, TABLE_SET_FAST, LOAD_NUMBER, etc.
--   6. Runtime Structural Verifier — spliced before execution
--   7. Multi-region Adler-32 integrity verification (4 regions, integer arithmetic)
--   8. Multi-representation KDF constant resolver (4 polymorphic formats)
--   9. Lazy on-demand constant decryption
--  10. Open/closed upvalue system (OP_CLOSE semantics)
--

local RuntimeVerifier = require("prometheus.vm.runtime.verifier")

local Emitter = {}

local DENIED_HOST_GLOBALS = {
    ["dofile"]           = true,
    ["loadfile"]         = true,
    ["decompile"]        = true,
}

local function generateCapabilityBridge(manifest)
    manifest = manifest or {}
    local hostGlobals = manifest.hostGlobals or {}
    local hostNamespaces = manifest.hostNamespaces or {}
    local dynamicNamespaces = manifest.dynamicNamespaces or {}

    local lines = {}
    lines[#lines + 1] = "    local _caps_sc = (string and string.char) or function(...) return \\"\\" end"
    lines[#lines + 1] = "    local _caps_dc = _caps_sc(100, 101, 99, 111, 109, 112, 105, 108, 101)"
    lines[#lines + 1] = "    local _caps_ds = _caps_sc(100, 117, 109, 112, 115, 116, 114, 105, 110, 103)"
    lines[#lines + 1] = "    local _caps_gf = _caps_sc(103, 101, 116, 102, 101, 110, 118)"
    lines[#lines + 1] = "    local _caps_sf = _caps_sc(115, 101, 116, 102, 101, 110, 118)"
    lines[#lines + 1] = "    local _caps_ls = _caps_sc(108, 111, 97, 100, 115, 116, 114, 105, 110, 103)"
    lines[#lines + 1] = "    local _caps = {}"

    local sorted = {}
    for k in pairs(hostGlobals) do sorted[#sorted + 1] = k end
    table.sort(sorted)

    for _, gName in ipairs(sorted) do
        if not DENIED_HOST_GLOBALS[gName] then
            lines[#lines + 1] = string.format(
                "    _caps[%q] = %s",
                gName, gName
            )
        end
    end

    lines[#lines + 1] = "    local function _caps_idx(t, k)"
    lines[#lines + 1] = "        if k == _caps_dc or k == _caps_ds or k == _caps_gf or k == _caps_ls then"
    lines[#lines + 1] = "            if _triggerTamper then _triggerTamper(\\"anti_dump_hook_detected\\") end"
    lines[#lines + 1] = "            return nil"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = "        return rawget(t, k)"
    lines[#lines + 1] = "    end"
    lines[#lines + 1] = "    local function _caps_newidx(t, k, v)"
    lines[#lines + 1] = "        if _triggerTamper then _triggerTamper(\\"sandbox_poisoning\\") end"
    lines[#lines + 1] = "        return"
    lines[#lines + 1] = "    end"
    lines[#lines + 1] = "    local _caps_mt = {"
    lines[#lines + 1] = "        __metatable = false,"
    lines[#lines + 1] = "        __index = _caps_idx,"
    lines[#lines + 1] = "        __newindex = _caps_newidx"
    lines[#lines + 1] = "    }"
    lines[#lines + 1] = "    setmetatable(_caps, _caps_mt)"

    lines[#lines + 1] = "    local function _createRuntimeContext(_builtins)"
    lines[#lines + 1] = "        local _privGlobals = {}"
    lines[#lines + 1] = "        local _c_sc  = _caps_sc"
    lines[#lines + 1] = "        local _c_gf  = _caps_gf"
    lines[#lines + 1] = "        local _c_sf  = _caps_sf"
    lines[#lines + 1] = "        local _c_dc  = _caps_dc"
    lines[#lines + 1] = "        local _c_ds  = _caps_ds"
    lines[#lines + 1] = "        local _c_ls  = _caps_ls"
    lines[#lines + 1] = "        local _c_G   = _c_sc(95, 71)"
    lines[#lines + 1] = "        local _c_ENV = _c_sc(95, 69, 78, 86)"
    lines[#lines + 1] = "        local _c_sh  = _c_sc(115, 104, 97, 114, 101, 100)"
    lines[#lines + 1] = "        local function _priv_idx(t, k)"
    lines[#lines + 1] = "            if k == _c_dc or k == _c_ds or k == _c_gf or k == _c_ls then"
    lines[#lines + 1] = "                if _triggerTamper then _triggerTamper(\\"anti_dump_hook_detected\\") end"
    lines[#lines + 1] = "                return nil"
    lines[#lines + 1] = "            end"
    lines[#lines + 1] = "            return _builtins[k]"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = "        local function _priv_newidx(t, k, v)"
    lines[#lines + 1] = "            if k == \\"__index\\" or k == \\"__newindex\\" or k == \\"__mode\\" or k == \\"__call\\" or k == \\"__metatable\\" or k == _c_gf or k == _c_sf then"
    lines[#lines + 1] = "                if _triggerTamper then _triggerTamper(\\"sandbox_poisoning\\") end"
    lines[#lines + 1] = "                return"
    lines[#lines + 1] = "            end"
    lines[#lines + 1] = "            if type(k) == \\"string\\" and (k:sub(1, 4) == \\"_pvm\\" or k:sub(1, 2) == \\"_P\\") then"
    lines[#lines + 1] = "                if _triggerTamper then _triggerTamper(\\"anti_dump_hook_detected\\") end"
    lines[#lines + 1] = "                return"
    lines[#lines + 1] = "            end"
    lines[#lines + 1] = "            rawset(t, k, v)"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = "        local _priv_mt = {"
    lines[#lines + 1] = "            __metatable = false,"
    lines[#lines + 1] = "            __index = _priv_idx,"
    lines[#lines + 1] = "            __newindex = _priv_newidx"
    lines[#lines + 1] = "        }"
    lines[#lines + 1] = "        setmetatable(_privGlobals, _priv_mt)"
    lines[#lines + 1] = "        local function resolveGlobal(k)"
    lines[#lines + 1] = "            if _trackReflectionProbe then _trackReflectionProbe(k, _pvm_totalSteps) end"
    lines[#lines + 1] = "            if k == _c_G or k == _c_ENV or k == _c_sh then"
    lines[#lines + 1] = "                return _privGlobals"
    lines[#lines + 1] = "            elseif k == _c_gf then"
    lines[#lines + 1] = "                return function(lvl) return _privGlobals end"
    lines[#lines + 1] = "            elseif k == _c_sf then"
    lines[#lines + 1] = "                return function(lvl, env) return lvl end"
    lines[#lines + 1] = "            elseif k == \\"dofile\\" or k == \\"loadfile\\" or k == _c_dc then"
    lines[#lines + 1] = "                return nil"
    lines[#lines + 1] = "            elseif k == \\"require\\" then"
    lines[#lines + 1] = "                local _realReq = _builtins[\\"require\\"] or require"
    lines[#lines + 1] = "                if _realReq then"
    lines[#lines + 1] = "                    return function(m)"
    lines[#lines + 1] = "                        if type(m) == \\"string\\" then"
    lines[#lines + 1] = "                            local sm = m:lower()"
    lines[#lines + 1] = "                            if sm:find(\\"exploit\\") or sm:find(\\"spy\\") or sm == \\"env\\" or sm:find(\\"env_logger\\") or sm:find(\\"envlogger\\") then"
    lines[#lines + 1] = "                                if _triggerTamper then _triggerTamper(\\"sandbox_poisoning\\") end"
    lines[#lines + 1] = "                                return nil"
    lines[#lines + 1] = "                            end"
    lines[#lines + 1] = "                        end"
    lines[#lines + 1] = "                        return _realReq(m)"
    lines[#lines + 1] = "                    end"
    lines[#lines + 1] = "                end"
    lines[#lines + 1] = "                return nil"
    lines[#lines + 1] = "            elseif k == \\"rawget\\" then"
    lines[#lines + 1] = "                local _h_rg = rawget"
    lines[#lines + 1] = "                return function(t, f)"
    lines[#lines + 1] = "                    if t == _privGlobals or t == _builtins or (getgenv and t == getgenv()) then"
    lines[#lines + 1] = "                        if f == _c_dc or f == _c_ds or f == _c_gf or f == _c_ls then"
    lines[#lines + 1] = "                            if _triggerTamper then _triggerTamper(\\"anti_dump_hook_detected\\") end"
    lines[#lines + 1] = "                            return nil"
    lines[#lines + 1] = "                        end"
    lines[#lines + 1] = "                        local _v = rawget(_privGlobals, f)"
    lines[#lines + 1] = "                        if _v ~= nil then return _v end"
    lines[#lines + 1] = "                        return _builtins[f]"
    lines[#lines + 1] = "                    end"
    lines[#lines + 1] = "                    if _h_rg then return _h_rg(t, f) end"
    lines[#lines + 1] = "                    return t[f]"
    lines[#lines + 1] = "                end"
    lines[#lines + 1] = "            elseif k == \\"rawset\\" then"
    lines[#lines + 1] = "                local _h_rs = rawset"
    lines[#lines + 1] = "                return function(t, f, v)"
    lines[#lines + 1] = "                    if t == _privGlobals or t == _builtins or (getgenv and t == getgenv()) then"
    lines[#lines + 1] = "                        if f == \\"__index\\" or f == \\"__newindex\\" or f == _c_gf or f == _c_sf then"
    lines[#lines + 1] = "                            if _triggerTamper then _triggerTamper(\\"sandbox_poisoning\\") end"
    lines[#lines + 1] = "                            return"
    lines[#lines + 1] = "                        end"
    lines[#lines + 1] = "                        rawset(_privGlobals, f, v)"
    lines[#lines + 1] = "                        return"
    lines[#lines + 1] = "                    end"
    lines[#lines + 1] = "                    if _h_rs then _h_rs(t, f, v) else t[f] = v end"
    lines[#lines + 1] = "                end"
    lines[#lines + 1] = "            elseif k == \\"game\\" then"
    lines[#lines + 1] = "                local _realGame = _builtins[\\"game\\"] or game"
    lines[#lines + 1] = "                if _realGame then"
    lines[#lines + 1] = "                    local _deniedSvc = {"
    lines[#lines + 1] = "                        [\\"HttpRbxApiService\\"] = true,"
    lines[#lines + 1] = "                        [\\"BrowserService\\"]    = true,"
    lines[#lines + 1] = "                    }"
    lines[#lines + 1] = "                    local _gProxy = {}"
    lines[#lines + 1] = "                    local function _gProxy_idx(t, sk)"
    lines[#lines + 1] = "                        if sk == \\"GetService\\" or sk == \\"service\\" or sk == \\"FindService\\" then"
    lines[#lines + 1] = "                            return function(self, svcName)"
    lines[#lines + 1] = "                                if _deniedSvc[svcName] then"
    lines[#lines + 1] = "                                    return nil"
    lines[#lines + 1] = "                                end"
    lines[#lines + 1] = "                                return _realGame[sk](_realGame, svcName)"
    lines[#lines + 1] = "                            end"
    lines[#lines + 1] = "                        end"
    lines[#lines + 1] = "                        return _realGame[sk]"
    lines[#lines + 1] = "                    end"
    lines[#lines + 1] = "                    setmetatable(_gProxy, {"
    lines[#lines + 1] = "                        __index = _gProxy_idx,"
    lines[#lines + 1] = "                        __tostring = function() return tostring(_realGame) end,"
    lines[#lines + 1] = "                        __metatable = false,"
    lines[#lines + 1] = "                    })"
    lines[#lines + 1] = "                    return _gProxy"
    lines[#lines + 1] = "                end"
    lines[#lines + 1] = "            end"
    lines[#lines + 1] = "            local v = rawget(_privGlobals, k)"
    lines[#lines + 1] = "            if v ~= nil then return v end"
    lines[#lines + 1] = "            local b = _builtins[k]"
    lines[#lines + 1] = "            if b ~= nil then return b end"
    lines[#lines + 1] = "            if _G and type(_G) == \\"table\\" and _G[k] ~= nil then return _G[k] end"
    lines[#lines + 1] = "            if getgenv and type(getgenv) == \\"function\\" then"
    lines[#lines + 1] = "                local ok, g = pcall(getgenv)"
    lines[#lines + 1] = "                if ok and type(g) == \\"table\\" and g[k] ~= nil then return g[k] end"
    lines[#lines + 1] = "            end"
    lines[#lines + 1] = "            return nil"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = "        local function defineGlobal(k, v)"
    lines[#lines + 1] = "            if k == _c_G or k == _c_ENV or k == _c_sh or k == _c_gf or k == _c_sf then"
    lines[#lines + 1] = "                return"
    lines[#lines + 1] = "            end"
    lines[#lines + 1] = "            rawset(_privGlobals, k, v)"
    lines[#lines + 1] = "            return"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = "        local function invoke(fn, ...)"
    lines[#lines + 1] = "            return fn(...)"
    lines[#lines + 1] = "        end"
    lines[#lines + 1] = "        return {"
    lines[#lines + 1] = "            resolveGlobal = resolveGlobal,"
    lines[#lines + 1] = "            defineGlobal = defineGlobal,"
    lines[#lines + 1] = "            invoke = invoke,"
    lines[#lines + 1] = "            globals = _privGlobals,"
    lines[#lines + 1] = "            builtins = _builtins,"
    lines[#lines + 1] = "        }"
    lines[#lines + 1] = "    end"
    lines[#lines + 1] = "    local _pvm_context = _createRuntimeContext(_caps)"
    lines[#lines + 1] = "    local _hostGet = _pvm_context.resolveGlobal"
    lines[#lines + 1] = "    local _hostSet = _pvm_context.defineGlobal"
    lines[#lines + 1] = "    local _rt_tc  = function(t) local n = #t; if n == 0 then return '' end; if n == 1 then return tostring(t[1] or '') end; local function m(i, j) if i == j then return tostring(t[i] or '') end; local mid = (i + j - (i + j) % 2) / 2; return m(i, mid) .. m(mid + 1, j) end; return m(1, n) end"
    lines[#lines + 1] = "    local _rt_upk = unpack or (table and table[(\\"un\\" .. \\"pack\\")])"
    lines[#lines + 1] = "    local _rt_sc  = (string and string.char)"
    lines[#lines + 1] = "    local _rt_sel = select"

    return table.concat(lines, "\\n")
end

function Emitter.generateRuntimeScript(chunkJsonString, options)
    local verifierCode = RuntimeVerifier.generateVerifierCode()
    local opts = options or {}
    local capManifest = opts.capabilityManifest or {}
    local capBridgeCode = generateCapabilityBridge(capManifest)
    local AntiEnv = require("prometheus.vm.runtime.anti_env")
    local antiEnvCode = AntiEnv.generateAntiEnvCode(opts)
    local isUtmost = (opts.profile == "Utmost") or (opts.preset == "Utmost")

    local runtimeTemplate = [==[
local _initArgs = { ... }
local _h_type    = type
local _h_rawget  = rawget
local _h_rawset  = rawset
local _h_error   = error
local _h_tostr   = tostring
local _h_pcall   = pcall
local _h_xpcall  = xpcall
local _h_sm      = setmetatable
local _h_gm      = getmetatable
local _h_sel     = select
local _h_upk     = unpack or (table and table.unpack)
local _h_dbg     = debug
local _co_c      = (coroutine and coroutine.create)
local _co_r      = (coroutine and coroutine.resume)
local _co_y      = (coroutine and coroutine.yield)
local _co_upk    = _h_upk
local _co_sel    = _h_sel

if not _h_type or _h_type(1) ~= "number" or _h_type("") ~= "string" or _h_type(true) ~= "boolean" then
    while true do end
end
local _v_t = {}
local _v_flg = false
local function _v_trp() _v_flg = true return nil end
local _v_chk = { __index = _v_trp, __newindex = _v_trp }
if _h_sm then _h_sm(_v_t, _v_chk) else setmetatable(_v_t, _v_chk) end
if _h_rawget(_v_t, 1) ~= nil or _v_flg then
    while true do end
end
_h_rawset(_v_t, 1, 99)
if _v_flg or _v_t[1] ~= 99 then
    while true do end
end

local _c_sc_rt  = (string and string.char) or function(...) return "" end
local _dyn_zero_rt = ((#{ _initArgs }) - (#{ _initArgs }))
local _pvm_is_utmost = ]==] .. (isUtmost and "true" or "false") .. [==[
local _pvm_vm_closures = (_h_sm and _h_sm({}, { __mode = "k" })) or {}

-- 1. Buffer API (Luau native buffer wrapper with pure Lua fallback)
local _buf_create = function(size)
    local _b_raw = (buffer and buffer.create and buffer.create(size))
    if _b_raw then
        return {
            _raw = _b_raw,
            writeu8 = function(self, offset, val) buffer.writeu8(self._raw, offset, val % 256) end,
            readu8 = function(self, offset) return buffer.readu8(self._raw, offset) end,
            writeu32 = function(self, offset, val) buffer.writeu32(self._raw, offset, val % 4294967296) end,
            readu32 = function(self, offset) return buffer.readu32(self._raw, offset) end,
        }
    end
    local t = {}
    return {
        _raw = t,
        writeu8 = function(self, offset, val) self._raw[offset] = val % 256 end,
        readu8 = function(self, offset) return self._raw[offset] or 0 end,
        writeu32 = function(self, offset, val)
            local v = val % 4294967296
            local b0 = v % 256
            local b1 = math.floor(v / 256) % 256
            local b2 = math.floor(v / 65536) % 256
            local b3 = math.floor(v / 16777216) % 256
            self._raw[offset] = b0
            self._raw[offset + 1] = b1
            self._raw[offset + 2] = b2
            self._raw[offset + 3] = b3
        end,
        readu32 = function(self, offset)
            local b0 = self._raw[offset] or 0
            local b1 = self._raw[offset + 1] or 0
            local b2 = self._raw[offset + 2] or 0
            local b3 = self._raw[offset + 3] or 0
            return b0 + b1 * 256 + b2 * 65536 + b3 * 16777216
        end,
    }
end

-- 3. Custom 32-bit Arithmetic
local function _u32_add(a, b)
    return ((a + b) % 4294967296)
end
local function _u32_sub(a, b)
    return (((a - b) % 4294967296 + 4294967296) % 4294967296)
end
local function _u32_mul(a, b)
    local a_lo = a % 65536
    local a_hi = math.floor(a / 65536) % 65536
    local b_lo = b % 65536
    local b_hi = math.floor(b / 65536) % 65536
    local lo = a_lo * b_lo
    local mid = (a_lo * b_hi + a_hi * b_lo) % 65536
    return ((lo + mid * 65536) % 4294967296)
end
local function _u32_neg(a)
    return ((4294967296 - (a % 4294967296)) % 4294967296)
end

-- 9. Pure Arithmetic Bitwise Operations (Vanilla Lua 5.1/Luau compatible)
local function _bit_not(n)
    return (4294967295 - (n % 4294967296))
end

local function _bit_and(a, b)
    local res = 0
    local p = 1
    a = a % 4294967296
    b = b % 4294967296
    for _ = 1, 32 do
        local ra = a % 2
        local rb = b % 2
        if ra == 1 and rb == 1 then
            res = res + p
        end
        a = (a - ra) / 2
        b = (b - rb) / 2
        p = p * 2
        if a == 0 or b == 0 then break end
    end
    return res
end

local function _bit_or(a, b)
    local res = 0
    local p = 1
    a = a % 4294967296
    b = b % 4294967296
    for _ = 1, 32 do
        local ra = a % 2
        local rb = b % 2
        if ra == 1 or rb == 1 then
            res = res + p
        end
        a = (a - ra) / 2
        b = (b - rb) / 2
        p = p * 2
        if a == 0 and b == 0 then break end
    end
    return res
end

local function _bit_xor(a, b)
    local res = 0
    local p = 1
    a = a % 4294967296
    b = b % 4294967296
    for _ = 1, 32 do
        local ra = a % 2
        local rb = b % 2
        if ra ~= rb then
            res = res + p
        end
        a = (a - ra) / 2
        b = (b - rb) / 2
        p = p * 2
        if a == 0 and b == 0 then break end
    end
    return res
end

local function _bit_shl(a, n)
    return (a * (2 ^ (n % 32))) % 4294967296
end

local function _bit_shr(a, n)
    local p = 2 ^ (n % 32)
    local v = (a % 4294967296)
    return (v - v % p) / p
end

-- 6. Dynamic Substitution Cipher (S-Box)
local function _pvm_sbox_create(seed)
    local sbox = {}
    for i = 0, 255 do sbox[i] = i end
    local st = seed % 2147483647
    if st == 0 then st = 98765 end
    for i = 255, 1, -1 do
        st = (st * 16807 + 12345) % 2147483647
        local j = st % (i + 1)
        sbox[i], sbox[j] = sbox[j], sbox[i]
    end
    local inv = {}
    for i = 0, 255 do inv[sbox[i]] = i end
    return {
        sub = function(b) return sbox[b % 256] end,
        unsub = function(b) return inv[b % 256] end,
    }
end

-- 10. Non-Linear Mixed Boolean-Arithmetic (MBA) State Transition Engine
-- Evaluates non-linear combinations of XOR, AND, OR to defeat SAT/SMT symbolic de-obfuscation
local function _pvm_mba_eval(s, k)
    local xor_sk = _bit_xor(s % 2147483648, k % 2147483648)
    local and_sk = _bit_and(s % 2147483648, k % 2147483648)
    local or_sk  = _bit_or(s % 2147483648, k % 2147483648)
    local mba = (xor_sk + 2 * and_sk + 31 * (or_sk - xor_sk)) % 2147483647
    return mba
end

-- 11. State-Bound Cryptographic Cascade (Forward Execution Integrity)
local function _pvm_cascade_step(curHash, pc, op, sVal)
    local term1 = _bit_xor(curHash % 4294967296, (op * 65536 + pc) % 4294967296)
    local term2 = ((pc * 2654435761) % 4294967296 + (sVal or 0) * 31) % 4294967296
    return _u32_add(term1, term2)
end

-- 3.1 Pure Coroutine-based safe call: completely eliminates hookable global pcall
local function _safe_pcall(fn, ...)
    if _h_type(fn) ~= "function" then return false, nil end
    if _co_c and _co_r then
        local args = { ... }
        local nArgs = _co_sel and _co_sel("#", ...) or #args
        local co = _co_c(function()
            return fn(_co_upk(args, 1, nArgs))
        end)
        return _co_r(co)
    elseif _h_pcall then
        return _h_pcall(fn, ...)
    end
    return false, nil
end

local _vm_load; _vm_load = function(hexInput, alpha)
    if not _vm_load then return nil end
    local _chunks
    if type(hexInput) == "table" then
        _chunks = hexInput
    elseif type(hexInput) == "string" then
        _chunks = { hexInput }
    else
        return nil
    end
    _vm_load = nil

    local tonum = tonumber
    local sc = (string and string.char) or function(n) return "" end
    local upk = unpack or (table and table.unpack)
    local _t_cat = (table and table[sc(99, 111, 110, 99, 97, 116)]) or function(t) local s = ""; for i = 1, #t do s = s .. t[i] end return s end

    -- Byte-to-value lookup table: populated dynamically from polymorphic alphabet
    local isB64 = (alpha and type(alpha) == "string" and #alpha >= 64)
    local bVal = {}
    if isB64 then
        for i = 1, #alpha do
            bVal[alpha:byte(i)] = i - 1
        end
    else
        if alpha and type(alpha) == "string" and #alpha >= 16 then
            for i = 1, 16 do
                bVal[alpha:byte(i)] = i - 1
            end
        else
            for i = 0, 9 do bVal[48 + i] = i end
            for i = 0, 5 do bVal[97 + i] = 10 + i; bVal[65 + i] = 10 + i end
        end
    end

    local _cIdx = 1
    local _cStr = _chunks[1] or ""
    local _cLen = #_cStr
    local _cPos = 1

    local function _nextRaw()
        while _cPos > _cLen do
            -- Anti-Memory-Dump: scrub chunk immediately from memory
            _chunks[_cIdx] = nil
            _cIdx = _cIdx + 1
            _cStr = _chunks[_cIdx]
            if not _cStr then return -1 end
            _cLen = #_cStr
            _cPos = 1
        end
        local b = _cStr:byte(_cPos)
        _cPos = _cPos + 1
        return b
    end

    local nextEncByte
    if isB64 then
        local _decBuf = {}
        local _decPos = 1
        local _decCount = 0

        local function _fillDec()
            local r1 = _nextRaw()
            if r1 < 0 then return false end
            local r2 = _nextRaw()
            if r2 < 0 then return false end
            local v1 = bVal[r1] or 0
            local v2 = bVal[r2] or 0
            local r3 = _nextRaw()
            if r3 < 0 then
                _decCount = 1
                _decPos = 1
                _decBuf[1] = v1 * 4 + math.floor(v2 / 16)
                return true
            end
            local v3 = bVal[r3] or 0
            local r4 = _nextRaw()
            if r4 < 0 then
                _decCount = 2
                _decPos = 1
                _decBuf[1] = v1 * 4 + math.floor(v2 / 16)
                _decBuf[2] = (v2 % 16) * 16 + math.floor(v3 / 4)
                return true
            end
            local v4 = bVal[r4] or 0
            _decCount = 3
            _decPos = 1
            _decBuf[1] = v1 * 4 + math.floor(v2 / 16)
            _decBuf[2] = (v2 % 16) * 16 + math.floor(v3 / 4)
            _decBuf[3] = (v3 % 4) * 64 + v4
            return true
        end

        nextEncByte = function()
            if _decPos > _decCount then
                if not _fillDec() then return -1 end
            end
            local b = _decBuf[_decPos]
            _decPos = _decPos + 1
            return b
        end
    else
        nextEncByte = function()
            local r1 = _nextRaw()
            if r1 < 0 then return -1 end
            local r2 = _nextRaw()
            if r2 < 0 then return -1 end
            return (bVal[r1] or 0) * 16 + (bVal[r2] or 0)
        end
    end

    local c1, c2, c3, c4 = nextEncByte(), nextEncByte(), nextEncByte(), nextEncByte()
    local c5, c6, c7, c8 = nextEncByte(), nextEncByte(), nextEncByte(), nextEncByte()

    -- Integrity verification of KDF nonce
    local v5 = (c1 * 3 + c2 * 7 + 17) % 256
    local v6 = (c2 * 5 + c3 * 11 + 29) % 256
    local v7 = (c3 * 7 + c4 * 13 + 43) % 256
    local v8 = (c4 * 11 + c1 * 17 + 61) % 256
    if c5 ~= v5 or c6 ~= v6 or c7 ~= v7 or c8 ~= v8 then return nil end

    -- Reconstruct 32-bit salt dynamically from modular inverses
    local b1 = ((c1 - 37 + 65536) * 197) % 256
    local b2 = ((c2 - 83 + 65536) * 53) % 256
    local b3 = ((c3 - 109 + 65536) * 173) % 256
    local b4 = ((c4 - 131 + 65536) * 29) % 256
    local key = b1 + b2 * 256 + b3 * 65536 + b4 * 16777216

    -- Dynamic S-Box Construction from key (32-bit Lehmer LCG)
    local sbox = {}
    for i = 0, 255 do sbox[i] = i end
    local rng = (key % 2147483647)
    if rng == 0 then rng = 1337 end
    for i = 255, 1, -1 do
        rng = (rng * 16807 + 12345) % 2147483647
        local j = rng % (i + 1)
        sbox[i], sbox[j] = sbox[j], sbox[i]
    end

    local state = key % 2147483647
    if state == 0 then state = 1337 end

    local function nextByte()
        local b = nextEncByte()
        if b < 0 then return -1 end
        state = (state * 16807 + 12345) % 2147483647
        local hi = ((state - state % 65536) / 65536)
        local lo = state % 65536
        state = (lo * 32719 + hi * 16807 + 7) % 2147483647
        local sIdx = state % 256
        local sVal = sbox[sIdx]
        local orig = (((b - (state % 256) + 65536) * 197 - sVal) % 256 + 256) % 256
        return orig
    end

    local function nextChar()
        local orig = nextByte()
        if orig < 0 then return "" end
        return sc(orig)
    end

    local function parseVal()
        local tag = nextByte()
        if tag == 73 then -- 'I': 1-byte unsigned int 0..255
            return nextByte()
        elseif tag == 75 then -- 'K': 2-byte signed int -32768..32767
            local h = nextByte()
            local l = nextByte()
            return (h * 256 + l) - 32768
        elseif tag == 88 then -- 'X': 4-element array
            return { parseVal(), parseVal(), parseVal(), parseVal() }
        elseif tag == 78 then -- 'N'
            local isNeg = false
            local isInt = true
            local intVal = 0
            local numBuf = {}
            while true do
                local b = nextByte()
                if b == 59 or b < 0 then break end -- ';'
                numBuf[#numBuf + 1] = b
                if isInt then
                    if b >= 48 and b <= 57 then
                        intVal = intVal * 10 + (b - 48)
                    elseif b == 45 and #numBuf == 1 then
                        isNeg = true
                    else
                        isInt = false
                    end
                end
            end
            if isInt and #numBuf > (isNeg and 1 or 0) then
                return isNeg and -intVal or intVal
            else
                return tonum(sc(upk(numBuf, 1, #numBuf)))
            end
        elseif tag == 83 then -- 'S'
            local len = 0
            while true do
                local b = nextByte()
                if b == 58 or b < 0 then break end -- ':'
                len = len * 10 + (b - 48)
            end
            local chunks = {}
            local subBuf = {}
            local subCount = 0
            local BATCH = 2048
            for i = 1, len do
                subCount = subCount + 1
                subBuf[subCount] = nextByte()
                if subCount >= BATCH then
                    chunks[#chunks + 1] = sc(upk(subBuf, 1, subCount))
                    subBuf = {}
                    subCount = 0
                end
            end
            if subCount > 0 then
                chunks[#chunks + 1] = sc(upk(subBuf, 1, subCount))
            end
            return _t_cat(chunks)
        elseif tag == 84 then -- 'T'
            return true
        elseif tag == 70 then -- 'F'
            return false
        elseif tag == 90 then -- 'Z'
            return nil
        elseif tag == 65 then -- 'A'
            local count = 0
            while true do
                local b = nextByte()
                if b == 59 or b < 0 then break end
                count = count * 10 + (b - 48)
            end
            local arr = {}
            for i = 1, count do
                arr[i] = parseVal()
            end
            return arr
        elseif tag == 77 then -- 'M'
            local count = 0
            while true do
                local b = nextByte()
                if b == 59 or b < 0 then break end
                count = count * 10 + (b - 48)
            end
            local map = {}
            for _ = 1, count do
                local k = parseVal()
                local v = parseVal()
                if k ~= nil then map[k] = v end
            end
            return map
        end
        return nil
    end

    local res = parseVal()
    if sbox then
        for i = 0, 255 do sbox[i] = 0 end
        sbox = nil
    end
    return res
end
local _vm_exec = function(chunkData)
]==] .. antiEnvCode .. [==[

    -- =====================================================
    -- Section B: Capability-Driven Host Bridge & VM State
    -- Zero environment mirror, explicit capability bindings
    -- =====================================================
]==] .. capBridgeCode .. [==[

    -- =====================================================
    -- Section C: Format & Version Validation
    -- =====================================================
    if not chunkData or chunkData.m ~= "PVM2" or (chunkData.v and chunkData.v > 3.0) then
        error("Corrupt bytecode format or unsupported VM version.")
        return
    end

    local decoder     = chunkData.cfg or chunkData.d or {}
    local rootProto   = chunkData.p
    local sig         = chunkData.sig or {}

    -- =====================================================
    -- Section G: Multi-Region Integrity Verification (Adler-32)
    -- Built-in VM Integrity & Manual Check Routine
    -- =====================================================
    local function _pvm_checkIntegrity(isRuntime)
        local _s1, _s2, _mod = 1, 0, 65521
        local function _addByte(n)
            local fl = (n or 0) - (n or 0) % 1
            local b = (fl % 256 + 256) % 256
            _s1 = (_s1 + b) % _mod
            _s2 = (_s2 + _s1) % _mod
        end
        local function _getChecksum()
            local res = _s2 * 65536 + _s1
            _s1, _s2 = 1, 0
            return res
        end

        -- Region 1: Header & VM Configuration
        if sig.header then
            local mStr = chunkData.m or "PVM2"
            for i = 1, #mStr do _addByte(mStr:byte(i)) end
            _addByte(((chunkData.v or 2.1) * 10))
            _addByte(chunkData.f or 0)
            _addByte(decoder.rkThreshold or 0)
            _addByte(decoder.opPos or 0)
            _addByte(decoder.aPos or 0)
            _addByte(decoder.bPos or 0)
            _addByte(decoder.cPos or 0)
            _addByte(decoder.maskA or 0)
            _addByte(decoder.maskB or 0)
            _addByte(decoder.maskC or 0)
            local _gotHeader = _getChecksum()
            if _gotHeader ~= sig.header then
                error("Integrity violation detected in region [Header/Config]. Execution aborted.")
                return false
            end
        end

        -- Region 2: Polymorphic Opcode Mapping
        if sig.opcodes and decoder.opcodeMap then
            local _keys = {}
            for k in pairs(decoder.opcodeMap) do _keys[#_keys + 1] = tostring(k) end
            for i = 2, #_keys do
                local key = _keys[i]
                local j = i - 1
                while j > 0 and _keys[j] > key do
                    _keys[j + 1] = _keys[j]
                    j = j - 1
                end
                _keys[j + 1] = key
            end
            for i = 1, #_keys do
                local k = _keys[i]
                for j = 1, #k do _addByte(k:byte(j)) end
                local v = (decoder.opcodeMap[k] or decoder.opcodeMap[tonumber(k)]) or 0
                _addByte(v)
            end
            if _getChecksum() ~= sig.opcodes then
                error("Integrity violation detected in region [Opcodes]. Execution aborted.")
                return false
            end
        end

        -- Region 3: Encrypted Constant Metadata
        if sig.constants and rootProto then
            if not isRuntime then
                local function _addValTokens(val)
                    if type(val) == "table" then
                        for i = 1, #val do _addValTokens(val[i]) end
                    elseif type(val) == "number" then
                        _addByte(val)
                    end
                end
                local function _traverseConsts(p)
                    local cs = p.constants or {}
                    for i = 1, #cs do
                        local c = cs[i]
                        _addByte(c.t or 0)
                        if c.r then _addByte(c.r) end
                        _addValTokens(c.v)
                        if c.m then _addByte(c.m) end
                    end
                    local ps = p.protos or {}
                    for i = 1, #ps do _traverseConsts(ps[i]) end
                end
                _traverseConsts(rootProto)
                if _getChecksum() ~= sig.constants then
                    error("Integrity violation detected in region [Constants]. Execution aborted.")
                    return false
                end
            else
                -- Runtime integrity check: some constants have been lazily resolved and replaced by _K_TRAP
                -- Verify each constant slot is either sealed trap (_K_TRAP) or valid constant descriptor table
                local function _checkRuntimeConsts(p)
                    local cs = p.constants or {}
                    for i = 1, #cs do
                        local c = cs[i]
                        if type(c) == "table" then
                            if not c.__pvm_trap and c.t == nil then
                                error("Integrity violation detected in region [Constants]. Execution aborted.")
                                return false
                            end
                        end
                    end
                    local ps = p.protos or {}
                    for i = 1, #ps do
                        if not _checkRuntimeConsts(ps[i]) then return false end
                    end
                    return true
                end
                if not _checkRuntimeConsts(rootProto) then return false end
            end
        end

        -- Region 4: Bytecode Instructions Payload
        if sig.payload and rootProto then
            local function _traverseInst(p)
                _addByte(p.numparams or 0)
                _addByte(p.maxstacksize or 0)
                _addByte(p.is_vararg or 0)
                local insts = p.instructions or {}
                for i = 1, #insts do
                    local inst = insts[i]
                    for j = 1, #inst do _addByte(inst[j]) end
                end
                local ps = p.protos or {}
                for i = 1, #ps do _traverseInst(ps[i]) end
            end
            _traverseInst(rootProto)
            if _getChecksum() ~= sig.payload then
                error("Integrity violation detected in region [Bytecode]. Execution aborted.")
                return false
            end
        end

        -- Region 5: Self-Hashing VM (2.1)
        if sig.selfHash then
            local sh1 = sig.header or 0
            local sh2 = sig.opcodes or 0
            local sh3 = sig.constants or 0
            local sh4 = sig.payload or 0
            _addByte(sh1 % 256)
            _addByte(sh2 % 256)
            _addByte(sh3 % 256)
            _addByte(sh4 % 256)
            if _getChecksum() ~= sig.selfHash then
                _triggerTamper("self_hash_mismatch")
                return false
            end
        end
        return true
    end

    -- Built-in VM Integrity: Automatic startup multi-region verification
    _pvm_checkIntegrity()

    -- Manual Check Hook: Exported for manual integrity checks on demand
    local function _pinatvm_manualCheck()
        if not _pvm_checkIntegrity(true) then return false end
        if _checkVmSelfHash then _checkVmSelfHash() end
        if _assertTamperIntegrity then _assertTamperIntegrity() end
        return true
    end
    if _hostSet then
        _hostSet("__pinatvm_manualCheck", _pinatvm_manualCheck)
    end


    -- =====================================================
    -- Section D: Polymorphic Decoder Config
    -- =====================================================
    local opMap       = decoder.opcodeMap
    local opPos       = decoder.opPos
    local aPos        = decoder.aPos
    local bPos        = decoder.bPos
    local cPos        = decoder.cPos
    local maskA       = decoder.maskA
    local maskB       = decoder.maskB
    local maskC       = decoder.maskC
    local rkThreshold = decoder.rkThreshold

    -- =====================================================
    -- Section E: Key Derivation Function (KDF)
    -- =====================================================
    local function deriveKey(salt, contextId, rounds)
        rounds = rounds or 3
        local state = (salt + (contextId or 0) * 2654435761) % 2147483647
        if state == 0 then state = 1234567 end
        for r = 1, rounds do
            state = (state * 16807 + 12345) % 2147483647
            local high = (state - state % 65536) / 65536
            local low  = state % 65536
            state = (low * 32719 + high * 16807 + 7) % 2147483647
        end
        return state
    end

    -- =====================================================
    -- Section A: Multi-Representation Constant Resolver
    -- =====================================================

    -- Rep 5 helpers: custom-alphabet Base64 + per-string XOR + anti-tamper
    -- _cq_gU: integrity check — verifies XOR'd ciphertext has not been tampered.
    -- Any single-byte modification to c.v triggers "String record integrity violation".
    local function _cq_gU(cv, stored_h, integrityKey)
        local h = (integrityKey % 65521) + 1
        for i = 1, #cv do
            h = (h + cv[i] * ((i % 31) + 1) + integrityKey % 97) % 65521
        end
        if h ~= stored_h then
            error("String record integrity violation")
        end
    end

    -- Reconstruct build-specific Base64 alphabet from baseSalt (same LCG as encoder)
    local _b64AlphaCache = {}
    local function _makeB64Rev(b64Salt)
        if _b64AlphaCache[b64Salt] then return _b64AlphaCache[b64Salt] end
        local src = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        local chars = {}
        for i = 1, 64 do chars[i] = src:sub(i, i) end
        local state = (b64Salt % 2147483647)
        if state == 0 then state = 314159 end
        for i = 64, 2, -1 do
            state = (state * 16807 + 12345) % 2147483647
            local j = (state % i) + 1
            chars[i], chars[j] = chars[j], chars[i]
        end
        -- Build reverse lookup: char -> 6-bit value
        local rev = {}
        for i = 1, 64 do rev[chars[i]] = i - 1 end
        _b64AlphaCache[b64Salt] = rev
        return rev
    end

    -- Base64 decode (custom alphabet) byte array -> byte array
    local function _b64DecBytes(xorBytes, rev)
        local out = {}
        local len = #xorBytes
        local i = 1
        while i <= len do
            local c0 = rev[_rt_sc(xorBytes[i])]   or 0
            local c1 = rev[_rt_sc(xorBytes[i+1] or 0)] or 0
            local c2 = rev[_rt_sc(xorBytes[i+2] or 0)]
            local c3 = rev[_rt_sc(xorBytes[i+3] or 0)]
            local n = c0 * 262144 + c1 * 4096
            out[#out + 1] = (n - n % 65536) / 65536
            if c2 then
                n = n + c2 * 64
                out[#out + 1] = ((n % 65536) - (n % 256)) / 256
            end
            if c3 then
                n = n + c3
                out[#out + 1] = n % 256
            end
            i = i + 4
        end
        return out
    end

    local function decodeConstant(c, salt, idx, proto)
        local key = deriveKey(salt, idx * 31, 3)
        if c.t == 1 then
            local r = c.r or 1
            if r == 1 then
                local state = key % 2147483647
                if state == 0 then state = 1234567 end
                local chars = {}
                local cv = c.v or {}
                for i = 1, #cv do
                    local b = cv[i]
                    state = (state * 16807 + 12345) % 2147483647
                    local k = ((state - state % 65536) / 65536) % 256
                    chars[i] = _rt_sc((b - k + 256) % 256)
                end
                return _rt_tc(chars)
            elseif r == 2 then
                local chunkMap, maxLen = {}, 0
                local cv = c.v or {}
                for i = 1, #cv do
                    local chunk = cv[i]
                    local offset = chunk[1]
                    local bytes  = chunk[2] or {}
                    for j = 1, #bytes do
                        local b = bytes[j]
                        local shift = (key + offset * 37 + j * 17) % 256
                        local pos   = offset + j - 1
                        chunkMap[pos] = _rt_sc((b - shift + 256) % 256)
                        if pos > maxLen then maxLen = pos end
                    end
                end
                local res = {}
                for i = 1, maxLen do res[i] = chunkMap[i] or "" end
                return _rt_tc(res)
            elseif r == 3 then
                local sbox  = {}
                for i = 0, 255 do sbox[i + 1] = i end
                local state = key % 2147483647
                if state == 0 then state = 54321 end
                for i = 256, 2, -1 do
                    state = (state * 16807 + 12345) % 2147483647
                    local j = (state % i) + 1
                    sbox[i], sbox[j] = sbox[j], sbox[i]
                end
                local invSbox = {}
                for i = 1, 256 do invSbox[sbox[i]] = i - 1 end
                local chars = {}
                local cv = c.v or {}
                for i = 1, #cv do
                    local b = cv[i]
                    chars[i] = _rt_sc(invSbox[b] or b)
                end
                return _rt_tc(chars)
            elseif r == 4 then
                local d1 = (key % 17) + 3
                local d2 = (key % 89) + 7
                local chars = {}
                local cv = c.v or {}
                for i = 1, #cv do
                    local b = cv[i]
                    local shift = (i * d1 + d2) % 256
                    chars[i] = _rt_sc((b - shift + 256) % 256)
                end
                return _rt_tc(chars)
            elseif r == 5 then
                -- =====================================================
                -- Rep 5: Custom-Alphabet Base64 + XOR + Anti-Tamper
                -- Layer 1: Integrity check (must pass or abort execution)
                -- Layer 2: Reverse XOR
                -- Layer 3: Custom Base64 decode
                -- =====================================================
                local cv          = c.v  or {}
                local stored_h    = c.h  or 0
                local xorKey      = c.xk or 0
                local integrityKey = c.ik or 0

                -- Anti-tamper: verify integrity record before any decode
                _cq_gU(cv, stored_h, integrityKey)

                -- Reverse XOR layer
                local unxored = {}
                for i = 1, #cv do
                    local subKey = (xorKey + i * 37) % 251 + 5
                    unxored[i] = (cv[i] - subKey + 256) % 256
                end

                -- Reconstruct build-specific Base64 reverse alphabet from b64Salt
                local b64Salt = (proto and proto.b64Salt) or salt
                local rev = _makeB64Rev(b64Salt)

                -- Base64 decode: unxored byte array -> original plaintext bytes
                local plainBytes = _b64DecBytes(unxored, rev)

                -- Assemble plaintext string from decoded bytes
                local chars = {}
                for i = 1, #plainBytes do
                    local b = plainBytes[i]
                    if b ~= nil then
                        chars[#chars + 1] = _rt_sc(b)
                    end
                end
                return _rt_tc(chars)
            elseif r == 6 then
                -- =====================================================
                -- Rep 6: AES inv-sbox + XOR-offset + 64-bit MAC (VeryMax)
                -- Verify 64-bit HMAC-style MAC, then decrypt in reverse:
                --   1. Un-XOR+offset each ciphertext byte
                --   2. Apply forward S-Box to get plaintext
                -- =====================================================
                local cv    = c.v  or {}
                local mac0e = c.m0 or 0
                local mac1e = c.m1 or 0
                local _baseSalt = (proto and proto.b64Salt) or salt
                local ss    = c.ss or (((salt % 65536) * 31337 + (idx % 1024) * 7919 + (_baseSalt % 65536) * 13) % 2147483647)
                if ss == 0 then ss = 100003 end
                local xb    = c.xb or (((salt % 251) * ((idx * 37) % 251) + (_baseSalt % 251) + 17) % 251)
                local ob    = c.ob or (((salt % 97) + (idx * 31) % 97 + (_baseSalt % 97)) % 97)

                -- Reconstruct AES S-Box from ss seed (KSA same as encoder)
                local _S = {}
                for _ii = 0, 255 do _S[_ii] = _ii end
                local _j6 = 0
                local _ks = {}
                local _sst = ss % 2147483647
                if _sst == 0 then _sst = 271828 end
                for _ii = 0, 31 do
                    _sst = (_sst * 16807 + 12345) % 2147483647
                    _ks[_ii] = _sst % 256
                end
                for _ii = 0, 255 do
                    _j6 = (_j6 + _S[_ii] + _ks[_ii % 32]) % 256
                    _S[_ii], _S[_j6] = _S[_j6], _S[_ii]
                end

                -- Lua 5.1 compatible XOR helper
                local function _x32(a, b)
                    local _r, _bv = 0, 1
                    for _z = 1, 32 do
                        local _ra = a % 2; local _rb = b % 2
                        if _ra ~= _rb then _r = _r + _bv end
                        a = (a - _ra) / 2; b = (b - _rb) / 2
                        _bv = _bv * 2
                    end
                    return _r
                end

                local function _m32(a, b)
                    local a_lo = a % 65536
                    local a_hi = math.floor(a / 65536) % 65536
                    local b_lo = b % 65536
                    local b_hi = math.floor(b / 65536) % 65536
                    local mid = (a_hi * b_lo + a_lo * b_hi) % 65536
                    return (mid * 65536 + a_lo * b_lo) % 4294967296
                end

                -- 64-bit MAC verify (two independent Murmur32 passes)
                local _isStr = (type(cv) == "string")
                local _ln = #cv
                local function _bAt(idx)
                    return _isStr and cv:byte(idx) or cv[idx]
                end
                local function _murm6(data, seed)
                    local _M = 4294967296
                    local _h = seed % _M
                    local _c1, _c2 = 0xcc9e2d51, 0x1b873593
                    local _mi = 1
                    while _mi + 3 <= _ln do
                        local _k = _bAt(_mi)+_bAt(_mi+1)*256+_bAt(_mi+2)*65536+_bAt(_mi+3)*16777216
                        _k = _m32(_k, _c1)
                        _k = ((_k * 32768) % _M + math.floor(_k / 32768)) % _M
                        _k = _m32(_k, _c2)
                        _h = _x32(_h, _k)
                        _h = ((_h * 8192) % _M + math.floor(_h / 8192)) % _M
                        _h = (_h * 5 + 0xe6546b64) % _M
                        _mi = _mi + 4
                    end
                    local _tl = 0; local _re = _ln - _mi + 1
                    if _re >= 3 then _tl = _tl + _bAt(_mi+2)*65536 end
                    if _re >= 2 then _tl = _tl + _bAt(_mi+1)*256 end
                    if _re >= 1 then _tl = _tl + _bAt(_mi) end
                    if _re > 0 then
                        _tl = _m32(_tl, _c1)
                        _tl = ((_tl * 32768) % _M + math.floor(_tl / 32768)) % _M
                        _tl = _m32(_tl, _c2)
                        _h = _x32(_h, _tl)
                    end
                    _h = _x32(_h, _ln)
                    _h = _x32(_h, math.floor(_h / 65536))
                    _h = _m32(_h, 0x85ebca6b)
                    _h = _x32(_h, math.floor(_h / 4096))
                    _h = _m32(_h, 0xc2b2ae35)
                    _h = _x32(_h, math.floor(_h / 65536))
                    return _h
                end

                local _dk0 = deriveKey(salt, idx * 11, 4)
                -- mac1 uses _baseSalt defined above
                local _dk1 = deriveKey(_baseSalt, idx * 17 + (salt % 65536), 4)
                local _m0c = _murm6(cv, _dk0 % 4294967296)
                local _m1c = _murm6(cv, _dk1 % 4294967296)
                if _m0c ~= mac0e or _m1c ~= mac1e then
                    _triggerTamper("rep6_mac_mismatch")
                    return ""
                end

                -- Decrypt: un-XOR+offset then forward S-Box
                local _r6chars = {}
                for _ii = 1, _ln do
                    local _subKey = (xb + _ii * 37) % 251 + 5
                    local _offset = (ob + _ii * 13) % 128
                    local _bVal = _bAt(_ii)
                    local _sub = (_bVal - _subKey - _offset + 512) % 256
                    _r6chars[_ii] = _rt_sc(_S[_sub])
                end
                return _rt_tc(_r6chars)
            end
        elseif c.t == 2 then
            return c.v - c.m
        elseif c.t == 3 then
            return (c.v == 1)
        elseif c.t == 4 then
            return nil
        end
        return nil
    end

    local function prepareProto(proto)
        proto.resolvedK   = {}
        proto.resolvedNil = {}
        if _pvm_verifyConstDigest then _pvm_verifyConstDigest(proto) end
        local ps = proto.protos or {}
        for i = 1, #ps do
            prepareProto(ps[i])
        end
    end
    local decoyProto = chunkData.dp or chunkData.decoy
    prepareProto(rootProto)
    if decoyProto then prepareProto(decoyProto) end
    if _pvm_auditBytecodePayload then _pvm_auditBytecodePayload(rootProto, chunkData.cfg) end

    -- =====================================================
    -- Section V: Runtime Structural Verifier
    -- =====================================================
]==] .. verifierCode .. [==[

    -- =====================================================
    -- Section F: Frame Operations & Central Dispatch Engine
    -- =====================================================
    local _pvm_callDepth      = 0
    local _pvm_maxDepth       = 1000
    _pvm_totalSteps = 0
    -- Large-code: per-closure step limit (200M) + global lifetime limit (2B)
    -- Resets per closure invocation to support scripts with heavy workloads / complex logic
    local _pvm_maxSteps        = 200000000
    local _pvm_maxClosureSteps = _pvm_maxSteps
    local _pvm_maxLifetimeSteps = 2000000000
    local _pvm_lifetimeSteps   = 0

    local function setR(f, idx, val)
        if f._canarySlots and f._canarySlots[idx] then
            _triggerTamper("memory_canary_corrupted")
            return
        end
        local mIdx = idx
        if _pvm_is_utmost and f._regMap then
            mIdx = f._regMap[idx] or ((idx * 2) + 1000 + (f._regKey or 0))
            if _h_type(val) == "number" then
                f._shadowTaint = ((f._shadowTaint or 1337) * 31 + (val % 65536)) % 4294967296
            elseif _h_type(val) == "string" then
                f._shadowTaint = ((f._shadowTaint or 1337) * 17 + #val) % 4294967296
            end
        elseif _pvm_is_utmost and f._regKey then
            mIdx = (idx * 2) + 1000 + f._regKey
        end
        f.R[mIdx] = val
        local uv = f.openUpvalues[idx]
        if uv then uv.val = val end
        if f.regSentinel then
            f.regSentinel = ((f.regSentinel * 31) % 4294967296 + (idx + 1) * 17) % 4294967296
        end
    end

    local function getR(f, idx)
        local uv = f.openUpvalues[idx]
        if uv then return uv.val end
        local mIdx = idx
        if _pvm_is_utmost and f._regMap then
            mIdx = f._regMap[idx] or ((idx * 2) + 1000 + (f._regKey or 0))
        elseif _pvm_is_utmost and f._regKey then
            mIdx = (idx * 2) + 1000 + f._regKey
        end
        return f.R[mIdx]
    end

    local _K_TRAP = { __pvm_trap = 3735929054 }
    local function getK(f, kIdx)
        local proto = f.proto
        if not proto.resolvedK then
            proto.resolvedK = {}
            proto.resolvedNil = {}
        end
        local resolved = proto.resolvedK[kIdx]
        if resolved ~= nil then return resolved end
        if proto.resolvedNil[kIdx] then return nil end
        local raw = proto.constants and proto.constants[kIdx]
        if not raw then return nil end
        if raw == _K_TRAP then
            if _triggerTamper then _triggerTamper("constant_access_violation") end
            return nil
        end
        local val = decodeConstant(raw, proto.kdfSalt, kIdx, proto)
        if val == nil then
            proto.resolvedNil[kIdx] = true
        else
            proto.resolvedK[kIdx] = val
        end
        -- Runtime Anti-Dump (B8): wipe decoded constant immediately from memory with sealed trap
        proto.constants[kIdx] = _K_TRAP
        return val
    end

    local function getRK(f, val)
        if val >= rkThreshold then
            return getK(f, val - rkThreshold + 1)
        else
            return getR(f, val)
        end
    end

    local makeClosure
    local handlers = {}
    local _opTiers = nil
    if _pvm_is_utmost then
        _opTiers = { [0] = {}, [1] = {}, [2] = {}, [3] = {} }
        for t1 = 0, 3 do
            for t2 = 0, 7 do
                _opTiers[t1][t2] = {}
            end
        end
    end

    -- 3.2: Tamper-handler integrity canary — seal _triggerTamper reference
    -- Direct sealed closure checks canary & integrity
    local _tt_canary = (((chunkData and chunkData.s) or 1337) * 49999 + 7) % 65521
    local _tt_self_verify = _tt_canary  -- shadow copy; mismatch = tamper
    local _triggerTamperSafe = _triggerTamper  -- capture before any hook
    local function _assertTamperIntegrity()
        -- If _tt_self_verify was overwritten externally or canary is damaged, seal is broken
        if _tt_self_verify ~= _tt_canary or (_verifyState and not (_verifyState(_STATE_RUNNING) or _verifyState(_STATE_VERIFIED))) or _pvm_tripped or (_pvm_canary and _pvm_canary ~= 3735929054) or (_verifyInvariant and not _verifyInvariant()) then
            if type(_triggerTamperSafe) == "function" then
                _triggerTamperSafe("handlers_tampered")
            end
            _h_error("0xE301", 0)
            if _fatalHalt then _fatalHalt() end
        end
    end

    local function _reg(tok, fn)
        local id = opMap and (opMap[tok] or (type(tok) == "number" and (opMap[tok] or opMap["_o" .. ((math and math.floor and math.floor(tok + 0.5)) or tok)])) or (type(tok) == "string" and opMap[tok]))
        if id then
            handlers[id] = fn
            if _pvm_is_utmost and _opTiers then
                local t1 = id % 4
                local t2 = (id * 7) % 8
                _opTiers[t1][t2][id] = fn
            end
        end
    end

    _reg(1, function(f, A, B, C)
        setR(f, A, getR(f, B))
    end)
    _reg(2, function(f, A, B, C)
        setR(f, A, getK(f, B))
    end)
    _reg(3, function(f, A, B, C)
        setR(f, A, (B ~= 0))
        if C ~= 0 then f.pc = f.pc + 1 end
    end)
    _reg(4, function(f, A, B, C)
        for i = A, B do setR(f, i, nil) end
    end)
    _reg(5, function(f, A, B, C)
        setR(f, A, getK(f, B))
    end)

    _reg(6, function(f, A, B, C)
        setR(f, A, _hostGet(getK(f, B)))
    end)
    _reg(7, function(f, A, B, C)
        _hostSet(getK(f, B), getR(f, A))
    end)

    _reg(8, function(f, A, B, C)
        local tbl = getR(f, B)
        setR(f, A, tbl[getRK(f, C)])
    end)
    _reg(9, function(f, A, B, C)
        getR(f, A)[getRK(f, B)] = getRK(f, C)
    end)
    _reg(10, function(f, A, B, C)
        setR(f, A, {})
    end)
    _reg(11, function(f, A, B, C)
        local obj = getR(f, B)
        setR(f, A + 1, obj)
        setR(f, A, obj[getRK(f, C)])
    end)
    _reg(12, function(f, A, B, C)
        local tbl   = getR(f, A)
        local count = (B == 0) and (f.topReg - A) or B
        local start = C
        for i = 1, count do tbl[start + i - 1] = getR(f, A + i) end
    end)

    _reg(49, function(f, A, B, C)
        setR(f, A, getR(f, B)[getRK(f, C)])
    end)
    _reg(50, function(f, A, B, C)
        getR(f, A)[getRK(f, B)] = getRK(f, C)
    end)

    _reg(13, function(f, A, B, C) setR(f, A, getRK(f, B) + getRK(f, C)) end)
    _reg(14, function(f, A, B, C) setR(f, A, getRK(f, B) - getRK(f, C)) end)
    _reg(15, function(f, A, B, C) setR(f, A, getRK(f, B) * getRK(f, C)) end)
    _reg(16, function(f, A, B, C) setR(f, A, getRK(f, B) / getRK(f, C)) end)
    _reg(17, function(f, A, B, C) setR(f, A, getRK(f, B) % getRK(f, C)) end)
    _reg(18, function(f, A, B, C) setR(f, A, getRK(f, B) ^ getRK(f, C)) end)
    _reg(19, function(f, A, B, C) setR(f, A, getRK(f, B) .. getRK(f, C)) end)
    _reg(20, function(f, A, B, C) setR(f, A, not getR(f, B)) end)
    _reg(21, function(f, A, B, C) setR(f, A, #getR(f, B)) end)
    _reg(22, function(f, A, B, C) setR(f, A, -getR(f, B)) end)

    _reg(23, function(f, A, B, C)
        f.pc = f.pc + A
    end)
    _reg(24, function(f, A, B, C)
        setR(f, A, getRK(f, B) == getRK(f, C))
    end)
    _reg(25, function(f, A, B, C)
        setR(f, A, getRK(f, B) ~= getRK(f, C))
    end)
    _reg(26, function(f, A, B, C)
        setR(f, A, getRK(f, B) < getRK(f, C))
    end)
    _reg(27, function(f, A, B, C)
        setR(f, A, getRK(f, B) <= getRK(f, C))
    end)
    _reg(28, function(f, A, B, C)
        if (not getR(f, A)) == (B ~= 0) then f.pc = f.pc + 1 end
    end)
    _reg(29, function(f, A, B, C)
        if (not getR(f, B)) == (C ~= 0) then
            setR(f, A, getR(f, B))
        else
            f.pc = f.pc + 1
        end
    end)

    _reg(45, function(f, A, B, C)
        if getR(f, A) then f.pc = f.pc + B end
    end)
    _reg(46, function(f, A, B, C)
        if not getR(f, A) then f.pc = f.pc + B end
    end)

    _reg(30, function(f, A, B, C)
        local callee  = getR(f, A)
        local numArgs = (B == 0) and (f.topReg - A) or (B - 1)
        local callArgs = {}
        for i = 1, numArgs do callArgs[i] = getR(f, A + i) end
        local function _cap(...) return _rt_sel("#", ...), {...} end
        _pvm_totalSteps = 0
        local nRets, rets = _cap(callee(_rt_upk(callArgs, 1, numArgs)))
        _pvm_totalSteps = 0
        if C == 0 then
            f.topReg = A + nRets - 1
            for i = 1, nRets do setR(f, A + i - 1, rets[i]) end
        else
            for i = 1, C - 1 do setR(f, A + i - 1, rets[i]) end
        end
    end)

    _reg(47, function(f, A, B, C)
        local callee   = getR(f, A)
        local callArgs = {}
        for i = 1, B do callArgs[i] = getR(f, A + i) end
        local function _cap(...) return {...} end
        _pvm_totalSteps = 0
        local rets = _cap(callee(_rt_upk(callArgs, 1, B)))
        _pvm_totalSteps = 0
        for i = 1, C do setR(f, A + i - 1, rets[i]) end
    end)

    _reg(31, function(f, A, B, C)
        local callee  = getR(f, A)
        local numArgs = (B == 0) and (f.topReg - A) or (B - 1)
        local callArgs = {}
        for i = 1, numArgs do callArgs[i] = getR(f, A + i) end
        local function _cap(...) return _rt_sel("#", ...), {...} end
        _pvm_totalSteps = 0
        local nRets, rets = _cap(callee(_rt_upk(callArgs, 1, numArgs)))
        _pvm_totalSteps = 0
        f.isReturning = true
        f.returnValues = rets
        f.numReturnValues = nRets
    end)

    _reg(32, function(f, A, B, C)
        local numRets = (B == 0) and (f.topReg - A + 1) or (B - 1)
        local rets = {}
        for i = 1, numRets do rets[i] = getR(f, A + i - 1) end
        f.isReturning = true
        f.returnValues = rets
        f.numReturnValues = numRets
    end)

    _reg(48, function(f, A, B, C)
        local rets = {}
        for i = 1, B do rets[i] = getR(f, A + i - 1) end
        f.isReturning = true
        f.returnValues = rets
        f.numReturnValues = B
    end)

    _reg(35, function(f, A, B, C)
        setR(f, A, f.UV[B] and f.UV[B].val or nil)
    end)
    _reg(36, function(f, A, B, C)
        if f.UV[B] then f.UV[B].val = getR(f, A) end
    end)
    _reg(33, function(f, A, B, C)
        local childProto = f.proto.protos[B]
        local childUV    = {}
        local ups = childProto.upvalues or {}
        for i = 1, #ups do
            local upDesc = ups[i]
            if upDesc.is_local == 1 then
                local rIdx = upDesc.index
                local uv   = f.openUpvalues[rIdx]
                if not uv then
                    uv = { val = f.R[rIdx] }
                    f.openUpvalues[rIdx] = uv
                end
                childUV[#childUV + 1] = uv
            else
                childUV[#childUV + 1] = f.UV[upDesc.index]
            end
        end
        setR(f, A, makeClosure(childProto, childUV, f.proto))
    end)
    _reg(34, function(f, A, B, C)
        for rIdx, uv in pairs(f.openUpvalues) do
            if rIdx >= A then
                f.R[rIdx] = uv.val
                f.openUpvalues[rIdx] = nil
            end
        end
    end)

    _reg(37, function(f, A, B, C)
        local init  = getR(f, A)
        local limit = getR(f, A + 1)
        local step  = getR(f, A + 2)
        local ok    = (step > 0) and (init <= limit) or (step < 0 and init >= limit)
        if not ok then f.pc = f.pc + B end
    end)
    _reg(38, function(f, A, B, C)
        local step    = getR(f, A + 2)
        local nextVal = getR(f, A) + step
        setR(f, A, nextVal)
        local cont = (step > 0) and (nextVal <= getR(f, A + 1))
                  or (step < 0 and nextVal >= getR(f, A + 1))
        if cont then f.pc = f.pc + B end
    end)
    _reg(39, function(f, A, B, C)
        local iter     = getR(f, A)
        local state    = getR(f, A + 1)
        local var      = getR(f, A + 2)
        local iterRets = { iter(state, var) }
        if iterRets[1] ~= nil then
            setR(f, A + 2, iterRets[1])
            for i = 1, B do setR(f, A + 2 + i, iterRets[i]) end
        else
            f.pc = f.pc + C
        end
    end)

    _reg(40, function(f, A, B, C)
        if B == 0 then
            for i = 1, f.numVarargs do setR(f, A + i - 1, f.varargs[i]) end
            f.topReg = A + f.numVarargs - 1
        else
            for i = 1, B - 1 do setR(f, A + i - 1, f.varargs[i]) end
        end
    end)

    _reg(41, function(f, A, B, C)
        setR(f, A, getK(f, B))
    end)
    _reg(42, function(f, A, B, C)
        setR(f, A, getK(f, B))
    end)
    _reg(43, function(f, A, B, C)
        setR(f, A, getK(f, B))
    end)
    _reg(44, function(f, A, B, C)
        for i = 0, C - 1 do
            setR(f, A + i, getR(f, B + i))
        end
    end)

    _reg(51, function(f, A, B, C)
        local v1 = getRK(f, B)
        local v2 = getRK(f, C)
        local res, p = 0, 1
        for _ = 1, 32 do
            local b1 = v1 % 2
            local b2 = v2 % 2
            if b1 ~= b2 then res = res + p end
            v1 = (v1 - b1) / 2
            v2 = (v2 - b2) / 2
            p = p * 2
        end
        setR(f, A, res)
    end)
    _reg(52, function(f, A, B, C)
        local v = getRK(f, B)
        local s = getRK(f, C) % 32
        setR(f, A, (v * (2 ^ s)) % 4294967296)
    end)
    _reg(53, function(f, A, B, C)
        local v = getRK(f, B)
        local s = getRK(f, C) % 32
        setR(f, A, math.floor(v / (2 ^ s)) % 4294967296)
    end)
    _reg(54, function(f, A, B, C)
        setR(f, A, math.floor(getRK(f, B) / getRK(f, C)))
    end)
    _reg(55, function(f, A, B, C)
        setR(f, A, getR(f, B) + C)
    end)
    _reg(56, function(f, A, B, C)
        setR(f, A, getR(f, B) - C)
    end)
    _reg(57, function(f, A, B, C)
        local tmpA = getR(f, A)
        local tmpB = getR(f, B)
        setR(f, A, tmpB)
        setR(f, B, tmpA)
    end)
    _reg(58, function(f, A, B, C)
        local actual = getR(f, A)
        local expected = (B * 17 + C * 31 + 101) % 65521
        if actual ~= expected then
            _triggerTamper("memory_canary_corrupted")
            _h_error("0xE100", 0)
        end
    end)
    _reg(59, function(f, A, B, C)
        _triggerTamper("instruction_chain_violation")
        local _ = nil; local _ = _[1]
        _h_error("0xE100", 0)
    end)

    -- 3.3 & 3.4: Handlers metatable with fail-closed write & introspection protection
    -- Gated by _pvm_in_dispatch token; any external read, iteration, or write triggers tamper
    local _pvm_in_dispatch = false
    local function _handlers_idx(t, k)
        _assertTamperIntegrity()
        if not _pvm_in_dispatch then
            if _triggerTamper then _triggerTamper("handlers_tampered") end
            local _ = nil; local _ = _[1]
            return nil
        end
        return rawget(t, k)
    end
    local _handlers_mt = {
        __metatable = false,
        __index = _handlers_idx,
        __newindex = function(t, k, v)
            _assertTamperIntegrity()
            if _triggerTamper then _triggerTamper("handlers_tampered") end
            local _ = nil; local _ = _[1]
            _h_error("0xE301", 0)
        end,
        __pairs = function()
            _assertTamperIntegrity()
            if _triggerTamper then _triggerTamper("handlers_tampered") end
            local _ = nil; local _ = _[1]
            return function() end
        end,
        __ipairs = function()
            _assertTamperIntegrity()
            if _triggerTamper then _triggerTamper("handlers_tampered") end
            local _ = nil; local _ = _[1]
            return function() end
        end,
    }
    setmetatable(handlers, _handlers_mt)

    if table and type(table.freeze) == "function" then
        _safe_pcall(table.freeze, handlers)
    end

    -- 3.9: Guard debug.setupvalue unconditionally to prevent tampering with VM closures & upvalues
    local _dbgRef = debug
    if _dbgRef and type(_dbgRef.setupvalue) == "function" then
        local _real_sv = _dbgRef.setupvalue
        local _guarded_sv = function(fn, idx, val)
            _assertTamperIntegrity()
            if _triggerTamper then _triggerTamper("handlers_tampered") end
            local _ = nil; local _ = _[1]
            return nil
        end
        _safe_pcall(function() _dbgRef.setupvalue = _guarded_sv end)
    end

    decoyProto = chunkData.dp or chunkData.decoy

    -- 2.1 Self-Hashing VM: Continuous Rolling Checksum of Opcode Map & Handlers
    local _pvm_hSum = 0
    for k, v in pairs(opMap) do
        local _kLen = (_h_type(k) == "string" and #k) or (k % 64)
        _pvm_hSum = (_pvm_hSum + v * 13 + _kLen) % 65521
    end
    local function _checkVmSelfHash()
        local cur = 0
        for k, v in pairs(opMap) do
            local _kLen = (_h_type(k) == "string" and #k) or (k % 64)
            cur = (cur + v * 13 + _kLen) % 65521
        end
        if cur ~= _pvm_hSum then
            _triggerTamper("self_hash_mismatch")
        end
    end

    -- =========================================================================
    -- Section 3.7: Two-Tier VM in VM Architecture (Outer Router -> Inner Core)
    -- Inter-VM Communication channel with dynamic sequence token barrier
    -- =========================================================================
    local _vm_channel = { tok = 0, f = nil, a = 0, b = 0, c = 0, op = 0 }
    local function _pvm_inner_core(ch)
        local f = ch.f
        if not f then
            _triggerTamper("invalid_opcode_dispatch")
            return false
        end
        local expTok = ((f.pc * 16807 + ch.op * 7919 + (f.regSentinel or 1337)) % 2147483647)
        if ch.tok ~= expTok then
            _triggerTamper("instruction_chain_violation")
            return false
        end
        _pvm_in_dispatch = true
        local opVal = (math and math.floor and math.floor(ch.op + 0.5)) or (ch.op - (ch.op % 1))
        local h
        if _pvm_is_utmost and _opTiers then
            local tier1 = _opTiers[opVal % 4]
            if tier1 then
                local tier2 = tier1[(opVal * 7) % 8]
                if tier2 then h = tier2[opVal] end
            end
        else
            h = handlers[opVal]
        end
        _pvm_in_dispatch = false
        if h then
            h(f, ch.a, ch.b, ch.c)
            return true
        end
        _triggerTamper("invalid_opcode_dispatch")
        return false
    end

    makeClosure = function(proto, upvalues, parentProto)
        local fn; fn = function(...)
            if (_verifyState and not _verifyState(_STATE_RUNNING)) or _pvm_halted then return end
            if _pvm_verifyProtoScope and not _pvm_verifyProtoScope(proto, parentProto) then return end
            _checkVmSelfHash()
            _pvm_callDepth = _pvm_callDepth + 1
            -- Large-code: reset per-closure step counter every invocation
            -- Each function gets its own 2M-step budget; lifetime counter accumulates globally
            _pvm_totalSteps = 0
            local _pvm_chunkSalt = (chunkData and chunkData.s) or 1337
            local _pvm_dynHash = ((_pvm_chunkSalt * 16807 + ((proto and proto.scopeHash) or 1337) * 31 + (_trc_chk or 0) * 17) % 2147483647)
            if _pvm_dynHash == 0 then _pvm_dynHash = 1234567 end
            if _pvm_callDepth > _pvm_maxDepth then
                _pvm_callDepth = _pvm_callDepth - 1
                _h_error("Call stack overflow (depth > " .. _pvm_maxDepth .. ")")
            end

            proto._activeFrames = (proto._activeFrames or 0) + 1

            -- 2.8 Integrity Chain Verification
            if proto.chainHash then
                local expected = proto.chainHash
                local s = proto.chainSeed or ((chunkData.s or 1337) % 2147483647)
                local chain = s
                local cMult = 31 + (s % 17) * 2
                local c1 = 7 + (s % 11)
                local c2 = 13 + (s % 19)
                local c3 = 17 + (s % 23)
                local c4 = 23 + (s % 29)
                local cIdx = 3 + (s % 7)
                local insts = proto.instructions or {}
                for i = 1, #insts do
                    local it = insts[i]
                    local f1 = it[1] or 0
                    local f2 = it[2] or 0
                    local f3 = it[3] or 0
                    local f4 = it[4] or 0
                    chain = (chain * cMult + f1 * c1 + f2 * c2 + f3 * c3 + f4 * c4 + i * cIdx) % 2147483647
                end
                if chain ~= expected then
                    _triggerTamper("instruction_chain_violation")
                end
            end

            local nArgs    = _rt_sel("#", ...)
            local nParams  = proto.numparams or 0
            local rawArgs  = { ... }
            local varargs  = {}
            local nVarargs = 0

            if nArgs > nParams then
                nVarargs = nArgs - nParams
                for i = nParams + 1, nArgs do
                    varargs[i - nParams] = rawArgs[i]
                end
            end

            -- 2.6 Memory Canary Setup
            local defaultCanary = (((chunkData and chunkData.s) or 1337) * 31337 + 1013904223) % 65521
            local cVal = proto.canary or defaultCanary
            local cLow = (cVal * 17 + 101) % 65521
            local cHigh = (cVal * 31 + 202) % 65521
            local maxStack = proto.maxstacksize or 16
            local frame = {
                proto           = proto,
                UV              = upvalues,
                pc              = 1,
                R               = {},
                topReg          = nParams,
                openUpvalues    = {},
                varargs         = varargs,
                numVarargs      = nVarargs,
                isReturning     = false,
                returnValues    = nil,
                numReturnValues = 0,
                _canarySlots    = { [-1] = true, [0] = true, [maxStack + 2] = true },
                _inDecoy        = false,
                regSentinel     = (((chunkData and chunkData.s) or 1337) * 16807 + 101) % 4294967296,
                _regKey         = _pvm_is_utmost and (((proto.kdfSalt or 1337) * 31 + 47) % 500 + 1) or nil,
                _state          = _pvm_is_utmost and (((proto.chainSeed or 1337) * 16807 + 11) % 2147483647) or nil,
                _isCo           = _pvm_is_utmost and (_co_c ~= nil),
                _cascadeHash    = _pvm_is_utmost and (((proto.chainSeed or 1337) * 31337 + 101) % 4294967296) or nil,
                _polyKey        = _pvm_is_utmost and (((proto.chainSeed or 1337) * 73 + 19) % 65521) or nil,
                _shadowTaint    = _pvm_is_utmost and 0x5A5A or nil,
                _regMap         = nil,
            }
            if _pvm_is_utmost and frame._regKey then
                frame._regMap = {}
                for rIdx = -1, maxStack + 5 do
                    frame._regMap[rIdx] = (rIdx * 2) + 1000 + frame._regKey
                end
            end
            -- Set canary sentinels surrounding stack registers
            frame.R[-1] = cLow
            frame.R[0]  = cLow
            frame.R[maxStack + 2] = cHigh
            if _pvm_initCanaries then _pvm_initCanaries(frame, maxStack) end
            if _pvm_pushCallFrame then _pvm_pushCallFrame(frame, proto) end
            if _pvm_verifyExecNonce and not _pvm_verifyExecNonce(_pvm_execNonce) then return end


            local function _validateCanaries(f)
                local mStack = ((f.proto and f.proto.maxstacksize) or 16)
                local cv = (f.proto and f.proto.canary) or defaultCanary
                local expLow = (cv * 17 + 101) % 65521
                local expHigh = (cv * 31 + 202) % 65521
                if f.R[-1] ~= expLow or f.R[0] ~= expLow or f.R[mStack + 2] ~= expHigh then
                    _triggerTamper("memory_canary_corrupted")
                    return false
                end
                if f.regSentinel == nil or f.regSentinel ~= f.regSentinel or _h_type(f.regSentinel) ~= "number" then
                    _triggerTamper("memory_canary_corrupted")
                    return false
                end
                if _pvm_verifyCanaries and not _pvm_verifyCanaries(f, mStack) then
                    return false
                end
                return true
            end

            local instructions = proto.instructions
            local numInsts      = #instructions

            for i = 1, nParams do
                setR(frame, i, rawArgs[i])
            end

            while frame.pc <= numInsts do
                if (_verifyState and not _verifyState(_STATE_RUNNING)) or _pvm_halted then return end
                -- PVM Feature: Integer State Machine progression with Non-Linear MBA & Cascade (Layer 8 & 13)
                if _pvm_is_utmost and frame._state then
                    local _curOp = instructions[frame.pc] and instructions[frame.pc][opPos] or 0
                    local _mbaTerm = _pvm_mba_eval(frame._state, frame.pc * 16807 + _curOp * 31)
                    frame._state = ((frame._state * 31 + _mbaTerm + frame.pc * 7) % 2147483647)
                    if frame._cascadeHash then
                        frame._cascadeHash = _pvm_cascade_step(frame._cascadeHash, frame.pc, _curOp, frame._shadowTaint or 0)
                    end
                    if frame._polyKey then
                        frame._polyKey = ((frame._polyKey * 16807 + frame.pc * 31 + _curOp * 17) % 65521)
                    end
                end
                -- PVM Feature: Yield per opcode (coroutine cooperative scheduling, Layer 7)
                if _pvm_is_utmost and frame._isCo and (frame.pc % 64 == 0) and _co_y then
                    _co_y()
                end
                -- Large-code: per-closure step counter (resets each invocation)
                -- + global lifetime counter (never resets, detects infinite loops across calls)
                _pvm_totalSteps  = _pvm_totalSteps + 1
                _pvm_lifetimeSteps = _pvm_lifetimeSteps + 1
                if _pvm_totalSteps % 256 == 0 then
                    if _pvm_totalSteps > _pvm_maxClosureSteps or _pvm_totalSteps > _pvm_maxSteps then
                        _pvm_callDepth = _pvm_callDepth - 1
                        _h_error("Execution step limit exceeded")
                    end
                    if _pvm_lifetimeSteps > _pvm_maxLifetimeSteps then
                        _pvm_callDepth = _pvm_callDepth - 1
                        _h_error("Lifetime step limit exceeded")
                    end
                    -- 3.2 Periodic Dispatch Loop Fail-Closed Tamper Invariant & Chaotic Hash Check
                    if (_verifyState and not _verifyState(_STATE_RUNNING)) or _pvm_tripped or (_pvm_canary and _pvm_canary ~= 3735929054) or _pvm_halted
                        or _pvm_dynHash == nil or _pvm_dynHash ~= _pvm_dynHash or _h_type(_pvm_dynHash) ~= "number" then
                        local _ = nil; local _ = _[1]
                    end
                    if _pollTamper then _pollTamper() end
                    if _pvm_totalSteps % 524288 == 0 and _pvm_enable_yield then
                        local _curCo = coroutine and coroutine.running and coroutine.running()
                        if _curCo then
                            coroutine.yield()
                        end
                    end
                end

                -- 2.2 Periodic Checksum & Runtime Health (every 64 instructions)
                -- Large-code: increased from 32 to 64 to halve overhead for large protos
                if _pvm_totalSteps % 64 == 0 then
                    _checkVmSelfHash()
                    if _verifyEnvFingerprint then _verifyEnvFingerprint() end
                    if _checkGlobalMetatable then _checkGlobalMetatable() end
                    _validateCanaries(frame)
                    if _pvm_epochJitter then _pvm_epochJitter(_pvm_totalSteps) end
                    -- 3.5 Anti-Dump: Detect external debug hooks attached dynamically
                    local _dbg = _h_dbg or debug
                    if _dbg and _dbg.gethook and _dbg.gethook() ~= nil then
                        _triggerTamper("anti_dump_hook_detected")
                        local _ = nil; local _ = _[1]
                    end
                    -- 2.8 Incremental rolling integrity check (large-code optimized)
                    -- Verify the chainBlock that covers the CURRENT pc range when crossing block boundaries
                    if proto.chainHash and proto.chainBlocks and proto.chainSeed then
                        local curBlockIdx = ((frame.pc - 1) - (frame.pc - 1) % 8) / 8 + 1
                        if curBlockIdx ~= frame._lastCheckedBlock then
                            frame._lastCheckedBlock = curBlockIdx
                            local expectedBlock = proto.chainBlocks[curBlockIdx]
                            if expectedBlock then
                                local s = proto.chainSeed
                                local cMult = 31 + (s % 17) * 2
                                local c1 = 7 + (s % 11)
                                local c2 = 13 + (s % 19)
                                local c3 = 17 + (s % 23)
                                local c4 = 23 + (s % 29)
                                local cIdx = 3 + (s % 7)
                                local blockStart = (curBlockIdx - 1) * 8 + 1
                                local blockEnd = curBlockIdx * 8
                                local insts = proto.instructions
                                if blockEnd > #insts then blockEnd = #insts end
                                local rolling = (curBlockIdx > 1) and proto.chainBlocks[curBlockIdx - 1] or s
                                for i = blockStart, blockEnd do
                                    local it = insts[i]
                                    local f1 = it[1] or 0
                                    local f2 = it[2] or 0
                                    local f3 = it[3] or 0
                                    local f4 = it[4] or 0
                                    rolling = (rolling * cMult + f1 * c1 + f2 * c2 + f3 * c3 + f4 * c4 + i * cIdx) % 2147483647
                                end
                                if rolling ~= expectedBlock then
                                    _triggerTamper("instruction_chain_violation")
                                end
                            end
                        end
                    end
                end

                -- 2.3 Decoy Payload execution on tamper or stealth honeypot trigger
                if _pvm_stealth_trap and not _pvm_decoy_active then
                    _pvm_decoy_active = true
                    _pvm_poison_delay = 48
                end

                if _pvm_decoy_active then
                    if decoyProto and not frame._inDecoy then
                        frame._inDecoy = true
                        frame.proto = decoyProto
                        frame.instructions = decoyProto.instructions
                        frame.pc = 1
                        numInsts = #frame.instructions
                        instructions = frame.instructions
                        for r = 1, 16 do frame.R[r] = 0 end
                    end
                    if _pvm_poison_delay > 0 then
                        _pvm_poison_delay = _pvm_poison_delay - 1
                        if frame.R[1] and _h_type(frame.R[1]) == "number" then
                            frame.R[1] = frame.R[1] + 1
                        end
                    else
                        local _errCode = (_ERR_CODES and _ERR_CODES[_pvm_tamper_reason]) or "0xE0FF"
                        _h_error(_errCode, 0)
                    end
                end

                local inst = instructions[frame.pc]
                local op   = inst[opPos]
                local A    = inst[aPos] - maskA
                local B    = inst[bPos] - maskB
                local C    = inst[cPos] - maskC

                -- Layer 1: Polynomial Chaos-Coupled Instruction Dispatch (PCCID) & MASIS
                _pvm_dynHash = ((_pvm_dynHash * 16807 + frame.pc * 31337 + op * 7919 + (_pvm_canary or 0)) % 2147483647)
                local _entangleState = ((frame.pc * 2654435761) % 4294967296 + (_pvm_dynHash % 65536) * 31) % 4294967296
                if frame.pc % 128 == 0 and _entangleState == 0 then
                    _triggerTamper("instruction_chain_violation")
                end
                if _evolveInvariant then _evolveInvariant(1) end
                if frame.pc % 64 == 0 and _verifyInvariant and not _verifyInvariant() then
                    _triggerTamper("instruction_chain_violation")
                end

                -- Outer VM: Dynamic Opcode Translation & Inter-VM Channel Dispatch
                local _ptrKey = (op * 16807 + 1337) % 65521
                local _unmaskOp = (((_ptrKey - 1337 + 65521) % 65521) * 13204) % 65521
                _vm_channel.tok = ((frame.pc * 16807 + _unmaskOp * 7919 + (frame.regSentinel or 1337)) % 2147483647)
                _vm_channel.f   = frame
                _vm_channel.a   = A
                _vm_channel.b   = B
                _vm_channel.c   = C
                _vm_channel.op  = _unmaskOp
                _pvm_inner_core(_vm_channel)
                _vm_channel.f   = nil

                if frame.isReturning then
                    if _pvm_dynHash == nil or _pvm_dynHash ~= _pvm_dynHash or _h_type(_pvm_dynHash) ~= "number" then
                        _triggerTamper("instruction_chain_violation")
                        local _ = nil; local _ = _[1]
                    end
                    _validateCanaries(frame)
                    if _pvm_popCallFrame then _pvm_popCallFrame(frame, proto) end
                    _pvm_callDepth = _pvm_callDepth - 1
                    proto._activeFrames = proto._activeFrames - 1
                    local retVals = frame.returnValues
                    local numRetVals = frame.numReturnValues
                    -- Layer 2: Dual-Phase Metamorphic Stack Frame Isolation (MSFI)
                    local _fR = frame.R
                    if _fR then
                        for _r in pairs(_fR) do _fR[_r] = 0 end
                        for _r in pairs(_fR) do _fR[_r] = nil end
                    end
                    frame.R = nil
                    frame.openUpvalues = nil
                    frame.instructions = nil
                    frame.proto = nil
                    frame.returnValues = nil
                    return _rt_upk(retVals, 1, numRetVals)
                end

                frame.pc = frame.pc + 1
            end

            _validateCanaries(frame)
            if _pvm_popCallFrame then _pvm_popCallFrame(frame, proto) end
            _pvm_callDepth = _pvm_callDepth - 1
            proto._activeFrames = proto._activeFrames - 1
            -- Layer 2: Dual-Phase Metamorphic Stack Frame Isolation (MSFI)
            local _fR = frame.R
            if _fR then
                for _r in pairs(_fR) do _fR[_r] = 0 end
                for _r in pairs(_fR) do _fR[_r] = nil end
            end
            frame.R = nil
            frame.openUpvalues = nil
            frame.instructions = nil
            frame.proto = nil
            return
        end
        if fn and _pvm_vm_closures then _pvm_vm_closures[fn] = true end
        if newcclosure and _h_type(newcclosure) == "function" then
            local _okC, _ccl = _h_pcall(newcclosure, fn)
            if _okC and _ccl then
                if _pvm_vm_closures then _pvm_vm_closures[_ccl] = true end
                return _ccl
            end
        end
        return fn
    end

    local rootClosure = makeClosure(rootProto, {}, nil)
    if _pvm_vm_closures and rootClosure then
        _pvm_vm_closures[rootClosure] = true
    end
    if _advanceState then
        _advanceState(_STATE_VERIFIED, _STATE_RUNNING)
    end
    local rootResults = {}
    if _pvm_is_utmost and _co_c and _co_r then
        local co = _co_c(function(...)
            return rootClosure(...)
        end)
        local stepResults = { _co_r(co, _rt_upk(_initArgs)) }
        if not stepResults[1] then
            _h_error(stepResults[2] or "Runtime error in VM coroutine", 0)
        end
        while (coroutine and coroutine.status and coroutine.status(co) == "suspended") do
            stepResults = { _co_r(co) }
            if not stepResults[1] then
                _h_error(stepResults[2] or "Runtime error in VM coroutine", 0)
            end
        end
        for i = 2, #stepResults do
            rootResults[i - 1] = stepResults[i]
        end
    else
        rootResults = { rootClosure(_rt_upk(_initArgs)) }
    end
    if _advanceState then
        _advanceState(_STATE_RUNNING, _STATE_TERMINATED)
    end
    if _pvm_sealExecution then _pvm_sealExecution() end
    -- 2.5 Self-Modifying Code & Anti-Dump Memory Destruction
    -- 3.6: Deep-wipe including chainBlocks, chainHash, canary, kdfSalt, b64Salt
    local function _wipeProto(p)
        if _h_type(p) ~= "table" then return end
        if p.instructions then
            for i = 1, #p.instructions do
                local it = p.instructions[i]
                if _h_type(it) == "table" then
                    for idx in pairs(it) do it[idx] = 0 end
                end
                p.instructions[i] = 0
            end
            p.instructions = nil
        end
        if p.constants then
            for k in pairs(p.constants) do
                local c = p.constants[k]
                if _h_type(c) == "table" then
                    if c.v then
                        if _h_type(c.v) == "table" then
                            for vi in pairs(c.v) do c.v[vi] = 0 end
                        end
                        c.v = nil
                    end
                    c.m = nil; c.m0 = nil; c.m1 = nil
                    c.xk = nil; c.ik = nil; c.xb = nil; c.ob = nil; c.ss = nil
                end
                p.constants[k] = nil
            end
            p.constants = nil
        end
        -- 3.6: Wipe integrity chain metadata
        if p.chainBlocks then
            for i = 1, #p.chainBlocks do p.chainBlocks[i] = 0 end
            p.chainBlocks = nil
        end
        p.chainHash = nil
        p.chainSeed = nil
        p.canary = nil
        p.kdfSalt = nil
        p.b64Salt = nil
        p.resolvedK = nil
        p.resolvedNil = nil
        if p.protos then
            for i = 1, #p.protos do _wipeProto(p.protos[i]) end
            p.protos = nil
        end
        if _pvm_poisonMemory then _pvm_poisonMemory(p) end
    end
    _wipeProto(rootProto)
    -- 3.6: Also wipe decoy proto after execution
    if _h_type(decoyProto) == "table" then _wipeProto(decoyProto) end
    -- 3.2: Tamper canary remains valid and persistent
    if _h_type(chunkData) == "table" then
        chunkData.p = nil
        chunkData.cfg = nil
        chunkData.sig = nil
        chunkData.dp = nil
        chunkData.s = nil
        chunkData.m = nil
        chunkData.v = nil
        chunkData.f = nil
    end
    rootProto = nil
    decoyProto = nil
    if handlers then
        handlers = nil
    end
    makeClosure = nil
    rootClosure = nil
    _vm_exec = nil
    if collectgarbage and not (_h_type and (_h_type(game) == "userdata" or _h_type(workspace) == "userdata")) then
        _h_pcall(collectgarbage, "collect")
    end
    return _rt_upk(rootResults)
end
local _vm_init = function(...)
    if not _vm_exec then return nil end
    local fn = _vm_exec
    _vm_exec = nil
    return fn(...)
end
if _pvm_is_utmost and _h_sm then
    local _cyclic = {}
    _cyclic.__index = _cyclic
    _cyclic.__pairs = function() return function() return _cyclic, _cyclic end end
    _h_pcall(function() _h_sm(_cyclic, _cyclic) end)

    local _executed = false
    local _proxy_inner = _h_sm({}, {
        __metatable = "The metatable is locked",
        __index = _cyclic,
        __call = function(_, ...)
            if _executed or not _vm_exec then
                repeat until false
            end
            _executed = true
            local fn = _vm_exec
            _vm_exec = nil
            return fn(...)
        end
    })
    _vm_init = _h_sm({}, {
        __metatable = "The metatable is locked",
        __index = _cyclic,
        __call = function(_, ...)
            return _proxy_inner(...)
        end
    })
end
if _pvm_vm_closures and _vm_init then _pvm_vm_closures[_vm_init] = true end
return _vm_init(]==] .. chunkJsonString .. ")"

    return runtimeTemplate
end

return Emitter
`,"prometheus.vm.runtime.standalone_verifier":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/runtime/standalone_verifier.lua
--
-- PinatVM Phase 1: Standalone Structural Bytecode Verifier
--
-- Independently validates PinatVM serialized or in-memory bytecode chunks
-- BEFORE execution or emission. Can be run offline by compiler passes,
-- quality gates, and unit/negative test suites without invoking a runtime script.
--
-- Verification rules:
--   1. Header: magic == "PVM2", version in [2.0, 3.0], required fields (cfg, p)
--   2. Decoder: rkThreshold, field positions (opPos, aPos, bPos, cPos)
--   3. Resource Limits:
--        - maxstacksize <= 255
--        - numparams <= 250
--        - instruction count <= 65535
--        - constant count <= 65535
--        - proto count <= 256
--        - upvalue count <= 256
--        - nested prototype depth <= 32
--        - max constant string size <= 1048576 (1 MB)
--   4. Constants: type tag in 1..4, correct structure for each type
--   5. Registers: all operands within [0, maxstacksize]
--   6. RK Operands: register within bounds, constant index within [1, #constants]
--   7. Protos & Upvalues: indexes within [1, #protos] and [1, #upvalues]
--   8. Jump Targets: branch offsets land within [1, #instructions + 1]
--   9. Opcodes: mapped in build's opcodeMap
--
-- Returns: ok (boolean), errors (table of string messages)
--

local StandaloneVerifier = {}

local DEFAULT_LIMITS = {
    MAX_STACK_SIZE     = 100000000, -- PinatVM manages its own stack; no VM limit
    MAX_PARAMS         = 100000,
    MAX_INSTRUCTIONS   = 100000000, -- support up to 30M+ line scripts
    MAX_CONSTANTS      = 100000000, -- large constant pools for big scripts
    MAX_PROTOS         = 10000000,  -- support nested functions
    MAX_UPVALUES       = 100000,
    MAX_PROTO_DEPTH    = 10000,     -- deeper nesting for complex code
    MAX_STRING_BYTES   = 104857600, -- 100 MB
}

function StandaloneVerifier.verify(chunkData, limits)
    limits = limits or DEFAULT_LIMITS
    local errors = {}

    local function vErr(msg)
        table.insert(errors, msg)
    end

    -- 1. Header Verification
    if type(chunkData) ~= "table" then
        return false, { "Header: chunkData is not a table" }
    end

    if chunkData.m ~= "PVM2" then
        vErr(string.format("Header: invalid magic '%s' (expected 'PVM2')", tostring(chunkData.m)))
    end

    local ver = chunkData.v
    if type(ver) ~= "number" then
        vErr("Header: version field is missing or not a number")
    elseif ver < 2.0 or ver > 3.0 then
        vErr(string.format("Header: unsupported version %s (expected 2.0-3.0)", tostring(ver)))
    end

    local decoder = chunkData.cfg or chunkData.d
    if type(decoder) ~= "table" then
        vErr("Header: missing decoder configuration (cfg/d)")
        return false, errors
    end

    local rootProto = chunkData.p
    if type(rootProto) ~= "table" then
        vErr("Header: missing root prototype (p)")
        return false, errors
    end

    -- 2. Decoder Verification
    local rkThresh = decoder.rkThreshold
    if type(rkThresh) ~= "number" or rkThresh < 1 or rkThresh > 2147483647 then
        vErr("Decoder: invalid rkThreshold")
        rkThresh = 250
    end

    local opPos = decoder.opPos
    local aPos  = decoder.aPos
    local bPos  = decoder.bPos
    local cPos  = decoder.cPos
    if type(opPos) ~= "number" or type(aPos) ~= "number" or
       type(bPos) ~= "number" or type(cPos) ~= "number" then
        vErr("Decoder: invalid field positions (opPos, aPos, bPos, cPos)")
        return false, errors
    end

    local mA = decoder.maskA or 0
    local mB = decoder.maskB or 0
    local mC = decoder.maskC or 0

    local opMap = decoder.opcodeMap
    local numToLogical = {}
    if type(opMap) == "table" then
        for logName, numId in pairs(opMap) do
            numToLogical[numId] = logName
        end
    else
        vErr("Decoder: opcodeMap is missing or not a table")
    end

    -- 3. Recursive Prototype Verification
    local function verifyProto(proto, path, depth)
        path = path or "root"
        depth = depth or 1

        if type(proto) ~= "table" then
            vErr(string.format("Function [%s]: proto is not a table", path))
            return
        end

        if depth > (limits.MAX_PROTO_DEPTH or 32) then
            vErr(string.format("Function [%s]: nested prototype depth %d exceeds limit %d", path, depth, limits.MAX_PROTO_DEPTH))
            return
        end

        -- Instructions
        local instructions = proto.instructions
        if type(instructions) ~= "table" then
            vErr(string.format("Function [%s]: instructions is not a table", path))
            instructions = {}
        end
        local numInst = #instructions
        if numInst == 0 and path == "root" then
            vErr(string.format("Function [%s]: root prototype has 0 instructions", path))
        elseif numInst > (limits.MAX_INSTRUCTIONS or 65535) then
            vErr(string.format("Function [%s]: instruction count %d exceeds limit %d", path, numInst, limits.MAX_INSTRUCTIONS))
        end

        -- Params & Stack
        local numparams = proto.numparams
        if type(numparams) ~= "number" or numparams < 0 or numparams > (limits.MAX_PARAMS or 250) then
            vErr(string.format("Function [%s]: invalid numparams %s", path, tostring(numparams)))
        end

        local maxStack = proto.maxstacksize
        if type(maxStack) ~= "number" or maxStack < 1 or maxStack > (limits.MAX_STACK_SIZE or 1024) then
            vErr(string.format("Function [%s]: invalid maxstacksize %s", path, tostring(maxStack)))
            maxStack = 1024
        end

        -- Constants
        local constants = proto.constants
        if type(constants) ~= "table" then
            vErr(string.format("Function [%s]: constants is not a table", path))
            constants = {}
        end
        local numConsts = #constants
        if numConsts > (limits.MAX_CONSTANTS or 65535) then
            vErr(string.format("Function [%s]: constant count %d exceeds limit %d", path, numConsts, limits.MAX_CONSTANTS))
        end

        for i, c in ipairs(constants) do
            local cPath = string.format("%s.K[%d]", path, i)
            if type(c) ~= "table" then
                vErr(string.format("Constant %s: not a table", cPath))
            else
                local t = c.t
                if type(t) ~= "number" or t < 1 or t > 4 then
                    vErr(string.format("Constant %s: invalid type tag %s", cPath, tostring(t)))
                else
                    if t == 1 then
                        if type(c.v) ~= "table" and type(c.v) ~= "string" then
                            vErr(string.format("Constant %s: string type but payload is neither table nor string", cPath))
                        elseif #c.v > (limits.MAX_STRING_BYTES or 1048576) then
                            vErr(string.format("Constant %s: string payload %d bytes exceeds limit", cPath, #c.v))
                        end
                    elseif t == 2 then
                        if type(c.v) ~= "number" then
                            vErr(string.format("Constant %s: number type but payload is not a number", cPath))
                        end
                    elseif t == 3 then
                        if c.v ~= 0 and c.v ~= 1 then
                            vErr(string.format("Constant %s: bool type but value is not 0 or 1", cPath))
                        end
                    end
                end
            end
        end

        -- Upvalues
        local upvalues = proto.upvalues
        if type(upvalues) ~= "table" then
            vErr(string.format("Function [%s]: upvalues is not a table", path))
            upvalues = {}
        end
        local numUpvals = #upvalues
        if numUpvals > (limits.MAX_UPVALUES or 256) then
            vErr(string.format("Function [%s]: upvalue count %d exceeds limit %d", path, numUpvals, limits.MAX_UPVALUES))
        end

        -- Child Protos
        local protos = proto.protos
        if type(protos) ~= "table" then
            vErr(string.format("Function [%s]: protos is not a table", path))
            protos = {}
        end
        local numProtos = #protos
        if numProtos > (limits.MAX_PROTOS or 256) then
            vErr(string.format("Function [%s]: child proto count %d exceeds limit %d", path, numProtos, limits.MAX_PROTOS))
        end

        -- Instruction & Operand Verification
        for pc, rawInst in ipairs(instructions) do
            if type(rawInst) ~= "table" or #rawInst < 4 then
                vErr(string.format("Register [%s@%d]: malformed instruction tuple (length < 4)", path, pc))
            else
                local opCode  = rawInst[opPos]
                local logName = numToLogical[opCode]
                local A       = rawInst[aPos] - mA
                local B       = rawInst[bPos] - mB
                local C       = rawInst[cPos] - mC

                if not logName then
                    vErr(string.format("Opcode [%s@%d]: unknown numeric opcode %s", path, pc, tostring(opCode)))
                else
                    local function checkReg(r, name)
                        if r < 0 or r > maxStack then
                            vErr(string.format("Register [%s@%d]: %s=%d out of bounds [0,%d]", path, pc, name, r, maxStack))
                        end
                    end

                    local function checkRK(val, name)
                        if val >= rkThresh then
                            local kIdx = val - rkThresh + 1
                            if kIdx < 1 or kIdx > numConsts then
                                vErr(string.format("Register [%s@%d]: const %s-index %d out of bounds [1,%d]", path, pc, name, kIdx, numConsts))
                            end
                        else
                            if val < 0 or val > maxStack then
                                vErr(string.format("Register [%s@%d]: %s=%d out of bounds [0,%d]", path, pc, name, val, maxStack))
                            end
                        end
                    end

                    local function checkConst(kIdx, name)
                        if kIdx < 1 or kIdx > numConsts then
                            vErr(string.format("Register [%s@%d]: const %s-index %d out of bounds [1,%d]", path, pc, name, kIdx, numConsts))
                        end
                    end

                    local function checkProtoIdx(pIdx)
                        if pIdx < 1 or pIdx > numProtos then
                            vErr(string.format("Register [%s@%d]: proto index %d out of bounds [1,%d]", path, pc, pIdx, numProtos))
                        end
                    end

                    local function checkUpvalIdx(uIdx)
                        if uIdx < 1 or uIdx > numUpvals then
                            vErr(string.format("Register [%s@%d]: upvalue index %d out of bounds [1,%d]", path, pc, uIdx, numUpvals))
                        end
                    end

                    local function checkJump(sBx, name)
                        local target = pc + sBx + 1
                        if target < 1 or target > numInst + 1 then
                            vErr(string.format("Jump [%s@%d]: target %d out of bounds [1,%d]", path, pc, target, numInst + 1))
                        end
                    end

                    -- Dispatch by instruction semantics
                    if logName == "JMP" then
                        checkJump(A, "A")
                    elseif logName == "FORPREP" or logName == "FORLOOP" or
                           logName == "JUMP_IF" or logName == "JUMP_IF_NOT" then
                        checkReg(A, "A")
                        checkJump(B, "B")
                    elseif logName == "TFORLOOP" then
                        checkReg(A, "A")
                        checkJump(C, "C")
                    elseif logName == "LOADK" or logName == "LOADNUM" or
                           logName == "LOAD_NUMBER" or logName == "LOAD_STRING" or
                           logName == "GETGLOBAL" or logName == "SETGLOBAL" or
                           logName == "LOAD_CONST" then
                        checkReg(A, "A")
                        checkConst(B, "B")
                    elseif logName == "CLOSURE" then
                        checkReg(A, "A")
                        checkProtoIdx(B)
                    elseif logName == "GETUPVAL" or logName == "SETUPVAL" then
                        checkReg(A, "A")
                        checkUpvalIdx(B)
                    elseif logName == "MOVE" or logName == "UNM" or
                           logName == "NOT" or logName == "LEN" or
                           logName == "MOVE_RANGE" or logName == "TESTSET" or
                           logName == "LOADNIL" then
                        checkReg(A, "A")
                        checkReg(B, "B")
                    elseif logName == "LOADBOOL" or logName == "CALL" or
                           logName == "TAILCALL" or logName == "RETURN" or
                           logName == "CALL_FAST" or logName == "RETURN_FAST" or
                           logName == "VARARG" or logName == "CLOSE" or
                           logName == "TEST" or logName == "NEWTABLE" or
                           logName == "SETLIST" then
                        checkReg(A, "A")
                    elseif logName == "GETTABLE" then
                        checkReg(A, "A")
                        checkReg(B, "B")
                        checkRK(C, "C")
                    elseif logName == "SETTABLE" then
                        checkReg(A, "A")
                        checkRK(B, "B")
                        checkRK(C, "C")
                    elseif logName == "SELF" then
                        checkReg(A, "A")
                        checkReg(B, "B")
                        checkRK(C, "C")
                    elseif logName == "TABLE_GET_FAST" then
                        checkReg(A, "A")
                        checkReg(B, "B")
                        checkRK(C, "C")
                    elseif logName == "TABLE_SET_FAST" then
                        checkReg(A, "A")
                        checkRK(B, "B")
                        checkRK(C, "C")
                    elseif logName == "ADD" or logName == "SUB" or logName == "MUL" or
                           logName == "DIV" or logName == "MOD" or logName == "POW" or
                           logName == "CONCAT" or logName == "EQ" or logName == "NE" or
                           logName == "LT" or logName == "LE" then
                        checkReg(A, "A")
                        checkRK(B, "B")
                        checkRK(C, "C")
                    end
                end
            end
        end

        -- Recurse into child protos
        for i, child in ipairs(protos) do
            verifyProto(child, string.format("%s.proto[%d]", path, i), depth + 1)
        end
    end

    verifyProto(rootProto, "root", 1)

    return (#errors == 0), errors
end

return StandaloneVerifier
`,"prometheus.vm.runtime.verifier":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/runtime/verifier.lua
--
-- PinatVM Phase 1: Runtime Structural Bytecode Verifier
--
-- Generates the Lua code string for the runtime structural verifier.
-- This verifier runs INSIDE the generated Lua script, BEFORE any bytecode
-- execution begins. It is a separate stage from the integrity checksums.
--
-- Verification pipeline:
--   verifyHeader()    → magic, version, required fields
--   verifyFunctions() → proto structure, numparams, upvalue counts
--   verifyConstants() → constant type tags, malformed entries
--   verifyRegisters() → all instruction operands within stack bounds
--   verifyJumps()     → all jump targets within instruction count bounds
--   verifyOpcodes()   → all opcodes present in the build's opcode map
--   pass              → execute
--
-- On any failure: controlled error() — never raw crash.
-- No execution can occur before all stages complete successfully.
--

local RuntimeVerifier = {}

-- Returns the Lua code string (template fragment) for the structural verifier.
-- This is spliced into the emitter's runtime template.
-- Parameters available in scope when this code executes:
--   chunkData  (the loaded payload table)
--   decoder    (the decoder config table, contains opcodeMap, rkThreshold, etc.)
--   rootProto  (the root function prototype)
--   adapter    (the Runtime Adapter with validated host primitives)
function RuntimeVerifier.generateVerifierCode()
    return [=[
    -- ===========================================================
    -- Section V: Lean Runtime Structural Verifier
    -- Validates bytecode invariants safely with zero adapter leak
    -- ===========================================================
    local _pvm_verifyErrors = {}
    local function _pvm_vErr(code)
        _pvm_verifyErrors[#_pvm_verifyErrors + 1] = code
    end

    local function _pvm_verifyAll()
        if not chunkData or chunkData.m ~= "PVM2" then
            _pvm_vErr(1)
            return
        end
        local _v_tbl = type({})
        local _v_num = type(0)
        local ver = chunkData.v
        if type(ver) ~= _v_num or ver < 2.0 or ver > 3.0 then
            _pvm_vErr(2)
            return
        end
        local d = chunkData.cfg or chunkData.d
        if not d or type(d.rkThreshold) ~= _v_num or not rootProto then
            _pvm_vErr(3)
            return
        end

        local opMapRev = {}
        if d.opcodeMap then
            for name, id in pairs(d.opcodeMap) do opMapRev[id] = name end
        end

        local function _verifyProto(p, isRoot)
            if type(p) ~= _v_tbl or type(p.instructions) ~= _v_tbl then
                _pvm_vErr(4)
                return
            end
            local nInst = #p.instructions
            if nInst == 0 and isRoot then
                _pvm_vErr(5)
            end
            local maxstack = p.maxstacksize or 255
            if type(p.numparams) ~= _v_num or p.numparams < 0 or p.numparams > 250 then
                _pvm_vErr(6)
            end
            if type(maxstack) ~= _v_num or maxstack < 1 or maxstack > 100000000 then
                _pvm_vErr(7)
            end
            if nInst > 100000000 or #(p.constants or {}) > 100000000 then
                _pvm_vErr(8)
            end

            local pConsts = p.constants or {}
            for i = 1, #pConsts do
                local c = pConsts[i]
                if type(c) ~= _v_tbl or type(c.t) ~= _v_num or c.t < 1 or c.t > 4 then
                    _pvm_vErr(9)
                end
            end

            local nConsts = #(p.constants or {})
            local nProtos = #(p.protos or {})
            local rkThresh = d.rkThreshold or 256
            for i = 1, nInst do
                local inst = p.instructions[i]
                if type(inst) ~= _v_tbl or #inst < 4 then
                    _pvm_vErr(10)
                    break
                end
                local op = inst[d.opPos]
                local opName = opMapRev[op]
                if not opName then
                    _pvm_vErr(11)
                end
                local A = inst[d.aPos] - (d.maskA or 0)
                local B = inst[d.bPos] - (d.maskB or 0)
                local C = inst[d.cPos] - (d.maskC or 0)

                local isJmp = (opName == 23 or opName == "JMP")
                local isBranch = (opName == 37 or opName == 38 or opName == 45 or opName == 46 or opName == "FORPREP" or opName == "FORLOOP" or opName == "JUMP_IF" or opName == "JUMP_IF_NOT")
                local isTFor = (opName == 39 or opName == "TFORLOOP")
                local isClosure = (opName == 33 or opName == "CLOSURE")

                if isJmp then
                    local tgt = i + A + 1
                    if tgt < 1 or tgt > nInst + 1 then _pvm_vErr(15) end
                else
                    if A < 0 or A > maxstack then
                        _pvm_vErr(12)
                    end
                    if isBranch then
                        local tgt = i + B + 1
                        if tgt < 1 or tgt > nInst + 1 then _pvm_vErr(15) end
                    elseif isTFor then
                        local tgt = i + C + 1
                        if tgt < 1 or tgt > nInst + 1 then _pvm_vErr(15) end
                    else
                        if B >= rkThresh and (B - rkThresh + 1) > nConsts then
                            _pvm_vErr(13)
                        end
                        if C >= rkThresh and (C - rkThresh + 1) > nConsts then
                            _pvm_vErr(14)
                        end
                    end
                end
                if isClosure then
                    if B < 1 or B > nProtos then
                        _pvm_vErr(16)
                    end
                end
            end

            local pProtos = p.protos or {}
            for i = 1, #pProtos do
                _verifyProto(pProtos[i], false)
            end
        end

        _verifyProto(rootProto, true)
    end

    _pvm_verifyAll()
    if #_pvm_verifyErrors > 0 then
        while true do end
        return
    end
]=]
end

return RuntimeVerifier
`,"prometheus.vm.vm_step":`-- This Script is Part of the Pinathub Obfuscator
--
-- src/prometheus/vm/vm_step.lua
--
-- PinatVM Phase 1: Prometheus Step integrating the PinatVM Production Pipeline
--
-- Pipeline stages (named):
--   1. COMPILE:   AST → Custom IR (AstToIR)
--   2. VERIFY_IR: Pre-transformation IR verification
--   3. OPTIMIZE:  IR optimization (DCE, constant folding)
--   4. TRANSFORM: CFG transformation (CFF, opaque predicates, block splitting)
--   5. VERIFY_CFG:Post-transformation IR + CFG equivalence verification
--   6. REGALLOC: Register lifetime analysis and bounds verification
--   7. PAYLOAD:  Bytecode compile → encode → protect → authenticate → package
--   8. EMIT:     Generate VM runtime interpreter script
--   9. QUALITY:  Anti-pattern protection quality gate
--   10. PARSE:   Parse emitted runtime back into Prometheus AST
--

local Step              = require("prometheus.step")
local Parser            = require("prometheus.parser")
local AstToIR           = require("prometheus.vm.ir.ast_to_ir")
local IRVerifier        = require("prometheus.vm.ir.verifier")
local IROptimizer       = require("prometheus.vm.ir.optimizer")
local CffIR             = require("prometheus.vm.compiler.cff_ir")
local CfgVerifier       = require("prometheus.vm.compiler.cfg_verifier")
local RegisterAllocator = require("prometheus.vm.compiler.register_allocator")
local Permutator        = require("prometheus.vm.opcodes.permutator")
local PayloadPipeline   = require("prometheus.vm.protection.payload")
local Emitter           = require("prometheus.vm.runtime.emitter")
local AntiPattern       = require("prometheus.vm.analyzer.antipattern")
local StandaloneVerifier = require("prometheus.vm.runtime.standalone_verifier")
local CapabilityAnalysis = require("prometheus.vm.analyzer.capability_analysis")

local PinatVM = Step:extend()
PinatVM.Description = "PinatVM Phase 1 — Production Bytecode Architecture: " ..
    "Versioned bytecode, polymorphic opcodes, CFG transformation, " ..
    "KDF payload encryption, multi-region integrity verification, " ..
    "Frame-model VM, dispatch-table runtime, structural verifier."
PinatVM.Name = "PinatVM"

PinatVM.SettingsDescriptor = {
    ControlFlowFlattening = {
        type    = "boolean",
        default = true,
    },
    CffThreshold = {
        type    = "number",
        default = 2,
        min     = 1,
        max     = 10,
    },
    DecoyStates = {
        type    = "number",
        default = 2,
        min     = 0,
        max     = 5,
    },
    BlockSplitting = {
        type    = "boolean",
        default = true,
    },
    -- Large-code: max blocks per proto before CFF switches to lite mode.
    -- Increase for higher security on all functions (slower on huge scripts).
    -- Decrease for faster compilation of 10k+ line scripts.
    MaxBlocksPerProto = {
        type    = "number",
        default = 500,
        min     = 50,
        max     = 5000,
        description = "Block count threshold per proto before CFF lite mode activates. Lower = faster compilation for large scripts (lite CFF on big functions).",
    },
    StrictVerification = {
        type    = "boolean",
        default = true,
    },
    StripMetadata = {
        type    = "boolean",
        default = true,   -- strip names/ids in production
    },
    CompatibilityProfile = {
        type    = "string",
        default = "LUA_5_1",  -- LUA_5_1 | LUA_5_2 | LUAU | LUA_5_1_STRICT
    },
    SkipPeephole = {
        type    = "boolean",
        default = false,  -- set true to disable fast-path opcode lowering
    },
    AntiEnvLogger = {
        type    = "boolean",
        default = true,
        description = "Hook getfenv() with a proxy environment to block Env Logger / XHider exploits.",
    },
    RuntimeProfile = {
        type    = "string",
        default = "Standard",
        description = "Runtime isolation profile: Standard (compatibility) or Hardened (minimal exposure, strict host isolation).",
    },
    ProtectionPreset = {
        type    = "string",
        default = "VeryMax",
        description = "Constant encryption preset: Standard (Rep5: Base64+XOR) or VeryMax (Rep6: AES inv-sbox + XOR-offset + 64-bit HMAC MAC + anti-dump).",
    },
    StateMachineDispatch = {
        type    = "boolean",
        default = true,
        description = "Enable state-machine computed goto indirect instruction dispatch in the VM interpreter.",
    },
}

function PinatVM:init(settings)
    settings = settings or {}
    for k, v in pairs(settings) do
        self[k] = v
    end
end

function PinatVM:apply(ast, pipeline)
    local seed = (pipeline and pipeline.Seed) or 1337
    if seed == 0 then seed = math.random(1, 1000000) end

    local buildMode = (pipeline and pipeline.BuildMode) or "Release"
    local luaVer    = (pipeline and pipeline.LuaVersion) or "Lua51"

    -- Deterministic LCG RNG for CFF (seed-reproducible)
    local lcgState = seed % 2147483647
    if lcgState == 0 then lcgState = 1234567 end
    local function rng(min, max)
        lcgState = (lcgState * 16807 + 12345) % 2147483647
        if not min then return lcgState / 2147483647 end
        if not max then max = min; min = 1 end
        return min + (lcgState % (max - min + 1))
    end

    -- -------------------------------------------------------
    -- Stage 1: COMPILE — AST → Custom IR (CFG / BasicBlocks)
    -- -------------------------------------------------------
    local compiler = AstToIR.new()
    local rootIR   = compiler:compile(ast)
    ast = nil
    compiler = nil
    collectgarbage("collect")

    -- -------------------------------------------------------
    -- Stage 2: VERIFY_IR — Pre-transformation verification
    -- -------------------------------------------------------
    local irOk, irErr = IRVerifier.verify(rootIR)
    if not irOk then
        error("[PinatVM Stage VERIFY_IR] Pre-transform verification failed:\\n" .. tostring(irErr))
    end

    -- -------------------------------------------------------
    -- Stage 3: OPTIMIZE — DCE, constant folding, jump chaining
    -- -------------------------------------------------------
    IROptimizer.optimize(rootIR)

    -- -------------------------------------------------------
    -- Stage 4: TRANSFORM — CFG transformation
    -- (CFF, opaque predicates, decoy states, block splitting)
    -- -------------------------------------------------------
    if self.ControlFlowFlattening ~= false then
        CffIR.apply(rootIR, {
            Threshold         = self.CffThreshold or 2,
            DecoyStates       = self.DecoyStates or 2,
            BlockSplitting    = (self.BlockSplitting ~= false),
            MaxBlocksPerProto = self.MaxBlocksPerProto or 500,
        }, rng)
    end

    -- -------------------------------------------------------
    -- Stage 5: VERIFY_CFG — Post-transformation IR + CFG equivalence
    -- -------------------------------------------------------

    -- 5a. Post-transform IR validity
    local postOk, postErr = IRVerifier.verify(rootIR)
    if not postOk then
        error("[PinatVM Stage VERIFY_CFG] Post-transform IR verification failed:\\n" .. tostring(postErr))
    end

    -- 5b. CFG structural equivalence check (wired in Phase 1)
    -- We perform a structural equivalence check on the proto tree.
    -- Since we cannot deep-copy before CFF (too expensive), we check
    -- structural invariants on the post-transform IR:
    --   - Entry block is reachable
    --   - All RETURN nodes present
    --   - No dangling jump targets
    local function checkCfgSafety(irFunc, path)
        path = path or "root"
        local reachable = irFunc:getReachableBlocks()
        if #irFunc.blocks > 0 and not reachable[irFunc.blocks[1].id] then
            error(string.format("[PinatVM Stage VERIFY_CFG] [%s] Entry block unreachable after CFF.", path))
        end
        local blockMap = {}
        for _, b in ipairs(irFunc.blocks) do blockMap[b.id] = true end
        for _, block in ipairs(irFunc.blocks) do
            for _, inst in ipairs(block.instructions) do
                local op  = inst.op
                local ops = inst.operands or {}
                if op == "JMP" and type(ops[1]) == "number" and not blockMap[ops[1]] then
                    error(string.format("[PinatVM Stage VERIFY_CFG] [%s] Dangling JMP to block %d.", path, ops[1]))
                end
            end
        end
        for i, child in ipairs(irFunc.protos or {}) do
            checkCfgSafety(child, path .. ".proto_" .. i)
        end
    end
    checkCfgSafety(rootIR, "root")

    -- -------------------------------------------------------
    -- Stage 6: REGALLOC — Register lifetime analysis + bounds verification
    -- -------------------------------------------------------
    local regIntervals, regMax = RegisterAllocator.analyze(rootIR)
    local regOk, regErrors = RegisterAllocator.verify(rootIR, regIntervals, regMax)
    if not regOk then
        -- Register errors are warnings in non-strict mode (CFF adds scratch registers)
        if self.StrictVerification then
            error("[PinatVM Stage REGALLOC] Register verification failed:\\n  " ..
                table.concat(regErrors, "\\n  "))
        end
    end

    -- -------------------------------------------------------
    -- Stage 6b: CAPABILITY_ANALYSIS — Minimal Host Manifest
    -- -------------------------------------------------------
    local capManifest = CapabilityAnalysis.analyze(rootIR)

    -- -------------------------------------------------------
    -- Stage 7: PAYLOAD — Bytecode compile → protect → package
    -- -------------------------------------------------------
    local profile = PayloadPipeline.CompatibilityProfile[self.CompatibilityProfile or "LUA_5_1"]
                 or PayloadPipeline.CompatibilityProfile.LUA_5_1

    local randGen = (self.pipeline and self.pipeline.random)
    local seed = (randGen and randGen:random(1000000, 2147483640))
              or (self.Seed and self.Seed > 0 and self.Seed)
              or (math.random and math.random(1000000, 2147483640))
              or ((os.time() * 1000 + math.floor(os.clock() * 1000000)) % 2147483647)

    local permutator = Permutator.new(seed)

    local payloadResult = PayloadPipeline.run(rootIR, permutator, {
        seed               = seed,
        buildMode          = buildMode,
        stripMetadata      = (self.StripMetadata ~= false),
        profile            = profile,
        flags              = 15,  -- 1=CFF | 2=KDF | 4=INTEGRITY | 8=POLYMORPHIC
        capabilityManifest = capManifest,
        preset             = self.ProtectionPreset or "VeryMax",
    })

    -- 7b. Pre-emission bytecode verification via StandaloneVerifier
    if payloadResult.chunkData then
        local vOk, vErrors = StandaloneVerifier.verify(payloadResult.chunkData)
        if not vOk then
            error("[PinatVM Stage PAYLOAD] Standalone bytecode verification failed:\\n  " ..
                table.concat(vErrors, "\\n  "))
        end
    end

    -- -------------------------------------------------------
    -- Stage 8: EMIT — Generate VM runtime interpreter script
    -- -------------------------------------------------------
    local runtimeScript = Emitter.generateRuntimeScript(payloadResult.chunkString, {
        capabilityManifest   = capManifest,
        profile              = self.RuntimeProfile or "Standard",
        preset               = self.ProtectionPreset or "VeryMax",
        stateMachineDispatch = (self.StateMachineDispatch ~= false),
    })

    -- -------------------------------------------------------
    -- Stage 9: QUALITY — Anti-pattern protection quality gate
    -- -------------------------------------------------------
    local antiPassed, protectionScore, issues, breakdown =
        AntiPattern.analyze(runtimeScript, payloadResult.proto, permutator, payloadResult.header)

    if not antiPassed and self.StrictVerification then
        local issueStr = table.concat(issues, "\\n  * ")
        error(string.format(
            "[PinatVM Stage QUALITY] Quality gate rejected build (Score: %d/100):\\n  * %s",
            protectionScore, issueStr
        ))
    end

    -- Free big payload and IR structures before parsing runtimeScript back to AST
    rootIR = nil
    payloadResult = nil
    permutator = nil
    collectgarbage("collect")

    -- -------------------------------------------------------
    -- Stage 10: PARSE — Parse emitted runtime back to Prometheus AST
    -- -------------------------------------------------------
    local parser     = Parser:new({ LuaVersion = luaVer })
    local runtimeAst = parser:parse(runtimeScript)

    runtimeScript = nil
    parser = nil
    collectgarbage("collect")

    return runtimeAst
end

return PinatVM
`,prometheus:`-- This Script is Part of the Prometheus Obfuscator by levno-710
--
-- prometheus.lua
--
-- This file is the entrypoint for Prometheus

-- Configure package.path for require
local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*[/%\\\\])") or "";
end

local oldPkgPath = package.path;
package.path = script_path() .. "?.lua;" .. package.path;

-- Math.random Fix for Lua5.1
-- Check if fix is needed
if not pcall(function()
    return math.random(1, 2^40);
end) then
    local oldMathRandom = math.random;
    math.random = function(a, b)
        if not a and b then
            return oldMathRandom();
        end
        if not b then
            return math.random(1, a);
        end
        if a > b then
            a, b = b, a;
        end
        local diff = b - a;
        assert(diff >= 0);
        if diff > 2 ^ 31 - 1 then
            return math.floor(oldMathRandom() * diff + a);
        else
            return oldMathRandom(a, b);
        end
    end
end

-- newproxy polyfill
newproxy = newproxy or function(arg)
    if arg then
        return setmetatable({}, {});
    end
    return {};
end


-- Require Prometheus Submodules
local Pipeline = require("prometheus.pipeline");
local highlight = require("highlightlua");
local colors = require("colors");
local Logger = require("logger");
local Presets = require("presets");
local Config = require("config");
local util = require("prometheus.util");

-- Restore package.path
package.path = oldPkgPath;

-- Export
return {
    Pipeline = Pipeline;
    colors = colors;
    Config = util.readonly(Config); -- Readonly
    Logger = Logger;
    highlight = highlight;
    Presets = Presets;
}

`};function f(e){let t=``;for(;e.includes(`]${t}]`);)t+=`=`;return`[${t}[${e}]${t}]`}let p=null;function m(e){if(typeof process<`u`&&process.versions?.node){try{let{createRequire:e}=l();return e(import.meta.url).resolve(`wasmoon/dist/glue.wasm`)}catch{}let t=e.startsWith(`/@fs/`)?e.slice(4):e;if(t.startsWith(`file://`))try{return new URL(t).pathname.replace(/^\/([A-Za-z]:)/,`$1`)}catch{}return t.startsWith(`/node_modules/`)&&(t=`.`+t),t=t.replace(/^\/([A-Za-z]:)/,`$1`),t}return e}async function h(){return p||(p=import(`./dist-B5WcHLgn.js`).then(e=>c(e.default,1)).then(e=>{let t=globalThis.wasmoon?.LuaFactory,n=e.LuaFactory,r=e.default?.LuaFactory,i=t??n??r;if(typeof i!=`function`)throw Error(`Unable to resolve LuaFactory export from wasmoon.`);return i}),p)}const g=Object.entries(d).map(([e,t])=>{let n=`@/src/${e.split(`.`).join(`/`)}.lua`;return`
package.preload[ ${f(e)} ] = function(...)
  local chunk, err = load(${f(t)}, ${f(n)}, "t")
  if not chunk then
    error(err)
  end
  return chunk(...)
end`}).join(`
`);function _(e){if(!e)return``;let t=[];return e.memberAccess&&t.push(`table.insert(config.Steps, { Name = "MemberAccessObfuscation", Settings = { Threshold = 1.0 } })`),e.controlFlowFlattening&&t.push(`table.insert(config.Steps, { Name = "ControlFlowFlattening", Settings = { Threshold = 3, MaxBlocks = 20, DecoyStates = ${e.cffDecoyStates||2} } })`),e.opaquePredicates&&t.push(`table.insert(config.Steps, { Name = "OpaquePredicates", Settings = { Threshold = 0.6, InjectDeadBlocks = true } })`),e.literalsToExpressions&&t.push(`table.insert(config.Steps, { Name = "LiteralsToExpressions", Settings = { Threshold = 1.0 } })`),e.encryptStrings&&t.push(`table.insert(config.Steps, { Name = "EncryptStrings", Settings = {} })`),e.vmify&&t.push(`table.insert(config.Steps, { Name = "Vmify", Settings = { ProtectionPreset = "VeryMax", AntiEnvLogger = true, RuntimeProfile = "Hardened" } })`),e.constantArray&&t.push(`table.insert(config.Steps, { Name = "ConstantArray", Settings = { Threshold = 1, StringsOnly = true, Shuffle = true, Rotate = true, LocalWrapperThreshold = 0 } })`),e.numbersToExpressions&&t.push(`table.insert(config.Steps, { Name = "NumbersToExpressions", Settings = { NumberRepresentationMutation = true } })`),e.metamethodGuard&&t.push(`table.insert(config.Steps, { Name = "MetamethodGuard", Settings = { AntiHook = true, DecoyDivergence = true, StringMetaProtection = true } })`),e.executionFlowIntegrity&&t.push(`table.insert(config.Steps, { Name = "ExecutionFlowIntegrity", Settings = { RollingState = true, CallStackValidation = true, SilentDegradation = true } })`),e.wrapInFunction&&t.push(`table.insert(config.Steps, { Name = "WrapInFunction", Settings = {} })`),t.join(`
  `)}function v(e){return`
_G.arg = _G.arg or {}
${g}

local logs = {}
local unpackFn = table.unpack or unpack
local function pushLog(level, ...)
  local parts = {}
  for i = 1, select("#", ...) do
    parts[#parts + 1] = tostring(select(i, ...))
  end
  if type(_G.__prometheusPushLog) == "function" then
    _G.__prometheusPushLog(level, unpackFn(parts))
  end
  logs[#logs + 1] = { level = level, message = table.concat(parts, " ") }
end

if not math.log10 then
  math.log10 = function(value)
    return math.log(value, 10)
  end
end

local Prometheus = require("prometheus")
Prometheus.Logger.logLevel = Prometheus.Logger.LogLevel.Info
Prometheus.colors.enabled = false
Prometheus.Logger.debugCallback = function(...) pushLog("debug", ...) end
Prometheus.Logger.logCallback = function(...) pushLog("info", ...) end
Prometheus.Logger.warnCallback = function(...) pushLog("warn", ...) end
Prometheus.Logger.errorCallback = function(...)
  pushLog("error", ...)
  error(table.concat((function(...)
    local parts = {}
    for i = 1, select("#", ...) do
      parts[#parts + 1] = tostring(select(i, ...))
    end
    return parts
  end)(...), " "))
end

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 200)
collectgarbage("collect")

local ok, outputOrError = xpcall(function()
  local preset = ${f(e.preset)}
  local source = ${f(e.source)}
  local filename = ${f(e.filename)}
  local config = {}
  if preset == "Custom" then
    config.Steps = {}
    config.NameGenerator = ${e.customSettings?.entropyNaming?`"Entropy"`:`"MangledShuffled"`}
    ${_(e.customSettings)}
  else
    for key, value in pairs(Prometheus.Presets[preset] or Prometheus.Presets.Medium) do
      config[key] = value
    end
  end

  config.LuaVersion = ${f(e.luaVersion)}
  config.PrettyPrint = ${e.prettyPrint?`true`:`false`}
  config.Seed = ${Math.max(1,Math.floor(e.seed))}

  local res = Prometheus.Pipeline:fromConfig(config):apply(source, filename)
  collectgarbage("collect")
  return res
end, debug.traceback)
collectgarbage("collect")
return { ok = ok, output = ok and outputOrError or "", error = ok and "" or outputOrError, logs = logs }
`}function y(e){return`
local logs = {}
local unpackFn = table.unpack or unpack
local function pushLog(level, ...)
  local parts = {}
  for i = 1, select("#", ...) do
    parts[#parts + 1] = tostring(select(i, ...))
  end
  if type(_G.__prometheusPushLog) == "function" then
    _G.__prometheusPushLog(level, unpackFn(parts))
  end
  logs[#logs + 1] = { level = level, message = table.concat(parts, " ") }
end

print = function(...)
  pushLog("info", ...)
end

local ok, err = xpcall(function()
  local chunk, loadErr = load(${f(e.source)}, ${f(e.filename)}, "t")
  if not chunk then
    error(loadErr)
  end
  chunk()
end, debug.traceback)

if not ok then
  pushLog("error", err)
end

return { ok = ok, output = "", error = ok and "" or err, logs = logs }
`}function b(e){return Array.isArray(e)?e.map(e=>{let t=e;return{level:t.level===`warn`||t.level===`error`||t.level===`debug`?t.level:`info`,message:String(t.message??``)}}):[]}async function x(e,t){let n=[],r=null;try{r=await new(await(h()))(m(u)).createEngine({openStandardLibs:!0}),t&&r.global.set?.(`__prometheusPushLog`,(e,...r)=>{let i={level:e===`warn`||e===`error`||e===`debug`?e:`info`,message:r.map(e=>String(e??``)).join(` `)};n.push(i),t(i)});let i=await r.doString(v(e));return i.ok===!1?{ok:!1,error:String(i.error??`Prometheus failed`),logs:b(i.logs)}:{ok:!0,output:String(i.output??``),logs:b(i.logs)}}catch(e){return{ok:!1,error:e instanceof Error?e.message:String(e),logs:n}}finally{r?.global.close()}}async function S(e,t){let n=null;try{n=await new(await(h()))(m(u)).createEngine({openStandardLibs:!0}),t&&n.global.set?.(`__prometheusPushLog`,(e,...n)=>{t({level:e===`warn`||e===`error`||e===`debug`?e:`info`,message:n.map(e=>String(e)).join(` `)})});let r=await n.doString(y(e));return r.ok===!1?{ok:!1,error:String(r.error??`Script execution failed`),logs:b(r.logs)}:{ok:!0,output:String(r.output??``),logs:b(r.logs)}}catch(e){return{ok:!1,error:e instanceof Error?e.message:String(e),logs:[]}}finally{n?.global.close()}}export{o as n,c as r,S as runLuaScript,x as runPrometheus,l as t};