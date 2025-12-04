{
  ...
}:

{
  imports = [
    ../zfs-latest.nix
  ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        # Set the following in flake.nix for each maschine:
        # device = <uuid>;
        content = {
          type = "gpt";
          partitions = {
            "boot" = {
              size = "1M";
              type = "EF02"; # for grub MBR
              priority = 1;
            };
            "ESP" = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" ];
              };
            };
            "root" = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "lz4";
          acltype = "posixacl";
          xattr = "sa";
          mountpoint = "none";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "file:///tmp/secret.key";
            };
          };
          "root/nixos" = {
            type = "zfs_fs";
            options.mountpoint = "/";
            mountpoint = "/";
          };
          "root/home" = {
            type = "zfs_fs";
            options.mountpoint = "/home";
            mountpoint = "/home";
          };
          "root/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
            options = {
              mountpoint = "/tmp";
              sync = "disabled";
            };
          };
        };
      };
    };
  };
}
