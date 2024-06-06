; Brackets
("(" @open ")" @close)
("[" @open "]" @close)

; Strings
("\"" @open "\"" @close)

; Begin end
("begin" @open "end" @close)
("is" @open "begin" @close)
("is" @open "end" @close)
("loop" @open "end" @close)
("loop" @open "loop" @close)
((for_loop "for" @open) "loop" "loop" @close)
((while_loop "while" @open) "loop" "loop" @close)
("generate" @open "end" @close)
("generate" @open "generate" @close)
("for" @open "generate" "generate" @close)

; If statements
(if_statement (if "then" @open) . "end" @close)
(if_statement (if "then" @open) . (else "else" @close))
(if_statement (if "then" @open) . (elsif "elsif" @close))
(if_statement (else "else" @open) . "end" @close)
(if_statement (elsif "then" @open) . (else "else" @close))
(if_statement (elsif "then" @open) . (elsif "elsif" @close))
(if_statement (if "if" @open) "if" @close)

; Other statements
("package" @open "package" @close)
("function" @open "function" @close)
("entity" @open "entity" @close)
("component" @open "component" @close)
("architecture" @open "architecture" @close)
("process" @open "process" @close)
("case" @open "case" @close)
("record" @open "record" @close)
