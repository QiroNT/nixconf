nix-instantiate --eval --strict --json config.nix | jq -S > config.yaml
