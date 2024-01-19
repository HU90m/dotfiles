{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    lowrisc-it = {
      url = "git+ssh://git@github.com/lowRISC/lowrisc-it";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, lowrisc-it }: let
    no_system_outputs = {
      nixosConfigurations = {
        HMS-Stealth = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hms-stealth/configuration.nix
            ./hms-stealth/lowrisc.nix
          ];
          specialArgs = {
            inherit nixpkgs lowrisc-it;
          };
        };
      };
    };
    system_outputs = system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      formatter = pkgs.alejandra;
    };
  in
    (flake-utils.lib.eachDefaultSystem system_outputs)
    // no_system_outputs;
}
