-- statusline and tabline

local git = require('git')
statusline = {}

statusline.colors = {}
statusline.colors.jolly = {
	STLText = { guifg = "#9039c6", guibg = "#232526" },
	STLNormal = { guifg = "#232526", guibg = "#9039c6" },
	STLInsert = { guifg = "#232526", guibg = "#a6e22e" },
	STLVisual = { guifg = "#232526", guibg = "#e6db74" },
	STLReplace = { guifg = "#232526", guibg = "#dd2c2c" },
	STLTerminal = { guifg = "#232526", guibg = "#9039c6" },
	STLHighlight = { guifg = "#232526", guibg = "#9039c6" },
	TabLine = { gui = 'NONE', guifg = "#9039c6", guibg = "#232526" },
	TabLineSel = { gui = 'NONE', guifg = "#232526", guibg = "#9039c6" },
	TabLineFill = { gui = 'NONE', guifg = "#9039c6", guibg = "#232526" }
}

statusline.colors.nord = {
	STLText = { guifg = "#5E81AC", guibg = "#232526" },
	STLNormal = { guifg = "#232526", guibg = "#5E81AC" },
	STLInsert = { guifg = "#232526", guibg = "#A3BE8C" },
	STLVisual = { guifg = "#232526", guibg = "#EBCB8B" },
	STLReplace = { guifg = "#232526", guibg = "#BF616A" },
	STLTerminal = { guifg = "#232526", guibg = "#5E81AC" },
	STLHighlight = { guifg = "#232526", guibg = "#5E81AC" },
	TabLine = { gui = 'NONE', guifg = "#5E81AC", guibg = "#232526" },
	TabLineSel = { gui = 'NONE', guifg = "#232526", guibg = "#5E81AC" },
	TabLineFill = { gui = 'NONE', guifg = "#5E81AC", guibg = "#232526" }
}

local plugin_map = {
	filetree = 'TREE',
	tagbar = 'tags',
	fzf = 'fzf',
	qf = 'quickfix',
}

local mode_map =  {
	[110] = 'NORMAL', [105] = 'INSERT', [82] = 'REPLACE', [118] = 'VISUAL',
	[116] = 'TERMINAL', [86] = 'V-LINE', [22] = 'V-BLOCK'
}

local color_map = {
	[110] = 'STLNormal', [105] = 'STLInsert', [82] = 'STLReplace', [118] = 'STLVisual',
	[116] = 'STLTerminal', [86] = 'STLVisual', [22] = 'STLVisual'
}

function statusline.highlight(colors)
	for group, def in pairs(colors) do
		local color = def
		local cmd = 'hi ' .. group .. ' '

		if color['guifg'] then
			cmd = cmd .. 'guifg=' .. color["guifg"] .. ' '
		end

		if color['guibg'] then
			cmd = cmd .. 'guibg=' .. color["guibg"] .. ' '
		end

		if color['gui'] then
			cmd = cmd .. 'gui=' .. color["gui"] .. ' '
		end

		vim.api.nvim_command(cmd)
	end

	local inverse = {
		STLNormal = 'STLInvNormal',
		STLInsert = 'STLInvInsert',
		STLVisual = 'STLInvVisual',
		STLReplace = 'STLInvReplace',
		STLTerminal = 'STLInvTerminal'
	}

	for group, inv in pairs(inverse) do
		local color = colors[group]
		local cmd = 'hi ' .. inv .. ' '

		if color['guifg'] then
			cmd = cmd .. 'guibg=' .. color["guifg"] .. ' '
		end

		if color['guibg'] then
			cmd = cmd .. 'guifg=' .. color["guibg"] .. ' '
		end

		vim.api.nvim_command(cmd)
	end
end

local function mode()
	local mode = vim.api.nvim_get_mode()
	mode = string.byte(mode.mode)
	if not mode_map[mode] then mode = 110 end

	local output = '%#' .. color_map[mode] .. '# '
	output = output .. mode_map[mode]
	output = output .. ' '

	return output
end

local function filename()
	local mode = vim.api.nvim_get_mode()
	mode = string.byte(mode.mode)
	if not mode_map[mode] then mode = 110 end

	local highlight = color_map[mode]
	highlight = 'STLInv' .. string.sub(highlight, 4)

	local filename = '%#' .. highlight .. '# %t '

	local modified = ''
	if vim.b.modified then modified = '+' end

	return filename .. modified
end

local function tabname(tab)
	local win = vim.api.nvim_tabpage_get_win(tab)
	local buf = vim.api.nvim_win_get_buf(win)
	local ftype = vim.api.nvim_buf_get_option(buf, 'filetype')
	local fname = vim.api.nvim_buf_get_name(buf)
	fname = vim.fn.fnamemodify(fname, ':t')

	if fname == '' then
		fname = '[No Name]'
	end

	if plugin_map[ftype] then
		fname = plugin_map[ftype]
	end

	local modified = ''
	if vim.api.nvim_buf_get_option(buf, 'modified') then modified = ' +' end

	return vim.api.nvim_tabpage_get_number(tab) .. ' ' .. fname .. modified
end

function statusline.statusline()
	local statusline = mode() .. filename()
	statusline = statusline .. '%=%#STLText#%#STLHighlight# Ln %l, Col %c %#STLText#  %L '

	return statusline
end

function statusline.tabline()
	local tabs = vim.api.nvim_list_tabpages()
	local current = vim.api.nvim_get_current_tabpage()
	local prev = current

	local tabline = '  '
	if (current ~= tabs[1]) then tabline = tabline .. '' end

	for _, tab in ipairs(tabs) do
		local sep = ''

		if tab == current then
			sep = ''
			tabline = tabline .. '%#TabLineSel#'
			tabline = tabline .. sep .. ' ' .. tabname(tab) .. ' '
			tabline = tabline .. '%#TabLine#' .. sep
		else
			if prev ~= current then sep = '' end
			tabline = tabline .. '%#TabLine#'
			tabline = tabline .. sep .. ' ' .. tabname(tab) .. ' '
		end

		prev = tab
	end

	tabline = tabline .. '%#TabLineFill#'
	tabline = tabline .. '%=' .. git.name() .. '  '

	return tabline
end

function statusline.setup()
	statusline.highlight(statusline.colors.nord)

	vim.g.qf_disable_statusline = 1
	vim.go.statusline='%!v:lua.statusline.statusline()'
	vim.go.tabline='%!v:lua.statusline.tabline()'
end

return statusline
