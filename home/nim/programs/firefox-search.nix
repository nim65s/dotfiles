{
  pkgs,
  ...
}:
{
  programs.firefox = {
    profiles.nim = {
      search.engines = {
        "Amazon.fr".metaData.hidden = true;
        bing.metaData.hidden = true;
        google.metaData.alias = ":g";

        "Wikipedia".metaData.alias = ":w";

        "Arch Wiki" = {
          icon = "https://wiki.archlinux.org/favicon.ico";
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

        "AUR" = {
          icon = "https://wiki.archlinux.org/favicon.ico";
          definedAliases = [ ":aur" ];
          urls = [
            {
              template = "https://aur.archlinux.org/packages";
              params = [
                {
                  name = "K";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };

        "Crates.io" = {
          icon = "https://crates.io/assets/cargo.png";
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
          icon = "https://github.com/favicon.ico";
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
          icon = "https://gitlab.laas.fr/favicon.ico";
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
          icon = "https://www.laas.fr/static/img/favicon.ico";
          definedAliases = [ ":l" ];
          urls = [
            {
              template = "https://www.laas.fr/annuaire/";
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
          icon = "https://www.laas.fr/static/img/favicon.ico";
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

        "mojeek" = {
          icon = "https://www.mojeek.com/logos/icon_cc.svg";
          definedAliases = [ ":m" ];
          urls = [
            {
              template = "https://www.mojeek.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
                {
                  name = "theme";
                  value = "dark";
                }
                {
                  name = "qss";
                  value = "Ecosia,Google";
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

        "Nixpkgs" = {
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ ":np" ];
          urls = [
            {
              template = "https://github.com/search";
              params = [
                {
                  name = "q";
                  value = "repo:NixOS/nixpkgs {searchTerms}";
                }
              ];
            }
          ];
        };

        "Python" = {
          icon = "https://www.python.org/images/favicon16x16.ico";
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
          icon = "https://pypi.org/static/images/favicon.35549fe8.ico";
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
          icon = "https://doc.rust-lang.org/static.files/favicon-16x16-8b506e7a72182f1c.png";
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

        "Wikipedia" = {
          definedAliases = [ ":wp" ];
          urls = [
            {
              template = "https://fr.wikipedia.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
                {
                  name = "title";
                  value = "Special:Recherche";
                }
                {
                  name = "fulltext";
                  value = "1";
                }
                {
                  name = "ns0";
                  value = "1";
                }
              ];
            }
          ];
        };

        "WordReference - enfr" = {
          icon = "https://www.wordreference.com/favicon.ico";
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
          icon = "https://www.wordreference.com/favicon.ico";
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

        xkcd = {
          definedAliases = [ ":xkcd" ];
          urls = [
            {
              template = "https://xkcd.com/{searchTerms}";
            }
          ];
        };
      };
    };
  };
}
