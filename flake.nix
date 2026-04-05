{
  description = "My dotfiles";

  inputs = {
    # alloria.url = "github:nim65s/alloria";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    clan-core = {
      url = "https://git.clan.lol/nim65s/clan-core/archive/harmonia.tar.gz";
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
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "clan-core/systems";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-ros.follows = "nix-ros-overlay/nixpkgs";
    nix-ros-overlay = {
      url = "github:lopsided98/nix-ros-overlay/develop";
      inputs = {
        flake-utils.follows = "flake-utils";
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
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
    uboot-bpi-r4 = {
      url = "github:K900/u-boot/bpi-r4";
      flake = false;
    };
    linux-bpi-r4 = {
      url = "github:K900/linux/bpi-r4-618";
      flake = false;
    };
  };

  outputs =
    inputs:
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
              # mycelium = {
              #   roles.peer = {
              #     tags.all = { };
              #   };
              # };
              harmonia = {
                roles.server = {
                  machines.ashitaka = { };
                };
                roles.client = {
                  tags.all = { };
                };
              };
              users-root = {
                module.name = "users";
                roles.default = {
                  tags.all = { };
                  settings.user = "root";
                };
              };
              users-doud = {
                module.name = "users";
                roles.default = {
                  machines.solarium = { };
                  settings.user = "doud";
                };
              };
              users-nim = {
                module.name = "users";
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
                roles.client = {
                  settings.certificate.searchDomains = [
                    "azv"
                    "w"
                  ];
                  tags.all = { };
                };
                roles.server = {
                  settings.certificate.searchDomains = [
                    "azv"
                    "w"
                  ];
                  settings.authorizedKeys = {
                    "upe" =
                      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBbE5nRZpgFdZJgC+hTzdyYLxKUBY59WFYOQ/O1oxwc gsaurel@upepesanke";
                    "ashitaka" =
                      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlKH10l4IazTlC2UC0HV44iw/p7w7ufxaOk7VLX9vTG nim@ashitaka";
                    "yupa" =
                      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPWyZK9yJEyY7DqxN+A2h4+LccOoZGt2OdWEYvwzXzT nim@yupa";
                    "sk1" =
                      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIOwQHhg10BZUogtkz+MlOsnmQER2Kkf9YjL3taOcNtbJAAAABHNzaDo= nim@sk1";
                  };
                  tags.all = { };
                };
              };
              wifi = {
                roles.default = {
                  machines.fix = { };
                  machines.hattori = { };
                  machines.solarium = { };
                  machines.tipunch = { };
                  machines.yupa = { };
                  settings.networks = {
                    antagnac = { };
                    azv = { };
                    azvfp = { };
                    baroustan.keyMgmt = "sae";
                    bouys = { };
                    bsc = { };
                    healoria = { };
                    kekeno = { };
                    kessica = { };
                    laas_welcome.autoConnect = false;
                    lacroix = { };
                    lavelanet = { };
                    marsrovers = { };
                    neofarm = { };
                    perseverance = { };
                    picto_cne = { };
                    prades = { };
                    sabliere = { };
                    share_fil = { };
                    share_nim = { };
                    toffan = { };
                    zhurong = { };
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
              w = {
                module.name = "wireguard";
                module.input = "clan-core";
                roles.controller.machines = {
                  calcifer.settings.endpoint = "w.saurel.me";
                };
                roles.peer.machines = {
                  ashitaka = { };
                  bpi-r4 = { };
                  fix = { };
                  hattori = { };
                  healoriaspi = { };
                  perseverance = { };
                  solarium = { };
                  spare = { };
                  tipunch = { };
                  yupa = { };
                  zhurong = { };
                };
              };
            };
          };
          meta = {
            name = "nim65s";
            domain = "w";
          };
          specialArgs = {
            inherit (inputs)
              catppuccin
              home-manager
              nixpkgs
              nixvim
              stylix
              linux-bpi-r4
              uboot-bpi-r4
              ;
            pkgsHost = import inputs.nixpkgs {
              # system = builtins.hostSystem;
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
              };
              overlays = lib.attrValues self.overlays;
            };
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
                  lib.filterAttrs (_n: v: v.pkgs.stdenv.hostPlatform.system == system) self.nixosConfigurations
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
                        stylix
                        ;
                    };
                    modules = [ { nixpkgs.overlays = lib.attrValues self.overlays; } ] ++ modules;
                  };
              in
              {
                "gsaurel" = homeConfiguration [
                  ./home/nim/main.nix
                  ./home/nim/lab.nix
                ];
                "gsaurel@upepesanke" = homeConfiguration [
                  ./home/nim/upepesanke
                ];
              };

            packages = {
              inherit (pkgs)
                cmeel
                dockgen
                exif-diff
                git-fork-clone
                git-objects-cache
                iosevka-aile
                iosevka-etoile
                iosevka-term
                nixook
                nurl
                pmapnitor
                pratches
                pre-commit-sort
                tailstamp
                ;
              inherit (inputs'.home-manager.packages) home-manager;
              inherit (inputs'.clan-core.packages) clan-cli;
              nixvim = inputs'.nixvim.legacyPackages.makeNixvim (import shared/nixvim.nix { inherit lib; });
            };
            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                deadnix.enable = true;
                mdformat.enable = true;
                nixfmt.enable = true;
                nixf-diagnose.enable = true;
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
          inherit (inputs.nixpkgs) lib;
          overlays = {
            default = import ./overlay.nix {
              inherit (inputs)
                nixpkgs-ros
                nix-ros-overlay
                ;
            };
            nur = inputs.nur.overlays.default;
          };
        };
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
      }
    );
}
