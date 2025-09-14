# Dotfiles

Mostly using this as a nix flake with clan / home-manager these days.
Everything else is probably outdated.

## pense-bete

```
nix run .#home-manager -- switch --flake .
# or
nix run github:nim65s/dotfiles#home-manager -- switch --flake github:nim65s/dotfiles
```

## zfs encrypt install

```
set machine fix
set remote $machine.m
ssh-keygen -f ~/.ssh/known_hosts -R $remote
ssh-keyscan $remote >> ~/.ssh/known_hosts
ssh root@localhost "ssh-keygen -f ~/.ssh/known_hosts -R $remote"
ssh root@localhost "ssh-keyscan $remote >> ~/.ssh/known_hosts"
ssh-copy-id root@$remote
ssh root@$remote
vim /tmp/secret.key
exit
clan machines install $machine --target-host root@$remote --phases disko,install
ssh root@$remote
umount /mnt/boot
zfs set keylocation=prompt zroot/root
cd /
zfs set -u mountpoint=/ zroot/root/nixos
zfs set -u mountpoint=/tmp zroot/root/tmp
zfs set -u mountpoint=/home zroot/root/home
zpool export zroot
reboot
```

## RPi

```
nix build .#nixosConfigurations.healoriaspi.config.system.build.sdImage
caligula burn result/sd-image/nixos-image-sd-card-25.11.20250908.b599843-aarch64-linux.img.zst

or

clan machines update --target root@192.168.8.126 --build ashitaka healoriaspi
```
