{ inputs, self, ... }:
let
  nixpkgsArgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "ventoy-1.1.10" ];
    };
    overlays = [
      self.overlays.default
      inputs.nur.overlays.default
      inputs.nix-cachyos-kernel.overlays.pinned
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
