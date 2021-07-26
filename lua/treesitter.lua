local highlight = require'treesitter.highlight'

-- Registers all query predicates
require"treesitter.query_predicates"

local treesitter = {}

treesitter.parser_config = {
	cpp		= true,
	c		= true,
	lua		= true,
--	python	= true,
--	query	= true
	java	= true
}

local function setupHighlightGroups()
	vim.cmd('highlight default link TSNone Normal')
	vim.cmd('highlight default link TSPunctDelimiter Delimiter')
	vim.cmd('highlight default link TSPunctBracket Delimiter')
	vim.cmd('highlight default link TSPunctSpecial Delimiter')

	vim.cmd('highlight default link TSConstant Constant')
	vim.cmd('highlight default link TSConstBuiltin Special')
	vim.cmd('highlight default link TSConstMacro Define')
	vim.cmd('highlight default link TSString String')
	vim.cmd('highlight default link TSStringRegex String')
	vim.cmd('highlight default link TSStringEscape SpecialChar')
	vim.cmd('highlight default link TSCharacter Character')
	vim.cmd('highlight default link TSNumber Number')
	vim.cmd('highlight default link TSBoolean Boolean')
	vim.cmd('highlight default link TSFloat Float')

	vim.cmd('highlight default link TSFunction Function')
	vim.cmd('highlight default link TSFuncBuiltin Special')
	vim.cmd('highlight default link TSFuncMacro Macro')
	vim.cmd('highlight default link TSParameter Identifier')
	vim.cmd('highlight default link TSParameterReference TSParameter')
	vim.cmd('highlight default link TSMethod Function')
	vim.cmd('highlight default link TSField Identifier')
	vim.cmd('highlight default link TSProperty Identifier')
	vim.cmd('highlight default link TSConstructor Special')
	vim.cmd('highlight default link TSAnnotation PreProc')
	vim.cmd('highlight default link TSAttribute PreProc')
	vim.cmd('highlight default link TSNamespace Include')
	vim.cmd('highlight default link TSSymbol Identifier')

	vim.cmd('highlight default link TSConditional Conditional')
	vim.cmd('highlight default link TSRepeat Repeat')
	vim.cmd('highlight default link TSLabel Label')
	vim.cmd('highlight default link TSOperator Operator')
	vim.cmd('highlight default link TSKeyword Keyword')
	vim.cmd('highlight default link TSKeywordFunction Keyword')
	vim.cmd('highlight default link TSKeywordOperator TSOperator')
	vim.cmd('highlight default link TSException Exception')

	vim.cmd('highlight default link TSType Type')
	vim.cmd('highlight default link TSTypeBuiltin Type')
	vim.cmd('highlight default link TSInclude Include')

	vim.cmd('highlight default link TSVariableBuiltin Special')

	vim.cmd('highlight default link TSText TSNone')
	vim.cmd('highlight default TSStrong term=bold cterm=bold gui=bold')
	vim.cmd('highlight default TSEmphasis term=italic cterm=italic gui=italic')
	vim.cmd('highlight default TSUnderline term=underline cterm=underline gui=underline')
	vim.cmd('highlight default TSStrike term=strikethrough cterm=strikethrough gui=strikethrough')
	vim.cmd('highlight default link TSMath Special')
	vim.cmd('highlight default link TSTextReference Constant')
	vim.cmd('highlight default link TSEnviroment Macro')
	vim.cmd('highlight default link TSEnviromentName Type')
	vim.cmd('highlight default link TSTitle Title')
	vim.cmd('highlight default link TSLiteral String')
	vim.cmd('highlight default link TSURI Underlined')

	vim.cmd('highlight default link TSComment Comment')
	vim.cmd('highlight default link TSNote SpecialComment')
	vim.cmd('highlight default link TSWarning Todo')
	vim.cmd('highlight default link TSDanger WarningMsg')

	vim.cmd('highlight default link TSTag Label')
	vim.cmd('highlight default link TSTagDelimiter Delimiter')
end

function treesitter.setup()
	setupHighlightGroups()
	highlight.setup(treesitter.parser_config)
end

return treesitter
