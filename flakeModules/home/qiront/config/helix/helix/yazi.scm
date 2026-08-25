(require "steel/result")
(require (prefix-in helix.commands. "helix/commands.scm"))
(require (prefix-in helix.configuration. "helix/configuration.scm"))
(require (prefix-in helix.editor. "helix/editor.scm"))

(provide yazi)
;;@doc
;; Open yazi picker at current buffer
(define (yazi)
  (define has-mouse (helix.configuration.get-config-option-value "mouse"))
  (define doc-path
    (or
      (~> (helix.editor.editor-focus)
        helix.editor.editor->doc-id
        helix.editor.editor-document->path)
      ""))
  (helix.configuration.set-option! "mouse" #f)
  (define selection
    (~> (command "@yaziPath@" (list doc-path))
      with-stdout-piped
      spawn-process
      unwrap-ok
      wait->stdout))
  (ok-and-then selection
    (lambda (selection)
      (define selection (trim-end selection))
      (unless (string=? selection "")
        (helix.commands.open selection))))
  (helix.configuration.set-option! "mouse" has-mouse)
  (helix.commands.redraw))
