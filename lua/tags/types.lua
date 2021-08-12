-- Type definitions for Universal Ctags
local types = {}

types.ada = {}
types.ada.ctagstype = 'ada'
types.ada.kinds = {
	{short = 'P', long = 'package specifications',        fold = 0, stl = 1},
	{short = 'p', long = 'packages',                      fold = 0, stl = 0},
	{short = 't', long = 'types',                         fold = 0, stl = 1},
	{short = 'u', long = 'subtypes',                      fold = 0, stl = 1},
	{short = 'c', long = 'record type components',        fold = 0, stl = 1},
	{short = 'l', long = 'enum type literals',            fold = 0, stl = 0},
	{short = 'v', long = 'variables',                     fold = 0, stl = 0},
	{short = 'f', long = 'generic formal parameters',     fold = 0, stl = 0},
	{short = 'n', long = 'constants',                     fold = 0, stl = 0},
	{short = 'x', long = 'user defined exceptions',       fold = 0, stl = 1},
	{short = 'R', long = 'subprogram specifications',     fold = 0, stl = 1},
	{short = 'r', long = 'subprograms',                   fold = 0, stl = 1},
	{short = 'K', long = 'task specifications',           fold = 0, stl = 1},
	{short = 'k', long = 'tasks',                         fold = 0, stl = 1},
	{short = 'O', long = 'protected data specifications', fold = 0, stl = 1},
	{short = 'o', long = 'protected data',                fold = 0, stl = 1},
	{short = 'e', long = 'task/protected data entries',   fold = 0, stl = 1},
	{short = 'b', long = 'labels',                        fold = 0, stl = 1},
	{short = 'i', long = 'loop/declare identifiers',      fold = 0, stl = 1},
}

types.ada.sro = '.' -- Not sure if possible
types.ada.kind2scope = {
	P = 'packspec',
	t = 'type',
}

types.ada.scope2kind = {
	packspec = 'P',
	type     = 't',
}

types.ant = {}
types.ant.ctagstype = 'ant'
types.ant.kinds     = {
	{short = 'p', long = 'projects',   fold = 0, stl = 1},
	{short = 'i', long = 'antfiles',   fold = 0, stl = 0},
	{short = 'P', long = 'properties', fold = 0, stl = 0},
	{short = 't', long = 'targets',    fold = 0, stl = 1}
}

types.asciidoc = {}
types.asciidoc.ctagstype = 'asciidoc'
types.asciidoc.kinds = {
	{short = 'c', long = 'chapter',       fold = 0, stl = 1},
	{short = 's', long = 'section',       fold = 0, stl = 1},
	{short = 'S', long = 'subsection',    fold = 0, stl = 1},
	{short = 't', long = 'subsubsection', fold = 0, stl = 1},
	{short = 'T', long = 'paragraph',     fold = 0, stl = 1},
	{short = 'u', long = 'subparagraph',  fold = 0, stl = 1},
	{short = 'a', long = 'anchor',        fold = 0, stl = 0}
}

types.asciidoc.sro        = '""'
types.asciidoc.kind2scope = {
	c = 'chapter',
	s = 'section',
	S = 'subsection',
	t = 'subsubsection',
	T = 'l4subsection',
	u = 'l5subsection'
}

types.asciidoc.scope2kind = {
	chapter = 'c',
	section = 's',
	subsection = 'S',
	subsubsection = 't',
	l4subsection = 'T',
	l5subsection = 'u'
}

types.asciidoc.sort = 0

types.asm = {}
types.asm.ctagstype = 'asm'
types.asm.kinds     = {
	{short = 'm', long = 'macros',    fold = 0, stl = 1},
	{short = 't', long = 'types',     fold = 0, stl = 1},
	{short = 's', long = 'sections',  fold = 0, stl = 1},
	{short = 'd', long = 'defines',   fold = 0, stl = 1},
	{short = 'l', long = 'labels',    fold = 0, stl = 1}
}

types.aspvbs = {}
types.aspvbs.ctagstype = 'asp'
types.aspvbs.kinds     = {
	{short = 'd', long = 'constants',   fold = 0, stl = 1},
	{short = 'c', long = 'classes',     fold = 0, stl = 1},
	{short = 'f', long = 'functions',   fold = 0, stl = 1},
	{short = 's', long = 'subroutines', fold = 0, stl = 1},
	{short = 'v', long = 'variables',   fold = 0, stl = 1}
}

-- Asymptote gets parsed well using filetype = c
types.asy = {}
types.asy.ctagstype = 'c'
types.asy.kinds = {
	{short = 'd', long = 'macros',      fold = 1, stl = 0},
	{short = 'p', long = 'prototypes',  fold = 1, stl = 0},
	{short = 'g', long = 'enums',       fold = 0, stl = 1},
	{short = 'e', long = 'enumerators', fold = 0, stl = 0},
	{short = 't', long = 'typedefs',    fold = 0, stl = 0},
	{short = 's', long = 'structs',     fold = 0, stl = 1},
	{short = 'u', long = 'unions',      fold = 0, stl = 1},
	{short = 'm', long = 'members',     fold = 0, stl = 0},
	{short = 'v', long = 'variables',   fold = 0, stl = 0},
	{short = 'f', long = 'functions',   fold = 0, stl = 1}
}

types.asy.sro        = '::'
types.asy.kind2scope = {
	g = 'enum',
	s = 'struct',
	u = 'union'
}

types.asy.scope2kind = {
	enum   = 'g',
	struct = 's',
	union  = 'u'
}

types.config = {}
types.config.ctagstype = 'autoconf'
types.config.kinds = {
	{short = 'p', long = 'packages',            fold = 0, stl = 1},
	{short = 't', long = 'templates',           fold = 0, stl = 1},
	{short = 'm', long = 'autoconf macros',     fold = 0, stl = 1},
	{short = 'w', long = '"with" options',      fold = 0, stl = 1},
	{short = 'e', long = '"enable" options',    fold = 0, stl = 1},
	{short = 's', long = 'substitution keys',   fold = 0, stl = 1},
	{short = 'c', long = 'automake conditions', fold = 0, stl = 1},
	{short = 'd', long = 'definitions',         fold = 0, stl = 1}
}

types.automake = {}
types.automake.ctagstype = 'automake'
types.automake.kinds = {
	{short = 'I', long = 'makefiles',   fold = 0, stl = 1},
	{short = 'd', long = 'directories', fold = 0, stl = 1},
	{short = 'P', long = 'programs',    fold = 0, stl = 1},
	{short = 'M', long = 'manuals',     fold = 0, stl = 1},
	{short = 'm', long = 'macros',      fold = 0, stl = 1},
	{short = 't', long = 'targets',     fold = 0, stl = 1},
	{short = 'T', long = 'ltlibraries', fold = 0, stl = 1},
	{short = 'L', long = 'libraries',   fold = 0, stl = 1},
	{short = 'S', long = 'scripts',     fold = 0, stl = 1},
	{short = 'D', long = 'datum',       fold = 0, stl = 1},
	{short = 'c', long = 'conditions',  fold = 0, stl = 1}
}

types.awk = {}
types.awk.ctagstype = 'awk'
types.awk.kinds = {
	{short = 'f', long = 'functions', fold = 0, stl = 1}
}

types.basic = {}
types.basic.ctagstype = 'basic'
types.basic.kinds = {
	{short = 'c', long = 'constants',    fold = 0, stl = 1},
	{short = 'g', long = 'enumerations', fold = 0, stl = 1},
	{short = 'f', long = 'functions',    fold = 0, stl = 1},
	{short = 'l', long = 'labels',       fold = 0, stl = 1},
	{short = 't', long = 'types',        fold = 0, stl = 1},
	{short = 'v', long = 'variables',    fold = 0, stl = 1}
}

types.beta = {}
types.beta.ctagstype = 'beta'
types.beta.kinds = {
	{short = 'f', long = 'fragments', fold = 0, stl = 1},
	{short = 's', long = 'slots',     fold = 0, stl = 1},
	{short = 'v', long = 'patterns',  fold = 0, stl = 1}
}

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

types.cs = {}
types.cs.ctagstype = 'c#'
types.cs.kinds     = {
	{short = 'd', long = 'macros',      fold = 1, stl = 0},
	{short = 'f', long = 'fields',      fold = 0, stl = 1},
	{short = 'g', long = 'enums',       fold = 0, stl = 1},
	{short = 'e', long = 'enumerators', fold = 0, stl = 0},
	{short = 't', long = 'typedefs',    fold = 0, stl = 1},
	{short = 'n', long = 'namespaces',  fold = 0, stl = 1},
	{short = 'i', long = 'interfaces',  fold = 0, stl = 1},
	{short = 'c', long = 'classes',     fold = 0, stl = 1},
	{short = 's', long = 'structs',     fold = 0, stl = 1},
	{short = 'E', long = 'events',      fold = 0, stl = 1},
	{short = 'm', long = 'methods',     fold = 0, stl = 1},
	{short = 'p', long = 'properties',  fold = 0, stl = 1}
}

types.cs.sro        = '.'
types.cs.kind2scope = {
	n = 'namespace',
	i = 'interface',
	c = 'class',
	s = 'struct',
	g = 'enum'
}

types.cs.scope2kind = {
	namespace = 'n',
	interface = 'i',
	class     = 'c',
	struct    = 's',
	enum      = 'g'
}

types.clojure = {}
types.clojure.ctagstype = 'clojure'
types.clojure.kinds     = {
	{short = 'n', long = 'namespace', fold = 0, stl = 1},
	{short = 'f', long = 'function',  fold = 0, stl = 1}
}

types.clojure.sro = '.'
types.clojure.kind2scope = {
	n = 'namespace',
}

types.clojure.scope2kind = {
	namespace = 'n'
}

types.cmake = {}
types.cmake.ctagstype = 'cmake'
types.cmake.kinds     = {
	{short = 'p', long = 'projects' , fold = 0, stl = 1},
	{short = 'm', long = 'macros'   , fold = 0, stl = 1},
	{short = 'f', long = 'functions', fold = 0, stl = 1},
	{short = 'D', long = 'options'  , fold = 0, stl = 1},
	{short = 'v', long = 'variables', fold = 0, stl = 1},
	{short = 't', long = 'targets'  , fold = 0, stl = 1}
}

types.cmake.sro = '.'
types.cmake.kind2scope = {
	f = 'function',
}

types.cmake.scope2kind = {
	func = 'f',
}

types.ctags = {}
types.ctags.ctagstype = 'ctags'
types.ctags.kinds = {
	 {short = 'l', long = 'language definitions', fold = 0, stl = 1},
	 {short = 'k', long = 'kind definitions',     fold = 0, stl = 1}
}

types.ctags.sro        = '.' -- Not actually possible
types.ctags.kind2scope = {
	l = 'langdef'
}

types.ctags.scope2kind = {
	langdef = 'l'
}

types.cobol = {}
types.cobol.ctagstype = 'cobol'
types.cobol.kinds = {
	{short = 'd', long = 'data items',        fold = 0, stl = 1},
	{short = 'D', long = 'divisions',         fold = 0, stl = 1},
	{short = 'f', long = 'file descriptions', fold = 0, stl = 1},
	{short = 'g', long = 'group items',       fold = 0, stl = 1},
	{short = 'p', long = 'paragraphs',        fold = 0, stl = 1},
	{short = 'P', long = 'program ids',       fold = 0, stl = 1},
	{short = 'S', long = 'source code file',  fold = 0, stl = 1},
	{short = 's', long = 'sections',          fold = 0, stl = 1}
}

types.css = {}
types.css.ctagstype = 'css'
types.css.kinds = {
	{short = 's', long = 'selector',   fold = 0, stl = 0},
	{short = 'i', long = 'identities', fold = 1, stl = 0},
	{short = 'c', long = 'classes',    fold = 1, stl = 0}
}

types.d = {}
types.d.ctagstype = 'D'
types.d.kinds = {
	{short = 'M', long = 'modules',              fold = 0, stl = 1},
	{short = 'V', long = 'version statements',   fold = 1, stl = 0},
	{short = 'n', long = 'namespaces',           fold = 0, stl = 1},
	{short = 'T', long = 'templates',            fold = 0, stl = 0},
	{short = 'c', long = 'classes',              fold = 0, stl = 1},
	{short = 'i', long = 'interfaces',           fold = 0, stl = 1},
	{short = 's', long = 'structure names',      fold = 0, stl = 1},
	{short = 'g', long = 'enumeration names',    fold = 0, stl = 1},
	{short = 'e', long = 'enumerators',          fold = 0, stl = 0},
	{short = 'u', long = 'union names',          fold = 0, stl = 1},
	{short = 'p', long = 'function prototypes',  fold = 0, stl = 1},
	{short = 'f', long = 'function definitions', fold = 0, stl = 1},
	{short = 'm', long = 'members',              fold = 0, stl = 1},
	{short = 'a', long = 'aliases',              fold = 1, stl = 0},
	{short = 'X', long = 'mixins',               fold = 0, stl = 1},
	{short = 'v', long = 'variable definitions', fold = 0, stl = 0}
}

types.d.sro = '.'
types.d.kind2scope = {
	g = 'enum',
	n = 'namespace',
	i = 'interface',
	c = 'class',
	s = 'struct',
	u = 'union'
}

types.d.scope2kind = {
	enum      = 'g',
	namespace = 'n',
	interface = 'i',
	class     = 'c',
	struct    = 's',
	union     = 'u'
}

types.dosbatch = {}
types.dosbatch.ctagstype = 'dosbatch'
types.dosbatch.kinds     = {
	{short = 'l', long = 'labels',    fold = 0, stl = 1},
	{short = 'v', long = 'variables', fold = 0, stl = 1}
}

types.eiffel = {}
types.eiffel.ctagstype = 'eiffel'
types.eiffel.kinds = {
	{short = 'c', long = 'classes',  fold = 0, stl = 1},
	{short = 'f', long = 'features', fold = 0, stl = 1}
}

types.eiffel.sro        = '.' -- Not sure, is nesting even possible?
types.eiffel.kind2scope = {
	c = 'class',
	f = 'feature'
}

types.eiffel.scope2kind = {
	class   = 'c',
	feature = 'f'
}

-- based on https://github.com/bitterjug/vim-tagbar-ctags-elm/blob/master/ftplugin/elm/tagbar-elm.vim
types.elm = {}
types.elm.ctagstype = 'elm'
types.elm.kinds = {
	{short = 'm', long = 'modules',           fold = 0, stl = 0},
	{short = 'i', long = 'imports',           fold = 1, stl = 0},
	{short = 't', long = 'types',             fold = 1, stl = 0},
	{short = 'a', long = 'type aliases',      fold = 0, stl = 0},
	{short = 'c', long = 'type constructors', fold = 0, stl = 0},
	{short = 'p', long = 'ports',             fold = 0, stl = 0},
	{short = 'f', long = 'functions',         fold = 1, stl = 0}
}

types.elm.sro = ':'
types.elm.kind2scope = {
	f = 'function',
	m = 'module',
	t = 'type'
}

types.elm.scope2kind = {
	func = 'f',
	module   = 'm',
	type     = 't'
}

types.erlang = {}
types.erlang.ctagstype = 'erlang'
types.erlang.kinds     = {
	{short = 'm', long = 'modules',            fold = 0, stl = 1},
	{short = 'd', long = 'macro definitions',  fold = 0, stl = 1},
	{short = 'f', long = 'functions',          fold = 0, stl = 1},
	{short = 'r', long = 'record definitions', fold = 0, stl = 1},
	{short = 't', long = 'type definitions',   fold = 0, stl = 1}
}

types.erlang.sro = '.' -- Not sure, is nesting even possible?
types.erlang.kind2scope = {
	m = 'module'
}

types.erlang.scope2kind = {
	module = 'm'
}

-- Vim doesn't support Flex out of the box, this is based on rough guesses and probably requires
-- http://www.vim.org/scripts/script.php?script_id=2909 Improvements welcome!
types.as = {}
types.as.ctagstype = 'flex'
types.as.kinds = {
	{short = 'v', long = 'global variables', fold = 0, stl = 0},
	{short = 'c', long = 'classes',          fold = 0, stl = 1},
	{short = 'm', long = 'methods',          fold = 0, stl = 1},
	{short = 'p', long = 'properties',       fold = 0, stl = 1},
	{short = 'f', long = 'functions',        fold = 0, stl = 1},
	{short = 'x', long = 'mxtags',           fold = 0, stl = 0}
}

types.as.sro = '.'
types.as.kind2scope = {
	c = 'class'
}

types.as.scope2kind = {
	class = 'c'
}

types.mxml = types.as
types.actionscript = types.as

types.fortran = {}
types.fortran.ctagstype = 'fortran'
types.fortran.kinds     = {
	{short = 'm', long = 'modules',       fold = 0, stl = 1},
	{short = 'p', long = 'programs',      fold = 0, stl = 1},
	{short = 'k', long = 'components',    fold = 0, stl = 1},
	{short = 'c', long = 'common blocks', fold = 0, stl = 1},
	{short = 'b', long = 'block data',    fold = 0, stl = 0},
	{short = 'E', long = 'enumerations',  fold = 0, stl = 1},
	{short = 'e', long = 'entry points',  fold = 0, stl = 1},
	{short = 'f', long = 'functions',     fold = 0, stl = 1},
	{short = 's', long = 'subroutines',   fold = 0, stl = 1},
	{short = 'l', long = 'labels',        fold = 0, stl = 1},
	{short = 'n', long = 'namelists',     fold = 0, stl = 1},
	{short = 'v', long = 'variables',     fold = 0, stl = 0},
	{short = 'N', long = 'enumeration values', fold = 0, stl = 0},
	{short = 'M', long = 'type bound procedures', fold = 0, stl = 1},
	{short = 't', long = 'derived types and structures', fold = 0, stl = 1}
}

types.fortran.sro        = '.' -- Not sure, is nesting even possible?
types.fortran.kind2scope = {
	m = 'module',
	p = 'program',
	f = 'function',
	s = 'subroutine'
}

types.fortran.scope2kind = {
	module     = 'm',
	program    = 'p',
	func   = 'f',
	subroutine = 's'
}

types.go = {}
types.go.ctagstype = 'go'
types.go.kinds = {
	{short = 'p', long = 'packages',       fold = 0, stl = 0},
	{short = 'i', long = 'interfaces',     fold = 0, stl = 0},
	{short = 'c', long = 'constants',      fold = 0, stl = 0},
	{short = 's', long = 'structs',        fold = 0, stl = 1},
	{short = 'm', long = 'struct members', fold = 0, stl = 0},
	{short = 't', long = 'types',          fold = 0, stl = 1},
	{short = 'f', long = 'functions',      fold = 0, stl = 1},
	{short = 'v', long = 'variables',      fold = 0, stl = 0}
}

types.go.sro = '.'
types.go.kind2scope = {
	s = 'struct'
}

types.go.scope2kind = {
	struct = 's'
}

types.html = {}
types.html.ctagstype = 'html'

types.html.kinds = {
	{short = 'a', long = 'named anchors', fold = 0, stl = 1},
	{short = 'c', long = 'classes',       fold = 0, stl = 1},
	{short = 'C', long = 'stylesheets',   fold = 0, stl = 1},
	{short = 'I', long = 'identifiers',   fold = 0, stl = 1},
	{short = 'J', long = 'scripts',       fold = 0, stl = 1},
	{short = 'h', long = 'H1 headings',   fold = 1, stl = 1},
	{short = 'i', long = 'H2 headings',   fold = 1, stl = 1},
	{short = 'j', long = 'H3 headings',   fold = 1, stl = 1},
}

types.java = {}
types.java.ctagstype = 'java'
types.java.kinds = {
	{short = 'p', long = 'packages',       fold = 1, stl = 0},
	{short = 'f', long = 'fields',         fold = 0, stl = 0},
	{short = 'g', long = 'enum types',     fold = 0, stl = 1},
	{short = 'e', long = 'enum constants', fold = 0, stl = 0},
	{short = 'a', long = 'annotations',    fold = 0, stl = 0},
	{short = 'i', long = 'interfaces',     fold = 0, stl = 1},
	{short = 'c', long = 'classes',        fold = 0, stl = 1},
	{short = 'm', long = 'methods',        fold = 0, stl = 1}
}

types.java.sro        = '.'
types.java.kind2scope = {
	g = 'enum',
	i = 'interface',
	c = 'class'
}

types.java.scope2kind = {
	enum      = 'g',
	interface = 'i',
	class     = 'c'
}

types.javascript = {}
types.javascript.ctagstype = 'javascript'
types.javascript.kinds = {
	{short = 'v', long = 'global variables', fold = 0, stl = 0},
	{short = 'C', long = 'constants',        fold = 0, stl = 0},
	{short = 'c', long = 'classes',          fold = 0, stl = 1},
	{short = 'g', long = 'generators',       fold = 0, stl = 0},
	{short = 'p', long = 'properties',       fold = 0, stl = 0},
	{short = 'm', long = 'methods',          fold = 0, stl = 1},
	{short = 'f', long = 'functions',        fold = 0, stl = 1}
}

types.javascript.sro        = '.'
types.javascript.kind2scope = {
	c = 'class',
	f = 'function',
	m = 'method',
	p = 'property',
}

types.javascript.scope2kind = {
	class    = 'c',
	func = 'f'
}

types.kotlin = {}
types.kotlin.ctagstype = 'kotlin'
types.kotlin.kinds = {
	{short = 'p', long = 'packages',    fold = 0, stl = 0},
	{short = 'c', long = 'classes',     fold = 0, stl = 1},
	{short = 'o', long = 'objects',     fold = 0, stl = 0},
	{short = 'i', long = 'interfaces',  fold = 0, stl = 0},
	{short = 'T', long = 'typealiases', fold = 0, stl = 0},
	{short = 'm', long = 'methods',     fold = 0, stl = 1},
	{short = 'C', long = 'constants',   fold = 0, stl = 0},
	{short = 'v', long = 'variables',   fold = 0, stl = 0}
}

types.kotlin.sro         = '.'

-- Note: the current universal ctags version does not have proper
-- definition for the scope of the tags. So for now we can't add the
-- kind2scope / scope2kind for anything until ctags supports the correct
-- scope info
types.kotlin.kind2scope  = {}
types.kotlin.scope2kind  = {}

types.lisp = {}
types.lisp.ctagstype = 'lisp'
types.lisp.kinds = {
	{short = 'f', long = 'functions', fold = 0, stl = 1}
}

types.lua = {}
types.lua.ctagstype = 'lua'
types.lua.kinds = {
	f = 'functions'
}

types.lua.scope = {}
types.lua.member = {}

types.make = {}
types.make.ctagstype = 'make'
types.make.kinds = {
	{short = 'I', long = 'makefiles', fold = 0, stl = 0},
	{short = 'm', long = 'macros',    fold = 0, stl = 1},
	{short = 't', long = 'targets',   fold = 0, stl = 1}
}

types.markdown = {}
types.markdown.ctagstype = 'markdown'
types.markdown.kinds = {
	{short = 'c', long = 'chapter',       fold = 0, stl = 1},
	{short = 's', long = 'section',       fold = 0, stl = 1},
	{short = 'S', long = 'subsection',    fold = 0, stl = 1},
	{short = 't', long = 'subsubsection', fold = 0, stl = 1},
	{short = 'T', long = 'l3subsection',  fold = 0, stl = 1},
	{short = 'u', long = 'l4subsection',  fold = 0, stl = 1}
}

types.markdown.kind2scope = {
	c = 'chapter',
	s = 'section',
	S = 'subsection',
	t = 'subsubsection',
	T = 'l3subsection',
	u = 'l4subsection',
}

types.markdown.scope2kind = {
	chapter       = 'c',
	section       = 's',
	subsection    = 'S',
	subsubsection = 't',
	l3subsection  = 'T',
	l4subsection  = 'u',
}

types.markdown.sro = '""'
types.markdown.sort = 0

types.matlab = {}
types.matlab.ctagstype = 'matlab'
types.matlab.kinds = {
	{short = 'f', long = 'functions', fold = 0, stl = 1},
	{short = 'v', long = 'variables', fold = 0, stl = 0}
}

types.nroff = {}
types.nroff.ctagstype = 'nroff'
types.nroff.kinds = {
	{short = 't', long = 'titles',   fold = 0, stl = 1},
	{short = 's', long = 'sections', fold = 0, stl = 1}
}

types.nroff.sro        = '.'
types.nroff.kind2scope = {
	t = 'title',
	s = 'section'
}

types.nroff.scope2kind = {
	section = 't',
	title   = 's'
}

types.objc = {}
types.objc.ctagstype = 'objectivec'
types.objc.kinds = {
	{short = 'M', long = 'preprocessor macros',   fold = 1, stl = 0},
	{short = 't', long = 'type aliases',          fold = 0, stl = 1},
	{short = 'v', long = 'global variables',      fold = 0, stl = 0},
	{short = 'i', long = 'class interfaces',      fold = 0, stl = 1},
	{short = 'I', long = 'class implementations', fold = 0, stl = 1},
	{short = 'c', long = 'class methods',         fold = 0, stl = 1},
	{short = 'E', long = 'object fields',         fold = 0, stl = 0},
	{short = 'm', long = 'object methods',        fold = 0, stl = 1},
	{short = 's', long = 'type structures',       fold = 0, stl = 1},
	{short = 'e', long = 'enumerations',          fold = 0, stl = 1},
	{short = 'f', long = 'functions',             fold = 0, stl = 1},
	{short = 'p', long = 'properties',            fold = 0, stl = 0},
	{short = 'P', long = 'protocols',             fold = 0, stl = 0}
}

types.objc.sro        = ':'
types.objc.kind2scope = {
	i = 'interface',
	I = 'implementation',
	s = 'struct',
	p = 'protocol'
}

types.objc.scope2kind = {
	interface = 'i',
	implementation = 'I',
	struct = 's',
	protocol = 'p'
}

types.objcpp = types.objc

types.ocaml = {}
types.ocaml.ctagstype = 'ocaml'
types.ocaml.kinds = {
	{short = 'M', long = 'modules or functors', fold = 0, stl = 1},
	{short = 'v', long = 'global variables',    fold = 0, stl = 0},
	{short = 'c', long = 'classes',             fold = 0, stl = 1},
	{short = 'C', long = 'constructors',        fold = 0, stl = 1},
	{short = 'm', long = 'methods',             fold = 0, stl = 1},
	{short = 'e', long = 'exceptions',          fold = 0, stl = 1},
	{short = 't', long = 'type names',          fold = 0, stl = 1},
	{short = 'f', long = 'functions',           fold = 0, stl = 1},
	{short = 'r', long = 'structure fields',    fold = 0, stl = 0},
	{short = 'p', long = 'signature items',     fold = 0, stl = 0}
}

types.ocaml.sro        = '.' -- Not sure, is nesting even possible?
types.ocaml.kind2scope = {
	M = 'Module',
	c = 'class',
	t = 'type'
}

types.ocaml.scope2kind = {
	Module = 'M',
	class  = 'c',
	type   = 't'
}

types.pascal = {}
types.pascal.ctagstype = 'pascal'
types.pascal.kinds = {
	{short = 'f', long = 'functions',  fold = 0, stl = 1},
	{short = 'p', long = 'procedures', fold = 0, stl = 1}
}

types.perl = {}
types.perl.ctagstype = 'perl'
types.perl.kinds = {
	{short = 'p', long = 'packages',    fold = 1, stl = 0},
	{short = 'c', long = 'constants',   fold = 0, stl = 0},
	{short = 'M', long = 'modules',     fold = 0, stl = 0},
	{short = 'f', long = 'formats',     fold = 0, stl = 0},
	{short = 'l', long = 'labels',      fold = 0, stl = 1},
	{short = 's', long = 'subroutines', fold = 0, stl = 1},
	{short = 'd', long = 'subroutineDeclarations', fold = 0, stl = 0}
}

types.perl6 = {}
types.perl6.ctagstype = 'perl6'
types.perl6.kinds = {
	{short = 'o', long = 'modules',     fold = 0, stl = 1},
	{short = 'p', long = 'packages',    fold = 1, stl = 0},
	{short = 'c', long = 'classes',     fold = 0, stl = 1},
	{short = 'g', long = 'grammars',    fold = 0, stl = 0},
	{short = 'm', long = 'methods',     fold = 0, stl = 1},
	{short = 'r', long = 'roles',       fold = 0, stl = 1},
	{short = 'u', long = 'rules',       fold = 0, stl = 0},
	{short = 'b', long = 'submethods',  fold = 0, stl = 1},
	{short = 's', long = 'subroutines', fold = 0, stl = 1},
	{short = 't', long = 'tokens',      fold = 0, stl = 0},
}

types.php = {}
types.php.ctagstype = 'php'
types.php.kinds = {
	{short = 'n', long = 'namespaces',           fold = 0, stl = 0},
	{short = 'a', long = 'use aliases',          fold = 1, stl = 0},
	{short = 'd', long = 'constant definitions', fold = 0, stl = 0},
	{short = 'i', long = 'interfaces',           fold = 0, stl = 1},
	{short = 't', long = 'traits',               fold = 0, stl = 1},
	{short = 'c', long = 'classes',              fold = 0, stl = 1},
	{short = 'v', long = 'variables',            fold = 1, stl = 0},
	{short = 'f', long = 'functions',            fold = 0, stl = 1}
}

types.php.sro        = '\\'
types.php.kind2scope = {
	c = 'class',
	n = 'namespace',
	i = 'interface',
	t = 'trait'
}

types.php.scope2kind = {
	class     = 'c',
	namespace = 'n',
	interface = 'i',
	trait     = 't',
}

types.proto = {}
types.proto.ctagstype = 'Protobuf'
types.proto.kinds = {
	{short = 'p', long = 'packages',       fold = 0, stl = 0},
	{short = 'm', long = 'messages',       fold = 0, stl = 0},
	{short = 'f', long = 'fields',         fold = 0, stl = 0},
	{short = 'e', long = 'enum constants', fold = 0, stl = 0},
	{short = 'g', long = 'enum types',     fold = 0, stl = 0},
	{short = 's', long = 'services',       fold = 0, stl = 0}
}

types.python = {}
types.python.ctagstype = 'python'
types.python.kinds = {
	{short = 'i', long = 'modules',   fold = 1, stl = 0},
	{short = 'c', long = 'classes',   fold = 0, stl = 1},
	{short = 'f', long = 'functions', fold = 0, stl = 1},
	{short = 'm', long = 'members',   fold = 0, stl = 1},
	{short = 'v', long = 'variables', fold = 0, stl = 0}
}

types.python.sro        = '.'
types.python.kind2scope = {
	c = 'class',
	f = 'function',
	m = 'member'
}

types.python.scope2kind = {
	class    = 'c',
	func = 'f',
	member   = 'm'
}

types.pyrex  = types.python
types.cython = types.python

types.r = {}
types.r.ctagstype = 'R'
types.r.kinds = {
	{short = 'l', long = 'libraries',          fold = 1, stl = 0},
	{short = 'f', long = 'functions',          fold = 0, stl = 1},
	{short = 's', long = 'sources',            fold = 0, stl = 0},
	{short = 'g', long = 'global variables',   fold = 0, stl = 1},
	{short = 'v', long = 'function variables', fold = 0, stl = 0}
}

types.rst = {}
types.rst.ctagstype = 'restructuredtext'
types.rst.kinds = {
	{short = 'c', long = 'chapter',       fold = 0, stl = 1},
	{short = 's', long = 'section',       fold = 0, stl = 1},
	{short = 'S', long = 'subsection',    fold = 0, stl = 1},
	{short = 't', long = 'subsubsection', fold = 0, stl = 1},
	{short = 'T', long = 'l3subsection',  fold = 0, stl = 1},
	{short = 'u', long = 'l4subsection',  fold = 0, stl = 1}
}

types.rst.kind2scope = {
	c = 'chapter',
	s = 'section',
	S = 'subsection',
	t = 'subsubsection',
	T = 'l3subsection',
	u = 'l4subsection'
}

types.rst.scope2kind = {
	chapter       = 'c',
	section       = 's',
	subsection    = 'S',
	subsubsection = 't',
	l3subsection  = 'T',
	l4subsection  = 'u',
}

types.rst.sro = '""'
types.rst.sort = 0

types.rexx = {}
types.rexx.ctagstype = 'rexx'
types.rexx.kinds     = {
	{short = 's', long = 'subroutines', fold = 0, stl = 1}
}

types.ruby = {}
types.ruby.ctagstype = 'ruby'
types.ruby.kinds = {
	{short = 'm', long = 'modules',           fold = 0, stl = 1},
	{short = 'c', long = 'classes',           fold = 0, stl = 1},
	{short = 'f', long = 'methods',           fold = 0, stl = 1},
	{short = 'S', long = 'singleton methods', fold = 0, stl = 1}
}

types.ruby.sro        = '.'
types.ruby.kind2scope = {
	c = 'class',
	f = 'method',
	m = 'module'
}

types.ruby.scope2kind = {
	class  = 'c',
	method = 'f',
	module = 'm'
}

types.rust = {}
types.rust.ctagstype = 'rust'
types.rust.kinds = {
	{short = 'n', long = 'module',          fold = 1, stl = 0},
	{short = 's', long = 'struct',          fold = 0, stl = 1},
	{short = 'i', long = 'trait',           fold = 0, stl = 1},
	{short = 'c', long = 'implementation',  fold = 0, stl = 0},
	{short = 'f', long = 'function',        fold = 0, stl = 1},
	{short = 'g', long = 'enum',            fold = 0, stl = 1},
	{short = 't', long = 'type alias',      fold = 0, stl = 1},
	{short = 'v', long = 'global variable', fold = 0, stl = 1},
	{short = 'M', long = 'macro',           fold = 0, stl = 1},
	{short = 'm', long = 'struct field',    fold = 0, stl = 1},
	{short = 'e', long = 'enum variant',    fold = 0, stl = 1},
	{short = 'P', long = 'method',          fold = 0, stl = 1}
}

types.rust.sro        = '::'
types.rust.kind2scope = {
	n = 'module',
	s = 'struct',
	i = 'interface',
	c = 'implementation',
	f = 'function',
	g = 'enum',
	P = 'method'
}

types.rust.scope2kind = {
	module         = 'n',
	struct         = 's',
	interface      = 'i',
	implementation = 'c',
	func       = 'f',
	enum           = 'g',
	method         = 'P',
}

types.scheme = {}
types.scheme.ctagstype = 'scheme'
types.scheme.kinds = {
	{short = 'f', long = 'functions', fold = 0, stl = 1},
	{short = 's', long = 'sets',      fold = 0, stl = 1}
}

types.racket = types.scheme

types.sh = {}
types.sh.ctagstype = 'sh'
types.sh.kinds = {
	{short = 'f', long = 'functions',    fold = 0, stl = 1},
	{short = 'a', long = 'aliases',      fold = 0, stl = 0},
	{short = 's', long = 'script files', fold = 0, stl = 0}
}

types.csh = types.sh
types.zsh = types.sh

types.slang = {}
types.slang.ctagstype = 'slang'
types.slang.kinds = {
	{short = 'n', long = 'namespaces', fold = 0, stl = 1},
	{short = 'f', long = 'functions',  fold = 0, stl = 1}
}

types.sml = {}
types.sml.ctagstype = 'sml'
types.sml.kinds = {
	{short = 'e', long = 'exception declarations', fold = 0, stl = 0},
	{short = 'f', long = 'function definitions',   fold = 0, stl = 1},
	{short = 'c', long = 'functor definitions',    fold = 0, stl = 1},
	{short = 's', long = 'signature declarations', fold = 0, stl = 0},
	{short = 'r', long = 'structure declarations', fold = 0, stl = 0},
	{short = 't', long = 'type definitions',       fold = 0, stl = 1},
	{short = 'v', long = 'value bindings',         fold = 0, stl = 0}
}

-- The SQL ctags parser seems to be buggy for me, so this just uses the
-- normal kinds even though scopes should be available. Improvements welcome!
types.sql = {}
types.sql.ctagstype = 'sql'
types.sql.kinds = {
	{short = 'P', long = 'packages',               fold = 1, stl = 1},
	{short = 'd', long = 'prototypes',             fold = 0, stl = 1},
	{short = 'c', long = 'cursors',                fold = 0, stl = 1},
	{short = 'f', long = 'functions',              fold = 0, stl = 1},
	{short = 'E', long = 'record fields',          fold = 0, stl = 1},
	{short = 'L', long = 'block label',            fold = 0, stl = 1},
	{short = 'p', long = 'procedures',             fold = 0, stl = 1},
	{short = 's', long = 'subtypes',               fold = 0, stl = 1},
	{short = 't', long = 'tables',                 fold = 0, stl = 1},
	{short = 'T', long = 'triggers',               fold = 0, stl = 1},
	{short = 'v', long = 'variables',              fold = 0, stl = 1},
	{short = 'i', long = 'indexes',                fold = 0, stl = 1},
	{short = 'e', long = 'events',                 fold = 0, stl = 1},
	{short = 'U', long = 'publications',           fold = 0, stl = 1},
	{short = 'R', long = 'services',               fold = 0, stl = 1},
	{short = 'D', long = 'domains',                fold = 0, stl = 1},
	{short = 'V', long = 'views',                  fold = 0, stl = 1},
	{short = 'n', long = 'synonyms',               fold = 0, stl = 1},
	{short = 'x', long = 'MobiLink Table Scripts', fold = 0, stl = 1},
	{short = 'y', long = 'MobiLink Conn Scripts',  fold = 0, stl = 1},
	{short = 'z', long = 'MobiLink Properties',    fold = 0, stl = 1}
}

types.tcl = {}
types.tcl.ctagstype = 'tcl'
types.tcl.kinds = {
	{short = 'n', long = 'namespaces', fold = 0, stl = 1},
	{short = 'p', long = 'procedures', fold = 0, stl = 1}
}

types.typescript = {}
types.typescript.ctagstype = 'typescript'
types.typescript.kinds = {
	{short = 'n', long = 'namespaces',   fold = 0, stl = 1},
	{short = 'i', long = 'interfaces',   fold = 0, stl = 1},
	{short = 'g', long = 'enums',        fold = 0, stl = 1},
	{short = 'e', long = 'enumerations', fold = 0, stl = 1},
	{short = 'c', long = 'classes',      fold = 0, stl = 1},
	{short = 'C', long = 'constants',    fold = 0, stl = 1},
	{short = 'f', long = 'functions',    fold = 0, stl = 1},
	{short = 'p', long = 'properties',   fold = 0, stl = 1},
	{short = 'v', long = 'variables',    fold = 0, stl = 1},
	{short = 'm', long = 'methods',      fold = 0, stl = 1}
}

types.typescript.sro        = '.'
types.typescript.kind2scope = {
	c = 'class',
	i = 'interface',
	g = 'enum',
	n = 'namespace'
}

types.typescript.scope2kind = {
	class       = 'c',
	interface   = 'i',
	enum        = 'g',
	namespace   = 'n'
}

types.tex = {}
types.tex.ctagstype = 'tex'
types.tex.kinds = {
	{short = 'i', long = 'includes',       fold = 1, stl = 0},
	{short = 'p', long = 'parts',          fold = 0, stl = 1},
	{short = 'c', long = 'chapters',       fold = 0, stl = 1},
	{short = 's', long = 'sections',       fold = 0, stl = 1},
	{short = 'u', long = 'subsections',    fold = 0, stl = 1},
	{short = 'b', long = 'subsubsections', fold = 0, stl = 1},
	{short = 'P', long = 'paragraphs',     fold = 0, stl = 0},
	{short = 'G', long = 'subparagraphs',  fold = 0, stl = 0},
	{short = 'l', long = 'labels',         fold = 0, stl = 0},
	{short = 'f', long = 'frames',         fold = 0, stl = 1}
}

types.tex.sro        = '""'
types.tex.kind2scope = {
	p = 'part',
	c = 'chapter',
	s = 'section',
	u = 'subsection',
	b = 'subsubsection'
}

types.tex.scope2kind = {
	part          = 'p',
	chapter       = 'c',
	section       = 's',
	subsection    = 'u',
	subsubsection = 'b'
}

types.tex.sort = 0

-- Why are variables 'virtual'?
types.vera = {}
types.vera.ctagstype = 'vera'
types.vera.kinds = {
	{short = 'h', long = 'header files', fold = 1, stl = 0},
	{short = 'd', long = 'macros',       fold = 1, stl = 0},
	{short = 'g', long = 'enums',        fold = 0, stl = 1},
	{short = 'T', long = 'typedefs',     fold = 0, stl = 0},
	{short = 'i', long = 'interfaces',   fold = 0, stl = 1},
	{short = 'c', long = 'classes',      fold = 0, stl = 1},
	{short = 'e', long = 'enumerators',  fold = 0, stl = 0},
	{short = 'm', long = 'members',      fold = 0, stl = 1},
	{short = 'f', long = 'functions',    fold = 0, stl = 1},
	{short = 's', long = 'signals',      fold = 0, stl = 0},
	{short = 't', long = 'tasks',        fold = 0, stl = 1},
	{short = 'v', long = 'variables',    fold = 0, stl = 0},
	{short = 'p', long = 'programs',     fold = 0, stl = 1}
}

types.vera.sro        = '.' -- Nesting doesn't seem to be possible
types.vera.kind2scope = {
	g = 'enum',
	c = 'class',
	v = 'virtual'
}

types.vera.scope2kind = {
	enum    = 'g',
	class   = 'c',
	virtual = 'v'
}

types.verilog = {}
types.verilog.ctagstype = 'verilog'
types.verilog.kinds     = {
	{short = 'c', long = 'constants',           fold = 0, stl = 0},
	{short = 'e', long = 'events',              fold = 0, stl = 1},
	{short = 'f', long = 'functions',           fold = 0, stl = 1},
	{short = 'm', long = 'modules',             fold = 0, stl = 1},
	{short = 'b', long = 'blocks',              fold = 0, stl = 1},
	{short = 'n', long = 'net data types',      fold = 0, stl = 1},
	{short = 'p', long = 'ports',               fold = 0, stl = 1},
	{short = 'r', long = 'register data types', fold = 0, stl = 1},
	{short = 't', long = 'tasks',               fold = 0, stl = 1}
}

-- The VHDL ctags parser unfortunately doesn't generate proper scopes
types.vhdl = {}
types.vhdl.ctagstype = 'vhdl'
types.vhdl.kinds = {
	{short = 'P', long = 'packages',   fold = 1, stl = 0},
	{short = 'c', long = 'constants',  fold = 0, stl = 0},
	{short = 't', long = 'types',      fold = 0, stl = 1},
	{short = 'T', long = 'subtypes',   fold = 0, stl = 1},
	{short = 'r', long = 'records',    fold = 0, stl = 1},
	{short = 'e', long = 'entities',   fold = 0, stl = 1},
	{short = 'f', long = 'functions',  fold = 0, stl = 1},
	{short = 'p', long = 'procedures', fold = 0, stl = 1}
}

types.vim = {}
types.vim.ctagstype = 'vim'
types.vim.kinds = {
	{short = 'n', long = 'vimball filenames',  fold = 0, stl = 1},
	{short = 'v', long = 'variables',          fold = 1, stl = 0},
	{short = 'f', long = 'functions',          fold = 0, stl = 1},
	{short = 'a', long = 'autocommand groups', fold = 1, stl = 1},
	{short = 'c', long = 'commands',           fold = 0, stl = 0},
	{short = 'm', long = 'maps',               fold = 1, stl = 0}
}

types.yacc = {}
types.yacc.ctagstype = 'yacc'
types.yacc.kinds = {
	{short = 'l', long = 'labels', fold = 0, stl = 1}
}

return types
