{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs = {
    bacon.settings.keybindings = {
      s = "scroll-lines(-1)";
      t = "scroll-lines(1)";
    };

    bat.config.pager = "less";

    fish = {
      interactiveShellInit = ''
        test -f ~/dotfiles/.config/fish/config.fish
        and source ~/dotfiles/.config/fish/config.fish
      '';
      loginShellInit = ''
        test -f ~/dotfiles/.config/fish/path.fish
        and source ~/dotfiles/.config/fish/path.fish

        if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
          #${lib.getExe config.wayland.windowManager.sway.package} > ~/.wayland.log 2> ~/.wayland.err
          #${pkgs.niri}/bin/niri-session
        end
      '';
    };

    i3status-rust = {
      enable = true;
      bars.default = {
        icons = "awesome6";
        #theme = "gruvbox-dark";
        blocks = [
          { block = "music"; }
          { block = "net"; }
          {
            alert = 10.0;
            block = "disk_space";
            format = " $icon root: $available.eng(w:2) ";
            info_type = "available";
            interval = 20;
            path = "/";
            warning = 20.0;
          }
          { block = "memory"; }
          { block = "cpu"; }
          {
            block = "sound";
            click = [
              {
                button = "left";
                cmd = "pwvucontrol";
              }
            ];
          }
          { block = "battery"; }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%Y-%m-%d %H:%M') ";
            interval = 60;
          }
        ];
      };
    };

    kitty = {
      enable = true;
      keybindings = {
        "kitty_mod+left" = "resize_window narrower";
        "kitty_mod+right" = "resize_window wider";
        "kitty_mod+up" = "resize_window taller";
        "kitty_mod+down" = "resize_window shorter";
        "alt+n" = "launch --location=split --cwd=current";
        "alt+m" = "launch --location=hsplit --cwd=current";
        "alt+z" = "launch --location=vsplit --cwd=current";
        "kitty_mod+n" = "new_os_window_with_cwd";
        "alt+t" = "next_window";
        "alt+s" = "previous_window";
        "alt+shift+t" = "move_window_forward";
        "alt+shift+s" = "move_window_backward";
        "alt+shift+d" = "detach_window";
        "alt+l" = "next_tab";
        "alt+v" = "previous_tab";
        "alt+d" = "new_tab_with_cwd";
        "alt+plus" = "layout_action increase_num_full_size_windows";
        "alt+minus" = "layout_action decrease_num_full_size_windows";
        "kitty_mod+plus" = "change_font_size all +1.0";
        "kitty_mod+minus" = "change_font_size all -1.0";
      };
      settings = {
        touch_scroll_multiplier = "10.0";
        focus_follows_mouse = true;
        enable_audio_bell = false;
        enabled_layouts = "splits,fat,tall,grid,horizontal,vertical,stack";
        placement_strategy = "top-left";
        tab_bar_style = "powerline";
        tab_separator = " | ";
        #background_opacity = "0.7";
        shell = "${lib.getExe pkgs.fish}";
        scrollback_lines = 10000;
      };
    };

    zathura = {
      mappings = {
        s = "reload";
        r = "navigate next";
        t = "navigate previous";
        h = "zoom in";
        g = "zoom out";
        q = "quit";
        n = "rotate";
      };
    };
  };
}
