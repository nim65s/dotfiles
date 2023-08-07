pkgs:
{
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
    ];
    search.force = true;
    search.default = "DuckDuckGo";
    search.engines = {
      "Amazon.fr".metaData.hidden = true;
      "Bing".metaData.hidden = true;
      "Google".metaData.alias = ":g";
      "Wikipedia (en)".metaData.alias = ":w";
      "Arch Wiki" = {
        iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
        definedAliases = [ ":a" ];
        urls = [{
          template = "https://wiki.archlinux.org/index.php";
          params = [
            { name = "search"; value = "{searchTerms}"; }
          ];
        }];
      };
      "Crates.io" = {
        iconUpdateURL = "https://crates.io/assets/cargo.png";
        definedAliases = [ ":c" ];
        urls = [{
          template = "https://crates.io/search";
          params = [
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
      };
      "Github" = {
        iconUpdateURL = "https://github.com/favicon.ico";
        definedAliases = [ ":gh" ];
        urls = [{
          template = "https://github.com/search";
          params = [
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
      };
      "Gitlab" = {
        iconUpdateURL = "https://gitlab.laas.fr/favicon.ico";
        definedAliases = [ ":gl" ];
        urls = [{
          template = "https://gitlab.laas.fr/search";
          params = [
            { name = "search"; value = "{searchTerms}"; }
          ];
        }];
      };
      "Nix Packages" = {
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ ":n" ];
        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "type"; value = "packages"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
      };
      "Python" = {
        iconUpdateURL = "https://www.python.org/images/favicon16x16.ico";
        definedAliases = [ ":p" ];
        urls = [{
          template = "https://docs.python.org/3.11/search.html";
          params = [
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
      };
      "PyPI" = {
        iconUpdateURL = "https://pypi.org/static/images/favicon.35549fe8.ico";
        definedAliases = [ ":pp" ];
        urls = [{
          template = "https://pypi.org/search/";
          params = [
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
      };
      "Rust" = {
        iconUpdateURL = "https://doc.rust-lang.org/static.files/favicon-16x16-8b506e7a72182f1c.png";
        definedAliases = [ ":r" ];
        urls = [{
          template = "https://doc.rust-lang.org/std/";
          params = [
            { name = "search"; value = "{searchTerms}"; }
          ];
        }];
      };
      "WordReference - enfr" = {
        iconUpdateURL = "https://www.wordreference.com/favicon.ico";
        definedAliases = [ ":enfr" ];
        urls = [{
          template = "https://www.wordreference.com/redirect/translation.aspx";
          params = [
            { name = "w"; value = "{searchTerms}"; }
            { name = "dict"; value = "enfr"; }
          ];
        }];
      };
      "WordReference - fren" = {
        iconUpdateURL = "https://www.wordreference.com/favicon.ico";
        definedAliases = [ ":fren" ];
        urls = [{
          template = "https://www.wordreference.com/redirect/translation.aspx";
          params = [
            { name = "w"; value = "{searchTerms}"; }
            { name = "dict"; value = "fren"; }
          ];
        }];
      };
    };
    settings = {
     "browser.toolbars.bookmarks.visibility" = "never";
     "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
