# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
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

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd" "amd-pstate"];
  boot.kernelParams = ["amd_pstate=passive"];
  boot.extraModulePackages = [];
  powerManagement.cpuFreqGovernor = "schedutil";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dade9845-3855-4fec-8aba-9bb8ac08197f";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-a33ef09e-00c0-46d4-9285-28ffbb48a7c8".device = "/dev/disk/by-uuid/a33ef09e-00c0-46d4-9285-28ffbb48a7c8";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2E9B-C8A6";
    fsType = "vfat";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp1s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}