(require (prefix-in helix.configuration. "helix/configuration.scm"))

(define (*add-language-server* language server)
  (define config (helix.configuration.get-language-config language))
  (define servers (and (hash? config) (hash-try-get config 'language-servers)))
  (helix.configuration.define-language language
    (language-servers (cons server (if (list? servers) servers '())))))

(define (*add-code-action-on-save* language code-action)
  (define config (helix.configuration.get-language-config language))
  (define actions (and (hash? config) (hash-try-get config 'code-actions-on-save)))
  (helix.configuration.define-language language
    (code-actions-on-save (cons code-action (if (list? actions) actions '())))))

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
  (config
    (check (hash 'command "clippy"))))

(helix.configuration.define-lsp "tinymist"
  (config
    (formatterMode "typstyle")
    (formatterProseWrap #t)))
(helix.configuration.define-language "typst"
  (auto-format #t))

(helix.configuration.define-lsp "vscode-eslint-language-server"
  (config
    (rulesCustomizations
      (map (lambda (rule) (hash 'rule rule 'severity "off" 'fixable #t))
        '("style/*"
          "format/*"
          "*-indent"
          "*-spacing"
          "*-spaces"
          "*-order"
          "*-dangle"
          "*-newline"
          "*quotes"
          "*semi")))))
(for-each (lambda (language)
           (*add-language-server* language "vscode-eslint-language-server")
           (*add-code-action-on-save* language "source.fixAll.eslint"))
  '("javascript"
    "jsx"
    "typescript"
    "tsx"
    "vue"
    "html"
    "markdown"
    "json"
    "jsonc"
    "yaml"
    "toml"
    "xml"
    "graphql"
    "astro"
    "svelte"
    "css"
    "scss"
    "less"))

(helix.configuration.define-lsp "rumdl"
  (config
    (global (hash
             'line-length
             75
             'disable
             '("MD033")))))

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
