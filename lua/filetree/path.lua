-- CLASS: Path
-- The Path class provides an abstracted representation of a file system
-- pathname. Various operations on pathnames are provided and a number of
-- representations of a given path name can be accessed here.

local path = {}

function path.change_cwd(path_info)
	local dir = path_info.path

	if not pathinfo.directory then
		dir = vim.fn.fnamemodify(dir, ":h")
	end

	vim.api.nvim_set_current_dir(dir)
	print('CWD: ' .. dir)
end

function path.path_info(name)
	name = vim.fn.fnamemodify(name, ":.")
	local filetype = vim.fn.getftype(name)

	local path_info = {}

	if filetype == 'dir' then
		path_info.directory = true
	else
		-- assume file... this might be wrong but whatever
		path_info.directory = false
	end

	path_info.flags	= ''
	path_info.path	= name

	return path_info
end

-- Renames this node on the filesystem
function path.rename(name)
	vim.fn.mkdir(vim.fn.fnamemodify(name, ":h"), "p")

	if vim.fn.rename(self.str(), name) then
		print("rename failed")
	end
end

-- Copies the file/dir represented by this Path to the given location
--
-- Args:
-- dest: the location to copy this dir/file to
function path.copy(path_info, dest)
	vim.fn.mkdir(vim.fn.fnamemodify(dest, ":h"), "p")

	if vim.fn.has('win32') then
		if path_info.directory then
			os.execute('xcopy /s /e /i /y /q ' .. path_info.path .. dest)
		else
			os.execute('copy /y ' .. path_info.path .. dest)
		end

		return
	end

	os.execute('cp -r ' .. path_info.path .. dest)
end

-- Deletes the file or directory represented by this path.
function path.delete(path_info)
	local flags = ''

	if path_info.directory then
		flags = 'rf'
	end

	if vim.fn.delete(path_info.path, flags) then
		print("could not delete file/directory")
	end
end

return path
