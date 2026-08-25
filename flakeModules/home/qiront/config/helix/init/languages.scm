(require (prefix-in helix.configuration. "helix/configuration.scm"))

(define (*add-language-server* language server)
  (define config (helix.configuration.get-language-config language))
  (define servers (hash-ref config 'language-servers))
  (helix.configuration.define-language language
    (language-servers (cons server servers))))

(helix.configuration.define-lsp "steel-language-server"
  (command "steel-language-server")
  (args '()))
(helix.configuration.define-language "scheme"
  (language-servers '("steel-language-server"))
  (auto-format #t)
  (formatter (command "schemat")))

(helix.configuration.define-language "nix"
  (auto-format #t)
  (formatter (command "nixfmt")))

(helix.configuration.define-lsp "rust-analyzer"
  (config (check (hash 'command "clippy"))))

(helix.configuration.define-lsp "tinymist"
  (config (formatterMode "typstyle")
    (formatterProseWrap #t)))
(helix.configuration.define-language "typst"
  (auto-format #t))

(helix.configuration.define-lsp "codebook"
  (command "codebook-lsp")
  (args '("serve")))
(for-each (lambda (language) (*add-language-server* language "codebook"))
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

(helix.configuration.define-lsp "harper-ls"
  (command "harper-ls")
  (args '("--stdio")))
(for-each (lambda (language) (*add-language-server* language "harper-ls"))
  '("git-commit"
    "markdown"
    "typst"))
