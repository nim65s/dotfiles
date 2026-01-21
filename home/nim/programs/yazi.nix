{
  lib,
  pkgs,
  ...
}:
{
  programs.yazi = {
    enable = lib.mkDefault true;
    initLua = ''
      require("git"):setup()
      require("starship"):setup()
    '';
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "+" ];
          run = "arrow next";
        }
        {
          on = [ "-" ];
          run = "arrow prev";
        }
        {
          on = [ "l" ];
          run = "plugin enter";
        }
      ];
    };
    plugins = {
      inherit (pkgs.yaziPlugins) git starship;
    };
    settings = {
      plugin.prepend_fetchers = [
        {
          id = "git";
          url = "*";
          run = "git";
        }
        {
          id = "git";
          url = "*/";
          run = "git";
        }
      ];
    };
  };
}
