"lightline

let g:lightline = {}

let g:lightline.colorscheme = 'molokai'

let g:lightline.separator = { 'left': "\ue0b8", 'right': "\ue0be" }
let g:lightline.subseparator = { 'left': "\ue0b9", 'right': "\ue0b9" }
let g:lightline.tabline_separator = { 'left': "\ue0bc", 'right': "\ue0ba" }
let g:lightline.tabline_subseparator = { 'left': "\ue0bb", 'right': "\ue0bb" }

let g:lightline.active = {
	\ 'left': [
	\	['mode', 'paste'],
	\	['filename']
	\ ],
	\ 'right': [
	\	['linecount'],
	\	['statusline'],
	\ ]
	\ }

let g:lightline.inactive = {
	\ 'left': [['inactivefilename']],
	\ 'right': []
	\ }

let g:lightline.component_function = {
	\ 'filename': 'LightlineFilename',
	\ 'inactivefilename': 'LightlineInactiveFilename',
	\ 'mode': 'LightlineMode',
	\ 'statusline': 'LightlineStatusline'
	\ }

let g:lightline.tabline = {
	\ 'left': [['vim_logo', 'tabs']],
	\ 'right': [['gitstatus']]
	\ }

let g:lightline.tab = {
	\ 'active': ['tabnum', 'filename'],
	\ 'inactive': ['tabnum', 'filename']
	\ }

let g:lightline.tab_component_function = {
	\ 'filename': 'LightlineTabname',
	\ 'tabnum': 'lightline#tab#tabnum'
	\ }

let g:lightline.component = {
	\ 'vim_logo': "\ue7c5",
	\ 'mode': '%{lightline#mode()}',
	\ 'statusline': 'Ln %l, Col %c',
	\ 'linecount': ' %L',
	\ 'gitstatus': '%{LightlineGitStatus()}',
	\ 'inactivefilename': '%t',
	\ 'absolutepath': '%F',
	\ 'relativepath': '%f',
	\ 'filename': '%t',
	\ 'modified': '%M',
	\ 'bufnum': '%n',
	\ 'paste': '%{&paste?"PASTE":""}',
	\ 'readonly': '%R',
	\ 'charvalue': '%b',
	\ 'charvaluehex': '%B',
	\ 'fileencoding': '%{&fenc!=#""?&fenc:&enc}',
	\ 'fileformat': '%{&ff}',
	\ 'filetype': '%{&ft!=#""?&ft:"no ft"}',
	\ 'percent': '%3p%%',
	\ 'percentwin': '%P',
	\ 'spell': '%{&spell?&spelllang:""}',
	\ 'lineinfo': '%3l:%-2c',
	\ 'line': '%l',
	\ 'column': '%c',
	\ 'close': '%999X X ',
	\ 'winnr': '%{winnr()}'
	\ }

"uses filetype detection to determine if current buffer is plugin
let g:PluginMap = {
	\ 'nerdtree': 'TREE',
	\ 'tagbar': 'tags',
	\ 'vim-plug': 'Plugins',
	\ 'qf': 'quickfix'
	\ }

func! IsFilePlugin()
	if !exists('b:IsPlugin')
		if has_key(g:PluginMap, &filetype)
			let b:IsPlugin = 1
			return 1
		endif

		let b:IsPlugin = 0
	endif

	return b:IsPlugin
endfunc

func! LightlineStatusline()
	if IsFilePlugin()
		return 'Ln ' . line('.')
	endif

	return 'Ln ' . line('.') . ', Col ' . col('.')
endfunc

func! LightlineFilename()
	if IsFilePlugin()
		return ''
	endif

	let l:filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
	let l:modified = &modified ? ' +' : ''
	return l:filename . l:modified
endfunc

func! LightlineInactiveFilename()
	if IsFilePlugin()
		return g:PluginMap[&filetype]
	endif

	let l:filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
	let l:modified = &modified ? ' +' : ''
	return l:filename . l:modified
endfunc

func! LightlineTabname(tabnum)
	let l:winnr = tabpagewinnr(a:tabnum)
	let l:filetype = gettabwinvar(a:tabnum, l:winnr, '&filetype')

	if has_key(g:PluginMap, l:filetype)
		return g:PluginMap[l:filetype]
	endif

	let l:buflist = tabpagebuflist(a:tabnum)
	let l:filename = expand('#'.l:buflist[l:winnr - 1].':t')

	if l:filename ==# ''
		let l:filename = '[No Name]'
	endif

	let l:modified = &modified ? ' +' : ''
	return l:filename . l:modified
endfunc

func! LightlineMode()
	let l:filename = expand('%')

	if IsFilePlugin()
		return g:PluginMap[&filetype]
	endif

	return winwidth(0) > 50 ? lightline#mode() : ''
endfunc

func! LightlineGitStatus()
	let l:head = gitbranch#name() !=# '' ? gitbranch#name() : 'none'
	return l:head . " \ue725"
endfunc
