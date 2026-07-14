# https://github.com/xddxdd/nixos-config/blob/master/nixos/hardware/nvidia/only.nix
{ inputs, self, ... }:
{
  flake.modules = self.lib.mkAnyNixos "nvidia" (
    { pkgs, config, ... }:
    {
      # nvidia driver
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        # package = config.boot.kernelPackages.nvidiaPackages.beta;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        open = true;
        modesetting.enable = true;
        powerManagement.enable = true;
        nvidiaSettings = false;
      };

      hardware.graphics = {
        enable = true;
        extraPackages = [ pkgs.nvidia-vaapi-driver ];
      };

      environment.variables = {
        LIBVA_DRIVER_NAME = "nvidia";
        VDPAU_DRIVER = "nvidia";
        NVD_BACKEND = "direct";

        # https://wiki.cachyos.org/configuration/gaming/#increase-maximum-shader-cache-size
        __GL_SHADER_DISK_CACHE_SIZE = toString (32 * 1024 * 1024 * 1024);
      };

      # https://github.com/NVIDIA/egl-wayland/issues/126
      environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-vram-usage.json".source =
        "${inputs.cachyos-pkgbuilds}/nvidia/nvidia-utils/limit-vram-usage";

      programs.nix-ld.libraries = [ config.hardware.nvidia.package ];
    }
  );
}
