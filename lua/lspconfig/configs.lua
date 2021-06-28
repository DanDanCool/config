local util = require 'lspconfig/util'
local api, lsp = vim.api, vim.lsp
local tbl_extend = vim.tbl_extend

local configs = {}

function configs.__newindex(t, config_name, config_def)
	config_def.commands = config_def.commands or {}

	local default_config = tbl_extend("keep", config_def.default_config, util.default_config)
	default_config.name = config_name

	local M = {}

	function M.setup(config)
		config.commands = config.commands or {}
		config = tbl_extend("keep", config, default_config)

		local trigger = "FileType "..table.concat(config.filetypes, ',')

		api.nvim_command(string.format(
		"autocmd %s lua require'lspconfig'[%q].manager.try_add()",
		trigger, config.name))

		local function make_config(_root_dir)
			local new_config = vim.tbl_deep_extend("keep", vim.empty_dict(), config)
			new_config = vim.tbl_deep_extend('keep', new_config, default_config)

			new_config.capabilities = new_config.capabilities or lsp.protocol.make_client_capabilities()
			new_config.capabilities = vim.tbl_deep_extend('keep', new_config.capabilities,
				{ workspace = { configuration = true } })

			new_config.on_init = function(client, _result)
				if not vim.tbl_isempty(new_config.settings) then
					return client.notify('workspace/didChangeConfiguration',
					{ settings = new_config.settings })
				end
			end

			-- Save the old _on_attach so that we can reference it via the BufEnter.
			M.on_attach = new_config.on_attach
			new_config.on_attach = vim.schedule_wrap(function(client, bufnr)
				if bufnr == api.nvim_get_current_buf() then
					M._setup_buffer(client.id, bufnr)
				else
					api.nvim_command(string.format(
						"autocmd BufEnter <buffer=%d> ++once lua require'lspconfig'[%q]._setup_buffer(%d,%d)",
						bufnr, config_name, client.id, bufnr))
				end
			end)

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

	function M._setup_buffer(client_id, bufnr)
		local client = lsp.get_client_by_id(client_id)

		if M.on_attach then
			M.on_attach(client, bufnr)
		end

		if not vim.tbl_isempty(client.config.commands) then
			M.commands = vim.tbl_deep_extend("force", M.commands, client.config.commands)
			util.create_module_commands(config_name, M.commands)
		end
	end

	M.commands = config_def.commands
	M.name = config_name
	M.document_config = config_def

	rawset(t, config_name, M)
	return M
end

return setmetatable({}, configs)
