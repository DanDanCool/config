if exists('g:loaded_treesitter')
  finish
endif

let g:loaded_treesitter = 1

let g:parser_config = {
	\ 'cpp'		: { 'enable': 1, 'name': 'cpp' },
	\ 'c'		: { 'enable': 1, 'name': 'c' },
	\ 'lua'		: { 'enable': 1, 'name': 'lua' },
	\ 'python'	: { 'enable': 1, 'name': 'python' },
	\ 'query'	: { 'enable': 1, 'name': 'query' }
	\ }

lua require'treesitter'.setup()

highlight default link TSNone Normal
highlight default link TSPunctDelimiter Delimiter
highlight default link TSPunctBracket Delimiter
highlight default link TSPunctSpecial Delimiter

highlight default link TSConstant Constant
highlight default link TSConstBuiltin Special
highlight default link TSConstMacro Define
highlight default link TSString String
highlight default link TSStringRegex String
highlight default link TSStringEscape SpecialChar
highlight default link TSCharacter Character
highlight default link TSNumber Number
highlight default link TSBoolean Boolean
highlight default link TSFloat Float

highlight default link TSFunction Function
highlight default link TSFuncBuiltin Special
highlight default link TSFuncMacro Macro
highlight default link TSParameter Identifier
highlight default link TSParameterReference TSParameter
highlight default link TSMethod Function
highlight default link TSField Identifier
highlight default link TSProperty Identifier
highlight default link TSConstructor Special
highlight default link TSAnnotation PreProc
highlight default link TSAttribute PreProc
highlight default link TSNamespace Include
highlight default link TSSymbol Identifier

highlight default link TSConditional Conditional
highlight default link TSRepeat Repeat
highlight default link TSLabel Label
highlight default link TSOperator Operator
highlight default link TSKeyword Keyword
highlight default link TSKeywordFunction Keyword
highlight default link TSKeywordOperator TSOperator
highlight default link TSException Exception

highlight default link TSType Type
highlight default link TSTypeBuiltin Type
highlight default link TSInclude Include

highlight default link TSVariableBuiltin Special

highlight default link TSText TSNone
highlight default TSStrong term=bold cterm=bold gui=bold
highlight default TSEmphasis term=italic cterm=italic gui=italic
highlight default TSUnderline term=underline cterm=underline gui=underline
highlight default TSStrike term=strikethrough cterm=strikethrough gui=strikethrough
highlight default link TSMath Special
highlight default link TSTextReference Constant
highlight default link TSEnviroment Macro
highlight default link TSEnviromentName Type
highlight default link TSTitle Title
highlight default link TSLiteral String
highlight default link TSURI Underlined

highlight default link TSComment Comment
highlight default link TSNote SpecialComment
highlight default link TSWarning Todo
highlight default link TSDanger WarningMsg

highlight default link TSTag Label
highlight default link TSTagDelimiter Delimiter
