{
  pkgs,
  ...
}:
{
  imports = [ ./firefox-search.nix ];

  catppuccin.firefox.profiles.nim = {
    enable = true;
    force = true;
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition;
    languagePacks = [
      "fr"
      "en"
    ];
    profiles.nim = {
      id = 0;
      name = "dev-edition-default";
      path = "nim.dev-edition-default";
      isDefault = true;
      extensions.force = true;
      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        click-and-read
        firefox-color
        mergify
        stylus
        #switchyomega
        tree-style-tab
        ublock-origin
        user-agent-string-switcher
        violentmonkey
      ];
      search.force = true;
      search.default = "mojeek";

      settings = {
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.urlbar.suggest.calculator" = true;
        "font.name.monospace.x-western" = "Iosevka";
        "font.name.sans-serif.x-western" = "Iosevka-Aile";
        "font.name.serif.x-western" = "Iosevka-Etoile";
        "font.size.variable.x-western" = 12;
        "layers.acceleration.disabled" = true; # TODO
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "signon.rememberSignons" = false;
      };
      userChrome = ''
        #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar {
            opacity: 0;
            pointer-events: none;
            margin-bottom: -44px !important;
            }
        #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
            visibility: collapse !important;
            }
        #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
            display: none;
            }
      '';
    };
  };
}
