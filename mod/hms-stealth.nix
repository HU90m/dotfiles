{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "HMS-Stealth";
  networking.hostId = "81ba5bff";

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = ["kvm-amd" "amd-pstate"];
  boot.kernelParams = ["amd_pstate=passive"];
  boot.extraModulePackages = [];
  powerManagement.cpuFreqGovernor = "schedutil";

  fileSystems."/" = {
    device = "StealthReservoir/ROOT";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/STEALTHBOOT";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/StealthSwap";}
  ];

  boot.zfs.extraPools = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
}
