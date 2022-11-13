; extends
(ranged_tag ("_prefix")
    name: (tag_name) @comment (#eq? @comment "comment")
    content: (ranged_tag_content)? @comment)

(carryover_tag_set
  (carryover_tag
    name: (tag_name) @_name
    (#eq? @_name "comment"))
  target: (paragraph) @comment)
(inline_comment) @comment
