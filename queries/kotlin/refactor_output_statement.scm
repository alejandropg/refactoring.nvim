; Statements with a body have their own pattern below, with `inside`
((statements
  (_) @output_statement)
  (#not-kind-eq? @output_statement
    "for_statement" "while_statement" "do_while_statement" "if_expression" "function_declaration"))

; Only in statement position: `val m = if (a) { 1 } else { 2 }` isn't a statement.
(statements
  (for_statement
    (control_structure_body
      (statements)? @output_statement.inside)?) @output_statement)

(statements
  (while_statement
    (control_structure_body
      (statements)? @output_statement.inside)?) @output_statement)

(statements
  (do_while_statement
    (control_structure_body
      (statements)? @output_statement.inside)?) @output_statement)

(statements
  (if_expression
    consequence: (control_structure_body
      (statements)? @output_statement.inside)?) @output_statement)

; Local functions
(statements
  (function_declaration
    (function_body
      (statements)? @output_statement.inside)?) @output_statement)

; Top-level and member functions
((function_declaration
  (function_body
    (statements) @output_statement.inside)) @output_statement
  (#not-has-parent? @output_statement statements)
  (#set! inside_only))

(lambda_literal
  (statements) @output_statement.inside
  (#set! inside_only)) @output_statement
