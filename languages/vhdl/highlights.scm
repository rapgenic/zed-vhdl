; Types
(type_mark) @type
(full_type_declaration name: (identifier) @type)
(subtype_declaration name: (identifier) @type)
(incomplete_type_declaration name: (identifier) @type)

; Hierarchy
(entity_declaration name: (identifier) @label)
(component_declaration name: (identifier) @label)
(component_instantiation component: (simple_name) @label)
(component_configuration (instantiation_list (simple_name) @label))
(component_configuration component: (simple_name) @label)
(architecture_body name: (identifier) @label)
(architecture_body entity: (simple_name) @label)
(entity_instantiation entity: (selected_name (simple_name) @label))
(entity_instantiation entity: (simple_name) @label)
(entity_instantiation architecture: (simple_name) @label)
(package_body package: (simple_name) @label)
(package_declaration name: (identifier) @label)
(package_instantiation_declaration name: (identifier) @label)
(package_instantiation_declaration uninstantiated: (selected_name (simple_name) @label))
(configuration_declaration name: (identifier) @label)
(configuration_declaration entity: (simple_name) @label)
(block_specification name_or_label: (simple_name) @label)
(context_declaration name: (identifier) @label)

; Labels
(label) @label
(_ at_end: (simple_name) @label)
(protected_type_declaration at_end: (simple_name) @type (#set! "priority" 101))
(protected_type_body at_end: (simple_name) @type (#set! "priority" 101))
(record_type_definition at_end: (simple_name) @type (#set! "priority" 101))
(physical_type_definition at_end: (simple_name) @type (#set! "priority" 101))
(function_body at_end: (simple_name) @function (#set! "priority" 101))
(procedure_body at_end: (simple_name) @function (#set! "priority" 101))

; Functions
(function_declaration designator: (identifier) @function)
(function_body designator: (identifier) @function)
(procedure_declaration designator: (identifier) @function)
(procedure_body designator: (identifier) @function)
(procedure_call_statement procedure: (simple_name) @function)
(resolution_function) @function

; Literals
[
    (integer_decimal)
    (based_integer)
    (real_decimal)
] @number

[
    (character_literal)
    (string_literal)
    (bit_string_literal)
] @string

; Attributes
(attribute_name designator: (predefined_designator) @attribute)

; Tokens
[
    ";"
    "."
    ","
    ":"
] @punctuation.delimiter

[
    "(" ")"
    "[" "]"
] @punctuation.bracket

; Operators
; (operator: (_) @operator)
(function_body designator: (operator_symbol) @operator)
(function_body at_end: (operator_symbol) @operator)
(function_declaration designator: (operator_symbol) @operator)
[
    "not" "and" "or" "nand" "nor" "xor" "xnor"
    "=" "/=" "<" "<=" ">" ">="
    "?=" "?/=" "?>" "?>=" "?<" "?<="
    "sll" "srl" "sla" "sra" "rol" "ror"
    "abs" "+" "-" "*" "/" "mod" "rem" "**"
    "&" "??"
    ":=" "=>"
    ";"
    "."
    ","
    ":"
] @operator

; Keywords
[
    "access"
    "after"
    "alias"
    "all"
    "architecture"
    "array"
    "assert"
    "attribute"
    "begin"
    "block"
    "body"
    "buffer"
    "bus"
    "case"
    "component"
    "configuration"
    "constant"
    "context"
    "disconnect"
    "downto"
    "else"
    "elsif"
    "end"
    "entity"
    "exit"
    "file"
    "for"
    "function"
    "generate"
    "generic"
    "group"
    "guarded"
    "if"
    "impure"
    "in"
    "inertial"
    "inout"
    "is"
    "label"
    "library"
    "linkage"
    "literal"
    "loop"
    "map"
    "new"
    "next"
    "null"
    "of"
    "on"
    "open"
    "others"
    "out"
    "package"
    "port"
    "postponed"
    "procedure"
    "process"
    "protected"
    "pure"
    "range"
    "record"
    "register"
    "reject"
    "report"
    "return"
    "select"
    "severity"
    "signal"
    "shared"
    "subtype"
    "then"
    "to"
    "transport"
    "type"
    "unaffected"
    "units"
    "until"
    "use"
    "variable"
    "wait"
    "when"
    "while"
    "with"
] @keyword

; Comments
(comment) @comment
