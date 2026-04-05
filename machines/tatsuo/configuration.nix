{
  imports = [
    ../../nixos/disko/ext4-swap-tmpfs.nix
    ../../nixos/display.nix
    ../../nixos/shared.nix
    ../../nixos/nixos.nix
    ../../nixos/systemd-boot.nix
  ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/ata-Samsung_SSD_870_EVO_2TB_S754NX0Y712985D";
    name = "main-5960c9943c8b84243d19fb3f2d5158fc";
  };
  home-manager.users = {
    nim = import ../../home/nim/main.nix;
  };
  # stylix.image = ../../bg/hattori.jpg;
}
