{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my-i3 = lib.mkOption {
    type = lib.types.attrs;
    description = "my i3";
    default =
      let
        mod = "Mod4";
      in
      config.i3sway
      // {
        menu = "${lib.getExe pkgs.rofi} -show run";
        window.commands = [
          {
            command = "layout tabbed";
            criteria.class = "^Signal$";
          }
          {
            command = "layout tabbed";
            criteria.class = "^Element$";
          }
        ];
        assigns = {
          "9" = [ { class = "^Zeal$"; } ];
          "10" = [ { class = "^Firefox$"; } ];
          "11" = [ { class = "^thunderbird$"; } ];
          "12" = [
            { class = "^Signal$"; }
            { class = "^Element$"; }
          ];
        };
        bars = [
          {
            fonts.names = [ "SauceCodePro Nerd Font" ];
            fonts.size = 8.0;
            statusCommand = "${lib.getExe pkgs.i3status-rust} config-default.toml";
          }
        ];
        keybindings = config.i3sway.keybindings // {
          "${mod}+i" = ''exec "${lib.getExe pkgs.rofi} -show run"'';

          "${mod}+e" = ''exec "${lib.getExe pkgs.rofi-rbw} --typer xdotool --clipboarder xclip"'';
          "${mod}+x" = ''exec "${lib.getExe pkgs.i3lock}"'';

          "${mod}+Shift+p" = ''exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? ' -b 'Yes' 'i3-msg exit'"'';
        };

        startup = [
          { command = lib.getExe pkgs.firefox-devedition; }
          { command = lib.getExe pkgs.thunderbird; }
          { command = lib.getExe pkgs.signal-desktop; }
          { command = lib.getExe pkgs.zeal; }
          { command = lib.getExe pkgs.element-desktop; }
          { command = "setxkbmap -synch"; }
          { command = "${lib.getExe pkgs.nitrogen} --restore"; }
        ];

      };
  };
}
