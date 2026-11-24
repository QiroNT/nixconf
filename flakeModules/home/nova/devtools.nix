{ lib, ... }:
{
  flake.modules.homeManager.nova-devtools =
    { class, pkgs, ... }:
    {
      imports = [
        {
          home.packages = with pkgs; [
            # nix stuff
            nixd # nix language server
            nixfmt
            deadnix
            statix

            # databases
            sqlite

            # c
            autoconf
            automake
            cmake

            # js
            nodejs_26
            bun
            dprint

            # py
            uv

            # go
            go

            # rust
            rustup
            sccache

            # lua
            luajit

            # docker / k8s
            dive

            antigravity-cli
            neovim
            vim
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          home.packages = with pkgs; [
            # c
            gcc
          ];
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}
