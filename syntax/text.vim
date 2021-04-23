if exists("b:SyntaxLoaded")
	finish
endif

syntax keyword TextTodo TODO NOTE IMPORTANT

syntax keyword TextMonth January February March April May June
syntax keyword TextMonth July August September November December

syntax keyword TextAssignment ASSIGNMENT

"matches one or more digits if there are no alphabet characters ahead of it
syntax match TextNumber "\v([a-zA-Z])@<!\d+"

"same as above except includes a single '.' for decimals
syntax match TextNumber "\v([a-zA-Z])@<!\d+\.\d+"

"matches a line that starts with '-'
syntax match TextPoint "\v\_^\w@!\s*-.+" contains=ALL

"matches a line that starts with any amount of whitespace character
syntax match TextPoint "\v\_^\s+.+" contains=ALL

"matches 3 or more capitalized characters
syntax match TextImportant "\v[A-Z]{3,}"

syntax region TextSpecial matchgroup=Special start="\v\*" end="\v\*" oneline concealends
syntax region TextUnderline matchgroup=Underlined start="\v_" end="\v_" oneline concealends
syntax region TextQuote start="\v\"" end="\v\""

highlight link TextTodo Todo
highlight link TextAssignment Function
highlight link TextMonth Constant
highlight link TextNumber Number
highlight link TextPoint Identifier
highlight link TextImportant Keyword
highlight link TextSpecial Special
highlight link TextUnderline Underlined
highlight link TextQuote Comment
highlight link TextSingleQuote Comment

let b:SyntaxLoaded = 1
