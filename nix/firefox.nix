pkgs: {
  enable = true;
  package = pkgs.firefox-devedition;
  profiles.nim = {
    id = 0;
    name = "dev-edition-default";
    path = "nim.dev-edition-default";
    isDefault = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      bitwarden
      switchyomega
      tree-style-tab
      ublock-origin
      user-agent-string-switcher
    ];
    search.force = true;
    search.default = "DuckDuckGo";
    search.engines = {
      "Amazon.fr".metaData.hidden = true;
      "Bing".metaData.hidden = true;
      "Google".metaData.alias = ":g";
      "Wikipedia".metaData.alias = ":w";
      "Arch Wiki" = {
        iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
        definedAliases = [ ":a" ];
        urls = [
          {
            template = "https://wiki.archlinux.org/index.php";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Crates.io" = {
        iconUpdateURL = "https://crates.io/assets/cargo.png";
        definedAliases = [ ":c" ];
        urls = [
          {
            template = "https://crates.io/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Github" = {
        iconUpdateURL = "https://github.com/favicon.ico";
        definedAliases = [ ":gh" ];
        urls = [
          {
            template = "https://github.com/search";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Gitlab" = {
        iconUpdateURL = "https://gitlab.laas.fr/favicon.ico";
        definedAliases = [ ":gl" ];
        urls = [
          {
            template = "https://gitlab.laas.fr/search";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "LAAS Annuaire" = {
        iconUpdateURL = "https://www.laas.fr/static/img/favicon.ico";
        definedAliases = [ ":l" ];
        urls = [
          {
            template = "https://www.laas.fr/fr/annuaire/";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "LAAS Search" = {
        iconUpdateURL = "https://www.laas.fr/static/img/favicon.ico";
        definedAliases = [ ":ls" ];
        urls = [
          {
            template = "https://www.laas.fr/fr/search/";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Nix Packages" = {
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ ":n" ];
        urls = [
          {
            template = "https://search.nixos.org/packages";
            params = [
              {
                name = "type";
                value = "packages";
              }
              {
                name = "query";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Nix Wiki" = {
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ ":nw" ];
        urls = [
          {
            template = "https://wiki.nixos.org/w/index.php";
            params = [
              {
                name = "title";
                value = "Special:Search";
              }
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Python" = {
        iconUpdateURL = "https://www.python.org/images/favicon16x16.ico";
        definedAliases = [ ":p" ];
        urls = [
          {
            template = "https://docs.python.org/3.11/search.html";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "PyPI" = {
        iconUpdateURL = "https://pypi.org/static/images/favicon.35549fe8.ico";
        definedAliases = [ ":pp" ];
        urls = [
          {
            template = "https://pypi.org/search/";
            params = [
              {
                name = "q";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "Rust" = {
        iconUpdateURL = "https://doc.rust-lang.org/static.files/favicon-16x16-8b506e7a72182f1c.png";
        definedAliases = [ ":r" ];
        urls = [
          {
            template = "https://doc.rust-lang.org/std/";
            params = [
              {
                name = "search";
                value = "{searchTerms}";
              }
            ];
          }
        ];
      };
      "WordReference - enfr" = {
        iconUpdateURL = "https://www.wordreference.com/favicon.ico";
        definedAliases = [ ":enfr" ];
        urls = [
          {
            template = "https://www.wordreference.com/redirect/translation.aspx";
            params = [
              {
                name = "w";
                value = "{searchTerms}";
              }
              {
                name = "dict";
                value = "enfr";
              }
            ];
          }
        ];
      };
      "WordReference - fren" = {
        iconUpdateURL = "https://www.wordreference.com/favicon.ico";
        definedAliases = [ ":fren" ];
        urls = [
          {
            template = "https://www.wordreference.com/redirect/translation.aspx";
            params = [
              {
                name = "w";
                value = "{searchTerms}";
              }
              {
                name = "dict";
                value = "fren";
              }
            ];
          }
        ];
      };
    };
    settings = {
      "browser.theme.content-theme" = 0;
      "browser.theme.toolbar-theme" = 0;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.urlbar.suggest.calculator" = true;
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      "font.name.monospace.x-western" = "SauceCodePro Nerd Font";
      "font.name.sans-serif.x-western" = "Source Sans 3";
      "font.name.serif.x-western" = "Source Serif 4";
      "font.size.variable.x-western" = 12;
      #"layers.acceleration.disabled" = true;  # TODO
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
}
