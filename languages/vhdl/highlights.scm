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
(function_call function: (simple_name) @function)

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

(physical_literal unit: (simple_name) @attribute)

; Attributes
(attribute_name designator: (predefined_designator) @attribute)

; Operators
; (operator: (_) @operator)
(function_body designator: (operator_symbol) @operator)
(function_body at_end: (operator_symbol) @operator)
(function_declaration designator: (operator_symbol) @operator)

[
  "(" ")" "[" "]"
] @punctuation.bracket

[
  "." ";" "," ":"
] @punctuation.delimeter

[
  "=>" "<=" "+" ":=" "=" "/=" "<" ">" "-" "*"
  "**" "/" "?>" "?<" "?<=" "?>=" "?=" "?/="
  ";" "'" "." ":" ","
; "?/" errors, maybe due to escape character
  (index_subtype_definition (any))
] @operator

[
  "not" "xor" "xnor" "and" "nand" "or" "nor" "mod" "rem" "abs"
  (index_subtype_definition (any))
] @keyword.operator

; Keywords
[
  "alias" "package" "file" "entity" "architecture" "type" "subtype"
  "attribute" "to" "downto" "signal" "variable" "record" "array"
  "others" "process" "component" "shared" "constant" "port" "generic"
  "generate" "range" "map" "in" "inout" "of" "out" "configuration"
  "pure" "impure" "is" "begin" "end" "context" "wait" "until" "after"
  "report" "open" "exit" "assert" "next" "null" "force" "property"
  "release" "sequence" "transport" "unaffected" "select" "severity"
  "register" "reject" "postponed" "on" "new" "literal" "linkage"
  "inertial" "guarded" "group" "disconnect" "bus" "buffer" "body"
  "all" "block" "access"
] @keyword

[
  "function" "procedure"
] @keyword.function

[
  "return"
] @keyword.return

[
  "for" "loop" "while"
] @keyword.repeat

[
  "if" "elsif" "else" "case" "then" "when"
] @keyword.conditional

[
  "library" "use"
] @keyword.include

; Comments
(comment) @comment

((simple_name) @constant.builtin (#any-of? @constant.builtin "true" "false" "now"))

(severity_expression) @constant.builtin

(ambiguous_name
  prefix: (simple_name) @function.builtin (#any-of? @function.builtin
    "rising_edge" "falling_edge" "find_rightmost" "find_leftmost"
    "maximum" "minimum" "shift_left" "shift_right" "rotate_left"
    "rotate_right" "sll" "srl" "rol" "ror" "sla" "sra" "resize"
    "mod" "rem" "abs" "saturate"
    "to_sfixed" "to_ufixed" "to_signed" "to_unsigned" "to_real"
    "to_integer" "sfixed_low" "ufixed_low" "sfixed_high"
    "ufixed_high" "to_slv" "to_stdulogicvector" "to_sulv"
    "to_float" "std_logic" "std_logic_vector" "integer" "signed"
    "unsigned" "real" "std_ulogic_vector"
    "std_ulogic" "x01" "x01z" "ux01" "ux01Z"
;math_real
    "sign" "ceil" "floor" "round" "fmax" "fmin" "uniform" "srand"
    "rand" "get_rand_max" "sqrt" "cbrt" "exp" "log" "log2" "log10"
    "sin" "cos" "tan" "asin" "acos" "atan" "atan2" "sinh" "cosh"
    "tanh" "asinh" "acosh" "atanh" "realmax" "realmin" "trunc"
    "conj" "arg" "polar_to_complex" "complex_to_polar"
    "get_principal_value" "cmplx"
;std_textio
    "read" "write" "hread" "hwrite" "to_hstring" "to_string"
    "from_hstring" "from_string"
    "justify" "readline" "sread" "string_read" " bread"
    "binary_read" "oread" "octal_read" "hex_read"
    "writeline" "swrite" "string_write" "bwrite"
    "binary_write" "owrite" "octal_write" "hex_write"
    "synthesis_return"
;std_logic_1164
    "resolved" "logic_type_encoding" "is_signed" "to_bit"
    "to_bitvector" "to_stdulogic" "to_stdlogicvector"
    "to_bit_vector" "to_bv" "to_std_logic_vector"
    "to_std_ulogic_vector" "to_01" "to_x01" "to_x01z" "to_ux01"
    "is_x" "to_bstring" "to_binary_string" "to_ostring"
    "to_octal_string" "to_hex_string"
;float_pkg
    "add" "subtract" "multiply" "divide" "remainder" "modulo"
    "reciprocal" "dividebyp2" "mac" "eq" "ne" "lt" "gt" "le" "ge"
    "to_float32" "to_float64" "to_float128" "realtobits" "bitstoreal"
    "break_number" "normalize" "copysign" "scalb" "logb" "nextafter"
    "unordered" "finite" "isnan" "zerofp" "nanfp" "qnanfp"
    "pos_inffp" "neg_inffp" "neg_zerofp" "from_bstring"
    "from_binary_string" "from_ostring" "from_octal_string"
    "from_hex_string"
;fixed_pkg
    "add_carry" "to_ufix" "to_sfix" "ufix_high"
    "ufix_low" "sfix_high" "sfix_low"
))
