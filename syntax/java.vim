syntax clear

let b:current_syntax = "java"

"-------------------------------------------------
hi def link javaComment         Comment
"-------------------------------------------------
hi def link javaConstant        Constant
hi def link javaString          String
hi def link javaCharacter       Character
hi def link javaNumber          Number
hi def link javaBoolean         Boolean
hi def link javaFloat           Float
"-------------------------------------------------
hi def link javaIdentifier      Identifier
hi def link javaFunction        Function
"-------------------------------------------------
hi def link javaStatement       Statement
hi def link javaConditional     Conditional
hi def link javaRepeat          Repeat
hi def link javaLabel           Label
hi def link javaOperator        Operator
hi def link javaKeyword         Keyword
hi def link javaException       Exception
"-------------------------------------------------
hi def link javaPreProc         PreProc
hi def link javaInclude         Include
hi def link javaDefine          Define
hi def link javaMacro           Macro
hi def link javaPreCondit       PreCondit
"-------------------------------------------------
hi def link javaType            TSType
hi def link javaStorageClass    StorageClass
hi def link javaStructure       Structure
hi def link javaTypedef         Typedef
"-------------------------------------------------
hi def link javaSpecial         Special
hi def link javaSpecialChar     SpecialChar
hi def link javaTag             Tag
hi def link javaDelimiter       Delimiter
hi def link javaSpecialComment  SpecialComment
hi def link javaDebug           Debug
"-------------------------------------------------
hi def link javaUnderlined      Underlined
"-------------------------------------------------
hi def link javaIgnore          Ignore
"-------------------------------------------------
hi def link javaError           Error
"-------------------------------------------------
hi def link javaTodo            Todo
"-------------------------------------------------
""-------------------------------------------------
hi def link javaDecNumber       javaNumber
hi def link javaOctNumber       javaNumber
hi def link javaHexNumber       javaNumber
hi def link javaBinNumber       javaNumber
"-------------------------------------------------
hi def link javaDecFloat        javaFloat
hi def link javaHexFloat        javaFloat
"-------------------------------------------------
hi def link javaAccessKeyword   javaKeyword
"-------------------------------------------------
hi def link javaTodoTask        javaTodo
hi def link javaTodoNote        javaTodo
hi def link javaTodoWarn        javaTodo
"-------------------------------------------------
sy cluster javaTodos    contains=javaTodoTask,javaTodoNote,javaTodoWarn
"-----------------------------------------------------------------------------------------
sy keyword javaConstant         this super
sy keyword javaConstant         null
sy keyword javaBoolean          true false
"-----------------------------------------------------------------------------------------
sy keyword javaStatement        return
sy keyword javaStatement        break continue
sy keyword javaStatement        yield
sy keyword javaConditional      if else switch
sy keyword javaRepeat           for while do
sy keyword javaLabel            case default
sy keyword javaOperator         new                 skipwhite skipempty nextgroup=javaType
sy keyword javaOperator         instanceof          skipwhite skipempty nextgroup=javaType
sy keyword javaAccessKeyword    public protected private
sy keyword javaException        throw
sy keyword javaException        try catch finally
"-----------------------------------------------------------------------------------------
sy keyword javaPreProc          package
"-----------------------------------------------------------------------------------------
sy keyword javaType             void
sy keyword javaType             char
sy keyword javaType             byte short int long
sy keyword javaType             boolean
sy keyword javaType             float double
sy keyword javaType             var
sy keyword javaStorageClass     static transient final abstract
sy keyword javaStorageClass     volatile strictfp native
sy keyword javaStorageClass     synchronized
sy keyword javaStructure        class interface     skipwhite skipempty nextgroup=javaType
sy keyword javaStructure        enum                skipwhite skipempty nextgroup=javaType
sy keyword javaStructure        extends implements  skipwhite skipempty nextgroup=javaType
sy keyword javaStructure        permits             skipwhite skipempty nextgroup=javaType
sy keyword javaStructure        throws              skipwhite skipempty nextgroup=javaType
sy keyword javaStructure        record              skipwhite skipempty nextgroup=javaType
"-----------------------------------------------------------------------------------------
sy keyword javaDebug            assert
"-----------------------------------------------------------------------------------------
sy keyword javaError            goto const
"-----------------------------------------------------------------------------------------
sy keyword javaTodoTask         TODO FIXME  contained
sy keyword javaTodoNote         NOTE        contained
sy keyword javaTodoWarn         XXX NB      contained
"-----------------------------------------------------------------------------------------
""---------------------------------------------------------------------------------------------------
sy match  javaOperator      '[+\-\~!\*/%<>=&\^|?:]'
sy match  javaDelimiter     '[()\.\[\],;{}]'
sy match  javaIdentifier    '\v<%(\h|\$)%(\w|\$)*>'
sy match  javaFunction      '\v<%(\h|\$)%(\w|\$)*>\ze\_s*\(\_.{-}\)'
sy match  javaType          '\v<\$*\u%(\w|\$)*>'
sy match  javaConstant      '\v<%(\u|[_\$])%(\u|\d|[_\$])*>'
"---------------------------------------------------------------------------------------------------
sy match  javaComment       '//.*'                  contains=@javaTodos
sy region javaComment       start='/\*' end='\*/'   contains=@javaTodos
"---------------------------------------------------------------------------------------------------
sy match  javaString        '\v"%([^\\"]|\\.)*"'
sy region javaString        start='"""\s*$' end='"""'
sy match  javaCharacter     "'[^\\']'"
sy match  javaCharacter     "'\\[btnfr\"'\\]'"
sy match  javaCharacter     "\v'\\%(\o{1,3}|u\x{4})'"
"---------------------------------------------------------------------------------------------------
sy match  javaDecNumber     '\v\c<\d%(\d|_*\d)*L=>'
sy match  javaOctNumber     '\v\c<0%(\o|_*\o)+L=>'
sy match  javaHexNumber     '\v\c<0X\x%(\x|_*\x)*L=>'
sy match  javaBinNumber     '\v\c<0B[01]%([01]|_*[01])*L=>'
"---------------------------------------------------------------------------------------------------
sy match  javaDecFloat      '\v\c<\d%(\d|_*\d)*%(E[+-]=\d%(\d|_*\d)*[FD]=|[FD])>'
sy match  javaDecFloat      '\v\c<\d%(\d|_*\d)*\.%(\d%(\d|_*\d)*)=%(E[+-]=\d%(\d|_*\d)*)=[FD]='
sy match  javaDecFloat      '\v\c\.\d%(\d|_*\d)*%(E[+-]=\d%(\d|_*\d)*)=[FD]='
sy match  javaHexFloat      '\v\c<0X\x%(\x|_*\x)*%(P[+-]=\d%(\d|_*\d)*[FD]=|[FD])>'
sy match  javaHexFloat      '\v\c<0X\x%(\x|_*\x)*\.%(\x%(\x|_*\x)*)=%(P[+-]=\d%(\d|_*\d)*)=[FD]='
sy match  javaHexFloat      '\v\c<0X\.\x%(\x|_*\x)*%(P[+-]=\d%(\d|_*\d)*)=[FD]='
"---------------------------------------------------------------------------------------------------
sy match  javaPreProc       '@\h\w*'
sy match  javaInclude       '\v<import%(\_s+static)=>'
\   skipwhite skipempty nextgroup=javaPackagePath
sy match  javaPackagePath   '\v<%(%(\w|\$)+\_s*\.\_s*)*%(\w|\$)+>'
\   contained contains=javaIdentifier,javaDelimiter
"---------------------------------------------------------------------------------------------------
