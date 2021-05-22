local api	= vim.api
local util	= require 'completion.util'

local signature = {}

function signature.autoSignature()
	if vim.lsp.buf_get_clients() == nil then return end

	for _, value in pairs(vim.lsp.buf_get_clients(0)) do
		if value.resolved_capabilities.signature_help == false or
			value.server_capabilities.signatureHelpProvider == nil then
			return
		end
	end

	local pos = api.nvim_win_get_cursor(0)
	local line = api.nvim_get_current_line()
	local line_to_cursor = vim.trim(line:sub(1, pos[2]))

	if util.checkTriggerCharacter(line_to_cursor) then
		vim.lsp.buf.signature_help()
	end
end

return signature
