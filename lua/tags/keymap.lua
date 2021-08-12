local ctags = require('tags.ctags')
local cache = require('tags.cache')

local keymap = {}

function keymap.bind(buf)
	local map_opt = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(buf, 'n', 'p', '<cmd>lua require("tags.keymap").parent()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'n', 'o', '<cmd>lua require("tags.keymap").toggle()<cr>', map_opt)
	vim.api.nvim_buf_set_keymap(buf, 'n', '<cr>', '<cmd>lua require("tags.keymap").goto()<cr>', map_opt)
end

-- jump to parent
function keymap.parent()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local parent = cache.current.list[cursor[1]].parent
	if not parent then return end

	vim.api.nvim_win_set_cursor(0, { parent.index, cursor[2] })
end

-- jump to tag in file
function keymap.goto()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local tag = cache.current.list[cursor[1]]
	if not tag then return end

	vim.api.nvim_set_current_win(cache.current.winid)
	vim.api.nvim_win_set_cursor(0, { tag.line, 0 })
end

function keymap.toggle()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local tag = cache.current.list[cursor[1]]
	if not tag then return end

	if cache.current.open[tag] then
		cache.current.open[tag] = nil
	else
		cache.current.open[tag] = true
	end

	cache.current.render = nil
	tags.Render()
end

return keymap
