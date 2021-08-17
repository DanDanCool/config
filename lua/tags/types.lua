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

types.lpc = types.c

types.cpp = {}
types.cpp.ctagstype = 'c++'
types.cpp.kinds = {
	h = 'header files',
	d = 'macros',
	p = 'prototypes',
	g = 'enums',
	e = 'enumerators',
	t = 'typedefs',
	n = 'namespaces',
	c = 'classes',
	s = 'structs',
	u = 'unions',
	f = 'functions',
	m = 'members',
	v = 'variables',
}

types.cpp.sro = '::'
types.cpp.scope = {
	g = 'enum',
	n = 'namespace',
	c = 'class',
	s = 'struct',
	u = 'union',
	enum = 'g',
	namespace = 'n',
	class = 'c',
	struct = 's',
	union = 'u'
}

types.cpp.member = {
	e = 'enumberators',
	m = 'members'
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
