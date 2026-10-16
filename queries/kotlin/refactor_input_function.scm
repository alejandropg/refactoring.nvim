; `fun f() { ... }`
(source_file
  (function_declaration) @input_function)

; `class A { fun f() { ... } }`
(class_body
  (function_declaration) @input_function
  (#set! method))
