; Declarations

(entity_declaration
    "entity" @context
    name: (_) @name
) @item

(configuration_declaration
    "configuration" @context
    name: (_) @name
) @item

(procedure_declaration
    "procedure" @context
    designator: (_) @name
) @item

(function_declaration
    "function" @context
    designator: (_) @name
) @item

; TODO: procedure_instantiation_declaration
; TODO: function_instantiation_declaration

(package_declaration
    "package" @context
    name: (_) @name
) @item

(package_instantiation_declaration
    "package" @context
    name: (_) @name
) @item

(primary_unit_declaration name: (_) @name) @item
(secondary_unit_declaration name: (_) @name) @item
(element_declaration (identifier_list (identifier) @name)) @item
(incomplete_type_declaration name: (_) @name) @item

(full_type_declaration
    "type" @context
    name: (_) @name
) @item

(subtype_declaration
    "subtype" @context
    name: (_) @name
) @item

(constant_declaration
    "constant" @context
    (identifier_list (identifier) @name)
) @item

(signal_declaration
    "signal" @context
    (identifier_list (identifier) @name)
) @item

(variable_declaration
    "variable" @context
    (identifier_list (identifier) @name)
) @item

(shared_variable_declaration
    "shared" @context
    "variable" @context
    (identifier_list (identifier) @name)
) @item

(file_declaration
    "file" @context
    (identifier_list (identifier) @name)
) @item

(alias_declaration
    "alias" @context
    designator: (_) @name
) @item

(attribute_declaration
    "attribute" @context
    name: (_) @name
) @item

(component_declaration
    "component" @context
    name: (_) @name
) @item

(group_template_declaration
    "group" @context
    name: (_) @name
) @item

(group_declaration
    "group" @context
    name: (_) @name
) @item

(context_declaration
    "context" @context
    name: (_) @name
) @item

; Bodies

(architecture_body
    "architecture" @context
    name: (_) @name
    "of" @context.extra
    entity: (_) @context.extra
) @item

(package_body
    "package" @context
    "body" @context
    package: (_) @name
) @item

(function_body
    "function" @context
    designator: (_) @name
) @item

(procedure_body
    "procedure" @context
    designator: (_) @name
) @item

; Instantiations

(process_statement
    . (label)? @name
    . "process" @context
) @item

(component_instantiation_statement
    . (label)? @name
    . (entity_instantiation) @context
) @item

(component_instantiation_statement
    . (label)? @name
    . (configuration_instantiation) @context
) @item

(component_instantiation_statement
    . (label)? @name
    . (component_instantiation) @context
) @item

(for_generate_statement
    . (label)? @name
    . "for" @context
    . (parameter_specification)
    . "generate" @context
) @item

(if_generate_statement
    . (label)? @name
    . (if_generate "if" @context)
    . "generate" @context
) @item

(case_generate_statement
    . (label)? @name
    . "case" @context
    . (expression)
    . "generate" @context
) @item

; Other

(attribute_specification
    "attribute" @context
    name: (_) @name
    "of" @context.extra
    (entity_specification) @context.extra
) @item
