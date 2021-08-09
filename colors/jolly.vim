"Super eye searing theme

set background=dark
highlight clear

if exists("syntax_on")
	syntax reset
endif

let g:colors_name = "jolly"

let s:JollyColors = {}

if get(g:, "TransparentBackground", 0) > 0
	let s:JollyColors.Normal	= {"fg": "white", "guifg": "#dcdcdc"}
	let s:JollyColors.VertSplit = {"cterm": "NONE", "fg": "38", "bg": "NONE",
				\	"gui": "NONE", "guifg": "#232526", "guibg": "NONE"}
else
	let s:JollyColors.Normal	= {"fg": "white", "bg": "black", "guifg": "#dcdcdc", "guibg": "#1B141B"}
	let s:JollyColors.VertSplit = {"fg": "38", "bg": "38", "guifg": "#1B141B", "guibg": "#FFFFFF"}
endif

"syntax"
let s:JollyColors.Comment		= {"fg":  "71", "guifg": "#4EB13E"}

let s:JollyColors.Constant		= {"fg": "white", "guifg": "#9039c6"}
let s:JollyColors.String		= {"fg": "197", "guifg": "#ff4056"}
let s:JollyColors.Character		= {"fg": "197", "guifg": "#ff4056"}
let s:JollyColors.Number		= {"fg": "197", "guifg": "#ff4056"}
let s:JollyColors.Boolean		= {"fg": "white", "guifg": "#9039c6"}
let s:JollyColors.Float			= {"fg": "197", "guifg": "#ff4056"}

let s:JollyColors.Identifier	= {"fg": "153", "guifg": "#b4e4fe"}
let s:JollyColors.Function		= {"fg":  "62", "guifg": "#5d5dd8"}

let s:JollyColors.Statement		= {"fg": "98", "guifg": "#9039c6"}
let s:JollyColors.Conditional	= {"fg": "98", "guifg": "#9039c6"}
let s:JollyColors.Repeat		= {"fg": "98", "guifg": "#9039c6"}
let s:JollyColors.Label			= {"fg": "98", "guifg": "#9039c6"}
let s:JollyColors.Operator		= {"fg": "white", "guifg": "#5E81AC"}
let s:JollyColors.Exception		= {"fg": "98", "guifg": "#9039c6"}
let s:JollyColors.Delimiter		= {"fg": "white", "guifg": "#DCDCDC"}

let s:JollyColors.PreProc		= {"fg":  "92", "guifg": "#9039c6"}
let s:JollyColors.Include		= {"fg": "245", "guifg": "#9b9b9b"}

let s:JollyColors.Type			= {"fg": "98", "guifg": "#9039c6"}
let s:JollyColors.Structure		= {"fg": "98", "guifg": "#9039c6"}

let s:JollyColors.Todo			= {"fg": "white", "bg": "28", "guifg": "#1B141B", "guibg": "#4EB13E"}
let s:JollyColors.Special		= {"fg": "98", "guifg": "#EBCB8B"}

"Misc"
let s:JollyColors.Folded		= {"fg": "white", "bg": "54", "guifg": "#dcdcdc", "guibg": "#594359"}
let s:JollyColors.Visual		= {"bg": "242", "guibg": "#594359"}
let s:JollyColors.Search		= {"fg": "black", "bg": "198", "guifg": "#1B141B", "guibg": "#F92672"}
let s:JollyColors.LineNr		= {"fg":  "38", "guifg": "#0089b7"}
let s:JollyColors.Pmenu			= {"fg": "white", "bg": "92", "guifg": "#dcdcdc", "guibg": "#231a23"}
let s:JollyColors.PmenuSel		= {"fg": "white", "bg": "62", "guifg": "#dcdcdc", "guibg": "#594359"}

"colors based off of lightline molokai theme"
let s:JollyColors.StatusLine	= {"fg": "233", "guifg": "#232526", "guibg": "#232526"}
let s:JollyColors.StatusLineNC	= {"fg": "233", "guifg": "#232526", "guibg": "#232526"}
let s:JollyColors.EndOfBuffer	= {"fg":  "38", "guifg": "#232526"}

let s:JollyColors.FileTreeDir		= {"fg": "white", "guifg": "#71468c"}
let s:JollyColors.FileTreeDirIcon	= {"fg": "white", "guifg": "#8FBCBB"}
let s:JollyColors.FileTreeNodeDir	= {"fg": "white", "guifg": "#5E81AC"}

"treesitter"
let s:JollyColors.TSNamespace	= {"fg": "white", "guifg": "#EBCB8B"}
let s:JollyColors.TSType		= {"fg": "white", "guifg": "#F92672"}
let s:JollyColors.TSText		= {"fg": "white", "guifg": "#dcdcdc"}

func s:HighlightFn(group)
	let l:colors = get(s:JollyColors, a:group)

	let l:highlightCmd = 'hi ' . a:group . ' '

	if has_key(l:colors, "fg")
		let l:highlightCmd .= 'guifg=' . get(l:colors, "guifg") . ' '
		let l:highlightCmd .= 'ctermfg=' . get(l:colors, "fg") . ' '
	endif

	if has_key(l:colors, "bg")
		let l:highlightCmd .= 'guibg=' . get(l:colors, "guibg") . ' '
		let l:highlightCmd .= 'ctermbg=' . get(l:colors, "bg") . ' '
	endif

	if has_key(l:colors, "cterm")
		let l:highlightCmd .= 'gui=' . get(l:colors, "gui") . ' '
		let l:highlightCmd .= 'cterm=' . get(l:colors, "cterm") . ' '
	endif

	if has_key(l:colors, "guisp")
		let l:highlightCmd .= 'guisp=' . get(l:colors, "guisp") . ' '
	endif

	execute l:highlightCmd
endfunc

for k in keys(s:JollyColors)
	call s:HighlightFn(k)
endfor

unlet s:JollyColors
