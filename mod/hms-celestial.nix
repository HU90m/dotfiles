{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  networking.hostName = "HMS-Celestial";
  networking.hostId = "81b79b18";

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm_intel" "intel_pstate"];

  fileSystems."/" = {
    device = "CelestialPond/ROOT";
    fsType = "zfs";
    options = [ "zfsutil" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-label/CelestialSwap";}
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

  services.fwupd = {
    enable = true;
    extraRemotes = [ "lvfs-testing" ];
  };
  boot.kernelParams = [ "iomem=relaxed" ];

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
}
