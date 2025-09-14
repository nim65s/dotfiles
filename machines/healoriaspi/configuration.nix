{
  config,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  hardware = {
    enableAllHardware = true;
    # raspberry-pi."4" = {
    # audio.enable = true;
    # gpio.enable = true;
    # i2c0.enable = true;
    # i2c1.enable = true;
    # poe-hat.enable = true;
    # poe-plus-hat.enable = true;
    # pwm0.enable = true;
    # };
  };

  nixpkgs = {
    hostPlatform = "aarch64-linux";
    buildPlatform = "x86_64-linux";
  };

  ## formated SD card as:
  # [nixos@nixos:~]$ sudo parted /dev/mmcblk1 -- p
  # Model: SD NCard (sd/mmc)
  # Disk /dev/mmcblk1: 31.3GB
  # Sector size (logical/physical): 512B/512B
  # Partition Table: msdos
  # Disk Flags:
  #
  # Number  Start   End     Size    Type     File system  Flags
  #  1      8389kB  1000MB  992MB   primary
  #  2      1000MB  2000MB  999MB   primary
  #  3      2000MB  31.3GB  29.3GB  primary               boot
  #
  #  [nixos@nixos:~]$ sudo mkfs.vfat -i 0x2178694e -n FIRMWARE /dev/mmcblk1p1
  #  mkfs.fat 4.2 (2021-01-31)
  #
  #  [nixos@nixos:~]$ sudo mkswap -L SWAP /dev/mmcblk1p2
  #  mkswap: /dev/mmcblk1p2: warning: wiping old swap signature.
  #  Setting up swapspace version 1, size = 953 MiB (999288832 bytes)
  #  LABEL=SWAP, UUID=a2bc4764-d0a1-4c23-b136-754623c2f78c
  #
  #  [nixos@nixos:~]$ sudo mkfs.ext4 -L NIXOS /dev/mmcblk1p3
  #  mke2fs 1.47.3 (8-Jul-2025)
  #  Discarding device blocks: done
  #  Creating filesystem with 7145216 4k blocks and 1787040 inodes
  #  Filesystem UUID: 9a2d1518-2b58-4ecb-be4d-be1b19f73d1c
  #  Superblock backups stored on blocks:
  #          32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
  #          4096000
  #
  #  Allocating group tables: done
  #  Writing inode tables: done
  #  Creating journal (32768 blocks): done
  #  Writing superblocks and filesystem accounting information: done

  # swapDevices = [
  #   { device = "/dev/disk/by-label/SWAP"; }
  # ];

  environment.systemPackages = [
    pkgs.btop
  ];

  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlKH10l4IazTlC2UC0HV44iw/p7w7ufxaOk7VLX9vTG nim@ashitaka"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPWyZK9yJEyY7DqxN+A2h4+LccOoZGt2OdWEYvwzXzT nim@yupa"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOwQHhg10BZUogtkz+MlOsnmQER2Kkf9YjL3taOcNtbJAAAABHNzaDo= nim@sk1"
    ];
    nim = {
      inherit (config.users.users.root) openssh;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
    };
  };
  security.sudo.wheelNeedsPassword = false;

  programs = {
    fish.enable = true;
    git.enable = true;
    tmux.enable = true;
    vim.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  networking.hostName = "healoriaspi";

  system.stateVersion = "25.05";
}
