(require (prefix-in helix.misc. "helix/misc.scm"))
(require (prefix-in helix.static. "helix/static.scm"))

(#%require-dylib "libhelix_chinos"
  (only-in
    HelixChinos-new
    HelixChinos-format
    HelixChinos-lorem))

(define *helix-chinos* (HelixChinos-new))

(provide fmw)
;;@doc
;; Format the primary selection.
(define (fmw)
  (define selection (helix.static.current-highlighted-text!))
  (helix.misc.await-callback (HelixChinos-format *helix-chinos* selection)
    (lambda (replacement)
      (helix.static.replace-selection-with replacement))))

(provide lorem)
;;@doc
;; Insert lorem ipsum.
(define (lorem . args)
  (define count (if (null? args) 5 (car args)))
  (helix.misc.await-callback (HelixChinos-lorem *helix-chinos* count)
    (lambda (lorem)
      (helix.static.insert_string lorem))))
