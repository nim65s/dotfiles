{
  description = "My dotfiles";

  inputs = {
    catppuccin.url = "github:catppuccin/nix";
    clan-core = {
      url = "git+https://git.clan.lol/clan/clan-core";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    fork-manager = {
      url = "github:nim65s/fork-manager";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neverest = {
      url = "github:pimalaya/neverest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
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
      };
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
        debug = true;
        clan = {
          machines = {
            #fix = {
            #imports = [
            #./common/nixos.nix
            #./machines/fix/configuration.nix
            #];
            #};
            #hattorian = {
            #imports = [
            #./common/nixos.nix
            #./machines/hattorian/configuration.nix
            #];
            #};
            hattori.imports = [
              ./nixos
              ./nixos/disko.nix
            ];
            loon.imports = [
              ./nixos
            ];
          };
          meta.name = "nim65s";
          specialArgs = {
            inherit inputs;
            inherit (self) allSystems;
          };
        };
        perSystem =
          { pkgs, system, ... }:
          {
            _module.args.pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
              overlays = [
                (final: prev: {
                  nur = import inputs.nur {
                    nurpkgs = prev;
                    pkgs = prev;
                  };
                  inherit (inputs.clan-core.packages.${system}) clan-cli;
                  inherit (inputs.fork-manager.packages.${system}) fork-manager;
                  inherit (inputs.pre-commit-sort.packages.${system}) pre-commit-sort;
                  sway = final.nur.repos.nim65s.sway-lone-titlebar;
                  neverest = inputs.neverest.packages.${system}.default;
                })
              ];
            };
            devShells.default = pkgs.mkShell { packages = [ inputs.clan-core.packages.${system}.clan-cli ]; };
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
          homeConfigurations = {
            "gsaurel@asahi" = inputs.home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              extraSpecialArgs = {
                inherit (inputs) nixgl;
              };
              modules = [
                ./home-manager
                ./machines/asahi/home.nix
              ];
            };
            "gsaurel@upepesanke" = inputs.home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              extraSpecialArgs = {
                inherit (inputs) nixgl;
              };
              modules = [
                ./home-manager
                ./machines/upepesanke/home.nix
              ];
            };
            "nim@yupa" = inputs.home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              extraSpecialArgs = {
                inherit (inputs) nixgl;
              };
              modules = [
                ./home-manager
                ./machines/yupa/home.nix
              ];
            };
          };
        };
        imports = [
          inputs.clan-core.flakeModules.default
          inputs.treefmt-nix.flakeModule
        ];
        systems = inputs.nixpkgs.lib.systems.flakeExposed;
      }
    );
}
