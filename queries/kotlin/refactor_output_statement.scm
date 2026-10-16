; Statements with a body have their own patterns below, with `inside`. They're
; left out of this list rather than excluded with `#not-kind-eq?`, which comes
; from nvim-treesitter, not Neovim.
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

; A loop's label (`outer@ for`) is a separate node before the loop: it's the
; statement extract variable inserts above, and the loop is only used for its
; body (`inside_only`).

; Loops without a label: the first statement, or after anything but a label.
; The label is told by its text (`name@`; a comment can end in `@` too) because
; a list of the other types before the `.` anchor makes tree-sitter skip some
; matches (a loop right after another loop).
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

; A loop's label, with the loop's body: a debug print with the cursor on the
; label goes into the body or above the label.
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

; A labelled loop
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

; Only in statement position: `val m = if (a) { 1 } else { 2 }` isn't a statement.
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
