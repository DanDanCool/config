local types = require('tags.types')
local cache = require('tags.cache')

local ctags = {}

local tag_info = {}

-- most recent tag that is a 'scope'
tag_info.scope = nil

function ctags.new_tag()
	local tag = {}

	tag.name			= ''
	tag.type			= ''
	tag.parent			= nil
	tag.children		= {}
	tag.line			= -1
	tag.index			= -1

	return tag
end

function ctags.new_struct()
	local struct = {}

	struct.tags = {}

	struct.functions = ctags.new_tag()
	struct.functions.name = 'functions'
	struct.functions.line = 0

	return struct
end

function ctags.get_output()
	if not cache.current_updated() and cache.current.render then
		return cache.current.render
	end

	cache.current.list = {}
	cache.current.index = 1

	local output = {}

	for _, tag in ipairs(cache.current.tags) do
		vim.list_extend(output, ctags.render_tag(tag, 0))

		cache.current.index = cache.current.index + 1
		table.insert(output, '')
	end

	cache.current.render = output

	return output
end

function ctags.render_tag(tag, depth)
	tag.index = cache.current.index
	cache.current.list[cache.current.index] = tag
	cache.current.index = cache.current.index + 1

	local output = {}

	if cache.current.open[tag] then
		table.insert(output, '+ ' .. string.rep('  ', depth) .. tag.name)

		for _, child in ipairs(tag.children) do
			if #child.children ~= 0 then
				table.insert(output, ctags.render_tag(child, depth + 1))
			end

			child.index = cache.current.index
			cache.current.list[cache.current.index] = child
			cache.current.index = cache.current.index + 1

			table.insert(output, string.rep('  ', depth + 2) .. child.name)
		end
	else
		table.insert(output, '- ' .. string.rep('  ', depth) .. tag.name)
	end

	return output
end

function ctags.ParseOutput(output)
	local parsed_tags = ctags.new_struct()

	for _, line in ipairs(output) do
		ctags.ParseTagline(line, parsed_tags)
	end

	cache.current.tags = parsed_tags.tags
	table.insert(cache.current.tags, parsed_tags.functions)
	--print(vim.inspect(cache.current.tags))
	--vim.fn.writefile(tags.ctags_output, 'tags.out')
end

-- Structure of a tag line:
-- tagname<TAB>filename<TAB>expattern;"fields
-- fields: <TAB>name:value
-- fields that are always present: kind, line
function ctags.ParseTagline(line, parsed_tags)
	-- ignore comments
	if string.match(line, '!_TAG') then
		return
	end

	-- ignore invalid tags
	local parts = vim.split(line, ';"\t')
	if #parts ~= 2 then
		return
	end

	local typeinfo = types[cache.current.ftype]

	local contents = vim.split(parts[1], '\t')
	local fields = vim.split(parts[2], '\t')

	local tag = ctags.new_tag()
	tag.name = contents[1]
	tag.type = fields[1]

	local line = vim.split(fields[2], ':')
	tag.line = tonumber(line[2])

	if typeinfo.member[tag.type] then
		tag.parent = tag_info.scope
		table.insert(tag_info.scope.children, tag)
	end

	if tag.type == 't' and string.match(tag_info.scope.name, '__anon') then
		tag_info.scope.name = tag.name
		tag_info.scope.line = tag.line
	end

	if tag.type == 'f' then
		tag.parent = parsed_tags.functions
		table.insert(parsed_tags.functions.children, tag)
	end

	if typeinfo.scope[tag.type] then
		table.insert(parsed_tags.tags, tag)
		tag_info.scope = tag
	end
end

return ctags
