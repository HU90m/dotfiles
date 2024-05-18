{
  pkgs,
  lib,
  bash,
  coreutils,
  fontconfig,
  freetype,
  glib,
  gtk2,
  libxcrypt-legacy,
  ncurses5,
  stdenv,
  xorg,
  zlib,
}: let
  vivado-version = "2023.2";
  env = binName:
    pkgs.buildFHSEnv {
      pname = binName;
      version = null;
      name = null;

      targetPkgs = _: let
        ncurses5-fhs = ncurses5.overrideAttrs (old: {
          configureFlags = old.configureFlags ++ ["--with-termlib"];
          postFixup = "";
        });
      in [
        ncurses5-fhs
        (ncurses5-fhs.override {unicodeSupport = false;})

        bash
        coreutils
        fontconfig
        freetype
        glib
        gtk2
        libxcrypt-legacy
        stdenv.cc.cc
        xorg.libXext
        xorg.libX11
        xorg.libXrender
        xorg.libXtst
        xorg.libXi
        xorg.libXft
        zlib
      ];

      profile = ''
        source /home/hugom/.local/bin/Xilinx/Vivado/${vivado-version}/settings64.sh
      '';
      runScript = binName;

      meta = with lib; {
        description = "Xilinx Vivado";
        homepage = "https://www.xilinx.com/products/design-tools/vivado.html";
        license = licenses.unfree;
        mainProgram = binName;
      };
    };
in
  pkgs.symlinkJoin {
    name = "vivado";
    paths = [(env "vivado") (env "updatemem")];
  }
