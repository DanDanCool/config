function! tree#delete_nodes(confirmEach) range
	let l:response = 0
	let l:curLine = a:firstline

	while l:curLine <= a:lastline
		call cursor(l:curLine, 1)
		let l:node = g:NERDTreeFileNode.GetSelected()

		if a:confirmEach && (l:response < 3)
			let l:pathstr = fnamemodify(l:node.path.str({'format': 'Edit'}), ":t")
			let l:confirmationstr = "Delete " . l:pathstr . ", Are you sure? "
			let l:response = confirm(l:confirmationstr, "&Yes\n&No\n&All\n&Cancel", 4)
		endif

		if l:response == 1 || l:response == 3
			call l:node.delete()
		endif

		let l:curLine += 1
	endwhile

	let g:NERDTreeOldSortOrder = []
	call b:NERDTree.root.refresh()
	call NERDTreeRender()

	if g:NERDTreeQuitOnOpen
		NERDTreeClose
	endif
endfunction

function! tree#open_nodes(target, confirmEach) range
	let l:response = 0
	let l:curLine = a:firstline

	while l:curLine <= a:lastline
		call cursor(l:curLine, 1)
		let l:node = g:NERDTreeFileNode.GetSelected()

		if a:confirmEach && (l:response < 3)
			let l:pathstr = fnamemodify(l:node.path.str({'format': 'Edit'}), ":t")
			let l:confirmationstr = "Open " . l:pathstr . ", Are you sure? "
			let l:response = confirm(l:confirmationstr, "&Yes\n&No\n&All\n&Cancel", 4)
		endif

		if l:response == 1 || l:response == 3
			if !empty(l:node) && !l:node.path.isDirectory
				silent call l:node.open({'where':a:target,'stay':1,'keepopen':1})
			endif
		endif

		let l:curLine += 1
	endwhile

	let g:NERDTreeOldSortOrder = []
	call b:NERDTree.root.refresh()
	call NERDTreeRender()

	if g:NERDTreeQuitOnOpen
		NERDTreeClose
	endif
endfunction

func! tree#move_nodes(confirmEach) range
	let l:node = g:NERDTreeFileNode.GetSelected()
	let l:directory = l:node.path.str()

	if !node.path.isDirectory
		let l:directory = fnamemodify(l:directory, ':p:h')
	endif

	let l:directory = input('Destination directory: ', l:directory, 'dir')

	if l:directory == ''
		return 0
	endif

	let l:directory .= (l:directory =~# nerdtree#slash().'$' ? '' : nerdtree#slash())

	if !isdirectory(l:directory)
		call mkdir(l:directory, 'p')
	endif

	let l:response = 0
	let l:curLine = a:firstline

	while l:curLine <= a:lastline
		call cursor(l:curLine, 1)
		let l:node = g:NERDTreeFileNode.GetSelected()

		if a:confirmEach && (l:response < 3)
			let l:pathstr = fnamemodify(l:node.path.str({'format': 'Edit'}), ":t")
			let l:confirmationstr = "Move " . l:pathstr . ", Are you sure? "
			let l:response = confirm(l:confirmationstr, "&Yes\n&No\n&All\n&Cancel", 4)
		endif

		if !a:confirmEach || l:response == 1 || l:response == 3
			let l:destination = l:directory . fnamemodify(l:node.path.str(), ':t')
			call l:node.rename(l:destination)
		endif

		let l:curLine += 1
	endwhile

	let g:NERDTreeOldSortOrder = []
	call b:NERDTree.root.refresh()
	call NERDTreeRender()

	if g:NERDTreeQuitOnOpen
		NERDTreeClose
	endif
endfunc

func! tree#copy_nodes(confirmEach) range
	let l:node = g:NERDTreeFileNode.GetSelected()
	let l:directory = l:node.path.str()

	if !node.path.isDirectory
		let l:directory = fnamemodify(l:directory, ':p:h')
	endif

	let l:directory = input('Destination directory: ', l:directory, 'dir')

	if l:directory == ''
		return 0
	endif

	let l:directory .= (l:directory =~# nerdtree#slash().'$' ? '' : nerdtree#slash())

	if !isdirectory(l:directory)
		call mkdir(l:directory, 'p')
	endif

	let l:response = 0
	let l:curLine = a:firstline

	while l:curLine <= a:lastline
		if a:confirmEach && (l:response < 3)
			let l:response = confirm("Are you sure? ", "&Yes\n&No\n&All\n&Cancel")

			if l:response == 0  " Make Escape behave like Cancel
				let l:response = 4
				break
			endif
		endif

		if !a:confirmEach || l:response == 1 || l:response == 3
			call cursor(l:curLine, 1)
			let l:node = g:NERDTreeFileNode.GetSelected()
			let l:destination = l:directory . fnamemodify(l:node.path.str(), ':t')

			call l:node.copy(l:destination)
		endif

		let l:curLine += 1
	endwhile

	let g:NERDTreeOldSortOrder = []
	call b:NERDTree.root.refresh()
	call NERDTreeRender()

	if g:NERDTreeQuitOnOpen
		NERDTreeClose
	endif
endfunc
