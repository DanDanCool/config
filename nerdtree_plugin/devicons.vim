" taken from: https://github.com/ryanoasis/vim-devicons

" set scriptencoding after 'encoding' and when using multibyte chars
scriptencoding utf-8

" standard fix/safety: line continuation (avoiding side effects)
let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_devicons')
	finish
endif

let g:loaded_devicons = 1

" config enable / disable settings
let g:devicons_enable						= 1
let g:devicons_enable_nerdtree				= 1
let g:devicons_conceal_nerdtree_brackets	= 1

" config options
let g:DevIconsDecorateFileNodes						= 1
let g:DevIconsDecorateFolderNodes					= 1
let g:DevIconsEnableFolderOpenClose					= 1
let g:DevIconsGlyphPadding							= ' '

" config defaults
let g:DevIconsFileNodeDefaultSymbol			= ''
let g:DevIconsByteOrderMarkerDefaultSymbol	= ''
let g:DevIconsFolderNodeDefaultSymbol		= g:DevIconsEnableFolderOpenClose ? '' : ''
let g:DevIconsDefaultFolderOpenSymbol		= ''

let g:DevIconsFileNodeExtensionSymbols = {
	\ 'md'       : '',
	\ 'mdx'      : '',
	\ 'markdown' : '',
	\ 'rmd'      : '',
	\ 'json'     : '',
	\ 'py'       : '',
	\ 'pyc'      : '',
	\ 'pyo'      : '',
	\ 'pyd'      : '',
	\ 'conf'     : '',
	\ 'ini'      : '',
	\ 'yml'      : '',
	\ 'yaml'     : '',
	\ 'bat'      : '',
	\ 'jpg'      : '',
	\ 'jpeg'     : '',
	\ 'bmp'      : '',
	\ 'png'      : '',
	\ 'webp'     : '',
	\ 'gif'      : '',
	\ 'ico'      : '',
	\ 'cpp'      : '',
	\ 'c++'      : '',
	\ 'cxx'      : '',
	\ 'cc'       : '',
	\ 'cp'       : '',
	\ 'c'        : '',
	\ 'cs'       : '',
	\ 'h'        : '',
	\ 'hh'       : '',
	\ 'hpp'      : '',
	\ 'hxx'      : '',
	\ 'nix'      : '',
	\ 'lua'      : '',
	\ 'sh'       : '',
	\ 'ps1'      : '',
	\ 'sln'      : '',
	\ 'vim'      : ''
	\}

let g:DevIconsFileNodeExactSymbols = {
	\ '.gitconfig'                       : '',
	\ '.gitignore'                       : '',
	\ '.gitattributes'                   : '',
	\ 'license'                          : '',
	\ 'makefile'                         : '',
	\ 'cmakelists.txt'                   : ''
	\}

augroup devicons
	au!
	autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeFlags
	autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeFlags
	autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeLinkFile
	autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\]" contained conceal containedin=NERDTreeLinkDir
	autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeLinkFile
	autocmd FileType nerdtree syntax match hideBracketsInNerdTree "\[" contained conceal containedin=NERDTreeLinkDir
	autocmd FileType nerdtree setlocal conceallevel=3
	autocmd FileType nerdtree setlocal concealcursor=nvic
augroup END

function! DevIconsGetFileTypeSymbol(nodeName)
	let nodeExtension = fnamemodify(a:nodeName, ':e')
	let fileNode = fnamemodify(a:nodeName, ':t')

	let symbol = g:DevIconsFileNodeDefaultSymbol
	let nodeExtension = tolower(nodeExtension)
	let fileNode = tolower(fileNode)

	if has_key(g:DevIconsFileNodeExactSymbols, fileNode)
		let symbol = g:DevIconsFileNodeExactSymbols[fileNode]
	elseif has_key(g:DevIconsFileNodeExtensionSymbols, nodeExtension)
		let symbol = g:DevIconsFileNodeExtensionSymbols[nodeExtension]
	endif

	return symbol
endfunction

" nerdtree

function! NERDTreeDevIconsRefreshListener(event)
	let path = a:event.subject
	let flag = ''

	if !path.isDirectory
		let flag = g:DevIconsGlyphPadding . DevIconsGetFileTypeSymbol(path.str()) . g:DevIconsGlyphPadding
	else
		let directoryOpened = get(path, 'isOpen', 0)

		if directoryOpened
			let flag = g:DevIconsGlyphPadding . g:DevIconsDefaultFolderOpenSymbol . g:DevIconsGlyphPadding
		else
			let flag = g:DevIconsGlyphPadding . g:DevIconsFolderNodeDefaultSymbol . g:DevIconsGlyphPadding
		endif
	endif

	call path.flagSet.clearFlags('webdevicons')

	if flag !=? ''
		call path.flagSet.addFlag('webdevicons', flag)
	endif
endfunction

" standard fix/safety: line continuation (avoiding side effects)
let &cpo = s:save_cpo
unlet s:save_cpo

function! s:Refresh()
	call b:NERDTree.root.refreshFlags()
	call NERDTreeRender()
endfunction

function! DevIconsNERDTreeDirUpdateFlags(node, glyph)
	let flag = g:DevIconsGlyphPadding . a:glyph . g:DevIconsGlyphPadding

	call a:node.path.flagSet.clearFlags('webdevicons')

	if flag !=? ''
		call a:node.path.flagSet.addFlag('webdevicons', flag)
		call a:node.path.refreshFlags(b:NERDTree)
	endif
endfunction

function! DevIconsNERDTreeDirClose(node)
	let a:node.path.isOpen = 0
	let glyph = g:DevIconsFolderNodeDefaultSymbol
	call DevIconsNERDTreeDirUpdateFlags(a:node, glyph)
endfunction

function! DevIconsNERDTreeDirOpen(node)
	let a:node.path.isOpen = 1
	let glyph = g:DevIconsDefaultFolderOpenSymbol
	call DevIconsNERDTreeDirUpdateFlags(a:node, glyph)
endfunction

function! DevIconsNERDTreeDirCloseChildren(node)
	for i in a:node.children
		if i.path.isDirectory ==# 1
			call DevIconsNERDTreeDirClose(i)
		endif
	endfor
endfunction

" NERDTreeMapActivateNode and <2-LeftMouse>
" handle the user activating a tree node
function! DevIconsNERDTreeMapActivateNode(node)
	let isOpen = a:node.isOpen

	if isOpen
		let glyph = g:DevIconsFolderNodeDefaultSymbol
	else
		let glyph = g:DevIconsDefaultFolderOpenSymbol
	endif

	let a:node.path.isOpen = !isOpen
	call DevIconsNERDTreeDirUpdateFlags(a:node, glyph)

	" continue with normal activate logic
	call a:node.activate()
endfunction

function! DevIconsNERDTreeMapCloseChildren(node)
	" close children but not current node:
	call DevIconsNERDTreeDirCloseChildren(a:node)
	call a:node.closeChildren()
	call b:NERDTree.render()
	call a:node.putCursorHere(0, 0)
endfunction

function! DevIconsNERDTreeMapCloseDir(node)
	let parent = a:node.parent

	while g:NERDTreeCascadeOpenSingleChildDir && !parent.isRoot()
		let childNodes = parent.getVisibleChildren()

		if len(childNodes) == 1 && childNodes[0].path.isDirectory
			let parent = parent.parent
		else
			break
		endif
	endwhile

	if parent ==# {} || parent.isRoot()
		call nerdtree#echo('cannot close tree root')
	else
		call parent.close()

		" update the glyph
		call DevIconsNERDTreeDirClose(parent)
		call b:NERDTree.render()
		call parent.putCursorHere(0, 0)
	endif
endfunction

function! DevIconsNERDTreeMapUpdirKeepOpen()
	call DevIconsNERDTreeDirOpen(b:NERDTree.root)
	call nerdtree#ui_glue#upDir(1)
	call s:Refresh()
endfunction

call g:NERDTreePathNotifier.AddListener('init', 'NERDTreeDevIconsRefreshListener')
call g:NERDTreePathNotifier.AddListener('refresh', 'NERDTreeDevIconsRefreshListener')
call g:NERDTreePathNotifier.AddListener('refreshFlags', 'NERDTreeDevIconsRefreshListener')

" overrides needed as AddListener cannot be used for reliable updating of
" open/close glyphs. Event has no access to isOpen property

" NERDTreeMapActivateNode
call NERDTreeAddKeyMap({
	\ 'key': g:NERDTreeMapActivateNode,
	\ 'callback': 'DevIconsNERDTreeMapActivateNode',
	\ 'override': 1,
	\ 'scope': 'DirNode' })

" NERDTreeMapCustomOpen
call NERDTreeAddKeyMap({
	\ 'key': g:NERDTreeMapCustomOpen,
	\ 'callback': 'DevIconsNERDTreeMapActivateNode',
	\ 'override': 1,
	\ 'scope': 'DirNode' })

" NERDTreeMapCloseChildren
call NERDTreeAddKeyMap({
	\ 'key': g:NERDTreeMapCloseChildren,
	\ 'callback': 'DevIconsNERDTreeMapCloseChildren',
	\ 'override': 1,
	\ 'scope': 'DirNode' })

" NERDTreeMapCloseChildren
call NERDTreeAddKeyMap({
	\ 'key': g:NERDTreeMapCloseDir,
	\ 'callback': 'DevIconsNERDTreeMapCloseDir',
	\ 'override': 1,
	\ 'scope': 'Node' })

" <2-LeftMouse>
call NERDTreeAddKeyMap({
	\ 'key': '<2-LeftMouse>',
	\ 'callback': 'DevIconsNERDTreeMapActivateNode',
	\ 'override': 1,
	\ 'scope': 'DirNode' })

" NERDTreeMapUpdirKeepOpen
call NERDTreeAddKeyMap({
	\ 'key': g:NERDTreeMapUpdirKeepOpen,
	\ 'callback': 'DevIconsNERDTreeMapUpdirKeepOpen',
	\ 'override': 1,
	\ 'scope': 'all' })
