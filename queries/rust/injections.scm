(call_expression
  function: (field_expression
    value: (identifier)@_value
        (#any-of? @_value "conn" "tx")
    field: (field_identifier)@_field
        (#any-of? @_field "execute" "prepare" "query_row")
  )
  arguments: (arguments
    (string_literal
      (string_content)@injection.content
        (#set! injection.language "sql"))))
