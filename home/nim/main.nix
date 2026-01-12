{
  config,
  lib,
  pkgs,
  nixvim,
  ...
}:
{
  imports = [
    nixvim.homeModules.nixvim
    ./minimal.nix
    ./accounts.nix
    ./options.nix
    ./packages.nix
    ./programs
    ./ssh.nix
  ];

  laasProxy.enable = lib.mkDefault true;

  home = {
    inherit (config.nim-home) homeDirectory username;
    file = {
      ".config/niri/config.kdl".source = pkgs.concatText "config.kdl" (
        [ ./niri.kdl ] ++ config.nim-home.niri
      );
    };
    keyboard = {
      layout = "fr";
      variant = "ergol";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  services = {
    home-manager.autoExpire.enable = true;
    ssh-agent.enable = true;
    swaync.enable = true;
    swayidle = {
      enable = true;
      events = {
        before-sleep = lib.getExe pkgs.swaylock;
      };
    };
  };

  systemd = {
    user = {
      services = {
        swaybgs = {
          Install.WantedBy = [ "graphical-session.target" ];
          Service.ExecStart = pkgs.writeShellScript "swaybgs" config.nim-home.swaybgs;
          Unit = {
            Description = "Set wallpaper(s)";
            PartOf = "graphical-session.target";
            After = "graphical-session.target";
          };
        };
      };
      #tmpfiles.rules = [
      #  "L ${config.home.homeDirectory}/.ssh/id_ed25519_sk - - - - ${sops.secrets.ssh-sk1.path}"
      #];
    };
  };
}
