rg = {}

rg.binary = 'rg'
rg.format = "%f:%l:%c:%m"
rg.command = 'rg --vimgrep'
rg.window_location = 'botright'

local function search(args)
	local rgopts = ' '

	if vim.o.ignorecase then
		rgopts = rgopts .. '-i '
	end

	if vim.o.smartcase then
		rgopts = rgopts .. '-S '
	end

	local query = '"' .. args.args .. '"'
	vim.api.nvim_command('grep!' .. rgopts .. query)

	if #vim.fn.getqflist() then
		vim.api.nvim_command('botright copen | redraw!')
	else
		vim.api.nvim_command('cclose | redraw!')
		print('No match found for ' .. txt)
	end
end

local function ripgrep(args)
	local grepprgb = vim.o.grepprg
	local grepformatb = vim.o.grepformat
	local shellpipe_bak = vim.o.shellpipe

	vim.opt.grepprg = rg.command
	vim.opt.grepformat = rg.format

	if not vim.fn.has('win32') then
		vim.opt.shellpipe="&>"
	end

	search(args)

	vim.opt.shellpipe = shellpipe_bak
	vim.opt.grepprg = grepprgb
	vim.opt.grepformat = grepformatb
end

function rg.setup()
	--vim.api.nvim_command('command! -nargs=* Rg call v:lua.ripgrep(<q-args>)')
	vim.api.nvim_create_user_command("RG", ripgrep, { nargs="*", force = true })
end

return rg
