{
  config,
  pkgs,
  nixpkgs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.registry.nixpkgs.flake = nixpkgs;

  nix.settings.substituters = [
    "https://nix-community.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/London";
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
  console.keyMap = "uk";

  environment.systemPackages = with pkgs; [
    neovim
    neovim-remote
    git
    rsync
    ripgrep
    fd
    bat
    btop
    brightnessctl
    ffmpeg
  ];

  users.users.hugom = {
    description = "Hugo McNally";
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "nextcloud"
      "syncthing"
    ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC+YMaWXPE7CV3lOkBHX9XgUlh7j6+g3rY38GbaR85tbzIqqEY9Q0Os7oM9oXEhYR8qp0inaEIn6Qygnvx1/uvtec1EWauJyB68cVHmUViB6z5NIVupAY/qhTGm2pItLX6Lqq/FTBmHmJkIk/k3qvVHwN+yzU/JW43M0+vBDcD+G085JDi4l87lshijPCXtf12gnE7JmLBKd4k13Se2f1ezKGJivdxUZJRhGuRSRA9bUlaeWLJkizMWTYB33XcziBER1ncNg7ngL5IG6cDomb6MZs6ryt7yfJbeGaOVzarRGc3v0dpmPxlB9RcHZo9oKPjz+4WpifpKIHX8cM82ZXKWi8JBh27Gx5fBFyz3qAYXXBfHpTfME9zsDwtlfxdwTakzTHkoChKv2qUGevdQ0woFCN3SGSMxXDTel5ufYgISAkuW9ZSUJbLUtI/KoQVk5T0OrZCMMftZb/V+v8mwoI1cRz3DiY5EvSI5f3yFS9nzu+jXUzJ/0mjwb5GpFa3pdqtG8TSMp1ZpeNkhNGuNRVFd/DfS0GYL7Z3TWbjcdvZLLNIoTjlUe5V/90ra3PAjcibsDfFqPtmwDQr5UbuvSPZ0ShrqgcWohUsw2G6K3XM+lWwLIw21lgJBe8JQ4cHnMoMC2BmgZgq/YUR4LZHZRPrX7nvfnKy/b8jkvBdDBjxH8Q== cardno:12_041_936"
    ];
  };

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      22000 # sync
    ];
    allowedUDPPorts = [
      80
      443
      22000 # sync
      21027 # sync discovery
    ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "hugo.mcnally+acme@gmail.com";
  };

  services = {
    openssh = {
      enable = true;
      ports = [9543];
      settings = {
        X11Forwarding = false;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    fail2ban = {
      enable = true;
      maxretry = 10;
      bantime = "8m";
    };

    postgresql = {
      enable = true;

      ensureDatabases = ["nextcloud"];
      ensureUsers = [
        {
          name = "nextcloud";
          ensureDBOwnership = true;
        }
      ];
    };
    nginx = {
      enable = true;
      virtualHosts = with config.services; {
        "git.hugom.uk" = {
          addSSL = true;
          enableACME = true;
          root = "/git/pub/";
          locations."/".extraConfig = "autoindex on;";
        };
        ${nextcloud.hostName} = {
          forceSSL = true;
          enableACME = true;
        };
        "sync.hugom.uk" = {
          forceSSL = true;
          enableACME = true;
          basicAuthFile = "/var/p/basic-auth";
          locations."/".proxyPass = "http://127.0.0.1:8384";
        };
      };
    };

    nextcloud = {
      enable = true;
      package = pkgs.nextcloud28;
      hostName = "cloud.hugom.uk";
      https = true;
      datadir = "/mnt/storage/cloud";

      configureRedis = true;

      config = {
        adminuser = "hugom";
        adminpassFile = "/var/p/nc-admin";

        dbtype = "pgsql";
        dbhost = "/run/postgresql"; # nextcloud will add /.s.PGSQL.5432 by itself
        dbpassFile = "/var/p/nc-db";
      };

      phpOptions.upload_max_filesize = pkgs.lib.mkForce "16G";
      phpOptions.post_max_size = pkgs.lib.mkForce "16G";
      phpOptions.memory_limit = pkgs.lib.mkForce "6G";
      phpOptions."opcache.interned_strings_buffer" = "23";

      extraApps = with config.services.nextcloud.package.packages.apps; {
        inherit contacts calendar mail tasks spreed notes cospend maps forms;
        collectives = pkgs.fetchNextcloudApp {
          url = "https://github.com/nextcloud/collectives/releases/download/v2.9.2/collectives-2.9.2.tar.gz";
          sha256 = "sha256-DtceLtfi79HJ2whOdjaYONZJ91ldTW/2f+allNWZLKA=";
          license = "agpl3Plus";
        };
        tables = pkgs.fetchNextcloudApp {
          url = "https://github.com/nextcloud/tables/releases/download/v0.6.5/tables.tar.gz";
          sha256 = "sha256-Srtvp+Ty7OE7cNdX60cBNxOiT69+VJDsC66TlH9OX1Y=";
          license = "agpl3Plus";
        };
      };
      extraAppsEnable = true;

      extraOptions = {
        default_phone_region = "GB";
        enabledPreviewProviders = [
          "OC\\Preview\\Image"
          "OC\\Preview\\Movie"
          "OC\\Preview\\BMP"
          "OC\\Preview\\GIF"
          "OC\\Preview\\JPEG"
          "OC\\Preview\\Krita"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\MP3"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PNG"
          "OC\\Preview\\TXT"
          "OC\\Preview\\XBitmap"
          "OC\\Preview\\HEIC"
          "OC\\Preview\\MKV"
          "OC\\Preview\\MP4"
          "OC\\Preview\\AVI"
        ];
      };
    };

    syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
    };
  };

  systemd.services."nextcloud-setup" = {
    requires = ["postgresql.service"];
    after = ["postgresql.service"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
