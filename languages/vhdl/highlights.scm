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
  "=>" "<=" "+" ":=" "=" "/=" "<" ">" "-" "*" ">="
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

((simple_name) @constant.builtin
	(#match? @constant.builtin "^(([tT][rR][uU][eE])|([fF][aA][lL][sS][eE])|([nN][oO][wW]))$")
)

(severity_expression) @constant.builtin

(ambiguous_name
  prefix: (simple_name) @function.builtin (#match? @function.builtin
    "^(([rR][iI][sS][iI][nN][gG]_[eE][dD][gG][eE])|([fF][aA][lL][lL][iI][nN][gG]_[eE][dD][gG][eE])|([fF][iI][nN][dD]_[rR][iI][gG][hH][tT][mM][oO][sS][tT])|([fF][iI][nN][dD]_[lL][eE][fF][tT][mM][oO][sS][tT])|([mM][aA][xX][iI][mM][uU][mM])|([mM][iI][nN][iI][mM][uU][mM])|([sS][hH][iI][fF][tT]_[lL][eE][fF][tT])|([sS][hH][iI][fF][tT]_[rR][iI][gG][hH][tT])|([rR][oO][tT][aA][tT][eE]_[lL][eE][fF][tT])|([rR][oO][tT][aA][tT][eE]_[rR][iI][gG][hH][tT])|([sS][lL][lL])|([sS][rR][lL])|([rR][oO][lL])|([rR][oO][rR])|([sS][lL][aA])|([sS][rR][aA])|([rR][eE][sS][iI][zZ][eE])|([mM][oO][dD])|([rR][eE][mM])|([aA][bB][sS])|([sS][aA][tT][uU][rR][aA][tT][eE])|([tT][oO]_[sS][fF][iI][xX][eE][dD])|([tT][oO]_[uU][fF][iI][xX][eE][dD])|([tT][oO]_[sS][iI][gG][nN][eE][dD])|([tT][oO]_[uU][nN][sS][iI][gG][nN][eE][dD])|([tT][oO]_[rR][eE][aA][lL])|([tT][oO]_[iI][nN][tT][eE][gG][eE][rR])|([sS][fF][iI][xX][eE][dD]_[lL][oO][wW])|([uU][fF][iI][xX][eE][dD]_[lL][oO][wW])|([sS][fF][iI][xX][eE][dD]_[hH][iI][gG][hH])|([uU][fF][iI][xX][eE][dD]_[hH][iI][gG][hH])|([tT][oO]_[sS][lL][vV])|([tT][oO]_[sS][tT][dD][uU][lL][oO][gG][iI][cC][vV][eE][cC][tT][oO][rR])|([tT][oO]_[sS][uU][lL][vV])|([tT][oO]_[fF][lL][oO][aA][tT])|([sS][tT][dD]_[lL][oO][gG][iI][cC])|([sS][tT][dD]_[lL][oO][gG][iI][cC]_[vV][eE][cC][tT][oO][rR])|([iI][nN][tT][eE][gG][eE][rR])|([sS][iI][gG][nN][eE][dD])|([uU][nN][sS][iI][gG][nN][eE][dD])|([rR][eE][aA][lL])|([sS][tT][dD]_[uU][lL][oO][gG][iI][cC]_[vV][eE][cC][tT][oO][rR])|([sS][tT][dD]_[uU][lL][oO][gG][iI][cC])|([xX]01)|([xX]01[zZ])|([uU][xX]01)|([uU][xX]01[zZ])|([sS][iI][gG][nN])|([cC][eE][iI][lL])|([fF][lL][oO][oO][rR])|([rR][oO][uU][nN][dD])|([fF][mM][aA][xX])|([fF][mM][iI][nN])|([uU][nN][iI][fF][oO][rR][mM])|([sS][rR][aA][nN][dD])|([rR][aA][nN][dD])|([gG][eE][tT]_[rR][aA][nN][dD]_[mM][aA][xX])|([sS][qQ][rR][tT])|([cC][bB][rR][tT])|([eE][xX][pP])|([lL][oO][gG])|([lL][oO][gG]2)|([lL][oO][gG]10)|([sS][iI][nN])|([cC][oO][sS])|([tT][aA][nN])|([aA][sS][iI][nN])|([aA][cC][oO][sS])|([aA][tT][aA][nN])|([aA][tT][aA][nN]2)|([sS][iI][nN][hH])|([cC][oO][sS][hH])|([tT][aA][nN][hH])|([aA][sS][iI][nN][hH])|([aA][cC][oO][sS][hH])|([aA][tT][aA][nN][hH])|([rR][eE][aA][lL][mM][aA][xX])|([rR][eE][aA][lL][mM][iI][nN])|([tT][rR][uU][nN][cC])|([cC][oO][nN][jJ])|([aA][rR][gG])|([pP][oO][lL][aA][rR]_[tT][oO]_[cC][oO][mM][pP][lL][eE][xX])|([cC][oO][mM][pP][lL][eE][xX]_[tT][oO]_[pP][oO][lL][aA][rR])|([gG][eE][tT]_[pP][rR][iI][nN][cC][iI][pP][aA][lL]_[vV][aA][lL][uU][eE])|([cC][mM][pP][lL][xX])|([rR][eE][aA][dD])|([wW][rR][iI][tT][eE])|([hH][rR][eE][aA][dD])|([hH][wW][rR][iI][tT][eE])|([tT][oO]_[hH][sS][tT][rR][iI][nN][gG])|([tT][oO]_[sS][tT][rR][iI][nN][gG])|([fF][rR][oO][mM]_[hH][sS][tT][rR][iI][nN][gG])|([fF][rR][oO][mM]_[sS][tT][rR][iI][nN][gG])|([jJ][uU][sS][tT][iI][fF][yY])|([rR][eE][aA][dD][lL][iI][nN][eE])|([sS][rR][eE][aA][dD])|([sS][tT][rR][iI][nN][gG]_[rR][eE][aA][dD])|([bB][rR][eE][aA][dD])|([bB][iI][nN][aA][rR][yY]_[rR][eE][aA][dD])|([oO][rR][eE][aA][dD])|([oO][cC][tT][aA][lL]_[rR][eE][aA][dD])|([hH][eE][xX]_[rR][eE][aA][dD])|([wW][rR][iI][tT][eE][lL][iI][nN][eE])|([sS][wW][rR][iI][tT][eE])|([sS][tT][rR][iI][nN][gG]_[wW][rR][iI][tT][eE])|([bB][wW][rR][iI][tT][eE])|([bB][iI][nN][aA][rR][yY]_[wW][rR][iI][tT][eE])|([oO][wW][rR][iI][tT][eE])|([oO][cC][tT][aA][lL]_[wW][rR][iI][tT][eE])|([hH][eE][xX]_[wW][rR][iI][tT][eE])|([sS][yY][nN][tT][hH][eE][sS][iI][sS]_[rR][eE][tT][uU][rR][nN])|([rR][eE][sS][oO][lL][vV][eE][dD])|([lL][oO][gG][iI][cC]_[tT][yY][pP][eE]_[eE][nN][cC][oO][dD][iI][nN][gG])|([iI][sS]_[sS][iI][gG][nN][eE][dD])|([tT][oO]_[bB][iI][tT])|([tT][oO]_[bB][iI][tT][vV][eE][cC][tT][oO][rR])|([tT][oO]_[sS][tT][dD][uU][lL][oO][gG][iI][cC])|([tT][oO]_[sS][tT][dD][lL][oO][gG][iI][cC][vV][eE][cC][tT][oO][rR])|([tT][oO]_[bB][iI][tT]_[vV][eE][cC][tT][oO][rR])|([tT][oO]_[bB][vV])|([tT][oO]_[sS][tT][dD]_[lL][oO][gG][iI][cC]_[vV][eE][cC][tT][oO][rR])|([tT][oO]_[sS][tT][dD]_[uU][lL][oO][gG][iI][cC]_[vV][eE][cC][tT][oO][rR])|([tT][oO]_01)|([tT][oO]_[xX]01)|([tT][oO]_[xX]01[zZ])|([tT][oO]_[uU][xX]01)|([iI][sS]_[xX])|([tT][oO]_[bB][sS][tT][rR][iI][nN][gG])|([tT][oO]_[bB][iI][nN][aA][rR][yY]_[sS][tT][rR][iI][nN][gG])|([tT][oO]_[oO][sS][tT][rR][iI][nN][gG])|([tT][oO]_[oO][cC][tT][aA][lL]_[sS][tT][rR][iI][nN][gG])|([tT][oO]_[hH][eE][xX]_[sS][tT][rR][iI][nN][gG])|([aA][dD][dD])|([sS][uU][bB][tT][rR][aA][cC][tT])|([mM][uU][lL][tT][iI][pP][lL][yY])|([dD][iI][vV][iI][dD][eE])|([rR][eE][mM][aA][iI][nN][dD][eE][rR])|([mM][oO][dD][uU][lL][oO])|([rR][eE][cC][iI][pP][rR][oO][cC][aA][lL])|([dD][iI][vV][iI][dD][eE][bB][yY][pP]2)|([mM][aA][cC])|([eE][qQ])|([nN][eE])|([lL][tT])|([gG][tT])|([lL][eE])|([gG][eE])|([tT][oO]_[fF][lL][oO][aA][tT]32)|([tT][oO]_[fF][lL][oO][aA][tT]64)|([tT][oO]_[fF][lL][oO][aA][tT]128)|([rR][eE][aA][lL][tT][oO][bB][iI][tT][sS])|([bB][iI][tT][sS][tT][oO][rR][eE][aA][lL])|([bB][rR][eE][aA][kK]_[nN][uU][mM][bB][eE][rR])|([nN][oO][rR][mM][aA][lL][iI][zZ][eE])|([cC][oO][pP][yY][sS][iI][gG][nN])|([sS][cC][aA][lL][bB])|([lL][oO][gG][bB])|([nN][eE][xX][tT][aA][fF][tT][eE][rR])|([uU][nN][oO][rR][dD][eE][rR][eE][dD])|([fF][iI][nN][iI][tT][eE])|([iI][sS][nN][aA][nN])|([zZ][eE][rR][oO][fF][pP])|([nN][aA][nN][fF][pP])|([qQ][nN][aA][nN][fF][pP])|([pP][oO][sS]_[iI][nN][fF][fF][pP])|([nN][eE][gG]_[iI][nN][fF][fF][pP])|([nN][eE][gG]_[zZ][eE][rR][oO][fF][pP])|([fF][rR][oO][mM]_[bB][sS][tT][rR][iI][nN][gG])|([fF][rR][oO][mM]_[bB][iI][nN][aA][rR][yY]_[sS][tT][rR][iI][nN][gG])|([fF][rR][oO][mM]_[oO][sS][tT][rR][iI][nN][gG])|([fF][rR][oO][mM]_[oO][cC][tT][aA][lL]_[sS][tT][rR][iI][nN][gG])|([fF][rR][oO][mM]_[hH][eE][xX]_[sS][tT][rR][iI][nN][gG])|([aA][dD][dD]_[cC][aA][rR][rR][yY])|([tT][oO]_[uU][fF][iI][xX])|([tT][oO]_[sS][fF][iI][xX])|([uU][fF][iI][xX]_[hH][iI][gG][hH])|([uU][fF][iI][xX]_[lL][oO][wW])|([sS][fF][iI][xX]_[hH][iI][gG][hH])|([sS][fF][iI][xX]_[lL][oO][wW]))$"
))
