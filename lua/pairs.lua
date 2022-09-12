autopairs = {}

autopairs.pair = {}
autopairs.pair['('] = ')'
autopairs.pair['['] = ']'
autopairs.pair['{'] = '}'
autopairs.pair["'"] = "'"
autopairs.pair['"'] = '"'
autopairs.pair[' '] = ' '

function autopairs.quote()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local char = string.sub(line, cursor[2], cursor[2])

	local output = "''<left>"

	if string.match(char, '%w') then
		output = "'"
	end

	return vim.api.nvim_replace_termcodes(output, true, false, true)
end

function autopairs.enter()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local pair = string.sub(line, cursor[2], cursor[2])
	local char = string.sub(line, cursor[2] + 1, cursor[2] + 1)

	local output = '<cr>'

	if char == autopairs.pair[pair] then
		output = '<cr><cr><up><tab>'
		output = output .. string.rep('<tab>', vim.fn.indent(cursor[1]) / vim.fn.shiftwidth())
	end

	return vim.api.nvim_replace_termcodes(output, true, false, true)
end

function autopairs.space()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local pair = string.sub(line, cursor[2], cursor[2])
	local char = string.sub(line, cursor[2] + 1, cursor[2] + 1)

	local output = '<space>'

	if char == autopairs.pair[pair] then
		output = '<space><space><left>'
	end

	return vim.api.nvim_replace_termcodes(output, true, false, true)
end

function autopairs.delete()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local pair = string.sub(line, cursor[2], cursor[2])
	local char = string.sub(line, cursor[2] + 1, cursor[2] + 1)

	local output = '<bs>'

	if char == autopairs.pair[pair] then
		if pair == ' ' then
			print("space")
			output = '<right><bs>'
		else
			output = '<right><bs><bs>'
		end
	end

	return vim.api.nvim_replace_termcodes(output, true, false, true)
end

function autopairs.ctrlw()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = vim.api.nvim_get_current_line()
	local pair = string.sub(line, cursor[2], cursor[2])
	local char = string.sub(line, cursor[2] + 1, cursor[2] + 1)

	local output = '<c-w>'

	if char == autopairs.pair[pair] then
		if pair == ' ' then
			print("space")
			output = '<right><bs>'
		else
			output = '<right><bs><bs>'
		end
	end

	return vim.api.nvim_replace_termcodes(output, true, false, true)
end

function autopairs.tab()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local indent = vim.fn.indent(cursor[1] - 1) / vim.fn.shiftwidth()

	local output = '<tab>'

	if cursor[2] == 0 then
		output = output .. string.rep('<tab>', indent - 1)
	end

	return vim.api.nvim_replace_termcodes(output, true, false, true)
end

function autopairs.setup()
	local map_opt = { noremap = true, silent = true }

	for key, def in pairs(autopairs.pair) do
		vim.api.nvim_set_keymap('i', key, key .. def .. '<left>', map_opt)
	end

	map_opt = { noremap = true, silent = true, expr = true }
	vim.api.nvim_set_keymap('i', "'", 'v:lua.autopairs.quote()', map_opt)
	vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.autopairs.enter()', map_opt)
	vim.api.nvim_set_keymap('i', '<space>', 'v:lua.autopairs.space()', map_opt)
	vim.api.nvim_set_keymap('i', '<bs>', 'v:lua.autopairs.delete()', map_opt)
	vim.api.nvim_set_keymap('i', '<c-w>', 'v:lua.autopairs.ctrlw()', map_opt)
	vim.api.nvim_set_keymap('i', '<tab>', 'v:lua.autopairs.tab()', map_opt)
end

return autopairs
