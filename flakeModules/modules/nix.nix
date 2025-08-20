{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "nix" (
    {
      class,
      pkgs,
      config,
      ...
    }:
    {
      imports = with (self.lib.withAny class); [
        sops
      ];

      nix = lib.mkMerge [
        {
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
        }

        (lib.optionalAttrs pkgs.stdenvNoCC.isLinux {
          optimise.automatic = true;
          gc = {
            automatic = true;
            persistent = true;
            dates = "monthly";
            randomizedDelaySec = "45min";
            options = "--delete-older-than 30d";
          };
        })

        (lib.optionalAttrs pkgs.stdenvNoCC.isDarwin {
          gc = {
            automatic = true;
            interval = {
              Day = 1;
              Hour = 2;
              Minute = 0;
            };
            options = "--delete-older-than 30d";
          };
        })
      ];
    }
  );
}
