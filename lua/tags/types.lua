-- Type definitions for Universal Ctags
local types = {}

types.c = {}
types.c.ctagstype = 'c'
types.c.kinds     = {
	h = 'header files',
	d = 'macros',
	p = 'prototypes',
	g = 'enums',
	e = 'enumerators',
	t = 'typedefs',
	s = 'structs',
	u = 'unions',
	m = 'members',
	v = 'variables',
	f = 'functions'
}

types.c.sro        = '::'
types.c.scope = {
	g = 'enum',
	s = 'struct',
	u = 'union',
	enum	= 'g',
	struct	= 's',
	union	= 'u'
}

types.c.member = {
	e = 'enumerators',
	m = 'members'
}

types.c.scope2kind = {
	enum   = 'g',
	struct = 's',
	union  = 'u'
}

types.lpc = types.c

types.cpp = {}
types.cpp.ctagstype = 'c++'
types.cpp.kinds = {
	{short = 'h', long = 'header files', fold = 1,  stl = 0},
	{short = 'd', long = 'macros',       fold = 1,  stl = 0},
	{short = 'p', long = 'prototypes',   fold = 1,  stl = 0},
	{short = 'g', long = 'enums',        fold = 0,  stl = 1},
	{short = 'e', long = 'enumerators',  fold = 0,  stl = 0},
	{short = 't', long = 'typedefs',     fold = 0,  stl = 0},
	{short = 'n', long = 'namespaces',   fold = 0,  stl = 1},
	{short = 'c', long = 'classes',      fold = 0,  stl = 1},
	{short = 's', long = 'structs',      fold = 0,  stl = 1},
	{short = 'u', long = 'unions',       fold = 0,  stl = 1},
	{short = 'f', long = 'functions',    fold = 0,  stl = 1},
	{short = 'm', long = 'members',      fold = 0,  stl = 0},
	{short = 'v', long = 'variables',    fold = 0,  stl = 0}
}

types.cpp.sro        = '::'
types.cpp.kind2scope = {
	g = 'enum',
	n = 'namespace',
	c = 'class',
	s = 'struct',
	u = 'union'
}

types.cpp.scope2kind = {
	enum      = 'g',
	namespace = 'n',
	class     = 'c',
	struct    = 's',
	union     = 'u'
}

types.cuda = types.cpp
types.arduino = types.cpp

types.lua = {}
types.lua.ctagstype = 'lua'
types.lua.kinds = {
	f = 'functions'
}

types.lua.scope = {}
types.lua.member = {}

return types
