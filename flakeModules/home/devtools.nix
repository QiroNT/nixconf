{ lib, ... }:
{
  flake.modules.homeManager.devtools =
    { class, pkgs, ... }:
    {
      imports = [
        {
          home.packages = with pkgs; [
            # nix stuff
            nixd # nix language server
            nixfmt-rfc-style
            deadnix
            statix

            # databases
            sqlite

            # cloud
            turso-cli
            awscli2

            # c
            autoconf
            automake
            cmake

            # js
            nodejs_22
            corepack_latest
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
            kubectl
            kubernetes-helm
            argocd # just to help with configs at work
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
