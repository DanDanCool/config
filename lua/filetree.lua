filetree	= {}

-- root of the tree, set in FileTreeInit
filetree.root	= {}

local key_map	= require'filetree/key_map'
local tree_node	= require'filetree/tree_node'
local path		= require'filetree/path'
filetree.config	= require'filetree/config'

filetree.bufid = nil
filetree.winid = nil
filetree.hlid = nil

filetree.cursor = { 1, 0 }

function filetree.render()
	vim.api.nvim_buf_set_option(filetree.bufid, 'modifiable', true)
	vim.api.nvim_buf_set_lines(filetree.bufid, 0, -1, false, tree_node.render(filetree.root))
	tree_node.highlight_tree()
	vim.api.nvim_buf_set_option(filetree.bufid, 'modifiable', false)
end

function filetree.create_window()
	filetree.bufid = vim.api.nvim_create_buf(false, true)

    -- Options for a non-file/control buffer.
	vim.api.nvim_buf_set_option(filetree.bufid, 'bufhidden', 'hide')
	vim.api.nvim_buf_set_option(filetree.bufid, 'buftype', 'nofile')
	vim.api.nvim_buf_set_option(filetree.bufid, 'swapfile', false)
	vim.api.nvim_buf_set_option(filetree.bufid, 'filetype', 'filetree')
	vim.api.nvim_buf_set_option(filetree.bufid, 'modifiable', false)
	vim.api.nvim_buf_set_option(filetree.bufid, 'buflisted', false)

	local opts = {
		relative	= 'editor',
		style		= 'minimal',
		border		= 'single'
	}

	opts.col = math.ceil(vim.o.columns / 4)
	opts.row = math.ceil(vim.o.lines / 8) - 2
	opts.width = vim.o.columns - opts.col * 2
	opts.height = vim.o.lines - opts.row * 2 - 6

	filetree.winid = vim.api.nvim_open_win(filetree.bufid, true, opts)

    -- Options for controlling buffer/window appearance.
	vim.wo.winfixwidth = true
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
	vim.api.nvim_buf_set_keymap(filetree.bufid, 'n', '<up>', '<nop>', map_opts)
	vim.api.nvim_buf_set_keymap(filetree.bufid, 'n', '<down>', '<nop>', map_opts)

	vim.api.nvim_command('clearjumps')
	vim.api.nvim_command('iabclear <buffer>')

	key_map.bind_all()
end

function filetree.toggle()
	if not filetree.winid then
		filetree.create_window()
		filetree.render()

		vim.api.nvim_win_set_cursor(filetree.winid, filetree.cursor)
	else
		filetree.close()
	end
end

function filetree.cwd()
	path = path.path_info(vim.fn.getcwd())

	if filetree.root.path_info.path == path.path then
		return
	end

	new_root = tree_node.create_node(path, filetree)
	filetree.change_root(new_root)
end

local function init()
    local path_info = path.path_info(vim.fn.getcwd())
	filetree.root = tree_node.create_node(path_info)
	tree_node.init_children(filetree.root)
	filetree.root.open = true
end

function filetree.setup()
	key_map.set_maps()
	init()

	filetree.hlid = vim.api.nvim_create_namespace("FileTree")

	for key, val in pairs(filetree.config.extension_colors) do
		vim.api.nvim_command('hi def FileTreeExtension_' .. key .. ' ctermfg=white guifg=#' .. val)
	end

	for key, val in pairs(filetree.config.exact_colors) do
		vim.api.nvim_command('hi def FileTreeExtension_' .. key .. ' ctermfg=white guifg=#' .. val)
	end
end

function filetree.change_root(node)
	local path
    if node.path_info.directory then
        path = node.path_info
    else
        path = node.parent.path_info
    end

	path.change_cwd(path)
	init()
    filetree.render()
end

function filetree.close()
	if (vim.api.nvim_win_is_valid(filetree.winid)) then
		filetree.cursor = vim.api.nvim_win_get_cursor(filetree.winid)
		vim.api.nvim_win_close(filetree.winid, true)
	end

	if vim.api.nvim_buf_is_valid(filetree.bufid) then
		vim.api.nvim_buf_delete(filetree.bufid, { force = true })
	end

	filetree.winid = nil
	filetree.bufid = nil
end

return filetree
