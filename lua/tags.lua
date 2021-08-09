local tags = {}

tags.project_root = {'.git'}
tags.root = ''

tags.busy = false

function tags.setup()
	if not tags.project_root_exists() then
		return
	end

	tags.root = vim.fn.getcwd()

	vim.api.nvim_command("augroup tags")
	vim.api.nvim_command("autocmd!")
	vim.api.nvim_comamnd("autocmd BufWritePost * lua require('tags').update()")
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

-- Update the tags file for the current buffer's file.
function tags.update()
	if vim.fn.getcwd() ~= tags.root or tags.busy then
		return
	end

	local filename = vim.api.nvim_buf_get_name(0)
	filename = fnamemodify(filename, ':.')

	local cmd = 'ctags -a ' .. filename
	vim.fn.jobstart(cmd)
end

-- Regenerate ALL files
function tags.regenerate()
	tags.busy = true

	local cmd = 'ctags -R *'
	local opts = {
		on_exit = function()
			tags.busy = false
		end
	}

	vim.fn.jobstart(cmd, opts)
end

return tags
