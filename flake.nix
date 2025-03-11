{
  description = "My dotfiles";

  inputs = {
    catppuccin = {
      url = "github:catppuccin/nix/refs/pull/480/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    clan-core = {
      url = "https://git.clan.lol/clan/clan-core/archive/main.tar.gz";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    cmeel = {
      url = "github:cmake-wheel/cmeel";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    patch-arsenik = {
      url = "https://github.com/NixOS/nixpkgs/pull/386205.patch";
      flake = false;
    };
    patch-arsenik-src = {
      url = "https://github.com/nim65s/arsenik/commit/20f0342339f151dc1dad55e48d79c8f5e46b01b0.patch";
      flake = false;
    };
    patch-firefox = {
      url = "https://github.com/NixOS/nixpkgs/pull/387931.patch";
      flake = false;
    };
    patch-jrk = {
      url = "https://github.com/NixOS/nixpkgs/pull/362957.patch";
      flake = false;
    };
    patch-rofimoji = {
      url = "https://github.com/NixOS/nixpkgs/pull/388852.patch";
      flake = false;
    };
    pre-commit-sort = {
      url = "github:nim65s/pre-commit-sort";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "clan-core/systems";
      };
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "clan-core/systems";
      };
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      pkgsForPatching = import inputs.nixpkgs { system = "x86_64-linux"; };
      patchedNixpkgs = (
        pkgsForPatching.applyPatches {
          name = "patched nixpkgs";
          src = inputs.nixpkgs;
          patches = [
            inputs.patch-arsenik
            inputs.patch-firefox
            inputs.patch-jrk
            inputs.patch-rofimoji
          ];
        }
      );
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        imports = [
          inputs.clan-core.flakeModules.default
          inputs.treefmt-nix.flakeModule
        ];

        debug = true;
        clan = {
          directory = self;
          /*
            machines = {
              loon.imports = [
                ./nixos
              ];
              };
          */
          meta.name = "nim65s";
          specialArgs = {
            inherit inputs patchedNixpkgs;
            inherit (self) allSystems;
          };
        };
        perSystem =
          {
            pkgs,
            self',
            system,
            ...
          }:
          {
            _module.args.pkgs = import patchedNixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                (final: prev: {
                  nur = import inputs.nur {
                    nurpkgs = prev;
                    pkgs = prev;
                  };
                  inherit (inputs.cmeel.packages.${system}) cmeel;
                  inherit (inputs.pre-commit-sort.packages.${system}) pre-commit-sort;
                  inherit (self'.packages)
                    clan-cli
                    iosevka-aile
                    iosevka-etoile
                    iosevka-term
                    ;
                  arsenik = prev.arsenik.overrideAttrs {
                    patches = [ inputs.patch-arsenik-src ];
                  };
                  element-web = prev.element-web.override {
                    conf = {
                      setting_defaults = {
                        custom_themes = [
                          (final.lib.importJSON "${
                            pkgs.catppuccin.override { variant = "mocha"; }
                          }/element/Catppuccin-mocha.json")
                        ];
                      };
                    };
                  };
                  git-extras = prev.git-extras.overrideAttrs {
                    patches = [
                      # Allow use of GITHUB_TOKEN
                      (final.fetchpatch {
                        url = "https://github.com/nim65s/git-extras/commit/efbf3e5ba94cfd385c9ec7ad8ff5b1ad69925e3f.patch";
                        hash = "sha256-ZkgCx7ChwoBzvnOWaR9Q4soHfAGObxrbmeUC6XZnUCA=";
                      })
                    ];
                  };
                })
              ];
            };
            devShells = {
              default = pkgs.mkShell {
                packages = [
                  self'.packages.clan-cli
                  inputs.system-manager.packages.${system}.system-manager
                ];
                CLAN_DIR = "/home/nim/dotfiles";
              };
              cpp = pkgs.mkShell {
                packages = with pkgs; [
                  clang_19
                  clang-tools
                  gdb
                  gdbgui
                  llvmPackages_17.openmp
                ];
              };
            };
            packages = {
              clan-cli = inputs.clan-core.packages.${system}.clan-cli.override {
                includedRuntimeDeps = [
                  "age"
                  "git"
                  "nix"
                ];
              };
              iosevka-aile = pkgs.iosevka-bin.override { variant = "Aile"; };
              iosevka-etoile = pkgs.iosevka-bin.override { variant = "Etoile"; };
              iosevka-term = pkgs.nerd-fonts.iosevka;
            };
            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                deadnix.enable = true;
                mdformat.enable = true;
                nixfmt.enable = true;
                ruff = {
                  check = true;
                  format = true;
                };
                rustfmt.enable = true;
                yamlfmt.enable = true;
              };
            };
          };
        flake =
          let
            system = "x86_64-linux";
          in
          {
            homeConfigurations = {
              "gsaurel@asahi" = inputs.home-manager.lib.homeManagerConfiguration {
                inherit (self.allSystems.${system}._module.args) pkgs;
                modules = [
                  inputs.catppuccin.homeManagerModules.catppuccin
                  inputs.stylix.homeManagerModules.stylix
                  ./aliens/asahi/home.nix
                  ./home-manager
                ];
              };
              "gsaurel@upepesanke" = inputs.home-manager.lib.homeManagerConfiguration {
                inherit (self.allSystems.${system}._module.args) pkgs;
                modules = [
                  inputs.catppuccin.homeManagerModules.catppuccin
                  inputs.stylix.homeManagerModules.stylix
                  ./aliens/upepesanke/home.nix
                  ./home-manager
                ];
              };
            };
            systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
              modules = [
                inputs.nix-system-graphics.systemModules.default
                {
                  config = {
                    nixpkgs.hostPlatform = system;
                    system-graphics.enable = true;
                  };
                }
              ];
            };
          };
        systems = [ "x86_64-linux" ];
      }
    );
}
