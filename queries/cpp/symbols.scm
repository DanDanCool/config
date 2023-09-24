; inherits: c
; for use in the symbol tree plugin

(namespace_definition
  name: (namespace_identifier) @namespace)

(struct_specifier
	body: (field_declaration_list
			(function_definition
			  declarator: (function_declarator) @method)))

(class_specifier
	name: (type_identifier) @class
	body: (field_declaration_list))

(class_specifier
	body: (field_declaration_list
			(function_definition
			  declarator: (function_declarator) @method)))


