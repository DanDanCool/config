local state = require'completion.state'

local hover = {}

local function getHoverWindowOptions(width, height, opts)
	local lines_above = vim.fn.winline() - 1
	local lines_below = vim.fn.winheight(0) - lines_above

	if lines_above < lines_below then
		height = math.min(lines_below, height)
	else
		height = math.min(lines_above, height)
	end

	local col
	if opts.align == 'right' then
		col = opts.col + opts.width
	else
		col = opts.col - width - 1
	end

	return {
		col = col,
		height = height,
		relative = 'editor',
		row = opts.row,
		focusable = false,
		style = 'minimal',
		width = width
	}
end

local function makeHoverWindow(contents, opts)
	local pad_left		= opts.pad_left
	local pad_right		= opts.pad_right

	local stripped		= {}
	local highlights	= {}

	local max_width
	if opts.align == 'right' then
		local columns = vim.api.nvim_get_option('columns')
		max_width = columns - opts.col - opts.width
	else
		max_width = opts.col - 1
	end

	do
		local i = 1
		local ft_found = false
		local ft = nil
		local start

		while i <= #contents do
			local line = contents[i]
			if not ft_found then ft = line:match("^```([a-zA-Z0-9_]*)$") end

			if ft then
				ft_found = true
				start = #stripped
				i = i + 1

				-- may cause problems
				if line == "```" then break end
			end

			while #line > max_width do
				local trimmed_line = string.sub(line, 1, max_width)
				local index = trimmed_line:reverse():find(" ")

				if index == nil or index > #trimmed_line / 2 then break end

				table.insert(stripped, string.sub(line, 1, max_width - index))
				line = string.sub(line, max_width - index + 2, #line)
			end

			table.insert(stripped, line)
			i = i + 1
		end

		if ft_found then
			table.insert(highlights, {
				ft = ft;
				start = start + 1;
				finish = #stripped
			})
		end
	end

	local width = 0
	for i, v in ipairs(stripped) do
		v = v:gsub("\r", "")

		if pad_left then v = (" "):rep(pad_left)..v end
		if pad_right then v = v..(" "):rep(pad_right) end

		stripped[i] = v
		width = math.max(width, #v)
	end

	if opts.align == 'right' then
		local columns = vim.api.nvim_get_option('columns')
		if opts.col + opts.row + width > columns then
			width = columns - opts.col - opts.width - 1
		end
	else
		if width > opts.col then
			width = opts.col - 1
		end
	end

	for i, h in ipairs(highlights) do
		h.start = h.start + i - 1
		h.finish = h.finish + i - 1

		if h.finish + 1 <= #stripped then
			table.insert(stripped, h.finish + 1, string.rep("─", width))
		end
	end

	-- Make the floating window.
	local height = #stripped
	local bufnr = vim.api.nvim_create_buf(false, true)
	local winnr
	local opt = getHoverWindowOptions(width, height, opts)

	if opt.width <= 0 then return end

	winnr = vim.api.nvim_open_win(bufnr, false, opt)
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, stripped)
	-- setup a variable for floating window, fix #223
	vim.api.nvim_buf_set_var(bufnr, "lsp_floating", true)

	local cwin = vim.api.nvim_get_current_win()
	vim.api.nvim_set_current_win(winnr)

	vim.cmd("ownsyntax markdown")
	local idx = 1

	local function highlight_region(ft, start, finish)
		if ft == '' then return end
		local name = ft..idx
		idx = idx + 1
		local lang = "@"..ft:upper()

		if not pcall(vim.cmd, string.format("syntax include %s syntax/%s.vim", lang, ft)) then
			return
		end

		vim.cmd(string.format("syntax region %s start=+\\%%%dl+ end=+\\%%%dl+ contains=%s", name, start, finish + 1, lang))
	end

	for _, h in ipairs(highlights) do
		highlight_region(h.ft, h.start, h.finish)
	end

	vim.api.nvim_set_current_win(cwin)
	return bufnr, winnr
end

local function lspHoverHandler(_, method, result)
	if vim.fn.pumvisible() == 1 then
		-- no results
		if not (result and result.contents) then
			return
		end

		local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
		markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)

		-- no results
		if vim.tbl_isempty(markdown_lines) then
			return
		end

		-- align hover window to popup menu
		local position = vim.fn.pum_getpos()
		local column_count = vim.api.nvim_get_option('columns')
		local align
		local col = position['col']

		if position['col'] < column_count / 2 then
			align = 'right'
			if position['scrollbar'] then
				col = col + 1
			end
		else
			align = 'left'
		end

		local bufnr, winnr
		bufnr, winnr = makeHoverWindow(markdown_lines, {
			pad_left = 0; pad_right = 1;
			col = col; width = position['width']; row = position['row']-1;
			align = align
		})

		hover.winnr = winnr

		if winnr ~= nil and vim.api.nvim_win_is_valid(winnr) then
			vim.lsp.util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, winnr)
		end

		-- setting height and width of the hover window
		local hover_len = #vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1]
		local win_width = vim.api.nvim_win_get_width(0)

		if hover_len > win_width then
			vim.api.nvim_win_set_width(winnr, math.min(hover_len, win_width))
			vim.api.nvim_win_set_height(winnr, math.ceil(hover_len / win_width))
			vim.wo[winnr].wrap = true
		end

		return bufnr, winnr
	end
end

function hover.autoHover()
	if vim.fn.pumvisible() ~= 1 then
		-- close any existing old windows
		if hover.winnr ~= nil and vim.api.nvim_win_is_valid(hover.winnr) then
			vim.api.nvim_win_close(hover.winnr, true)
		end

		hover.winnr = nil
		return
	end

	local items = vim.api.nvim_call_function('complete_info', {{"eval", "selected", "items", "user_data"}})

	if items['selected'] ~= state.selected then
		state.textHover = true

		-- close any existing old windows
		if hover.winnr ~= nil and vim.api.nvim_win_is_valid(hover.winnr) then
			vim.api.nvim_win_close(hover.winnr, true)
		end

		hover.winnr = nil
	end

	if state.textHover == true and items['selected'] ~= -1 then
		if items['selected'] == -2 then
			items['selected'] = 0
		end

		local item = items['items'][items['selected']+1]

		local has_hover = false

		for _, client in pairs(vim.lsp.buf_get_clients(0)) do
			if client.resolved_capabilities.hover then
				has_hover = true
				break
			end
		end

		if not has_hover then return end

		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		row = row - 1
		local line = vim.api.nvim_buf_get_lines(0, row, row+1, true)[1]
		col = vim.str_utfindex(line, col)

		local params = {
			textDocument = vim.lsp.util.make_text_document_params();
			position = { line = row; character = col-string.len(item.word); }
		}

		local bufnr = vim.api.nvim_get_current_buf()
		vim.lsp.buf_request(bufnr, 'textDocument/hover', params, lspHoverHandler)

		state.textHover = false
		state.selected = items['selected']
	end
end

return hover
