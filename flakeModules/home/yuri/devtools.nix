{ lib, ... }:
{
  flake.modules.homeManager.yuri-devtools =
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
            nodejs_24
            # (corepack.override { nodejs = nodejs_24; })
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
