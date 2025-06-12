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
      };
    };
    nur = {
      url = "github:nix-community/nur";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
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
      # ref. https://github.com/danth/stylix/issues/835
      url = "github:danth/stylix/b00c9f46ae6c27074d24d2db390f0ac5ebcc329f";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "clan-core/systems";
        flake-utils.follows = "flake-utils";
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
        catppuccin.patches = unpatchedInputs.nixpkgs.lib.fileset.toList ./patches/catppuccin/nix;
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
                permittedInsecurePackages = [ "squid-7.0.1" ]; # TODO
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
                  git-extras = prev.git-extras.overrideAttrs {
                    patches = [
                      ./patches/tj/git-extras/1177_support-github_token-var-for-git-fork-and-git-pull-request.patch
                    ];
                  };
                  nixpkgs-review = prev.nixpkgs-review.overrideAttrs {
                    patches = [
                      ./patches/Mic92/nixpkgs-review/501_add-github_token_cmd.patch
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
