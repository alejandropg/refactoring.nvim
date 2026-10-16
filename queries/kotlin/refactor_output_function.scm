; `// a`
; `fun f() { ... }`
(source_file
  _*
  [
    (line_comment)
    (multiline_comment)
  ]* @output_function.comment
  .
  (function_declaration) @output_function)

; `class A { /* a */ fun f() { ... } }`
(class_body
  _*
  [
    (line_comment)
    (multiline_comment)
  ]* @output_function.comment
  .
  (function_declaration) @output_function)
