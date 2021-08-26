local api = vim.api
local ts = vim.treesitter

local highlight = {}

local hlmap = vim.treesitter.highlighter.hl_map

-- treesitter Highlight Group Mappings
-- Note: Some highlight groups may not be applied upstream, some may be experimental

hlmap["annotation"] = "TSAnnotation"

hlmap["attribute"] = "TSAttribute"

hlmap["boolean"] = "TSBoolean"

hlmap["character"] = "TSCharacter"

hlmap["comment"] = "TSComment"

hlmap["conditional"] = "TSConditional"

hlmap["constant"] = "TSConstant"
hlmap["constant.builtin"] = "TSConstBuiltin"
hlmap["constant.macro"] = "TSConstMacro"

hlmap["constructor"] = "TSConstructor"

hlmap["error"] = "TSError"
hlmap["exception"] = "TSException"

hlmap["field"] = "TSField"

hlmap["float"] = "TSFloat"

hlmap["function"] = "TSFunction"
hlmap["function.builtin"] = "TSFuncBuiltin"
hlmap["function.macro"] = "TSFuncMacro"

hlmap["include"] = "TSInclude"

hlmap["keyword"] = "TSKeyword"
hlmap["keyword.function"] = "TSKeywordFunction"
hlmap["keyword.operator"] = "TSKeywordOperator"

hlmap["label"] = "TSLabel"

hlmap["method"] = "TSMethod"

hlmap["namespace"] = "TSNamespace"

hlmap["none"] = "TSNone"
hlmap["number"] = "TSNumber"

hlmap["operator"] = "TSOperator"

hlmap["parameter"] = "TSParameter"
hlmap["parameter.reference"] = "TSParameterReference"

hlmap["property"] = "TSProperty"

hlmap["punctuation.delimiter"] = "TSPunctDelimiter"
hlmap["punctuation.bracket"] = "TSPunctBracket"
hlmap["punctuation.special"] = "TSPunctSpecial"

hlmap["repeat"] = "TSRepeat"

hlmap["string"] = "TSString"
hlmap["string.regex"] = "TSStringRegex"
hlmap["string.escape"] = "TSStringEscape"

hlmap["symbol"] = "TSSymbol"

hlmap["tag"] = "TSTag"
hlmap["tag.delimiter"] = "TSTagDelimiter"

hlmap["text"] = "TSText"
hlmap["text.strong"] = "TSStrong"
hlmap["text.emphasis"] = "TSEmphasis"
hlmap["text.underline"] = "TSUnderline"
hlmap["text.strike"] = "TSStrike"
hlmap["text.title"] = "TSTitle"
hlmap["text.literal"] = "TSLiteral"
hlmap["text.uri"] = "TSURI"
hlmap["text.math"] = "TSMath"
hlmap["text.reference"] = "TSTextReference"
hlmap["text.environment"] = "TSEnviroment"
hlmap["text.environment.name"] = "TSEnviromentName"

hlmap["text.note"] = "TSNote"
hlmap["text.warning"] = "TSWarning"
hlmap["text.danger"] = "TSDanger"

hlmap["type"] = "TSType"
hlmap["type.builtin"] = "TSTypeBuiltin"

hlmap["variable"] = "TSVariable"
hlmap["variable.builtin"] = "TSVariableBuiltin"

local langs = {
	c = true,
	cpp = true,
	lua = true
}

function highlight.attach()
	local buf = vim.api.nvim_get_current_buf()
	local lang = vim.api.nvim_buf_get_option(buf, 'ft')

	if not langs[lang] then
		return
	end

	local parser = ts.get_parser(buf, lang)
	local highlighter = ts.highlighter.new(parser, {})
	vim.api.nvim_command("syntax off")

	vim.api.nvim_buf_attach(buf, false, { on_detach = function()
		highlighter:destroy()
	end })
end

return highlight
