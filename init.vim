call plug#begin(stdpath('data'))

Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/tagbar'
""Plug 'nvim-treesitter/nvim-treesitter'

call plug#end()

"Theme
let g:TransparentBackground = 1
colo nord

set number
set nowrap
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

set shada=""

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

nnoremap <Up> <cmd>bprev<cr>
nnoremap <Down> <cmd>bnext<cr>

"move lines up and down
inoremap <A-k> <Esc>ddkkp0i
inoremap <A-j> <Esc>ddp0i

nnoremap <silent> // <cmd>noh<Return>

nmap gh <Nop>
nnoremap gk K

tnoremap <Esc> <C-\><C-n>

augroup autocommands
	autocmd!
	autocmd FileType python nnoremap <buffer> <C-/> I#<Esc>0
	autocmd FileType c,cpp setlocal expandtab |
				\ nnoremap <buffer> <C-/> I//<Esc>0 |
	autocmd BufWritePre * %s/\s\+$//e
	autocmd WinNew * silent! NERDTreeMirror | silent! NERDTreeClose
	autocmd FileType nerdtree vnoremap <silent> <buffer> t :call tree#open_nodes('t', 1)<CR> |
				\ vnoremap <silent> <buffer> dd :call tree#delete_nodes(1)<CR> |
				\ vnoremap <silent> <buffer> m :call tree#move_nodes(1)<CR> |
				\ vnoremap <silent> <buffer> c :call tree#copy_nodes(1)<CR>
	autocmd TermOpen * setlocal nonumber
augroup end

lua << EOF
	require'lspconfig'.clangd.setup()
	require'treesitter'.setup()
	require'filetree'.Setup()
EOF

set completeopt=menuone,noinsert,noselect
set shortmess+=c

inoremap <silent> <Plug>(completion_trigger)
			\ <cmd>lua require'completion'.triggerCompletion()<cr>

imap <silent> <c-p> <Plug>(completion_trigger)
imap <silent> <c-n> <Plug>(completion_trigger)

"ripgrep
let &t_TI = ''
let &t_TE = ''

let &grepprg = 'rg --vimgrep'
let &grepformat = "%f:%l:%c:%m"

func! s:Rg(txt)
	silent! exe 'grep! ' . a:txt

	if len(getqflist())
		botright copen
		redraw!
	else
		cclose
		redraw!
		echo "No match found for " . a:txt
	endif
endfunc

command! -nargs=* -complete=file Rg :call s:Rg(<q-args>)

"tagbar
nnoremap <silent> ; <cmd>ShowTags<CR>
let g:tagbar_compact		= 2
let g:tagbar_foldlevel		= 2
let g:tagbar_sort			= 0

command! -nargs=0 ShowTags call tagbar#ToggleWindow()

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

""command! -n=? -complete=dir -bar Tree call g:NERDTreeCreator.ToggleTabTree('<args>')
command! -n=? -complete=dir -bar Tree lua require'filetree'.Toggle()

"disable garbage plugin
let g:loaded_netrw			= 1
let g:loaded_netrwPlugin	= 1

"FZF
nnoremap <silent> <C-P> <cmd>lua require'fzf'.run()<Return>
