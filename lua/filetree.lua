FileTree	= {}

-- root of the tree, set in FileTreeInit
FileTree.Root	= {}

local KeyMap	= require'filetree/key_map'
local TreeNode	= require'filetree/tree_node'
local Path		= require'filetree/path'
local Config	= require'filetree/config'

FileTree.WinSize = 30

FileTree.BufID = nil
FileTree.WinID = nil
FileTree.HlID = nil

FileTree.Cursor = { 1, 1 }

function FileTree.Render()
	vim.api.nvim_buf_set_option(FileTree.BufID, 'modifiable', true)
	vim.api.nvim_buf_set_lines(FileTree.BufID, 0, -1, false, TreeNode.Render(FileTree.Root))
	TreeNode.HighlightTree()
	vim.api.nvim_buf_set_option(FileTree.BufID, 'modifiable', false)
end

function FileTree.CreateWindow()
	local opts = {
		relative	= 'editor',
		style		= 'minimal',
		border		= 'single'
	}

	opts.col = math.ceil(vim.o.columns / 4)
	opts.row = math.ceil(vim.o.lines / 8) - 2
	opts.width = vim.o.columns - opts.col * 2
	opts.height = vim.o.lines - opts.row * 2 - 6

	FileTree.BufID = vim.api.nvim_create_buf(false, true)
	FileTree.WinID = vim.api.nvim_open_win(FileTree.BufID, true, opts)

	vim.wo.winfixwidth = true

    -- Options for a non-file/control buffer.
	vim.bo.bufhidden = 'hide'
	vim.bo.buftype = 'nofile'
	vim.bo.swapfile = false
	vim.bo.filetype = 'filetree'
	vim.bo.modifiable = false
	vim.bo.buflisted = false

    -- Options for controlling buffer/window appearance.
	vim.wo.foldcolumn = '0'
	vim.wo.foldmethod = 'manual'
	vim.wo.foldenable = true
	vim.wo.list = false
	vim.wo.spell = false
	vim.wo.wrap = false
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.cursorline = true
	vim.wo.statusline = '%#STLHighlight# TREE %#STLText#'

	local map_opts = { noremap = true, silent = true }
	vim.api.nvim_buf_set_keymap(FileTree.BufID, 'n', '<up>', '<nop>', map_opts)
	vim.api.nvim_buf_set_keymap(FileTree.BufID, 'n', '<down>', '<nop>', map_opts)

	vim.api.nvim_command('clearjumps')
	vim.api.nvim_command('iabclear <buffer>')

	KeyMap.BindAll()
end

function FileTree.Toggle()
	if not FileTree.WinID then
		FileTree.CreateWindow()
		FileTree.Render()

		vim.api.nvim_win_set_cursor(FileTree.WinID, FileTree.Cursor)
	else
		FileTree.Close()
	end
end

function FileTree.CWD()
	cwdPath = Path.CreatePathInfo(vim.fn.getcwd())

	if FileTree.Root.pathInfo.path == cwdPath.path then
		return
	end

	newRoot = TreeNode.CreateNode(cwdPath, FileTree)
	FileTree.ChangeRoot(newRoot)
end

local function FileTreeInit()
    local pathInfo = Path.CreatePathInfo(vim.fn.getcwd())
	FileTree.Root = TreeNode.CreateNode(pathInfo)
	TreeNode.InitChildren(FileTree.Root)
	FileTree.Root.isOpen = true
end

function FileTree.Setup()
	KeyMap.SetMaps()
	FileTreeInit()

	FileTree.HlID = vim.api.nvim_create_namespace("FileTree")

	for key, val in pairs(Config.ExtensionColors) do
		vim.api.nvim_command('hi def FileTreeExtension_' .. key .. ' ctermfg=white guifg=#' .. val)
	end

	for key, val in pairs(Config.ExactColors) do
		vim.api.nvim_command('hi def FileTreeExtension_' .. key .. ' ctermfg=white guifg=#' .. val)
	end
end

function FileTree.ChangeRoot(node)
	local pathInfo

    if node.pathInfo.isDirectory then
        pathInfo = node.pathInfo
    else
        pathInfo = node.parent.pathInfo
    end

	Path.ChangeCWD(pathInfo)

	FileTreeInit()

    FileTree.Render()
end

function FileTree.Close()
    if not FileTree.WinID then
        return
    end

	FileTree.Cursor = vim.api.nvim_win_get_cursor(FileTree.WinID)
	vim.api.nvim_win_close(FileTree.WinID, true)
	vim.api.nvim_buf_delete(FileTree.BufID, { force = true })
	FileTree.WinID = nil
	FileTree.BufID = nil
end

return FileTree
