-- CLASS: MenuController
--
local MenuController = {}

-- create a new menu controller that operates on the given menu items
function MenuController.New(menuItems)
    local newMenuController =  copy(self)

    if menuItems[0].isSeparator() then
        newMenuController.menuItems = menuItems[1:-1]
    else
        newMenuController.menuItems = menuItems
    end

    return newMenuController
end

-- Enter the main loop of the NERDTree menu, prompting the user to select a menu item.
function MenuController.showMenu()
    self._saveOptions()

	self.selection = 0
	local done = 0

	while not done do
		if has('nvim') then
			mode
		else
			redraw!
		end
		self._echoPrompt()

		local key = nr2char(getchar())
		done = self._handleKeypress(key)
	end

	self._restoreOptions()

	-- Redraw when Ctrl-C or Esc is received.
	if not done || self.selection == -1 then
		redraw!
	end

    if self.selection ~= -1 then
        let m = self._current()
        m.execute()
    end
end

function MenuController._echoPrompt()
    local navHelp = 'Use ' .. NERDTreeMenuDown .. '/' .. NERDTreeMenuUp .. '/enter'

    if self.isMinimal() then
        local selection = self.menuItems[self.selection].text
        local keyword = matchstr(selection, '[^ ]*([^ ]*')

        local shortcuts = map(copy(self.menuItems), "v:val['shortcut']")
        shortcuts[self.selection] = ' ' .. keyword .. ' '

        echo 'Menu: [' . join(shortcuts, ',') . '] (' . navHelp . ' or shortcut): '
    else
        echo 'NERDTree Menu. ' . navHelp . ', or the shortcuts indicated'
        echo '========================================================='

        for i in range(0, #self.menuItems - 1) do
            if self.selection == i then
                echo '> ' .. self.menuItems[i].text
            else
                echo '  ' .. self.menuItems[i].text
            end
        end
    end
end

-- change the selection (if appropriate) and return 1 if the user has made
-- their choice, 0 otherwise
function MenuController._handleKeypress(key)
    if key == nr2char(27) then -- escape
        self.selection = -1
        return 1
    elseif key == "\r" or key == "\n" -- enter and ctrl-j then
        return 1
    else
        local index = self._nextIndexFor(key)
        if index ~= -1 then
            self.selection = index

            if #self._allIndexesFor(key) == 1 then
                return 1
            end
        end
    end

    return 0
end

-- get indexes to all menu items with the given shortcut
function MenuController._allIndexesFor(shortcut)
    local toReturn = []

    for i in range(0, #self.menuItems - 1) do
        if self.menuItems[i].shortcut == shortcut then
            add(toReturn, i)
        end
    end

    return toReturn
end

-- get the index to the next menu item with the given shortcut, starts from the
-- current cursor location and wraps around to the top again if need be
function MenuController._nextIndexFor(shortcut)
    for i in range(self.selection + 1, #self.menuItems - 1) do
        if self.menuItems[i].shortcut == shortcut then
            return i
        end
    end

    for i in range(0, self.selection) do
        if self.menuItems[i].shortcut == shortcut then
            return i
        end
    end

    return -1
end

-- sets &cmdheight to whatever is needed to display the menu
function MenuController._setCmdheight()
    if self.isMinimal() then
        let &cmdheight = 1
    else
        let &cmdheight = #self.menuItems + 3
    end
end

-- set any vim options that are required to make the menu work (saving their old values)
function MenuController._saveOptions()
    let self._oldLazyredraw = &lazyredraw
    let self._oldCmdheight = &cmdheight
    set nolazyredraw

    self._setCmdheight()
end

-- restore the options we saved in _saveOptions()
function MenuController._restoreOptions()
    let &cmdheight = self._oldCmdheight
    let &lazyredraw = self._oldLazyredraw
end

return MenuController
