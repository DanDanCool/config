FileTree.Config = {}
local Config = FileTree.Config

Config.ExtensionSymbols = {
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
	h        = '',
	hpp      = '',
	lua      = '',
	sh       = '',
	sln      = '',
	vim      = ''
}

function Config.ExtensionSymbols.__index(table, key)
	local value = Config.ExactSymbols[key]
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

Config.ExactSymbols = {
	gitconfig		= '',
	gitignore		= '',
	gitattributes	= '',
	license			= '',
	makefile		= '',
	cmakeliststxt	= ''
}

function Config.ExactSymbols.__index(table, key)
	key = string.lower(key)
	key = string.gsub(key, '%.', '')
	return rawget(table, key)
end

-- taken from https://github.com/tiagofumo/vim-nerdtree-syntax-highlight
Config.ExtensionColors = {
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
	h		= "1682af",
	hpp		= "1682af",
	lua		= "7e2793",
	sh		= "71909e",
	sln		= "7e2793",
	vim		= "63aa53",
	misc	= "9b9b9b"
}

Config.ExactColors = {
	gitconfig		= '71909e',
	gitignore		= '71909e',
	gitattributes	= '71909e',
	license			= 'f09f17',
	makefile		= '71909e',
	cmakeliststxt	= '71909e'
}

Config.ExtensionGroups = {}

function Config.ExtensionGroups.__index(table, key)
	local exact = string.lower(key)
	exact = string.gsub(exact, '%.', '')

	if Config.ExactColors[exact] ~= nil then
		return 'FileTreeExtension_' .. exact
	end

	key = vim.fn.fnamemodify(key, ':e')
	if Config.ExtensionColors[key] == nil then
		return 'FileTreeExtension_misc'
	end

	return 'FileTreeExtension_' .. key
end

Config.ExtensionSymbols = setmetatable(Config.ExtensionSymbols, Config.ExtensionSymbols)
Config.ExactSymbols = setmetatable(Config.ExactSymbols, Config.ExactSymbols)
Config.ExtensionGroups = setmetatable({}, Config.ExtensionGroups)

return Config
