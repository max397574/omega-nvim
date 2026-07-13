;; extends
(term
  term: (text) @markup.strong)

(code
  ("#" @markup.bold (#set! conceal ""))
  (call
    item: ((ident) @f_name (#match? @f_name "paragraph"))
    (content)))

(code
  (call
    item: ((ident) @f_name (#match? @f_name "paragraph"))
    (content
      ("[" @conceal (#set! conceal ""))
      (text)
      ("]" @conceal (#set! conceal ""))
      )))

(call
  item: ((ident) @markup.strong (#match? @markup.strong "paragraph") (#set! conceal " "))
  (content))


(call
  item: ((ident) @conceal (#match? @conceal "paragraph"))
  (content
    (text) @markup.strong))

(code
  ("#" @markup.bold (#set! conceal ""))
  (call
    item: (ident) @call1 (#match? @call1 "figure")
    (group
      (call
        item: (ident) @call2 (#match? @call2 "image")
        (group)))))

(code
  (call
    item: (ident) @call1 (#match? @call1 "figure")
    (group
      (call
        item: (ident) @call2 (#match? @call2 "image")
        (group
          (string) @noconceal
          (tagged))))) @conceal (#set! conceal " "))
