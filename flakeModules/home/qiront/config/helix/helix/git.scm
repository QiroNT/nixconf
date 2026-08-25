(require "steel/result")
(require (prefix-in helix.commands. "helix/commands.scm"))
(require (prefix-in helix.configuration. "helix/configuration.scm"))
(require (prefix-in helix.editor. "helix/editor.scm"))

(define (*open* path)
  (define has-mouse (helix.configuration.get-config-option-value "mouse"))
  (define doc-path
    (or
      (~> (helix.editor.editor-focus)
        helix.editor.editor->doc-id
        helix.editor.editor-document->path)
      ""))
  (helix.commands.write-all)
  (helix.configuration.set-option! "mouse" #f)
  (~> (command path (list doc-path))
    spawn-process
    unwrap-ok
    wait)
  (helix.commands.reload-all)
  (helix.configuration.set-option! "mouse" has-mouse)
  (helix.commands.redraw))

(provide gitu)
;;@doc
;; Open gitu at current buffer
(define (gitu)
  (*open* "@gituPath@"))

(provide lazygit)
;;@doc
;; Open lazygit at current buffer
(define (lazygit)
  (*open* "@lazygitPath@"))
