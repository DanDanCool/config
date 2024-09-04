local path = require'filetree/path'

local tree_node = {}

-- number of nodes
tree_node.count = 0

-- list of nodes in order of appearance on the tree
tree_node.nodes = {}

-- Return a new DirNode object with the given path and parent.
--
-- Args:
-- path: dir that the node represents
function tree_node.create_node(path_info)
	local node = {}

	node.path_info	= path_info
	node.open		= false
	node.children	= {}
	node.parent		= {}
	node.ln			= -1

	return node
end

-- Removes all childen from this node and re-reads them
-- Return: the number of child nodes read
function tree_node.init_children(node)
	local files = vim.fn.readdir(node.path_info.path)

	node.children = {}

	-- chance that this may fail due to invalid file objects
	for _, name in ipairs(files) do
		name = node.path_info.path .. '/' .. name
		local path_info = path.path_info(name)
		local child = tree_node.create_node(path_info)
		child.parent = node

		table.insert(node.children, child)
	end

	table.sort(node.children, compare_nodes)
end

function tree_node.toggle_open_dir(node)
	if node.open then
		node.open = false
	else
		node.open = true

		if #node.children == 0 then
			tree_node.init_children(node)
		end
	end

	local cursorpos = vim.api.nvim_win_get_cursor(filetree.winid)
	filetree.render()
	vim.api.nvim_win_set_cursor(filetree.winid, cursorpos)
end

-- Open this directory node and any descendant directory nodes whose pathnames are not ignored.
function tree_node.open_recursively(node)
	node.open = true

	if #node.children == 0 then
		tree_node.init_children(node)
	end

	for _, child in ipairs(node.children) do
		if child.path_info.directory then
			tree_node.open_recursively(child)
		end
	end
end

function tree_node.refresh(node)
	node.path_info = path.path_info(node.path_info.path)
	tree_node.init_children(node)
end

-- Remove the given tree_node from self.children.
-- Throws NERDTree.ChildNotFoundError if the node is not found.
--
-- Args:
-- tree_node: the node object to remove
function tree_node.remove(parent, node)
	for i, child in ipairs(parent.children) do
		if child.path_info.path == node.path_info.path then
			parent.children[i] = nil
			return
		end
	end
end

-- Removes this node from the tree and calls the Delete method for its path obj
function tree_node.delete(node)
	path.delete(node.pathInfo)
	tree_node.remove(node.parent, node)
end

-- Calls the rename method for this nodes path obj
function tree_node.rename(node, name)
	path.rename(name)
	tree_node.refresh(filetree.root)
end

function tree_node.render(root)
	tree_node.count = 0
	tree_node.nodes = {}

	return tree_node.render_node_tree(root, 0)
end

-- Assemble and return a string that can represent this Node object in the Tree window.
function tree_node.render_node(node)
	local display = vim.fn.fnamemodify(node.path_info.path, ":t")

	local symbol = ' '

	if node.path_info.directory then
		if node.open then
			node.path_info.flags = ''
			symbol = ''
		else
			node.path_info.flags = ''
			symbol = ''
		end
	else
		node.path_info.flags = filetree.config.extension_symbols[display]
	end

	return symbol .. node.path_info.flags .. ' ' .. display
end

-- node should always be a directory
-- also sets the 'ln' field of the node
function tree_node.render_node_tree(node, depth)
	local output = { string.rep('  ', depth) .. tree_node.render_node(node) }

	table.insert(tree_node.nodes, node)
	tree_node.count = tree_node.count + 1
	node.ln	= tree_node.count
	node.depth = depth

	if node.path_info.directory and node.open then
		for _, child in ipairs(node.children) do
			if child.path_info.directory then
				vim.list_extend(output, tree_node.render_node_tree(child, depth + 1))
			else
				table.insert(output, string.rep('  ', depth + 1) .. tree_node.render_node(child))
				table.insert(tree_node.nodes, child)

				tree_node.count = tree_node.count + 1
				child.ln = tree_node.count
				child.depth = depth + 1
			end
		end
	end

	return output
end

function tree_node.highlight_tree()
	vim.api.nvim_buf_clear_namespace(filetree.bufid, filetree.hlid, 0, -1)

	for _, node in ipairs(tree_node.nodes) do
		if node.path_info.directory then
			vim.api.nvim_buf_add_highlight(filetree.bufid, filetree.hlid, 'FileTreeDirIcon', node.ln - 1, node.depth * 2 + 2, node.depth * 2 + 4)
			vim.api.nvim_buf_add_highlight(filetree.bufid, filetree.hlid, 'FileTreeDir', node.ln - 1, node.depth * 2 + 4, node.depth * 2 + 6)
			vim.api.nvim_buf_add_highlight(filetree.bufid, filetree.hlid, 'FileTreeNodeDir', node.ln - 1, node.depth * 2 + 6, -1)
		else
			vim.api.nvim_buf_add_highlight(filetree.bufid, filetree.hlid, filetree.config.extension_groups[node.path_info.path], node.ln - 1, node.depth * 2, node.depth * 2 + 4)
		end
	end
end

-- returns a key used in compare function for sorting
local function get_sort_key(path_info)
	local sortkey = { 0, 0, '' }

	local path = vim.fn.fnamemodify(path_info.path, ":t")
	path = string.lower(path)

	if path_info.directory then
		sortkey[1] = 1
	else
		sortkey[1] = 0
	end

	local sortorder = {'^%.', '.+'}

	for i, regex in ipairs(sortorder) do
		if string.match(path, regex) ~= nil then
			sortkey[2] = i
			break
		end
	end

	sortkey[3] = path

	return sortkey
end

function compare_nodes(n1, n2)
	local sortkey1 = get_sort_key(n1.path_info)
	local sortkey2 = get_sort_key(n2.path_info)

	-- Compare chunks upto common length.
	-- If chunks have different type, the one which has
	-- integer type is the lesser.
	for i = 1, #sortkey1 do
		if type(sortkey1[i]) == 'number' then
			if sortkey1[i] > sortkey2[i] then
				return true
			elseif sortkey1[i] < sortkey2[i] then
				return false
			end
		else
			if sortkey1[i] < sortkey2[i] then
				return true
			elseif sortkey1[i] > sortkey2[i] then
				return false
			end
		end
	end

	return false
end

return tree_node
