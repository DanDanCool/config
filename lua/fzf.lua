local ffi = require('ffi')
local keymap = require('fzf.keymap')

fzf = {}

fzf.results = {}
fzf.prompt = {}

ffi.cdef[[
	typedef struct string string;
	struct string {
		char* data;
		uint64_t size;
	};

	typedef struct vector vector;
	struct vector {
		string* data;
		uint32_t reserve;
		uint32_t size;
	};

	void fzf_init();
	void fzf_term();
	void fzf_start(const char* prompt);
	vector fzf_scores();
]]

local lib = {}

function fzf.setup()
	local path = vim.api.nvim_get_runtime_file('bin/libfuzzy.*', false)
	lib = ffi.load(path[1])
	lib.fzf_init()
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

	fzf.selection = 0
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

	vim.api.nvim_win_close(fzf.results.win, true)
	vim.api.nvim_win_close(fzf.prompt.win, true)
	vim.api.nvim_buf_delete(fzf.results.buf, { force = 1 })
	vim.api.nvim_buf_delete(fzf.prompt.buf, { force = 1 })
	vim.api.nvim_input('<esc>')
end

function fzf.render()
	local lines = {}
	local output = lib.fzf_scores()

	local height = vim.api.nvim_win_get_height(fzf.results.win)
	local len = tonumber(output.size)
	if len == 0 then return end

	for i = 1, height - len do
		table.insert(lines, '')
	end

	local start = math.max(len - height, 0)
	for i = start, len - 1 do
		local prefix = '  '
		local str = output.data[i]

		if i == len - fzf.selection - 1 then
			prefix = '> '
			fzf.selected = ffi.string(str.data, str.size)
		end

		table.insert(lines, prefix .. ffi.string(str.data, str.size))
	end

	vim.api.nvim_buf_set_lines(fzf.results.buf, 0, -1, false, lines)
end

function fzf.run()
	fzf.cwin = vim.api.nvim_get_current_win()
	fzf.cbuf = vim.api.nvim_get_current_buf()

	fzf.create_win()

	local timer = vim.loop.new_timer()
	timer:start(100, 50, vim.schedule_wrap(function()
		local tick = vim.api.nvim_buf_get_changedtick(fzf.prompt.buf)
		if tick ~= fzf.prompt.tick then
			fzf.prompt.tick = tick

			local lines = vim.api.nvim_buf_get_lines(fzf.prompt.buf, 0, 1, false)
			local input = string.sub(lines[1], 3):lower()
			local prompt = ffi.new('char[?]', #input + 1)
			ffi.copy(prompt, input)

			lib.fzf_start(prompt)
		end

		if vim.api.nvim_buf_line_count(fzf.prompt.buf) > 1 then
			vim.api.nvim_buf_set_lines(fzf.prompt.buf, 0, -1, false, {})
		end

		fzf.render()
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
