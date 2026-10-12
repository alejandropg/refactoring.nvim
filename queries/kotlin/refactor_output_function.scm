(source_file
  ([
    (line_comment)
    (multiline_comment)
  ]* @output_function.comment
    .
    (function_declaration) @output_function))

(class_body
  ([
    (line_comment)
    (multiline_comment)
  ]* @output_function.comment
    .
    (function_declaration) @output_function))
