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

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    lowrisc-it,
  }: let
    no_system_outputs = {
      nixosConfigurations = let
        system = "x86_64-linux";
        specialArgs = {
          inherit nixpkgs lowrisc-it;
        };
      in {
        HMS-Stealth = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./mod/hms-stealth.nix
            ./mod/workstation.nix
            ./mod/lowrisc.nix
          ];
        };
        HMS-Think = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./mod/hms-think.nix
            ./mod/workstation.nix
            ./mod/lowrisc.nix
          ];
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
