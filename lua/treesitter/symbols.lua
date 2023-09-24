local language = require('treesitter.language')

local symbols = {}
symbols.nodes = {}
symbols.map = {}

local function create_node(type, tsnode)
	local start_row, start_col, end_row, end_col = tsnode:range()
	local text = vim.api.nvim_buf_get_text(treesitter.analyze.buf, start_row, start_col, end_row, end_col, {})

	node = {}
	node.name = text[1]
	node.type = type
	node.start_row = start_row
	node.start_col = start_col
	node.end_row = end_row
	node.end_col = end_col

	return node
end

function symbols.create_tree()
	symbols.nodes = {}
	symbols.map = {}

	local lang = vim.api.nvim_buf_get_option(treesitter.analyze.buf, 'ft')
	if not language.supported(lang) then
		return
	end

	local query = vim.treesitter.query.get(lang, 'symbols')
	if not query then
		return
	end

	local parser = vim.treesitter.get_parser(treesitter.analyze.buf, lang)
	local tree = parser:parse()[1]

	local seen = {}
	local nodes = {}
	for id, tsnode, metadata in query:iter_captures(tree:root(), treesitter.analyze.buf) do
		local type = query.captures[id]
		local start_row, start_col, end_row, end_col = tsnode:range()
		local key = start_row .. ' ' .. start_col ..  ' ' .. end_row .. ' ' .. end_col
		if seen[key] then
			nodes[seen[key]] = {type, tsnode}
		else
			table.insert(nodes, {type, tsnode})
			seen[key] = #nodes
		end
	end

	for _, info in ipairs(nodes) do
		table.insert(symbols.nodes, create_node(unpack(info)))
	end
end

function symbols.render()
	symbols.create_tree()

	local lines = { 'Symbols' }
	for _, node in ipairs(symbols.nodes) do
		local line = ''
		if node.type ~= 'method' then
			table.insert(lines, '')
		else
			line = line .. '  '
		end

		line = line .. node.type .. ': ' .. node.name
		table.insert(lines, line)
		symbols.map[#lines] = node
	end

	return lines
end

return symbols
