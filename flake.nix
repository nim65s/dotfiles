{
  description = "My dotfiles";

  inputs = {
    # alloria.url = "github:nim65s/alloria";
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
    flake-input-patcher = {
      url = "github:jfly/flake-input-patcher";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "clan-core/systems";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "clan-core/systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        nuschtosSearch.follows = "nuschtosSearch";
        systems.follows = "clan-core/systems";
      };
    };
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nuschtosSearch = {
      url = "github:NuschtOS/search";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
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
        nixpkgs.follows = "nixpkgs";
        nur.follows = "nur";
        systems.follows = "clan-core/systems";
        flake-parts.follows = "flake-parts";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    unpatchedInputs:
    let
      patcher = unpatchedInputs.flake-input-patcher.lib.x86_64-linux;
      inputs = patcher.patch unpatchedInputs {
        nixpkgs.patches = unpatchedInputs.nixpkgs.lib.fileset.toList ./patches/NixOS/nixpkgs;
        nixvim.patches = unpatchedInputs.nixpkgs.lib.fileset.toList ./patches/nix-community/nixvim;
        home-manager.patches = unpatchedInputs.nixpkgs.lib.fileset.toList ./patches/nix-community/home-manager;
      };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, self, ... }:
      {
        imports = [
          inputs.clan-core.flakeModules.default
          inputs.treefmt-nix.flakeModule
        ];

        clan = {
          inventory = {
            instances = {
              admin = {
                roles.default = {
                  tags.all = { };
                };
              };
              mycelium = {
                roles.peer = {
                  tags.all = { };
                };
              };
              users = {
                roles.default = {
                  tags.all = { };
                  settings.user = "nim";
                };
              };
              users-fil = {
                module.name = "users";
                roles.default = {
                  machines.fix = { };
                  settings.user = "fil";
                };
              };
              users-martine = {
                module.name = "users";
                roles.default = {
                  machines.tipunch = { };
                  settings.user = "martine";
                };
              };
              users-mimi = {
                module.name = "users";
                roles.default = {
                  machines.hattori = { };
                  settings.user = "mimi";
                };
              };
              sshd = {
                roles.server = {
                  tags.all = { };
                };
              };
              wifi = {
                roles.default = {
                  machines.fix = { };
                  machines.hattori = { };
                  machines.tipunch = { };
                  machines.yupa = { };
                  settings.networks = {
                    antagnac = { };
                    azv = { };
                    baroustan = { };
                    bouys = { };
                    bsc = { };
                    healoria = { };
                    kekeno = { };
                    kessica = { };
                    laas_welcome.autoConnect = false;
                    lacroix = { };
                    lavelanet = { };
                    marsrovers = { };
                    picto_cne = { };
                    prades = { };
                    sabliere = { };
                    share_fil = { };
                    share_nim = { };
                    toffan = { };
                  };
                };
              };
              wifi-rovers = {
                module.name = "wifi";
                roles.default = {
                  machines.perseverance = { };
                  machines.zhurong = { };
                  settings.networks = {
                    azv = { };
                    marsrovers = { };
                  };
                };
              };
              wifi-laas = {
                module.name = "wifi";
                roles.default = {
                  machines.yupa = { };
                  settings.networks = {
                    eduroam_gsaurel.autoConnect = false;
                    laas_secure_gsaurel = { };
                  };
                };
              };
            };
          };
          meta.name = "nim65s";
          specialArgs = {
            inherit (inputs)
              catppuccin
              home-manager
              nixpkgs
              nixvim
              spicetify-nix
              stylix
              ;
            flake = self;
          };
        };
        perSystem =
          {
            inputs',
            pkgs,
            self',
            system,
            ...
          }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
              overlays = lib.attrValues self.overlays;
            };
            checks =
              let
                homes = lib.mapAttrs' (
                  n: v: lib.nameValuePair "hm-${n}" v.activationPackage
                ) self'.legacyPackages.homeConfigurations;
                nixos = lib.mapAttrs' (n: v: lib.nameValuePair "nixos-${n}" v.config.system.build.toplevel) (
                  lib.filterAttrs (n: _v: n != "ashitaka") self.nixosConfigurations
                );
                packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") self'.packages;
                shells = lib.mapAttrs' (n: lib.nameValuePair "shell-${n}") self'.devShells;
              in
              lib.filterAttrs (_n: v: v.meta.available && !v.meta.broken) (shells // homes // nixos // packages);
            devShells = {
              default = pkgs.mkShell {
                packages = [
                  self'.packages.clan-cli
                  pkgs.nix-fast-build
                ];
                CLAN_DIR = "/home/nim/dotfiles";
              };
            }
            // (
              let
                llvm = pkgs.llvmPackages_21;
                gcc = {
                  stdenv = pkgs.gcc15Stdenv;
                };
              in
              lib.mapAttrs (
                _n: v:
                (pkgs.mkShell.override { inherit (v) stdenv; }) {
                  packages = [
                    llvm.clang-tools
                    pkgs.cmake
                    pkgs.gdb
                    pkgs.gdbgui
                  ]
                  ++ lib.optionals v.stdenv.cc.isClang [ llvm.openmp ];
                }
              ) { inherit gcc llvm; }
            );
            legacyPackages.homeConfigurations =
              let
                homeConfiguration =
                  modules:
                  inputs.home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = {
                      inherit (inputs)
                        catppuccin
                        nixvim
                        spicetify-nix
                        stylix
                        ;
                    };
                    modules = [ ({ nixpkgs.overlays = lib.attrValues self.overlays; }) ] ++ modules;
                  };
              in
              {
                "gsaurel" = homeConfiguration [
                  ./modules/nim-home.nix
                  ./modules/lab.nix
                ];
                "gsaurel@upepesanke" = homeConfiguration [
                  ./homes/upepesanke/home.nix
                ];
              };

            packages = {
              inherit (pkgs)
                cmeel
                exif-diff
                git-fork-clone
                iosevka-aile
                iosevka-etoile
                iosevka-term
                nixook
                nurl
                pmapnitor
                pratches
                pre-commit-sort
                ;
              inherit (inputs'.home-manager.packages) home-manager;
              inherit (inputs'.clan-core.packages) clan-cli;
              nixvim = inputs'.nixvim.legacyPackages.makeNixvim (import modules/nixvim.nix);
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
        flake = {
          overlays = {
            default = import ./overlay.nix {
              inherit (inputs)
                catppuccin
                nixvim
                spicetify-nix
                stylix
                ;
            };
            nur = inputs.nur.overlays.default;
          };
        };
        systems = [ "x86_64-linux" ];
      }
    );
}
