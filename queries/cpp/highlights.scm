; inherits: c

((identifier) @field
	(#match? @field "^_"))

((identifier) @field
	(#match? @field "^m_"))

((identifier) @field
	(#match? @field "_$"))

;(field_expression) @parameter ;; How to highlight this?
(template_function
	name: (identifier) @function)

(template_method
	name: (field_identifier) @method)

(((field_expression
	(field_identifier) @method)) @_parent
	(#has-parent? @_parent template_method function_declarator call_expression))

(field_initializer
	(field_identifier) @property)

(function_declarator
	declarator: (field_identifier) @method)

(template_function
	name: (scoped_identifier
	name: (identifier) @function))

(namespace_identifier) @namespace

(namespace_definition
	name: (identifier) @namespace)

(destructor_name
	(identifier) @method)

(function_declarator
	declarator: (scoped_identifier
	name: (identifier) @function))

(operator_name) @function

(call_expression
	function: (scoped_identifier
	name: (identifier) @function))

(call_expression
	function: (field_expression
	field: (field_identifier) @function))

(ERROR (identifier)) @keyword

; Constants

(true) @boolean
(false) @boolean

; Literals

(raw_string_literal) @string

; Keywords

[
	"try"
	"catch"
	"noexcept"
	"throw"
] @exception


[
	"class"
	"decltype"
	"constexpr"
	"explicit"
	"final"
	"friend"
	"mutable"
	"namespace"
	"override"
	"private"
	"protected"
	"public"
	"template"
	"typename"
	"using"
	"virtual"
	"new"
	"delete"
	(auto)
	(this)
	(nullptr)
] @keyword

"::" @operator
"..." @operator
