{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-sort = {
      url = "github:nim65s/pre-commit-sort";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      pre-commit-sort,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        localSystem = system;
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
    in
    {
      homeConfigurations = {
        "gsaurel@asahi" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/asahi/home.nix ];
        };
        "gsaurel@upepesanke" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/upepesanke/home.nix ];
        };
        "nim@yupa" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./nix/yupa/home.nix ];
        };
      };
      nixosConfigurations = {
        fix = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nix/fix/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/fix/home.nix;
            }
          ];
        };
        loon = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./nix/loon/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/loon/home.nix;
            }
          ];
        };
        hattorixos = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          modules = [
            ./nix/hattorixos/configuration.nix
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users.nim = import ./nix/loon/home.nix; # follow loon cfg
            }
          ];
        };
      };
    };
}
