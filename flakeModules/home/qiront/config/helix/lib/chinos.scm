(require "steel/async")
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
  (define replacement (await (HelixChinos-format *helix-chinos* selection)))
  (helix.static.replace-selection-with replacement))

(provide lorem)
;;@doc
;; Insert lorem ipsum.
(define (lorem . args)
  (define count (if (null? args) 5 (car args)))
  (define lorem (await (HelixChinos-lorem *helix-chinos* count)))
  (helix.static.insert_string lorem))
