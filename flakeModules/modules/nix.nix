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
      imports = with self.lib.withAny class; [
        sops
      ];

      nix = lib.mkMerge [
        {
          package = pkgs.nix;

          settings = {
            # enable flakes support
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];

            trusted-users = [ "root" ];

            substituters = [
              "https://cache.garnix.io"
              "https://nix-community.cachix.org"
              "https://numtide.cachix.org"
              "https://niri.cachix.org"
              "https://attic.xuyh0120.win/lantian" # nix-cachyos-kernel
            ];
            trusted-public-keys = [
              "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
              "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
              "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
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

      sops.secrets."common/nix/netrc" = {
        sopsFile = "${self}/secrets/common.yaml";
      };
    }
  );
}
