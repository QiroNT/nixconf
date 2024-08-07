# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "uas"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c7f8349b-a217-4197-9fb0-ef61030094a6";
    fsType = "btrfs";
    options = [ "subvol=@root" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8365-1021";
    fsType = "vfat";
    options = [
      "fmask=0137"
      "dmask=0027"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/c7f8349b-a217-4197-9fb0-ef61030094a6";
    fsType = "btrfs";
    options = [ "subvol=@nix" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/c7f8349b-a217-4197-9fb0-ef61030094a6";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/f2bc2fe3-3904-4ea0-b769-ed2df61372ab"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp11s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
