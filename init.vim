call plug#begin(stdpath('data'))

Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
"TODO: write a better plugin for this
"NOTE: probably reconsider this
Plug 'jremmen/vim-ripgrep'
Plug 'preservim/nerdtree'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'

if !has("nvim-0.5")
	Plug 'neoclide/coc.nvim', { 'branch': 'release' }
	Plug 'jackguo380/vim-lsp-cxx-highlight'
endif

"Pretty"
"Plug 'vim-airline/vim-airline'
"TODO: delete this
"Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'DanDanCool/JollyTheme'

"Syntax"
Plug 'tikhomirov/vim-glsl'

"TODO: move this out when 0.5 becomes stable
if has("nvim-0.5")
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'jiangmiao/auto-pairs'
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

let mapleader = "-"

syntax keyword Note NOTE IMPORTANT
highlight link Note Todo

"Split navigation"
nnoremap <S-H> <C-W><C-H>
nnoremap <S-J> <C-W><C-J>
nnoremap <S-K> <C-W><C-K>
nnoremap <S-L> <C-W><C-L>

nnoremap gk K

inoremap <S-Del> <Esc>dda
inoremap <C-Del> <Esc>dei

inoremap <C-S> <Esc>:w<Return>a

inoremap <A-k> <Esc>ddkkp0i
inoremap <A-j> <Esc>ddp0i

nnoremap <A-k> ddkkp
nnoremap <A-j> ddp

inoremap <C-E> <s-right>
inoremap <C-B> <s-left>
inoremap <C-A> <Esc><S-A>

"undo and redo"
inoremap <C-Z> <Esc>ui
inoremap <C-Y> <Esc><C-R>i

nnoremap <leader>vimrc :vsplit $MYVIMRC<Return>
nnoremap <leader>rvimrc :so $MYVIMRC<Return>
nnoremap <C-/> 0i//<Esc>0
nnoremap // :noh<Return>

augroup autocommands
	autocmd!
	autocmd FileType python :noremap <C-/> 0i#<Esc>0
	autocmd FileType c,cpp setlocal expandtab
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePost * call tagbar#ForceUpdate() | call lightline#update()
	autocmd WinNew * silent NERDTreeMirror | silent NERDTreeClose
augroup END

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

"tagbar
nnoremap ; :UserTagbarToggle<CR>
let g:tagbar_compact = 2
let g:tagbar_foldlevel = 2
let g:tagbar_autofocus = 1
let g:tagbar_no_autocmds = 1

command! -nargs=0 UserTagbarToggle call tagbar#ToggleWindow() | call lightline#update()

"JollyTheme
let g:JollyTransparentBackground = 1

"airline"
so $HOME/appdata/local/nvim/airlineinit.vim

"lightline
so $HOME/appdata/local/nvim/lightlineinit.vim

"NerdTree"
nnoremap <C-N> :UserNERDTreeToggle<Return>
let NERDTreeMinimalUI			= 1
let NERDTreeAutoDeleteBuffer	= 1
let NERDTreeNaturalSort			= 1
let NERDTreeChDirMode			= 2
let NERDTreeMouseMode			= 2
let NERDTreeDirArrowExpandable	= "+"
let NERDTreeDirArrowCollapsible = "-"

command! -n=? -complete=dir -bar UserNERDTreeToggle :call g:NERDTreeCreator.ToggleTabTree('<args>') |
	\ :call lightline#update()

"FZF"
nnoremap <C-P> :FZF<Return>

"Coc"
if !has("nvim-0.5")
	so $HOME/appdata/local/nvim/cocinit.vim
endif
