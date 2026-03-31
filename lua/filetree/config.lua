local config = {}

config.extension_symbols = {
	md       = '',
	json     = '',
	py       = '',
	conf     = '',
	ini      = '',
	yaml     = '',
	bat      = '',
	png      = '',
	c        = '',
	cpp      = '',
	mpp      = '',
	h        = '',
	hpp      = '',
	lua      = '',
	sh       = '',
	sln      = '',
	vim      = ''
}

function config.extension_symbols.__index(table, key)
	local value = config.exact_symbols[key]
	if value ~= nil then
		return value
	end

	key = vim.fn.fnamemodify(key, ":e")
	value = rawget(table, key)

	if value == nil then
		return ''
	end

	return value
end

config.exact_symbols = {
	gitconfig		= '',
	gitignore		= '',
	gitattributes	= '',
	license			= '',
	makefile		= '',
	cmakeliststxt	= ''
}

function config.exact_symbols.__index(table, key)
	key = string.lower(key)
	key = string.gsub(key, '%.', '')
	return rawget(table, key)
end

-- taken from https://github.com/tiagofumo/vim-nerdtree-syntax-highlight
config.extension_colors = {
	md		= "f09f17",
	json	= "71909e",
	py		= "f09f17",
	conf	= "71909e",
	ini		= "71909e",
	yaml	= "71909e",
	bat		= "71909e",
	png		= "31496d",
	c		= "1682af",
	cpp		= "1682af",
	mpp		= "1682af",
	h		= "1682af",
	hpp		= "1682af",
	lua		= "7e2793",
	sh		= "71909e",
	sln		= "7e2793",
	vim		= "63aa53",
	misc	= "9b9b9b"
}

config.exact_colors = {
	gitconfig		= '71909e',
	gitignore		= '71909e',
	gitattributes	= '71909e',
	license			= 'f09f17',
	makefile		= '71909e',
	cmakeliststxt	= '71909e'
}

config.extension_groups = {}

function config.extension_groups.__index(table, key)
	local exact = string.lower(key)
	exact = string.gsub(exact, '%.', '')

	if config.exact_colors[exact] ~= nil then
		return 'FileTreeExtension_' .. exact
	end

	key = vim.fn.fnamemodify(key, ':e')
	if config.extension_colors[key] == nil then
		return 'FileTreeExtension_misc'
	end

	return 'FileTreeExtension_' .. key
end

config.extension_symbols = setmetatable(config.extension_symbols, config.extension_symbols)
config.exact_symbols = setmetatable(config.exact_symbols, config.exact_symbols)
config.extension_groups = setmetatable(config.extension_groups, config.extension_groups)

return config
