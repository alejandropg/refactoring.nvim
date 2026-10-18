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

; `a++`, `a--`, `++a`, `--a`
([
  (postfix_expression
    (simple_identifier) @reference.identifier
    [
      "++"
      "--"
    ])
  (prefix_expression
    [
      "++"
      "--"
    ]
    (simple_identifier) @reference.identifier)
]
  (#set! reference_type write))

; Identifiers read as expressions
([
  ; `a + 1`, `a - 1`
  (additive_expression
    (simple_identifier) @reference.identifier)
  ; `a * 2`, `a / 2`, `a % 2`
  (multiplicative_expression
    (simple_identifier) @reference.identifier)
  ; `a < b`
  (comparison_expression
    (simple_identifier) @reference.identifier)
  ; `a == b`, `a != b`
  (equality_expression
    (simple_identifier) @reference.identifier)
  ; `a && b`
  (conjunction_expression
    (simple_identifier) @reference.identifier)
  ; `a || b`
  (disjunction_expression
    (simple_identifier) @reference.identifier)
  ; `a ?: b`
  (elvis_expression
    (simple_identifier) @reference.identifier)
  ; `a..b`
  (range_expression
    (simple_identifier) @reference.identifier)
  ; `-a`, `+a`, `!a`
  (prefix_expression
    [
      "-"
      "+"
      "!"
    ]
    (simple_identifier) @reference.identifier)
  ; `a!!`
  (postfix_expression
    (simple_identifier) @reference.identifier
    "!!")
  ; `a as T`
  (as_expression
    (simple_identifier) @reference.identifier)
  ; `a is T`, `a in xs`
  (check_expression
    (simple_identifier) @reference.identifier)
  ; `f(*a)`
  (spread_expression
    (simple_identifier) @reference.identifier)
  ; `(a)`
  (parenthesized_expression
    (simple_identifier) @reference.identifier)
  ; `a.b`
  (navigation_expression
    (simple_identifier) @reference.identifier)
  ; `a[i]`
  (indexing_expression
    (simple_identifier) @reference.identifier)
  ; `xs[a]`
  (indexing_suffix
    (simple_identifier) @reference.identifier)
  ; `[a]`
  (collection_literal
    (simple_identifier) @reference.identifier)
  ; `"${a}"`
  (interpolated_expression
    (simple_identifier) @reference.identifier)
  ; `return a`, `throw a`
  (jump_expression
    (simple_identifier) @reference.identifier)
  ; `if (a) ...`
  (if_expression
    (simple_identifier) @reference.identifier)
  ; `when (a) { ... }`
  (when_subject
    (simple_identifier) @reference.identifier)
  ; `when (x) { a -> ... }`
  (when_condition
    (simple_identifier) @reference.identifier)
  ; `when (x) { in a -> ... }`
  (range_test
    (simple_identifier) @reference.identifier)
  ; `when (x) { is T if a -> ... }`
  (guard_condition
    (simple_identifier) @reference.identifier)
  ; `while (a) ...`
  (while_statement
    (simple_identifier) @reference.identifier)
  ; `do { ... } while (a)`
  (do_while_statement
    (simple_identifier) @reference.identifier)
  ; `for (x in a)`
  (for_statement
    (simple_identifier) @reference.identifier)
  ; `if (c) a else b`
  (control_structure_body
    (simple_identifier) @reference.identifier)
  ; `{ a }`
  (statements
    (simple_identifier) @reference.identifier)
  ; `fun f() = a`
  (function_body
    (simple_identifier) @reference.identifier)
  ; `val x = a`
  (property_declaration
    (simple_identifier) @reference.identifier)
  ; `val x by a`
  (property_delegate
    (simple_identifier) @reference.identifier)
  ; `class C(a: I) : I by a`
  (explicit_delegation
    (simple_identifier) @reference.identifier)
  ; `x = a`
  (assignment
    (simple_identifier) @reference.identifier)
]
  (#set! reference_type read))

; `f(a)`, `f(x = a)`
((value_argument
  (simple_identifier) @reference.identifier
  .)
  (#set! reference_type read))

; `a to b`
([
  (infix_expression
    .
    (simple_identifier) @reference.identifier)
  (infix_expression
    (simple_identifier) @reference.identifier
    .)
]
  (#set! reference_type read))

; `"$a"`
((interpolated_identifier) @reference.identifier
  (#set! reference_type read))
