{ lib, pkgs, ... }:
{
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
}
