inoremap <C-H> <Left>
inoremap <C-L> <Right>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
cnoremap <S-BS> <C-W>
inoremap <S-BS> <C-W>

inoremap <C-Return> <Esc><S-O>
inoremap <S-Return> <Esc>o

inoremap <c-space> <C-N>
inoremap <c-s-space> <C-P>

let g:JollyTransparentBackground = 0
colo jolly

if exists('g:GuiLoaded')
	GuiTabline 0
	GuiPopupmenu 0
	GuiFont! Hack NF:h12
endif
