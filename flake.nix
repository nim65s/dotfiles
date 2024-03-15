{
  description = "My dotfiles";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nim65s-dotfiles.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nim65s-dotfiles.cachix.org-1:6vuY5z8YGzfjrssfcxb3DuH50DC1l562U0BIGMxnClg="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/nur";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        localSystem = system;
        config.allowUnfree = true;
        overlays = [
          (import ./nix/overlays.nix)
          (final: prev: {
            nur = import nur {
              nurpkgs = prev;
              pkgs = prev;
            };
          })
        ];
      };
    in
    {
      homeConfigurations = {
        gsaurel = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./nix/upepesanke/home.nix
          ];
        };
        nim = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./nix/yupa/home.nix
          ];
        };
      };
      nixosConfigurations = {
        loon = nixpkgs.lib.nixosSystem {
          inherit pkgs;
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
              home-manager.users.nim = import ./nix/loon/home.nix;  # follow loon cfg
            }
          ];
        };
      };
    };
}
