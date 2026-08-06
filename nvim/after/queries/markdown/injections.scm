; extends

; Use php_only parser for PHP code blocks so <?php tag isn't required
(fenced_code_block
  (info_string
    (language) @_lang)
  (code_fence_content) @injection.content
  (#eq? @_lang "php")
  (#set! injection.language "php_only"))
