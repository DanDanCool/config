local configs = require 'lspconfig/configs'

-- disable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics,
	{
		underline = false,
		virtual_text = false,
		signs = false,
		update_in_insert = false
	})


vim.api.nvim_command("command! -nargs=0 Format lua vim.lsp.buf.formatting()")

local mt = {}

function mt:__index(k)
	require('lspconfig/' .. k)
	return configs[k]
end

return setmetatable({}, mt)
