call plug#begin(stdpath('data'))

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'preservim/nerdtree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'

"Pretty"
Plug 'itchyny/lightline.vim'
Plug 'DanDanCool/JollyTheme'

"TODO: move this out when 0.5 becomes stable
if has("nvim-0.5")
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'nvim-treesitter/nvim-treesitter'
	"Plug 'nvim-treesitter/playground'
endif

call plug#end()

set number
set clipboard=unnamed
set backspace=indent,eol,start
set noswapfile

set noexpandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set autoindent

set foldmethod=indent
set foldlevelstart=5

set ignorecase

set showtabline=2

set termguicolors

set pumheight=15

let mapleader = "-"

if has('win32')
	" AAAAAAGGGGGHHHHH
	nmap <C-z> <Nop>
endif

"Split navigation"
nnoremap <S-H> <C-W><C-H>
nnoremap <S-J> <C-W><C-J>
nnoremap <S-K> <C-W><C-K>
nnoremap <S-L> <C-W><C-L>

nnoremap gk K

"move lines up and down
inoremap <A-k> <Esc>ddkkp0i
inoremap <A-j> <Esc>ddp0i

inoremap <C-E> <s-right>
inoremap <C-B> <s-left>
inoremap <C-A> <Esc><S-A>

"vimrc
command! -nargs=0 VIMRC vsplit $MYVIMRC
command! -nargs=0 RVIMRC so $MYVIMRC
command! -nargs=0 TERM call OpenTerminal()

func! OpenTerminal()
	tabnew
	term
endfunc

"commenting
nnoremap <C-/> I//<Esc>0
nnoremap <silent> // <cmd>noh<Return>

tnoremap <Esc> <C-\><C-n>

augroup autocommands
	autocmd!
	autocmd FileType python <cmd>noremap <C-/> I#<Esc>0
	autocmd FileType c,cpp setlocal expandtab
	autocmd FileType text setlocal conceallevel=2
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePost,BufWinEnter * silent! call tagbar#ForceUpdate() | call lightline#update()
	autocmd WinNew * silent! NERDTreeMirror | silent! NERDTreeClose
	autocmd FileType nerdtree vnoremap <silent> <buffer> t <cmd>call tree#open_nodes('t', 1)<CR> |
				\ vnoremap <silent> <buffer> dd <cmd>call tree#delete_nodes(1)<CR> |
				\ vnoremap <silent> <buffer> m <cmd>call tree#move_nodes(1)<CR> |
				\ vnoremap <silent> <buffer> c <cmd>call tree#copy_nodes(1)<CR>
	autocmd TermOpen * setlocal nonumber
augroup END

syntax keyword Note NOTE IMPORTANT
highlight link Note Todo

"Settings for nightly build
if has("nvim-0.5")
	"nvim-lspconfig"

lua << EOF
	local lspconfig = require'lspconfig'

	local clangd_on_attach = function(client, bufnr)
		local map_opts = { noremap = true, silent = true }
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>ClangdSwitchSourceHeader<cr>', map_opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gk', '<cmd>lua vim.lsp.buf.hover()<cr>', map_opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', map_opts)
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'rn', '<cmd>lua vim.lsp.buf.rename()<cr>', map_opts)

		require'completion'.on_attach()
	end

	lspconfig.clangd.setup{
		on_attach = clangd_on_attach
	}

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
			virtual_text = false,
			signs = false,
			update_in_insert = false
		}
	)

	require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }

	require'nvim-treesitter.configs'.setup {
		highlight = {
			enable = true,
		},

		playground = {
			enable = true,
			disable = {},
			updatetime = 25,
			persist_queries = false,
			keybindings = {
				toggle_query_editor = 'o',
				toggle_hl_groups = 'i',
				toggle_injected_languages = 't',
				toggle_anonymous_nodes = 'a',
				toggle_language_display = 'I',
				focus_language = 'f',
				unfocus_language = 'F',
				update = 'R',
				goto_node = '<cr>',
				show_help = '?'
			}
		}
	}
EOF

	command! -nargs=0 Format lua vim.lsp.buf.formatting()

	" Set completeopt to have a better completion experience
	set completeopt=menuone,noinsert,noselect
	let g:completion_matching_strategy_list = ["exact", "substring"]

	" Avoid showing message extra message when using completion
	set shortmess+=c

	let g:completion_enable_auto_popup = 0
	let g:completion_menu_length = 30
	let g:completion_abbr_length = 30
endif "nightly build settings"

"pairs
so $HOME/appdata/local/nvim/pairs.vim

"tagbar
nnoremap <silent> ; <cmd>ShowTags<CR>
let g:tagbar_compact		= 2
let g:tagbar_foldlevel		= 2
let g:tagbar_autofocus		= 1
let g:tagbar_no_autocmds	= 1

command! -nargs=0 ShowTags call tagbar#ToggleWindow() | call lightline#update()

"JollyTheme
let g:JollyTransparentBackground = 1
colo jolly

"lightline
so $HOME/appdata/local/nvim/lightline.vim

"NerdTree"
nnoremap <silent> <C-N> <cmd>Tree<Return>
let NERDTreeMinimalUI				= 1
let NERDTreeAutoDeleteBuffer		= 1
let NERDTreeNaturalSort				= 1
let NERDTreeChDirMode				= 2
let NERDTreeMouseMode				= 2
let NERDTreeShowHidden				= 1
let NERDTreeCascadeSingleChildDir	= 0
let NERDTreeDirArrowExpandable		= "+"
let NERDTreeDirArrowCollapsible		= "-"

command! -n=? -complete=dir -bar Tree :call g:NERDTreeCreator.ToggleTabTree('<args>') |
	\ :call lightline#update()

"FZF
nnoremap <silent> <C-P> <cmd>FZF<Return>
