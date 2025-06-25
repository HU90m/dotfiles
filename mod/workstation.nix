{
  self,
  pkgs,
  nixpkgs,
  ...
}: {
  nix.settings = {
    trusted-users = ["root" "@wheel"];
    experimental-features = ["nix-command" "flakes"];
    accept-flake-config = true;
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.registry.self.flake = self;
  nix.registry.nixpkgs.flake = nixpkgs;
  nix.registry.unstable.to = {
    owner = "NixOS";
    repo = "nixpkgs";
    ref = "nixpkgs-unstable";
    type = "github";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.system76-scheduler.enable = true;
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-edit
    cosmic-player
    cosmic-randr
  ];

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "layer(control)";
        "leftshift+rightshift" = "capslock";
      };
    };
  };

  services.flatpak.enable = true;
  services.blueman.enable = true;

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  virtualisation.docker.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Add the plugdev group
  users.groups.plugdev = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hugom = {
    isNormalUser = true;
    description = "Hugo McNally";
    extraGroups = ["networkmanager" "wheel" "plugdev" "keyd" "dialout"];
    packages = with pkgs; [
      firefox
      tor-browser
      alacritty
      foot
      pass
      wl-clipboard
    ];
  };

  services.syncthing = {
    enable = true;
    user = "hugom";
    dataDir = "/home/hugom/sync";
    configDir = "/home/hugom/.config/syncthing";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.graphics.enable32Bit = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    neovim
    neovim-remote
    nushell
    clang
    clang-tools
    python3
    git
    ripgrep
    file
    fd
    btop
    nix-output-monitor
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    atkinson-hyperlegible
    atkinson-monolegible
  ];

  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
