# QMK Corne Keyboard Keymap

## QMK Set up

Install `qmk` (an arch community package).
This is installs all the compilers and programmers needed as well making life
very easy.

```sh
qmk setup # clone repo
pushd ~/qmk_firmware/keyboards/crkbd/keymaps # move to repo
ln -s ~1/keymaps/hu90m . # add my config to the repo
```


## Compile and flash the firmware

```sh
qmk compile -kb crkbd -km hu90m
```

To flash, disconnect the two halves of the keyboard.
Then, for each half, plug it in and run the following command
pressing the reset button on the keyboard when asked.

```sh
qmk flash -kb crkbd -km hu90m
```
