{ pkgs, ... }:
{
  imports = [
    ../../nixos/disko/zfs.nix
    ../../nixos/display.nix
    ../../nixos/home-assistant.nix
    ../../nixos/monitor.nix
    ../../nixos/monitored.nix
    ../../nixos/mopidy.nix
    ../../nixos/nginx.nix
    ../../nixos/nvidia.nix
    ../../nixos/remote-decrypt.nix
    ../../nixos/shared.nix
    ../../nixos/nixos.nix
    ../../nixos/zenoh.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kernelModules = [ "hid_nintendo" ];

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-eui.0025385b4140cf80";
    name = "main-ab41b1b291c142a29d99aaf8f398f575";
  };

  # environment.systemPackages = [ pkgs.factorio-space-age ];

  hardware.uinput.enable = true;
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

  programs = {
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "-W"
          "3840"
          "-H"
          "2160"
        ];
      };
    };
  };

  services.udev.extraRules = ''
    ENV{LIBINPUT_ATTR_KEYBOARD_DEBOUNCE_DELAY}="50"
  '';
  services.udev.packages = [ pkgs.steam ];
  services.joycond.enable = true;

  stylix.image = ../../bg/ashitaka-3.jpg;

  # system.extraDependencies = [ pkgs.factorio-space-age.src ];

  users.users.nim.extraGroups = [
    "docker"
    "uinput"
  ];

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # clan dev tests
  nix.settings.auto-allocate-uids = true;
  nix.settings.experimental-features = [
    "auto-allocate-uids"
    "cgroups"
  ];
  nix.settings.system-features = [ "uid-range" ];
}
