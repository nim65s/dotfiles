{
  imports = [
    ../../nixos/disko/ext4-swap.nix
    ../../nixos/display.nix
    ../../nixos/shared.nix
    ../../nixos/nixos.nix
  ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-LDLC_F8+M.2_120_09292220C0589";
    name = "51314835-6a8a-47bd-8d4b-d63415838e3f";
  };
  home-manager.users = {
    nim = import ../../home/nim/main.nix;
  };
  # stylix.image = ../../bg/hattori.jpg;
}
