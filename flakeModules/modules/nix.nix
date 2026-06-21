{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "nix" (
    {
      class,
      pkgs,
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
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];

            trusted-users = [ "root" ];

            substituters = [
              "https://nix-community.cachix.org"
              "https://numtide.cachix.org"
              "https://niri.cachix.org"
              "https://attic.xuyh0120.win/lantian" # nix-cachyos-kernel
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
              "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
              "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
            ];
          };
        }
      ];
    }
  );
}
