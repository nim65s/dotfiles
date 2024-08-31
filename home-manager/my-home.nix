{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs = config.my-programs;

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  services = {
    dunst = {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          geometry = "0x5-10+10";
          indicate_hidden = true;
          padding = 10;
          horizontal_padding = 10;
          sort = true;
          format = ''
            <b>%s</b>
            %b'';
          font = "Source Sans";
          browser = "${lib.getExe pkgs.firefox-devedition} -new-tab";
        };
      };
    };

    signaturepdf = {
      enable = true;
      port = 5165;
      extraConfig = {
        max_file_uploads = "201";
        post_max_size = "24M";
        upload_max_filesize = "24M";
      };
    };
    ssh-agent.enable = true;

    spotifyd = {
      enable = true;
      settings = {
        global = {
          username = "nim65s";
          password_cmd = "rbw get spotify";
          device_name = "home-manager";
          device_type = "computer";
          backend = "pulseaudio";
        };
      };
    };
  };
  systemd.user.services.spotifyd.Service.Environment = [ "PATH=${pkgs.rbw}/bin" ];

  xdg = {
    enable = true;
    portal = {
      config.sway.default = [
        "wlr"
        "gtk"
      ];
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      xdgOpenUsePortal = true;
    };
    systemDirs.data = [ "/home/${config.my-username}/.nix-profile/share" ];
  };

  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3 = {
      config = config.my-i3;
      enable = true;
    };
  };

  wayland.windowManager.sway = {
    config = config.my-sway;
    enable = true;
    extraConfig = ''
      hide_edge_borders --smart-titles smart
    '';
  };
}
