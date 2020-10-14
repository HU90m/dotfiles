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
if the below exists UEFI mode is enabled and you should follow the *EFI*
instructions, else follow the normal instructions.
You may have to disable secure boot in the motherboard settings to use *EFI*.
```bash
ls /sys/firmware/efi/efivars
```

### Connect to the Internet
if you want to use wifi, first try wifi-menu.
if it doesn't work continue with this section.
```bash
wifi-menu
```

to see the network devices
```bash
ip link
```

bring interface up
```bash
ip link set wlp7s0 up
```

Make a file called `/etc/wpa_supplicant/wpa_supplicant.conf` containing
```
ctrl_interface=/run/wpa_supplicant
update_config=1
```

start *wpa\_supplicant* and run
```bash
wpa_supplicant -B -i wlp7s0 -c /etc/wpa_supplicant/wpa_supplicant.conf
wpa_cli
```

then in the interactive prompt
```
> scan
> scan_results
> add_network
> set_network 0 ssid "YourSSID"
> set_network 0 psk "passphrase"
> enable_network 0
> save_config
> quit
```

then grab an ip address manually
```bash
dhcpcd wlp7s0
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


if *EFI*,

| Mount     | Partition | Type                | Size                 |
|-----------|-----------|---------------------|----------------------|
| /mnt/boot | /dev/sdX1 | EFI System          | 256-512MB            |
| [SWAP]    | /dev/sdX2 | Linux Swap          | ~RAM size            |
| /mnt      | /dev/sdX3 | Linux root (x86-64) | 30GB                 |
| /mnt/home | /dev/sdX4 | Linux home          | the rest of the disk |


else,

| Mount     | Partition | Type                | Size                 |
|-----------|-----------|---------------------|----------------------|
| /mnt/boot | /dev/sdX1 | BIOS boot           | 256-512MB            |
| [SWAP]    | /dev/sdX2 | Linux Swap          | ~RAM size            |
| /mnt      | /dev/sdX3 | Linux root (x86-64) | 30GB                 |
| /mnt/home | /dev/sdX4 | Linux home          | the rest of the disk |


### Format Partitions
```bash
mkfs.ext4 /dev/sdX3
mkfs.ext4 /dev/sdX4
```

if *EFI*,
```bash
mkfs.vfat /dev/sdX1
```

else,
```bash
mkfs.ext4 /dev/sdX1
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
pacstrap /mnt base linux linux-firmware base-devel vim networkmanager
```
If you are running a desktop, try the `linux-zen` kernel instead of `linux`.
If you want stability, try the `linux-lts` kernel instead of `linux`.
Can't decide? Install them all and decide at boot.



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

### Localisation

uncomment all beginning with en\_GB
```
/etc/locale.gen
```

```bash
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
```

```bash
locale-gen
```

### Microcode
This will put an image in the boot partition.
```bash
pacman -S amd-ucode
```

### if not *EFI*, Install Grub
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

### if *EFI*, Install Bootctl
[For more information](https://wiki.archlinux.org/index.php/Systemd-boot)

#### Install
```bash
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
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root="PARTUUID=982aebe0-23f7-4d2c-9f01-06164fe84421"  rw
```

/boot/loader/entries/arch-lts.conf
```
title Arch Linux LTS Kernel
linux /vmlinuz-linux-lts
initrd /amd-ucode.img
initrd /initramfs-linux-lts.img
options root="PARTUUID=982aebe0-23f7-4d2c-9f01-06164fe84421"  rw
```

Use the following command to find the PARTUUID of the root partition:
```bash
blkid
```

### Init RAM File System
recreate initramfs image (not usually required unless using LVM, RAID, system encryption, etc...)
```bash
mkinitcpio -P
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

### Change root password
```bash
passwd
```

### Reboot
```bash
exit
umount /mnt/boot
umount /mnt
reboot
```


## After Reboot

### Network Manager
enables Network Manager on start-up
```bash
systemctl enable NetworkManager
```

start Network Manager
```bash
systemctl start NetworkManager
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
EDITOR=vim visudo
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
pacman -S openssh
```
will be up and running on the next restart
its service is called sshd and can be controlled via systemd

get the ip address of the active interfaces
```bash
ip addr
```


to enable X11 Forwarding
```bash
pacman -S xorg-xauth xorg-xhost
```
in `/etc/ssh/sshd_config` set the following
```
AllowTcpForwarding yes
X11Forwarding yes
X11DisplayOffset 10
X11UseLocalhost yes
```

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

### Create a better mirror list
install
```
reflector
```
run
```bash
reflector --country "United Kingdom" --age 12 --sort rate --save /etc/pacman.d/mirrorlist
```


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

for east Asian and south Korean fonts
```
opendesktop-fonts ttf-baekmuk
```


install programs used in config
```
picom
feh
redshift python-gobject
network-manager-applet
dunst
scrot
flite
```
(gobject needed for redshift)

configs and files
```
~/.wallpapers
~/.config/dunst/dunstrc
~/.config/i3/config
~/.config/i3status/config
~/.config/alacritty/alacritty.yml
~/.config/flite/voices/cmu_us_awb.flitevox
~/.config/flite/voices/cmu_us_jmk.flitevox
```

install laptop specific programs
```
light
cbatticon
```
add user to video group for light program
```bash
usermod -a -G video hugo
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
make directories and enable socket
```bash
mkdir -p ~/Audio/Music/Playlists
mkdir -p ~/Audio/Music/Songs
```

### XDG default applications
query what mime type a file is
```bash
xdg-mime query filetype file.pdf
```

get a list of the applications' desktop files
```bash
ls /usr/share/applications/
```

change the default application for a mime type
```bash
xdg-mime default org.pwmt.zathura.desktop application/pdf
```

change default browser
```bash
xdg-settings set default-web-browser firefox.desktop
```

query what application is used for a mime type
```bash
xdg-mime query default application/pdf
```

open files with your new defaults
```bash
xdg-open file.pdf
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


### Password Store
install
```
pass yubikey-manager
```
enable smartcard daemon
```bash
systemctl enable pcscd.socket
```
clone password store
```bash
git clone https://github.com/HU90m/ssssssh ~/.password-store
```
to get a password (use -c flag to copy to clipboard)
```bash
pass path/password_name
```
generate a new password of 14 characters (use -n flag for no symbols)
```bash
pass generate path/password_name 14
```
generate a random password of 14 characters
```bash
pwgen -cny 14 1
```
insert a password into the store
```bash
pass insert path/password_name
```
remove a password
```bash
pass rm path/password_name
```
Change the gpg key of the password store
where $(gpg-id) is the new key.
```bash
pass init [-p path] $(gpg-id)
```


### Trackpad Settings
find your trackpad's id
```bash
xinput list
```
list properties you can change
```bash
xinput list-props <trackpad-id>
```
change property
```bash
xinput set-prop <trackpad-id> <property-id> <setting>
```
One can use the name string as oppose to the id.
(Properties with the 'Default' suffix are the read-only start-up settings.)


### Steam
requires multi-lib
```
steam lib32-nvidia-utils
ttf-liberation
```
