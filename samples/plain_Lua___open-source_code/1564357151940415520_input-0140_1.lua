local fs = require("@lune/fs")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local Types = require("./infinitysrc/types")
local Logger = require("./infinitysrc/logger")
local LoopDetector = require("./infinitysrc/loopdetector")
local RobloxMock = require("./infinitysrc/robloxmock")
local Sandbox = require("./infinitysrc/sandbox")
local Reconstructor = require("./infinitysrc/reconstructor")

local Unveilr = {}

function Unveilr.createConfig(overrides: Types.ConfigOverrides?): Types.Config
	local default: Types.Config = {
		maxInstructions = 10000000,
		maxTime = 30,
		maxYields = 10000,
		loopThreshold = 1000,
		verboseLogging = false,
		outputPath = "output.luau",
		reconstructAST = true,
	}

	if overrides then
		for key, value in overrides do
			(default :: any)[key] = value
		end
	end

	return default
end

function Unveilr.run(inputPath: string, config: Types.Config): Types.UnveilrResult
	local result: Types.UnveilrResult = {
		success = false,
		outputCode = nil,
		logs = {},
		errors = {},
		stats = {
			totalCalls = 0,
			totalGets = 0,
			totalSets = 0,
			executionTime = 0,
			instructionsExecuted = 0,
		},
	}

	if not fs.isFile(inputPath) then
		table.insert(result.errors, `File not found: {inputPath}`)
		return result
	end

	local sourceCode = fs.readFile(inputPath)

	local logger = Logger.new(config.verboseLogging)
	local loopDetector = LoopDetector.new(config)
	local robloxMock = RobloxMock.new(logger)
	local sandbox = Sandbox.new(logger, loopDetector, robloxMock)

	local startTime = os.clock()

	local execSuccess, execError = sandbox:execute(sourceCode)

	result.stats.executionTime = os.clock() - startTime
	result.stats.totalCalls = logger:getCallCount()
	result.stats.totalGets = logger:getGetCount()
	result.stats.totalSets = logger:getSetCount()
	result.stats.instructionsExecuted = loopDetector:getInstructionCount()

	if not execSuccess then
		table.insert(result.errors, execError or "Unknown execution error")
	end

	result.logs = logger:getAllLogs()

	if config.reconstructAST then
		local reconstructor = Reconstructor.new(logger)
		local reconstructSuccess, reconstructedCode = reconstructor:reconstruct()

		if reconstructSuccess and reconstructedCode then
			result.outputCode = reconstructedCode
			result.success = true

			fs.writeFile(config.outputPath, reconstructedCode)
		else
			table.insert(result.errors, "Reconstruction failed")
		end
	else
		result.success = execSuccess
	end

	return result
end

function Unveilr.printBanner()
	stdio.write(stdio.color("cyan"))
	print([[
   __  __                _ __     
  / / / /___  _   _____ (_) /____
 / / / / __ \| | / / _ \/ / / ___/
/ /_/ / / / /| |/ /  __/ / / /    
\____/_/ /_/ |___/\___/_/_/_/     
                                  
  Advanced Environment Logger
]])
	stdio.write(stdio.color("reset"))
end

function Unveilr.printStats(result: Types.UnveilrResult)
	stdio.write(stdio.color("yellow"))
	print("\n═══════════════════════════════════")
	print("         EXECUTION STATS           ")
	print("═══════════════════════════════════")
	stdio.write(stdio.color("reset"))

	print(`  Total Calls:    {result.stats.totalCalls}`)
	print(`  Total Gets:     {result.stats.totalGets}`)
	print(`  Total Sets:     {result.stats.totalSets}`)
	print(`  Instructions:   {result.stats.instructionsExecuted}`)
	print(`  Time Elapsed:   {string.format("%.4f", result.stats.executionTime)}s`)

	if result.success then
		stdio.write(stdio.color("green"))
		print("\n[SUCCESS] Reconstruction complete")
		stdio.write(stdio.color("reset"))
	else
		stdio.write(stdio.color("red"))
		print("\n[FAILED] Errors occurred:")
		for _, err in result.errors do
			print(`  • {err}`)
		end
		stdio.write(stdio.color("reset"))
	end
end

local function main()
	Unveilr.printBanner()

	local args = process.args

	if #args < 1 then
		stdio.write(stdio.color("red"))
		print("Usage: lune run main.luau <input_file> [output_file]")
		stdio.write(stdio.color("reset"))
		process.exit(1)
	end

	local inputPath = args[1]
	local outputPath = args[2] or "output.luau"

	local configOverrides: Types.ConfigOverrides = {
		outputPath = outputPath,
		verboseLogging = table.find(args, "--verbose") ~= nil,
	}

	local maxTimeArg = table.find(args, "--max-time")
	if maxTimeArg and args[maxTimeArg + 1] then
		configOverrides.maxTime = tonumber(args[maxTimeArg + 1])
	end

	local maxInstrArg = table.find(args, "--max-instructions")
	if maxInstrArg and args[maxInstrArg + 1] then
		configOverrides.maxInstructions = tonumber(args[maxInstrArg + 1])
	end

	local config = Unveilr.createConfig(configOverrides)

	stdio.write(stdio.color("cyan"))
	print(`\nProcessing: {inputPath}`)
	print(`Output to:  {outputPath}\n`)
	stdio.write(stdio.color("reset"))

	local result = Unveilr.run(inputPath, config)

	Unveilr.printStats(result)

	process.exit(result.success and 0 or 1)
end

main()

return Unveilr