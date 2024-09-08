{ config, ... }:
{
  disko = {
    devices = {
      disk = {
        main = {
          type = "disk";
          #device = "/dev/disk/by-id/${idx}"; set this in machines/X/configuration.nix
          content = {
            type = "gpt";
            partitions = {
              "${config.networking.hostName}-boot" = {
                size = "1M";
                type = "EF02"; # for grub MBR
                priority = 1;
              };
              "${config.networking.hostName}-ESP" = {
                size = "2G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "nofail" ];
                };
              };
              "${config.networking.hostName}-swap" = {
                size = "32G";
                content = {
                  type = "swap";
                  discardPolicy = "both";
                  resumeDevice = true;
                };
              };
              "${config.networking.hostName}-root" = {
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
            "com.sun:auto-snapshot" = "true";
            mountpoint = "none";
          };
          datasets = {
            "root" = {
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
  };
}
