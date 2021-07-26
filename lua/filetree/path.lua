-- CLASS: Path
-- The Path class provides an abstracted representation of a file system
-- pathname. Various operations on pathnames are provided and a number of
-- representations of a given path name can be accessed here.

local Path = {}

function Path.ChangeCWD(pathInfo)
	local dir = pathInfo.path

	if not pathInfo.isDirectory then
		dir = vim.fn.fnamemodify(dir, ":h")
	end

	vim.api.nvim_set_current_dir(dir)
	print('CWD: ' .. dir)
end

function Path.CreatePathInfo(path)
	path = vim.fn.fnamemodify(path, ":.")
	local filetype = vim.fn.getftype(path)

	local pathInfo = {}

	if filetype == 'dir' then
		pathInfo.isDirectory = true
	elseif filetype == 'file' then
		pathInfo.isDirectory = false
	else
		print("filetype not supported: " .. path .. " " .. filetype)
		return nil
	end

	pathInfo.flags	= ''
	pathInfo.path	= path

	return pathInfo
end

-- Renames this node on the filesystem
function Path.Rename(path)
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")

	if vim.fn.rename(self.str(), path) then
		print("rename failed")
	end
end

-- Copies the file/dir represented by this Path to the given location
--
-- Args:
-- dest: the location to copy this dir/file to
function Path.Copy(pathInfo, dest)
	vim.fn.mkdir(vim.fn.fnamemodify(dest, ":h"), "p")

	if vim.fn.has('win32') then
		if pathInfo.isDirectory then
			os.execute('xcopy /s /e /i /y /q ' .. pathInfo.path .. dest)
		else
			os.execute('copy /y ' .. pathInfo.path .. dest)
		end

		return
	end

	os.execute('cp -r ' .. pathInfo.path .. dest)
end

-- Deletes the file or directory represented by this path.
function Path.Delete(pathInfo)
	local flags = ''

	if pathInfo.isDirectory then
		flags = 'rf'
	end

	if delete(pathInfo.path, flags) then
		print("could not delete file/directory")
	end
end

return Path
