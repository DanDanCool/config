[
	"const"
	"default"
	"enum"
	"extern"
	"inline"
	"return"
	"sizeof"
	"static"
	"struct"
	"typedef"
	"union"
	"volatile"
	"goto"
	"register"
] @keyword

[
	"while"
	"for"
	"do"
	"continue"
	"break"
] @repeat

[
	"if"
	"else"
	"case"
	"switch"
] @conditional

"#define" @constant.macro

[
	"#if"
	"#ifdef"
	"#ifndef"
	"#else"
	"#elif"
	"#endif"
	(preproc_directive)
] @keyword

"#include" @include

[
	"="

	"-"
	"*"
	"/"
	"+"
	"%"

	"~"
	"|"
	"&"
	"^"
	"<<"
	">>"

	"<"
	"<="
	">="
	">"
	"=="
	"!="

	"!"
	"&&"
	"||"

	"-="
	"+="
	"*="
	"/="
	"%="
	"|="
	"&="
	"^="
	">>="
	"<<="
	"--"
	"++"
] @operator

[
	(true)
	(false)
] @boolean

[ "." ";" ":" "," "->" ] @punctuation.delimiter

(conditional_expression [ "?" ":" ] @conditional)


[ "(" ")" "[" "]" "{" "}"] @punctuation.bracket

(string_literal) @string
(system_lib_string) @string

(null) @constant.builtin
(number_literal) @number
(char_literal) @character

(call_expression
	function: (identifier) @function)

(call_expression
	function: (field_expression
	field: (field_identifier) @function))

(function_declarator
	declarator: (identifier) @function)

(preproc_function_def
	name: (identifier) @function.macro)

[
	(preproc_arg)
	(preproc_defined)
] @function.macro

(((field_expression
	(field_identifier) @property)) @_parent
	(#not-has-parent? @_parent template_method function_declarator call_expression))

(((field_identifier) @property)
	(#has-ancestor? @property field_declaration)
	(#not-has-ancestor? @property function_declarator))

(statement_identifier) @label

[
	(type_identifier)
	(sized_type_specifier)
	(type_descriptor)
] @type

(primitive_type) @type.builtin

(declaration (type_qualifier) @type)
(cast_expression type: (type_descriptor) @type)
(sizeof_expression value: (parenthesized_expression (identifier) @type))

((identifier) @constant
	(#match? @constant "^[A-Z][A-Z0-9_]+$"))

;; Preproc def / undef
(preproc_def
	name: (_) @constant)

(preproc_call
	directive: (preproc_directive) @_u
	argument: (_) @constant
	(#eq? @_u "#undef"))

(comment) @comment
