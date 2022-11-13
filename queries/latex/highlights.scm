;; extends
((package_include command: ("\\usepackage") @include) (#set! conceal ""))
(
 (
  generic_command
  command: (command_name)@nospell
  )
 )

(line_comment)@nospell

(
 generic_command
 arg: ( curly_group
        (text
          (word)@nospell
          )
        )
 )
(
 curly_group_text
 (
  text
  (word)@nospell
  )@nospell
 )

