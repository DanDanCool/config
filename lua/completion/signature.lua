local api	= vim.api
local util	= require'completion.util'
local state = require'completion.state'

local signature = {}

function signature.autoSignature()
	local pos = api.nvim_win_get_cursor(0)
	local line = api.nvim_get_current_line()
	local line_to_cursor = vim.trim(line:sub(1, pos[2]))

	if not state.textSignature and util.checkTriggerCharacter(line_to_cursor) then
		vim.lsp.buf.signature_help()
		state.textSignature = true
		return
	end

	state.textSignature = util.checkTriggerCharacter(line_to_cursor)
end

return signature
