{
  description = "My dotfiles";

  inputs = {
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    pre-commit-sort = {
      url = "github:nim65s/pre-commit-sort";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { home-manager, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { self, ... }:
      {
        debug = true;
        clan = {
          machines = {
            fix = {
              imports = [
                ./machines/fix/configuration.nix
                ./common/x86_64-linux.nix
                ./common/nixos.nix
                home-manager.nixosModules.home-manager
              ];
            };
            hattorian = {
              imports = [
                ./machines/hattorixos/configuration.nix
                ./common/x86_64-linux.nix
                ./common/nixos.nix
                home-manager.nixosModules.home-manager
              ];
            };
            loon = {
              imports = [
                home-manager.nixosModules.home-manager
                ./common/x86_64-linux.nix
                ./common/nixos.nix
                ./common/nixgl.nix
                ./common/i3sway.nix
                ./common/my-i3.nix
                ./common/my-sway.nix
                ./common/my-home.nix
                ./common/my-programs.nix
                ./common/my-firefox.nix
                ./machines/loon/configuration.nix
              ];
            };
          };
          meta.name = "github.com/nim65s/dotfiles";
          specialArgs = {
            inherit inputs;
            inherit (self) allSystems;
          };
        };
        perSystem =
          { system, ... }:
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
                })
              ];
            };
            treefmt = {
              projectRootFile = "flake.nix";
              programs = {
                deadnix.enable = true;
                mdformat.enable = true;
                nixfmt-rfc-style.enable = true;
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
            "gsaurel@asahi" = home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              modules = [
                ./common/nixgl.nix
                ./common/i3sway.nix
                ./common/my-i3.nix
                ./common/my-sway.nix
                ./common/my-home.nix
                ./common/my-programs.nix
                ./common/my-firefox.nix
                ./machines/asahi/home.nix
              ];
            };
            "gsaurel@upepesanke" = home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              modules = [
                ./common/nixgl.nix
                ./common/i3sway.nix
                ./common/my-i3.nix
                ./common/my-sway.nix
                ./common/my-home.nix
                ./common/my-programs.nix
                ./common/my-firefox.nix
                ./machines/upepesanke/home.nix
              ];
            };
            "nim@yupa" = home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              modules = [
                ./common/nixgl.nix
                ./common/i3sway.nix
                ./common/my-i3.nix
                ./common/my-sway.nix
                ./common/my-home.nix
                ./common/my-programs.nix
                ./common/my-firefox.nix
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
