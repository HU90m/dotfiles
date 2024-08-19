{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  networking.hostName = "HMS-Convenient";
  networking.hostId = "81b79b25";

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9e40e40a-c620-46d3-bc5c-18d9bd0d1a78";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6ACD-ACA0";
    fsType = "vfat";
  };

  fileSystems."/mnt/storage" = {
    device = "ConvenientReservoir/STORAGE";
    fsType = "zfs";
  };

  fileSystems."/mnt/media" = {
    device = "ConvenientReservoir/MEDIA";
    fsType = "zfs";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services = {
    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
    };
    zfs = {
      autoScrub.enable = true;
      autoSnapshot.enable = true;
    };
  };
}
