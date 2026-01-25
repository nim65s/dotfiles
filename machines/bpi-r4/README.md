# get NixOS on BPi-R4

- `nix build -L .#nixosConfigurations.bpi-r4.config.system.build.sdImage`
- burn that to USB stick, eg. `caligula burn result/sd-image/nixos-image-sd-card-26.05.19700101.dirty-aarch64-linux.img.zst`
- burn something from https://wiki.banana-pi.org/Banana_Pi_BPI-R4#Release_image to SD card, eg `caligula burn debian-12-bookworm-bpi-r4-5.4-sd-emmc.img`
- boot on that SD card (boot selector down-down)
- use debug serial, eg. `minicom -D /dev/ttyUSB0 -b 115200`, root/bananapi
- mount the USB stick on the bpi booted on SD, eg. `mount /dev/sda2 /mnt`
- burn uboot to Nand, ref. https://wiki.banana-pi.org/Getting_Started_with_BPI-R4#How_to_burn_image_to_onboard_Nand, eg. `dd if=/mnt/u-boot-bpi-r4-nand.img of=/dev/mtdblock0`
- `poweroff`
- boot from USB Nand -> USB stick (boot selector up-down)

Then real config, eg. `calcifer`:

- `disko --mode destroy,format,mount -f .#calcifer`
- `nixos-install -v --root /mnt --flake .#calcifer`

*OR*

- `clan machines install calcifer --target-host root@192.168.8.136 --host-key-check tofu --build-on local --phases disko,install,reboot` (no kexec needed)

## boot on usb again after that

once everything is set up, BPi-R4 will boot on NVMe. If you want to boot on USB:

- plug debug serial, eg. `minicom -D /dev/ttyUSB0 -b 115200`
- reboot
- "Hit any key to stop autoboot"
- `usb start`
- `bootflow scan -b usb`
