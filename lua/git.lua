local git = {}

git.dir = ''
git.branch = ''

function git.name()
	if vim.fn.getcwd() == git.dir then
		return git.branch
	end

	if not git.detect() then
		git.branch = 'none'
		return git.branch
	end

	local head = io.open(git.dir .. '/.git/HEAD')
	local line = head:read()
	io.close(head)

	local branch = vim.split(line, '/')
	git.branch = branch[#branch]

	return git.branch
end

function git.detect()
	git.dir = vim.fn.getcwd()

	if vim.fn.isdirectory(git.dir .. '/.git') == 0 then
		return false
	end

	if vim.fn.filereadable(git.dir .. '/.git/HEAD') == 0 then
		return false
	end

	return true
end

return git
