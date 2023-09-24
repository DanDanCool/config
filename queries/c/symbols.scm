; for use in symbol tree plugin

(struct_specifier
	name: (type_identifier) @struct
	body: (field_declaration_list))

(type_definition
  declarator: (type_identifier) @typedef)

(function_declarator) @function
(preproc_function_def
	name: (identifier) @macro)

