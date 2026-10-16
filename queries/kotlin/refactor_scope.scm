; `fun f(a: Int) { ... }`
(function_declaration
  (function_value_parameters) @scope
  (function_body
    (statements
      (_)* @scope.inside)) @scope)

; `if (a) { ... }`, `for (a in xs) { ... }`
(control_structure_body
  (statements
    (_)* @scope.inside)) @scope

; `{ a -> ... }`
(lambda_literal
  (statements
    (_)* @scope.inside)) @scope

; `class A { ... }`
(class_body
  (_)* @scope.inside) @scope

; `package a`
(source_file
  (_)* @scope.inside) @scope
