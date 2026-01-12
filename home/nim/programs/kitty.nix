{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.kitty = {
    enable = true;

    actionAliases = {
      "kitty_scrollback_nvim" =
        "kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py";
    };

    keybindings = {
      "kitty_mod+a" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
      "kitty_mod+u" = "launch --location=vsplit --cwd=current";
      "kitty_mod+k" = "launch --location=hsplit --cwd=current";
      "kitty_mod+r" = "previous_window";
      "kitty_mod+t" = "next_window";
      "kitty_mod+," = "new_tab_with_cwd";
      "kitty_mod+h" = "previous_tab";
      "kitty_mod+g" = "next_tab";
      # "kitty_mod+p" = "show_scrollback";
      "kitty_mod+p" = "kitty_scrollback_nvim";
    };

    settings = {
      allow_remote_control = "socket-only";
      background_opacity = config.stylix.opacity.terminal;
      cursor_trail = "1";
      enable_audio_bell = false;
      enabled_layouts = "splits,fat,tall,grid,horizontal,vertical,stack";
      focus_follows_mouse = true;
      font_family = config.stylix.fonts.monospace.name;
      font_size = config.stylix.fonts.sizes.terminal;
      listen_on = "unix:\${HOME}/.kitty-remote";
      scrollback_pager_history_size = 2;
      shell = lib.getExe pkgs.fish;
      tab_bar_style = "powerline";
    };

    shellIntegration.mode = "enabled";
  };

}
