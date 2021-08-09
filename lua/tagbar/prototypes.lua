local prototypes = {}

local visibility_symbols = {
    public    = '+',
    protected = '#',
    private   = '-'
}

-- basetag
function prototypes.basetag.new(name)
    local newobj = {}

    newobj.name          = name
    newobj.fields        = {}
    newobj.fields.line   = 0
    newobj.fields.column = 0
    newobj.fields.end    = 0
    newobj.prototype     = ''
    newobj.data_type     = ''
    newobj.path          = ''
    newobj.fullpath      = name
    newobj.depth         = 0
    newobj.parent        = {}
    newobj.tline         = -1
    newobj.fileinfo      = {}
    newobj.typeinfo      = {}
    newobj._childlist    = {}
    newobj._childdict    = {}

    newobj.isNormalTag = 0
    newobj.isPseudoTag = 0
    newobj.isSplitTag = 0
    newobj.isKindheader = 0
    newobj._getPrefix = _getPrefix
    newobj.initFoldState = initFoldState
    newobj.getClosedParentTline = getClosedParentTline
    newobj.isFolded = isFolded
    newobj.openFold = openFold
    newobj.closeFold = closeFold
    newobj.setFolded = setFolded
    newobj.openParents = openParents
    newobj.addChild = addChild
    newobj.getChildrenByName = getChildrenByName
    newobj.removeChild = removeChild

    return newobj
end

function _getPrefix()
    local fileinfo = self.fileinfo

    if not empty(self._childlist) then
        if fileinfo.tagfolds[self.fields.kind][self.fullpath] then
            prefix = '-'
        else
            prefix = '+'
        end
    else
        prefix = ' '
    end

    -- Visibility is called 'access' in the ctags output
	if has_key(self.fields, 'access') then
		prefix = prefix .. get(visibility_symbols, self.fields.access, ' ')
	elseif has_key(self.fields, 'file')
		prefix = prefix .. visibility_symbols.private
	else
		prefix = prefix .. ' '
	end

    return prefix
end

function initFoldState(known_files)
    local fileinfo = self.fileinfo

    if known_files.has(fileinfo.fpath) and has_key(fileinfo, '_tagfolds_old') and
		has_key(fileinfo._tagfolds_old[self.fields.kind], self.fullpath) then
        -- The file has been updated and the tag was there before, so copy its old fold state
        fileinfo.tagfolds[self.fields.kind][self.fullpath] = fileinfo._tagfolds_old[self.fields.kind][self.fullpath]
    elseif self.depth >= fileinfo.foldlevel then
        fileinfo.tagfolds[self.fields.kind][self.fullpath] = 1
    else
        fileinfo.tagfolds[self.fields.kind][self.fullpath] = fileinfo.kindfolds[self.fields.kind]
    end
end

function getClosedParentTline()
    local tagline  = self.tline

    -- Find the first closed parent, starting from the top of the hierarchy.
    parents = {}
    local curparent = self.parent
    while not empty(curparent) do
        add(parents, curparent)
        curparent = curparent.parent
    end

    for parent in reverse(parents) do
        if parent.isFolded() then
            tagline = parent.tline
            break
        end
    end

    return tagline
end

function isFoldable()
    return not empty(self._childlist)
end

function isFolded()
    return self.fileinfo.tagfolds[self.fields.kind][self.fullpath]
end

function openFold()
    if self.isFoldable() then
        self.fileinfo.tagfolds[self.fields.kind][self.fullpath] = 0
    end
end

function closeFold()
    local newline = line('.')

    if not empty(self.parent) and self.parent.isKindheader() then
        -- Tag is child of generic 'kind'
        self.parent.closeFold()
        newline = self.parent.tline
    elseif self.isFoldable() and not self.isFolded() then
        -- Tag is parent of a scope and is not folded
        self.fileinfo.tagfolds[self.fields.kind][self.fullpath] = 1
        newline = self.tline
    elseif not empty(self.parent) then
        -- Tag is normal child, so close parent
        local parent = self.parent
        self.fileinfo.tagfolds[parent.fields.kind][parent.fullpath] = 1
        newline = parent.tline
    end

    return newline
end

function setFolded(folded)
    self.fileinfo.tagfolds[self.fields.kind][self.fullpath] = folded
end

function openParents()
    local parent = self.parent

    while not empty(parent) do
        parent.openFold()
        parent = parent.parent
    end
end

function addChild(tag)
    add(self._childlist, tag)

    if has_key(self._childdict, tag.name) then
        add(self._childdict[tag.name], tag)
    else
        self._childdict[tag.name] = [tag]
    end
end

function getChildrenByName(tagname)
    return get(self._childdict, tagname, [])
end

function removeChild(tag)
    local idx = index(self._childlist, tag)
    if idx >= 0 then
        remove(self._childlist, idx)
    end

    local namelist = get(self._childdict, tag.name, {})
    idx = index(namelist, tag)
    if idx >= 0 then
        remove(namelist, idx)
    end
end

-- fileinfo
function prototypes.fileinfo.new(fname, ftype, typeinfo)
    local newobj = {}

    -- The complete file path
    newobj.fpath = fname
    newobj.bufnr = bufnr(fname)

    newobj.mtime = getftime(fname)
    newobj.fsize = getfsize(a:fname)

    -- Get the number of lines in the file
    newobj.lnum = line('$')

    -- The vim file type
    newobj.ftype = ftype

    -- List of the tags that are present in the file, sorted according to the value of 'g:tagbar_sort'
    newobj._taglist = {}
    newobj._tagdict = {}

    -- Dictionary of the tags, indexed by line number in the file
    newobj.fline = {}

    -- Dictionary of the tags, indexed by line number in the tagbar
    newobj.tline = {}

    -- Dictionary of the folding state of 'kind's, indexed by short name
    newobj.kindfolds = {}
    newobj.typeinfo = typeinfo

    -- copy the default fold state from the type info
    for kind in typeinfo.kinds do
        newobj.kindfolds[kind.short] = tagbar_foldlevel == 0 ? 1 : kind.fold
    end

    -- Dictionary of dictionaries of the folding state of individual tags, indexed by kind and full path
    newobj.tagfolds = {}
    for kind in typeinfo.kinds do
        newobj.tagfolds[kind.short] = {}
    end

    -- The current foldlevel of the file
    newobj.foldlevel = tagbar_foldlevel

    newobj.addTag = addTag
    newobj.getTagsByName = getTagsByName
    newobj.removeTag = removeTag
    newobj.reset = reset
    newobj.sortTags = sortTags
    newobj.openKindFold = openKindFold
    newobj.closeKindFold = closeKindFold

    -- This is used during file processing. If the limit is exceeded at that
    -- point, then mark this flag for displaying to the tagbar window
    newobj.fsize_exceeded = 0

    return newobj
end

function addTag(tag)
    add(self._taglist, tag)

    if has_key(self._tagdict, tag.name) then
        add(self._tagdict[tag.name], tag)
    else
        self._tagdict[tag.name] = [tag]
    end
end

function getTagsByName(tagname)
    return get(self._tagdict, tagname, {})
end

function removeTag(tag)
    local idx = index(self._taglist, tag)
    if idx >= 0 then
        remove(self._taglist, idx)
    end

    local namelist = get(self._tagdict, tag.name, {})
    idx = index(namelist, tag)
    if idx >= 0 then
        remove(namelist, idx)
    end
end

-- Reset stuff that gets regenerated while processing a file and save the old tag folds
function reset()
    self.mtime = getftime(self.fpath)
    self._taglist = {}
    self._tagdict = {}
    self.fline = {}
    self.tline = {}

    self._tagfolds_old = self.tagfolds
    self.tagfolds = {}

    for kind in self.typeinfo.kinds do
        self.tagfolds[kind.short] = {}
    end
end

function sortTags(compare_typeinfo)
    if get(compare_typeinfo, 'sort', 0) then
        tagbar#sorting#sort(self._taglist, 'kind', compare_typeinfo)
    else
        tagbar#sorting#sort(self._taglist, 'line', compare_typeinfo)
    end
end

function openKindFold(kind)
    self.kindfolds[kind.short] = 0
end

function closeKindFold(kind)
    self.kindfolds[a:kind.short] = 1
end

-- kind header tag
function prototypes.kindheadertag.new(name)
    newobj = prototypes.basetag.new(name)

    newobj.isKindheader = 1
    newobj.getPrototype = getPrototype
    newobj.isFoldable = 1
    newobj.isFolded = isFolded
    newobj.openFold = openFold
    newobj.closeFold = closeFold
    newobj.toggleFold = toggleFold

    return newobj
end

function getPrototype(short)
    return self.name .. ': ' .. self.numtags .. ' tags'
end

function isFolded()
    return self.fileinfo.kindfolds[self.short]
end

function openFold()
    self.fileinfo.kindfolds[self.short] = 0
end

function closeFold()
    self.fileinfo.kindfolds[self.short] = 1
    return line('.')
end

function toggleFold(fileinfo)
    fileinfo.kindfolds[self.short] = not fileinfo.kindfolds[self.short]
end

function maybe_map_scope(scopestr)
    return scopestr
end

-- normal tag
function prototypes.normaltag.new(name)
    newobj = prototypes.basetag.new(name)

    newobj.isNormalTag = 1
    newobj.strfmt = strfmt
    newobj.str = str
    newobj.getPrototype = getPrototype
    newobj.getDataType = getDataType

    return newobj
end

function strfmt()
    local typeinfo = self.typeinfo
    local suffix = get(self.fields, 'signature', '')

    if has_key(self.fields, 'type') then
        suffix = suffix .. ' : ' .. self.fields.type
    elseif has_key(get(typeinfo, 'kind2scope', {}), self.fields.kind) then
        local scope = maybe_map_scope(typeinfo.kind2scope[self.fields.kind])
		suffix = suffix .. ' : ' .. scope
    end

    local prefix = self._getPrefix()

    return prefix .. self.name .. suffix
end

function str(longsig, full)
    if full and self.path ~= '' then
        str = self.path .. self.typeinfo.sro .. self.name
    else
        str = self.name
    end

    if has_key(self.fields, 'signature') then
        if longsig then
            str = self.fields.signature
        else
            str = str .. '()'
        end
    end

    return str
end

function getPrototype(short)
    if self.prototype ~= '' then
        prototype = self.prototype
    else
        bufnr = self.fileinfo.bufnr

        if self.fields.line == 0 or not bufloaded(bufnr) then
            -- No linenumber available or buffer not loaded (probably due to 'nohidden'), try the pattern instead
            return substitute(self.pattern, '^\\M\\^\\C\s*\(.*\)\\$$', '\1', '')
        end

        line = getbufline(bufnr, self.fields.line)[0]
        -- If prototype includes declaration, remove the '=' and anything after
        -- FIXME: Need to remove this code. This breaks python prototypes that
        -- can include a '=' in the function paramter list.
        --   ex: function(arg1, optional_arg2=False)
        -- let line = substitute(line, '\s*=.*', '', '')
        list = split(line, '\zs')

        start = index(list, '(')
        if start == -1 then
            return substitute(line, '^\s\+', '', '')
        end

        local opening = count(list, '(', 0, start)
        local closing = count(list, ')', 0, start)
        if closing >= opening then
            return substitute(line, '^\s\+', '', '')
        end

        local balance = opening - closing

        prototype = line
        local curlinenr = self.fields.line + 1
        while balance > 0 and curlinenr < line('$') do
            curline = getbufline(bufnr, curlinenr)[0]
            curlist = split(curline, '\zs')
            balance = balance + count(curlist, '(') - count(curlist, ')')
            prototype = prototype .. "\n" .. curline
            curlinenr = curlinenr + 1
        end

        self.prototype = prototype
    end

    if short then
        -- join all lines and remove superfluous spaces
        prototype = substitute(prototype, '^\s\+', '', '')
        prototype = substitute(prototype, '\_s\+', ' ', 'g')
        prototype = substitute(prototype, '(\s\+', '(', 'g')
        prototype = substitute(prototype, '\s\+)', ')', 'g')

        -- Avoid hit-enter prompts
        local maxlen = vim.go.columns - 12
        if #prototype > maxlen then
            prototype = prototype[:maxlen - 1 - 3]
            prototype = prototype .. '...'
        end
    end

    return prototype
end

function getDataType()
    if self.data_type ~= '' then
        data_type = self.data_type
    else
        -- This is a fallthrough attempt to derive the data_type from the line in the event ctags doesn't return the typeref field
        local bufnr = self.fileinfo.bufnr

        if self.fields.line == 0 or not bufloaded(bufnr) then
            -- No linenumber available or buffer not loaded (probably due to 'nohidden'), try the pattern instead
            return substitute(self.pattern, '^\\M\\^\\C\s*\(.*\)\\$$', '\1', '')
        end

        local line = getbufline(bufnr, self.fields.line)[0]
        data_type = substitute(line, '\s*' . escape(self.name, '~') . '.*', '', '')

        -- Strip off the path if we have one along with any spaces prior to the path
        if self.path ~= '' then
            data_type = substitute(data_type, '\s*' . self.path . self.typeinfo.sro, '', '')
        end

        -- Strip off leading spaces
        data_type = substitute(data_type, '^\s\+', '', '')

        self.data_type = data_type
    end

    return data_type
end

-- pseudo tag
function prototypes.pseudotag.new(name)
    local newobj = prototypes.basetag.new(name)

    newobj.isPseudoTag = 1
    newobj.strfmt = strfmt

    return newobj
end

function strfmt()
    local typeinfo = self.typeinfo
    local suffix = get(self.fields, 'signature', '')

    if has_key(typeinfo.kind2scope, self.fields.kind) then
        suffix = suffix .. ' : ' .. typeinfo.kind2scope[self.fields.kind]
    end

    local prefix = self._getPrefix()

    return prefix .. self.name .. '*' .. suffix
end

-- split tag
-- A tag that was created because of a tag name that covers multiple scopes
-- Inherits the fields of the "main" tag it was split from.
-- May be replaced during tag processing if it appears as a normal tag later, just like a pseudo tag.

function prototypes.splittag.new(name)
    local newobj = prototypes.normaltag.new(name)

    newobj.isSplitTag = 1

    return newobj
end

function prototypes.typeinfo.new(...)
    local newobj = {}

    newobj.kinddict = {}

    if a:0 > 0 then
        extend(newobj, a:1)
    end

    newobj.getKind = getKind
    newobj.createKinddict = createKinddict

    return newobj
end

function getKind(kind)
    local idx = has_key(self.kinddict, kind) ? self.kinddict[kind] : -1
    return self.kinds[idx]
end

-- Create a dictionary of the kind order for fast access in sorting functions
function createKinddict()
    local i = 0
    for i, kind in ipairs(self.kinds) do
        self.kinddict[kind.short] = i
    end

    self.kinddict['?'] = i
end

return prototypes
