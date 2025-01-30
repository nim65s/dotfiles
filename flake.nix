{
  description = "My dotfiles";

  inputs = {
    catppuccin = {
      url = "github:catppuccin/nix";
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
    patch-jrk = {
      url = "https://github.com/NixOS/nixpkgs/pull/362957.patch";
      flake = false;
    };
    pre-commit-sort = {
      url = "github:nim65s/pre-commit-sort";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
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
          machines = {
            loon.imports = [
              ./nixos
            ];
          };
          meta.name = "nim65s";
          inventory.services.mycelium.default = {
            roles.peer.machines = [
              "ashitaka"
              "hattori"
              "perseverance"
              "yupa"
            ];
            config = {
              topLevelDomain = "m";
              openFirewall = true;
            };
          };
          specialArgs = {
            inherit inputs;
            inherit (self) allSystems;
            inherit (inputs) home-manager stylix;
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
            _module.args.pkgs =
              let
                supernix = import inputs.nixpkgs { inherit system; };
              in
              import
                (supernix.applyPatches {
                  name = "patched nixpkgs";
                  src = inputs.nixpkgs;
                  patches = [
                    inputs.patch-jrk
                  ];
                })
                {
                  inherit system;
                  config.allowUnfree = true;
                  overlays = [
                    (final: prev: {
                      nur = import inputs.nur {
                        nurpkgs = prev;
                        pkgs = prev;
                      };
                      inherit (inputs.clan-core.packages.${system}) clan-cli;
                      inherit (inputs.pre-commit-sort.packages.${system}) pre-commit-sort;
                      inherit (self'.packages) iosevka-aile iosevka-etoile iosevka-term;
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
                  inputs.clan-core.packages.${system}.clan-cli
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
