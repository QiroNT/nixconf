{
  lib,
  inputs,
  self,
  ...
}:
let
  nixpkgsArgs = {
    config = {
      allowUnfree = true;
      allowInsecurePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "ventoy"
        ];
    };
    overlays = [
      self.overlays.default
      inputs.nur.overlays.default
      inputs.nix-cachyos-kernel.overlays.pinned
      (_: prev: {
        # FIXME
        # https://github.com/NixOS/nixpkgs/issues/426717
        # https://github.com/NixOS/nixpkgs/issues/513245
        openldap = prev.openldap.overrideAttrs {
          doCheck = !prev.stdenv.hostPlatform.isi686;
        };
      })
    ];
  };
in
{
  easy-hosts.shared.specialArgs = {
    inherit nixpkgsArgs;
  };

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs ({ inherit system; } // nixpkgsArgs);
    };
}
