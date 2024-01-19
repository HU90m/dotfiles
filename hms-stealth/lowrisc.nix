{ lowrisc-it, ... }:
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
}
