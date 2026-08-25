(require (prefix-in helix.configuration. "helix/configuration.scm"))
(require (prefix-in helix.editor. "helix/editor.scm"))
(require (prefix-in helix.misc. "helix/misc.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(#%require-dylib "libhelix_chinos"
  (only-in
    HelixChinos-new
    HelixChinos-format
    HelixChinos-lorem))

(define *helix-chinos* (HelixChinos-new))

; see https://github.com/helix-editor/helix/blob/079a789e8cb08ead67f19e1971a1b7438b37354b/helix-view/src/document.rs#L2023
; we can't get the actually document config, unfortunately.
(define (*current-tab-width*)
  (or
    (let* ([doc (helix.editor.editor->doc-id (helix.editor.editor-focus))]
           [lang (helix.editor.editor-document->language doc)]
           [cfg (and lang
                 (helix.configuration.get-language-config lang))]
           [indent (and (hash? cfg)
                    (hash-contains? cfg "indent")
                    (hash-get cfg "indent"))])
      (and (hash? indent)
        (hash-contains? indent "tab-width")
        (hash-get indent "tab-width")))
    4))

(provide fmw)
;;@doc
;; Format the primary selection
(define (fmw)
  (define selection (helix.static.current-highlighted-text!))
  (define tab-width (*current-tab-width*))
  (helix.misc.await-callback (HelixChinos-format *helix-chinos* selection tab-width)
    (lambda (replacement)
      (helix.static.replace-selection-with replacement))))

(provide lorem)
;;@doc
;; Insert lorem ipsum
(define (lorem . args)
  (define count (if (null? args) 5 (string->number (car args))))
  (helix.misc.await-callback (HelixChinos-lorem *helix-chinos* count)
    (lambda (lorem)
      (helix.static.insert_string lorem))))
