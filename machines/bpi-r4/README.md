# get NixOS on BPi-R4

- `nix build -L .#nixosConfigurations.bpi-r4.config.system.build.sdImage`
- burn that to USB stick, eg. `caligula burn result/sd-image/nixos-image-sd-card-26.05.19700101.dirty-aarch64-linux.img.zst`
- burn something from https://wiki.banana-pi.org/Banana_Pi_BPI-R4#Release_image to SD card, eg `caligula burn debian-12-bookworm-bpi-r4-5.4-sd-emmc.img`
- boot on that SD card (boot selector down-down)
- use debug serial, eg. `sudo minicom -D /dev/ttyUSB0 -b 115200`, root/bananapi
- mount the USB stick on the bpi booted on SD, eg. `mount /dev/sda2 /mnt`
- burn uboot to Nand, ref. https://wiki.banana-pi.org/Getting_Started_with_BPI-R4#How_to_burn_image_to_onboard_Nand, eg. `dd if=/mnt/u-boot-bpi-r4-nand.img of=/dev/mtdblock0`
- `poweroff`
- boot from USB Nand -> USB stick (boot selector up-down)
