{
  inputs,
  self,
  lib,
  ...
}:
{
  flake.modules = self.lib.mkAny "secure-boot" (
    { class, ... }:
    lib.optionalAttrs (class == "nixos") {
      imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

      boot = {
        # secure boot, see lzbt & arch docs for setup
        loader = {
          efi.canTouchEfiVariables = lib.mkForce false;
          systemd-boot.enable = lib.mkForce false;
        };
        lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
        };

        # to roll disk encryption keys into TPM, use the following:
        # $ systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 --wipe-slot=tpm2 /dev/sdX
        # TODO add pcr 11 after https://github.com/nix-community/lanzaboote/issues/61
        initrd.systemd.enable = true;
      };
    }
  );
}
