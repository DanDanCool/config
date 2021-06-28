local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local mt = {}

function mt:__index(k)
  local script_path = util.script_path()

  if configs[k] == nil then
    -- dofile is used here as a performance hack to increase the speed of calls to setup({})
    -- dofile does not cache module lookups, and requires the absolute path to the target file
    pcall(dofile, script_path .. 'lspconfig/' .. k .. ".lua")
  end

  return configs[k]
end

return setmetatable({}, mt)
