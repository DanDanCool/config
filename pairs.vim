if exists('g:PairsLoaded')
	finish
endif

let g:PairsLoaded = 0

let g:Pairs = {'(': ')', '[': ']', '{': '}', "'": "'", '"': '"'}

func! PairsQuote()
	let l:cursorpos = col(".")
	let l:line = getline(".")

	if l:line[l:cursorpos - 2] =~# '\w'
		return "'"
	endif

	return "''\<LEFT>"
endfunc

func! PairsReturn()
	" col() starts at 1, so it needs to be offset by 1 in splicing
	let l:cursorpos = col(".")
	let l:line = getline(".")

	" get the character to the right of the cursor
	let l:pair = l:line[l:cursorpos - 2]

	if has_key(g:Pairs, l:pair)
		if l:line[l:cursorpos - 1] ==# g:Pairs[l:pair]
			let l:output = "\<CR>\<CR>\<UP>\<TAB>"
			let l:it = 0
			let l:indent = indent(line("."))

			while l:it < l:indent
				let l:output .= "\<TAB>"
				let l:it += shiftwidth()
			endwhile

			return l:output
		endif
	endif

	return "\<CR>"
endfunc

func! PairsSpace()
	let l:cursorpos = col(".")
	let l:line = getline(".")
	let l:pair = l:line[l:cursorpos - 2]

	if has_key(g:Pairs, l:pair)
		if l:line[l:cursorpos - 1] ==# g:Pairs[l:pair]
			return "\<SPACE>\<SPACE>\<LEFT>"
		endif
	endif

	return "\<SPACE>"
endfunc

func! PairsDelete()
	let l:cursorpos = col(".")
	let l:line = getline(".")
	let l:pair = l:line[l:cursorpos - 2]

	if has_key(g:Pairs, l:pair)
		if l:line[l:cursorpos - 1] ==# g:Pairs[l:pair]
			if l:pair ==# ' '
				return "\<RIGHT>\<BS>"
			endif

			return "\<RIGHT>\<BS>\<BS>"
		endif
	endif

	return "\<BS>"
endfunc

func! PairsInit()
	if g:PairsLoaded
		return
	endif

	for [l:key, l:item] in items(g:Pairs)
		execute 'inoremap ' . l:key . ' ' . l:key . l:item . '<LEFT>'
	endfor

	inoremap <expr> ' PairsQuote()

	let g:Pairs[' '] = ' '

	inoremap <expr> <CR> PairsReturn()
	inoremap <expr> <SPACE> PairsSpace()
	inoremap <expr> <BS> PairsDelete()
	inoremap <expr> <C-H> PairsDelete()

	let g:PairsLoaded = 1
endfunc

func! PairsToggle()
	if g:PairsLoaded
		for l:key in keys(g:Pairs)
			iunmap l:key
		endfor

		let g:PairsLoaded = 0
	else
		call PairsInit()
endfunc

call PairsInit()

command! -nargs=0 PairsToggle call PairsToggle()
