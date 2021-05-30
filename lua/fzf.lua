local fzf = {}

local function getWinOpts()
	local opts = {
		relative	= 'editor',
		style		= 'minimal',
		border		= 'single'
	}

	opts.col = math.ceil(vim.o.columns / 10)
	opts.row = math.ceil(vim.o.lines / 8)
	opts.width = vim.o.columns - opts.col * 2
	opts.height = vim.o.lines - opts.row * 2

	return opts
end

function fzf.cleanup()
--	vim.api.nvim_set_current_win(fzf.cwin)
	vim.api.nvim_set_current_buf(fzf.cbuf)

	local file = io.open(fzf.temp)
	local contents = file:read('*a')

	vim.cmd(string.format('edit %s', contents))

--	vim.api.nvim_buf_delete(fzf.buf, { force = 1 })
	os.remove(fzf.temp)

	vim.defer_fn(function() vim.cmd('edit') end, 10)
end

-- stupid hack
function fzf.postcleanup()
	vim.api.nvim_feedkeys('0000', 'n', false)
	vim.cmd('edit')
end

function fzf.run()
--	fzf.cwin = vim.api.nvim_get_current_win()
	fzf.cbuf = vim.api.nvim_get_current_buf()
	fzf.buf =  vim.api.nvim_create_buf(0, 1)
--	fzf.win = vim.api.nvim_open_win(fzf.buf, 1, getWinOpts())
	fzf.temp = os.tmpname()

	local cmd = 'fzf --preview "bat --color always --style plain --line-range :100 --tabs 4 {}" > ' .. fzf.temp

	vim.api.nvim_set_current_buf(fzf.buf)
	vim.cmd('term ' .. cmd)
	vim.api.nvim_input('i')

	vim.cmd('autocmd TermClose <buffer> lua require"fzf".cleanup()')
end

return fzf
