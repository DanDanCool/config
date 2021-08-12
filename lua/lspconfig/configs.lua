local util = require 'lspconfig/util'
local api, lsp = vim.api, vim.lsp
local tbl_extend = vim.tbl_extend

local configs = {}

function configs.__newindex(t, config_name, config_def)
	config_def.commands = config_def.commands or {}

	local config = tbl_extend("keep", config_def.default_config, util.default_config)
	config.name = config_name

	local M = {}

	function M.setup()
		if not vim.tbl_isempty(config_def.commands) then
			util.create_module_commands(config.name, config_def.commands)
		end

		local trigger = "FileType "..table.concat(config.filetypes, ',')

		api.nvim_command(string.format(
		"autocmd %s lua require'lspconfig'[%q].manager.try_add()",
		trigger, config.name))

		local function make_config(_root_dir)
			local new_config = vim.tbl_deep_extend("keep", vim.empty_dict(), config)

			new_config.capabilities = new_config.capabilities or lsp.protocol.make_client_capabilities()
			new_config.capabilities = vim.tbl_deep_extend('keep', new_config.capabilities,
				{ workspace = { configuration = true } })

			new_config.root_dir = _root_dir
			return new_config
		end

		local manager = util.server_per_root_dir_manager(make_config)

		function manager.try_add(bufnr)
			bufnr = bufnr or api.nvim_get_current_buf()

			local root_dir = config.root_dir(api.nvim_buf_get_name(bufnr))
			local id = manager.add(root_dir)

			if id then
				lsp.buf_attach_client(bufnr, id)
			end
		end

		M.manager = manager
		M.make_config = make_config
	end

	M.commands = config_def.commands
	M.name = config_name
	M.document_config = config_def

	rawset(t, config_name, M)
	return M
end

return setmetatable({}, configs)
