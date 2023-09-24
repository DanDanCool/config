local language = {}

local langs = {
	c = true,
	cpp = true,
	lua = true,
	python = true,
	java = false
}

function language.supported(lang)
	return langs[lang]
end

return language
