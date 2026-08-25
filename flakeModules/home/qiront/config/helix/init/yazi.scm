(require (prefix-in helix.keymaps. "helix/keymaps.scm"))

; replace file explorer with yazi
(helix.keymaps.add-global-keybinding
  (hash "normal" (hash "space" (hash "e" ':yazi))))
