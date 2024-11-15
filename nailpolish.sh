#!/usr/bin/env sh
# Utility script for changing the theme configuration of the foot terminal.

set -e

FOOT_CONFIG_FILE=~/.config/foot/foot.ini
FOOT_THEMES_DIR=$(nix build nixpkgs#foot.themes --print-out-paths)/share/foot/themes

panic () {
  echo "$1" && exit "$2"
}

random_theme () {
  select_theme "$(find "$FOOT_THEMES_DIR" | shuf | head -1)"
}

select_theme () {
  [ -f "$1" ] || panic "theme can't be found: $1" 2
  sed -i "s|^include=.*theme.*$|include=$1|" "$FOOT_CONFIG_FILE"
}

get_theme () {
  sed -n 's|^include=.*theme.*/\(.*\)$|\1|p' "$FOOT_CONFIG_FILE"
}

list_themes () {
  ls "$FOOT_THEMES_DIR"
}

while getopts "rs:gl" opt; do
    case "${opt}" in
        r) random_theme;;
        s) select_theme "$FOOT_THEMES_DIR/$OPTARG";;
        g) get_theme;;
        l) list_themes;;
        ?) exit 2;; # invalid input exit early
    esac
done
