{
  description = "My dotfiles";

  inputs = {
    alloria.url = "github:nim65s/alloria";
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
    cmeel = {
      url = "github:cmake-wheel/cmeel";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
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
      { self, ... }:
      {
        imports = [
          inputs.clan-core.flakeModules.default
          inputs.treefmt-nix.flakeModule
        ];

        debug = true;
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
            inherit inputs;
            inherit (self) allSystems;
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
                # permittedInsecurePackages = [ "squid-7.0.1" ]; # TODO
              };
              overlays = [
                (_final: prev: {
                  nur = import inputs.nur {
                    nurpkgs = prev;
                    pkgs = prev;
                  };
                  inherit (inputs'.cmeel.packages) cmeel;
                  inherit (inputs'.pre-commit-sort.packages) pre-commit-sort;
                  inherit (self'.packages)
                    clan-cli
                    git-fork-clone
                    exif-diff
                    iosevka-aile
                    iosevka-etoile
                    iosevka-term
                    nixook
                    nixvim
                    pmapnitor
                    pratches
                    ;
                  arsenik = prev.arsenik.overrideAttrs {
                    patches = [ ./patches/OneDeadKey/arsenik/77_kanata-numpad-add-operators.patch ];
                  };
                  nurl = prev.nurl.overrideAttrs {
                    patches = [
                      ./patches/nix-community/nurl/388_feat-use-a-github-token-for-authorization-if-it-exists.patch
                    ];
                  };
                  spicetify-extensions = inputs'.spicetify-nix.legacyPackages.extensions;
                })
              ];
            };
            devShells = {
              default = pkgs.mkShell {
                packages = [
                  self'.packages.clan-cli
                  # self'.packages.home-manager
                  pkgs.lix
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
              inherit (pkgs) nurl;
              inherit (inputs'.home-manager.packages) home-manager;
              # inherit (inputs'.clan-core.packages) clan-cli;
              clan-cli = inputs'.clan-core.packages.clan-cli.override {
                includedRuntimeDeps = [
                  "age"
                  "git"
                  "nix"
                ];
              };
              git-fork-clone = pkgs.writeShellApplication {
                name = "git-fork-clone";
                runtimeInputs = [ (pkgs.python3.withPackages (p: [ p.PyGithub ])) ];
                text = ''
                  python ${./bin/git-fork-clone.py} "$@"
                '';
              };
              exif-diff = pkgs.writeShellApplication {
                name = "exif-diff";
                runtimeInputs = [
                  pkgs.exiftool
                  pkgs.gnugrep
                ];
                text = ''
                  exiftool -sort "$1" | grep -v 'File Name\|Directory\|Date/Time\|Permissions'
                '';
              };
              iosevka-aile = pkgs.iosevka-bin.override { variant = "Aile"; };
              iosevka-etoile = pkgs.iosevka-bin.override { variant = "Etoile"; };
              iosevka-term = pkgs.nerd-fonts.iosevka;
              nixook = pkgs.writeShellApplication {
                name = "nixook";
                text = ''
                  cd "$(git rev-parse --git-dir)"
                  (
                    echo '#! ${pkgs.runtimeShell}'
                    echo 'set -eux'
                    echo 'nix fmt'
                    echo 'git diff --quiet'
                    if test -f ../.pre-commit-config.yaml
                    then echo 'pre-commit run -a'
                    fi
                  ) > hooks/pre-commit
                  chmod +x hooks/pre-commit
                  (
                    echo '#! ${pkgs.runtimeShell}'
                    echo 'set -eux'
                    echo 'nix flake check -L'
                  ) > hooks/pre-push
                  chmod +x hooks/pre-push
                '';
              };
              nixvim = inputs'.nixvim.legacyPackages.makeNixvim (import modules/nixvim.nix);
              pmapnitor = pkgs.writeShellApplication {
                name = "pmapnitor";
                runtimeInputs = [ pkgs.python3 ];
                text = ''
                  python ${./bin/pmapnitor.py} "$@"
                '';
              };
              pratches = pkgs.writeShellApplication {
                name = "pratches";
                runtimeInputs = [ (pkgs.python3.withPackages (p: [ p.httpx ])) ];
                text = ''
                  python ${./bin/pratches.py} "$@"
                '';
              };
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
            pkgs = self.allSystems.${system}._module.args.pkgs;
          in
          {
            homeConfigurations = {
              #"gsaurel@asahi" = inputs.home-manager.lib.homeManagerConfiguration {
              #  inherit (self.allSystems.${system}._module.args) pkgs;
              #  modules = [
              #    inputs.catppuccin.homeModules.catppuccin
              #    inputs.stylix.homeManagerModules.stylix
              #    ./aliens/asahi/home.nix
              #    ./home-manager
              #  ];
              #};
              "gsaurel" = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [
                  ./modules/nim-home.nix
                  ./modules/lab.nix
                ];
              };
              "gsaurel@upepesanke" = inputs.home-manager.lib.homeManagerConfiguration {
                inherit pkgs;
                extraSpecialArgs = { inherit inputs; };
                modules = [ ./homes/upepesanke/home.nix ];
              };
            };
          };
        systems = [ "x86_64-linux" ];
      }
    );
}
