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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    pre-commit-sort = {
      url = "github:nim65s/pre-commit-sort";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:nim65s/treefmt-nix"; # https://github.com/numtide/treefmt-nix/pull/224
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
                ./nix/fix/configuration.nix
                ./nix/x86_64-linux.nix
                ./nix/nixos.nix
                home-manager.nixosModules.home-manager
                { home-manager.users.nim = import ./nix/fix/home.nix; }
              ];
            };
            hattorian = {
              imports = [
                ./nix/hattorixos/configuration.nix
                ./nix/x86_64-linux.nix
                ./nix/nixos.nix
                home-manager.nixosModules.home-manager
                {
                  home-manager.users.nim = import ./nix/loon/home.nix; # follow loon cfg
                }
              ];
            };
            loon = {
              imports = [
                ./nix/loon/configuration.nix
                ./nix/x86_64-linux.nix
                ./nix/nixos.nix
                home-manager.nixosModules.home-manager
                { home-manager.users.nim = import ./nix/loon/home.nix; }
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
                  sway = final.nur.repos.nim65s.sway-lone-titlebar;
                  pre-commit-sort = inputs.pre-commit-sort.packages.${system}.default;
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
              modules = [ ./nix/asahi/home.nix ];
            };
            "gsaurel@upepesanke" = home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              modules = [ ./nix/upepesanke/home.nix ];
            };
            "nim@yupa" = home-manager.lib.homeManagerConfiguration {
              inherit (self.allSystems.x86_64-linux._module.args) pkgs;
              modules = [ ./nix/yupa/home.nix ];
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
