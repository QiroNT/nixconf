{
  lib,
  pkgs,
  namespace,
  config,
  ...
}: let
  cfg = config.${namespace}.cli.devtools;
in {
  options.${namespace}.cli.devtools = with lib.types; {
    enable = lib.mkEnableOption "cli devtools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # databases
      postgresql_16_jit # til: postgres has jit
      sqlite

      # cloud
      turso-cli
      awscli2

      # c
      autoconf
      automake
      cmake

      # wasm
      binaryen
      emscripten

      # js
      nodejs_22
      corepack_22
      bun
      dprint

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
  };
}
