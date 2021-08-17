local ffi = require('ffi')
local keymap = require('fzf.keymap')

fzf = {}

fzf.results = {}
fzf.prompt = {}

ffi.cdef[[
	typedef struct
	{
		char* str;
		size_t len;
	} fzf_string;

	typedef struct
	{
		fzf_string results[40];
		size_t len;
	} fzf_output;

	void fzf_setup(char** ignore, int len);
	fzf_output fzf_get_output(fzf_string* input);
	int fzf_char_match(fzf_string* s1, fzf_string* s2);
	int fzf_fuzzy_match(fzf_string* s1, fzf_string* s2);
]]

local lib = {}

function fzf.setup()
	local path = vim.api.nvim_get_runtime_file('bin/libfuzzy.*', false)
	lib = ffi.load(path[1])

	local ignore = ffi.new('char*[?]', 2)
	ignore[0] = ffi.new('char[?]', #'./.git')
	ffi.copy(ignore[0], './.git')

	ignore[1] = ffi.new('char[?]', #'./bin')
	ffi.copy(ignore[1], './bin')

	lib.fzf_setup(ignore, 2)
end

function fzf.get_results(input)
	input = string.lower(input)

	local prompt = ffi.new('fzf_string[?]', 1)
	prompt[0].str = ffi.new('char[?]', #input + 1)
	ffi.copy(prompt[0].str, input)
	prompt[0].len = #input

	local output = lib.fzf_get_output(prompt)
	return output
end

function fzf.create_win()
	local opts = {
		relative	= 'editor',
		style		= 'minimal',
		border		= 'single'
	}

	opts.col = math.ceil(vim.o.columns / 4)
	opts.row = math.ceil(vim.o.lines / 8) - 2
	opts.width = vim.o.columns - opts.col * 2
	opts.height = vim.o.lines - opts.row * 2 - 6

	fzf.results.buf = vim.api.nvim_create_buf(false, true)
	fzf.results.win = vim.api.nvim_open_win(fzf.results.buf, false, opts)

	opts.row = vim.o.lines - math.ceil(vim.o.lines / 8) - 2
	opts.height = 1

	fzf.prompt.buf = vim.api.nvim_create_buf(false, true)
	fzf.prompt.win = vim.api.nvim_open_win(fzf.prompt.buf, true, opts)
	fzf.prompt.tick = vim.api.nvim_buf_get_changedtick(fzf.prompt.buf)

	fzf.selection = 40
	fzf.selected = ''

	vim.wo.statusline = '%#STLText# fzf'
	vim.bo.filetype = 'fzf'

	vim.api.nvim_command('autocmd BufLeave <buffer> lua require("fzf").close()')
	vim.api.nvim_buf_set_option(fzf.prompt.buf, 'buftype', 'prompt')
	vim.fn.prompt_setprompt(fzf.prompt.buf, '> ')
	keymap.bind(fzf.prompt.buf)
end

function fzf.close()
	vim.api.nvim_set_current_win(fzf.cwin)
	vim.api.nvim_set_current_buf(fzf.cbuf)

	vim.api.nvim_win_close(fzf.results.win, { force = 1 })
	vim.api.nvim_win_close(fzf.prompt.win, { force = 1 })
	vim.api.nvim_buf_delete(fzf.results.buf, { force = 1 })
	vim.api.nvim_buf_delete(fzf.prompt.buf, { force = 1 })
	vim.api.nvim_input('<esc>')
end

function fzf.render(lines)
	local output = {}

	local len = tonumber(lines.len) - 1
	for i = 0, len do
		local prefix = '  '
		local str = lines.results[i]

		if i == fzf.selection - 1 then
			prefix = '> '
			fzf.selected = ffi.string(str.str, str.len)
		end

		table.insert(output, prefix .. ffi.string(str.str, str.len))
	end

	vim.api.nvim_buf_set_lines(fzf.results.buf, 0, -1, false, output)
end

function fzf.run()
	fzf.cwin = vim.api.nvim_get_current_win()
	fzf.cbuf = vim.api.nvim_get_current_buf()

	fzf.create_win()

	local timer = vim.loop.new_timer()
	timer:start(100, 100, vim.schedule_wrap(function()
		local tick = vim.api.nvim_buf_get_changedtick(fzf.prompt.buf)
		if tick == fzf.prompt.tick then	return end

		local lines = vim.api.nvim_buf_get_lines(fzf.prompt.buf, 0, 1, false)
		local input = string.sub(lines[1], 2)
		local output = fzf.get_results(input)
		fzf.render(output)
	end))

	vim.api.nvim_buf_attach(fzf.prompt.buf, false, {
		on_detach = function()
			timer:stop()
			timer:close()
		end
	})

	vim.api.nvim_input('i')
end

return fzf
