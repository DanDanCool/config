local tagbar = {}

tagbar.icon_closed = '-'
tagbar.icon_open   = '+'

tagbar.ctags_bin = 'ctags'

tagbar.paused = 0
tagbar.buffer_seqno = 0
tagbar.last_alt_bufnr = -1

tagbar.window_expanded = 0
tagbar.expand_bufnr = -1
tagbar.window_pos = {
	pre = { x = 0, y = 0 },
	post = { x = 0, y = 0 }
}

tagbar.delayed_update_files = {}
tagbar.last_highlight_tline = 0

tagbar.warnings = {
	type = {},
	encoding = 0
}

tagbar.indent = 2
tagbar.highlight_method = 'nearest-stl'
tagbar.position = 'botright vertical'
tagbar.width = 40

tagbar.singular_types = {
	Classes = 'Class',
	Delegates = 'Delegate',
	Enumeration_values = 'Enumeration value',
	Enumerations = 'Enumeration',
	Error_codes = 'Error code',
	Error_domains = 'Error domain',
	Fields = 'Field',
	Interfaces = 'Interface',
	JavaScript_functions = 'JavaScript function',
	Methods = 'Method',
	MobiLink_Conn_Scripts = 'MobiLink Conn Script',
	MobiLink_Properties = 'MobiLink Property',
	MobiLink_Table_Scripts = 'MobiLink Table Script',
	Properties = 'Property',
	Signals = 'Signal',
	Structures = 'Structure',
	autocommand_groups = 'autocommand group',
	block_data = 'block data',
	block_label = 'block label',
	chapters = 'chapter',
	classes = 'class',
	commands = 'command',
	common_blocks = 'common block',
	components = 'component',
	constant_definitions = 'constant definition',
	constants = 'constant',
	constructors = 'constructor',
	cursors = 'cursor',
	data_items = 'data item',
	defines = 'define',
	derived_types_and_structures = 'derived type and structure',
	domains = 'domain',
	entities = 'entity',
	entry_points = 'entry point',
	embedded = 'embedded',
	enum_constants = 'enum constant',
	enum_types = 'enum type',
	enumerations = 'enumeration',
	enumerators = 'enumerator',
	enums = 'enum',
	events = 'event',
	exception_declarations = 'exception declaration',
	exceptions = 'exception',
	features = 'feature',
	fields = 'field',
	file_descriptions = 'file description',
	formats = 'format',
	fragments = 'fragment',
	function_definitions = 'function definition',
	functions = 'function',
	functor_definitions = 'functor definition',
	global_variables = 'global variable',
	group_items = 'group item',
	imports = 'import',
	includes = 'include',
	indexes = 'index',
	interfaces = 'interface',
	javascript_functions = 'JavaScript function',
	labels = 'label',
	macro_definitions = 'macro definition',
	macros = 'macro',
	maps = 'map',
	members = 'member',
	methods = 'method',
	modules_or_functors = 'module or function',
	modules = 'module',
	mxtags = 'mxtag',
	named_anchors = 'named anchor',
	namelists = 'namelist',
	namespaces = 'namespace',
	net_data types = 'net data type',
	packages = 'package',
	package = 'package',
	paragraphs = 'paragraph',
	parts = 'part',
	patterns = 'pattern',
	ports = 'port',
	procedures = 'procedure',
	program_ids = 'program id',
	programs = 'program',
	projects = 'project',
	properties = 'property',
	prototypes = 'prototype',
	publications = 'publication',
	record_definitions = 'record definition',
	record_fields = 'record field',
	records = 'record',
	register data types = 'register data type',
	sections = 'section',
	services = 'services',
	sets = 'sets',
	signature_declarations = 'signature declaration',
	singleton_methods = 'singleton method',
	slots = 'slot',
	structs = 'struct',
	structure_declarations = 'structure declaration',
	structure_fields = 'structure field',
	subparagraphs = 'subparagraph',
	subroutines = 'subroutine',
	subsections = 'subsection',
	subsubsections = 'subsubsection',
	subtypes = 'subtype',
	synonyms = 'synonym',
	tables = 'table',
	targets = 'target',
	tasks = 'task',
	triggers = 'trigger',
	type_definitions = 'type definition',
	type_names = 'type name',
	typedefs = 'typedef',
	types = 'type',
	unions = 'union',
	value_bindings = 'value binding',
	variables = 'variable',
	views = 'view',
	vimball_filenames = 'vimball filename'
}

local known_files = {
	_files = {}
}

function known_files.get(fname)
	return get(self._files, fname, {})
end

function known_files.put(fileinfo, ...)
	if a:0 == 1 then
		self._files[a:1] = fileinfo
	else
		local fname = fileinfo.fpath
		self._files[fname] = fileinfo
	end
end

function known_files.has(fname)
	return has_key(self._files, fname)
end

function known_files.rm(fname)
	if known_files.has(fname) then
		print('Removing fileinfo for [' .. fname .. ']')
		remove(self._files, fname)
	end
end

function tagbar.setup()
	if executable(tagbar.ctags_bin) == 0 then
		print('ctags binary not found')
		return false
	end

	local ctags_cmd = EscapeCtagsCmd({'--version'}, '')
	if ctags_cmd == '' then
		return false
	end

	known_types = ctags.init()

	-- Add an 'unknown' kind to the types for pseudotags that we can't
	-- determine the correct kind for since they don't have any children that
	-- are not pseudotags and that therefore don't provide scope information
	for _, typeinfo in ipairs(known_types) do
		if typeinfo.kind2scope ~= nil then
			local unknown_kind = {short = '?', long = 'unknown', fold = 0, stl = 1}
			typeinfo.kind2scope['?'] = 'unknown'
		end
	end

	CreateAutocommands()
	UpdateFile(fnamemodify(expand('%'), ':p'))

	return true
end

function MapKeys()
	print('Mapping keys')

	local map_opt = { noremap = true, silent = true }

	vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', 'JumpToTag(0)', map_opt)
	vim.api.nvim_buf_set_keymap(0, 'n', 'p', 'JumpToTag(0)', map_opt)
	vim.api.nvim_buf_set_keymap(0, 'n', 'o', 'ToggleFold()', map_opt)
	vim.api.nvim_set_keymap(0, 'n', ';', 'ToggleWindow()', map_opt)

	tagbar.mapped_keys = 1
end

function CreateAutocommands()
	print('Creating autocommands')

	vim.api.nvim_command("augroup TagbarAutoCmds")
	vim.api.nvim_command("autocmd!")

	vim.api.nvim_command("autocmd BufEnter * if expand('<amatch>') !~ '__Tagbar__.*' then last_alt_bufnr = bufnr('#') end")

	vim.api.nvim_command("autocmd CursorHold __Tagbar__.* call ShowPrototype(1)")

	vim.api.nvim_command("autocmd BufWritePost * call HandleBufWrite(fnamemodify(expand('<afile>'), ':p'))")
	vim.api.nvim_command("autocmd CursorHold,CursorHoldI * call do_delayed_update()")

	-- BufReadPost is needed for reloading the current buffer if the file
	vim.api.nvim_command("autocmd BufReadPost,BufEnter,CursorHold,FileType * call UpdateFile(fnamemodify(expand('<afile>'), ':p'))")

	-- Suspend Tagbar while grep commands are running, since we don't want
	-- to process files that only get loaded temporarily to search them
	vim.api.nvim_command("autocmd QuickFixCmdPre  *grep* let s:tagbar_qf_active = 1")
	vim.api.nvim_command("autocmd QuickFixCmdPost *grep* if exists('tagbar_qf_active') unlet tagbar_qf_active end")

	vim.api.nvim_command("augroup END")

	-- Separate these autocmds out from the others as we want to always perform
	-- these actions even if the tagbar window closes.
	vim.api.nvim_command("augroup TagbarCleanupAutoCmds")
	vim.api.nvim_command("autocmd BufDelete,BufWipeout * nested call HandleBufDelete(expand('<afile>'), expand('<abuf>'))")
	vim.api.nvim_command("augroup END")
end

function ToggleWindow()
	print('ToggleWindow called')

	local tagbarwinnr = bufwinnr(TagbarBufName())
	if tagbarwinnr ~= -1 then
		CloseWindow()
		return
	end

	OpenWindow(false)

	print('ToggleWindow finished')
end

function OpenWindow()
	print("OpenWindow called with flags: '" .. flags .. "'")

	local curfile = fnamemodify(bufname('%'), ':p')
	local curline = line('.')

	-- If the tagbar window is already open check jump flag
	local tagbarwinnr = bufwinnr(TagbarBufName())
	if tagbarwinnr ~= -1 then
		if winnr() ~= tagbarwinnr then
			win_gotoid(tagbarwinnr)
			HighlightTag(1, 1, curline)
		end

		print('OpenWindow finished, Tagbar already open')
		return
	end

	-- Use the window ID if the functionality exists, this is more reliable
	-- since the window number can change due to the Tagbar window opening
	if exists('*win_getid') then
		local prevwinid = win_getid()
		if winnr('$') > 1 then
			win_gotoid('p', 1)
			pprevwinid = win_getid()
			win_gotoid('p', 1)
		end
	else
		local prevwinnr = winnr()
		if winnr('$') > 1 then
			win_gotoid('p', 1)
			pprevwinnr = winnr()
			win_gotoid('p', 1)
		end
	end

	local window_opening = 1
	if tagbar_position =~# 'vertical' then
		size = tagbar_width
		mode = 'vertical '
	else
		size = 10
		mode = ''
	end

	vim.api.nvim_command("'silent keepalt ' .. tagbar_position .. size .. 'split ' .. TagbarBufName()")
	vim.api.nvim_command("'silent ' .. mode .. 'resize ' .. size")

	SetWindowOptions()

	-- If the current file exists, but is empty, it means that it had a processing error before opening the window.
	-- Remove the entry so an error message will be shown if the processing still fails.
	if empty(known_files.get(curfile)) then
		known_files.rm(curfile)
	end

	UpdateFile(curfile)
	HighlightTag(1, 1, curline)

	print('OpenWindow finished')
end

function SetWindowOptions()
	-- Buffer-local options
	vim.bo.filetype = 'tagbar'
	vim.bo.readonly = false -- in case the "view" mode is used
	vim.bo.buftype = 'nofile'
	vim.bo.bufhidden = 'hide'
	vim.bo.swapfile = false
	vim.bo.buflisted = false
	vim.bo.modifiable = false
	vim.bo.textwidth = 0

	-- Window-local options
	vim.wo.list = false
	vim.wo.winfixwidth = true
	vim.wo.spell = false
	vim.wo.wrap = false
	vim.wo.number = false
	vim.wo.relativenumber = false
	vim.wo.foldenable = false
	vim.wo.foldcolumn = '0'

	-- Reset fold settings in case a plugin set them globally to something
	-- expensive. 'foldexpr' gets executed even if 'foldenable' is off
	vim.wo.foldmethod = 'manual'
	vim.wo.foldexpr = '0'
	vim.wo.signcolumn = 'no'

	MapKeys()
end

function CloseWindow()
	print('CloseWindow called')

	local tagbarwinnr = bufwinnr(TagbarBufName())
	if tagbarwinnr == -1 then
		return
	end

	if winnr() == tagbarwinnr then
		if winbufnr(2) ~= -1 then
			-- Other windows are open, only close the tagbar one

			local curfile = tagbar#state#get_current_file(0)
			vim.api.nvim_command("close")

			-- Try to jump to the correct window after closing
			win_gotoid('p')

			if not empty(curfile) then
				local filebufnr = bufnr(curfile.fpath)

				if bufnr('%') ~= filebufnr then
					local filewinnr = bufwinnr(filebufnr)
					if filewinnr ~= -1 then
						win_gotoid(filewinnr)
					end
				end
			end
		end
	else
		-- Go to the tagbar window, close it and then come back to the original
		-- window. Save a win-local variable in the original window so we can
		-- jump back to it even if the window number changed.
		nvim_win_close(tagbarwinnr, false)
	end

	vim.api.nvim_command("autocmd! TagbarAutoCmds")

	print('CloseWindow finished')
end

-- Execute ctags and put the information into a 'FileInfo' object
function ProcessFile(fname, ftype)
	print('ProcessFile called [' .. fname .. ']')

	if not IsValidFile(fname, ftype) then
		print('Not a valid file, returning')
		return
	end

	local bufnum = bufnr(fname)

	if not bufloaded(bufnum) then
		print('[ProcessFile] Buffer is not loaded, exiting...')
		return
	end

	if not bufexists(bufnum) then
		print('[ProcessFile] Buffer does not exist, exiting...')
		return
	end

	local typeinfo = known_types[ftype]

	-- If the file has only been updated preserve the fold states, otherwise create a new entry
	if known_files.has(fname) and not empty(known_files.get(fname)) and known_files.get(fname).ftype == ftype then
		local fileinfo = known_files.get(fname)
		typeinfo = fileinfo.typeinfo
		fileinfo.reset()
	else
		fileinfo = prototypes#fileinfo#new(fname, ftype, typeinfo)
	end

	print('typeinfo for file to process: ' .. string(typeinfo))

	fileinfo.fsize_exceeded = 0
	ctags_output = ExecuteCtagsOnFile('', fname, typeinfo)

	if ctags_output == -1 then
		print('Ctags error when processing file')
		-- Put an empty entry into known_files so the error message is only shown once
		known_files.put({}, fname)
		return
	elseif ctags_output == '' then
		print('Ctags output empty')
		-- No need to go through processing if there are no tags, and preserving old fold state isn't necessary
		known_files.put(tagbar#prototypes#fileinfo#new(fname, ftype, known_types[ftype]), fname)
		return
	end

	print('Filetype tag kinds: ' .. string(keys(typeinfo.kinddict)))

	-- Parse the ctags output lines
	print('Parsing ctags output')
	local rawtaglist = split(ctags_output, '\n\+')

	for line in rawtaglist do
		if line =~# '^!_TAG_' then
			continue
		end

		local parts = split(line, ';"')
		if #parts == 2 then -- Is a valid tag line
			ParseTagline(parts[1], parts[2], typeinfo, fileinfo)
		end
	end

	-- Create a placeholder tag for the 'kind' header for folding purposes, but only for non-scoped tags
	for kind in typeinfo.kinds do
		if has_key(get(typeinfo, 'kind2scope', {}), kind.short) then
			continue
		end

		local curtags = filter(copy(fileinfo.getTags()), 'v:val.fields.kind ==# kind.short && ' .. '!has_key(v:val, "scope")')
		print('Processing kind: ' .. kind.short .. ', number of tags: ' .. #curtags)

		if empty(curtags) then
			continue
		end

		local kindtag    = prototypes#kindheadertag#new(kind.long)
		kindtag.short    = kind.short
		kindtag.numtags  = #curtags
		kindtag.fileinfo = fileinfo

		for tag in curtags do
			tag.parent = kindtag
		end
	end

	-- Clear old folding information from previous file version to prevent leaks
	fileinfo.clearOldFolds()
	fileinfo.sortTags(typeinfo)

	known_files.put(fileinfo)
end

function ExecuteCtagsOnFile(fname, realfname, typeinfo)
	print('ExecuteCtagsOnFile called [' .. fname .. ']')

	local ctags_args = {
		'--extras=+F',
		'-f',
		'-',
		'--format=2',
		'--excmd=pattern',
		'--fields=nksSafet',
		'--sort=no',
		'--append=no'
	}

	-- Third-party programs may not necessarily make use of this
	local ctags_type = typeinfo.ctagstype

	local ctags_kinds = ''
	for kind in typeinfo.kinds do
		if kind.short ~= '?' then
			ctags_kinds = ctags_kinds .. kind.short
		end
	end

	table.insert(ctags_args, '--language-force=' .. ctags_type)
	table.insert(ctags_args, '--' .. ctags_type .. '-kinds=' .. ctags_kinds)

	ctags_cmd = EscapeCtagsCmd(ctags_args, fname)

	local ctags_output = ExecuteCtags(ctags_cmd)

	print('Ctags executed successfully')
	print(ctags_output)

	return ctags_output
end

-- Structure of a tag line:
-- tagname<TAB>filename<TAB>expattern;"fields
-- fields: <TAB>name:value
-- fields that are always present: kind, line
function ParseTagline(part1, part2, typeinfo, fileinfo)
	local basic_info  = split(part1, '\t')
	local tagname  = basic_info[1]
	local filename = basic_info[2]

	-- the pattern can contain tabs and thus may have been split up, so join the rest of the items together again
	local pattern = join(basic_info[2:], "\t")
	if pattern[1] == '/' then
		local start   = 2 -- skip the slash and the ^
		local finish  = #pattern - 1

		if pattern[finish - 1] == '$' then
		finish = finish - 1
		dollar = '\$'
	else
		dollar = ''
	end

		pattern = '\V\^\C' .. strpart(pattern, start, finish - start) .. dollar
	else
		pattern = ''
	end

	-- When splitting fields make sure not to create empty keys or values in
	-- case a value illegally contains tabs
	local fields = split(part2, '^\t\|\t\ze\w\+:')
	local fielddict = {}
	if fields[0] !~# ':' then
		fielddict.kind = remove(fields, 0)
	end

	for field in fields do
		-- can't use split() since the value can contain ':'
		local delimit = stridx(field, ':')
		local key = strpart(field, 0, delimit)

		-- Remove all tabs that may illegally be in the value
		lcocal val = substitute(strpart(field, delimit + 1), '\t', '', 'g')

		-- File-restricted scoping
		if key ==# 'file' then
			fielddict[key] = 'yes'
		end

		if #val > 0 then
			if key == 'line' or key == 'column' or key == 'end' then
			fielddict[key] = str2nr(val)
		else
			let fielddict[key] = val
		end
	end
end

-- If the tag covers multiple scopes, split it up and create individual tags
-- for each scope so that the hierarchy can be displayed correctly.
-- This can happen with PHP's 'namespace' tags in uctags, for example.
if has_key(typeinfo, 'kind2scope') and has_key(typeinfo.kind2scope, fielddict.kind) and tagname =~# '\V' .. escape(typeinfo.sro, '\\') then
	local tagparts = split(tagname, '\V' .. escape(typeinfo.sro, '\\'))

	local scope = typeinfo.kind2scope[fielddict.kind]
	if has_key(fielddict, scope) then
		parent = fielddict[scope]
	else
		parent = ''
	end

	local curfielddict = fielddict

	for i = 0, #tagparts do
		local part = tagparts[i]
		ProcessTag(part, filename, pattern, curfielddict, i ~= len(tagparts) - 1, typeinfo, fileinfo)
		if parent ~= '' then
			parent = parent .. typeinfo.sro .. part
		else
			parent = part
		end

		curfielddict = copy(fielddict)
		curfielddict[scope] = parent
	end
else
	ProcessTag(tagname, filename, pattern, fielddict, 0, typeinfo, fileinfo)
end
end

function ProcessTag(name, filename, pattern, fields, is_split, typeinfo, fileinfo)
	if is_split then
		taginfo = tagbar#prototypes#splittag#new(name)
	else
		taginfo = tagbar#prototypes#normaltag#new(name)
	end

	taginfo.file    = filename
	taginfo.pattern = pattern
	extend(taginfo.fields, fields)

	-- Needed for jsctags
	if has_key(taginfo.fields, 'lineno') then
		taginfo.fields.line = str2nr(taginfo.fields.lineno)
	end

	-- Do some sanity checking in case ctags reports invalid line numbers
	if taginfo.fields.line < 0 then
		taginfo.fields.line = 0
	end

	-- Make sure our 'end' is valid
	if taginfo.fields.end < taginfo.fields.line then
		if typeinfo.getKind(taginfo.fields.kind).stl then
			-- the config indicates this is a scoped kind due to 'stl', but we
			-- don't have scope vars, assume scope goes to end of file. This
			-- can also be the case for exhuberant ctags which doesn't support
			-- the --fields=e option.
			-- When we call the GetNearbyTag(), it will look up for the nearest
			-- tag, so if we have multiples that have scope to the end of the
			-- file it will still only grab the first one above the current line
			taginfo.fields.end = line('$')
		else
			taginfo.fields.end = taginfo.fields.line
		end
	end

	if not has_key(taginfo.fields, 'kind') then
		print("Warning: No 'kind' field found for tag " .. name[0] .. '!')
		if index(warnings.type, typeinfo.ftype) == -1 then
			warning("No 'kind' field found for tag " .. name[0] .. '!' .. " Please read the last section of ':help tagbar-extend'.")
			add(warnings.type, typeinfo.ftype)
		end
		return
	end

	taginfo.fileinfo = fileinfo
	taginfo.typeinfo = typeinfo

	fileinfo.fline[taginfo.fields.line] = taginfo

	if has_key(taginfo.fields, 'typeref') then
		local typeref = taginfo.fields.typeref
		local delimit = stridx(typeref, ':')
		local key = strpart(typeref, 0, delimit)

		if key == 'typename' then
			taginfo.data_type = substitute(strpart(typeref, delimit + 1), '\t', '', 'g')
		else
			taginfo.data_type = key
		end
	end

	-- If this filetype doesn't have any scope information then we can stop here after adding the tag to the list
	if not has_key(typeinfo, 'scope2kind') then
		fileinfo.addTag(taginfo)
		return
	end

	-- Make some information easier accessible
	for scope in keys(typeinfo.scope2kind) do
		if has_key(taginfo.fields, scope) then
			taginfo.scope = scope
			taginfo.path  = taginfo.fields[scope]

			taginfo.fullpath = taginfo.path . a:typeinfo.sro .. taginfo.name
			break
		end
	end

	local pathlist = split(taginfo.path, '\V' .. escape(typeinfo.sro, '\\'))
	taginfo.depth = #pathlist

	-- Needed for folding
	taginfo.initFoldState(known_files)

	add_tag_recursive({}, taginfo, pathlist)
end

-- Add a tag recursively as a child of its parent, or if there is no parent, to
-- the root tag list in the fileinfo object.
function add_tag_recursive(parent, taginfo, pathlist) then
	-- If the pathlist is empty we are at the correct scope for the current tag
	if empty(pathlist) then
		-- If a child tag got processed before a parent tag then there will
		-- be a pseudotag here as a placeholder. Copy the children over and
		-- then replace the pseudotag with the real one.
		local pseudotags = {}
		if empty(parent) then
			name_siblings = taginfo.fileinfo.getTagsByName(taginfo.name)
		else
			name_siblings = parent.getChildrenByName(taginfo.name)
		end

		-- Consider a tag as replaceable if the current tag is considered to have more appropriate information
		for tag in name_siblings do
			if (tag.fields.kind == '?' or tag.fields.kind == taginfo.fields.kind) and
				(tag.isPseudoTag() or (not taginfo.isSplitTag() and tag.isSplitTag())) then
				add(pseudotags, tag)
			end
		end

		if #pseudotags == 1 then
			pseudotag = pseudotags[0]
			for child in pseudotag.getChildren() do
				taginfo.addChild(child)
				child.parent = taginfo
			end

			if empty(parent) then
				taginfo.fileinfo.removeTag(pseudotag)
			else
				parent.removeChild(pseudotag)
			end

		elseif #pseudotags > 1 then
			print('found duplicate pseudotag: ' .. pseudotag.name)
		end

		-- If this is a tag that got created due to splitting up a tag name, don't replace existing tags of the same kind.
		if taginfo.isSplitTag() then
			for tag in name_siblings do
				if tag.fields.kind == taginfo.fields.kind then
					return
				end
			end
		end

		if empty(parent) then
			taginfo.fileinfo.addTag(taginfo)
		else
			parent.addChild(taginfo)
			taginfo.parent = parent
		end

		return
	end

	-- There is still at least one more scope between the current one and the
	-- one of the current tag, so we have to either find or create the intermediate tags
	local grandparent = parent
	local parentname = remove(pathlist, 0)

	if empty(grandparent) then
		name_siblings = taginfo.fileinfo.getTagsByName(parentname)
	else
		name_siblings = grandparent.getChildrenByName(parentname)
	end

	if empty(pathlist) then
		-- If the current tag is a direct child of the parent we're looking for
		-- then we can also filter the parents based on the scope information
		local parents = {}
		for tag in name_siblings do
			if tag.fields.kind == '?' or get(taginfo.typeinfo.kind2scope, tag.fields.kind, '') == taginfo.scope then
				add(parents, tag)
			end
		end
	else
		parents = name_siblings
	end

	if empty(parents) then
		-- No parents found, so either the parent is a pseudotag or it hasn't
		-- been processed yet. Create a pseudotag as a placeholder; if the
		-- actual parent gets processed later it will get replaced.
		if empty(pathlist) then
			pseudokind = taginfo.typeinfo.scope2kind[taginfo.scope]
		else
			pseudokind = '?'
		end

		parent = create_pseudotag(parentname, grandparent, pseudokind, taginfo.typeinfo, taginfo.fileinfo)
		if empty(grandparent) then
			taginfo.fileinfo.addTag(parent)
		else
			grandparent.addChild(parent)
		end

	elseif #parents == 1 then
		parent = parents[0]
	else
		-- If there are multiple possible parents (c.f. issue #139, or tags
		-- with the same name but a different kind) then we will pick the one
		-- that is closest above the current tag as a heuristic.

		-- Start at line 0 so that pseudotags get included
		local minline = 0
		for candidate in parents do
			-- If the line number of the current tag is 0 then we have no way
			-- of determining the best candidate by comparing line numbers.
			-- Just use the first one we have.
			if taginfo.fields.line == 0 then
				parent = candidate
				break
			end

			if candidate.fields.line <= taginfo.fields.line and candidate.fields.line >= minline then
				parent = candidate
				minline = candidate.fields.line
			end
		end

		if not exists('parent') then
			-- If we still haven't found a parent it must be below the current
			-- tag, so find the closest parent below the tag. This can happen for example in Go.
			local maxline = line('$')
			for candidate in parents do
				if candidate.fields.line >= taginfo.fields.line and candidate.fields.line <= maxline then
					parent = candidate
					maxline = candidate.fields.line
				end
			end
		end
	end

	-- If the parent is a pseudotag it may have gotten created as an in-between
	-- tag without proper information about its kind because all if its
	-- children are also pseudotags, so it may be incorrect. If the current tag
	-- is a direct child of a pseudotag then we can derive the correct kind, so replace it if necessary.
	if parent.isPseudoTag() and empty(pathlist) then
		parentkind = taginfo.typeinfo.scope2kind[taginfo.scope]
		if parent.fields.kind == '?' or parentkind ~= parent.fields.kind then
			parent.fields.kind = parentkind
			parent.initFoldState(known_files)
		end
	end

	add_tag_recursive(parent, taginfo, pathlist)
end

function create_pseudotag(name, parent, kind, typeinfo, fileinfo)
	if not empty(parent) then
		curpath = parent.fullpath
		-- If the kind is not present in the kind2scope dictionary, return an
		-- empty scope. This can happen due to incorrect ctags output as in #397.
		pscope  = get(typeinfo.kind2scope, parent.fields.kind, '')
	else
		curpath = ''
		pscope  = ''
	end

	local pseudotag = tagbar#prototypes#pseudotag#new(name)
	pseudotag.fields.kind = kind

	local parentscope = substitute(curpath, '\V' .. name .. '$', '', '')
	parentscope = substitute(parentscope, '\V\^' .. escape(typeinfo.sro, '\') . '\$', '', '')

	if pscope ~= '' then
		pseudotag.fields[pscope] = parentscope
		pseudotag.scope = pscope
		pseudotag.path = parentscope
		pseudotag.fullpath = pseudotag.path .. typeinfo.sro .. pseudotag.name
	end

	pseudotag.depth = #(split(pseudotag.path, '\V' .. escape(typeinfo.sro, '\\')))
	pseudotag.parent = parent
	pseudotag.fileinfo = fileinfo
	pseudotag.typeinfo = typeinfo

	pseudotag.initFoldState(known_files)

	return pseudotag
end

function RenderContent(fileinfo)
	print('RenderContent called')

	if empty(fileinfo) then
		print('Empty fileinfo, returning')
		return
	end

	local tagbarwinnr = bufwinnr(TagbarBufName())

	if vim.b.filetype == 'tagbar' then
		in_tagbar = 1
	else
		in_tagbar = 0
		local prevwinnr = winnr()

		-- Get the previous window number, so that we can reproduce
		-- the window entering history later. Do not run autocmd on
		-- this command, make sure nothing is interfering.
		-- let pprevwinnr = winnr('#') " Messes up windows for some reason
		win_gotoid('p', 1)
		pprevwinnr = winnr()
		win_gotoid(tagbarwinnr, 1)
	end

	if not empty(tagbar#state#get_current_file(0)) and fileinfo.fpath == tagbar#state#get_current_file(0).fpath then
		-- We're redisplaying the same file, so save the view
		print('Redisplaying file [' .. fileinfo.fpath .. ']')
		local saveline = line('.')
		local savecol  = col('.')
		local topline  = line('w0')
	end

	local lazyredraw_save = vim.go.lazyredraw
	vim.go.lazyredraw = true
	local eventignore_save = vim.goj.eventignore
	vim.go.eventignore = "all"

	vim.b.modifiable = true

	vim.api.nvim_command("silent %delete _")

	typeinfo = fileinfo.typeinfo

	if fileinfo.fsize_exceeded == 1 then
		if tagbar_compact then
			silent 0put ='\" File size [' .. fileinfo.fsize .. 'B] exceeds limit'
		else
			put ='\" File size exceeds defined limit'
			put ='\"   File Size [' .. fileinfo.fsize .. ' bytes]'
			put ='\"   Limit     [0 bytes]'
			put ='\" Use TagbarForceUpdate override'
		end
	elseif not empty(fileinfo.getTags()) then
		-- Print tags
		PrintKinds(typeinfo, fileinfo)
	else
		print('No tags found, skipping printing.')
		if tagbar_compact then
			silent 0put ='\" No tags found.'
		else
			silent  put ='\" No tags found.'
		end
	end

	-- Delete empty lines at the end of the buffer
	for linenr in range(line('$'), 1, -1) do
		if getline(linenr) =~# '^$' then
			execute 'silent ' .. linenr .. 'delete _'
		else
			break
		end
	end

	vim.b.modifiable = false

	if not empty(tagbar#state#get_current_file(0)) and fileinfo.fpath == tagbar#state#get_current_file(0).fpath then
		local scrolloff_save = vim.w.scrolloff
		vim.w.scrolloff = 0

		cursor(topline, 1)
		vim.api.nvim_command("normal! zt")
		cursor(saveline, savecol)

		vim.w.scrolloff = scrolloff_save
	else
		-- Make sure as much of the Tagbar content as possible is shown in the window by jumping to the top after drawing
		vim.api.nvim_command("1")
		winline()

		-- Invalidate highlight cache from old file
		last_highlight_tline = 0
	end

	vim.go.lazyredraw  = lazyredraw_save
	vim.go.eventignore = eventignore_save

	if not in_tagbar then
		win_gotoid(pprevwinnr)
		win_gotoid(prevwinnr)
	end
end

function PrintKinds(typeinfo, fileinfo)
	print('PrintKinds called')

	-- If the short or long help is being displayed then the line numbers don't
	-- match up with the length of the output list
	local offset = tagbar_compact  ? 0 : line('.')
	local output = {}

	for kind in typeinfo.kinds do
		local curtags = filter(copy(fileinfo.getTags()), 'v:val.fields.kind ==# kind.short')
		print('Printing kind: ' .. kind.short .. ', number of (top-level) tags: ' .. #curtags)

		if empty(curtags) then
			continue
		end

		if has_key(get(typeinfo, 'kind2scope', {}), kind.short) then
			-- Scoped tags
			for tag in curtags do
				PrintTag(tag, 0, output, fileinfo, typeinfo)

				if tagbar_compact ~= 1 then
					add(output, '')
				end
			end
		else
			-- Non-scoped tags
			local kindtag = curtags[0].parent

			if kindtag.isFolded() then
				foldmarker = tagbar.icon_closed
			else
				foldmarker = tagbar.icon_open
			end

			local padding = ' '

			curline                 = #(output) + offset
			kindtag.tline           = curline
			fileinfo.tline[curline] = kindtag

			if not kindtag.isFolded() then
				for tag in curtags do
					local str = tag.strfmt()
					add(output, repeat(' ', tagbar.indent) .. str)

					-- Save the current tagbar line in the tag for easy highlighting access
					curline                 = #output + offset
					tag.tline               = curline
					fileinfo.tline[curline] = tag
				end
			end

			if tagbar_compact ~= 1 then
				add(output, '')
			end
		end
	end

	outstr = join(output, "\n")
	if tagbar_compact then
		silent 0put =outstr
	else
		silent  put =outstr
	end
end

function PrintTag(tag, depth, output, fileinfo, typeinfo)
	-- Print tag indented according to depth
	local tagstr = repeat(' ', depth * tagbar.indent) .. tag.strfmt()
	add(output, tagstr)

	-- Save the current tagbar line in the tag for easy highlighting access
	local offset = tagbar_compact ? 0 : line('.')
	local curline                 = #output + offset
	local tag.tline               = curline
	local fileinfo.tline[curline] = tag

	-- Recursively print children
	if tag.isFoldable() and not tag.isFolded() then
		for ckind in typeinfo.kinds do
			local childfilter = 'v:val.fields.kind ==# ckind.short'

			local childtags = filter(copy(tag.getChildren()), childfilter)
			if #childtags > 0 then
				-- Print 'kind' header of following children, but only if they
				-- are not scope-defining tags (since those already have an identifier)
				if not has_key(typeinfo.kind2scope, ckind.short) then
					local indent = (depth + 1) * tagbar.indent + 2 -- fold symbol

					add(output, repeat(' ', indent) .. '[' .. ckind.long .. ']')
					-- Add basic tag to allow folding when on the header line
					local headertag = tagbar#prototypes#basetag#new(ckind.long)
					headertag.parent = tag
					headertag.fileinfo = tag.fileinfo
					fileinfo.tline[#output + offset] = headertag
				end

				for childtag in childtags do
					PrintTag(childtag, depth + 1, output, fileinfo, typeinfo)
				end
			end
		end
	end
end

-- The gist of this function was taken from NERDTree by Martin Grenfell.
function RenderKeepView(...)
	if a:0 == 1 then
		let line = a:1
	else
		let line = line('.')
	end

	local curcol  = col('.')
	local topline = line('w0')

	RenderContent()

	local scrolloff_save = vim.wo.scrolloff
	vim.wo.scrolloff = 0

	cursor(topline, 1)
	vim.api.nvim_command("normal! zt")
	cursor(line, curcol)

	vim.wo.srolloff = scrolloff_save

	vim.api.nvim_command("redraw")
end

function HighlightTag(openfolds, ...)
	local tagline = 0
	local force = a:0 > 0 ? a:1 : 0

	if a:0 > 1 then
		tag = GetNearbyTag(tagbar_highlight_method, 0, a:2)
	else
		tag = GetNearbyTag(tagbar_highlight_method, 0)
	end

	if not empty(tag) then
		tagline = tag.tline
	end

	-- Don't highlight the tag again if it's the same one as last time.
	-- This prevents the Tagbar window from jumping back after scrolling with the mouse.
	if not force and tagline == last_highlight_tline then
		return
	else
		last_highlight_tline = tagline
	end

	local tagbarwinnr = bufwinnr(TagbarBufName())
	if tagbarwinnr == -1 then
		return
	end

	if tagbarwinnr == winnr() then
		in_tagbar = 1
	else
		in_tagbar = 0
		prevwinnr = winnr()
		win_gotoid('p')
		pprevwinnr = winnr()
		win_gotoid(tagbarwinnr)
	end

	vim.api.nvim_command("match none")

	-- No tag above cursor position so don't do anything
	if tagline == 0 then
		return
	end

	if openfolds then
		OpenParents(tag)
	end

	-- Check whether the tag is inside a closed fold and highlight the parent instead in that case
	tagline = tag.getClosedParentTline()

	-- Parent tag line number is invalid, better don't do anything
	if tagline <= 0 then
		return
	end

	-- Go to the line containing the tag
	vim.api.nvim_command(tagline)

	-- Make sure the tag is visible in the window
	winline()

	local foldpat = '[' .. tagbar.icon_open .. tagbar.icon_closed .. ' ]'

	-- If printing the line number of the tag to the left, and the tag is visible (I.E. parent isn't folded)
	local identifier = '\zs\V' .. escape(tag.name, '/\\') .. '\m\ze'

	print("Highlight pattern: '" .. pattern .. "'")

	-- Safeguard in case syntax highlighting is disabled
	if hlexists('TagbarHighlight') then
		execute 'match TagbarHighlight ' .. pattern
	else
		execute 'match Search ' .. pattern
	end

	if not in_tagbar then
		win_gotoid(pprevwinnr)
		win_gotoid(prevwinnr)
	end

	vim.api.nvim_command("redraw")
end

function JumpToTag(stay_in_tagbar)
	local taginfo = GetTagInfo(line('.'), 1)

	if empty(taginfo) or not taginfo.isNormalTag() then
		return
	end

	local tagbarwinnr = winnr()

	GotoFileWindow(taginfo.fileinfo)

	-- Mark current position so it can be jumped back to
	vim.api.nvim_command("mark '")

	-- Check if the tag is already visible in the window.  We must do this before jumping to the line.
	-- Jump to the line where the tag is defined. Don't use the search pattern
	-- since it doesn't take the scope into account and thus can fail if tags
	-- with the same name are defined in different scopes (e.g. classes)
	print('Jumping to line ' .. taginfo.fields.line)
	vim.api.nvim_command(taginfo.fields.line)

	-- If the file has been changed but not saved, the tag may not be on the
	-- saved line anymore, so search for it in the vicinity of the saved line
	if taginfo.pattern ~= '' then
		print('Searching for pattern "' .. taginfo.pattern .. '"')
		if match(getline('.'), taginfo.pattern) == -1 then
			local interval = 1
			local forward  = 1
			while search(taginfo.pattern, 'W' .. forward ? '' : 'b') == 0 do
				if not forward then
					if interval > line('$') then
						break
					else
						interval = interval * 2
					end
				end

				forward = not forward
			end
		end
	end

	-- If the tag is on a different line after unsaved changes update the tag and file infos/objects
	curline = line('.')
	if taginfo.fields.line ~= curline then
		taginfo.fields.line = curline
		taginfo.fileinfo.fline[curline] = taginfo
	end

	-- Center the tag in the window and jump to the correct column if
	-- available, otherwise try to find it in the line
	vim.api.nvim_command("normal! z.")

	if taginfo.fields.column > 0 then
		cursor(taginfo.fields.line, taginfo.fields.column)
	else
		cursor(taginfo.fields.line, 1)
		search('\V' . taginfo.name, 'c', line('.'))
	end

	vim.api.nvim_command("normal! zv")

	if stay_in_tagbar then
		HighlightTag(0)
		win_gotoid(tagbarwinnr)
		vim.api.nvim_command("redraw")
	else
		HighlightTag(0)
	end
end

function ShowPrototype(short)
	local taginfo = GetTagInfo(line('.'), 1)

	if empty(taginfo) then
		return ''
	end

	print(taginfo.getPrototype(short))
end

function ToggleFold()
	local fileinfo = tagbar#state#get_current_file(0)
	if empty(fileinfo) then
		return
	end

	vim.api.nvim_command("match none")

	local curtag = GetTagInfo(line('.'), 0)
	if empty(curtag) then
		return
	end

	local newline = line('.')

	if curtag.isKindheader() then
		curtag.toggleFold(tagbar#state#get_current_file(0))
	elseif curtag.isFoldable() then
		if curtag.isFolded() then
			curtag.openFold()
		else
			newline = curtag.closeFold()
		end
	else
		newline = curtag.closeFold()
	end

	RenderKeepView(newline)
end

function OpenParents(...)
	if a:0 == 1 then
		tag = a:1
	else
		tag = GetNearbyTag('nearest', 0)
	end

	if not empty(tag) then
		tag.openParents()
		RenderKeepView()
	end
end

function UpdateFile(fname)
	print('UpdateFile called [' .. fname .. ']')

	-- This file is being loaded due to a quickfix command like vimgrep, so don't process it
	if exists('s:tagbar_qf_active') then
		return
	elseif exists('s:window_opening') then
		-- This can happen if another plugin causes the active window to change
		-- with an autocmd during the initial Tagbar window creation. In that
		-- case InitWindow() hasn't had a chance to run yet and things can
		-- break. MiniBufExplorer does this, for example. Completely disabling
		-- autocmds at that point is also not ideal since for example
		-- statusline plugins won't be able to update.
		print('Still opening window, stopping processing')
		return
	end

	-- Get the filetype of the file we're about to process
	bufnr = bufnr(fname)
	ftype = getbufvar(bufnr, '&filetype')

	-- Don't do anything if we're in the tagbar window
	if ftype == 'tagbar' then
		print('In Tagbar window, stopping processing')
		return
	end

	print("Vim filetype: " .. ftype)

	-- Don't do anything if the file isn't supported
	if not IsValidFile(fname, sftype) then
		print('Not a valid file, stopping processing')
		nearby_disabled = 1
		return
	end

	local updated = 0

	-- Process the file if it's unknown or the information is outdated.
	-- Testing the mtime of the file is necessary in case it got changed
	-- outside of Vim, for example by checking out a different version from a VCS.
	if known_files.has(fname) then
		local curfile = known_files.get(fname)

		if empty(curfile) or curfile.ftype ~= sftype or
			(filereadable(fname) and getftime(fname) > curfile.mtime) then
			print('File data outdated, updating [' .. fname .. ']')
			ProcessFile(fname, sftype)
			updated = 1
		else
			print('File data seems up to date [' .. fname .. ']')
		end
	else
		print('New file, processing [' .. fname .. ']')
		ProcessFile(fname, sftype)
		updated = 1
	end

	print('UpdateFile finished successfully')
end

-- Assemble the ctags command line in a way that all problematic characters are
-- properly escaped and converted to the system's encoding
-- Optional third parameter is a file name to run ctags on
-- Note: args must always be a list
function EscapeCtagsCmd(args, filename)
	print('EscapeCtagsCmd called')

	local shellslash_save = vim.go.shellslash
	vim.go.shellslash = false

	local ctags_cmd = tagbar.ctags_bin

	for arg in args do
		ctags_cmd = ctags_cmd .. ' ' .. shellescape(arg)
	end

	-- if a filename was specified, add filename as final argument to ctags_cmd.
	ctags_cmd = ctags_cmd .. ' ' .. shellescape(filename)

	vim.go.shellslash = shellslash_save

	print('Escaped ctags command: ' .. ctags_cmd)

	return ctags_cmd
end

-- Execute ctags with necessary shell settings
-- Partially based on the discussion at
-- http://vim.1045645.n5.nabble.com/bad-default-shellxquote-in-Widows-td1208284.html
function ExecuteCtags(ctags_cmd)
	print('Executing ctags command: ' .. ctags_cmd)

	local shellslash_save = vim.go.shellslash
	vim.go.shellslash = false

	if has('win32') then
		local shellxquote_save = vim.go.shellxquote
		local shellcmdflag_save = vim.go.shellcmdflag
		vim.go.shellxquote = "\""
		vim.go.shellcmdflag = "/s /c"
	end

	local ctags_output = system(ctags_cmd)

	if has('win32') then
		vim.go.shellxquote  = shellxquote_save
		vim.go.shellcmdflag = shellcmdflag_save
	end

	vim.go.shellslash = shellslash_save

	return ctags_output
end

-- Get the tag info for a file near the cursor in the current file
function GetNearbyTag(request, forcecurrent, ...)
	if nearby_disabled then
		return {}
	end

	local fileinfo = tagbar#state#get_current_file(forcecurrent)
	if empty(fileinfo) then
		return {}
	end

	local typeinfo = fileinfo.typeinfo
	if a:0 > 0 then
		curline = a:1
	else
		curline = line('.')
	end

	local tag = {}

	-- If a tag appears in a file more than once (for example namespaces in
	-- C++) only one of them has a 'tline' entry and can thus be highlighted.
	-- The only way to solve this would be to go over the whole tag list again,
	-- making everything slower. Since this should be a rare occurence and
	-- highlighting isn't /that/ important ignore it for now.
	for line = curline, 1, -1 do
		if has_key(fileinfo.fline, line) then
			local curtag = fileinfo.fline[line]
			if request == 'nearest-stl' and typeinfo.getKind(curtag.fields.kind).stl then
				tag = curtag
				break
			elseif request == 'scoped-stl' and typeinfo.getKind(curtag.fields.kind).stl and
				curtag.fields.line <= curline and curline <= curtag.fields.end then
				tag = curtag
				break
			elseif request == 'nearest' or line == curline then
				tag = curtag
				break
			end
		end
	end

	return tag
end

-- Return the info dictionary of the tag on the specified line. If the line
-- does not contain a valid tag (for example because it is empty or only
-- contains a pseudo-tag) return an empty dictionary.
function GetTagInfo(linenr, ignorepseudo)
	local fileinfo = tagbar#state#get_current_file(0)

	if empty(fileinfo) then
		return {}
	end

	-- Don't do anything in empty and comment lines
	local curline = getbufline(bufnr(TagbarBufName()), linenr)[0]
	if curline =~# '^\s*$' or curline[0] == '"' then
		return {}
	end

	-- Check if there is a tag on the current line
	if not has_key(fileinfo.tline, linenr) then
		return {}
	end

	local taginfo = fileinfo.tline[linenr]

	-- Check if the current tag is not a pseudo-tag
	if ignorepseudo and taginfo.isPseudoTag() then
		return {}
	end

	return taginfo
end

-- Try to switch to the window that has Tagbar's current file loaded in it, or
-- open the file in an existing window otherwise.
function GotoFileWindow(fileinfo)
	local filewinnr = 0
	local prevwinnr = winnr('#')

	if winbufnr(prevwinnr) == fileinfo.bufnr and not getwinvar(prevwinnr, '&previewwindow') then
		filewinnr = prevwinnr
	else
		-- Search for the first real window that has the correct buffer loaded
		-- in it. Similar to bufwinnr() but skips the previewwindow.
		for i = 1, winnr('$') do
			win_gotoid(i)
			if bufnr('%') == fileinfo.bufnr and not vim.w.previewwindow then
				filewinnr = winnr()
				break
			end
		end

		win_gotoid(bufwinnr(TagbarBufName()))
	end

	-- If there is no window with the correct buffer loaded then load it
	-- into the first window that has a non-special buffer in it.
	if filewinnr == 0 then
		for i = 1, winnr('$') do
			win_gotoid(i)
			if &buftype == '' and not vim.w.previewwindow then
				vim.api.nvim_command('buffer ' .. fileinfo.bufnr)
				break
			end
		end
	else
		win_gotoid(filewinnr)
	end

	-- To make ctrl-w_p work we switch between the Tagbar window and the correct window once
	win_gotoid(bufwinnr(TagbarBufName()))
	win_gotoid('p')
end

function IsValidFile(fname, ftype)
	print('Checking if file is valid [' .. fname .. ']')

	if fname == '' or ftype == '' then
		print('Empty filename or type')
		return 0
	end

	if not filereadable(fname) and getbufvar(fname, 'netrw_tmpfile') == '' then
		print('File not readable')
		return 0
	end

	if getbufvar(fname, 'tagbar_ignore') == 1 then
		print('File is marked as ignored')
		return 0
	end

	local winnr = bufwinnr(fname)
	if winnr ~= -1 and getwinvar(winnr, '&diff') then
		print('Window is in diff mode')
		return 0
	end

	if &previewwindow then
		print('In preview window')
		return 0
	end

	if not has_key(known_types, ftype) then
		print('Unsupported filetype: ' .. ftype)
		return 0
	end

	return 1
end

function HandleBufDelete(bufname, bufnr)
	-- Ignore autocmd events generated for "set nobuflisted",
	local nr = str2nr(bufnr)
	if bufexists(nr) and not buflisted(nr) then
		return
	end

	known_files.rm(fnamemodify(bufname, ':p'))

	local tagbarwinnr = bufwinnr(TagbarBufName())
	if tagbarwinnr == -1 or bufname =~# '__Tagbar__.*' then
		return
	end

	if not HasOpenFileWindows() then
		if tabpagenr('$') == 1 and exists('t:tagbar_buf_name') then
			-- The last normal window closed due to a :bdelete/:bwipeout.
			-- In order to get a normal file window back switch to the last
			-- alternative buffer (or a new one if there is no alternative
			-- buffer), reset the Tagbar-set window options, and then re-open
			-- the Tagbar window.

			-- Ignore the buffer to be deleted, just in case
			setbufvar(bufname, 'tagbar_ignore', 1)

			if last_alt_bufnr == -1 or last_alt_bufnr == expand('<abuf>') then
				if argc() > 1 and argidx() < argc() - 1 then
					-- We don't have an alternative buffer, but there are still files left in the argument list
					vim.api.nvim_command('next')
				else
					vim.api.nvim_command('enew')
				end
			else
				-- Save a local copy as the global value will change during buffer switching
				local prev_alt_bufnr = last_alt_bufnr

				-- Ignore the buffer we're switching to for now, it will get processed due to the OpenWindow() call anyway
				setbufvar(prev_alt_bufnr, 'tagbar_ignore', 1)
				execute 'keepalt buffer' prev_alt_bufnr
				setbufvar(prev_alt_bufnr, 'tagbar_ignore', 0)
			end

			-- Reset Tagbar window-local options
			vim.wo.winfixwidth = true

			OpenWindow('')
		elseif exists('t:tagbar_buf_name') then
			vim.api.nvim_command('close')
		end
	end
end

function HandleBufWrite(fname)
	if index(delayed_update_files, fname) == -1 then
		add(delayed_update_files, fname)
	end
end

function do_delayed_update()
	local curfile = tagbar#state#get_current_file(0)
	if empty(curfile) then
		curfname = ''
	else
		curfname = curfile.fpath
	end

	while not empty(delayed_update_files) do
		local fname = remove(delayed_update_files, 0)
		local no_display = curfname ~= fname
		UpdateFile(fname)
	end
end

function HasOpenFileWindows()
	for i = 1, winnr('$') do
		local buf = winbufnr(i)

		-- skip unlisted buffers, except for netrw
		if not buflisted(buf) and getbufvar(buf, '&filetype') ~= 'netrw' then
			continue
		end

		-- skip temporary buffers with buftype set
		if getbufvar(buf, '&buftype') ~= '' then
			continue
		end

		-- skip the preview window
		if getwinvar(i, '&previewwindow') then
			continue
		end

		return 1
	end

	return 0
end

function TagbarBufName()
	if not exists('t:tagbar_buf_name') then
		buffer_seqno = buffer_seqno + 1
		vim.t.tagbar_buf_name = '__Tagbar__.' .. buffer_seqno
	end

	return tagbar_buf_name
end

-- Go to a previously marked window and delete the mark.
function goto_markedwin(...)
	for window = 1, winnr('$') do
		win_gotoid(window)
		if exists('w:tagbar_mark') then
			vim.w.tagbar_mark = nil
			break
		end
	end
end

-- Script-local variable needed since compare functions can't take additional arguments
local compare_typeinfo = {}

function tagbar.sorting.sort(tags, compareby, compare_typeinfo)
    local comparemethod = compareby == 'kind' ? 's:compare_by_kind' : 's:compare_by_line'

    sort(tags, comparemethod)

    for tag in tags do
        if not empty(tag.getChildren()) then
            tagbar#sorting#sort(tag.getChildren(), compareby, compare_typeinfo)
        end
    end
end

function compare_by_kind(tag1, tag2)
    local typeinfo = compare_typeinfo

    if not has_key(typeinfo.kinddict, tag1.fields.kind) then
        return -1
    end

    if not has_key(typeinfo.kinddict, tag2.fields.kind) then
        return 1
    end

    if typeinfo.kinddict[tag1.fields.kind] < typeinfo.kinddict[tag2.fields.kind] then
        return -1
    elseif typeinfo.kinddict[tag1.fields.kind] > typeinfo.kinddict[tag2.fields.kind]
        return 1
    else
        -- Ignore '~' prefix for C++ destructors to sort them directly under the constructors
        if tag1.name[0] == '~' then
            name1 = tag1.name[1:]
        else
            name1 = tag1.name
        end

        if tag2.name[0] == '~' then
            name2 = tag2.name[1:]
        else
            name2 = tag2.name
        end

        local ci = tagbar_case_insensitive
        if (((!ci) and (name1 <= name2)) or (ci and (name1 <= name2))) then
            return -1
        else
            return 1
        end
    end
end

function compare_by_line(tag1, tag2)
    return tag1.fields.line - tag2.fields.line
end

function tagbar.state.get_current_file(force_current)
    return get().getCurrent(force_current)
end

function tagbar.state.set_current_file(fileinfo)
    get().setCurrentFile(fileinfo)
end

function tagbar.state.set_paused()
    get().setPaused()
end

function get()
    if not exists('t:tagbar_state') then
        vim.t.tagbar_state = State.New()
    end

    return vim.t.tagbar_state
end

local State = {
    _current = {},
    _paused  = {},
}

function State.New()
    return deepcopy(self)
end

function State.getCurrent(force_current)
    if not tagbar.is_paused() or force_current then
        return self._current
    else
        return self._paused
    end
end

function State.setCurrentFile(fileinfo)
    self._current = fileinfo
end

function State.setPaused()
    self._paused = self._current
end

return tagbar
