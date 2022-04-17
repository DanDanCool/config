FileTree	= {}

-- root of the tree, set in FileTreeInit
FileTree.Root	= {}

local KeyMap	= require'filetree/key_map'
local TreeNode	= require'filetree/tree_node'
local Path		= require'filetree/path'
local Config	= require'filetree/config'

FileTree.WinSize = 30

FileTree.BufID = nil
FileTree.HlID = nil

FileTree.Cursor = { 1, 1 }

function FileTree.Render()
	vim.api.nvim_buf_set_option(FileTree.BufID, 'modifiable', true)
	vim.api.nvim_buf_set_lines(FileTree.BufID, 0, -1, false, TreeNode.Render(FileTree.Root))
	TreeNode.HighlightTree()
	vim.api.nvim_buf_set_option(FileTree.BufID, 'modifiable', false)
end

function FileTree.CreateWindow()
	vim.api.nvim_command('silent! topleft vertical new')

	vim.t.FileTreeWin = vim.api.nvim_get_current_win()

	vim.api.nvim_win_set_buf(vim.t.FileTreeWin, FileTree.BufID)
	vim.api.nvim_win_set_width(vim.t.FileTreeWin, FileTree.WinSize)

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
	if not vim.t.FileTreeWin then
		FileTree.CreateWindow()
		FileTree.Render()

		vim.api.nvim_win_set_cursor(vim.t.FileTreeWin, FileTree.Cursor)
	else
		FileTree.Close()
		vim.t.FileTreeWin = nil
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
	FileTree.BufID = vim.api.nvim_create_buf(false, true)
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

-- Closes the tab tree window for this tab
function FileTree.Close()
    if not vim.t.FileTreeWin or vim.fn.winnr('$') == 1 then
        return
    end

	FileTree.Cursor = vim.api.nvim_win_get_cursor(vim.t.FileTreeWin)
	vim.api.nvim_win_close(vim.t.FileTreeWin, true)
end

return FileTree
