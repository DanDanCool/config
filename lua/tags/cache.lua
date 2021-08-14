local types = require('tags.types')
local cache = {}
cache.current = nil

local open = {}
function open.__index(table, key)
	return rawget(table, key.name .. key.line)
end

function open.__newindex(table, key, value)
	rawset(table, key.name .. key.line, value)
end

function cache.add_entry(buf)
	local ftype = vim.api.nvim_buf_get_option(buf, 'filetype')

	if not types[ftype] then
		return
	end

	local info = {}

	local fname = vim.api.nvim_buf_get_name(buf)
	fname = vim.fn.fnamemodify(fname, ':.')

	info.fname = fname
	info.ftype = ftype
	info.ftime = vim.fn.getftime(fname)
	info.winid = vim.api.nvim_get_current_win()
	info.bufid = buf

	info.render = nil
	info.tags = nil
	info.open = setmetatable({}, open)
	info.list = {}
	info.index = 1

	cache[buf] = info
	cache.current = info
end

function cache.update_entry(buf)
	local info = cache[buf]
	info.ftime = vim.fn.getftime(info.fname)
	info.winid = vim.api.nvim_get_current_win()

	cache.current = info
end

function cache.buf_updated(buf)
	local info = cache[buf]
	return info.ftime ~= vim.fn.getftime(info.fname) or not info.tags
end

function cache.current_updated()
	local info = cache.current
	if not info then return false end

	return info.ftime ~= vim.fn.getftime(info.fname) or not info.tags
end

return cache
