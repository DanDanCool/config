-- Super eye searing theme

vim.o.background = 'dark'

if vim.g.syntax_on then
	vim.api.nvim_command('syntax reset')
end

vim.g.colors_name = "jolly"

local JollyColors = {}

JollyColors.Normal	= {fg = "white", guifg = "#dcdcdc"}
JollyColors.VertSplit = {cterm = "NONE", fg = "38", bg = "NONE", gui = "NONE", guifg = "#232526", guibg = "NONE"}
-- JollyColors.Normal	= {"fg": "white", "bg": "black", "guifg": "#dcdcdc", "guibg": "#1B141B"}
-- JollyColors.VertSplit = {"fg": "38", "bg": "38", "guifg": "#1B141B", "guibg": "#FFFFFF"}

-- syntax
JollyColors.Comment		= {fg = "71", guifg = "#4EB13E"}

JollyColors.Constant	= {fg = "white", guifg = "#9039c6"}
JollyColors.String		= {fg = "197", guifg = "#ff4056"}
JollyColors.Character	= {fg = "197", guifg = "#ff4056"}
JollyColors.Number		= {fg = "197", guifg = "#ff4056"}
JollyColors.Boolean		= {fg = "white", guifg = "#9039c6"}
JollyColors.Float		= {fg = "197", guifg = "#ff4056"}

JollyColors.Identifier	= {fg = "153", guifg = "#b4e4fe"}
JollyColors.Function	= {fg =  "62", guifg = "#5d5dd8"}

JollyColors.Statement	= {fg = "98", guifg = "#9039c6"}
JollyColors.Conditional	= {fg = "98", guifg = "#9039c6"}
JollyColors.Repeat		= {fg = "98", guifg = "#9039c6"}
JollyColors.Label		= {fg = "98", guifg = "#9039c6"}
JollyColors.Operator	= {fg = "white", guifg = "#5E81AC"}
JollyColors.Exception	= {fg = "98", guifg = "#9039c6"}
JollyColors.Delimiter	= {fg = "white", guifg = "#DCDCDC"}

JollyColors.PreProc		= {fg = "92", guifg = "#9039c6"}
JollyColors.Include		= {fg ="245", guifg = "#9b9b9b"}

JollyColors.Type		= {fg = "98", guifg = "#9039c6"}
JollyColors.Structure	= {fg = "98", guifg = "#9039c6"}

JollyColors.Todo		= {fg = "green", bg = 'NONE', guifg = '#4EB13E', guibg = "#NONE"}
JollyColors.Special		= {fg = "98", guifg = "#EBCB8B"}

-- Misc
JollyColors.Folded		= {fg = "white", bg = "54", guifg = "#dcdcdc", guibg = "#594359"}
JollyColors.Visual		= {bg = "242", guibg = "#594359"}
JollyColors.Search		= {fg = "black", bg = "198", guifg = "#D8DEE9", guibg = "#B48EAD"}
JollyColors.LineNr		= {fg =  "38", guifg = "#0089b7"}
JollyColors.Pmenu		= {fg = "white", bg = "92", guifg = "#dcdcdc", guibg = "#231a23"}
JollyColors.PmenuSel	= {fg = "white", bg = "62", guifg = "#dcdcdc", guibg = "#594359"}

-- colors based off of lightline molokai theme
JollyColors.StatusLine		= {fg = "233", guifg = "#232526", guibg = "#232526"}
JollyColors.StatusLineNC	= {fg = "233", guifg = "#232526", guibg = "#232526"}
JollyColors.EndOfBuffer		= {fg =  "38", guifg = "#232526"}

JollyColors.FileTreeDir		= {fg = "white", guifg = "#71468c"}
JollyColors.FileTreeDirIcon	= {fg = "white", guifg = "#8FBCBB"}
JollyColors.FileTreeNodeDir	= {fg = "white", guifg = "#5E81AC"}

-- treesitter
JollyColors.TSNamespace	= {fg = "white", guifg = "#EBCB8B"}
JollyColors.TSType		= {fg = "white", guifg = "#F92672"}
JollyColors.TSText		= {fg = "white", guifg = "#dcdcdc"}

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

	vim.api.nvim_command(cmd)
end

for group, def in pairs(JollyColors) do
	highlight(group, def)
end
