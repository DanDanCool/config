-- options
vim.o.number = true
vim.o.wrap = false
vim.o.backspace = 'indent,eol,start'
vim.o.swapfile = false

vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.autoindent = true

vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 5
vim.o.splitright = true

vim.o.ignorecase = true
vim.o.showtabline = 2
vim.o.termguicolors = true
vim.o.pumheight = 15

vim.o.modeline = false

vim.o.shada = ''

vim.g.TransparentBackground = 1
vim.api.nvim_command('colo jolly')

local map_opt = { noremap = true, silent = true }

if vim.fn.has('win32') then
	-- AAAAAAGGGGGHHHHH
	vim.api.nvim_set_keymap('n', '<c-z', '<nop>', map_opt)
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

vim.api.nvim_command('augroup autocommands')
vim.api.nvim_command('	autocmd!')
vim.api.nvim_command('	autocmd BufWritePre * %s/\\s\\+$//e')
vim.api.nvim_command('	autocmd TermOpen * setlocal nonumber')
vim.api.nvim_command('augroup end')

require('lspconfig').clangd.setup()
require('treesitter').setup()
require('filetree').Setup()
require('tags').setup()
require('pairs').setup()
require('statusline').setup()

vim.o.completeopt = 'menuone,noinsert,noselect'
vim.o.shortmess = vim.go.shortmess .. 'c'

vim.api.nvim_set_keymap('i', '<c-p>', '<cmd>lua require("completion").triggerCompletion()<cr>', map_opt)
vim.api.nvim_set_keymap('i', '<c-n>', '<cmd>lua require("completion").triggerCompletion()<cr>', map_opt)

-- ripgrep
vim.o.grepprg = 'rg --vimgrep'
vim.o.grepformat = '%f:%l:%c:%m'

function ripgrep(txt)
	vim.api.nvim_command('grep! ' .. txt)

	if #vim.fn.getqflist() then
		vim.api.nvim_command('botright copen | redraw!')
	else
		vim.api.nvim_command('cclose | redraw!')
		print('No match found for ' .. txt)
	end
end

vim.api.nvim_command('command! -nargs=* Rg v:lua.ripgrep(<q-args>)')

-- tagbar
vim.api.nvim_set_keymap('n', ';', '<cmd>lua require("tags").toggle()<cr>', map_opt)
vim.api.nvim_command('command! Tags lua require("tags").regenerate()')

-- NerdTree"
vim.api.nvim_set_keymap('n', '<c-n>', '<cmd>lua require("filetree").Toggle()<cr>', map_opt)

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

-- FZF
vim.api.nvim_set_keymap('n', '<c-p>', '<cmd>lua require("fzf").run()<cr>', map_opt)
