"statusline and tabline

let g:qf_disable_statusline = 1

let s:plugin_map = {
	\ 'nerdtree': 'TREE',
	\ 'tagbar': 'tags',
	\ 'vim-plug': 'Plugins',
	\ 'fzf': 'fzf',
	\ 'qf': 'quickfix',
	\ }

let s:mode_map =  {
	\ 'n': 'NORMAL', 'i': 'INSERT', 'R': 'REPLACE', 'v': 'VISUAL',
	\ 't': 'TERMINAL', 'V': 'V-LINE', "\<c-v>": 'V-BLOCK'
	\ }

let s:color_map = {
	\ 'n': 'STLNormal', 'i': 'STLInsert', 'R': 'STLReplace', 'v': 'STLVisual',
	\ 't': 'STLTerminal', 'V': 'STLVisual', "\<c-v>": 'STLVisual'
	\ }

func StatusHighlight(colors)
	for l:group in keys(a:colors)
		let l:highlightCmd = 'hi ' . l:group . ' '
		let l:colors = get(a:colors, l:group)

		if has_key(l:colors, 'guifg')
			let l:highlightCmd .= 'guifg=' . get(l:colors, "guifg") . ' '
			let l:highlightCmd .= 'ctermfg=' . get(l:colors, "fg", "white") . ' '
		endif

		if has_key(l:colors, 'guibg')
			let l:highlightCmd .= 'guibg=' . get(l:colors, "guibg") . ' '
			let l:highlightCmd .= 'ctermbg=' . get(l:colors, "bg", "white") . ' '
		endif

		if has_key(l:colors, 'gui')
			let l:highlightCmd .= 'gui=' . get(l:colors, "gui") . ' '
			let l:highlightCmd .= 'cterm=' . get(l:colors, "cterm", "NONE") . ' '
		endif

		execute l:highlightCmd
	endfor

	let l:inverse = {
				\ 'STLNormal': 'STLInvNormal',
				\ 'STLInsert': 'STLInvInsert',
				\ 'STLVisual': 'STLInvVisual',
				\ 'STLReplace': 'STLInvReplace',
				\ 'STLTerminal': 'STLInvTerminal'
				\ }

	for [l:group, l:inv] in items(l:inverse)
		let l:highlightCmd = 'hi ' . l:inv . ' '
		let l:colors = get(a:colors, l:group)

		if has_key(l:colors, 'guifg')
			let l:highlightCmd .= 'guibg=' . get(l:colors, "guifg") . ' '
			let l:highlightCmd .= 'ctermfg=' . get(l:colors, "fg", "white") . ' '
		endif

		if has_key(l:colors, 'guibg')
			let l:highlightCmd .= 'guifg=' . get(l:colors, "guibg") . ' '
			let l:highlightCmd .= 'ctermbg=' . get(l:colors, "bg", "white") . ' '
		endif

		execute l:highlightCmd
	endfor
endfunc

func! s:StatusLineMode()
	let l:mode = '%#' . get(s:color_map, mode(), 'STLNormal') . '# '
	let l:mode .= get(s:mode_map, mode(), 'NORMAL')
	let l:mode .= ' '
	return l:mode
endfunc

func! s:StatusLineFilename()
	let l:highlight = 'STLInv' . get(s:color_map, mode(), 'STLNormal')[3:]
	let l:filename = '%#' . l:highlight . '# %t '
	let l:modified = &modified ? '+' : ''

	return l:filename . l:modified
endfunc

func! s:StatusLineInfo()
	return '%#STLText#%#STLHighlight# Ln %l, Col %c %#STLText#  %L '
endfunc

func! StatusLine()
	let l:statusline = s:StatusLineMode() . s:StatusLineFilename()
	let l:statusline .= '%=' . s:StatusLineInfo()

	return l:statusline
endfunc

" I hate this
func! TagbarStatus(...)
	return '%#STLText# tags'
endfunc

func! s:TablineName(tabnr)
	let l:winnr = tabpagewinnr(a:tabnr)
	let l:buflist = tabpagebuflist(a:tabnr)
	let l:filename = expand('#'.l:buflist[l:winnr - 1].':t')
	let l:filetype = gettabwinvar(a:tabnr, l:winnr, '&filetype')

	if l:filename ==# ''
		let l:filename = '[No Name]'
	endif

	if has_key(s:plugin_map, l:filetype)
		let l:filename = s:plugin_map[l:filetype]
	endif

	let l:modified = gettabwinvar(a:tabnr, l:winnr, '&modified ') ? ' +' : ''
	return a:tabnr . ' ' . l:filename . l:modified
endfunc

func! Tabline()
	let l:tabline = '  '

	for i in range(1, tabpagenr('$'))
		let l:sep = ''

		if i == tabpagenr()
			let l:sep = ''
			let l:tabline .= '%#TabLineSel#'
			let l:tabline .= l:sep . ' ' . s:TablineName(i) . ' '
			let l:tabline .= '%#TabLine#' . l:sep
		else
			let l:sep = i - 1 == tabpagenr() ? '' : ''
			let l:tabline .= '%#TabLine#'
			let l:tabline .= l:sep . ' ' . s:TablineName(i) . ' '
		endif
	endfor

	let l:tabline .= '%#TabLineFill#'
	let l:tabline .= '%=%{gitbranch#name()}  '

	return l:tabline
endfunc

call StatusHighlight(g:statusline#colors.nord)

set statusline=%!StatusLine()
set tabline=%!Tabline()

let g:tagbar_status_func = 'TagbarStatus'

augroup statusline
	autocmd!
	autocmd ColorScheme * call StatusHighlight(g:statusline#colors[g:colors_name])
augroup end
