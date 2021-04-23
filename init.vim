call plug#begin(stdpath('data'))

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'preservim/nerdtree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'

"Pretty"
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'DanDanCool/JollyTheme'

"TODO: move this out when 0.5 becomes stable
if has("nvim-0.5")
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
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
set smartindent

set foldmethod=indent
set foldlevelstart=5

set ignorecase

set showtabline=2

set termguicolors

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

inoremap <C-S> <Esc>:w<Return>a

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
nnoremap <C-/> 0i//<Esc>0
nnoremap <silent> // :noh<Return>

tnoremap <Esc> <C-\><C-n>

augroup autocommands
	autocmd!
	autocmd FileType python :noremap <C-/> 0i#<Esc>0
	autocmd FileType c,cpp setlocal expandtab
	autocmd FileType text setlocal conceallevel=2
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePost,BufWinEnter * silent! call tagbar#ForceUpdate() | call lightline#update()
	autocmd WinNew * silent! NERDTreeMirror | silent! NERDTreeClose
	autocmd FileType nerdtree vnoremap <silent> <buffer> t :call tree#open_nodes('t', 1)<CR> |
				\ vnoremap <silent> <buffer> dd :call tree#delete_nodes(1)<CR> |
				\ vnoremap <silent> <buffer> m :call tree#move_nodes(1)<CR> |
				\ vnoremap <silent> <buffer> c :call tree#copy_nodes(1)<CR>
	autocmd TermOpen * setlocal nonumber
augroup END

syntax keyword Note NOTE IMPORTANT
highlight link Note Todo

"Settings for nightly build
if has("nvim-0.5")
	"nvim-lspconfig"

lua << EOF
	local lspconfig = require'lspconfig'

	lspconfig.clangd.setup{
		on_attach=require'completion'.on_attach
	}

	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
			virtual_text = false,
			signs = false,
			update_in_insert = false
		}
	)

	require'nvim-treesitter.configs'.setup {
		highlight = {
			enable = true,
		},
	}
EOF

	"completion-nvim"
	" Use <Tab> and <S-Tab> to navigate through popup menu
	inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

	" Set completeopt to have a better completion experience
	set completeopt=menuone,noinsert,noselect
	let g:completion_matching_strategy_list = ["exact", "substring", "fuzzy"]

	" Avoid showing message extra message when using completion
	set shortmess+=c

	let g:completion_enable_auto_popup = 0
endif "nightly build settings"

"pairs
so $HOME/appdata/local/nvim/pairs.vim

"tagbar
nnoremap <silent> ; :ShowTags<CR>
let g:tagbar_compact = 2
let g:tagbar_foldlevel = 2
let g:tagbar_autofocus = 1
let g:tagbar_no_autocmds = 1

command! -nargs=0 ShowTags call tagbar#ToggleWindow() | call lightline#update()

"JollyTheme
let g:JollyTransparentBackground = 1
colo jolly

"lightline
so $HOME/appdata/local/nvim/lightline.vim

"NerdTree"
nnoremap <silent> <C-N> :Tree<Return>
let NERDTreeMinimalUI			= 1
let NERDTreeAutoDeleteBuffer	= 1
let NERDTreeNaturalSort			= 1
let NERDTreeChDirMode			= 2
let NERDTreeMouseMode			= 2
let NERDTreeShowHidden			= 1
let NERDTreeDirArrowExpandable	= "+"
let NERDTreeDirArrowCollapsible = "-"

command! -n=? -complete=dir -bar Tree :call g:NERDTreeCreator.ToggleTabTree('<args>') |
	\ :call lightline#update()

"FZF
nnoremap <silent> <C-P> :FZF<Return>
