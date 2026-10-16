; `val a = 1`, `a = 1`, `f(a)`, `return a`
; All types but those with a body below: `#not-kind-eq?` isn't in Neovim.
(statements
  [
    (additive_expression)
    (annotation)
    (anonymous_function)
    (as_expression)
    (assignment)
    (bin_literal)
    (boolean_literal)
    (call_expression)
    (callable_reference)
    (character_literal)
    (check_expression)
    (class_declaration)
    (collection_literal)
    (comparison_expression)
    (conjunction_expression)
    (destructuring_declaration)
    (disjunction_expression)
    (elvis_expression)
    (equality_expression)
    (getter)
    (hex_literal)
    (indexing_expression)
    (infix_expression)
    (integer_literal)
    (jump_expression)
    (lambda_literal)
    (long_literal)
    (multiplicative_expression)
    (navigation_expression)
    (null_literal)
    (object_declaration)
    (object_literal)
    (parenthesized_expression)
    (postfix_expression)
    (prefix_expression)
    (property_declaration)
    (range_expression)
    (real_literal)
    (setter)
    (simple_identifier)
    (spread_expression)
    (string_literal)
    (super_expression)
    (this_expression)
    (try_expression)
    (type_alias)
    (unsigned_literal)
    (when_expression)
  ] @output_statement)

; `for (a in xs) { ... }`, `while (a) { ... }`, `do { ... } while (a)`
(statements
  .
  [
    (for_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (do_while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
  ] @output_statement)

; `f()`
; `for (a in xs) { ... }`
; The label is told by its text: a type list before `.` skips a loop after a loop.
((statements
  (_) @_previous
  .
  [
    (for_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (do_while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
  ] @output_statement)
  (#not-lua-match? @_previous "^[^/].*@$"))

; `outer@ for (a in xs) { ... }`
; The label isn't in the loop's node: insert above the label, not after it.
(statements
  (label) @output_statement
  .
  [
    (for_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (do_while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
  ])

; `outer@ for (a in xs) { ... }`
; `inside_only`: only the loop's body is used.
((statements
  (label)
  .
  [
    (for_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
    (do_while_statement
      (control_structure_body
        (statements)? @output_statement.inside)?)
  ] @output_statement)
  (#set! inside_only))

; `if (a) { ... }`
(statements
  (if_expression
    consequence: (control_structure_body
      (statements)? @output_statement.inside)?) @output_statement)

; `fun f() { fun g() { ... } }`
(statements
  (function_declaration
    (function_body
      (statements)? @output_statement.inside)?) @output_statement)

; `fun f() { ... }`, `class A { fun f() { ... } }`
; `inside_only`: not a statement, only its body is used.
((function_declaration
  (function_body
    (statements) @output_statement.inside)) @output_statement
  (#not-has-parent? @output_statement statements)
  (#set! inside_only))

; `{ a -> ... }`
; `inside_only`: not a statement, only its body is used.
(lambda_literal
  (statements) @output_statement.inside
  (#set! inside_only)) @output_statement
