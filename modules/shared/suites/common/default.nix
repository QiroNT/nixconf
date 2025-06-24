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
    chinos.sops.enable = true;

    nix = {
      package = pkgs.nix;

      settings = {
        # enable flakes support
        experimental-features = "nix-command flakes pipe-operators";

        trusted-users = [
          "root"
          "qiront"
        ];

        substituters = [
          "https://numtide.cachix.org"
          "https://cache.garnix.io"
          "https://wezterm.cachix.org"
        ];
        trusted-public-keys = [
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
        ];

        # https://garnix.io/docs/caching
        netrc-file = config.sops.secrets."common/nix/netrc".path;
        narinfo-cache-positive-ttl = 3600;
      };
    };

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
    };

    # create /etc/zshrc that loads the environment
    programs.zsh.enable = true;

    sops.secrets."common/nix/netrc" = {
      sopsFile = lib.snowfall.fs.get-file "secrets/common.yaml";
    };
  };
}
