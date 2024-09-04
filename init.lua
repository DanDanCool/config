-- options
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false
vim.opt.backspace = 'indent,eol,start'
vim.opt.swapfile = false

vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.autoindent = true
vim.opt.textwidth = 120

vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 5
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.showtabline = 2
vim.opt.termguicolors = true
vim.opt.pumheight = 15

vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.modeline = false

vim.opt.shada = ''

vim.g.TransparentBackground = 1
vim.g.loaded_python3_provider = 0
vim.api.nvim_command('colo nord')

local map_opt = { noremap = true, silent = true }

-- AAAAAAGGGGGHHHHH
if vim.fn.has('win32') == 1 then
	vim.api.nvim_set_keymap('n', '<c-z>', '<nop>', map_opt)
end

-- Split navigation"
vim.api.nvim_set_keymap('n', '<s-h>', '<c-w><c-h>', map_opt)
vim.api.nvim_set_keymap('n', '<s-j>', '<c-w><c-j>', map_opt)
vim.api.nvim_set_keymap('n', '<s-k>', '<c-w><c-k>', map_opt)
vim.api.nvim_set_keymap('n', '<s-l>', '<c-w><c-l>', map_opt)

vim.api.nvim_set_keymap('n', '<up>', '<cmd>bprev<cr>', map_opt)
vim.api.nvim_set_keymap('n', '<down>', '<cmd>bnext<cr>', map_opt)

vim.api.nvim_set_keymap('n', '//', '<cmd>noh<cr>', map_opt)

vim.api.nvim_set_keymap('n', 'gh', '<nop>', map_opt)
vim.api.nvim_set_keymap('n', 'gk', 'K', map_opt)

vim.api.nvim_set_keymap('t', '<esc>', '<c-\\><c-n>', map_opt)

vim.api.nvim_set_keymap('v', 'y', '"+y', map_opt)
vim.api.nvim_set_keymap('v', 'p', '"+p', map_opt)

local function delete_empty_buffers()
	local name = vim.api.nvim_buf_get_name(0)
	if name == '' then
		return
	end

	local bufs = vim.api.nvim_list_bufs()
	for _, buf in ipairs(bufs) do
		if vim.api.nvim_buf_get_name(buf) == '' and not vim.api.nvim_buf_get_option(buf, 'modified') then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

local groupid = vim.api.nvim_create_augroup("global_autocommands", {})
vim.api.nvim_create_autocmd({"BufWritePre"}, {
	group = groupid,
	command = "%s/\\s\\+$//e"
})
vim.api.nvim_create_autocmd({"BufWinEnter"}, {
	group = groupid,
	callback = delete_empty_buffers
})

-- plugins
-- require('lspconfig').clangd.setup()
require('treesitter').setup()
require('filetree').setup()
require('pairs').setup()
require('statusline').setup()
require('fzf').setup()
require('ripgrep').setup()

vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.shortmess = vim.opt.shortmess + 'c'

--vim.api.nvim_set_keymap('i', '<c-p>', '<cmd>lua require("completion").trigger_completion()<cr>', map_opt)
--vim.api.nvim_set_keymap('i', '<c-n>', '<cmd>lua require("completion").trigger_completion()<cr>', map_opt)

-- NerdTree"
vim.api.nvim_set_keymap('n', '<c-n>', '<cmd>lua require("filetree").toggle()<cr>', map_opt)

-- FZF
vim.api.nvim_set_keymap('n', '<c-p>', '<cmd>lua require("fzf").run()<cr>', map_opt)

vim.api.nvim_set_keymap('n', ';', '<cmd>lua require("treesitter").toggle()<cr>', map_opt)

-- disable nonsense plugins
vim.g.loaded_fzf				= 1
vim.g.loaded_gzip				= 1
vim.g.loaded_netrw				= 1
vim.g.loaded_tarPlugin			= 1
vim.g.loaded_zipPlugin			= 1
vim.g.loaded_netrwPlugin		= 1
vim.g.loaded_2html_plugin		= 1
vim.g.loaded_shada_plugin		= 1
vim.g.loaded_remote_plugins		= 1
vim.g.loaded_spellfile_plugin	= 1
vim.g.loaded_tutor_mode_plugin	= 1

vim.g.c_no_curly_error = 1
vim.g.c_no_bracket_error = 1
