local api	= vim.api
local util	= require'completion.util'
local state = require'completion.state'

local signature = {}

function signature.autoSignature()
	print('signature')
	local pos = api.nvim_win_get_cursor(0)
	local line = api.nvim_get_current_line()
	local line_to_cursor = vim.trim(line:sub(1, pos[2]))

	state.textSignature = util.checkTriggerCharacter(line_to_cursor)

	if state.textSignature then
		-- overwrite signature help here to disable "no signature help" message
		local params = vim.lsp.util.make_position_params()
		local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
		vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, function(err, method, result, client_id)
			if not (result and result.signatures and result.signatures[1]) then
				return
			end

			local lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result, filetype)
			if vim.tbl_isempty(lines) then return end

			-- if `lines` can be trimmed, it is modified in place
			local ftype = vim.lsp.util.try_trim_markdown_code_blocks(lines)
			lines = vim.lsp.util.trim_empty_lines(lines)

			local bufnr, _ = vim.lsp.util.open_floating_preview(lines, ftype, {})
		end)
	end
end

return signature
