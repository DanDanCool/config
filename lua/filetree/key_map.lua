local tree_node = require'filetree/tree_node'
local opener = require'filetree/opener'

local key_map = {}
key_map.maps = {}

function key_map.bind_all()
	local map_opts = { noremap = true, silent = true }

    for key, def in pairs(key_map.maps) do
		vim.api.nvim_buf_set_keymap(0, 'n', def.key, '<cmd>lua require("filetree/key_map").invoke("' .. def.key .. '")<cr>', map_opts)
    end
end

-- Find a key_mapping for a:key and the current scope invoke it.
--
-- Scope is determined as follows:
--    * if the cursor is on a dir node then DirNode
--    * if the cursor is on a file node then FileNode
--
-- If a key_map has the scope of 'all' then it will be called if no other keymap
-- is found for a:key and the scope.
function key_map.invoke(key)
    local node = tree_node.nodes[vim.fn.line('.')]
	local km = nil

    if node ~= nil then
        -- try file node
        if not node.path_info.directory then
            km = key_map.maps[key ..'FileNode']
		else
            km = key_map.maps[key .. 'DirNode']
        end

        -- try generic node
		if km == nil then
			km = key_map.maps[key .. 'Node']
        end
    end

    -- try all
	if km == nil then
		km = key_map.maps[key .. 'all']
	end

    if km ~= nil then
        return km.callback(node)
    end
end

function key_map.create(options)
    vim.tbl_extend("keep", options, {scope = 'all'})
	key_map.maps[options.key .. options.scope] = options
end

function key_map.set_maps()
    key_map.create({ key = 'o', scope = 'DirNode', callback = tree_node.toggle_open_dir	})

    key_map.create({ key = 'o', scope = 'FileNode', callback = function(node)
		opener.open(node, { reuse = 'all', where = 'p', keepopen = 1 })
		filetree.close()
	end	})

    key_map.create({ key = 'i', scope = 'FileNode', callback = function(node)
		opener.open(node, { where = 'h', keepopen = 1 })
		filetree.close()
	end	})

    key_map.create({ key = 's', scope = 'FileNode', callback = function(node)
		opener.open(node, { where = 'v', keepopen = 1 })
		filetree.close()
	end	})

    key_map.create({ key = 'O', scope = 'DirNode', callback = function(node)
		tree_node.openrecursively(node)
		filetree.render()
	end	})

    key_map.create({ key = 'C', scope = 'Node', callback = function(node)
		filetree.change_root(node)
	end	})

    key_map.create({ key = 'CD', scope = 'all', callback = filetree.cwd })

    key_map.create({ key = 'R', scope = 'all', callback = function()
		tree_node.refresh(filetree.root)
		filetree.render()
	end	})

	key_map.create({ key = 'r', scope = 'DirNode', callback = function(node)
		tree_node.refresh(node)
		filetree.render()
	end })

    key_map.create({ key = 'p', scope = 'Node', callback = function(node)
		vim.api.nvim_win_set_cursor(filetree.winid, { node.parent.ln, 0 })
	end	})

    key_map.create({ key = 't', scope = 'FileNode', callback = function(node)
		opener.open(node, {where = 't', keepopen = 1})
		filetree.close()
	end	})

    key_map.create({ key = 'T', scope = 'FileNode', callback =  function(node)
		opener.open(node, {where = 't', keepopen = 1, stay = 1})
		filetree.close()
	end	})

	key_map.create({ key = 'n', scope = 'FileNode', callback = function(node)
		local parent = node.parent
		local path = vim.fn.input('file/directory: ', parent.path_info.path .. '/', 'file')

		if path:sub(#path, #path) == '/' then
			vim.fn.mkdir(path, 'p')
		else
			vim.api.nvim_command('wincmd p')
			vim.api.nvim_command('edit ' .. path)
			filetree.close()
		end
	end })

	key_map.create({ key = 'n', scope = 'DirNode', callback = function(node)
		local path = vim.fn.input('file/directory: ', node.path_info.path .. '/', 'file')

		if path:sub(#path, #path) == '/' then
			vim.fn.mkdir(path, 'p')
		else
			vim.api.nvim_command('wincmd p')
			vim.api.nvim_command('edit ' .. path)
			filetree.close()
		end
	end })
end

return key_map
