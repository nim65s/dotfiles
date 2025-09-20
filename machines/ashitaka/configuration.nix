{ pkgs, ... }:
{
  imports = [
    ../../modules/disko-zfs.nix
    ../../modules/display.nix
    ../../modules/nvidia.nix
    ../../modules/remote-decrypt.nix
    ../../modules/shared.nix
    ../../modules/steam.nix
    ../../modules/nixos.nix
  ];

  # environment.systemPackages = [ pkgs.factorio-space-age ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-eui.0025385b4140cf80";
    name = "main-ab41b1b291c142a29d99aaf8f398f575";
  };
  home-manager.users.nim = import ./home.nix;

  networking = {
    defaultGateway = {
      address = "192.168.8.1";
      interface = "enp3s0";
    };
    interfaces = {
      enp3s0 = {
        ipv4.addresses = [
          {
            address = "192.168.8.238";
            prefixLength = 24;
          }
        ];
      };
      "tinc.mars".ipv4.addresses = [
        {
          address = "10.0.55.205";
          prefixLength = 24;
        }
      ];
    };
  };

  services.udev.extraRules = ''
    ENV{LIBINPUT_ATTR_KEYBOARD_DEBOUNCE_DELAY}="50"
  '';

  stylix.image = ../../bg/ashitaka-3.jpg;

  # system.extraDependencies = [ pkgs.factorio-space-age.src ];

  users.users.nim.extraGroups = [ "docker" ];

  virtualisation.docker.enable = true;
}
