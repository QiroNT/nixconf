{
  lib,
  pkgs,
  namespace,
  config,
  system,
  ...
}:
let
  cfg = config.${namespace}.cli.devtools;
in
{
  options.${namespace}.cli.devtools = with lib.types; {
    enable = lib.mkEnableOption "cli devtools";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
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
    })

    (lib.mkIf (cfg.enable && lib.snowfall.system.is-linux system) {
      home.packages = with pkgs; [
        # c
        gcc
      ];
    })
  ];
}
