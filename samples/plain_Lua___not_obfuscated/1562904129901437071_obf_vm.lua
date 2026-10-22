-- Portable 8-bit XOR (works on any Lua version, no bitwise operators needed)
local function xor8(a, b)
  local result, bitval = 0, 1
  while a > 0 or b > 0 do
    local abit, bbit = a % 2, b % 2
    if abit ~= bbit then
      result = result + bitval
    end
    a = (a - abit) / 2
    b = (b - bbit) / 2
    bitval = bitval * 2
  end
  return result
end

local KEY = 42

-- Encoded constant pool (XOR(42)-obfuscated byte arrays)
local POOL = {
  {90, 88, 67, 68, 94}, -- [1]
  {66},                 -- [2]
  {67},                 -- [3]
}

local function decode(idx)
  local bytes = POOL[idx]
  local chars = {}
  for i = 1, #bytes do
    chars[i] = string.char(xor8(bytes[i], KEY))
  end
  return table.concat(chars)
end

-- Opcodes
local OP_PUSHK   = 0x11
local OP_RESOLVE = 0x22
local OP_CONCAT  = 0x44
local OP_CALL    = 0x33
local OP_HALT    = 0xFF

-- Bytecode program
local PROGRAM = {
  OP_PUSHK, 1,
  OP_RESOLVE,
  OP_PUSHK, 2,
  OP_PUSHK, 3,
  OP_CONCAT,
  OP_CALL, 1,
  OP_HALT,
}

local function run(code)
  local stack, sp, pc = {}, 0, 1
  local ops = {}

  ops[OP_PUSHK] = function()
    pc = pc + 1
    local idx = code[pc]
    pc = pc + 1
    sp = sp + 1
    stack[sp] = decode(idx)
  end

  ops[OP_RESOLVE] = function()
    pc = pc + 1
    stack[sp] = _G[stack[sp]]
  end

  ops[OP_CONCAT] = function()
    pc = pc + 1
    local b = stack[sp]; sp = sp - 1
    local a = stack[sp]
    stack[sp] = a .. b
  end

  ops[OP_CALL] = function()
    pc = pc + 1
    local n = code[pc]
    pc = pc + 1
    local args = {}
    for i = n, 1, -1 do
      args[i] = stack[sp]
      sp = sp - 1
    end
    local fn = stack[sp]
    sp = sp - 1
    fn(table.unpack(args))
  end

  ops[OP_HALT] = function()
    pc = -1
  end

  while pc ~= -1 and pc <= #code do
    local handler = ops[code[pc]]
    if not handler then
      error("bad opcode: " .. tostring(code[pc]))
    end
    handler()
  end
end

run(PROGRAM)
