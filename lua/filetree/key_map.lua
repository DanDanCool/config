local TreeNode = require'filetree/tree_node'
local Opener = require'filetree/opener'

local KeyMap = {}
KeyMap.Maps = {}

function KeyMap.BindAll()
	local map_opts = { noremap = true, silent = true }

    for key, def in pairs(KeyMap.Maps) do
		vim.api.nvim_buf_set_keymap(0, 'n', def.key, '<cmd>lua require"filetree/key_map".Invoke("' .. def.key .. '")<cr>', map_opts)
    end
end

-- Find a keymapping for a:key and the current scope invoke it.
--
-- Scope is determined as follows:
--    * if the cursor is on a dir node then DirNode
--    * if the cursor is on a file node then FileNode
--
-- If a keymap has the scope of 'all' then it will be called if no other keymap
-- is found for a:key and the scope.
function KeyMap.Invoke(key)
    local node = TreeNode.Nodes[vim.fn.line('.')]
	local km = nil

    if node ~= nil then
        -- try file node
        if not node.pathInfo.isDirectory then
            km = KeyMap.Maps[key ..'FileNode']
		else
            km = KeyMap.Maps[key .. 'DirNode']
        end

        -- try generic node
		if km == nil then
			km = KeyMap.Maps[key .. 'Node']
        end
    end

    -- try all
	if km == nil then
		km = KeyMap.Maps[key .. 'all']
	end

    if km ~= nil then
        return km.callback(node)
    end
end

function KeyMap.Create(options)
    vim.tbl_extend("keep", options, {scope = 'all'})
	KeyMap.Maps[options.key .. options.scope] = options
end

function KeyMap.SetMaps()
    KeyMap.Create({ key = 'o', scope = 'DirNode', callback = TreeNode.ToggleOpenDir	})

    KeyMap.Create({ key = 'o', scope = 'FileNode', callback = function(node)
		Opener.Open(node, { reuse = 'all', where = 'p', keepopen = 1 })
	end	})

    KeyMap.Create({ key = 'i', scope = 'FileNode', callback = function(node)
		Opener.Open(node, { where = 'h', keepopen = 1 })
	end	})

    KeyMap.Create({ key = 's', scope = 'FileNode', callback = function(node)
		Opener.Open(node, { where = 'v', keepopen = 1 })
	end	})

    KeyMap.Create({ key = 'O', scope = 'DirNode', callback = function(node)
		TreeNode.OpenRecursively(node)
		FileTree.Render()
	end	})

    KeyMap.Create({ key = 'C', scope = 'Node', callback = function(node)
		FileTree.ChangeRoot(node)
	end	})

    KeyMap.Create({ key = 'CD', scope = 'all', callback = FileTree.CWD })

    KeyMap.Create({ key = 'r', scope = 'all', callback = function()
		TreeNode.Refresh(FileTree.Root)
		FileTree.Render()
	end	})

    KeyMap.Create({ key = 'm', scope = 'Node', callback = function(node)
		local mc = FileTree.MenuController.New(FileTree.MenuItem.AllEnabled())
		mc.showMenu()
	end	})

    KeyMap.Create({ key = 'p', scope = 'Node', callback = function(node)
		vim.api.nvim_win_set_cursor(vim.t.FileTreeWin, { node.parent.ln, 0 })
	end	})

    KeyMap.Create({ key = 't', scope = 'Node', callback = function(node)
		Opener.Open(node, {where = 't', keepopen = 1})
	end	})

    KeyMap.Create({ key = 'T', scope = 'Node', callback =  function(node)
		Opener.Open(node, {where = 't', keepopen = 1, stay = 1})
	end	})
end

return KeyMap