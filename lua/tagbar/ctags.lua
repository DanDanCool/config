-- Type definitions for Universal Ctags

local ctags = {}

function ctags.init()
    local type = {}

    type.ada = tagbar#prototypes#typeinfo#new()
    type.ada.ctagstype = 'ada'
    type.ada.kinds = {
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

    type.ada.sro = '.' -- Not sure if possible
    type.ada.kind2scope = {
        P = 'packspec',
        t = 'type',
    }

    type.ada.scope2kind = {
        packspec = 'P',
        type     = 't',
    }

    type.ant = tagbar#prototypes#typeinfo#new()
    type.ant.ctagstype = 'ant'
    type.ant.kinds     = {
        {short = 'p', long = 'projects',   fold = 0, stl = 1},
        {short = 'i', long = 'antfiles',   fold = 0, stl = 0},
        {short = 'P', long = 'properties', fold = 0, stl = 0},
        {short = 't', long = 'targets',    fold = 0, stl = 1}
    }

    type.asciidoc = tagbar#prototypes#typeinfo#new()
    type.asciidoc.ctagstype = 'asciidoc'
    type.asciidoc.kinds = {
        {short = 'c', long = 'chapter',       fold = 0, stl = 1},
        {short = 's', long = 'section',       fold = 0, stl = 1},
        {short = 'S', long = 'subsection',    fold = 0, stl = 1},
        {short = 't', long = 'subsubsection', fold = 0, stl = 1},
        {short = 'T', long = 'paragraph',     fold = 0, stl = 1},
        {short = 'u', long = 'subparagraph',  fold = 0, stl = 1},
        {short = 'a', long = 'anchor',        fold = 0, stl = 0}
    }

    type.asciidoc.sro        = '""'
    type.asciidoc.kind2scope = {
        c = 'chapter',
        s = 'section',
        S = 'subsection',
        t = 'subsubsection',
        T = 'l4subsection',
        u = 'l5subsection'
    }

    type.asciidoc.scope2kind = {
        chapter = 'c',
        section = 's',
        subsection = 'S',
		subsubsection = 't',
		l4subsection = 'T',
        l5subsection = 'u'
    }

    type.asciidoc.sort = 0

    type.asm = tagbar#prototypes#typeinfo#new()
    type.asm.ctagstype = 'asm'
    type.asm.kinds     = {
        {short = 'm', long = 'macros',    fold = 0, stl = 1},
        {short = 't', long = 'types',     fold = 0, stl = 1},
        {short = 's', long = 'sections',  fold = 0, stl = 1},
        {short = 'd', long = 'defines',   fold = 0, stl = 1},
        {short = 'l', long = 'labels',    fold = 0, stl = 1}
    }

    type.aspvbs = tagbar#prototypes#typeinfo#new()
    type.aspvbs.ctagstype = 'asp'
    type.aspvbs.kinds     = {
        {short = 'd', long = 'constants',   fold = 0, stl = 1},
        {short = 'c', long = 'classes',     fold = 0, stl = 1},
        {short = 'f', long = 'functions',   fold = 0, stl = 1},
        {short = 's', long = 'subroutines', fold = 0, stl = 1},
        {short = 'v', long = 'variables',   fold = 0, stl = 1}
    }

    -- Asymptote gets parsed well using filetype = c
    type.asy = tagbar#prototypes#typeinfo#new()
    type.asy.ctagstype = 'c'
    type.asy.kinds = {
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

    type_asy.sro        = '::'
    type_asy.kind2scope = {
        g = 'enum',
        s = 'struct',
        u = 'union'
    }

    type_asy.scope2kind = {
        enum   = 'g',
        struct = 's',
        union  = 'u'
    }

    type.config = tagbar#prototypes#typeinfo#new()
    type.config.ctagstype = 'autoconf'
    type.config.kinds = {
        {short = 'p', long = 'packages',            fold = 0, stl = 1},
        {short = 't', long = 'templates',           fold = 0, stl = 1},
        {short = 'm', long = 'autoconf macros',     fold = 0, stl = 1},
        {short = 'w', long = '"with" options',      fold = 0, stl = 1},
        {short = 'e', long = '"enable" options',    fold = 0, stl = 1},
        {short = 's', long = 'substitution keys',   fold = 0, stl = 1},
        {short = 'c', long = 'automake conditions', fold = 0, stl = 1},
        {short = 'd', long = 'definitions',         fold = 0, stl = 1}
    }

    type.automake = tagbar#prototypes#typeinfo#new()
    type.automake.ctagstype = 'automake'
    type.automake.kinds = {
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

    type.awk = tagbar#prototypes#typeinfo#new()
    type.awk.ctagstype = 'awk'
    type.awk.kinds = {
        {short = 'f', long = 'functions', fold = 0, stl = 1}
    }

    type.basic = tagbar#prototypes#typeinfo#new()
    type.basic.ctagstype = 'basic'
    type.basic.kinds = {
        {short = 'c', long = 'constants',    fold = 0, stl = 1},
        {short = 'g', long = 'enumerations', fold = 0, stl = 1},
        {short = 'f', long = 'functions',    fold = 0, stl = 1},
        {short = 'l', long = 'labels',       fold = 0, stl = 1},
        {short = 't', long = 'types',        fold = 0, stl = 1},
        {short = 'v', long = 'variables',    fold = 0, stl = 1}
    }

    type.beta = tagbar#prototypes#typeinfo#new()
    type.beta.ctagstype = 'beta'
    type.beta.kinds = {
        {short = 'f', long = 'fragments', fold = 0, stl = 1},
        {short = 's', long = 'slots',     fold = 0, stl = 1},
        {short = 'v', long = 'patterns',  fold = 0, stl = 1}
    }

    type.c = tagbar#prototypes#typeinfo#new()
    type.c.ctagstype = 'c'
    type.c.kinds     = {
        {short = 'h', long = 'header files', fold = 1, stl = 0},
        {short = 'd', long = 'macros',       fold = 1, stl = 0},
        {short = 'p', long = 'prototypes',   fold = 1, stl = 0},
        {short = 'g', long = 'enums',        fold = 0, stl = 1},
        {short = 'e', long = 'enumerators',  fold = 0, stl = 0},
        {short = 't', long = 'typedefs',     fold = 0, stl = 0},
        {short = 's', long = 'structs',      fold = 0, stl = 1},
        {short = 'u', long = 'unions',       fold = 0, stl = 1},
        {short = 'm', long = 'members',      fold = 0, stl = 0},
        {short = 'v', long = 'variables',    fold = 0, stl = 0},
        {short = 'f', long = 'functions',    fold = 0, stl = 1}
    }

    type.c.sro        = '::'
    type.c.kind2scope = {
        g = 'enum',
        s = 'struct',
        u = 'union'
    }

    type.c.scope2kind = {
        enum   = 'g',
        struct = 's',
        union  = 'u'
    }

	type.lpc = type.c

    type.cpp = tagbar#prototypes#typeinfo#new()
    type.cpp.ctagstype = 'c++'
    type.cpp.kinds = {
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

    type.cpp.sro        = '::'
    type.cpp.kind2scope = {
        g = 'enum',
        n = 'namespace',
        c = 'class',
        s = 'struct',
        u = 'union'
    }

    type.cpp.scope2kind = {
        enum      = 'g',
        namespace = 'n',
        class     = 'c',
        struct    = 's',
        union     = 'u'
    }

    type.cuda = type.cpp
    type.arduino = type.cpp

    type.cs = tagbar#prototypes#typeinfo#new()
    type.cs.ctagstype = 'c#'
    type.cs.kinds     = {
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

    type.cs.sro        = '.'
    type.cs.kind2scope = {
        n = 'namespace',
        i = 'interface',
        c = 'class',
        s = 'struct',
        g = 'enum'
    }

    type.cs.scope2kind = {
        namespace = 'n',
        interface = 'i',
        class     = 'c',
        struct    = 's',
        enum      = 'g'
    }

    type.clojure = tagbar#prototypes#typeinfo#new()
    type.clojure.ctagstype = 'clojure'
    type.clojure.kinds     = {
        {short = 'n', long = 'namespace', fold = 0, stl = 1},
        {short = 'f', long = 'function',  fold = 0, stl = 1}
    }

    type.clojure.sro = '.'
    type.clojure.kind2scope = {
        n = 'namespace',
    }

    type.clojure.scope2kind = {
        namespace = 'n'
    }

    type.cmake = tagbar#prototypes#typeinfo#new()
    type.cmake.ctagstype = 'cmake'
    type.cmake.kinds     = {
        {short = 'p', long = 'projects' , fold = 0, stl = 1},
        {short = 'm', long = 'macros'   , fold = 0, stl = 1},
        {short = 'f', long = 'functions', fold = 0, stl = 1},
        {short = 'D', long = 'options'  , fold = 0, stl = 1},
        {short = 'v', long = 'variables', fold = 0, stl = 1},
        {short = 't', long = 'targets'  , fold = 0, stl = 1}
    }

    type.cmake.sro = '.'
    type.cmake.kind2scope = {
        f = 'function',
    }

    type.cmake.scope2kind = {
        function = 'f',
    }

    type.ctags = tagbar#prototypes#typeinfo#new()
    type.ctags.ctagstype = 'ctags'
    type.ctags.kinds = {
         {short = 'l', long = 'language definitions', fold = 0, stl = 1},
         {short = 'k', long = 'kind definitions',     fold = 0, stl = 1}
    }

    type.ctags.sro        = '.' -- Not actually possible
    type.ctags.kind2scope = {
        l = 'langdef'
    }

    type.ctags.scope2kind = {
        langdef = 'l'
    }

    type.cobol = tagbar#prototypes#typeinfo#new()
    type.cobol.ctagstype = 'cobol'
    type.cobol.kinds = {
        {short = 'd', long = 'data items',        fold = 0, stl = 1},
        {short = 'D', long = 'divisions',         fold = 0, stl = 1},
        {short = 'f', long = 'file descriptions', fold = 0, stl = 1},
        {short = 'g', long = 'group items',       fold = 0, stl = 1},
        {short = 'p', long = 'paragraphs',        fold = 0, stl = 1},
        {short = 'P', long = 'program ids',       fold = 0, stl = 1},
        {short = 'S', long = 'source code file',  fold = 0, stl = 1},
        {short = 's', long = 'sections',          fold = 0, stl = 1}
    }

    type.css = tagbar#prototypes#typeinfo#new()
    type.css.ctagstype = 'css'
    type.css.kinds = {
        {short = 's', long = 'selector',   fold = 0, stl = 0},
        {short = 'i', long = 'identities', fold = 1, stl = 0},
        {short = 'c', long = 'classes',    fold = 1, stl = 0}
    }

    type.d = tagbar#prototypes#typeinfo#new()
    type.d.ctagstype = 'D'
    type.d.kinds = {
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

    type.d.sro = '.'
    type.d.kind2scope = {
        g = 'enum',
        n = 'namespace',
        i = 'interface',
        c = 'class',
        s = 'struct',
        u = 'union'
    }

    type.d.scope2kind = {
        enum      = 'g',
        namespace = 'n',
        interface = 'i',
        class     = 'c',
        struct    = 's',
        union     = 'u'
    }

    type.dosbatch = tagbar#prototypes#typeinfo#new()
    type.dosbatch.ctagstype = 'dosbatch'
    type.dosbatch.kinds     = {
        {short = 'l', long = 'labels',    fold = 0, stl = 1},
        {short = 'v', long = 'variables', fold = 0, stl = 1}
    }

    type.eiffel = tagbar#prototypes#typeinfo#new()
    type.eiffel.ctagstype = 'eiffel'
    type.eiffel.kinds = {
        {short = 'c', long = 'classes',  fold = 0, stl = 1},
        {short = 'f', long = 'features', fold = 0, stl = 1}
    }

    type.eiffel.sro        = '.' -- Not sure, is nesting even possible?
    type.eiffel.kind2scope = {
        c = 'class',
        f = 'feature'
    }

    type.eiffel.scope2kind = {
        class   = 'c',
        feature = 'f'
    }

    -- based on https://github.com/bitterjug/vim-tagbar-ctags-elm/blob/master/ftplugin/elm/tagbar-elm.vim
    type.elm = tagbar#prototypes#typeinfo#new()
    type.elm.ctagstype = 'elm'
    type.elm.kinds = {
        {short = 'm', long = 'modules',           fold = 0, stl = 0},
        {short = 'i', long = 'imports',           fold = 1, stl = 0},
        {short = 't', long = 'types',             fold = 1, stl = 0},
        {short = 'a', long = 'type aliases',      fold = 0, stl = 0},
        {short = 'c', long = 'type constructors', fold = 0, stl = 0},
        {short = 'p', long = 'ports',             fold = 0, stl = 0},
        {short = 'f', long = 'functions',         fold = 1, stl = 0}
    }

    type.elm.sro = ':'
    type.elm.kind2scope = {
        f = 'function',
        m = 'module',
        t = 'type'
    }

    type.elm.scope2kind = {
        function = 'f',
        module   = 'm',
        type     = 't'
    }

    type.erlang = tagbar#prototypes#typeinfo#new()
    type.erlang.ctagstype = 'erlang'
    type.erlang.kinds     = {
        {short = 'm', long = 'modules',            fold = 0, stl = 1},
        {short = 'd', long = 'macro definitions',  fold = 0, stl = 1},
        {short = 'f', long = 'functions',          fold = 0, stl = 1},
        {short = 'r', long = 'record definitions', fold = 0, stl = 1},
        {short = 't', long = 'type definitions',   fold = 0, stl = 1}
    }

    type.erlang.sro = '.' -- Not sure, is nesting even possible?
    type.erlang.kind2scope = {
        m = 'module'
    }

    type.erlang.scope2kind = {
        module = 'm'
    }

    -- Vim doesn't support Flex out of the box, this is based on rough guesses and probably requires
    -- http://www.vim.org/scripts/script.php?script_id=2909 Improvements welcome!
    type.as = tagbar#prototypes#typeinfo#new()
    type.as.ctagstype = 'flex'
    type.as.kinds = {
        {short = 'v', long = 'global variables', fold = 0, stl = 0},
        {short = 'c', long = 'classes',          fold = 0, stl = 1},
        {short = 'm', long = 'methods',          fold = 0, stl = 1},
        {short = 'p', long = 'properties',       fold = 0, stl = 1},
        {short = 'f', long = 'functions',        fold = 0, stl = 1},
        {short = 'x', long = 'mxtags',           fold = 0, stl = 0}
    }

    type.as.sro = '.'
    type.as.kind2scope = {
        c = 'class'
    }

    type.as.scope2kind = {
        class = 'c'
    }

    type.mxml = type_as
    type.actionscript = type_as

    type.fortran = tagbar#prototypes#typeinfo#new()
    type.fortran.ctagstype = 'fortran'
    type.fortran.kinds     = {
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

    type.fortran.sro        = '.' -- Not sure, is nesting even possible?
    type.fortran.kind2scope = {
        m = 'module',
        p = 'program',
        f = 'function',
        s = 'subroutine'
    }

    type.fortran.scope2kind = {
        module     = 'm',
        program    = 'p',
        function   = 'f',
        subroutine = 's'
    }

    type.go = tagbar#prototypes#typeinfo#new()
    type.go.ctagstype = 'go'
    type.go.kinds = {
        {short = 'p', long = 'packages',       fold = 0, stl = 0},
        {short = 'i', long = 'interfaces',     fold = 0, stl = 0},
        {short = 'c', long = 'constants',      fold = 0, stl = 0},
        {short = 's', long = 'structs',        fold = 0, stl = 1},
        {short = 'm', long = 'struct members', fold = 0, stl = 0},
        {short = 't', long = 'types',          fold = 0, stl = 1},
        {short = 'f', long = 'functions',      fold = 0, stl = 1},
        {short = 'v', long = 'variables',      fold = 0, stl = 0}
    }

    type.go.sro = '.'
    type.go.kind2scope = {
        s = 'struct'
    }

    type.go.scope2kind = {
        struct = 's'
    }

    type.html = tagbar#prototypes#typeinfo#new()
    type.html.ctagstype = 'html'

    type.html.kinds = {
        {short = 'a', long = 'named anchors', fold = 0, stl = 1},
        {short = 'c', long = 'classes',       fold = 0, stl = 1},
        {short = 'C', long = 'stylesheets',   fold = 0, stl = 1},
        {short = 'I', long = 'identifiers',   fold = 0, stl = 1},
        {short = 'J', long = 'scripts',       fold = 0, stl = 1},
        {short = 'h', long = 'H1 headings',   fold = 1, stl = 1},
        {short = 'i', long = 'H2 headings',   fold = 1, stl = 1},
        {short = 'j', long = 'H3 headings',   fold = 1, stl = 1},
	}

    type.java = tagbar#prototypes#typeinfo#new()
    type.java.ctagstype = 'java'
    type.java.kinds = {
        {short = 'p', long = 'packages',       fold = 1, stl = 0},
        {short = 'f', long = 'fields',         fold = 0, stl = 0},
        {short = 'g', long = 'enum types',     fold = 0, stl = 1},
        {short = 'e', long = 'enum constants', fold = 0, stl = 0},
        {short = 'a', long = 'annotations',    fold = 0, stl = 0},
        {short = 'i', long = 'interfaces',     fold = 0, stl = 1},
        {short = 'c', long = 'classes',        fold = 0, stl = 1},
        {short = 'm', long = 'methods',        fold = 0, stl = 1}
    }

    type.java.sro        = '.'
    type.java.kind2scope = {
        g = 'enum',
        i = 'interface',
        c = 'class'
    }

    type.java.scope2kind = {
        enum      = 'g',
        interface = 'i',
        class     = 'c'
    }

    type.javascript = tagbar#prototypes#typeinfo#new()
    type.javascript.ctagstype = 'javascript'
    type.javascript.kinds = {
        {short = 'v', long = 'global variables', fold = 0, stl = 0},
        {short = 'C', long = 'constants',        fold = 0, stl = 0},
        {short = 'c', long = 'classes',          fold = 0, stl = 1},
        {short = 'g', long = 'generators',       fold = 0, stl = 0},
        {short = 'p', long = 'properties',       fold = 0, stl = 0},
        {short = 'm', long = 'methods',          fold = 0, stl = 1},
        {short = 'f', long = 'functions',        fold = 0, stl = 1}
    }

    type.javascript.sro        = '.'
    type.javascript.kind2scope = {
        c = 'class',
        f = 'function',
        m = 'method',
        p = 'property',
    }

    type.javascript.scope2kind = {
        class    = 'c',
        function = 'f'
    }

    type.kotlin = tagbar#prototypes#typeinfo#new()
    type.kotlin.ctagstype = 'kotlin'
    type.kotlin.kinds = {
        {short = 'p', long = 'packages',    fold = 0, stl = 0},
        {short = 'c', long = 'classes',     fold = 0, stl = 1},
        {short = 'o', long = 'objects',     fold = 0, stl = 0},
        {short = 'i', long = 'interfaces',  fold = 0, stl = 0},
        {short = 'T', long = 'typealiases', fold = 0, stl = 0},
        {short = 'm', long = 'methods',     fold = 0, stl = 1},
        {short = 'C', long = 'constants',   fold = 0, stl = 0},
        {short = 'v', long = 'variables',   fold = 0, stl = 0}
    }

    type_kotlin.sro         = '.'

    -- Note: the current universal ctags version does not have proper
    -- definition for the scope of the tags. So for now we can't add the
    -- kind2scope / scope2kind for anything until ctags supports the correct
    -- scope info
    type.kotlin.kind2scope  = {}
    type.kotlin.scope2kind  = {}

    type.lisp = tagbar#prototypes#typeinfo#new()
    type.lisp.ctagstype = 'lisp'
    type.lisp.kinds = {
        {short = 'f', long = 'functions', fold = 0, stl = 1}
    }

    type.lua = tagbar#prototypes#typeinfo#new()
    type.lua.ctagstype = 'lua'
    type.lua.kinds = {
        {short = 'f', long = 'functions', fold = 0, stl = 1}
    }

    type.make = tagbar#prototypes#typeinfo#new()
    type.make.ctagstype = 'make'
    type.make.kinds = {
        {short = 'I', long = 'makefiles', fold = 0, stl = 0},
        {short = 'm', long = 'macros',    fold = 0, stl = 1},
        {short = 't', long = 'targets',   fold = 0, stl = 1}
    }

    type.markdown = tagbar#prototypes#typeinfo#new()
    type.markdown.ctagstype = 'markdown'
    type.markdown.kinds = {
		{short = 'c', long = 'chapter',       fold = 0, stl = 1},
        {short = 's', long = 'section',       fold = 0, stl = 1},
        {short = 'S', long = 'subsection',    fold = 0, stl = 1},
        {short = 't', long = 'subsubsection', fold = 0, stl = 1},
        {short = 'T', long = 'l3subsection',  fold = 0, stl = 1},
        {short = 'u', long = 'l4subsection',  fold = 0, stl = 1}
    }

    type.markdown.kind2scope = {
        c = 'chapter',
        s = 'section',
        S = 'subsection',
        t = 'subsubsection',
        T = 'l3subsection',
        u = 'l4subsection',
    }

    type.markdown.scope2kind = {
        chapter       = 'c',
        section       = 's',
        subsection    = 'S',
        subsubsection = 't',
        l3subsection  = 'T',
        l4subsection  = 'u',
    }

    type.markdown.sro = '""'
    type.markdown.sort = 0

    type.matlab = tagbar#prototypes#typeinfo#new()
    type.matlab.ctagstype = 'matlab'
    type.matlab.kinds = {
        {short = 'f', long = 'functions', fold = 0, stl = 1},
        {short = 'v', long = 'variables', fold = 0, stl = 0}
    }

    type.nroff = tagbar#prototypes#typeinfo#new()
    type.nroff.ctagstype = 'nroff'
    type.nroff.kinds = {
        {short = 't', long = 'titles',   fold = 0, stl = 1},
        {short = 's', long = 'sections', fold = 0, stl = 1}
    }

    type.nroff.sro        = '.'
    type.nroff.kind2scope = {
        t = 'title',
        s = 'section'
    }

    type.nroff.scope2kind = {
        section = 't',
        title   = 's'
    }

    type.objc = tagbar#prototypes#typeinfo#new()
    type.objc.ctagstype = 'objectivec'
    type.objc.kinds = {
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

    type.objc.sro        = ':'
    type.objc.kind2scope = {
        i = 'interface',
        I = 'implementation',
        s = 'struct',
        p = 'protocol'
    }

    type.objc.scope2kind = {
        interface = 'i',
        implementation = 'I',
        struct = 's',
        protocol = 'p'
    }

    types.objcpp = type_objc

    type.ocaml = tagbar#prototypes#typeinfo#new()
    type.ocaml.ctagstype = 'ocaml'
    type.ocaml.kinds = {
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

    type.ocaml.sro        = '.' -- Not sure, is nesting even possible?
    type.ocaml.kind2scope = {
        M = 'Module',
        c = 'class',
        t = 'type'
    }

    type_ocaml.scope2kind = {
        Module = 'M',
        class  = 'c',
        type   = 't'
    }

    type.pascal = tagbar#prototypes#typeinfo#new()
    type.pascal.ctagstype = 'pascal'
    type.pascal.kinds = {
        {short = 'f', long = 'functions',  fold = 0, stl = 1},
        {short = 'p', long = 'procedures', fold = 0, stl = 1}
    }

    type.perl = tagbar#prototypes#typeinfo#new()
    type.perl.ctagstype = 'perl'
    type.perl.kinds = {
        {short = 'p', long = 'packages',    fold = 1, stl = 0},
        {short = 'c', long = 'constants',   fold = 0, stl = 0},
        {short = 'M', long = 'modules',     fold = 0, stl = 0},
        {short = 'f', long = 'formats',     fold = 0, stl = 0},
        {short = 'l', long = 'labels',      fold = 0, stl = 1},
        {short = 's', long = 'subroutines', fold = 0, stl = 1},
        {short = 'd', long = 'subroutineDeclarations', fold = 0, stl = 0}
    }

    type.perl6 = tagbar#prototypes#typeinfo#new()
    type.perl6.ctagstype = 'perl6'
    type.perl6.kinds = {
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

    type.php = tagbar#prototypes#typeinfo#new()
    type.php.ctagstype = 'php'
    type.php.kinds = {
        {short = 'n', long = 'namespaces',           fold = 0, stl = 0},
        {short = 'a', long = 'use aliases',          fold = 1, stl = 0},
        {short = 'd', long = 'constant definitions', fold = 0, stl = 0},
        {short = 'i', long = 'interfaces',           fold = 0, stl = 1},
        {short = 't', long = 'traits',               fold = 0, stl = 1},
        {short = 'c', long = 'classes',              fold = 0, stl = 1},
        {short = 'v', long = 'variables',            fold = 1, stl = 0},
        {short = 'f', long = 'functions',            fold = 0, stl = 1}
    }

    type.php.sro        = '\\'
    type.php.kind2scope = {
        c = 'class',
        n = 'namespace',
        i = 'interface',
        t = 'trait'
    }

    type.php.scope2kind = {
        class     = 'c',
        namespace = 'n',
        interface = 'i',
        trait     = 't',
    }

    type.proto = tagbar#prototypes#typeinfo#new()
    type.proto.ctagstype = 'Protobuf'
    type.proto.kinds = {
        {short = 'p', long = 'packages',       fold = 0, stl = 0},
        {short = 'm', long = 'messages',       fold = 0, stl = 0},
        {short = 'f', long = 'fields',         fold = 0, stl = 0},
        {short = 'e', long = 'enum constants', fold = 0, stl = 0},
        {short = 'g', long = 'enum types',     fold = 0, stl = 0},
        {short = 's', long = 'services',       fold = 0, stl = 0}
    }

    type.python = tagbar#prototypes#typeinfo#new()
    type.python.ctagstype = 'python'
    type.python.kinds = {
        {short = 'i', long = 'modules',   fold = 1, stl = 0},
        {short = 'c', long = 'classes',   fold = 0, stl = 1},
        {short = 'f', long = 'functions', fold = 0, stl = 1},
        {short = 'm', long = 'members',   fold = 0, stl = 1},
        {short = 'v', long = 'variables', fold = 0, stl = 0}
    }

    type.python.sro        = '.'
    type.python.kind2scope = {
        c = 'class',
        f = 'function',
        m = 'member'
    }

    type.python.scope2kind = {
        class    = 'c',
        function = 'f',
		member   = 'm'
    }

    type.pyrex  = type.python
    type.cython = type.python

    type.r = tagbar#prototypes#typeinfo#new()
    type.r.ctagstype = 'R'
    type.r.kinds = {
        {short = 'l', long = 'libraries',          fold = 1, stl = 0},
        {short = 'f', long = 'functions',          fold = 0, stl = 1},
        {short = 's', long = 'sources',            fold = 0, stl = 0},
        {short = 'g', long = 'global variables',   fold = 0, stl = 1},
        {short = 'v', long = 'function variables', fold = 0, stl = 0}
    }

    type.rst = tagbar#prototypes#typeinfo#new()
    type.rst.ctagstype = 'restructuredtext'
    type.rst.kinds = {
        {short = 'c', long = 'chapter',       fold = 0, stl = 1},
        {short = 's', long = 'section',       fold = 0, stl = 1},
        {short = 'S', long = 'subsection',    fold = 0, stl = 1},
        {short = 't', long = 'subsubsection', fold = 0, stl = 1},
        {short = 'T', long = 'l3subsection',  fold = 0, stl = 1},
        {short = 'u', long = 'l4subsection',  fold = 0, stl = 1}
    }

    type.rst.kind2scope = {
        c = 'chapter',
        s = 'section',
        S = 'subsection',
        t = 'subsubsection',
        T = 'l3subsection',
        u = 'l4subsection'
    }

    type.rst.scope2kind = {
        chapter       = 'c',
        section       = 's',
        subsection    = 'S',
        subsubsection = 't',
        l3subsection  = 'T',
        l4subsection  = 'u',
    }

    type.rst.sro = '""'
    type.rst.sort = 0

    type.rexx = tagbar#prototypes#typeinfo#new()
    type.rexx.ctagstype = 'rexx'
    type.rexx.kinds     = {
        {short = 's', long = 'subroutines', fold = 0, stl = 1}
    }

    type.ruby = tagbar#prototypes#typeinfo#new()
    type.ruby.ctagstype = 'ruby'
    type.ruby.kinds = {
        {short = 'm', long = 'modules',           fold = 0, stl = 1},
        {short = 'c', long = 'classes',           fold = 0, stl = 1},
        {short = 'f', long = 'methods',           fold = 0, stl = 1},
        {short = 'S', long = 'singleton methods', fold = 0, stl = 1}
    }

    type.ruby.sro        = '.'
    type.ruby.kind2scope = {
        c = 'class',
        f = 'method',
        m = 'module'
    }

    type.ruby.scope2kind = {
        class  = 'c',
        method = 'f',
        module = 'm'
    }

    type.rust = tagbar#prototypes#typeinfo#new()
    type.rust.ctagstype = 'rust'
    type.rust.kinds = {
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

    type.rust.sro        = '::'
    type.rust.kind2scope = {
        n = 'module',
        s = 'struct',
        i = 'interface',
        c = 'implementation',
        f = 'function',
        g = 'enum',
        P = 'method'
    }

    type.rust.scope2kind = {
        module         = 'n',
        struct         = 's',
        interface      = 'i',
        implementation = 'c',
        function       = 'f',
        enum           = 'g',
        method         = 'P',
    }

    type.scheme = tagbar#prototypes#typeinfo#new()
    type.scheme.ctagstype = 'scheme'
    type.scheme.kinds = {
        {short = 'f', long = 'functions', fold = 0, stl = 1},
        {short = 's', long = 'sets',      fold = 0, stl = 1}
    }

    type.racket = type.scheme

    type.sh = tagbar#prototypes#typeinfo#new()
    type.sh.ctagstype = 'sh'
    type.sh.kinds = {
        {short = 'f', long = 'functions',    fold = 0, stl = 1},
        {short = 'a', long = 'aliases',      fold = 0, stl = 0},
        {short = 's', long = 'script files', fold = 0, stl = 0}
    }

    type.csh = type.sh
    type.zsh = type.sh

    type.slang = tagbar#prototypes#typeinfo#new()
    type.slang.ctagstype = 'slang'
    type.slang.kinds = {
        {short = 'n', long = 'namespaces', fold = 0, stl = 1},
        {short = 'f', long = 'functions',  fold = 0, stl = 1}
    }

    type.sml = tagbar#prototypes#typeinfo#new()
    type.sml.ctagstype = 'sml'
    type.sml.kinds = {
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
    type.sql = tagbar#prototypes#typeinfo#new()
    type.sql.ctagstype = 'sql'
    type.sql.kinds = {
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

    type.tcl = tagbar#prototypes#typeinfo#new()
    type.tcl.ctagstype = 'tcl'
    type.tcl.kinds = {
        {short = 'n', long = 'namespaces', fold = 0, stl = 1},
        {short = 'p', long = 'procedures', fold = 0, stl = 1}
    }

    type.typescript = tagbar#prototypes#typeinfo#new()
    type.typescript.ctagstype = 'typescript'
    type.typescript.kinds = {
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

    type.typescript.sro        = '.'
    type.typescript.kind2scope = {
        c = 'class',
        i = 'interface',
        g = 'enum',
        n = 'namespace'
    }

    type.typescript.scope2kind = {
        class       = 'c',
        interface   = 'i',
        enum        = 'g',
        namespace   = 'n'
    }

    type.tex = tagbar#prototypes#typeinfo#new()
    type.tex.ctagstype = 'tex'
    type.tex.kinds = {
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

    type.tex.sro        = '""'
    type.tex.kind2scope = {
        p = 'part',
        c = 'chapter',
        s = 'section',
        u = 'subsection',
        b = 'subsubsection'
    }

    type.tex.scope2kind = {
        part          = 'p',
        chapter       = 'c',
        section       = 's',
        subsection    = 'u',
        subsubsection = 'b'
    }

    type.tex.sort = 0

    -- Why are variables 'virtual'?
    type.vera = tagbar#prototypes#typeinfo#new()
    type.vera.ctagstype = 'vera'
    type.vera.kinds = {
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

    type.vera.sro        = '.' -- Nesting doesn't seem to be possible
    type.vera.kind2scope = {
        g = 'enum',
        c = 'class',
        v = 'virtual'
    }

    type.vera.scope2kind = {
        enum    = 'g',
        class   = 'c',
        virtual = 'v'
    }

    type.verilog = tagbar#prototypes#typeinfo#new()
    type.verilog.ctagstype = 'verilog'
    type.verilog.kinds     = {
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
    type.vhdl = tagbar#prototypes#typeinfo#new()
    type.vhdl.ctagstype = 'vhdl'
    type.vhdl.kinds = {
        {short = 'P', long = 'packages',   fold = 1, stl = 0},
        {short = 'c', long = 'constants',  fold = 0, stl = 0},
        {short = 't', long = 'types',      fold = 0, stl = 1},
        {short = 'T', long = 'subtypes',   fold = 0, stl = 1},
        {short = 'r', long = 'records',    fold = 0, stl = 1},
        {short = 'e', long = 'entities',   fold = 0, stl = 1},
        {short = 'f', long = 'functions',  fold = 0, stl = 1},
        {short = 'p', long = 'procedures', fold = 0, stl = 1}
    }

    type.vim = tagbar#prototypes#typeinfo#new()
    type.vim.ctagstype = 'vim'
    type.vim.kinds = {
        {short = 'n', long = 'vimball filenames',  fold = 0, stl = 1},
        {short = 'v', long = 'variables',          fold = 1, stl = 0},
        {short = 'f', long = 'functions',          fold = 0, stl = 1},
        {short = 'a', long = 'autocommand groups', fold = 1, stl = 1},
        {short = 'c', long = 'commands',           fold = 0, stl = 0},
        {short = 'm', long = 'maps',               fold = 1, stl = 0}
    }

    type.yacc = tagbar#prototypes#typeinfo#new()
    type.yacc.ctagstype = 'yacc'
    type.yacc.kinds = {
        {short = 'l', long = 'labels', fold = 0, stl = 1}
    }

    for type, typeinfo in items(types) do
        typeinfo.ftype = type
    end

    for typeinfo in values(types) do
        typeinfo.createKinddict()
    end

    return types
end

return ctags
