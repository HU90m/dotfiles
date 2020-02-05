# Arch Install Notes

## Making bootable USB
```bash
dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync
```

## Install Commands

### Set the Keyboard Layout
```bash
loadkeys /usr/share/kbd/keymaps/i386/qwerty/uk.map.gz
```

### Verify the Boot Mode
if the below exists UEFI mode is enabled
```bash
ls /sys/firmware/efi/efivars
```

### Connect to the Internet
to see the network devices
```bash
ip link
```

bring interface up
```bash
ip link wlp7s0 up
```

if wifi, connect to wireless access point
```bash
wpa_supplicant -B -d -i wlp7s0 -c <(wpa_passphrase Winifred 126Mayfield)
```

### Update System Clock
```bash
timedatectl set-ntp true
```

### Partition Drives
list block devices
```bash
lsblk
```

partition drive
```bash
fdisk /dev/sdX
```

Possible Layout:

| Mount     | Partition | Type                | Size                 |
|-----------|-----------|---------------------|----------------------|
| /mnt/boot | /dev/sdX1 | BIOS boot           | 256-512MB            |
| [SWAP]    | /dev/sdX2 | Linux Swap          | ~RAM size            |
| /mnt      | /dev/sdX3 | Linux root (x86-64) | 30GB                 |
| /mnt/home | /dev/sdX4 | Linux home          | the rest of the disk |


### Format Partitions
```bash
mkfs.ext4 /dev/sdX1
mkfs.ext4 /dev/sdX3
mkfs.ext4 /dev/sdX4
```

### Swap
```bash
mkswap /dev/sdX2
swapon /dev/sdX2
```

### Mount
```bash
mount /dev/sdX1 /mnt/boot
mount /dev/sdX3 /mnt
mount /dev/sdX4 /mnt/home
```


### Install Base Packages
you can also install other stuff to make your life easier
```bash
pacstrap /mnt base base-devel neovim networkmanager
```


### Generate File Systems Table
```bash
genfstab -U /mnt >> /mnt/etc/fstab
```


### Change root directory
```bash
arch-chroot /mnt
```


## After Change of Root Directory

### Set time zone
```bash
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
```

generate /etc/adjtime
```bash
hwclock --systohc
```

### Install Grub
For UEFI systems don't use grub use bootctl (part of the systemd suit)
```bash
pacman -S grub
```

make sure the boot partition is of type 'BIOS boot' when using a GPT
```bash
grub-install --bootloader-id=GRUB --target=i386-pc /dev/sda
```

generate grub config
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### Bootctl
[For more information](https://wiki.archlinux.org/index.php/Systemd-boot)
#### Install
```
bootctl install
```

#### Configuration
/boot/loader/loader.conf
```
default arch-lts
```

/boot/loader/entries/arch.conf
```
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=982aebe0-23f7-4d2c-9f01-06164fe84421  rw
```

/boot/loader/entries/arch-lts.conf
```
title Arch Linux LTS Kernel
linux /vmlinuz-linux-lts
initrd /initramfs-linux-lts.img
options root=PARTUUID=982aebe0-23f7-4d2c-9f01-06164fe84421  rw
```

Use the following command to find the PARTUUID of the root partition:
```bash
blkid
```


### Localisation
```bash
vim /etc/locale.gen
```

uncomment all beginning with en\_GB
```bash
locale-gen
```

### Keyboard
echo "KEYMAP=uk" >> /etc/vconsole.conf

### Networking
create a host name
```bash
echo "HMS-Machine" >> /etc/hostname
```

add matching to hosts
```bash
echo "127.0.0.1  localhost" >> /etc/hosts
echo "::1        localhost" >> /etc/hosts
```

### Init RAM File System
recreate initramfs image (not usually required unless using LVM, RAID, system encryption, etc...)
```bash
mkinitcpio -p linux
```

### Change root password
```bash
passwd
```


## After Reboot

### Network Manager
enables Network Manager on start-up
```bash
systemctl enable NetworkManager
```

list wifi access point
```bash
nmcli device wifi list
```

connect to wifi access point
```bash
nmcli device wifi connect Winifred password 126Mayfield
```


### Set up sudo
install sudo
```bash
pacman -S sudo
```

open config using this command
```bash
visudo
```
uncomment this line: `%wheel ALL=(ALL) ALL`


### Create New User
creates new user, creates home directory and adds user to wheel group
```bash
useradd -m -G wheel hugo
```

change new user's password
```bash
passwd hugo
```

switch to new user
```bash
su hugo
```


### SSH
install ssh
```bash
sudo pacman -S openssh
```
will be up and running on the next restart
its service is called sshd and can be controlled via systemd

### Enable Multi-lib
```bash
sudo vim /etc/pacman.conf
```
uncomment the following lines
```

[multilib]
Include = /etc/pacman.d/mirrorlist
```

also might as well enable color
```
Color
```

### Graphics Card Drivers
find graphics card manufacturer
```bash
lspci | grep -e VGA -e 3D
```
install drivers
```bash
sudo pacman -S nvidia
```

## Programs

### Xorg
install
```
xorg xorg-xinit
```
config
```
~/.xinitrc
```

### i3 windows manager
install i3
```
i3 dmenu
```

install terminal emulator
```
alacritty
```

install fonts
```
noto-fonts noto-fonts-emoji
```

install programs used in config
```
compton
nitrogen
redshift python-gobject
network-manager-applet
dunst
scrot
```
(gobject needed for redshift)

configs and files
```
~/.wallpapers
~/.config/dunst/dunstrc
~/.config/i3/config
~/.config/i3status/config
~/.config/alacritty/alacritty.yml
```

install laptop specific programs
```
xfce4-power-manager
light
```

### Bluetooth
install
```
blueman
```
enable and default to off at start up
```bash
systemctl enable bluetooth
gsettings set org.blueman.plugins.powermanager auto-power-on false
```


### Terminal Programs
install
```
tmux
gvim
git
youtube-dl
```

configs
```
~/.bashrc
~/.tmux.conf
~/.vimrc
```

### YAY (Yet Another Yogurt)
The following commands will install yay.
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Audio
install
```
pulseaudio pulseaudio-alsa
pulsemixer
```

### Productivity
install
```
firefox
qutebrowser
zathura zathura-pdf-mupdf
libreoffice-still libreoffice-still-en-gb
texlive-most
pandoc
sxiv
imagemagick
```

### GTK
install
```
gtk3
arc-gtk-theme papirus-icon-theme
lxappearance
```


### Music
install
```
mpd mpc ncmpcpp
```
config
```
~/.config/mpd/mpd.conf
```
make directories
```bash
mkdir -p ~/.config/mpd/playlists
mkdir -p ~/Music/Songs
```


### Printer
#### Drivers
install printer driver collection
```
gutenprint
```
I need a specific driver in the AUR for my printer
```
epson-inkjet-printer-201211w
```
#### Avahi
install avahi to allow your computer to search the network for printers.
```
avahi
```
start avahi
```bash
systemctl start avahi-daemon.service
```
#### CUPS
install CUPS
```
cups
cups-pdf
```
enable CUPS socket
```bash
systemctl enable org.cups.cupsd.socket
```
search for printers and drivers
```bash
lpinfo -v
lpinfo -m
```
make a new queue and make it the default
```bash
lpadmin -p WF2510 -E -v "usb://EPSON/WF-2510%20Series?serial=523256593033393112&interface=1" -m "epson-inkjet-printer-201211w/EPSON_WF_2510.ppd"
lpoptions -d WF2510
```
#### Printing
print a file
```bash
lpr file.pdf
```
pipe to printer
```bash
echo "hello" | lpr
```


### Clock Synchronisation
install
```
ntp
```
to synchronise time once per boot
```bash
systemctl enable ntpdate.service
```
To update the hardware clock as well,
make `/etc/systemd/system/ntpdate.service.d/hwclock.conf`
and insert
```
[Service]
ExecStart=/usr/bin/hwclock -w
```


### Steam
requires multi-lib
```
steam lib32-nvidia-utils
ttf-liberation
```
