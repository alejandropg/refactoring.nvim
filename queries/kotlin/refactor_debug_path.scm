; `if (a) { ... }`
(if_expression
  (#set! text if)) @debug_path_segment

; `for (a in xs) { ... }`
(for_statement
  (#set! text for)) @debug_path_segment

; `while (a) { ... }`
(while_statement
  (#set! text while)) @debug_path_segment

; `do { ... } while (a)`
(do_while_statement
  (#set! text do)) @debug_path_segment

; `fun f() { ... }`
(function_declaration
  (simple_identifier) @_name
  (#set! text @_name)) @debug_path_segment

; `{ a -> ... }`
(lambda_literal
  (#set! text "(anon)")) @debug_path_segment
