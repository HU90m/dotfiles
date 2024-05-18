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
        config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) ["vivado" "updatemem"];
      };
      lowriscPkgs = {
        std = lowrisc-nix.outputs.packages.${system};
        it = lowrisc-it.outputs.packages.${system};
      };
      vivado = pkgs.callPackage ./env/vivado.nix {};
    in {
      packages = {
        inherit vivado;
      };
      devShells = {
        llvm = pkgs.mkShell {
          name = "llvm-dev";
          packages = with pkgs; [clang cmake ninja python311];
          buildInputs = with pkgs; [stdenv.cc.cc.lib];
        };
        rust = pkgs.mkShell {
          name = "rust-dev";
          meta.description = "An environment with libraries commonly linked to by rust projects.";
          packages = with pkgs; [pkg-config openssl systemd];
        };
        surfer = pkgs.mkShell rec {
          name = "surfer-dev";
          packages = with pkgs; [pkg-config openssl];
          buildInputs = with pkgs; [wayland libxkbcommon libGL];
          LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath buildInputs}";
        };
      };
      formatter = pkgs.alejandra;
    };
  in
    (flake-utils.lib.eachDefaultSystem system_outputs)
    // no_system_outputs;
}
