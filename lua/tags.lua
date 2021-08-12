local types = require('tags.types')
local ctags = require('tags.ctags')
local cache = require('tags.cache')
local keymap = require('tags.keymap')

tags = {}

tags.project_root = {'.git'}
tags.root = ''

tags.ctags_bin = 'ctags'
tags.ctags_output = {}

tags.width = 30

function tags.setup()
	if tags.project_root_exists() then
		tags.root = vim.fn.getcwd()
	end

	vim.api.nvim_command("augroup tags")
	vim.api.nvim_command("autocmd!")
	vim.api.nvim_command("autocmd BufWritePost * lua require('tags').update()")
	vim.api.nvim_command("autocmd BufEnter * lua require('tags').update_finfo()")
	vim.api.nvim_command("augroup end")
end

-- checks for project root in the current working directory
function tags.project_root_exists()
	if vim.fn.getftype('.notags') then
		return false
	end

	for root in tags.project_root do
		if vim.fn.getftype(root) ~= '' then
			return true
		end
	end

	return false
end

function tags.update_finfo()
	local buf = vim.api.nvim_get_current_buf()

	if not cache[buf] then
		return cache.add_entry(buf)
	end

	cache.update_entry(buf)
end

-- Update the tags file for the current buffer's file.
function tags.update()
	if not cache.current_updated() then
		return tags.Render()
	end

	if vim.fn.getcwd() == tags.root then
		local cmd = 'ctags -a ' .. fname
		vim.fn.jobstart(cmd)
	end

	local cmd = 'ctags --extras=+F -f -	--format=2 --excmd=pattern --fields=nksSafet --sort=no --append=no '
	cmd = cmd .. cache.current.fname

	opts = {
		on_stdout = function(_, data, _)
			tags.ctags_output = data
		end,

		on_exit = function()
			ctags.ParseOutput(tags.ctags_output)
			tags.Render()
		end,

		stdout_buffered = true
	}

	vim.fn.jobstart(cmd, opts)
end

-- Regenerate ALL files
function tags.regenerate()
	local cmd = 'ctags -R *'
	vim.fn.jobstart(cmd)
end

function tags.toggle()
	if not vim.t.tags_win then
		tags.CreateWindow()
		tags.update()
	else
		tags.Close()
		vim.t.tags_win = nil
	end
end

function tags.CreateWindow()
	vim.api.nvim_command('silent! botright vertical new')

	vim.t.tags_win = vim.api.nvim_get_current_win()
	vim.t.tags_buf = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_win_set_width(win, tags.width)
	vim.api.nvim_win_set_buf(vim.t.tags_win, vim.t.tags_buf)

	-- Buffer-local options
	vim.bo.filetype = 'tags_win'
	vim.bo.readonly = false -- in case the "view" mode is used
	vim.bo.buftype = 'nofile'
	vim.bo.bufhidden = 'hide'
	vim.bo.swapfile = false
	vim.bo.buflisted = false
	vim.bo.modifiable = false
	vim.bo.textwidth = 0

	-- Window-local options
	vim.wo.list = false
	vim.wo.winfixwidth = true
	vim.wo.spell = false
	vim.wo.wrap = false
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.foldenable = false
	vim.wo.foldcolumn = '0'

	-- Reset fold settings in case a plugin set them globally to something
	-- expensive. 'foldexpr' gets executed even if 'foldenable' is off
	vim.wo.foldmethod = 'manual'
	vim.wo.foldexpr = '0'
	vim.wo.signcolumn = 'no'

	vim.wo.statusline = '%#STLText# tags'

	vim.api.nvim_command('augroup tags_win')
	vim.api.nvim_command('autocmd!')
	vim.api.nvim_command('autocmd BufEnter * lua require("tags").update()')
	vim.api.nvim_command('augroup end')

	keymap.bind(vim.t.tags_buf)
end

function tags.Close()
    if not vim.t.tags_win or vim.fn.winnr('$') == 1 then
        return
    end

	vim.api.nvim_win_close(vim.t.tags_win, true)
	vim.api.nvim_buf_delete(vim.t.tags_buf, {})

	vim.t.tags_win = nil
	vim.t.tags_buf = nil

	vim.api.nvim_command('autocmd! tags_win')
end

function tags.Render()
	if not vim.t.tags_win then
		return
	end

	vim.api.nvim_buf_set_option(vim.t.tags_buf, 'modifiable', true)
	vim.api.nvim_buf_set_lines(vim.t.tags_buf, 0, -1, false, ctags.get_output())
	vim.api.nvim_buf_set_option(vim.t.tags_buf, 'modifiable', false)
end

return tags
