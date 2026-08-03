(require "helix/configuration.scm")

(define (add-language-server language server)
  (define config (get-language-config language))
  (define servers (hash-ref config 'language-servers))
  (define-language language
    (language-servers (cons server servers))))

(define-lsp "steel-language-server"
  (command "steel-language-server")
  (args '()))
(define-language "scheme"
  (language-servers '("steel-language-server"))
  (auto-format #t)
  (formatter (command "schemat")))

(define-language "nix"
  (auto-format #t)
  (formatter (command "nixfmt")))

(define-lsp "rust-analyzer"
  (config (check (hash 'command "clippy"))))

(define-lsp "tinymist"
  (config (formatterMode "typstyle")
    (formatterProseWrap #t)))
(define-language "typst"
  (auto-format #t))

(define-lsp "codebook"
  (command "codebook-lsp")
  (args '("serve")))
(for-each (lambda (language) (add-language-server language "codebook"))
  '("astro"
    "bash"
    "c"
    "c-sharp"
    "cpp"
    "css"
    "dart"
    "elixir"
    "erlang"
    "go"
    "haskell"
    "html"
    "java"
    "javascript"
    "lua"
    "nix"
    "ocaml"
    "ocaml-interface"
    "odin"
    "php"
    "python"
    "ruby"
    "rust"
    "svelte"
    "swift"
    "toml"
    "typescript"
    "vhdl"
    "vue"
    "yaml"
    "zig"))

(define-lsp "harper-ls"
  (command "harper-ls")
  (args '("--stdio")))
(for-each (lambda (language) (add-language-server language "harper-ls"))
  '("git-commit"
    "markdown"
    "typst"))
