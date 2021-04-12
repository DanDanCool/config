let g:Pairs = {'(': ')', '[': ']', '{': '}', "'": "'", '"': '"', "<": ">"}

func PairsReturn()
	" col() starts at 1, so it needs to be offset by 1 in splicing
	let l:cursorpos = col(".")
	let l:line = getline(".")

	" get the character to the right of the cursor
	let l:pair = l:line[l:cursorpos - 2]

	if has_key(g:Pairs, l:pair)
		if l:line[l:cursorpos - 1] ==# g:Pairs[l:pair]
			if l:pair ==# '{'
				return "\<CR>\<BS>\<CR>\<UP>\<TAB>"
			endif

			return "\<CR>\<CR>\<UP>\<TAB>"
		endif
	endif

	return "\<CR>"
endfunc

func PairsSpace()
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

func PairsDelete()
	let l:cursorpos = col(".")
	let l:line = getline(".")
	let l:pair = l:line[l:cursorpos - 2]

	if has_key(g:Pairs, l:pair)
		if l:line[l:cursorpos - 1] ==# g:Pairs[l:pair]
			return "\<RIGHT>\<BS>\<BS>"
		endif
	endif

	return "\<BS>"
endfunc

func PairsInit()
	for [l:key, l:item] in items(g:Pairs)
		execute 'inoremap ' . l:key . ' ' . l:key . l:item . '<LEFT>'
	endfor

	inoremap <expr> <CR> PairsReturn()
	inoremap <expr> <SPACE> PairsSpace()
	inoremap <expr> <BS> PairsDelete()
	inoremap <expr> <C-H> PairsDelete()
endfunc

call PairsInit()
