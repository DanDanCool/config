-- nord port

vim.o.background = 'dark'

if vim.g.syntax_on then
	vim.api.nvim_command('syntax reset')
end

vim.g.colors_name = "nord"

local NordColors = {}

NordColors.Normal	= {fg = "white", guifg = "#D8DEE9", guibg="NONE", bg="NONE"}
NordColors.NormalFloat	= {fg = "white", guifg = "#D8DEE9", guibg="NONE", bg="NONE"}
NordColors.FloatBorder	= {fg = "white", guifg = "#2E3440", guibg="NONE", bg="NONE"}
NordColors.Conceal	= {fg = "white", guifg = "#D8DEE9", bg = "NONE", guibg = "NONE"}
NordColors.VertSplit = {cterm = "NONE", fg = "38", bg = "NONE", gui = "NONE", guifg = "#2E3440", guibg = "NONE"}
NordColors.WinSeparator = {cterm = "NONE", fg = "38", bg = "NONE", gui = "NONE", guifg = "#2E3440", guibg = "NONE"}

--NordColors.Normal	= {"fg": "white", "bg": "black", "guifg": "#E5E9F0", "guibg": "#1c1f26"}
--NordColors.VertSplit = {"fg": "38", "bg": "38", "guifg": "#1c1f26", "guibg": "#2E3440"}

-- syntax
NordColors.Comment		= {fg = "71", guifg = "#899bbf"}

NordColors.Constant		= {fg = "white", guifg = "#71468c"}
NordColors.String		= {fg = "197", guifg = "#A3BE8C"}
NordColors.Character	= {fg = "197", guifg = "#A3BE8C"}
NordColors.Number		= {fg = "197", guifg = "#71468c"}
NordColors.Boolean		= {fg = "white", guifg = "#71468c"}
NordColors.Float		= {fg = "197", guifg = "#71468c"}

NordColors.Identifier	= {fg = "153", guifg = "#D8DEE9"}
NordColors.Function		= {fg =  "62", guifg = "#5E81AC"}

NordColors.Statement	= {fg = "98", guifg = "#81A1C1"}
NordColors.Conditional	= {fg = "98", guifg = "#81A1C1"}
NordColors.Repeat		= {fg = "98", guifg = "#81A1C1"}
NordColors.Label		= {fg = "98", guifg = "#81A1C1"}
NordColors.Operator		= {fg = "white", guifg = "#5E81AC"}
NordColors.Delimiter	= {fg = "white", guifg = "#D8DEE9"}
NordColors.Exception	= {fg = "98", guifg = "#88C0D0"}

NordColors.PreProc		= {fg =  "92", guifg = "#899bbf"}
NordColors.Include		= {fg = "245", guifg = "#899bbf"}

NordColors.Type			= {fg = "98", guifg = "#88C0D0"}
NordColors.Structure	= {fg = "98", guifg = "#88C0D0"}

NordColors.Special		= {fg = "98", guifg = "#EBCB8B"}
NordColors.Underlined	= {fg = "98", guifg = "#5E81AC"}
NordColors.Todo			= {fg = "white", bg = "28", guifg = "#D8DEE9", guibg = "#434C5E"}

-- Misc
NordColors.Folded		= {fg = "white", bg = "54", guifg = "#D8DEE9", guibg = "#3B4252"}
NordColors.Visual		= {bg = "242", guibg = "#3B4252"}
NordColors.Search		= {bg = "242", guifg = "#D8DEE9", guibg = "#B48EAD"}
NordColors.CurSearch	= {bg = "242", guifg = "#D8DEE9", guibg = "#71468c"}
NordColors.LineNr		= {fg =  "38", guifg = "#2E3440"}
NordColors.Pmenu		= {fg = "white", bg = "92", guifg = "#E5E9F0", guibg = "#434C5E"}
NordColors.PmenuSel		= {fg = "white", bg = "62", guifg = "#E5E9F0", guibg = "#2E3440"}
NordColors.CursorColumn		= {bg = "92", guifg = "#E5E9F0", guibg = "#434C5E"}
NordColors.CursorLine		= {bg = "62", guifg = "#E5E9F0", guibg = "#2E3440"}
NordColors.ColorColumn		= {bg = "92", guifg = "#E5E9F0", guibg = "#434C5E"}
NordColors.FloatShadow		= {fg = "white", bg = "62", guifg = "#E5E9F0", guibg = "#2E3440"}
NordColors.FloatShadowThrough		= {fg = "white", bg = "62", guifg = "#E5E9F0", guibg = "#2E3440"}

NordColors.StatusLine	= {fg = "233", guifg = "#2E3440", guibg = "#2E3440"}
NordColors.StatusLineNC	= {fg = "233", guifg = "#2E3440", guibg = "#2E3440"}
NordColors.EndOfBuffer	= {fg =  "38", guifg = "#3B4252"}

NordColors.FileTreeDir		= {fg = "white", guifg = "#71468c"}
NordColors.FileTreeDirIcon	= {fg = "white", guifg = "#8FBCBB"}
NordColors.FileTreeNodeDir	= {fg = "white", guifg = "#5E81AC"}

-- treesitter
NordColors.TSNamespace	= {fg = "white", guifg = "#8FBCBB"}
NordColors.TSType		= {fg = "white", guifg = "#88C0D0"}
NordColors.TSText		= {fg = "white", guifg = "#E5E9F0"}

local function highlight(group, def)
	local colors = def

	local cmd = 'hi ' .. group .. ' '

	if colors['fg'] then
		cmd = cmd .. 'guifg=' .. colors["guifg"] .. ' '
		cmd = cmd .. 'ctermfg=' .. colors["fg"] .. ' '
	end

	if colors["bg"] then
		cmd = cmd .. 'guibg=' .. colors["guibg"] .. ' '
		cmd = cmd .. 'ctermbg=' .. colors["bg"] .. ' '
	end

	if colors["cterm"] then
		cmd = cmd .. 'gui=' .. colors["gui"] .. ' '
		cmd = cmd .. 'cterm=' .. colors["cterm"] .. ' '
	end

	if colors["guisp"] then
		cmd = cmd .. 'guisp=' .. colors['guisp'] .. ' '
	end

	vim.api.nvim_command(cmd)
end

for group, def in pairs(NordColors) do
	highlight(group, def)
end
