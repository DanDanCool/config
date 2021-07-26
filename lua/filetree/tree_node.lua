local Path = require'filetree/path'
local Config = require'filetree/config'

local TreeNode = {}

-- number of nodes
TreeNode.Count = 0

-- list of nodes in order of appearance on the tree
TreeNode.Nodes = {}

-- Return a new DirNode object with the given path and parent.
--
-- Args:
-- path: dir that the node represents
function TreeNode.CreateNode(pathInfo)
	local node = {}

	node.pathInfo	= pathInfo
	node.isOpen		= false
	node.children	= {}
	node.parent		= {}
	node.ln			= -1

	return node
end

-- Removes all childen from this node and re-reads them
-- Return: the number of child nodes read
function TreeNode.InitChildren(node)
	local files = vim.fn.readdir(node.pathInfo.path)

	node.children = {}

	-- chance that this may fail due to invalid file objects
	for _, path in ipairs(files) do
		path = node.pathInfo.path .. '/' .. path
		local pathInfo = Path.CreatePathInfo(path)
		local child = TreeNode.CreateNode(pathInfo)
		child.parent = node

		table.insert(node.children, child)
	end

	table.sort(node.children, compareNodes)
end

function TreeNode.ToggleOpenDir(node)
	if node.isOpen then
		node.isOpen = false
	else
		node.isOpen = true

		if #node.children == 0 then
			TreeNode.InitChildren(node)
		end
	end

	local cursorpos = vim.api.nvim_win_get_cursor(vim.t.FileTreeWin)
	FileTree.Render()
	vim.api.nvim_win_set_cursor(vim.t.FileTreeWin, cursorpos)
end

-- Open this directory node and any descendant directory nodes whose pathnames are not ignored.
function TreeNode.OpenRecursively(node)
	node.isOpen = true

	if #node.children == 0 then
		TreeNode.InitChildren(node)
	end

	for _, child in ipairs(node.children) do
		if child.pathInfo.isDirectory then
			TreeNode.OpenRecursively(child)
		end
	end
end

function TreeNode.Refresh(node)
	node.pathInfo = Path.CreatePathInfo(node.pathInfo.path)
	TreeNode.InitChildren(node)
end

-- Remove the given treenode from self.children.
-- Throws NERDTree.ChildNotFoundError if the node is not found.
--
-- Args:
-- treenode: the node object to remove
function TreeNode.Remove(parent, node)
	for i, child in ipairs(parent.children) do
		if child.pathInfo.path == node.pathInfo.path then
			parent.children[i] = nil
			return
		end
	end
end

-- Removes this node from the tree and calls the Delete method for its path obj
function TreeNode.Delete(node)
	Path.Delete(node.pathInfo)
	TreeNode.Remove(node.parent, node)
end

-- Calls the rename method for this nodes path obj
function TreeNode.Rename(node, name)
	Path.Rename(name)

	TreeNode.Refresh(FileTree.Root)
end

function TreeNode.Render(root)
	TreeNode.Count = 0
	TreeNode.Nodes = {}

	return TreeNode.RenderNodeTree(root, 0)
end

-- Assemble and return a string that can represent this Node object in the Tree window.
function TreeNode.RenderNode(node)
	local displayString = vim.fn.fnamemodify(node.pathInfo.path, ":t")

	local symbol = ' '

	if node.pathInfo.isDirectory then
		if node.isOpen then
			node.pathInfo.flags = ''
			symbol = ''
		else
			node.pathInfo.flags = ''
			symbol = ''
		end
	else
		node.pathInfo.flags = Config.ExtensionSymbols[displayString]
	end

	return symbol .. node.pathInfo.flags .. ' ' .. displayString
end

-- node should always be a directory
-- also sets the 'ln' field of the node
function TreeNode.RenderNodeTree(node, depth)
	local output = { string.rep('  ', depth) .. TreeNode.RenderNode(node)}

	table.insert(TreeNode.Nodes, node)
	TreeNode.Count = TreeNode.Count + 1
	node.ln	= TreeNode.Count
	node.depth = depth

	if node.pathInfo.isDirectory and node.isOpen then
		for _, child in ipairs(node.children) do
			if child.pathInfo.isDirectory then
				vim.list_extend(output, TreeNode.RenderNodeTree(child, depth + 1))
			else
				table.insert(output, string.rep('  ', depth + 1) .. TreeNode.RenderNode(child))
				table.insert(TreeNode.Nodes, child)

				TreeNode.Count = TreeNode.Count + 1
				child.ln = TreeNode.Count
				child.depth = depth + 1
			end
		end
	end

	return output
end

function TreeNode.HighlightTree()
	vim.api.nvim_buf_clear_namespace(FileTree.BufID, FileTree.HlID, 0, -1)

	for _, node in ipairs(TreeNode.Nodes) do
		if node.pathInfo.isDirectory then
			vim.api.nvim_buf_add_highlight(FileTree.BufID, FileTree.HlID, 'FileTreeDirIcon', node.ln - 1, node.depth * 2 + 2, node.depth * 2 + 4)
			vim.api.nvim_buf_add_highlight(FileTree.BufID, FileTree.HlID, 'FileTreeDir', node.ln - 1, node.depth * 2 + 4, node.depth * 2 + 6)
			vim.api.nvim_buf_add_highlight(FileTree.BufID, FileTree.HlID, 'FileTreeNodeDir', node.ln - 1, node.depth * 2 + 6, -1)
		else
			vim.api.nvim_buf_add_highlight(FileTree.BufID, FileTree.HlID, Config.ExtensionGroups[node.pathInfo.path], node.ln - 1, node.depth * 2 + 2, node.depth * 2 + 4)
		end
	end
end

-- returns a key used in compare function for sorting
local function getSortKey(pathInfo)
	local sortkey = { 0, 0, '' }

	local path = vim.fn.fnamemodify(pathInfo.path, ":t")
	path = string.lower(path)

	if pathInfo.isDirectory then
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

function compareNodes(n1, n2)
	local sortkey1 = getSortKey(n1.pathInfo)
	local sortkey2 = getSortKey(n2.pathInfo)

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

return TreeNode
