#!/bin/sh

# places links in the configs' locations

pushd ~
ln -vs ~1/.inputrc
ln -vs ~1/.bashrc
ln -vs ~1/.vimrc

cd ~/.config
ln -vs ~1/.config/i3
ln -vs ~1/.config/alacritty
ln -vs ~1/.config/picom
ln -vs ~1/.config/safeeyes
