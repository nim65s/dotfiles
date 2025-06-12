{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = "Mod4";
in
{
  xsession = {
    enable = true;
    numlock.enable = true;
    windowManager.i3 = {
      enable = true;
      config = config.i3sway // {
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
            statusCommand = "${lib.getExe pkgs.i3status-rust} config-default.toml";
          }
        ];
        keybindings = config.i3sway.keybindings // {
          "${mod}+i" = ''exec "${lib.getExe pkgs.rofi} -show run"'';

          "${mod}+e" = ''exec "${lib.getExe pkgs.rofi-rbw} --typer xdotool --clipboarder xclip"'';
          "${mod}+x" = ''exec "${lib.getExe pkgs.i3lock}"'';

          "${mod}+Shift+p" =
            ''exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? ' -b 'Yes' 'i3-msg exit'"'';
        };

        startup = [
          { command = lib.getExe config.programs.firefox.finalPackage; }
          { command = lib.getExe pkgs.thunderbird; }
          { command = lib.getExe pkgs.signal-desktop; }
          { command = lib.getExe pkgs.zeal; }
          { command = lib.getExe config.programs.element-desktop.package; }
          { command = "setxkbmap -synch"; }
          { command = "${lib.getExe pkgs.nitrogen} --restore"; }
        ];

      };

    };
  };
}
