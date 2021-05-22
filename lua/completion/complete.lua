local state = require'completion.state'

local complete = {}

local function formatCompleteItems(items)
	table.sort(items, function(a, b)
		return (a.sortText or a.label) < (b.sortText or b.label)
	end)

	local matches = {}

	for _, completion_item in ipairs(items) do
		local item = {
			icase	= 0,
			equal	= 0,
			dup		= 0,
			empty	= 0,
			menu	= ''
		}

		item.word = vim.trim(string.gsub(completion_item.textEdit.newText, '\n', ' '))

		item.user_data = {
			lsp = {
				completion_item = completion_item,
			}
		}

		item.kind = vim.lsp.protocol.CompletionItemKind[completion_item.kind]
		item.abbr = vim.trim(completion_item.label)

		table.insert(matches, item)
	end

	return matches
end

function complete.autoComplete()
	if vim.lsp.buf_get_clients(0) == nil then return end

	local position_param = vim.lsp.util.make_position_params()

	vim.lsp.buf_request(0, 'textDocument/completion', position_param, function(err, _, result)
		local items = vim.lsp.util.extract_completion_items(result)

		if vim.tbl_isempty(items) then return end

		if vim.tbl_isempty(state.matches) then
			state.matches = formatCompleteItems(items)
		end

		local pos = vim.api.nvim_win_get_cursor(0)
		local line = vim.api.nvim_get_current_line()
		local line_to_cursor = line:sub(1, pos[2])
		local complete_pos = vim.fn.match(line_to_cursor, '\\k*$') + 1
		vim.fn.complete(complete_pos, state.matches)
	end)
end

return complete
