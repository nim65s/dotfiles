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
  };

  outputs =
    {
      clan-core,
      flake-parts,
      home-manager,
      nixpkgs,
      nur,
      pre-commit-sort,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } ({ self, ... }: {
      debug = true;
      clan = {
        machines = {
          fix = {
            imports = [
              ./nix/fix/configuration.nix
              nur.nixosModules.nur
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.nim = import ./nix/fix/home.nix;
              }
            ];
            nixpkgs = { inherit (self.allSystems.x86_64-linux._module.args) pkgs; };
          };
          hattorian = {
            imports = [
              ./nix/hattorixos/configuration.nix
              nur.nixosModules.nur
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.nim = import ./nix/loon/home.nix; # follow loon cfg
              }
            ];
          };
          loon = {
            imports = [
              ./nix/loon/configuration.nix
              nur.nixosModules.nur
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.users.nim = import ./nix/loon/home.nix;
              }
            ];
            nixpkgs = { inherit (self.allSystems.x86_64-linux._module.args) pkgs; };
          };
        };
        meta.name = "github.com/nim65s/dotfiles";
        specialArgs = { inherit inputs; };
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
        clan-core.flakeModules.default
      ];
      perSystem = { system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              nur = import nur {
                nurpkgs = prev;
                pkgs = prev;
              };
              sway = final.nur.repos.nim65s.sway-lone-titlebar;
              pre-commit-sort = pre-commit-sort.packages.${system}.default;
            })
          ];
        };
      };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    });
}
