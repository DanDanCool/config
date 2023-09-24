-- CLASS: Opener
-- The Opener class defines an API for 'opening' operations.
--
-- Find if the buffer is already open somewhere
-- return 1 if we were successful
local function buf_open(options)
	local bufid = -1

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if string.find(vim.api.nvim_buf_get_name(buf), options.path_info.path, 1, true) then
			bufid = buf
			break
		end
	end

	if bufnr == -1 then
		return false
	end

	if options.reuse == nil then
		return false
	end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == bufid then
			vim.api.nvim_set_current_win(win)
			return true
		end
    end

	return false
end

local function open_split(options)
	local split = 'vertical'
	if options.where == 'h' then
		split = ''
	end

	-- Open the new window
	-- Error: file might already be open and modified
	vim.api.nvim_command('wincmd p')
	vim.api.nvim_command(split .. ' split')
end

local function previous_window(options)
	local prev_usable = true

	local winid = vim.fn.win_getid(vim.fn.winnr('#'))
	local buf = vim.api.nvim_win_get_buf(winid)

	-- if its a special window e.g. quickfix or another explorer plugin then we have to split
	if vim.api.nvim_buf_get_option(buf, 'buftype') ~= ''
		or vim.api.nvim_win_get_option(winid, 'previewwindow')
		or (vim.api.nvim_buf_get_option(buf, 'modified') and not vim.g.hidden)
		or vim.fn.winnr('$') == 1 then
		prev_usable = false
	end

	if not prev_usable then
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
			buf = vim.api.nvim_win_get_buf(win)

			if vim.api.nvim_buf_get_option(buf, 'buftype') == ''
				and not vim.api.nvim_win_get_option(win, 'previewwindow')
				and (not vim.api.nvim_buf_get_option(buf, 'modified') or vim.g.hidden) then
				winid = win
				break
			end
		end
	end

	if not vim.api.nvim_win_is_valid(winid) then
		open_split(options)
	else
		vim.api.nvim_set_current_win(winid)
	end
end

local function open_window(options)
	if options.where == 't' then
		vim.api.nvim_command('wincmd p')
		vim.api.nvim_command('tabnew')
	elseif options.where == 'p' then
		previous_window(options)
	else
		open_split(options)
	end
end

local opener = {}

function opener.open(node, options)
	options = options or {}
	options.path_info = node.path_info

	local win = vim.api.nvim_get_current_win()

	if buf_open(options) then
		return
	end

	open_window(options)
	vim.api.nvim_command('edit ' .. node.path_info.path)

	if options.stay then
		vim.api.nvim_set_current_win(win)
	end
end

return opener
