; `val a = 1`
; Separators aren't captured, so the whole line is deleted.
; NOTE: we don't support destructuring declarations (`val (a, b) = pair`)
; because the value is a single expression read through `componentN()`, so
; there are no per-identifier values to match together by order.
(property_declaration
  (variable_declaration
    (simple_identifier) @variable.identifier)
  .
  (_) @variable.value) @variable.declaration
