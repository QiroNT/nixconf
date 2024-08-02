{
  lib,
  pkgs,
  namespace,
  config,
  ...
}:
let
  cfg = config.${namespace}.suites.common;
in
{
  config = lib.mkIf cfg.enable {
    nix = {
      package = pkgs.nix;

      settings = {
        # enable flakes support
        experimental-features = "nix-command flakes";

        substituters = [
          "https://numtide.cachix.org"
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };

    # create /etc/zshrc that loads the environment
    programs.zsh.enable = true;
  };
}
