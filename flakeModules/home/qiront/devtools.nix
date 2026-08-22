{ lib, ... }:
{
  flake.modules.homeManager.qiront-devtools =
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
            man-pages
            stdmanpages

            # js
            nodejs_24
            # (corepack.override { nodejs = nodejs_24; })
            pnpm
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

            # cloud
            google-cloud-sdk
          ];
        }

        (lib.optionalAttrs (class == "nixos") {
          home.packages = with pkgs; [
            # c
            gcc
            acl.man
            attr.man
            keyutils.man
            libcap.man
            libseccomp.man
            liburing.man
            numactl.man
            rdma-core.man
          ];
        })

        (lib.optionalAttrs (class == "darwin") {

        })
      ];
    };
}
