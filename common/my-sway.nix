{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my-sway-output = lib.mkOption {
    type = lib.types.attrs;
    description = "my sway output";
    default = {
      "*" = {
        bg = "${./../bg/sleep.jpg} fill";
      };
    };
  };
  options.my-sway = lib.mkOption {
    type = lib.types.attrs;
    description = "my sway";
    default =
      let
        mod = "Mod4";
      in
      config.i3sway
      // {
        up = "s";
        down = "t";
        left = "c";
        right = "r";
        menu = "${lib.getExe pkgs.rofi-wayland} -show run";
        output = config.my-sway-output;
        window.commands = [
          {
            command = "layout tabbed";
            criteria.class = "^Signal$";
          }
          {
            command = "layout tabbed";
            criteria.class = "^Element$";
          }
          {
            command = "layout tabbed";
            criteria.app_id = "Element";
          }
          {
            command = "title_format \"[XWayland] %title\"";
            criteria.shell = "xwayland";
          }
        ];
        assigns = {
          "9" = [
            { class = "^Zeal$"; }
            { app_id = "org.zealdocs.zeal"; }
          ];
          "10" = [
            { class = "^Firefox$"; }
            { app_id = "firefox"; }
          ];
          "11" = [
            { class = "^thunderbird$"; }
            { app_id = "thunderbird"; }
          ];
          "12" = [
            { class = "^Signal$"; }
            { class = "^Element$"; }
            { app_id = "Element"; }
          ];
        };

        keybindings = config.i3sway.keybindings // {

          "${mod}+i" = ''exec "${lib.getExe pkgs.rofi-wayland} -show run"'';

          "${mod}+e" = ''exec "${lib.getExe pkgs.rofi-rbw} --typer wtype --clipboarder wl-copy"'';
          "${mod}+x" = ''exec "${lib.getExe pkgs.swaylock}"'';

          "${mod}+Shift+p" = ''exec "swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? ' -b 'Yes' 'swaymsg exit'"'';
        };

        bars = [ ];
        input = {
          "type:keyboard" = {
            xkb_layout = "fr";
            xkb_numlock = "enabled";
            xkb_variant = "bepo";
          };
        };

        startup = [
          { command = lib.getExe pkgs.firefox-devedition; }
          { command = lib.getExe pkgs.thunderbird; }
          { command = lib.getExe pkgs.signal-desktop; }
          { command = lib.getExe pkgs.zeal; }
          { command = lib.getExe pkgs.element-desktop-wayland; }
          { command = lib.getExe pkgs.waybar; }
        ];

      };
  };
}
