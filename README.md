# Dotfiles

Mostly using this as a nix flake with clan / home-manager these days.
Everything else is probably outdated.

## pense-bete

nix run .#home-manager -- switch --flake .

## zfs encrypt install

```
set machine fix
set remote 192.168.8.231
ssh-keygen -f ~/.ssh/known_hosts -R $remote
ssh-keyscan $remote >> ~/.ssh/known_hosts
ssh root@localhost "ssh-keygen -f ~/.ssh/known_hosts -R $remote"
ssh root@localhost "ssh-keyscan $remote >> ~/.ssh/known_hosts"
ssh-copy-id root@$remote
ssh root@$remote
vim /tmp/secret.key
exit
clan machines install $machine --target-host root@$remote --phases kexec,disko,install
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
