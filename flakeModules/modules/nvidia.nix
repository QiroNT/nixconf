# https://github.com/xddxdd/nixos-config/blob/master/nixos/hardware/nvidia/only.nix
{ self, lib, ... }:
{
  flake.modules = self.lib.mkAny "nvidia" (
    { class, pkgs, ... }:
    lib.optionalAttrs (class == "nixos") {
      # nvidia driver
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        open = true;
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = false;
      };

      hardware.graphics.enable = true;
      hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

      environment.variables = {
        LIBVA_DRIVER_NAME = "nvidia";
        VDPAU_DRIVER = "nvidia";
        NVD_BACKEND = "direct";
      };
    }
  );
}
