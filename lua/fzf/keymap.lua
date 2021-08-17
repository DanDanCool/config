local keymap = {}

function keymap.bind(buf)
	local map_opt = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(buf, 'i', '<cr>', '<cmd>lua require("fzf.keymap").enter()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'i', '<up>', '<cmd>lua require("fzf.keymap").up()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'i', '<down>', '<cmd>lua require("fzf.keymap").down()<cr>', map_opt)

	vim.api.nvim_buf_set_keymap(buf, 'n', '<cr>', '<cmd>lua require("fzf.keymap").enter()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<up>', '<cmd>lua require("fzf.keymap").up()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<down>', '<cmd>lua require("fzf.keymap").down()<cr>', map_opt)

	vim.api.nvim_buf_set_keymap(buf, 'n', 't', '<cmd>lua require("fzf.keymap").tab()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'n', 's', '<cmd>lua require("fzf.keymap").split()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<esc>', '<cmd>lua require("fzf.keymap").esc()<cr>', map_opt)
end

function keymap.up()
	fzf.selection = fzf.selection - 1
	if (fzf.selection < 1) then fzf.selection = 1 end
end

function keymap.down()
	fzf.selection = fzf.selection + 1
	if (fzf.selection > 40) then fzf.selection = 40 end
end

function keymap.enter()
	vim.api.nvim_set_current_win(fzf.cwin)
	vim.api.nvim_command('edit ' .. fzf.selected)
end

function keymap.esc()
	vim.api.nvim_set_current_win(fzf.cwin)
end

function keymap.split()
	vim.api.nvim_set_current_win(fzf.cwin)
	vim.api.nvim_command('vsplit ' .. fzf.selected)
end

function keymap.tab()
	vim.api.nvim_set_current_win(fzf.cwin)
	vim.api.nvim_command('tabnew ' .. fzf.selected)
end

return keymap
