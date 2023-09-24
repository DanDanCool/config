; for use in symbol tree plugin

(function_definition
  name: (identifier) @function)

(class_definition
  name: (identifier) @class)

(class_definition
  body: (block
		  (function_definition
			name: (identifier) @method)))
