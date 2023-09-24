-- Registers all query predicates
require('treesitter.query_predicates')
local symbols = require('treesitter.symbols')
local language = require('treesitter.language')

treesitter = {}
treesitter.analyze = {}
treesitter.cursor = { 1, 0 }

local function keymap()
	local keys = {
		'o',
	}

	for _, key in ipairs(keys) do
		vim.api.nvim_buf_set_keymap(treesitter.buf, 'n', key, '<nop>', {
			noremap = true,
			silent = true,
			callback = function()
				local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
				if not symbols.map[row] then
					return
				end

				local node = symbols.map[row]
				vim.api.nvim_win_set_cursor(treesitter.analyze.win, { node.start_row + 1, node.start_col })
				vim.api.nvim_set_current_win(treesitter.analyze.win)
				treesitter.close()
			end
		})
	end

	local jump = function(offset)
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local max = vim.api.nvim_buf_line_count(0)

		row = row + offset
		while not symbols.map[row] do
			if row < 1 or row > max then
				return
			end

			row = row + offset
		end

		vim.api.nvim_win_set_cursor(0, { row, col })
	end

	vim.api.nvim_buf_set_keymap(treesitter.buf, 'n', 'j', '<nop>', {
		noremap = true,
		silent = true,
		callback = function()
			jump(1)
		end
	})

	vim.api.nvim_buf_set_keymap(treesitter.buf, 'n', 'k', '<nop>', {
		noremap = true,
		silent = true,
		callback = function()
			jump(-1)
		end
	})
end

function treesitter.create_window()
	treesitter.analyze.win = vim.api.nvim_get_current_win()

	local cur = vim.api.nvim_get_current_buf()
	if cur ~= treesitter.analyze.buf then
		treesitter.cursor = { 1, 1 }
		treesitter.analyze.buf = cur
	end

	treesitter.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(treesitter.buf, 'filetype', 'symbols')

	vim.api.nvim_command('silent! botright vertical new')
	treesitter.win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_width(0, 48)
	vim.api.nvim_win_set_buf(0, treesitter.buf)
	vim.wo.winfixwidth = true
	vim.wo.foldcolumn = '0'
	vim.wo.foldmethod = 'manual'
	vim.wo.foldenable = true
	vim.wo.list = false
	vim.wo.spell = false
	vim.wo.wrap = false
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.statusline = '%#STLText# treesitter'

	keymap()
end

function treesitter.close()
	if (vim.api.nvim_win_is_valid(treesitter.win)) then
		treesitter.cursor = vim.api.nvim_win_get_cursor(treesitter.win)
		vim.api.nvim_win_close(treesitter.win, true)
	end

	if vim.api.nvim_buf_is_valid(treesitter.buf) then
		vim.api.nvim_buf_delete(treesitter.buf, { force = true })
	end

	treesitter.win = nil
	treesitter.buf = nil
end

function treesitter.render()
	vim.api.nvim_buf_set_lines(treesitter.buf, 0, -1, false, symbols.render())
	vim.api.nvim_buf_set_option(treesitter.buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(treesitter.buf, 'bufhidden', 'hide')
	vim.api.nvim_buf_set_option(treesitter.buf, 'buftype', 'nofile')
	vim.api.nvim_buf_set_option(treesitter.buf, 'swapfile', false)
	vim.api.nvim_buf_set_option(treesitter.buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(treesitter.buf, 'buflisted', false)
end

function treesitter.toggle()
	if not treesitter.win then
		treesitter.create_window()
		treesitter.render()

		vim.api.nvim_win_set_cursor(treesitter.win, treesitter.cursor)
	else
		treesitter.close()
	end
end

function treesitter.setup()
	local groupid = vim.api.nvim_create_augroup("ts_highlight", {})
	vim.api.nvim_create_autocmd({"FileType"}, {
		group = groupid,
		callback = function(args)
			local lang = vim.api.nvim_buf_get_option(args.buf, 'ft')
			if not language.supported(lang) then
				return
			end

			vim.treesitter.start(args.buf, lang)
		end
	})
end

return treesitter
