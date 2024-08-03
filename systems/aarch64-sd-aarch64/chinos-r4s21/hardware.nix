{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.loader = {
    grub.enable = lib.mkDefault false;
    # Enables the generation of /boot/extlinux/extlinux.conf.
    generic-extlinux-compatible = {
      enable = lib.mkDefault true;
      useGenerationDeviceTree = true;
    };
  };

  # This file needs to be at the top of /boot
  hardware.deviceTree.name = lib.mkDefault "../../rk3399-nanopi-r4s.dtb";

  boot.kernelParams = [
    "cma=32M"
    "console=ttyS2,115200n8"
    "console=ttyACM0,115200n8"
    "console=tty0"
  ];
  boot.kernelPatches = [
    {
      name = "rockchip-config.patch";
      patch = null;
      extraConfig = ''
        PCIE_ROCKCHIP_EP y
        PCIE_ROCKCHIP_DW_HOST y
        ROCKCHIP_VOP2 y
      '';
    }
    {
      name = "status-leds.patch";
      patch = null;
      extraConfig = ''
        LED_TRIGGER_PHY y
        USB_LED_TRIG y
        LEDS_BRIGHTNESS_HW_CHANGED y
        LEDS_TRIGGER_MTD y
      '';
    }
  ];

  boot.initrd.availableKernelModules = [
    ## Rockchip
    ## Storage
    "sdhci_of_dwcmshc"
    "dw_mmc_rockchip"

    "analogix_dp"
    "io-domain"
    "rockchip_saradc"
    "rockchip_thermal"
    "rockchipdrm"
    "rockchip-rga"
    "pcie_rockchip_host"
    "phy-rockchip-pcie"
    "phy_rockchip_snps_pcie3"
    "phy_rockchip_naneng_combphy"
    "phy_rockchip_inno_usb2"
    "dwmac_rk"
    "dw_wdt"
    "dw_hdmi"
    "dw_hdmi_cec"
    "dw_hdmi_i2s_audio"
    "dw_mipi_dsi"
  ];

  # Most Rockchip CPUs (especially with hybrid cores) work best with "schedutil"
  powerManagement.cpuFreqGovernor = "schedutil";
}
