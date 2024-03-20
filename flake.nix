{
  description = "HU90m's Personal Packages, Shells and Machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    lowrisc-it = {
      url = "git+ssh://git@github.com/lowRISC/lowrisc-it";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    lowrisc-nix = {
      url = "github:lowRISC/lowrisc-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    lowrisc-it,
    lowrisc-nix,
  }: let
    no_system_outputs = {
      nixosConfigurations = let
        system = "x86_64-linux";
        specialArgs = {
          inherit nixpkgs lowrisc-it lowrisc-nix;
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
        HMS-Celestial = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./mod/hms-celestial.nix
            ./mod/workstation.nix
            ./mod/lowrisc.nix
          ];
        };
        HMS-Convenient = nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules = [
            ./mod/hms-convenient.nix
            ./mod/server.nix
          ];
        };
      };
    };
    system_outputs = system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      lowriscPkgs = {
        std = lowrisc-nix.outputs.packages.${system};
        it = lowrisc-it.outputs.packages.${system};
      };
    in {
      devShells = {
        llvm = pkgs.mkShell {
          name = "llvm-dev";
          packages = with pkgs; [cmake ninja];
          buildInputs = with pkgs; [stdenv.cc.cc.lib];
        };
        lychee = pkgs.mkShell {
          name = "lychee-dev";
          packages = with pkgs; [pkg-config openssl];
        };
        sunburst = pkgs.mkShell {
          name = "sunburst-dev";
          packages =
            (with pkgs; [libelf zlib openfpgaloader python311Packages.pip])
            ++ (with lowriscPkgs.std; [python_ot verilator_ot])
            ++ (with lowriscPkgs.it; [vivado]);
        };
      };
      formatter = pkgs.alejandra;
    };
  in
    (flake-utils.lib.eachDefaultSystem system_outputs)
    // no_system_outputs;
}
