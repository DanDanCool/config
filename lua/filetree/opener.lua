-- CLASS: Opener
-- The Opener class defines an API for 'opening' operations.

local Opener = {}

function Opener.Open(node, options)
	options = options or {}
	options.pathInfo = node.pathInfo

	local win = vim.api.nvim_get_current_win()

	if BufIsOpen(options) then
		return
	end

	OpenWindow(options)
	vim.api.nvim_command('edit ' .. node.pathInfo.path)

	if options.stay then
		vim.api.nvim_set_current_win(win)
	end
end

-- Find if the buffer is already open somewhere
-- return 1 if we were successful
function BufIsOpen(options)
	local bufid = -1

	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if string.find(vim.api.nvim_buf_get_name(buf), options.pathInfo.path, 1, true) then
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

function OpenWindow(options)
	if options.where == 't' then
		vim.api.nvim_command('wincmd p')
		vim.api.nvim_command('tabnew')
	elseif options.where == 'p' then
		PreviousWindow(options)
	else
		OpenSplit(options)
	end
end

function OpenSplit(options)
	local onlyOneWin = (vim.fn.winnr('$') == 1)
	local splitMode = 'vertical'

	if options.where == 'h' then
		splitMode = ''
	end

	-- resize tree window
	vim.api.nvim_command('silent vertical resize' .. FileTree.WinSize)

	-- Open the new window
	-- Error: file might already be open and modified
	vim.api.nvim_command('wincmd p')
	vim.api.nvim_command(splitMode .. ' split')
end

function PreviousWindow(options)
	local prevUsable = true

	local winid = vim.fn.win_getid(vim.fn.winnr('#'))
	local buf = vim.api.nvim_win_get_buf(winid)

	-- if its a special window e.g. quickfix or another explorer plugin then we have to split
	if vim.api.nvim_buf_get_option(buf, 'buftype') ~= ''
		or vim.api.nvim_win_get_option(winid, 'previewwindow')
		or (vim.api.nvim_buf_get_option(buf, 'modified') and not vim.g.hidden)
		or vim.fn.winnr('$') == 1 then
		prevUsable = false
	end

	if not prevUsable then
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
		OpenSplit(options)
	else
		vim.api.nvim_set_current_win(winid)
	end
end

return Opener
