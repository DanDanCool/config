local validate = vim.validate
local api = vim.api
local lsp = vim.lsp
local uv = vim.loop
local fn = vim.fn

local M = {}

M.default_config = {
  log_level = lsp.protocol.MessageType.Warning;
  message_level = lsp.protocol.MessageType.Warning;
  settings = vim.empty_dict();
  init_options = vim.empty_dict();
  handlers = {};
}

function M.create_module_commands(module_name, commands)
  for command_name, def in pairs(commands) do
    local command = "command! "
	command = command .. command_name
    command = command .. string.format(" lua require'lspconfig'[%q].commands[%q](<f-args>)", module_name, command_name)

    api.nvim_command(command)
  end
end

function M.script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*[/\\])")
end

-- Some path utilities
M.path = {}
M.path.is_windows   = uv.os_uname().version:match("Windows")
M.path.path_sep     = M.path.is_windows and "\\" or "/"

M.path.is_fs_root   = nil
if M.path.is_windows then
  M.path.is_fs_root = function(path)
    return path:match("^%a:$")
  end
else
  M.path.is_fs_root = function(path)
    return path == "/"
  end
end

function M.path.dirname(path)
  if not path then return end

  local strip_dir_pat = M.path.path_sep.."([^"..M.path.path_sep.."]+)$"
  local strip_sep_pat = M.path.path_sep.."$"

  local result = path:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
  if #result == 0 then
    return "/"
  end

  return result
end

function M.path.exists(filename)
  local stat = uv.fs_stat(filename)
  return stat and stat.type or false
end

function M.path.is_dir(filename)
  return M.path.exists(filename) == 'directory'
end

function M.path.is_file(filename)
  return M.path.exists(filename) == 'file'
end

function M.path.is_absolute(filename)
  if M.path.is_windows then
    return filename:match("^%a:") or filename:match("^\\\\")
  else
    return filename:match("^/")
  end
end

function M.path.join(...)
  local result = table.concat(vim.tbl_flatten {...}, M.path.path_sep):gsub(M.path.path_sep.."+", M.path.path_sep)
  return result
end

-- Traverse the path calling cb along the way.
function M.path.traverse_parents(path, cb)
  path = uv.fs_realpath(path)
  local dir = path
  -- Just in case our algo is buggy, don't infinite loop.
  for _ = 1, 100 do
    dir = dirname(dir)
    if not dir then return end
    -- If we can't ascend further, then stop looking.
    if cb(dir, path) then
      return dir, path
    end
    if is_fs_root(dir) then
      break
    end
  end
end

-- Iterate the path until we find the rootdir.
function M.path.iterate_parents(path)
  path = uv.fs_realpath(path)

  local function it(s, v)
    if not v then return end
    if M.path.is_fs_root(v) then return end

    return M.path.dirname(v), path
  end

  return it, path, path
end

function M.path.is_descendant(root, path)
  if (not path) then
    return false;
  end

  local function cb(dir, _)
    return dir == root;
  end

  local dir, _ = traverse_parents(path, cb);

  return dir == root;
end

-- Returns a function(root_dir), which, when called with a root_dir it hasn't
-- seen before, will call make_config(root_dir) and start a new client.
function M.server_per_root_dir_manager(_make_config)
  local clients = {}
  local manager = {}

  function manager.add(root_dir)
    if not root_dir then return end
    if not M.path.is_dir(root_dir) then return end

    -- Check if we have a client alredy or start and store it.
    local client_id = clients[root_dir]

    if not client_id then
      local new_config = _make_config(root_dir)

      new_config.on_exit = function()
        clients[root_dir] = nil
      end

      client_id = lsp.start_client(new_config)
      clients[root_dir] = client_id
    end

    return client_id
  end

  function manager.clients()
    local res = {}

    for _, id in pairs(clients) do
      local client = lsp.get_client_by_id(id)
      if client then
        table.insert(res, client)
      end
    end

    return res
  end

  return manager
end

function M.search_ancestors(startpath, func)
  validate { func = {func, 'f'} }
  if func(startpath) then return startpath end

  for path in M.path.iterate_parents(startpath) do
    if func(path) then return path end
  end
end

function M.root_pattern(...)
  local patterns = vim.tbl_flatten {...}

  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      for _, p in ipairs(vim.fn.glob(M.path.join(path, pattern), true, true)) do
        if M.path.exists(p) then
          return path
        end
      end
    end
  end

  return function(startpath)
    return M.search_ancestors(startpath, matcher)
  end
end

function M.find_git_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, ".git")) then
      return path
    end
  end)
end

function M.find_node_modules_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, "node_modules")) then
      return path
    end
  end)
end

function M.find_package_json_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_file(M.path.join(path, "package.json")) then
      return path
    end
  end)
end

return M
