-- CLASS: MenuItem
--
local MenuItem = {}

-- get all top level menu items
function MenuItem.All()
    if not exists('s:menuItems') then
        local menuItems = []
    end

    return menuItems
end

-- get all top level menu items that are currently enabled
function MenuItem.AllEnabled()
    let toReturn = []
    for i in s:MenuItem.All() do
        if i.enabled() then
            call add(toReturn, i)
        end
    end
    return toReturn
end

-- make a new menu item and add it to the global list
function MenuItem.Create(options)
    let newMenuItem = copy(self)

    let newMenuItem.text = a:options['text']
    let newMenuItem.shortcut = a:options['shortcut']
    let newMenuItem.children = []

    let newMenuItem.isActiveCallback = -1
    if has_key(a:options, 'isActiveCallback') then
        let newMenuItem.isActiveCallback = a:options['isActiveCallback']
    end

    let newMenuItem.callback = -1
    if has_key(a:options, 'callback') then
        let newMenuItem.callback = a:options['callback']
    end

    if has_key(a:options, 'parent') then
        call add(a:options['parent'].children, newMenuItem)
    else
        call add(s:MenuItem.All(), newMenuItem)
    end

    return newMenuItem
end

-- make a new separator menu item and add it to the global list
function MenuItem.CreateSeparator(options)
    let standard_options = { 'text': '--------------------',
                \ 'shortcut': -1,
                \ 'callback': -1 }
    let options = extend(a:options, standard_options, 'force')

    return s:MenuItem.Create(options)
end

-- make a new submenu and add it to global list
function s:MenuItem.CreateSubmenu(options)
    let standard_options = { 'callback': -1 }
    let options = extend(a:options, standard_options, 'force')

    return s:MenuItem.Create(options)
end

-- return 1 if this menu item should be displayed
--
-- delegates off to the isActiveCallback, and defaults to 1 if no callback was specified
function MenuItem.enabled()
    if self.isActiveCallback ~= -1 then
        return type(self.isActiveCallback) == type(function('tr')) ? self.isActiveCallback() : {self.isActiveCallback}()
    end

    return 1
end

-- perform the action behind this menu item, if this menuitem has children then
-- display a new menu for them, otherwise deletegate off to the menuitem's
-- callback
function MenuItem.execute()
    if len(self.children) then
        let mc = g:NERDTreeMenuController.New(self.children)
        call mc.showMenu()
    else
        if self.callback != -1 then
            if type(self.callback) == type(function('tr')) then
                call self.callback()
            else
                call {self.callback}()
            end
        end
    end
end

-- return 1 if this menuitem is a separator
function MenuItem.isSeparator()
    return self.callback == -1 && self.children == []
end

-- return 1 if this menuitem is a submenu
function MenuItem.isSubmenu()
    return self.callback == -1 && !empty(self.children)
end

NERDTreeAddMenuItem({text = '(a)dd a childnode', shortcut = 'a', callback = 'NERDTreeAddNode'})
NERDTreeAddMenuItem({text = '(m)ove the current node', shortcut = 'm', callback = 'NERDTreeMoveNode'})
NERDTreeAddMenuItem({text = '(d)elete the current node', shortcut = 'd', callback = 'NERDTreeDeleteNode'})

NERDTreeAddMenuItem({text = '(c)opy the current node', shortcut = 'c', callback = 'NERDTreeCopyNode'})
NERDTreeAddMenuItem({text = 'copy (p)ath to clipboard', shortcut = 'p', callback = 'NERDTreeCopyPath'})

-- returns the string that should be prompted to the user for the given action
-- Args:
-- action: the action that is being performed, e.g. 'delete'
function inputPrompt(action)
    if action == 'add' then
        let title = 'Add a childnode'
        let info = "Enter the dir/file name to be created. Dirs end with a '/'"
        let minimal = 'Add node:'

    elseif action ==# 'copy' then
        let title = 'Copy the current node'
        let info = 'Enter the new path to copy the node to:'
        let minimal = 'Copy to:'

    elseif action ==# 'delete' then
        let title = 'Delete the current node'
        let info = 'Are you sure you wish to delete the node:'
        let minimal = 'Delete?'

    elseif action ==# 'deleteNonEmpty' then
        let title = 'Delete the current node'
        let info =  "STOP! Directory is not empty! To delete, type 'yes'"
        let minimal = 'Delete directory?'

    elseif action ==# 'move' then
        let title = 'Rename the current node'
        let info = 'Enter the new path for the node:'
        let minimal = 'Move to:'
    end

    if NERDTreeMenuController.isMinimal() then
        redraw! -- Clear the menu
        return minimal . ' '
    else
        let divider = '=========================================================='
        return title . "\n" . divider . "\n" . info . "\n"
    end
end

-- prints out the given msg and, if the user responds by pushing 'y' then the
-- buffer with the given bufnum is deleted
--
-- Args:
-- bufnum: the buffer that may be deleted
-- msg: a message that will be echoed to the user asking them if they wish to del the buffer
function promptToDelBuffer(bufnum, msg)
    print(msg)
    if NERDTreeAutoDeleteBuffer || nr2char(getchar()) ==# 'y' then
        -- 1. ensure that all windows which display the just deleted filename
        -- now display an empty buffer (so a layout is preserved).
        -- Is not it better to close single tabs with this file only ?
        let originalTabNumber = tabpagenr()
        let originalWindowNumber = winnr()
        -- Go to the next buffer in buffer list if at least one extra buffer is listed
        -- Otherwise open a new empty buffer
		let listedBufferCount = len(getbufinfo({'buflisted':1}))


        if listedBufferCount > 1 then
            exec('tabdo windo if winbufnr(0) ==# ' . a:bufnum . " | exec ':bnext! ' | endif", 1)
        else
            exec('tabdo windo if winbufnr(0) ==# ' . a:bufnum . " | exec ':enew! ' | endif", 1)
        end

        exec('tabnext ' . s:originalTabNumber, 1)
        exec(s:originalWindowNumber . 'wincmd w', 1)
        -- 3. We don't need a previous buffer anymore
        exec('bwipeout! ' . a:bufnum, 0)
    end
end

-- The buffer with the given bufNum is replaced with a new one
--
-- Args:
-- bufNum: the buffer that may be deleted
-- newNodeName: the name given to the renamed node
-- isDirectory: determines how to do the create the new filenames
function renameBuffer(bufNum, newNodeName, isDirectory)
    if isDirectory then
        let quotedFileName = fnameescape(a:newNodeName . '/' . fnamemodify(bufname(a:bufNum),':t'))
        let editStr = g:NERDTreePath.New(a:newNodeName . '/' . fnamemodify(bufname(a:bufNum),':t')).str({'format': 'Edit'})
    else
        let quotedFileName = fnameescape(a:newNodeName)
        let editStr = g:NERDTreePath.New(a:newNodeName).str({'format': 'Edit'})
    end
    -- 1. ensure that a new buffer is loaded
    exec('badd ' . quotedFileName, 0)
    -- 2. ensure that all windows which display the just deleted filename
    -- display a buffer for a new filename.
    let originalTabNumber = tabpagenr()
    let originalWindowNumber = winnr()
    exec('tabdo windo if winbufnr(0) ==# ' . a:bufNum . " | exec ':e! " . editStr . "' | endif", 0)
    exec('tabnext ' . s:originalTabNumber, 1)
    exec(s:originalWindowNumber . 'wincmd w', 1)
    -- 3. We don't need a previous buffer anymore
	exec('confirm bwipeout ' . a:bufNum, 0)
end

function NERDTreeAddNode()
    let curDirNode = TreeDirNode.GetSelected()
    let prompt = inputPrompt('add')
    let newNodeName = input(prompt, curDirNode.path.str() . nerdtree#slash(), 'file')

    if newNodeName ==# '' then
        print('Node Creation Aborted.')
        return
    end

	let newPath = g:NERDTreePath.Create(newNodeName)
	let parentNode = b:NERDTree.root.findNode(newPath.getParent())

	let newTreeNode = g:NERDTreeFileNode.New(newPath, b:NERDTree)
	" Emptying g:NERDTreeOldSortOrder forces the sort to
	" recalculate the cached sortKey so nodes sort correctly.
	let g:NERDTreeOldSortOrder = []
	if empty(parentNode)
		call b:NERDTree.root.refresh()
		call b:NERDTree.render()
	elseif parentNode.isOpen || !empty(parentNode.children)
		call parentNode.addChild(newTreeNode, 1)
		call NERDTreeRender()
		call newTreeNode.putCursorHere(1, 0)
	endif

	redraw!
end

function NERDTreeMoveNode()
    let curNode = TreeFileNode.GetSelected()
    let prompt = inputPrompt('move')
    let newNodePath = input(prompt, curNode.path.str(), 'file')

    while filereadable(newNodePath) do
        print('This destination already exists. Try again.')
        newNodePath = input(prompt, curNode.path.str(), 'file')
    end


    if newNodePath ==# '' then
        print('Node Renaming Aborted.')
        return
    end

	if curNode.path.isDirectory then
		let curPath = escape(curNode.path.str(),'\') . (nerdtree#runningWindows()?'\\':'/') . '.*'
		let openBuffers = filter(range(1,bufnr('$')),'bufexists(v:val) && fnamemodify(bufname(v:val),":p") =~# "'.escape(l:curPath,'\').'"')
	else
		let openBuffers = filter(range(1,bufnr('$')),'bufexists(v:val) && fnamemodify(bufname(v:val),":p") ==# curNode.path.str()')
	end

	curNode.rename(newNodePath)
	NERDTree.root.refresh()
	NERDTreeRender()

	-- If the file node is open, or files under the directory node are
	-- open, ask the user if they want to replace the file(s) with the
	-- renamed files.
	if !empty(openBuffers) then
		if curNode.path.isDirectory then
			echo "\nDirectory renamed.\n\nFiles with the old directory name are open in buffers " . join(l:openBuffers, ', ') . '. Replace these buffers with the new files? (yN)'
		else
			echo "\nFile renamed.\n\nThe old file is open in buffer " . l:openBuffers[0] . '. Replace this buffer with the new file? (yN)'
		end

		if g:NERDTreeAutoDeleteBuffer || nr2char(getchar()) ==# 'y' then
			for bufNum in openBuffers do
				call s:renameBuffer(bufNum, newNodePath, curNode.path.isDirectory)
			end
		end
	end

	curNode.putCursorHere(1, 0)

	redraw!
end

function NERDTreeDeleteNode()
    let currentNode = TreeFileNode.GetSelected()
    let confirmed = 0

    if currentNode.path.isDirectory && ((currentNode.isOpen && currentNode.getChildCount() > 0) ||
                                      (len(currentNode._glob('*', 1)) > 0)) then
        let prompt = inputPrompt('deleteNonEmpty') . currentNode.path.str() . ': '
        let choice = input(prompt)
        let confirmed = choice ==# 'yes'
    else
        let prompt = s:inputPrompt('delete') . currentNode.path.str() . ' (yN): '
        echo prompt
        let choice = nr2char(getchar())
        let confirmed = choice ==# 'y'
    end

    if confirmed then
		currentNode.delete()
		NERDTreeRender()

		-- if the node is open in a buffer, ask the user if they want to
		-- close that buffer
		let bufnum = bufnr('^'.currentNode.path.str().'$')
		if buflisted(bufnum)
			let prompt = "\nNode deleted.\n\nThe file is open in buffer ". bufnum . (bufwinnr(bufnum) ==# -1 ? ' (hidden)' : '') .'. Delete this buffer? (yN)'
			promptToDelBuffer(bufnum, prompt)
		endif

		redraw!
    else
        print('delete aborted')
    end
end

function NERDTreeListNode()
    let treenode = NERDTreeFileNode.GetSelected()

    if !empty(treenode) then
        let uname = system('uname')
        let stat_cmd = 'stat -c "%s" '

        if uname =~? 'Darwin' then
            let stat_cmd = 'stat -f "%z" '
        endif

        let cmd = 'size=$(' . stat_cmd . shellescape(treenode.path.str()) . ') && ' .
                 'size_with_commas=$(echo $size | sed -e :a -e "s/\(.*[0-9]\)\([0-9]\{3\}\)/\1,\2/;ta") && ' .
                 'ls -ld ' . shellescape(treenode.path.str()) . ' | sed -e "s/ $size / $size_with_commas /"'

        let metadata = split(system(cmd),'\n')
        print(metadata[0])
    else
        print('No information available')
    end
end

function NERDTreeListNodeWin32()
    let node = NERDTreeFileNode.GetSelected()

    if !empty(node) then
        let l:path = l:node.path.str()
        print('%s:%s  MOD:%s  BYTES:%d  PERMISSIONS:%s',
                    toupper(getftype(path)),
                    fnamemodify(path, ':t'),
                    strftime('%c', getftime(path)),
                    getfsize(path),
                    getfperm(path)))
        return
    end

    print('node not recognized')
endfunction

function NERDTreeCopyNode()
    let currentNode = NERDTreeFileNode.GetSelected()
    let prompt = inputPrompt('copy')
    let newNodePath = input(prompt, currentNode.path.str(), 'file')

    if newNodePath !=# '' then
        -- strip trailing slash
        let newNodePath = substitute(newNodePath, '\/$', '', '')

        let confirmed = 1
        if currentNode.path.copyingWillOverwrite(newNodePath) then
            call nerdtree#echo('Warning: copying may overwrite files! Continue? (yN)')
            let choice = nr2char(getchar())
            let confirmed = choice ==# 'y'
        end

        if confirmed then
                let newNode = currentNode.copy(newNodePath)

                if empty(newNode) then
                    NERDTree.root.refresh()
                    NERDTree.render()
                else
                    call NERDTreeRender()
                    call newNode.putCursorHere(0, 0)
                end
        end
    else
        print('Copy aborted.')
    end

    redraw!
end

function NERDTreeCopyPath()
    let nodePath = NERDTreeFileNode.GetSelected().path.str()
    if has('clipboard') then
        if &clipboard ==# 'unnamedplus' then
            let @+ = l:nodePath
        else
            let @* = l:nodePath
        end
        print('The path [' .. nodePath .. '] was copied to your clipboard.')
    else
        print('The full path is: ' .. l:nodePath)
    end
end

function NERDTreeQuickLook()
    let node = NERDTreeFileNode.GetSelected()

    if empty(node) then
        return
    end

    system('qlmanage -p 2>/dev/null ' . shellescape(l:node.path.str()))
end

return MenuItem
