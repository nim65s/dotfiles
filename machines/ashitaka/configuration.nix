{ pkgs, ... }:
{
  imports = [
    # contains your disk format and partitioning configuration.
    ../../modules/disko.nix
    # this file is shared among all machines
    ../../modules/shared.nix
    # enables GNOME desktop (optional)
    #../../modules/gnome.nix
  ];

  # This is your user login name.
  users.users.user.name = "nim";

  # Set this for clan commands use ssh i.e. `clan machines update`
  # If you change the hostname, you need to update this line to root@<new-hostname>
  # This only works however if you have avahi running on your admin machine else use IP
  clan.core.networking.targetHost = "root@192.168.8.238";

  # You can get your disk id by running the following command on the installer:
  # Replace <IP> with the IP of the installer printed on the screen or by running the `ip addr` command.
  # ssh root@<IP> lsblk --output NAME,ID-LINK,FSTYPE,SIZE,MOUNTPOINT
  disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.0025385b4140cf80";

  # IMPORTANT! Add your SSH key here
  # e.g. > cat ~/.ssh/id_ed25519.pub
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
  ];

  # Zerotier needs one controller to accept new nodes. Once accepted
  # the controller can be offline and routing still works.
  clan.core.networking.zerotier.controller.enable = true;

  # nvidia
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "fr";
    xkb.variant = "bepo";
    windowManager.i3.enable = true;
  };
  hardware.nvidia.open = true;
  nixpkgs.config.allowUnfree = true;

  # autologin
  #services.xserver.displayManager.gdm.settings.daemon = {
    #AutomaticLoginEnable=true;
    #AutomaticLogin="nim";
  #};

  # misc
  environment.systemPackages = with pkgs; [
    alacritty
    kitty
    zellij
    tmux
    file
    pciutils
    iproute2
    coreutils
    jq
    nettools
    htop
    btop
  ];

  # systemd-boot
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 30;
  };

  # ease reinstall
  system.nixos.variant_id = "installer";

  #services.xserver.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  services.displayManager.defaultSession = "niri";
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    #autoLogin.relogin = true;
    #settings = {
      #Autologin = {
        #Session = "niri.desktop";
        #User = "nim";
      #};
    #};
  };

  programs = {
    niri.enable = true;
    vim.enable = true;
    waybar.enable = true;
    xwayland.enable = true;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "nim";
  };

  networking = {
    interfaces.enp3s0 = {
      ipv4.addresses = [{
        address = "192.168.8.238";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.8.1";
      interface = "enp3s0";
    };
  };

  console.keyMap = "fr-bepo";
}
