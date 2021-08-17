local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header()
	local params = { uri = vim.uri_from_bufnr(0) }

	vim.lsp.buf_request(bufnr, 'textDocument/switchSourceHeader', params, function(err, _, result)
		if err then error(tostring(err)) end
		if not result then print ("Corresponding file can’t be determined") return end

		vim.api.nvim_command('edit '..vim.uri_to_fname(result))
	end)
end

local function clangd_on_attach(client, bufnr)
	local map_opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>ClangdSwitchSourceHeader<cr>', map_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', map_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', map_opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'rn', '<cmd>lua vim.lsp.buf.rename()<cr>', map_opts)

	require('completion').setup()
end

local root_pattern = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")

local default_capabilities = vim.tbl_deep_extend('force',
util.default_config.capabilities or vim.lsp.protocol.make_client_capabilities(),
{
	textDocument = {
		completion = {
			editsNearCursor = true
		}
	},
	offsetEncoding = {"utf-8", "utf-16"}
});

configs.clangd = {
	default_config = {
		cmd = {"clangd", "--background-index"};
		filetypes = {"c", "cpp", "objc", "objcpp"};

		root_dir = function(fname)
			return root_pattern(fname) or util.path.dirname(fname)
		end;

		on_init = function(client, result)
			if result.offsetEncoding then
				client.offset_encoding = result.offsetEncoding
			end
		end;

		on_attach = clangd_on_attach;

		capabilities = default_capabilities;
	};

	commands = {
		ClangdSwitchSourceHeader = switch_source_header;
	};
}
