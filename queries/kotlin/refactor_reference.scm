; `val a: Int = 1`, `var a = 1`
(property_declaration
  (variable_declaration
    (simple_identifier) @reference.identifier
    (_)? @_type)
  (#set-type! kotlin @_type @reference.identifier)
  (#set! reference_type write)
  (#set! declaration))

; `fun f(a: Int)`
(parameter
  (simple_identifier) @reference.identifier
  (_) @_type
  (#set-type! kotlin @_type @reference.identifier)
  (#set! reference_type write)
  (#set! declaration))

; `for (a in xs)`
(for_statement
  (variable_declaration
    (simple_identifier) @reference.identifier)
  (#set! reference_type write)
  (#set! declaration))

; `{ a -> ... }`
(lambda_parameters
  (variable_declaration
    (simple_identifier) @reference.identifier)
  (#set! reference_type write)
  (#set! declaration))

; `a = 1`, `a += 1`
(assignment
  (directly_assignable_expression
    (simple_identifier) @reference.identifier)
  (#set! reference_type write))

; `a++`, `a--`
(postfix_expression
  (simple_identifier) @reference.identifier
  (#set! reference_type write))

; `f(a)`, `a + 1`, `a.b`
((simple_identifier) @reference.identifier
  (#not-has-parent? @reference.identifier
    variable_declaration parameter directly_assignable_expression navigation_suffix
    call_expression function_declaration identifier class_parameter)
  (#set! reference_type read))

; `"$a"`
((interpolated_identifier) @reference.identifier
  (#set! reference_type read))
