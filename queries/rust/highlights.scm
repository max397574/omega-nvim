;; extends
(
 function_item
 (
  identifier
  )@function_definition
 )


(("->" @operator) (#set! conceal ""))
(("fn" @keyword.function) (#set! conceal ""))

(("use"    @keyword) (#set! conceal ""))
(("return" @keyword) (#set! conceal ""))
(("break" @keyword) (#set! conceal ""))
(("!" @keyword) (#set! conceal ""))

(scoped_identifier(scoped_identifier path: (scoped_identifier) @rust_path) (#set! conceal ""))
