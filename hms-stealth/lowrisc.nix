{ pkgs, lowrisc-it, ... }:
{
  imports = [
    lowrisc-it.nixosModules.lowrisc
  ];
  lowrisc = {
    identity = "hugom@lowrisc.org";
    network = true;
    toolnas = true;
  };
  nix.registry.lowrisc-it.flake = lowrisc-it;

  nix.settings.substituters = [
    "https://nix-cache.lowrisc.org/public/"
  ];
  nix.settings.trusted-public-keys = [
    "nix-cache.lowrisc.org-public-1:O6JLD0yXzaJDPiQW1meVu32JIDViuaPtGDfjlOopU7o="
  ];

  services.udev = {
    # FTDI Device Rules
    packages = [pkgs.libftdi1];
    # OpenFPGALoader Rules (excluding FTDI Device Rules)
    extraRules = ''
      ACTION!="add|change", GOTO="openfpgaloader_rules_end"

      # gpiochip subsystem
      SUBSYSTEM=="gpio", MODE="0664", GROUP="plugdev", TAG+="uaccess"

      SUBSYSTEM!="usb|tty|hidraw", GOTO="openfpgaloader_rules_end"

      # anlogic cable
      ATTRS{idVendor}=="0547", ATTRS{idProduct}=="1002", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # altera usb-blaster
      ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", MODE="664", GROUP="plugdev", TAG+="uaccess"
      ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6002", MODE="664", GROUP="plugdev", TAG+="uaccess"
      ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6003", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # altera usb-blasterII - uninitialized
      ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6810", MODE="664", GROUP="plugdev", TAG+="uaccess"
      # altera usb-blasterII - initialized
      ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6010", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # dirtyJTAG
      ATTRS{idVendor}=="1209", ATTRS{idProduct}=="c0ca", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # Jlink
      ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0105", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # NXP LPC-Link2
      ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0090", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # NXP ARM mbed
      ATTRS{idVendor}=="0d28", ATTRS{idProduct}=="0204", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # icebreaker bitsy
      ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6146", MODE="664", GROUP="plugdev", TAG+="uaccess"

      # orbtrace-mini dfu
      ATTRS{idVendor}=="1209", ATTRS{idProduct}=="3442", MODE="664", GROUP="plugdev", TAG+="uaccess"

      LABEL="openfpgaloader_rules_end"
    '';
  };
}
